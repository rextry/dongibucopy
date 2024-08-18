package kr.spring.member.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.siot.IamportRestClient.exception.IamportResponseException;

import kr.spring.config.validation.ValidationGroups.PatternCheckGroup;
import kr.spring.cs.service.CSService;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.cs.vo.ReportVO;
import kr.spring.dbox.service.DboxService;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.member.service.MemberDeleteService;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.member.vo.PaymentVO;
import kr.spring.point.service.PointService;
import kr.spring.point.vo.PointVO;
import kr.spring.util.FileUtil;
import kr.spring.util.PagingUtil;
import kr.spring.util.StringUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyPageController {
	@Autowired
	MemberService memberService;
	
	@Autowired
	PointService pointService;
	
	@Autowired
	CSService csService;
	
	@Autowired
	DboxService dboxService;
	
	@Autowired
	MemberDeleteService memberDeleteService;

	//자바빈 초기화
	@ModelAttribute
	public MemberVO initCommandMember() {
		return new MemberVO();
	}
	
	//자바빈(VO) 초기화
	@ModelAttribute
	public InquiryVO initCommandInquiry() {
		return new InquiryVO();
	}

	@GetMapping("/member/myPage")
	public String myPage() {
		return "redirect:/member/myPage/memberInfo";
	}

	//회원정보 수정 폼
	@GetMapping("/member/myPage/memberInfo")
	public String memberInfo(HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");

		MemberVO memberVO = memberService.selectMemberDetail(user.getMem_num());

		if (memberVO.getMem_phone() != null) {
			model.addAttribute("phone2", memberVO.getMem_phone().substring(3, 7));
			model.addAttribute("phone3", memberVO.getMem_phone().substring(7, 11));
			log.debug("<<phone>> : " + memberVO.getMem_phone().substring(3, 7)
					+ memberVO.getMem_phone().substring(7, 11));
		}

		if (memberVO.getMem_birth() != null) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
			LocalDate parsedDate = LocalDate.parse(memberVO.getMem_birth(), formatter);

			model.addAttribute("birth_year", parsedDate.getYear());
			model.addAttribute("birth_month", parsedDate.getMonthValue());
			model.addAttribute("birth_day", parsedDate.getDayOfMonth());
		}
		
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());

		model.addAttribute("memberTotal", memberTotal);
		model.addAttribute("memberVO", memberVO);
		return "memberInfo";
	}

	//회원정보 수정
	@PostMapping("/member/myPage/updateMember")
	public String updateMemberInfo(@Valid MemberVO memberVO, BindingResult result,
			HttpSession session, Model model) {
		if (memberVO.getMem_phone().equals("010")) {
			memberVO.setMem_phone(null);
		}
		

		MemberVO user = (MemberVO) session.getAttribute("user");

		memberVO.setMem_num(user.getMem_num());
		memberVO.setMem_email(user.getMem_email());
		
		log.debug("<<회원정보 수정>> : " + memberVO);
		
		//닉네임 유효성 검사
		if (memberVO.getMem_nick()=="" || memberVO.getMem_nick() == null) {
			result.rejectValue("mem_nick", "NotBlank.mem_nick");
		}
		//phone 유효성 검사
		if (memberVO.getMem_phone() != null && !memberVO.getMem_phone().isEmpty() && !memberVO.getMem_phone().matches("\\d{11}")) {
		    result.rejectValue("mem_phone", "InvalidFormat.mem_phone");
		}

		if (result.hasErrors()) {
			log.debug("<<에러>> : " + result.getAllErrors());
			return "memberInfo";
		}

		model.addAttribute("memberVO", memberVO);

		//회원정보 수정
		memberService.updateMember(memberVO);

		// 세션에 저장된 user 정보 업데이트
		user.setMem_nick(memberVO.getMem_nick());
		// 세션에 업데이트된 user 객체 저장
		session.setAttribute("user", user);

		//리디렉트할 모델 value 설정
		if (memberVO.getMem_phone() != null && !memberVO.getMem_phone().isEmpty()) {
			model.addAttribute("phone2", memberVO.getMem_phone().substring(3, 7));
			model.addAttribute("phone3", memberVO.getMem_phone().substring(7, 11));
			log.debug("<<phone>> : " + memberVO.getMem_phone().substring(3, 7)
					+ memberVO.getMem_phone().substring(7, 11));
		}

		if (memberVO.getMem_birth() != null && !memberVO.getMem_birth().isEmpty()) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
			LocalDate parsedDate = LocalDate.parse(memberVO.getMem_birth(), formatter);

			model.addAttribute("birth_year", parsedDate.getYear());
			model.addAttribute("birth_month", parsedDate.getMonthValue());
			model.addAttribute("birth_day", parsedDate.getDayOfMonth());
		}
		
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());
		model.addAttribute("memberTotal", memberTotal);

		return "memberInfo";
	}

	//비밀번호 수정 폼
	@GetMapping("/member/myPage/changePassword")
	public String changePasswordForm(Model model, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());

		model.addAttribute("memberTotal", memberTotal);
		
		return "memberChangePassword";
	}

	//비밀번호 수정
	@PostMapping("/member/myPage/changePassword")
	public String changePassword(@Validated(PatternCheckGroup.class) MemberVO memberVO, BindingResult result,
			Model model, HttpServletRequest request, HttpSession session) {
		
		log.debug("<<비밀번호 수정>> : " + memberVO);

		if (result.hasErrors()) {
			log.debug("<<에러>> : " + result.getAllErrors());
			return "memberChangePassword";
		}
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		memberVO.setMem_num(user.getMem_num());
		
		memberService.updatePassword(memberVO);
		
		model.addAttribute("accessTitle", "비밀번호 변경 완료");
		model.addAttribute("accessMsg", "비밀번호 변경이 완료되었습니다");
		model.addAttribute("accessBtn", "홈으로");
		model.addAttribute("accessUrl", request.getContextPath() + "/main/main");
		
		return "changePasswordResultPage";
	}
	
	//회원탈퇴
	@GetMapping("/member/myPage/deleteAccount")
	public String deleteAccountForm(Model model, HttpSession session) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());

		model.addAttribute("memberTotal", memberTotal);
		
		return "memberDeleteAccount";
	}
	
	//회원탈퇴
	@PostMapping("/member/myPage/deleteAccount")
	public String deleteAccount(@Valid MemberVO memberVO, BindingResult result,
			Model model, HttpServletRequest request, HttpSession session) throws IamportResponseException, IOException {
		
		MemberVO user = (MemberVO) session.getAttribute("user");
		
		log.debug("<<회원탈퇴>> : " + memberVO);

		if (memberVO.getMem_pw().equals("")) {
			log.debug("<<에러>> : " + result.getAllErrors());
			result.rejectValue("mem_pw", "NotBlank.mem_pw");
			
			MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());
			model.addAttribute("memberTotal", memberTotal);
			return "memberDeleteAccount";
		}
		
		MemberVO member = memberService.selectMember(user.getMem_num());
		
		if (!memberService.isCheckedPassword(member, memberVO.getMem_pw())) {
			log.debug("<<에러>> : " + result.getAllErrors());
			result.rejectValue("mem_pw", "pwNotMatched");
			
			MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());
			model.addAttribute("memberTotal", memberTotal);
			return "memberDeleteAccount";
		}
		
		memberVO.setMem_num(user.getMem_num());

		//회원탈퇴 service
		memberDeleteService.deleteAccount(user.getMem_num());
		
		session.invalidate();
		
		model.addAttribute("message", "회원탈퇴가 완료되었습니다");
		model.addAttribute("url", request.getContextPath() + "/main/main");
		
		return "common/resultAlert";
	}

	//친구초대이벤트 페이지
	@GetMapping("/member/myPage/inviteFriendEvent")
	public String inviteFriendEvent(HttpSession session, Model model) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		MemberVO member =  memberService.selectMemberDetail(user.getMem_num());
		
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());
		
		//모델에 rcode 담아보내기
		model.addAttribute("rcode", member.getMem_rcode());
		model.addAttribute("memberTotal", memberTotal);
		
		return "inviteFriendEvent";
	}
	
	//포인트 페이지
	@GetMapping("/member/myPage/point")
	public String memberPoint(@RequestParam(defaultValue="1") int pageNum, HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mem_num", user.getMem_num());
		
		int count = pointService.getMPointRowCount(map);
		
		//페이지 처리
		PagingUtil page = new PagingUtil(pageNum, count, 30, 10, "memberPoint");
		
		List<PointVO> list = null;
		
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			list = pointService.getMemberPointList(map);
		}
		
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());

		
		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());
		model.addAttribute("memberTotal", memberTotal);
		
        // ObjectMapper를 사용하여 JSON 형식으로 변환
        ObjectMapper objectMapper = new ObjectMapper();
        try {
			String listJson = objectMapper.writeValueAsString(list);
			log.debug("listJson : " + listJson);
			model.addAttribute("listJson", listJson);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return "memberPoint";
	}
	
	//결제내역 페이지
	@GetMapping("/member/myPage/payment")
	public String memberPayment(@RequestParam(defaultValue="1") int pageNum, HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		
		MemberTotalVO memberTotal = memberService.selectMemberTotal(user.getMem_num());
		model.addAttribute("memberTotal", memberTotal);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("mem_num", user.getMem_num());
		
		int count = memberService.selectMemberPaymentCount(map);
		
		
		//페이지 처리
		PagingUtil page = new PagingUtil(pageNum, count, 30, 10, "payment");
		
		List<PaymentVO> list = null;
		
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			list = memberService.selectMemberPayment(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		log.debug("<<결제 내역>> : " + list);
		
		return "memberPayment";
	}
	
	//문의내역 페이지
	@GetMapping("/member/myPage/inquiry")
	public String memberInquiry(Model model, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<InquiryVO> list = csService.selectInquiryListByMemNum(user.getMem_num());
		
		model.addAttribute("list", list);
		
		return "memberInquiry";
	}
	
	//문의 상세
	@GetMapping("/member/myPage/inquiry/detail")
	public String memberInquiryDetail(@RequestParam long inquiry_num, Model model) {
		InquiryVO inquiry = csService.selectInquiryDetail(inquiry_num);
		
		log.debug("<<문의 상세 - inquiry_num>> : " +inquiry_num);
		log.debug("<<문의 상세>> : " +inquiry);
		
		inquiry.setInquiry_content(StringUtil.useBrNoHTML(inquiry.getInquiry_content()));
		inquiry.setInquiry_reply(StringUtil.useBrNoHTML(inquiry.getInquiry_reply()));
		
		model.addAttribute("inquiry", inquiry);
		
		return "memberInquiryDetail";
	}
	
	
	//파일 다운로드
	@GetMapping("/member/myPage/inquiry/file")
	public String download(@RequestParam long inquiry_num, HttpServletRequest request, Model model) {
		
		InquiryVO inquiry = csService.selectInquiryDetail(inquiry_num);
		byte[] downloadFile = FileUtil.getBytes(request.getServletContext().getRealPath("/upload") + "/" + inquiry.getInquiry_filename());
		
		model.addAttribute("downloadFile", downloadFile);
		model.addAttribute("filename", inquiry.getInquiry_filename());
		
		return "downloadView";
	}
	
	//문의 수정폼
	@GetMapping("/member/myPage/inquiry/modify")
	public String modifyForm(@RequestParam long inquiry_num, Model model) {
		InquiryVO inquiryVO = csService.selectInquiryDetail(inquiry_num);
		
		Map<String, String> inquiry_category = new HashMap<String, String>();
		inquiry_category.put("", "카테고리 선택");
		inquiry_category.put("0", "정기기부");
		inquiry_category.put("1", "기부박스");
		inquiry_category.put("2", "챌린지");
		inquiry_category.put("3", "굿즈샵");
		inquiry_category.put("4", "기타");

		model.addAttribute("inquiry_category", inquiry_category);
		
		log.debug("<<문의 상세 - inquiry_num>> : " +inquiry_num);
		log.debug("<<문의 상세>> : " +inquiryVO);
		
		model.addAttribute("inquiryVO", inquiryVO);
		
		return "memberInquiryModify";
	}

	//문의 수정
	@PostMapping("/member/myPage/inquiry/modify")
	public String modify(@Valid InquiryVO inquiryVO, BindingResult result, HttpServletRequest request,
			HttpSession session, Model model) throws IllegalStateException, IOException {
		if (result.hasErrors()) {
			Map<String, String> inquiry_category = new HashMap<String, String>();
			inquiry_category.put("", "카테고리 선택");
			inquiry_category.put("0", "정기기부");
			inquiry_category.put("1", "기부박스");
			inquiry_category.put("2", "챌린지");
			inquiry_category.put("3", "굿즈샵");
			inquiry_category.put("4", "기타");

			model.addAttribute("inquiry_category", inquiry_category);
			return "memberInquiryModify";
		}
		
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		//db에서 문의 가져오기
		InquiryVO inquiry = csService.selectInquiryDetail(inquiryVO.getInquiry_num());
		
		
		//파일 새로 업로드 됐을 때
		if (inquiryVO.getUpload() != null) {
			inquiryVO.setInquiry_filename(FileUtil.createFile(request, inquiryVO.getUpload()));			
		}
		
		//파일 삭제 됐을 때
		if (inquiryVO.getFile_deleted() == "1") {
			inquiryVO.setInquiry_filename("");			
			FileUtil.removeFile(request, inquiry.getInquiry_filename());
		}

		inquiryVO.setMem_num(user.getMem_num());

		log.debug("<<1:1문의 수정>> : " + inquiryVO);

		//문의수정
		csService.updateInquiry(inquiryVO);

		return "redirect:/member/myPage/inquiry/detail?inquiry_num=" + inquiryVO.getInquiry_num();

	}
	
	//문의 삭제
	@GetMapping("/member/myPage/inquiry/delete")
	public String deleteInquiry(@RequestParam long inquiry_num) {
		
		csService.deleteInquiry(inquiry_num);
		
		return "redirect:/member/myPage/inquiry";
	}
	
	//신고내역 페이지
	@GetMapping("/member/myPage/report")
	public String memberReport(Model model, HttpSession session) {
		MemberVO user = (MemberVO)session.getAttribute("user");
		List<ReportVO> list = csService.selectReportListByMemNum(user.getMem_num());
		
		model.addAttribute("list", list);
		
		return "memberReport";
	}
	
	//신고 상세
	@GetMapping("/member/myPage/report/detail")
	public String memberReportDetail(@RequestParam long report_num, Model model) {
		ReportVO report = csService.selectReportDetail(report_num);
		
		log.debug("<<신고 상세 - report_num>> : " +report_num);
		log.debug("<<신고 상세>> : " +report);
		
		report.setReport_content(StringUtil.useBrNoHTML(report.getReport_content()));
		report.setReport_reply(StringUtil.useBrNoHTML(report.getReport_reply()));
		
		model.addAttribute("report", report);
		
		return "memberReportDetail";
	}
	
	//신고 파일 다운로드
	@GetMapping("/member/myPage/report/file")
	public String downloadReport(@RequestParam long report_num, HttpServletRequest request, Model model) {
		
		ReportVO report = csService.selectReportDetail(report_num);
		byte[] downloadFile = FileUtil.getBytes(request.getServletContext().getRealPath("/upload") + "/" + report.getReport_filename());
		
		model.addAttribute("downloadFile", downloadFile);
		model.addAttribute("filename", report.getReport_filename());
		
		return "downloadView";
	}
	
	//신고 삭제
	@GetMapping("/member/myPage/report/delete")
	public String deleteReport(@RequestParam long report_num) {
		
		csService.deleteReport(report_num);
		
		return "redirect:/member/myPage/report";
	}
	
	/*===================================
	 * 		dbox
	 *==================================*/
	
	/*===================================
	 * 		제안한 기부박스
	 *==================================*/
    @GetMapping("/dbox/myPage/dboxMyPropose")
    public String dboxMyPropose(@RequestParam(defaultValue="1") int pageNum, HttpSession session, Model model) {
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	MemberVO user = (MemberVO) session.getAttribute("user");
    	
    	map.put("mem_num", user.getMem_num());
    	int count = dboxService.getDboxCountbyMem_num(map);
    	
    	log.debug("<<MyPage - 제안한 기부박스 개수>> : " + count);
    	
		//페이지 처리
		PagingUtil page = new PagingUtil(pageNum, count, 10, 10, "dboxMyPropose");
		
		map.put("start", page.getStartRow());
		map.put("end", page.getEndRow());
		
		List<DboxVO> list = null;
		if(count > 0) {
			list = dboxService.getDboxByMem_num(map);
		}else {
			list = Collections.emptyList();//null일 경우 빈 배열로 인식되게 세팅
		}
		
		for (DboxVO dbox : list) {
			dbox.setDbox_acomment(StringUtil.useBrNoHTML(dbox.getDbox_acomment()));
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		log.debug("<<제안한 기부박스 내역>> : " + list);
    	
        return "dboxMyPropose";
    }	
    
    /*===================================
     * 		기부박스 기부내역
     *==================================*/
    @GetMapping("/dbox/myPage/dboxMyDonation")
    public String dboxMyDonation() {
    	log.debug("<<MyPage - 기부박스 기부내역>> : ");
    	
    	return "dboxMyDonation";
    }	
}
