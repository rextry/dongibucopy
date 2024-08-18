package kr.spring.cs.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.cs.vo.FaqVO;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.cs.vo.ReportVO;

@Mapper
public interface CSMapper {
	//문의 작성
	public void insertInquiry(InquiryVO inquiryVO);
	//문의 상세
	@Select("SELECT a.*, b.mem_nick FROM inquiry a JOIN member b ON a.mem_num=b.mem_num WHERE a.inquiry_num=#{inquiry_num}")
	public InquiryVO selectInquiryDetail(long inquiry_num);
	//문의 목록(관리자)
	public List<InquiryVO> selectInquiryList(Map<String, Object> map);
	//문의 개수(관리자)
	public int selectInquiryListCount(Map<String, Object> map);
	//회원별 문의 목록
	@Select("SELECT * FROM inquiry WHERE mem_num=#{mem_num}")
	public List<InquiryVO> selectInquiryListByMemNum(long mem_num);
	//문의 수정
	public void updateInquiry(InquiryVO inquiryVO);
	//문의 삭제
	@Delete("DELETE FROM inquiry WHERE inquiry_num=#{inquiry_num}")
	public void deleteInquiry(long inquiry_num);
	//문의 답변/답변 수정(관리자)
	public void replyInquiry(InquiryVO inquiryVO);
	
	//faq 목록
	public List<FaqVO> selectFaqList(Map<String, Object> map);
	//faq 등록
	@Insert("INSERT INTO faq(faq_num,faq_category,faq_question,faq_answer) VALUES(#{faq_num}, #{faq_category}, #{faq_question}, #{faq_answer})")
	public void insertFaq(FaqVO faqVO);
	//faq 수정
	@Update("UPDATE faq SET faq_question=#{faq_question}, faq_answer=#{faq_answer} WHERE faq_num=#{faq_num}")
	public void updateFaq(FaqVO faqVO);
	//faq 삭제
	@Delete("DELETE FROM faq WHERE faq_num=#{faq_num}")
	public void deleteFaq(long faq_num);
	//faq seq 선택
	@Select("SELECT faq_seq.nextval FROM dual")
	public long selectFaqNum();
	
	//신고 작성
	public void insertReport(ReportVO reportVO);
	//신고 개수
	public int selectReportListCount(Map<String, Object> map);
	//신고 목록
	public List<ReportVO> selectReportList(Map<String, Object> map);
	//신고 상세
	public ReportVO selectReportDetail(long report_num);
	//신고 답변/답변 수정
	public void replyReport(ReportVO reportVO);
	//신고 삭제(처리중일 때만 가능)
	@Delete("DELETE FROM report WHERE report_num=#{report_num}")
	public void deleteReport(long report_num);
	//신고 목록(사용자)
	@Select("SELECT * FROM report WHERE mem_num=#{mem_num}")
	public List<ReportVO> selectReportListByMemNum(long mem_num);
}
