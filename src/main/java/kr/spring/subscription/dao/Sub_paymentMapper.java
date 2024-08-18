package kr.spring.subscription.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.subscription.vo.Sub_paymentVO;

@Mapper
public interface Sub_paymentMapper {
	//결제 번호 생성
	@Select("SELECT sub_payment_seq.nextval FROM dual")
	public long getSub_payment_num();
	//결제 예약 내역 저장
	@Insert("INSERT INTO sub_payment(sub_pay_num,mem_num,sub_num,sub_price) VALUES(#{sub_pay_num},#{mem_num},#{sub_num},#{sub_price})")
	public void insertSub_payment(Sub_paymentVO subpaymentVO);
	//예약된 결제 상태 변경
	//가장 최근 결제 정보 가져오기
	@Select("SELECT * FROM (SELECT * FROM sub_payment ORDER BY sub_pay_date DESC) WHERE ROWNUM = 1 AND mem_num=#{mem_num}")
	public Sub_paymentVO getSub_paymentByDate(long mem_num);
	@Select("SELECT * FROM sub_payment")
	public List<Sub_paymentVO> getSub_payment();

	public int getSub_paymentCountByMem_num(Map<String,Object> map);
	public List<Sub_paymentVO> getSub_paymentByMem_num(Map<String,Object> map);
	
	//sub_num에 해당하는 기부 목록만 가져오기
	@Select("SELECT * FROM sub_payment WHERE sub_num=#{sub_num} ORDER BY sub_pay_date DESC")
	public List<Sub_paymentVO> getSub_paymentBySub_num(long sub_num);
	
	//환불신청시 결제상태 변경
	@Update("UPDATE sub_payment SET sub_pay_status=#{sub_pay_status} WHERE sub_pay_num=#{sub_pay_num}")
	public void updateSubPayStatus(long sub_pay_num, long sub_pay_status);
}
