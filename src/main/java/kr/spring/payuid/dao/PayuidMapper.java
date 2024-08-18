package kr.spring.payuid.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.payuid.vo.PayuidVO;

@Mapper
public interface PayuidMapper {
	// 결제 수단 등록 (빌링키 발급)
	public void registerPayUId(PayuidVO payuidVO);
	
	// 결제 카드 삭제 (빌링키 삭제, 수정불가능 재발급 필요)
	@Delete("DELETE FROM pay_uid WHERE pay_uid=#{pay_uid}")
	public void deletePayuid (String pay_uid);
	
	//등록된 카드 가져오기
	@Select("SELECT * FROM pay_uid WHERE mem_num=#{mem_num}")
	public List<PayuidVO> getPayUId(long mem_num);
	
	//선택한 결제수단과 mem_num으로 payuid 유무 확인
	public PayuidVO getPayuidByMethod(PayuidVO payuidVO);
	
	//payuid로 payuidVO 불러오기
	@Select("SELECT * FROM pay_uid WHERE pay_uid=#{pay_uid}")
	public PayuidVO getPayuidVOByPayuid(String pay_uid);
	
	//payuid 생성 메소드
	public String generateUUIDFromMem_num(long mem_num);
	
}
