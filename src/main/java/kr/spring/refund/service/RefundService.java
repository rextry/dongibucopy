package kr.spring.refund.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Select;

import kr.spring.refund.vo.RefundVO;

public interface RefundService {
	//환불 신청
		public void insertRefund(RefundVO refundVO);
		
		//관리자 환불신청 목록 수 
		public int getRefundCount(Map<String,Object> map);
		
		//관리자 환불신청 목록 조회
		public List<RefundVO> getRefundList(Map<String,Object> map);
		
		//사용자 환불신청 목록 조회
		public List<RefundVO> getRefundListByMemnum(Map<String,Object> map);
		
		//refund_num으로 refundVO 얻기
		public RefundVO getRefundVOByReNum(long refund_num);
		
		//환불 취소(삭제)
		public void deleteRefund(long refund_num);
		
		//환불 승인 및 반려
		public void updateRefundStatus(long refund_num, int status);
}
