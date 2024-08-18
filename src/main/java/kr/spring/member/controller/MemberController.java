package kr.spring.member.controller;

import java.io.IOException;
import java.io.InputStream;
import java.lang.ProcessBuilder.Redirect;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.spring.config.validation.ValidationSequence;
import kr.spring.config.validation.ValidationGroups.PatternCheckGroup;
import kr.spring.dbox.vo.DboxBudgetVO;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.member.service.EmailService;
import kr.spring.member.service.MemberOAuthService;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.EmailMessageVO;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.member.vo.UserInfo;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.util.AuthCheckException;
import kr.spring.util.PagingUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;

	@Autowired
	private MemberOAuthService memberOAuthService;

	@Autowired
	private RestTemplate restTemplate;

	@Autowired
	private EmailService emailService;

	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private NotifyService notifyService;
	
	//카카오 로그인 API 정보
	@Value("${kakao.client_id}")
	private String k_client_id;
	@Value("${kakao.redirect_uri}")
	private String k_redirect_uri;
	@Value("${kakao.client_secret}")
	private String k_client_secret;

	//네이버 로그인 API 정보
	@Value("${naver.client_id}")
	private String n_client_id;
	@Value("${naver.redirect_uri}")
	private String n_redirect_uri;
	@Value("${naver.client_secret}")
	private String n_client_secret;

	//자바빈 초기화
	@ModelAttribute
	public MemberVO initCommand() {
		return new MemberVO();
	}

	/*===================================
	 * 			회원가입
	 *==================================*/
	//일반 회원가입 폼
	@GetMapping("/member/signup")
	public String signupForm(@RequestParam(value = "rcode", required = false) String rcode, HttpSession session) {
		session.setAttribute("rcode", rcode);
		return "memberSignup";
	}

	//일반 회원가입
	@PostMapping("/member/signup")
	public String signup(@Validated(ValidationSequence.class) MemberVO memberVO, BindingResult result,
			RedirectAttributes redirectAttributes, HttpServletRequest request, HttpSession session) {
		log.debug("<<회원가입>> : " + memberVO);

		if (result.hasErrors()) {
			log.debug("<<에러>> : " + result.getAllErrors());
			return "memberSignup";
		}
		//회원가입 타입 지정(1:일반 회원가입)
		memberVO.setMem_reg_type(1);

		//추천인 이벤트 참가
		if (memberVO.getFriend_rcode() != null && !memberVO.getFriend_rcode().equals("")) {
			//추천인 이벤트 참여
			if (memberService.selectMemNumByRCode(memberVO.getFriend_rcode()) != null) {
				memberVO.setRecommend_status(1);
			} else {
				result.rejectValue("friend_rcode", "invalidRCode");
				return "memberSignup"; // 회원가입 폼 다시 보여주기
			}
		} else {
			//미참여
			memberVO.setRecommend_status(0);
		}

		//이메일,닉네임 UK 체크
		if (memberService.selectMemberByEmail(memberVO.getMem_email()) != null) {
			result.rejectValue("mem_email", "emailExists");
			return "memberSignup";
		}
		if (memberService.selectMemberByNick(memberVO.getMem_nick()) != null) {
			result.rejectValue("mem_nick", "nickExists");
			return "memberSignup";
		}

		//회원가입
		memberService.insertMember(memberVO);
		session.removeAttribute("rcode"); //추천인코드 초기화

		// 세션에 속성 설정
		session.setAttribute("accessTitle", "회원가입 완료");
		session.setAttribute("accessMsg", "회원가입이 완료되었습니다");
		session.setAttribute("accessBtn", "로그인하기");
		session.setAttribute("accessUrl", request.getContextPath() + "/member/login");

		return "redirect:/member/signup/result";
	}

	//회원가입 완료 페이지
	@GetMapping("/member/signup/result")
	public String signupResult(Model model, HttpSession session) {
		// 세션에서 속성 가져와서 모델에 추가
		model.addAttribute("accessTitle", session.getAttribute("accessTitle"));
		model.addAttribute("accessMsg", session.getAttribute("accessMsg"));
		model.addAttribute("accessBtn", session.getAttribute("accessBtn"));
		model.addAttribute("accessUrl", session.getAttribute("accessUrl"));
		return "signupResultPage";
	}

	//카카오 로그인/회원가입 api
	@GetMapping("/member/oauth/kakao")
	public String getKakaoLogin() {
		String url = String.format(
				"https://kauth.kakao.com/oauth/authorize?client_id=%s&response_type=code&redirect_uri=%s", k_client_id,
				k_redirect_uri);
		return "redirect:" + url;
	}

	//카카오 로그인/회원가입 api 콜백
	@GetMapping("/member/callback/kakao")
	public ResponseEntity<?> kakaoCallback(@RequestParam("code") String code, RedirectAttributes redirectAttributes,
			HttpSession session) {
		try {
			// Access Token 획득
			String accessToken = memberOAuthService.getKakaoAccessToken(code);
			UserInfo kakaoMember = memberOAuthService.getKakaoInfo(accessToken);

			log.debug("<<카카오 로그인 정보>> : " + kakaoMember);

			// 이메일을 통해 기존 회원 정보 조회
			MemberVO existingMember = memberService.selectMemberByEmail(kakaoMember.getEmail());

			String redirectUrl;

			if (existingMember != null) { // 기존 회원이 존재하는 경우
				if (existingMember.getMem_status() == 1) { // 정지 회원인 경우
					redirectAttributes.addFlashAttribute("error", "정지된 회원입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_status() == 0) { // 탈퇴 회원인 경우
					redirectAttributes.addFlashAttribute("error", "탈퇴한 회원입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_reg_type() == 1) { //일반회원가입된 이메일일 경우
					redirectAttributes.addFlashAttribute("error", "일반 회원가입된 이메일입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_reg_type() == 2) { //네이버 회원가입된 이메일일 경우
					redirectAttributes.addFlashAttribute("error", "네이버로 회원가입된 이메일입니다");
					redirectUrl = "/member/login";
				} else { // 정상 회원인 경우
					// TODO: 자동 로그인 체크 로직 추가

					// 로그인 처리
					session.setAttribute("user", existingMember);
					session.setMaxInactiveInterval(60 * 30); //30분
					session.setAttribute("kakaoToken", accessToken);

					log.debug("<<인증 성공>>");

					log.debug("<<photo>> : {}", existingMember.getMem_photo());
					log.debug("<<email>> : {}", existingMember.getMem_email());
					log.debug("<<status>> : {}", existingMember.getMem_status());
					log.debug("<<reg_type>> : {}", existingMember.getMem_reg_type());

					if (existingMember.getMem_status() == 9) { // 관리자
						redirectUrl = "/admin/manageMember";
					} else { // 일반 회원
						redirectUrl = "/main/main";
					}
				}

			} else { // 기존 회원이 없는 경우 회원가입 폼으로 이동

				MemberVO memberVO = new MemberVO();
				memberVO.setMem_email(kakaoMember.getEmail());
				memberVO.setMem_social_id(kakaoMember.getId());
				memberVO.setMem_reg_type(3);

				log.debug("<<카카오 email>> : " + memberVO.getMem_email());

				//회원가입 폼으로 redirect
				session.setAttribute("memberVO", memberVO);
				redirectUrl = "/member/signup/oauth";
			}

			// 리다이렉트 URL을 반환
			return ResponseEntity.status(HttpStatus.FOUND).header(HttpHeaders.LOCATION, redirectUrl).body(null);

		} catch (Exception e) {
			// 예외 처리 로직: 에러 페이지로 리다이렉트
			return new ResponseEntity<>("Exception occurred: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	//카카오/네이버 회원가입 폼으로 redirect
	@GetMapping("/member/signup/oauth")
	public String signupFormKakao(HttpSession session, Model model) {
		MemberVO memberVO = (MemberVO) session.getAttribute("memberVO");

		if (memberVO == null) {
			return "redirect:/member/signup";
		} else if (memberVO.getMem_reg_type() == 2) {
			model.addAttribute("memberVO", memberVO);
			return "memberSocialSignup";
		} else {
			model.addAttribute("memberVO", memberVO);
			return "memberSocialSignup";
		}
	}

	//카카오/네이버 회원가입
	@PostMapping("/member/signup/oauth")
	public String signupKakao(@Valid MemberVO memberVO, BindingResult result, Model model, HttpServletRequest request,
			HttpSession session) {
		memberVO.setMem_pw("N"); // 비밀번호 임의 지정

		//추천인 이벤트 참가
		if (memberVO.getFriend_rcode() != null && !memberVO.getFriend_rcode().equals("")) {
			//추천인 이벤트 참여
			if (memberService.selectMemNumByRCode(memberVO.getFriend_rcode()) != null) {
				memberVO.setRecommend_status(1);
			} else {
				result.rejectValue("friend_rcode", "invalidRCode");
				return "memberSocialSignup"; // 회원가입 폼 다시 보여주기
			}
		} else {
			//미참여
			memberVO.setRecommend_status(0);
		}
		//이메일,닉네임 UK 체크
		if (memberService.selectMemberByEmail(memberVO.getMem_email()) != null) {
			result.rejectValue("mem_email", "emailExists");
			return "memberSignup";
		}
		if (memberService.selectMemberByNick(memberVO.getMem_nick()) != null) {
			result.rejectValue("mem_nick", "nickExists");
			return "memberSignup";
		}

		log.debug("<<카카오/네이버 회원가입>> : " + memberVO);

		// 회원가입 처리
		memberService.insertMember(memberVO);
		session.removeAttribute("rcode"); //추천인코드 초기화

		// 세션에 속성 설정
		session.setAttribute("accessTitle", "회원가입 완료");
		session.setAttribute("accessMsg", "회원가입이 완료되었습니다");
		session.setAttribute("accessBtn", "로그인하기");
		session.setAttribute("accessUrl", request.getContextPath() + "/member/login");

		return "redirect:/member/signup/result";
	}

	//네이버 로그인/회원가입 api
	@GetMapping("/member/oauth/naver")
	public String getNaverLogin() {
		String url = String.format(
				"https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=%s&redirect_uri=%s&state=%s",
				n_client_id, n_redirect_uri, "STATE_STRING");
		return "redirect:" + url;
	}

	//네이버 로그인/회원가입 api 콜백
	@GetMapping("/member/callback/naver")
	ResponseEntity<?> naverCallback(@RequestParam("code") String code, @RequestParam(name = "state") String state,
			RedirectAttributes redirectAttributes, HttpSession session) {
		try {
			// 2. 접근 토큰 발급 요청
			String accessToken = memberOAuthService.getNaverAccessToken(code, state);
			// 3. 사용자 정보 받기
			UserInfo naverMember = memberOAuthService.getNaverInfo(accessToken);

			log.debug("<<네이버 로그인 정보>> : " + naverMember);

			// 이메일을 통해 기존 회원 정보 조회
			MemberVO existingMember = memberService.selectMemberByEmail(naverMember.getEmail());

			String redirectUrl;

			if (existingMember != null) { // 기존 회원이 존재하는 경우
				if (existingMember.getMem_status() == 1) { // 정지 회원인 경우
					redirectAttributes.addFlashAttribute("error", "정지된 회원입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_status() == 0) { // 정지 회원인 경우
					redirectAttributes.addFlashAttribute("error", "탈퇴한 회원입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_reg_type() == 1) { //일반회원가입된 이메일일 경우
					redirectAttributes.addFlashAttribute("error", "일반 회원가입된 이메일입니다");
					redirectUrl = "/member/login";
				} else if (existingMember.getMem_reg_type() == 3) { //카카오 회원가입된 이메일일 경우
					redirectAttributes.addFlashAttribute("error", "카카오로 회원가입된 이메일입니다");
					redirectUrl = "/member/login";
				} else { // 정상 회원인 경우
					// TODO: 자동 로그인 체크 로직 추가

					// 로그인 처리
					session.setAttribute("user", existingMember);
					session.setMaxInactiveInterval(60 * 30); //30분
					session.setAttribute("naverToken", accessToken);

					log.debug("<<인증 성공>>");

					log.debug("<<photo>> : {}", existingMember.getMem_photo());
					log.debug("<<email>> : {}", existingMember.getMem_email());
					log.debug("<<status>> : {}", existingMember.getMem_status());
					log.debug("<<reg_type>> : {}", existingMember.getMem_reg_type());

					if (existingMember.getMem_status() == 9) { // 관리자
						redirectUrl = "/admin/manageMember";
					} else { // 일반 회원
						redirectUrl = "/main/main";
					}
				}

			} else { // 기존 회원이 없는 경우 회원가입 폼으로 이동

				MemberVO memberVO = new MemberVO();
				memberVO.setMem_email(naverMember.getEmail());
				memberVO.setMem_social_id(naverMember.getId());
				memberVO.setMem_reg_type(2);

				log.debug("<<네이버 email>> : " + memberVO.getMem_email());

				//회원가입 폼으로 redirect
				session.setAttribute("memberVO", memberVO);
				redirectUrl = "/member/signup/oauth";
			}

			// 리다이렉트 URL을 반환
			return ResponseEntity.status(HttpStatus.FOUND).header(HttpHeaders.LOCATION, redirectUrl).body(null);

		} catch (Exception e) {
			// 예외 처리 로직: 에러 페이지로 리다이렉트
			return new ResponseEntity<>("Exception occurred: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	/*===================================
	 * 			로그인
	 *==================================*/
	//로그인폼
	@GetMapping("/member/login")
	public String loginForm(HttpSession session, Model model) {

		String error = (String) session.getAttribute("error");
		if (error != null) {
			model.addAttribute("error", error);
			session.removeAttribute("error");
		}

		return "memberLogin";
	}

	//일반 로그인
	@PostMapping("/member/login")
	public String login(@Valid MemberVO memberVO, BindingResult result, HttpSession session) {
		log.debug("<<회원 로그인>> : {}", memberVO);

		// 유효성 체크 결과 오류가 있으면 폼 호출
		if (result.hasFieldErrors("mem_email") || result.hasFieldErrors("mem_pw")) {
			return "memberLogin";
		}

		try {
			MemberVO member = memberService.selectMemberByEmail(memberVO.getMem_email());

			// =====TODO 로그인타입 체크 ====//
			if (member != null) {
				// 멤버 email이 존재할 시 status가 정지회원, 탈퇴회원인지 체크
				if (member.getMem_status() == 1) { // 정지회원
					result.reject("suspendedMember");
					return "memberLogin";
				}

				// 비밀번호 일치여부 체크
				if (memberService.isCheckedPassword(member, memberVO.getMem_pw())) {
					// 인증 성공
					// =====TODO 자동로그인 체크 시작====//
					// =====TODO 자동로그인 체크 끝====//

					// 로그인 처리
					session.setAttribute("user", member);

					log.debug("<<인증 성공>>");
					log.debug("<<email>> : {}", member.getMem_email());
					log.debug("<<status>> : {}", member.getMem_status());
					log.debug("<<reg_type>> : {}", member.getMem_reg_type());

					if (member.getMem_status() == 9) { // 관리자
						return "redirect:/admin/manageMember";
					} else {
						return "redirect:/main/main";
					}
				}
			}

			// 인증 실패 시 예외 던지기
			throw new AuthCheckException();
		} catch (AuthCheckException e) {
			result.reject("invalidEmailOrPassword");
			log.debug("<<인증 실패>>");
			return "memberLogin";
		}
	}

	//로그아웃
	@GetMapping("/member/logout")
	public String logout(HttpSession session) {
		String kakaoToken = (String) session.getAttribute("kakaoToken");
		String naverToken = (String) session.getAttribute("naverToken");
		if (kakaoToken != null && !"".equals(kakaoToken)) { //카카오 로그인 
			try {
				// =====TODO 자동로그인 체크 시작====//
				// =====TODO 자동로그인 체크 끝====//
				memberOAuthService.kakaoDisconnect(kakaoToken);
			} catch (Exception e) {
				// 예외 처리
				return "Exception occurred: " + e.getMessage();
			}
		} else if (naverToken != null && !"".equals(naverToken)) { //네이버 로그인
			return "redirect:/member/logout/naver";
		}

		//로그아웃
		session.invalidate();

		return "redirect:/main/main";
	}

	//네이버 로그아웃
	@GetMapping("/member/logout/naver")
	public String logoutNaver(HttpSession session) {
		String naverToken = (String) session.getAttribute("naverToken");
		if (naverToken != null && !"".equals(naverToken)) {
			try {
				String url = String.format(
						"https://nid.naver.com/oauth2.0/token?grant_type=%s&client_id=%s&client_secret=%s&access_token=%s&service_provider=%s",
						"delete", n_client_id, n_client_secret, naverToken, "Naver");

				HttpHeaders headers = new HttpHeaders();
				headers.add("Content-Type", "application/x-www-form-urlencoded");

				HttpEntity<String> requestEntity = new HttpEntity<>(null, headers);

				ResponseEntity<String> responseEntity = restTemplate.exchange(url, HttpMethod.POST, requestEntity,
						String.class);

				if (responseEntity.getStatusCode().is2xxSuccessful()) {
					// 로그아웃 처리 로직
					session.invalidate();
					log.debug("<<네이버 로그아웃 성공>>");
					return "redirect:/main/main";
				} else {
					throw new Exception();
				}
			} catch (Exception e) {
				// 예외 처리
				return "Exception occurred: " + e.getMessage();
			}
		} else {
			return "redirect:/main/main";
		}
	}

	//비밀번호 찾기 폼
	@GetMapping("/member/findPassword")
	public String findPasswordForm() {
		return "memberFindPassword";
	}

	//비밀번호 찾기 결과
	@GetMapping("/member/findPasswordResult")
	public String findPassword(@RequestParam("mem_email") String mem_email, HttpSession session, Model model,
			HttpServletRequest request) {
		log.debug("<<비밀번호 찾기>> : " + mem_email);
		MemberVO memberVO = memberService.selectMemberByEmail(mem_email);
		log.debug("<<비밀번호 찾기>> : " + memberVO);

		if (memberVO != null) {
			if (memberVO.getMem_status() == 0) {
				//탈퇴회원
				model.addAttribute("email_msg", "탈퇴 회원입니다");
				return "memberFindPassword";
			} else if (memberVO.getMem_status() == 1) {
				//정지회원
				model.addAttribute("email_msg", "정지회원입니다");
				return "memberFindPassword";
			}

			if (memberVO.getMem_reg_type() == 2) {
				//네이버 로그인
				model.addAttribute("email_msg", "네이버로 소셜로그인된 계정입니다");
				return "memberFindPassword";
			} else if (memberVO.getMem_reg_type() == 3) {
				//카카오 로그인
				model.addAttribute("email_msg", "카카오로 소셜로그인된 계정입니다");
				return "memberFindPassword";
			}

			//인증번호 발급
			String veryficationCode = memberService.getPasswordVerificationCode();

			// JSP 템플릿 로드
			String htmlContent;
			try {
				htmlContent = loadHtmlTemplate("/WEB-INF/views/member/password-email.html", veryficationCode);
				//메일 전송
				EmailMessageVO emailMessage = new EmailMessageVO();
				emailMessage.setTo(mem_email);
				emailMessage.setSubject("[Don Gibu Up] 비밀번호 변경 인증번호 발급");
				emailMessage.setMessage(htmlContent);
				log.debug("<<email>> : " + emailMessage);
				emailService.sendMail(emailMessage, "password");

				session.setAttribute("verificationCode", veryficationCode);
				session.setAttribute("mem_email", mem_email);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			model.addAttribute("email_msg", "가입된 이메일이 없습니다");
			return "memberFindPassword";
		}
		return "redirect:/member/changePassword";
	}

	@GetMapping("/member/changePassword")
	public String changePasswordForm() {
		return "passwordChangePage";
	}

	//비밀번호 찾기 - 비밀번호 수정
	@PostMapping("/member/changePassword")
	public String changePassword(@Validated(PatternCheckGroup.class) MemberVO memberVO, BindingResult result,
			Model model, HttpServletRequest request, HttpSession session) {

		log.debug("<<비밀번호 수정 요청 도착>> : " + memberVO);

		if (result.hasErrors()) {
			log.debug("<<검증 에러>> : " + result.getAllErrors());
			return "passwordChangePage";
		}

		String mem_email = (String) session.getAttribute("mem_email");

		if (mem_email == null) {
			log.debug("<<세션에 이메일 없음>>");
			// 세션에 이메일이 없을 경우 처리 로직 추가
			return "redirect:/member/login";
		}

		MemberVO user = memberService.selectMemberByEmail(mem_email);
		if (user == null) {
			log.debug("<<이메일로 사용자를 찾을 수 없음>>");
			return "redirect:/member/login";
		}

		memberVO.setMem_num(user.getMem_num());

		memberService.updatePassword(memberVO);

		session.setAttribute("accessTitle", "비밀번호 변경 완료");
		session.setAttribute("accessMsg", "비밀번호 변경이 완료되었습니다");
		session.setAttribute("accessBtn", "로그인하기");
		session.setAttribute("accessUrl", request.getContextPath() + "/member/login");

		return "redirect:/member/changePassword/result";
	}

	//비밀번호 변경 완료 페이지
	@GetMapping("/member/changePassword/result")
	public String changePasswordResult(Model model, HttpSession session) {
		// 세션에서 속성 가져와서 모델에 추가
		model.addAttribute("accessTitle", session.getAttribute("accessTitle"));
		model.addAttribute("accessMsg", session.getAttribute("accessMsg"));
		model.addAttribute("accessBtn", session.getAttribute("accessBtn"));
		model.addAttribute("accessUrl", session.getAttribute("accessUrl"));
		
		return "passwordResultPage";
	}

	private String loadHtmlTemplate(String path, String verificationCode) throws IOException {
		InputStream inputStream = servletContext.getResourceAsStream(path);
		if (inputStream == null) {
			throw new IOException("HTML 템플릿을 찾을 수 없습니다: " + path);
		}
		String htmlTemplate = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
		return htmlTemplate.replace("${verificationCode}", verificationCode);
	}

	/*===================================
	 * 			관리자 회원관리
	 *==================================*/
	//회원 목록
	@GetMapping("/admin/manageMember")
	private String adminMemberList(@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "1") int order, String keyfield, String keyword, Model model) {

		log.debug("<<회원 목록 - order>> : " + order);

		Map<String, Object> map = new HashMap<String, Object>();
		if (keyword != null && keyword.equals("")) {
			keyword = null;
		}

		map.put("keyfield", keyfield);
		map.put("keyword", keyword);

		//전체, 검색 레코드수
		int count = memberService.selectMemberCount(map);

		//페이지 처리
		PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, count, 20, 10, "manageMember", "&order=" + order);

		List<MemberVO> list = null;
		if (count > 0) {
			map.put("order", order);
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());

			list = memberService.selectMemberList(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		return "adminManageMember";
	}

	//회원 포인트 관리 페이지
	@GetMapping("/admin/managePoint")
	private String adminMemberPoint(@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "1") int order, String keyfield, String keyword, Model model) {

		log.debug("<<회원 포인트 - order>> : " + order);

		Map<String, Object> map = new HashMap<String, Object>();
		if (keyword != null && keyword.equals("")) {
			keyword = null;
		}

		map.put("keyfield", keyfield);
		map.put("keyword", keyword);

		//전체, 검색 레코드수
		int count = memberService.selectMemberCount(map);

		//페이지 처리
		PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, count, 20, 10, "managePoint", "&order=" + order);

		List<MemberVO> list = null;
		if (count > 0) {
			map.put("order", order);
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());

			list = memberService.selectMemberList(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		return "adminManagePoint";
	}
	//회원 상세 페이지
    @GetMapping("/admin/detail")
	public String statusAdmin(long mem_num, Model model) {
		log.debug("<<관리자 회원 상세 - member_num>> : "+ mem_num);
    	//멤버정보
    	MemberVO member = memberService.selectMemberDetail(mem_num);
    	log.debug("<<관리자 회원 상세 - member>> : " + member);	
    	
    	//휴대폰번호
    	if (member.getMem_phone() != null) {
			model.addAttribute("phone2", member.getMem_phone().substring(3, 7));
			model.addAttribute("phone3", member.getMem_phone().substring(7, 11));
			log.debug("<<관리자 회원 상세 - phone>> : " + member.getMem_phone().substring(3, 7)
					+ member.getMem_phone().substring(7, 11));
		}
    	
    	//생년월일
		if (member.getMem_birth() != null) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
			LocalDate parsedDate = LocalDate.parse(member.getMem_birth(), formatter);

			model.addAttribute("birth_year", parsedDate.getYear());
			model.addAttribute("birth_month", parsedDate.getMonthValue());
			model.addAttribute("birth_day", parsedDate.getDayOfMonth());
		}
		MemberTotalVO memberTotal = memberService.selectMemberTotal(mem_num);
		log.debug("<<관리자 회원 상세 - memberTotal>> : " + memberTotal);	
		//뷰에 전달
		model.addAttribute("memberTotal", memberTotal);
		model.addAttribute("member", member);
    	
    	return "adminMemberDetail";
    }
    
    //회원 등급 변경
    @GetMapping("/admin/Change")
    public String authChange(long mem_num,int member_auth) {
    	log.debug("<<관리자 회원 등급 변경 - member_num>> : "+ mem_num);
    	log.debug("<<관리자 회원 등급 변경 전 - member_auth>> : " + member_auth);

    	//회원 등급 수정
    	memberService.updateMemAuth(mem_num,member_auth);
    	
    	//알림을 위한 정보 세팅
    	MemberVO member = memberService.selectMember(mem_num);
    	String authName = null;
    	if(member_auth==1) {
    		authName="기부흙";
    	}else if (member_auth==2) {
    		authName="기부씨앗";
		}else if (member_auth==3) {
    		authName="기부새싹";
		}else if (member_auth==4) {
    		authName="기부꽃";
		}else if (member_auth==5) {
    		authName="기부나무";
		}else if (member_auth==6) {
    		authName="기부숲";
		}
    	//알림
		NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(mem_num);
		notifyVO.setNotify_type(38); 
		notifyVO.setNot_url("/member/myPage/memberInfo");
		
		Map<String, String> dynamicValues = new HashMap<String, String>();
		dynamicValues.put("memNick", member.getMem_nick());
		dynamicValues.put("memAuth", authName);
		
		notifyService.insertNotifyLog(notifyVO, dynamicValues);
		
    	return "redirect:/admin/detail?mem_num=" + mem_num;
    }
	//회원 등급 자동 등업
    @Scheduled(cron = "0 0 0 * * ?")
    public void authUpdate() {
    	//전체 멤버리스트
    	List<MemberVO> memberList = memberService.selectAllMemberList();
    	//등업한 회원수 카운트
    	int count = 0;
    	for(MemberVO member : memberList) {
    		MemberTotalVO memberTotal = memberService.selectMemberTotal(member.getMem_num());  		
    		if(member.getAuth_num()==1) {
    			//기부흙 -> 기부씨앗 : 기부액 10,000원, 기부횟수 5회
        		if(memberTotal.getTotal_amount() >= 10000 && memberTotal.getTotal_count() >= 5) {
        			memberService.updateMemAuth(member.getMem_num(),member.getAuth_num()+1);
        			notifyMethod(member.getMem_num(),member.getMem_nick(),member.getAuth_num()+1);
        			log.debug("<<등업한 회원 - 기부흙 -> 기부씨앗>> : " + member.getMem_nick() + "(" + member.getMem_num() + ")");
        			count++;
        		}
        	}else if (member.getAuth_num()==2) {
        		//기부씨앗 -> 기부새싹 : 기부액 100,000원, 기부횟수 10회
        		if(memberTotal.getTotal_amount() >= 100000 && memberTotal.getTotal_count() >= 10) {
        			memberService.updateMemAuth(member.getMem_num(),member.getAuth_num()+1);
        			notifyMethod(member.getMem_num(),member.getMem_nick(),member.getAuth_num()+1);
        			log.debug("<<등업한 회원 - 기부씨앗 -> 기부새싹>> : " + member.getMem_nick() + "(" + member.getMem_num() + ")");
        			count++;
        		}
    		}else if (member.getAuth_num()==3) {
    			//기부새싹 -> 기부꽃 : 기부액 1,000,000원, 기부횟수 30회
    			if(memberTotal.getTotal_amount() >= 1000000 && memberTotal.getTotal_count() >= 30) {
    				memberService.updateMemAuth(member.getMem_num(),member.getAuth_num()+1);
    				notifyMethod(member.getMem_num(),member.getMem_nick(),member.getAuth_num()+1);
    				log.debug("<<등업한 회원 - 기부새싹 -> 기부꽃>> : " + member.getMem_nick() + "(" + member.getMem_num() + ")");
    				count++;
    			}     	
        	}else if (member.getAuth_num()==4) {
        		//기부꽃 -> 기부나무 : 기부액 10,000,000원, 기부횟수 30회
        		if(memberTotal.getTotal_amount() >= 10000000 && memberTotal.getTotal_count() >= 30) {
        			memberService.updateMemAuth(member.getMem_num(),member.getAuth_num()+1);
        			notifyMethod(member.getMem_num(),member.getMem_nick(),member.getAuth_num()+1);
        			log.debug("<<등업한 회원 - 기부꽃 -> 기부나무>> : " + member.getMem_nick() + "(" + member.getMem_num() + ")");
        			count++;
        		}     	
        	}else if (member.getAuth_num()==5) {
        		//기부나무 -> 기부숲 : 기부액 100,000,000원, 기부횟수 30회
        		if(memberTotal.getTotal_amount() >= 100000000 && memberTotal.getTotal_count() >= 30) {
        			memberService.updateMemAuth(member.getMem_num(),member.getAuth_num()+1);
        			notifyMethod(member.getMem_num(),member.getMem_nick(),member.getAuth_num()+1);
        			log.debug("<<등업한 회원 - 기부나무 -> 기부숲>> : " + member.getMem_nick() + "(" + member.getMem_num() + ")");
        			count++;
        		}     	
        	}   		
    	}//end of for
    	log.debug("<<오늘 등업한 회원 수>> : " + count);
    }
	
    //알림 메서드
    public void notifyMethod(long mem_num,String mem_nick,int member_auth) {
    	String authName = null;
    	if(member_auth==1) {
    		authName="기부흙";
    	}else if (member_auth==2) {
    		authName="기부씨앗";
		}else if (member_auth==3) {
    		authName="기부새싹";
		}else if (member_auth==4) {
    		authName="기부꽃";
		}else if (member_auth==5) {
    		authName="기부나무";
		}else if (member_auth==6) {
    		authName="기부숲";
		}
    	
    	NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(mem_num);
		notifyVO.setNotify_type(38); 
		notifyVO.setNot_url("/member/myPage/memberInfo");
		
		Map<String, String> dynamicValues = new HashMap<String, String>();
		dynamicValues.put("memNick", mem_nick);
		dynamicValues.put("memAuth", authName);
		
		notifyService.insertNotifyLog(notifyVO, dynamicValues);
    }
	
	/*	@GetMapping("/test/endpage")
		public String getEnd() {
			return "dboxProposeEnd2";
		}*/
}
