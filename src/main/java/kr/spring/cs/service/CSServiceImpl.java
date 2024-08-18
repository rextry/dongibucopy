package kr.spring.cs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.cs.dao.CSMapper;
import kr.spring.cs.vo.FaqVO;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.cs.vo.ReportVO;
import kr.spring.member.dao.MemberMapper;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;

@Service
@Transactional
public class CSServiceImpl implements CSService {
	@Autowired
	CSMapper csMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	NotifyService notifyService;

	@Override
	public void insertInquiry(InquiryVO inquiryVO) {
		csMapper.insertInquiry(inquiryVO);
	}

	@Override
	public InquiryVO selectInquiryDetail(long inquiry_num) {
		return csMapper.selectInquiryDetail(inquiry_num);
	}

	@Override
	public List<InquiryVO> selectInquiryList(Map<String, Object> map) {
		return csMapper.selectInquiryList(map);
	}
	
	@Override
	public int selectInquiryListCount(Map<String, Object> map) {
		return csMapper.selectInquiryListCount(map);
	}

	@Override
	public List<InquiryVO> selectInquiryListByMemNum(long mem_num) {
		return csMapper.selectInquiryListByMemNum(mem_num);
	}

	@Override
	public void updateInquiry(InquiryVO inquiryVO) {
		csMapper.updateInquiry(inquiryVO);
	}

	@Override
	public void deleteInquiry(long inquiry_num) {
		csMapper.deleteInquiry(inquiry_num);
	}

	//관리자 문의 답변
	@Override
	public void replyInquiry(InquiryVO inquiryVO) {
		csMapper.replyInquiry(inquiryVO);
		
		NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(inquiryVO.getMem_num());
		notifyVO.setNotify_type(25);
		notifyVO.setNot_url("/member/myPage/inquiry/detail?inquiry_num=" + inquiryVO.getInquiry_num());
		
		Map<String, String> dynamicValues = new HashMap<String, String>();
		//value로 전달하는 값은 String이어야 함. String이 아닐 시에는 형변환하고 넣을 것
		dynamicValues.put("inquiryTitle", inquiryVO.getInquiry_title());
		
		notifyService.insertNotifyLog(notifyVO, dynamicValues);
	}

	@Override
	public List<FaqVO> selectFaqList(Map<String, Object> map) {
		return csMapper.selectFaqList(map);
	}

	@Override
	public long insertFaq(FaqVO faqVO) {
		long faq_num = csMapper.selectFaqNum();
		
		faqVO.setFaq_num(faq_num);
		csMapper.insertFaq(faqVO);
		
		return faq_num;
	}

	@Override
	public void updateFaq(FaqVO faqVO) {
		csMapper.updateFaq(faqVO);
	}

	@Override
	public void deleteFaq(long faq_num) {
		csMapper.deleteFaq(faq_num);
	}

	@Override
	public void insertReport(ReportVO reportVO) {
		csMapper.insertReport(reportVO);
	}
	
	@Override
	public int selectReportListCount(Map<String, Object> map) {
		return csMapper.selectReportListCount(map);
	}

	@Override
	public List<ReportVO> selectReportList(Map<String, Object> map) {
		return csMapper.selectReportList(map);
	}

	@Override
	public ReportVO selectReportDetail(long report_num) {
		return csMapper.selectReportDetail(report_num);
	}

	//관리자 신고 답변
	@Override
	public void replyReport(ReportVO reportVO) {
		csMapper.replyReport(reportVO);
		
		NotifyVO notifyVO = new NotifyVO();
		notifyVO.setMem_num(reportVO.getMem_num());
		notifyVO.setNotify_type(21);
		notifyVO.setNot_url("/member/myPage/report/detail?report_num=" + reportVO.getReport_num());
		
		Map<String, String> dynamicValues = new HashMap<String, String>();
		//value로 전달하는 값은 String이어야 함. String이 아닐 시에는 형변환하고 넣을 것
		dynamicValues.put("reportNum", String.valueOf(reportVO.getReport_num()));
		
		notifyService.insertNotifyLog(notifyVO, dynamicValues);
	}

	@Override
	public void deleteReport(long report_num) {
		csMapper.deleteReport(report_num);
	}

	@Override
	public List<ReportVO> selectReportListByMemNum(long mem_num) {
		return csMapper.selectReportListByMemNum(mem_num);
	}


}
