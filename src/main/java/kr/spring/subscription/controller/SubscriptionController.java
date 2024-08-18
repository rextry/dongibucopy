package kr.spring.subscription.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.spring.category.service.CategoryService;
import kr.spring.category.vo.DonationCategoryVO;
import kr.spring.config.validation.ValidationSequence;
import kr.spring.cs.service.CSService;
import kr.spring.cs.vo.FaqVO;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.dbox.service.DboxService;
import kr.spring.goods.service.GoodsService;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberVO;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.payuid.service.PayuidService;
import kr.spring.payuid.vo.PayuidVO;
import kr.spring.point.vo.PointVO;
import kr.spring.refund.service.RefundService;
import kr.spring.refund.vo.RefundVO;
import kr.spring.subscription.service.Sub_paymentService;
import kr.spring.subscription.service.SubscriptionService;
import kr.spring.subscription.vo.SubscriptionVO;
import kr.spring.util.PagingUtil;
import kr.spring.util.StringUtil;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;
import com.siot.IamportRestClient.IamportClient;

import kr.spring.subscription.vo.GetTokenVO;
import kr.spring.subscription.vo.Sub_paymentVO;
@Slf4j
@Controller
public class SubscriptionController {
	@Autowired
	private SubscriptionService subscriptionService;
	@Autowired
	private PayuidService payuidService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private Sub_paymentService sub_paymentService;
	@Autowired
	NotifyService notifyService;
	@Autowired
	CSService csService;
	@Autowired
	RefundService refundService;
	@Autowired
	GoodsService goodsService;
	@Autowired
	DboxService dboxService;

	private IamportClient impClient;

	@Value("${iamport.apiKey}")
	private String apiKey;

	@Value("${iamport.secretKey}")
	private String secretKey;



	@PostConstruct
	public void initImp() {
		log.debug("API Key: " + apiKey);
		log.debug("Secret Key: " + secretKey);
		this.impClient = new IamportClient(apiKey, secretKey);
	}

	/*--------------------
	 * 정기 기부 메인창 이동
	 *-------------------*/
	@GetMapping("/subscription/subscriptionMain")
	public String subScriptionMain(Model model) {
		Map<String,Object> map = 
				new HashMap<String,Object>();

		//전체,검색 레코드수
		int count = categoryService.getListCount(map);

		//페이지 처리

		List<DonationCategoryVO> list = null;
		if(count > 0) {
			list = categoryService.selectList();
		}

		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("category", 0);

		List<FaqVO> faqlist = csService.selectFaqList(map2);

		for (FaqVO faq : faqlist) {
			faq.setFaq_answer(StringUtil.useBrNoHTML(faq.getFaq_answer()));
		}

		model.addAttribute("faqlist", faqlist);
		model.addAttribute("count", count);
		model.addAttribute("list", list);

		return "subscriptionMain";
	}

	/*--------------------
	 * 정기기부 신청폼 제출
	 *-------------------*/
	@PostMapping("/category/registerSubscription")
	public String signup(@Validated(ValidationSequence.class) SubscriptionVO subscriptionVO,
			Model model,
			HttpServletRequest request,
			HttpSession session,                    
			RedirectAttributes redirectAttributes,
			@RequestParam(name = "sub_date") String subDate
			) {

		MemberVO user = (MemberVO) session.getAttribute("user");
		//비로그인 상태면 로그인 페이지로 이동
		if(user==null) {
			return "redirect:/member/login";
		}
		//sub_num 생성
		subscriptionVO.setSub_num(subscriptionService.getSub_num());
		//subDate int 형으로 변환
		subscriptionVO.setSub_ndate(Integer.parseInt(subDate));
		log.debug("정기기부 등록 subscriptionVO : " + subscriptionVO);
		log.debug("subscriptionVO.card_nickname : " + subscriptionVO.getCard_nickname());
		//로그인한 회원 정보 저장
		MemberVO member_db = memberService.selectMemberDetail(user.getMem_num()); 
		//존재하는 payuid와 대조할 payuidVO 생성후 데이터 셋팅
		PayuidVO payuid = new PayuidVO();
		payuid.setMem_num(user.getMem_num());

		if(!subscriptionVO.getCard_nickname().equals("")) { //결제수단 카드 선택(카드 이름 셋팅)
			payuid.setCard_nickname(subscriptionVO.getCard_nickname());
		} else{// 결제수단 이지페이 선택 (플랫폼 셋팅) 
			payuid.setEasypay_method(subscriptionVO.getEasypay_method());	       
		}
		log.debug("결제수단에 따른 payuidVO 셋팅 : " + payuid);

		if (payuidService.getPayuidByMethod(payuid) == null) { //선택한 결제수단의 payuid가 없는 경우, payuid 생성 후 빌링키 발급 페이지로 이동
			PayuidVO reg_payuid = new PayuidVO();
			reg_payuid.setPay_uid(payuidService.generateUUIDFromMem_num(user.getMem_num()));
			reg_payuid.setMem_num(user.getMem_num());
			if ("easy_pay".equals(subscriptionVO.getSub_method())) {
				reg_payuid.setEasypay_method(subscriptionVO.getEasypay_method());
			} else {
				reg_payuid.setCard_nickname(subscriptionVO.getCard_nickname());
			}
			log.debug("등록할 payuid 정보 : " + reg_payuid);
			//payuid 등록 -> 빌링키 발급 실패하면 삭
			payuidService.registerPayUId(reg_payuid);
			redirectAttributes.addFlashAttribute("subscriptionVO",subscriptionVO);
			redirectAttributes.addFlashAttribute("user", member_db);
			redirectAttributes.addFlashAttribute("payuidVO", reg_payuid); // 등록되는 payuid 정보로 빌링키 발급 페이지 이동        
			//빌링키 발급 성공 여부에 따라 insertSub_payment로 
			return "redirect:/subscription/getpayuid"; 
		}
		payuid = payuidService.getPayuidByMethod(payuid);
		subscriptionService.insertSubscription(subscriptionVO);
		//정기기부 등록 성공 알림
		NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(user.getMem_num());
		notifyVO.setNotify_type(12);
		notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+subscriptionVO.getSub_num());
		Map<String, String> dynamicValues = new HashMap<String, String>();
		DonationCategoryVO category = categoryService.selectDonationCategory(subscriptionVO.getDcate_num());
		dynamicValues.put("dcateName", category.getDcate_charity());
		notifyService.insertNotifyLog(notifyVO, dynamicValues);
		//알림

		redirectAttributes.addFlashAttribute("subscriptionVO",subscriptionVO);
		redirectAttributes.addFlashAttribute("user", member_db);
		redirectAttributes.addFlashAttribute("payuidVO", payuid);

		//재결제 요청 후 resultView 페이지로 이동
		String paymentResult = insertSub_Payment(payuid.getPay_uid(), subscriptionVO.getSub_num());

		if ("payment success".equals(paymentResult)) {
			model.addAttribute("accessTitle", "결제 결과");
			model.addAttribute("accessMsg", "결제가 성공적으로 처리되었습니다.");
			model.addAttribute("accessBtn", "확인");
			model.addAttribute("accessUrl", "/subscription/subscriptionList");
		} else {
			model.addAttribute("accessTitle", "결제 실패");
			model.addAttribute("accessMsg", "결제에 실패하였습니다. 다시 시도해주세요.");
			model.addAttribute("accessBtn", "다시 시도");
			model.addAttribute("accessUrl", "/category/detail?decate_num=" + subscriptionVO.getDcate_num());
		}


		return "paymentResultView";
	}



	/*--------------------
	 * 결제수단 등록페이지로 이동
	 *-------------------*/
	@GetMapping("/subscription/getpayuid")
	public String getpayuid(@ModelAttribute("user") MemberVO user,
			@ModelAttribute("payuidVO") PayuidVO payuidVO,
			@ModelAttribute("subscriptionVO") SubscriptionVO subscriptionVO,
			Model model) {
		subscriptionService.insertSubscription(subscriptionVO);
		// user와 payuidVO 데이터를 사용하여 로직을 처리합니다.
		model.addAttribute("user", user);
		model.addAttribute("subscriptionVO",subscriptionVO);
		model.addAttribute("payuidVO", payuidVO);
		return "/subscription/getpayuid";
	}

	//결제수단 변경폼 제출
	@PostMapping("/subscription/modifyPayMethod")
	@ResponseBody
	public Map getNewpayuid(
			SubscriptionVO subscriptionVO,
			Model model,
			HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		Map<String,String> mapJson = new HashMap<String,String>();					
		//존재하는 payuid와 대조할 payuidVO 생성후 데이터 셋팅
		PayuidVO payuid = new PayuidVO();
		payuid.setMem_num(subscriptionVO.getMem_num());
		DonationCategoryVO categoryVO = categoryService.selectDonationCategory(subscriptionVO.getDcate_num());
		if(!subscriptionVO.getCard_nickname().equals("")) { //결제수단 카드 선택(카드 이름 셋팅)
			payuid.setCard_nickname(subscriptionVO.getCard_nickname());
		} else{// 결제수단 이지페이 선택 (플랫폼 셋팅) 
			payuid.setEasypay_method(subscriptionVO.getEasypay_method());	       
		}
		log.debug("결제수단에 따른 payuidVO 셋팅 : " + payuid);

		if (payuidService.getPayuidByMethod(payuid) == null) { //선택한 결제수단의 payuid가 없는 경우, payuid 생성 후 빌링키 발급 페이지로 이동
			mapJson.put("result", "noPayuid");
		}else {//이미 등록된 결제수단인 경우
			//결제수단 변경 알림
			NotifyVO notifyVO = new NotifyVO();

			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("dcateName",categoryVO.getDcate_charity());
			notifyVO.setMem_num(subscriptionVO.getMem_num());
			notifyVO.setNotify_type(29);
			notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+subscriptionVO.getSub_num());
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			subscriptionService.modifyPayMethod(subscriptionVO);
			mapJson.put("result", "success");
		}

		return mapJson;
	}
	/*--------------------
	 * 결제수단 등록 성공시 결제 메소드 호출, 
	 *-------------------*/
	@PostMapping("/subscription/paymentReservation")
	@ResponseBody
	public ResponseEntity<Map<String, String>> signUp(String pay_uid, long sub_num) {

		SubscriptionVO subscription = subscriptionService.getSubscriptionBySub_num(sub_num); 
		int notify_type = 0;
		Map<String, String> dynamicValues = new HashMap<String, String>();

		if(subscription.getSub_method().equals("card")) {
			notify_type= 26;
			dynamicValues.put("cardNickname", subscription.getCard_nickname());
		}else {
			notify_type= 27;
			dynamicValues.put("easypay_method", subscription.getEasypay_method());
		}

		NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(subscription.getMem_num());
		notifyVO.setNotify_type(notify_type);
		notifyVO.setNot_url("/member/myPage/memberInfo");
		notifyService.insertNotifyLog(notifyVO, dynamicValues);

		// 결제 처리 로직
		String paymentResult = insertSub_Payment(pay_uid, sub_num);

		Map<String, String> response = new HashMap<>();
		if ("payment success".equals(paymentResult)) {
			response.put("status", "success");
			response.put("accessTitle", "결제 결과");
			response.put("accessMsg", "결제가 성공적으로 처리되었습니다.");
			response.put("accessBtn", "확인");
			response.put("accessUrl", "subscriptionList"); 
			response.put("url", "/subscription/resultView"); // 클라이언트에서 이동할 URL
		} else {
			response.put("status", "fail");
			response.put("accessTitle", "결제 실패");
			response.put("accessMsg", "결제에 실패하였습니다. 다시 시도해주세요.");
			response.put("accessBtn", "다시 시도");
			response.put("url", "/subscription/resultView"); // 클라이언트에서 이동할 URL
			response.put("accessUrl", "categoryList");
		}

		return new ResponseEntity<>(response, HttpStatus.OK);
	}

	@GetMapping("/subscription/resultView")
	public String showResult(Model model) {
		// Model attributes 설정
		model.addAttribute("accessTitle", "결제 결과");
		model.addAttribute("accessMsg", "결제가 성공적으로 처리되었습니다.");
		model.addAttribute("accessBtn", "확인");
		model.addAttribute("accessUrl", "subscriptionList");

		// JSP 파일명 반환
		return "paymentResultView"; // 상대경로로 지정
	}


	/*--------------------
	 * 결제수단 등록 실패시 payuid 삭제
	 *-------------------*/
	@PostMapping("/subscription/failGetpayuid")
	@ResponseBody
	public Map<String,String> deletePayuid(String pay_uid, long sub_num, HttpSession session) throws Exception {
		Map<String,String> mapJson = new HashMap<String,String>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		log.debug("빌링키 발급 실패(중단)된 pay_uid : " + pay_uid);
		try {
			//정기기부도 삭제
			subscriptionService.deleteSubscription(sub_num);
			//빌링키 발급 실패한 payuid 삭제
			payuidService.deletePayuid(pay_uid);
			//알림 처리
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(user.getMem_num());
			notifyVO.setNotify_type(28);
			notifyVO.setNot_url("/cs/faqlist");
			Map<String, String> dynamicValues = new HashMap<String, String>();
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			mapJson.put("result", "success");
		}catch(Exception e) {
			mapJson.put("result", "fail");
			throw new Exception(e);
		}	
		return mapJson;
	}


	/*-----------------------
	 * 결제
		 ------------------------*/
	public String insertSub_Payment(String payuid, long sub_num) {
		SubscriptionVO subscriptionVO = subscriptionService.getSubscriptionBySub_num(sub_num);
		log.debug("sub_num" + sub_num);
		DonationCategoryVO categoryVO = categoryService.selectDonationCategory(subscriptionVO.getDcate_num());
		MemberVO user = memberService.selectMemberDetail(subscriptionVO.getMem_num());
		String token = subscriptionService.getToken(0);
		Gson gson = new Gson();
		token = token.substring(token.indexOf("response") + 10);
		token = token.substring(0, token.length() - 1);

		// token에서 response 부분을 추출하여 GetTokenVO로 변환
		GetTokenVO vo = gson.fromJson(token, GetTokenVO.class);

		String access_token = vo.getAccess_token();
		System.out.println(access_token);

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(access_token);
		Sub_paymentVO sub_paymentVO = new Sub_paymentVO();
		sub_paymentVO.setSub_pay_num(sub_paymentService.getSub_payment_num());
		sub_paymentVO.setMem_num(subscriptionVO.getMem_num());
		sub_paymentVO.setSub_num(subscriptionVO.getSub_num());
		sub_paymentVO.setSub_price(subscriptionVO.getSub_price());

		Map<String, Object> map = new HashMap<>();
		map.put("customer_uid", payuid);
		map.put("merchant_uid", "merchant_uid"+sub_paymentVO.getSub_pay_num());
		map.put("amount", sub_paymentVO.getSub_price());
		map.put("name", categoryVO.getDcate_name() + " 정기 기부");
		map.put("buyer_name", user.getMem_name());

		String json = gson.toJson(map);
		System.out.println("json : " + json);

		HttpEntity<String> entity = new HttpEntity<>(json, headers);
		ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/subscribe/payments/again", entity, String.class);

		// API 응답을 문자열로 받음
		String responseBody = response.getBody();

		// API 응답 문자열에서 code 값을 추출
		Number codeNumber = (Number) gson.fromJson(responseBody, Map.class).get("code");
		int code = codeNumber.intValue();
		System.out.println("response : " + response);

		if (response.getStatusCode() == HttpStatus.OK) {	        	
			// API 호출은 성공적으로 되었지만, 실제 결제 성공 여부는 API 응답의 상태를 확인해야 함
			if (code == 0) {
				//결제 성공 알림
				NotifyVO notifyVO = new NotifyVO();
				notifyVO.setMem_num(user.getMem_num());
				notifyVO.setNotify_type(14);
				notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+sub_num);
				Map<String, String> dynamicValues = new HashMap<String, String>();
				dynamicValues.put("dcateName", categoryVO.getDcate_charity());
				notifyService.insertNotifyLog(notifyVO, dynamicValues);

				// 결제 성공
				sub_paymentService.insertSub_payment(sub_paymentVO);
				return "payment success";
			} else {
				//결제 실패 알림
				NotifyVO notifyVO = new NotifyVO();
				notifyVO.setMem_num(user.getMem_num());
				notifyVO.setNotify_type(29);
				notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+sub_num);
				Map<String, String> dynamicValues = new HashMap<String, String>();
				dynamicValues.put("dcateName", categoryVO.getDcate_name());
				notifyService.insertNotifyLog(notifyVO, dynamicValues);				
				// 결제 실패시 정기기부 중단
				subscriptionService.updateSub_status(sub_num);
				// 결제 실패 구독 정보 로그
				log.debug("결제 실패 구독 정보 sub_num : "+subscriptionVO.getSub_num());
				return  "payment fail";
			}
		} else {
			// API 호출 실패
			return "api fail";
		}
	}


	@Scheduled(cron = "0 0 * * * ?")
	public void SubscriptionPayment() {
		int today = subscriptionService.getTodayDate();

		List<SubscriptionVO> list = new ArrayList<SubscriptionVO>();
		list = subscriptionService.getSubscriptionByDay(today);

		for(SubscriptionVO subscription : list) {
			PayuidVO payuid = new PayuidVO();
			payuid.setMem_num(subscription.getMem_num());

			// Check for easypay_method and cardNickname
			if (subscription.getEasypay_method() != null) {
				payuid.setEasypay_method(subscription.getEasypay_method());
			} else if (subscription.getCard_nickname() != null) {
				payuid.setCard_nickname(subscription.getCard_nickname());
			}
			payuid = payuidService.getPayuidByMethod(payuid);
			String response = insertSub_Payment(payuid.getPay_uid(), subscription.getSub_num());
			System.out.println("금일 정기기부 목록 결제요청 완료 : " + response);						
		}
	}

	@Scheduled(cron = "0 0 * * * ?")
	public void performDailyTask() {
		// 오늘 날짜를 LocalDate 객체로 생성
		LocalDate today = LocalDate.now(); // 현재 날짜

		// 다음 날의 일(day)을 두 자리 int 형식으로 구하기
		int tomorrow = getNextDayOfMonthAsInt(today);

		List<SubscriptionVO> list = new ArrayList<SubscriptionVO>();
		list = subscriptionService.getSubscriptionByD1(tomorrow);

		for(SubscriptionVO subscription : list) {

			DonationCategoryVO categoryVO = categoryService.selectDonationCategory(subscription.getDcate_num());

			//결제 하루 전 도래시 알림
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(subscription.getMem_num());
			notifyVO.setNotify_type(13);
			notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+subscription.getSub_num());
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("dcateName", categoryVO.getDcate_name());
			notifyService.insertNotifyLog(notifyVO, dynamicValues);	
			System.out.println("결제 하루 전 도래한 정기기부 알림 완료");						
		}		
	}

	// 다음 날의 일(day)을 두 자리 int로 반환
	public static int getNextDayOfMonthAsInt(LocalDate today) {
		// 다음 날 계산
		LocalDate nextDay = today.plusDays(1);

		// 다음 날의 일(day)을 가져오고 두 자리 형식으로 포맷팅
		int dayOfMonth = nextDay.getDayOfMonth();

		// 두 자리 형식으로 포맷팅된 문자열을 int로 변환하여 반환
		return Integer.parseInt(String.format("%02d", dayOfMonth));
	}

	//정기기부 현황 및 정기결제 내역
	@GetMapping("/subscription/subscriptionList")
	public String subscriptionList(HttpSession session, Model model,
			@RequestParam(defaultValue="1") int pageNum,
			@RequestParam(defaultValue="") String category,
			String keyfield,String keyword){

		MemberVO user = (MemberVO)session.getAttribute("user");


		//페이지 처리
		int count = subscriptionService.getSubscriptionCountbyMem_num(user.getMem_num());
		List<SubscriptionVO> list = null;
		if(count > 0) {
			list = subscriptionService.getSubscriptionByMem_numWithCategories(user.getMem_num());
		}
		model.addAttribute("count", count);
		model.addAttribute("list", list);

		return "subscriptionList";
	}

	@GetMapping("/subscription/paymentHistory")
	public String paymentHistory(HttpSession session, Model model,
			@RequestParam(defaultValue="1") int pageNum,
			@RequestParam(defaultValue="") String category,
			String keyfield,String keyword){

		MemberVO user = (MemberVO)session.getAttribute("user");

		Map<String,Object> map = 
				new HashMap<String,Object>();
		map.put("category", category);
		map.put("keyfield", keyfield);
		map.put("keyword", keyword);
		map.put("mem_num", user.getMem_num());


		int payCount = sub_paymentService.getSub_paymentCountByMem_num(map);
		//결제내역 페이징
		PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, payCount, 10, 10, "paymentHistory", "&category=" + category);

		List<Sub_paymentVO> paylist = null;
		if(payCount > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			paylist = sub_paymentService.getSub_paymentByMem_num(map);


			SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat outputFormat = new SimpleDateFormat("yy년 MM월 dd일/HH:mm");

			for (Sub_paymentVO payment : paylist) {
				try {
					Date date = inputFormat.parse(payment.getSub_pay_date());
					payment.setSub_pay_date(outputFormat.format(date));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}


		model.addAttribute("page",page.getPage());
		model.addAttribute("payCount",payCount);
		model.addAttribute("paylist",paylist);


		return "paymentHistory";
	}

	//정기기부 상세
	@GetMapping("/subscription/subscriptionDetail")
	public ModelAndView subscriptionDetail(long sub_num, Model model) throws ParseException {
		SubscriptionVO subscription = subscriptionService.getSubscriptionBySub_num(sub_num);
		DonationCategoryVO category = categoryService.selectDonationCategory(subscription.getDcate_num());
		Sub_paymentVO subpayment = sub_paymentService.getSub_paymentByDate(subscription.getMem_num());
		String cancelDate = "";

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String regDate = sdf.format(sdf.parse(subscription.getReg_date()));
		String subPayDate = sdf.format(sdf.parse(subpayment.getSub_pay_date()));
		if (subscription.getCancel_date() != null) {
			cancelDate = sdf.format(sdf.parse(subscription.getCancel_date()));
		}

		ModelAndView modelAndView = new ModelAndView("subscriptionDetail");

		List<PayuidVO> paylist = payuidService.getPayUId(subscription.getMem_num());

		List<Sub_paymentVO> list = sub_paymentService.getSub_paymentBySub_num(sub_num);

		SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat outputFormat = new SimpleDateFormat("yy년 MM월 dd일/HH:mm");

		for (Sub_paymentVO payment : list) {
			try {
				Date date = inputFormat.parse(payment.getSub_pay_date());
				payment.setSub_pay_date(outputFormat.format(date));
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		modelAndView.addObject("count",list.size());
		modelAndView.addObject("paylist", paylist);
		modelAndView.addObject("list", list);
		modelAndView.addObject("cancel_date", cancelDate);
		modelAndView.addObject("reg_date", regDate);
		modelAndView.addObject("sub_paydate", subPayDate);
		modelAndView.addObject("category", category);
		modelAndView.addObject("subscription", subscription);
		modelAndView.addObject("subpayment", subpayment);
		modelAndView.addObject("subscriptionVO", new SubscriptionVO()); // Add PayuidVO object
		modelAndView.addObject("refundVO", new RefundVO()); // Add PayuidVO object

		return modelAndView;
	}
	//정기기부 중지
	@PostMapping("/subscription/updateSub_status")
	@ResponseBody
	public Map<String,String> updateSub_status(long sub_num,HttpSession session){
		Map<String, String> mapJson = new HashMap<String,String>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			mapJson.put("result", "logout");
		}

		SubscriptionVO subscriptionVO = subscriptionService.getSubscriptionBySub_num(sub_num);
		if(subscriptionVO.getSub_status()==0) {
			subscriptionService.updateSub_status(sub_num);
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(user.getMem_num());
			notifyVO.setNotify_type(15);
			notifyVO.setNot_url("/subscription/subscriptionDetail?sub_num="+sub_num);
			Map<String, String> dynamicValues = new HashMap<String, String>();
			DonationCategoryVO category = categoryService.selectDonationCategory(subscriptionVO.getDcate_num());
			dynamicValues.put("dcateName", category.getDcate_charity());
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			mapJson.put("result", "success");
		}else {
			mapJson.put("result", "fail");
		}

		return mapJson;
	}


	@GetMapping("/admin/refundRequest")
	public String getListRefund(HttpSession session, Model model,
			@RequestParam(defaultValue="1") int pageNum,
			@RequestParam(defaultValue="3") int refund_status) {

		MemberVO user = (MemberVO)session.getAttribute("user");

		if (user == null) {
			log.warn("세션에 사용자 정보가 없습니다.");
			return "redirect:/login"; // 사용자가 로그인되지 않은 경우 리다이렉트
		}

		log.debug("사용자 mem_num: {}", user.getMem_num());

		Map<String, Object> map = new HashMap<>();
		map.put("mem_num", user.getMem_num());
		map.put("refund_status", refund_status); // 필요한 경우 추가

		log.debug("map 내용: {}", map);

		int count = refundService.getRefundCount(map);
		log.debug("환불 요청 수: {}", count);

		PagingUtil page = new PagingUtil(pageNum, count, 10, 10, "refundRequest");

		List<RefundVO> list = null;
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			log.debug("페이지 범위: {} - {}", page.getStartRow(), page.getEndRow());
			list = refundService.getRefundList(map);
			log.debug("환불 요청 목록 크기: {}", list.size());
		} else {
			log.debug("환불 요청 목록이 비어있음");
		}

		model.addAttribute("page", page.getPage());
		model.addAttribute("count", count);
		model.addAttribute("list", list);

		log.debug("모델에 데이터 추가됨");

		return "refundRequest";
	}


	@GetMapping("/admin/AdminSubscription")
	public String getSubscriptionList(HttpSession session, Model model,
			@RequestParam(defaultValue="1") int pageNum,
			String keyfield,String keyword){

		MemberVO user = (MemberVO)session.getAttribute("user");

		Map<String,Object> map = 
				new HashMap<String,Object>();
		map.put("keyfield", keyfield);
		map.put("keyword", keyword);
		map.put("mem_num", user.getMem_num());


		int count = subscriptionService.getSubscriptionCount(map);
		//결제내역 페이징
		PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, count, 10, 10, "AdminSubscription");

		List<SubscriptionVO> list = null;
		if(count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			list = subscriptionService.getSubscription(map);
		}
		model.addAttribute("page", page.getPage());
		model.addAttribute("count", count);
		model.addAttribute("list", list);

		return "AdminSubscription";
	}


	//환불신청
	@PostMapping("/subscription/paymentRefund")
	@ResponseBody
	public Map<String,String> insertRefund(HttpServletRequest request,
			HttpSession session, 
			RefundVO refundVO, long sub_pay_num) {
		Map<String,String> mapJson = new HashMap<String,String>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			mapJson.put("result", "logout");
		}else {
			refundVO.setMem_num(user.getMem_num());
			refundVO.setPayment_type(0);
			refundVO.setReturn_point(0);

			System.out.println("Received RefundVO: " + refundVO + ", sub_pay_num : " + sub_pay_num);

			refundService.insertRefund(refundVO);
			// 결제 상태 환불 신청으로 변경
			sub_paymentService.updateSubPayStatus(sub_pay_num, 1);
			
			//환불 신청 알림
			String payment_type = "";
			
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(user.getMem_num());
			notifyVO.setNotify_type(30);
			notifyVO.setNot_url("/member/myPage/payment");
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("type","정기기부");
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			
			mapJson.put("result", "success");
		}
		return mapJson;
	}

	/*-----------------------
	 * 환불 api
	 ------------------------*/
	@PostMapping("/admin/approvalRefund")
	@ResponseBody
	public Map<String,String> refund(@RequestBody RefundVO refundVO, HttpSession session) {
		Map<String,String> mapJson = new HashMap<String,String>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user==null) {
			mapJson.put("result", "logout");
		}
		log.debug("refundVO : " + refundVO);
		String token = subscriptionService.getToken(refundVO.getPayment_type());
		Gson gson = new Gson();
		token = token.substring(token.indexOf("response") + 10);
		token = token.substring(0, token.length() - 1);

		// token에서 response 부분을 추출하여 GetTokenVO로 변환
		GetTokenVO vo = gson.fromJson(token, GetTokenVO.class);

		String access_token = vo.getAccess_token();

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(access_token);

		Map<String, Object> map = new HashMap<>();
		if(refundVO.getPayment_type()==0) {
			map.put("merchant_uid", refundVO.getImp_uid());
		}else {
			map.put("imp_uid", refundVO.getImp_uid());
		}
		map.put("reason", refundVO.getReason());

		String json = gson.toJson(map);
		System.out.println("json : " + json);

		HttpEntity<String> entity = new HttpEntity<>(json, headers);
		ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/payments/cancel", entity, String.class);

		// API 응답을 문자열로 받음
		String responseBody = response.getBody();

		// API 응답 문자열에서 code와 message 값을 추출
		Map<String, Object> responseMap = gson.fromJson(responseBody, Map.class);
		Number codeNumber = (Number) responseMap.get("code");
		int code = codeNumber.intValue();
		String message = (String) responseMap.get("message");
		System.out.println("response : " + response);
		
		if (response.getStatusCode() == HttpStatus.OK) {	        	
			// API 호출은 성공적으로 되었지만, 실제 결제 성공 여부는 API 응답의 상태를 확인해야 함
			if (code == 0) { 
				PointVO pointVO = new PointVO();
				//환불 성공
				refundService.updateRefundStatus(refundVO.getRefund_num(), 1);
				if(refundVO.getPayment_type()==0) {					
					// refundVO 객체에서 imp_uid를 가져온다
					String impUid = refundVO.getImp_uid();
					// impUid에서 "merchant_uid"를 제거하여 sub_pay_num을 추출한다
					String prefix = "merchant_uid"; 
					String subPayNumStr = impUid.substring(prefix.length());

					// subPayNum 문자열을 long 타입으로 변환한다
					long subPayNum = Long.parseLong(subPayNumStr);
					// subPayNum을 사용하여 결제 상태를 환불 완료로 변경한다
					sub_paymentService.updateSubPayStatus(subPayNum, 2);
	
				}else if(refundVO.getPayment_type()==1) {	
					//포인트 반환
					pointVO.setMem_num(refundVO.getMem_num());
					pointVO.setPevent_type(30);
					pointVO.setPoint_amount(refundVO.getReturn_point());
					memberService.updateMemPoint(pointVO);
					//결제상태 변경
					long dbox_do_num = subscriptionService.getDboxDoNum(refundVO.getImp_uid());
					dboxService.updatePayStatus(dbox_do_num, 2);
				}else {
					//포인트 반환
					pointVO.setMem_num(refundVO.getMem_num());
					pointVO.setPevent_type(30);
					pointVO.setPoint_amount(refundVO.getReturn_point());
					memberService.updateMemPoint(pointVO);
					//결제상태 변경
					long purchase_num = subscriptionService.getPurchase_num(refundVO.getImp_uid());
					goodsService.updatePayStatus(purchase_num, 2);
				}
				//환불 신청 알림
				String payment_type = "";
				if(refundVO.getPayment_type()==0) {
					payment_type="정기기부";
				}else if(refundVO.getPayment_type()==1) {
					payment_type="기부박스";
				}else {
					payment_type="굿즈샵";
				}
				
				NotifyVO notifyVO = new NotifyVO();
				notifyVO.setMem_num(refundVO.getMem_num());
				notifyVO.setNotify_type(31);
				notifyVO.setNot_url("/member/myPage/payment");
				Map<String, String> dynamicValues = new HashMap<String, String>();
				dynamicValues.put("type",payment_type);
				notifyService.insertNotifyLog(notifyVO, dynamicValues);
				
				mapJson.put("result", "success");
			} else {
				mapJson.put("result", "error");
				mapJson.put("error_msg", message); // 에러 메시지 추가
			}
		} else {
			// API 호출 실패
			mapJson.put("result", "netWorkerror");
		}
		return mapJson;
	}

	@PostMapping("/admin/rejectionRefund")
	@ResponseBody
	public Map<String,String> approvalRefund(@RequestBody RefundVO refundVO, HttpSession session){
		Map<String, String> mapJson = new HashMap<>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		if (user == null) {
			mapJson.put("result", "logout");
			return mapJson;
		}
		refundVO = refundService.getRefundVOByReNum(refundVO.getRefund_num());
		if(refundVO.getPayment_type()==0) {
			// refundVO 객체에서 imp_uid를 가져온다
			String impUid = refundVO.getImp_uid();

			// impUid에서 "merchant_uid"를 제거하여 sub_pay_num을 추출한다
			String prefix = "merchant_uid"; 
			String subPayNumStr = impUid.substring(prefix.length());

			// subPayNum 문자열을 long 타입으로 변환한다
			long subPayNum = Long.parseLong(subPayNumStr);
			// subPayNum을 사용하여 결제 상태를 환불 불가로 변경한다
			sub_paymentService.updateSubPayStatus(subPayNum, 3);
		}else if(refundVO.getPayment_type()==1) {
			long dbox_do_num = subscriptionService.getDboxDoNum(refundVO.getImp_uid());
			dboxService.updatePayStatus(dbox_do_num, 3);
		}else {
			long purchase_num = subscriptionService.getPurchase_num(refundVO.getImp_uid());
			goodsService.updatePayStatus(purchase_num, 3);
		}

			refundService.updateRefundStatus(refundVO.getRefund_num(), 2);
			//환불 신청 알림
			String payment_type = "";
			if(refundVO.getPayment_type()==0) {
				payment_type="정기기부";
			}else if(refundVO.getPayment_type()==1) {
				payment_type="기부박스";
			}else {
				payment_type="굿즈샵";
			}
			
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(refundVO.getMem_num());
			notifyVO.setNotify_type(32);
			notifyVO.setNot_url("/member/myPage/payment");
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("type",payment_type);
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			
		mapJson.put("result", "success");

		return mapJson;
	}

	//종합결제내역에서 환불신청
	@PostMapping("/myPage/paymentRefund")
	@ResponseBody
	public Map<String,String> insertRefundByType(HttpServletRequest request,
			HttpSession session, 
			RefundVO refundVO) {
		Map<String,String> mapJson = new HashMap<String,String>();
		MemberVO user = (MemberVO)session.getAttribute("user");
		if(user == null) {
			mapJson.put("result", "logout");
		}else {
			refundVO.setMem_num(user.getMem_num());
			System.out.println("Received RefundVO: " + refundVO);

			refundService.insertRefund(refundVO);
			// 결제 상태 환불 신청으로 변경
			if(refundVO.getPayment_type()==0) {
				// refundVO 객체에서 imp_uid를 가져온다
				String impUid = refundVO.getImp_uid();

				// impUid에서 "merchant_uid"를 제거하여 sub_pay_num을 추출한다
				String prefix = "merchant_uid"; 
				String subPayNumStr = impUid.substring(prefix.length());

				// subPayNum 문자열을 long 타입으로 변환한다
				long sub_pay_num = Long.parseLong(subPayNumStr);
				sub_paymentService.updateSubPayStatus(sub_pay_num, 1);
			}else if(refundVO.getPayment_type()==1) {
				//기부박스 결제 상태 변경
				dboxService.updatePayStatus(refundVO.getId(), 1);
			}else {
				//굿즈샵 결제 환불신청으로 변경
				goodsService.updatePayStatus(refundVO.getId(), 1);
			}
			//환불 신청 알림
			String payment_type = "";
			if(refundVO.getPayment_type()==0) {
				payment_type="정기기부";
			}else if(refundVO.getPayment_type()==1) {
				payment_type="기부박스";
			}else {
				payment_type="굿즈샵";
			}
			
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(refundVO.getMem_num());
			notifyVO.setNotify_type(30);
			notifyVO.setNot_url("/member/myPage/payment");
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("type",payment_type);
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
			mapJson.put("result", "success");
		}
		return mapJson;
	}

}




