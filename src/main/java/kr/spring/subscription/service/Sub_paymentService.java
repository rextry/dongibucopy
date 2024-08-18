package kr.spring.subscription.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Select;

import kr.spring.subscription.vo.Sub_paymentVO;

public interface Sub_paymentService {
	//결제 예약
	public void insertSub_payment(Sub_paymentVO subpaymentVO);
	//결제 예약 내역 가져오기
	//예약된 결제 상태 변경
	//sub_pay_num 생성
	public long getSub_payment_num();
	public Sub_paymentVO getSub_paymentByDate(long mem_num);
	public List<Sub_paymentVO> getSub_payment();
	public int getSub_paymentCountByMem_num(Map<String,Object> map);
	public List<Sub_paymentVO> getSub_paymentByMem_num(Map<String,Object> map);
	public List<Sub_paymentVO> getSub_paymentBySub_num(long sub_num);
	//환불신청시 결제상태 변경
	public void updateSubPayStatus(long sub_pay_num, long sub_pay_status);
}
