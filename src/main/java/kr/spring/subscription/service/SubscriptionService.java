package kr.spring.subscription.service;

import java.util.List;
import java.util.Map;

import kr.spring.subscription.vo.SubscriptionVO;

public interface SubscriptionService {
    // 정기기부 번호 생성
    public long getSub_num();

    // 정기기부 등록
    public void insertSubscription(SubscriptionVO subscriptionVO);

    // 정기기부 종료
    public void endSubscription(long sub_num);

    // 정기기부 조회
    public SubscriptionVO getSubscriptionBySub_num(long sub_num);

    // 정기기부 삭제
    public void deleteSubscription(long sub_num);

    // 오늘 날짜 구하기
    public int getTodayDate();
    
    public String getImpKeys(int payment_type);
    
    public String getImpSecret(int payment_type);
    
    public String getToken(int payment_type);
    //정기 결제 날짜가 오늘인 구독 목록 반환
    public List<SubscriptionVO> getSubscriptionByDay(int today);
    
    //정기기부 중단
    public void updateSub_status(long sub_num);
    
    //정기기부 목록
    public List<SubscriptionVO> getSubscriptionByMem_numWithCategories(long mem_num);
    
    public int getSubscriptionCountbyMem_num(long mem_num);
    //정기기부 결제수단 변경
    public void modifyPayMethod(SubscriptionVO subscriptionVO);
    //내일 결제일인 정기기부 목록
    public List<SubscriptionVO> getSubscriptionByD1(int tomorrow);
    
  //모든 사용자의 정기기부 개수
  	public int getSubscriptionCount(Map<String,Object> map);
  	//모든 사용자의 정기기부 현황 확인
  	public List<SubscriptionVO> getSubscription(Map<String,Object> map);
  	
  //impuid로 기부박스 결제번호와 굿즈샵 결제번호 가져오기
  	public long getPurchase_num(String imp_uid);
  	
  	public long getDboxDoNum(String imp_uid);
}
