package kr.spring.cs.controller;

import java.io.IOException;
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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.spring.cs.service.CSService;
import kr.spring.cs.vo.FaqVO;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.cs.vo.ReportVO;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberVO;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.util.FileUtil;
import kr.spring.util.PagingUtil;
import kr.spring.util.StringUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CSController {
	@Autowired
	CSService csService;
	
	@Autowired
	MemberService memberService;

	//자바빈(VO) 초기화
	@ModelAttribute
	public InquiryVO initInquiryCommand() {
		return new InquiryVO();
	}
	@ModelAttribute
	public ReportVO initReportCommand() {
		return new ReportVO();
	}

	//자주하는 질문(사용자)
	@GetMapping("/cs/faqlist")
	public String faqlist(@RequestParam(name = "category", required = false) String category, Model model) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);

		log.debug("<<사용자 faq 목록 - category>> : " + category);
		

		List<FaqVO> list = csService.selectFaqList(map);
		
		for (FaqVO faq : list) {
			faq.setFaq_answer(StringUtil.useBrNoHTML(faq.getFaq_answer()));
		}

		model.addAttribute("list", list);

		return "faqlist";
	}

	//자주하는 질문(관리자)
	@GetMapping("/admin/cs/faq")
	public String adminFAQ(@RequestParam(name = "category", required = false) String category, Model model) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category", category);

		log.debug("<<관리자 faq 목록 - category>> : " + category);

		List<FaqVO> list = csService.selectFaqList(map);
		
		for (FaqVO faq : list) {
			faq.setFaq_answer(StringUtil.useBrNoHTML(faq.getFaq_answer()));
		}

		model.addAttribute("list", list);

		return "adminFAQ";
	}

	//faq 등록
	@ResponseBody
	@PostMapping("/admin/cs/insertFaq")
	public Map<String, Object> insertFaqAjax(@RequestParam String faq_question, @RequestParam String faq_answer,
			@RequestParam int faq_category, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			FaqVO faqVO = new FaqVO(faq_category, faq_question, faq_answer);
			long faq_num = csService.insertFaq(faqVO);
			mapAjax.put("faq_num", faq_num);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}

	//faq 수정
	@ResponseBody
	@PostMapping("/admin/cs/modifyFaq")
	public Map<String, Object> modifyFaqAjax(@RequestParam String faq_question, @RequestParam String faq_answer,
			@RequestParam long faq_num, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			FaqVO faqVO = new FaqVO(faq_num, faq_question, faq_answer);
			csService.updateFaq(faqVO);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}

	//faq 삭제
	@ResponseBody
	@PostMapping("/admin/cs/deleteFaq")
	public Map<String, Object> deleteFaqAjax(@RequestParam long faq_num, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			csService.deleteFaq(faq_num);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}

	//1:1문의 폼
	@GetMapping("/cs/inquiry")
	public String form(Model model) {
		Map<String, String> inquiry_category = new HashMap<String, String>();
		inquiry_category.put("", "카테고리 선택");
		inquiry_category.put("0", "정기기부");
		inquiry_category.put("1", "기부박스");
		inquiry_category.put("2", "챌린지");
		inquiry_category.put("3", "굿즈샵");
		inquiry_category.put("4", "기타");

		model.addAttribute("inquiry_category", inquiry_category);

		return "inquiryForm";
	}

	//1:1문의 작성
	@PostMapping("/cs/inquiry")
	public String inquiry(@Valid InquiryVO inquiryVO, BindingResult result, HttpServletRequest request,
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
			return "inquiryForm";
		}

		//회원번호 세팅
		MemberVO user = (MemberVO) session.getAttribute("user");

		inquiryVO.setMem_num(user.getMem_num());

		//파일 업로드
		inquiryVO.setInquiry_filename(FileUtil.createFile(request, inquiryVO.getUpload()));

		log.debug("<<1:1문의 작성>> : " + inquiryVO);

		//문의작성
		csService.insertInquiry(inquiryVO);

		model.addAttribute("accessTitle", "문의 접수 완료");
		model.addAttribute("accessMsg", "1:1문의가 접수되었습니다");
		model.addAttribute("accessBtn", "마이페이지에서 확인하기");
		model.addAttribute("accessUrl", request.getContextPath() + "/member/myPage/inquiry");

		return "inquiryResultPage";
	}

	//관리자 1:1문의 목록
	@GetMapping("admin/cs/inquiry")
	public String inquiryList(@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "1") int status, HttpSession session, Model model) {

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);

		log.debug("<<관리자 문의 목록 - status>> : " + status);

		//레코드 수
		int count = csService.selectInquiryListCount(map);

		//페이지 처리
		PagingUtil page = new PagingUtil(pageNum, count, 30, 10, "inquiry", "&status=" + status);

		List<InquiryVO> list = null;
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			list = csService.selectInquiryList(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		return "adminInquiry";
	}

	//관리자 1:1 문의 답변 폼 (문의 상세보기)
	@GetMapping("/admin/cs/inquiry/reply")
	public String replyInquiryForm(@RequestParam long inquiry_num, Model model) {
		InquiryVO inquiry = csService.selectInquiryDetail(inquiry_num);

		log.debug("<<문의 상세 - inquiry_num>> : " + inquiry_num);
		log.debug("<<문의 상세>> : " + inquiry);
		
		inquiry.setInquiry_content(StringUtil.useBrNoHTML(inquiry.getInquiry_content()));
		inquiry.setInquiry_reply(StringUtil.useBrNoHTML(inquiry.getInquiry_reply()));

		model.addAttribute("inquiry", inquiry);

		return "adminInquiryReply";
	}

	//관리자 문의 답변
	@PostMapping("/admin/cs/inquiry/reply")
	public String replyInquiry(@Valid InquiryVO inquiryVO, BindingResult result, Model model, HttpServletRequest request) {
		if (inquiryVO.getInquiry_reply() == null || inquiryVO.getInquiry_reply().equals("")) {
			result.rejectValue("inquiry_reply", "notBlank.inquiry_reply");
			return "adminInquiryReply";
		}
		
		log.debug("<<1:1문의 답변 - inquiry_num>> : " + inquiryVO.getInquiry_num());
		
		//답변 수정
		csService.replyInquiry(inquiryVO);

		model.addAttribute("inquiry", inquiryVO);
		return "redirect:/admin/cs/inquiry/reply?inquiry_num=" + inquiryVO.getInquiry_num();
	}

	@GetMapping("/admin/cs/inquiry/modifyForm")
	public String modifyInquiryFormAjax(@RequestParam long inquiry_num, Model model) {
		InquiryVO inquiry = csService.selectInquiryDetail(inquiry_num);

		model.addAttribute("inquiry", inquiry);

		return "admin/cs/inquiryModifyForm";
	}
	
	//관리자 신고 목록
	@GetMapping("admin/cs/report")
	public String memberReport(@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(required = false) String status, HttpSession session, Model model) {
		
		if (status != null && status.equals("")) {
			status = null;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", status);

		log.debug("<<관리자 신고 목록 - status>> : " + status);

		//레코드 수
		int count = csService.selectReportListCount(map);

		//페이지 처리
		PagingUtil page = new PagingUtil(pageNum, count, 30, 10, "report", "&status=" + status);

		List<ReportVO> list = null;
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());
			list = csService.selectReportList(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());

		return "adminReport";
	}
	
	//관리자 신고 답변 (신고 상세보기)
	@GetMapping("admin/cs/report/reply")
	public String replyReportForm(@RequestParam long report_num, Model model) {
		ReportVO report = csService.selectReportDetail(report_num);

		log.debug("<<신고 상세 - report_num>> : " + report_num);
		log.debug("<<신고 상세>> : " + report);
		
		report.setReport_content(StringUtil.useBrNoHTML(report.getReport_content()));
		report.setReport_reply(StringUtil.useBrNoHTML(report.getReport_reply()));

		model.addAttribute("report", report);
		return "adminReportReply";
	}
	
	@PostMapping("/admin/cs/report/reply")
	public String replyReport(@Valid ReportVO reportVO, BindingResult result, Model model) {
		if (reportVO.getReport_reply() == null || reportVO.getReport_reply().equals("")) {
			result.rejectValue("report_reply", "notBlank.report_reply");
			return "adminReportReply";
		}
		
		log.debug("<<신고 답변>> : " +reportVO);

		//답변 수정
		csService.replyReport(reportVO);

		model.addAttribute("report", reportVO);
		return "redirect:/admin/cs/report/reply?report_num=" + reportVO.getReport_num();
	}

	@GetMapping("/admin/cs/report/modifyForm")
	public String modifyReportFormAjax(@RequestParam long report_num, Model model) {
		ReportVO report = csService.selectReportDetail(report_num);

		model.addAttribute("report", report);

		return "admin/cs/reportModifyForm";
	}
	
	//신고 폼
	@GetMapping("/cs/report")
	public String formReport(@RequestParam(required = false) Long chal_num,
							 @RequestParam(required = false) Long chal_rev_num,
							 @RequestParam(required = false) Long dbox_re_num,
							 @RequestParam Integer report_source,
							 @RequestParam long reported_mem_num, 
							 Model model,
							 HttpSession session) {
		
		
		Map<String, String> report_type = new HashMap<String, String>();
		report_type.put("", "신고 사유");
		report_type.put("1", "스팸/광고");
		report_type.put("2", "폭력/위협");
		report_type.put("3", "혐오발언/차별");
		report_type.put("4", "음란물/부적절한 콘텐츠");
		
		MemberVO user = (MemberVO) session.getAttribute("user");
		MemberVO reported_mem = memberService.selectMember(reported_mem_num);
		
		ReportVO reportVO = new ReportVO();
		reportVO.setMem_num(user.getMem_num());
		reportVO.setChal_num(chal_num);
		reportVO.setChal_rev_num(chal_rev_num);
		reportVO.setDbox_re_num(dbox_re_num);
		reportVO.setReported_mem_num(reported_mem_num);
		reportVO.setReported_mem_nick(reported_mem.getMem_nick());
		reportVO.setReport_source(report_source);

		log.debug("<<신고 폼>> : " + reportVO);

		model.addAttribute("report_type", report_type);
		model.addAttribute("reportVO", reportVO);

		return "reportForm";
	}

	//신고 작성
	@PostMapping("/cs/report")
	public String report(@Valid ReportVO reportVO, BindingResult result, HttpServletRequest request,
			HttpSession session, Model model) throws IllegalStateException, IOException {
		
		if (result.hasErrors()) {
			Map<String, String> report_type = new HashMap<String, String>();
			report_type.put("", "신고 사유 선택");
			report_type.put("1", "스팸/광고");
			report_type.put("2", "폭력/위협");
			report_type.put("3", "혐오발언/차별");
			report_type.put("4", "음란물/부적절한 콘텐츠");

			model.addAttribute("report_type", report_type);
			model.addAttribute("reportVO", reportVO);
			
			log.debug("<<신고 유효성 검사>> : " + reportVO);
			
			return "reportForm";
		}

		//회원번호 세팅
		MemberVO user = (MemberVO) session.getAttribute("user");

		reportVO.setMem_num(user.getMem_num());

		//파일 업로드
		reportVO.setReport_filename(FileUtil.createFile(request, reportVO.getUpload()));

		log.debug("<<신고>> : " + reportVO);

		//신고 작성
		csService.insertReport(reportVO);

		model.addAttribute("accessTitle", "신고 접수 완료");
		model.addAttribute("accessMsg", "신고가 접수되었습니다");
		model.addAttribute("accessBtn", "마이페이지에서 확인하기");
		model.addAttribute("accessUrl", request.getContextPath() + "/member/myPage/report");

		return "reportResultPage";
	}
}
