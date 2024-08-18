package kr.spring.delete.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import kr.spring.challenge.vo.ChallengePaymentVO;
import kr.spring.dbox.vo.DboxDonationVO;

@Mapper
public interface DeleteMapper {
	/*********************
	 * 챌린지 
	 *********************/
	
	//챌린지 좋아요 -> 완료
	//chal_chat_read
	@Delete("DELETE FROM chal_chat_read WHERE mem_num=#{mem_num}")
	public void deleteChatReadsByMember(long mem_num);
	
	//chal_verify_rpt
	@Delete("DELETE FROM chal_verify_rpt WHERE report_mem_num=#{mem_num}")
	public void deleteVerifyRptsByMember(long mem_num);
	
	//chal_veriify
	@Delete("DELETE FROM chal_verify WHERE mem_num=#{mem_num}")
	public void deleteVerifiesByMember(long mem_num);
	
	//
	//chal_join
	@Update("UPDATE chal_join SET chal_joi_status=2 WHERE mem_num=#{mem_num}")
	public void updateChalJoinStatusesByMember(long mem_num);
	
	//리더일때 챌린지 불러오기 -> 환불 (챌린지가 시작전이거나 진행중일 때)
	public List<Long> selectChallengesByMember(long mem_num);
	
	//챌린지 각각의 모든 결제 불러오기
	public List<ChallengePaymentVO> selectChalPayListByChalNum(long chal_num);

	//리더가 아닐때 모든 결제 불러오기 ->환불 (챌린지가 시작전이거나 진행중일 때)
	public List<ChallengePaymentVO> selectNonLeaderChallengesByMember(long mem_num);
	
	
	/*********************
	 * 기부박스
	 *********************/
	//진행중인 기부박스 불러오기 -> 환불 
	public List<DboxDonationVO> selectOngoingDboxByMember(long mem_num);
	
	//시작 안한모든 기부박스 불러와서 status 변경
	@Update("UPDATE dbox SET dbox_status=5 WHERE dbox_status < 2 AND mem_num=#{mem_num}")
	public void updateDboxStatusByMember(long mem_num);
	
	
	/*********************
	 * 기타
	 *********************/
	//문의 삭제
	@Delete("DELETE FROM inquiry WHERE mem_num=#{mem_num}")
	public void deleteInquiriesByMember(long mem_num);
	
	//알림 로그 삭제
	@Delete("DELETE FROM notify_log WHERE mem_num=#{mem_num}")
	public void deleteNotifyLogsByMember(long mem_num);
	
	//결제수단(pay_uid 삭제)
	@Delete("DELETE FROM pay_uid WHERE mem_num=#{mem_num}")
	public void deletePayUidsByMember(long mem_num);
	
	//포인트 로그 삭제
	@Delete("DELETE FROM point_log WHERE mem_num=#{mem_num}")
	public void deletePointLogsByMember(long mem_num);
	
	//환불신청 삭제
	@Delete("DELETE FROM refund WHERE mem_num=#{mem_num}")
	public void deleteRefundsByMember(long mem_num);
	
	//신고 삭제(mem_num)
	@Delete("DELETE FROM report WHERE mem_num=#{mem_num}")
	public void deleteReportsByMember(long mem_num);
	
	//정기기부 중단
	@Update("UPDATE subscription SET sub_status=1 WHERE mem_num=#{mem_num}")
	public void cancelSubscriptionByMember(long mem_num);
	
	
	
	
	
}
