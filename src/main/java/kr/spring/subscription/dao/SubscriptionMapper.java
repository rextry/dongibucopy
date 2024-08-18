package kr.spring.subscription.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import kr.spring.subscription.vo.SubscriptionVO;

@Mapper
public interface SubscriptionMapper {


	//정기기부 번호 생성
	@Select("SELECT subscription_seq.nextval FROM dual")
	public long getSub_num();
	//정기기부 등록
	public void insertSubscription(SubscriptionVO subscriptionVO);
	//등록된 정기기부 정보 가져오기
	@Select("SELECT * FROM subscription WHERE sub_num=#{sub_num}")
	public SubscriptionVO getSubscriptionBySub_num(long sub_num);
	//정기기부 종료
	public void endSubscription(long sub_num);
	//결제수단 변경
	public void modifyPayMethod(SubscriptionVO subscriptionVO);

	//정기기부 중단
	@Update("UPDATE subscription SET sub_status=1, cancel_date=SYSDATE WHERE sub_num=#{sub_num}")
	public void updateSub_status(long sub_num);


	//자신의 정기기부 개수
	@Select("SELECT COUNT(*) FROM subscription WHERE mem_num=#{mem_num}")
	public int getSubscriptionCountbyMem_num(long mem_num);
	//자신의 정기기부 현황 확인
	public List<SubscriptionVO> getSubscriptionByMem_num(long mem_num);

	//모든 사용자의 정기기부 개수
	public int getSubscriptionCount(Map<String,Object> map);
	//모든 사용자의 정기기부 현황 확인
	public List<SubscriptionVO> getSubscription(Map<String,Object> map);


	//정기기부 삭제 (결제수단 등록 실패시)
	@Delete("DELETE FROM subscription WHERE sub_num=#{sub_num}")
	public void deleteSubscription(long sub_num);

	//정기결제를 위한 getToken
	@Select("SELECT imp_key FROM token WHERE payment_type=#{payment_type}")
	public String getImpKeys(int payment_type);
	
	@Select("SELECT imp_secret FROM token WHERE payment_type=#{payment_type}")
	public String getImpSecret(int payment_type);
	
	
	@Select("SELECT * FROM subscription WHERE sub_ndate = #{today} AND sub_status = 0")
	public List<SubscriptionVO> getSubscriptionByDay(int today);

	@Select("SELECT * FROM subscription WHERE sub_ndate = #{tomorrow} AND sub_status = 0")
	public List<SubscriptionVO> getSubscriptionByD1(int tomorrow);

	//impuid로 기부박스 결제번호와 굿즈샵 결제번호 가져오기
	@Select("SELECT purchase_num FROM purchase WHERE imp_uid=#{imp_uid}")
	public long getPurchase_num(String imp_uid);
	@Select("SELECT dbox_do_num FROM dbox_donation WHERE dbox_imp_uid=#{imp_uid}")
	public long getDboxDoNum(String imp_uid);
}
