package kr.spring.dbox.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import kr.spring.dbox.dao.DboxMapper;
import kr.spring.dbox.vo.DboxBudgetVO;
import kr.spring.dbox.vo.DboxDonationVO;
import kr.spring.dbox.vo.DboxResultVO;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.member.dao.MemberMapper;
import kr.spring.member.service.MemberService;
import kr.spring.notify.dao.NotifyMapper;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.point.vo.PointVO;
import kr.spring.refund.vo.RefundVO;
import kr.spring.subscription.dao.SubscriptionMapper;
import kr.spring.subscription.service.SubscriptionService;
import kr.spring.subscription.vo.GetTokenVO;
import kr.spring.subscription.vo.SubscriptionVO;

@Service
@Transactional
public class DboxServiceImpl implements DboxService {
	@Autowired
	DboxMapper dboxMapper;
	
	@Autowired
	SubscriptionMapper subscriptionMapper;
	
	@Autowired 
	MemberMapper memberMapper;
	
	@Autowired
	NotifyMapper notifyMapper;
	
   @Autowired
    SubscriptionService subscriptionService;  // SubscriptionService 주입
	//Dbox 등록
	@Override
	public Long insertDbox(DboxVO dbox) {
		dbox.setDbox_num(dboxMapper.selectDboxNum());//Dbox 번호 생성(nextval)
		dboxMapper.insertDbox(dbox);//Dbox 등록
		for(DboxBudgetVO dboxBudget : dbox.getDboxBudgets()) {
			dboxMapper.insertDboxBudget(dboxBudget);//Dbox 모금액 사용 계획 등록
		}
		return dboxMapper.curDboxNum();//dbox번호 반환(curval)
	}
	//Dbox 수정
	@Override
	public void updateDboxStatus(long dbox_num, int dbox_status) {//Dbox Status 수정
		dboxMapper.updateDboxStatus(dbox_num, dbox_status);
	}
	@Override
	public void updateDboxAcomment(long dbox_num,String dbox_acomment) {//Dbox Acomment 수정
		dboxMapper.updateDboxAcomment(dbox_num,dbox_acomment);
	}
	//Dbox 데이터 가져오기
	@Override
	public Integer selectListCount(Map<String, Object> map) {//Dbox 개수
		return dboxMapper.selectListCount(map);
	}	
	@Override
	public List<DboxVO> selectList(Map<String, Object> map) {//Dbox 목록
		return dboxMapper.selectList(map);
	}
	@Override
	public Integer selectAdminListCount(Map<String, Object> map) {//Dbox 관리자개수
		return dboxMapper.selectAdminListCount(map);
	}	
	@Override
	public List<DboxVO> selectAdminList(Map<String, Object> map) {//Dbox 관리자목록
		return dboxMapper.selectAdminList(map);
	}
	@Override
	public List<DboxVO> selectStatusUpdateList(int dbox_status) {//Dbox 업데이트 목록
		return dboxMapper.selectStatusUpdateList(dbox_status);
	}
	@Override
	public List<DboxVO> mainDboxList() {//메인 기부박스 최신 목록 5개
		return dboxMapper.mainDboxList();
	}
	@Override
	public DboxVO selectDbox(long dbox_num) {
		return dboxMapper.selectDbox(dbox_num);//Dbox 개별 선택	
	}
	//Dbox 기부계획
	@Override
	public List<DboxBudgetVO> selectDboxBudgets(long dbox_num) {//기부계획 목록 불러오기
		return dboxMapper.selectDboxBudgets(dbox_num);
	}
	//Dbox 기부하기
	@Override
	public void insertDboxDonation(DboxDonationVO dboxDonationVO) {//기부하기 등록
		dboxMapper.insertDboxDonation(dboxDonationVO);
	}
	@Override
	public List<DboxDonationVO> selectDboxDonations(long dbox_num) {//기부하기 목록
		return dboxMapper.selectDboxDonations(dbox_num);
	}
	@Override
	public Integer selectDboxDonationsCount(long dbox_num) {//기부하기 개수
		return dboxMapper.selectDboxDonationsCount(dbox_num);
	}
	@Override
	public Long selecDoantionTotal(long dbox_num) {//기부하기 총합
		return dboxMapper.selecDoantionTotal(dbox_num);
	}
	//Dbox 결과보고
	@Override
	public DboxResultVO selectDboxResult(long dbox_num) {//기부 결과 개별 데이터
		return dboxMapper.selectDboxResult(dbox_num);
	}
	@Override
	public void updatePayStatus(long dbox_do_num, long dbox_do_status) {
		dboxMapper.updatePayStatus(dbox_do_num, dbox_do_status);
	}

	//마이페이지
	@Override
	public int getDboxCountbyMem_num(Map<String, Object> map) {
		return dboxMapper.getDboxCountbyMem_num(map);
	}
	@Override
	public List<DboxVO> getDboxByMem_num(Map<String, Object> map) {
		return dboxMapper.getDboxByMem_num(map);
	}
	@Override
	public List<DboxDonationVO> getDboxDonationVODboxNum(long dbox_num) {
		return dboxMapper.getDboxDonationVODboxNum(dbox_num);
	}
	
	public void refund(RefundVO refundVO , DboxDonationVO dboxDonationVO) {
		String token = subscriptionService.getToken(1);
		Gson gson = new Gson();
		token = token.substring(token.indexOf("response") + 10);
		token = token.substring(0, token.length() - 1);

		// token에서 response 부분을 추출하여 GetTokenVO로 변환
		GetTokenVO vo = gson.fromJson(token, GetTokenVO.class);

		String access_token = vo.getAccess_token();

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.setBearerAuth(access_token);

		Map<String, Object> map = new HashMap<>();
		if(refundVO.getPayment_type()==0) {
			map.put("merchant_uid", refundVO.getImp_uid());
		}else {
			map.put("imp_uid", refundVO.getImp_uid());
		}
		map.put("reason", refundVO.getReason());

		String json = gson.toJson(map);
		System.out.println("json : " + json);

		HttpEntity<String> entity = new HttpEntity<>(json, headers);
		ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/payments/cancel", entity, String.class);

		// API 응답을 문자열로 받음
		String responseBody = response.getBody();

		// API 응답 문자열에서 code와 message 값을 추출
		Map<String, Object> responseMap = gson.fromJson(responseBody, Map.class);
		Number codeNumber = (Number) responseMap.get("code");
		int code = codeNumber.intValue();
		String message = (String) responseMap.get("message");

		if (response.getStatusCode() == HttpStatus.OK) {	        	
			// API 호출은 성공적으로 되었지만, 실제 결제 성공 여부는 API 응답의 상태를 확인해야 함
			if (code == 0) { 
				PointVO pointVO = new PointVO();
				//포인트 반환
				pointVO.setMem_num(refundVO.getMem_num());
				pointVO.setPevent_type(30);
				pointVO.setPoint_amount(refundVO.getReturn_point());
				memberMapper.updateMemPoint(pointVO);
				//환불 알림				
				NotifyVO notifyVO = new NotifyVO();
				notifyVO.setMem_num(dboxDonationVO.getMem_num());
				notifyVO.setNotify_type(36);
				notifyVO.setNot_url("/member/myPage/payment");
				Map<String, String> dynamicValues = new HashMap<String, String>();

				DboxVO dboxVO = dboxMapper.selectDbox(dboxDonationVO.getDbox_num());
				dynamicValues.put("dboxTitle",dboxVO.getDbox_title());
				dynamicValues.put("price",""+dboxDonationVO.getDbox_do_price());
				dynamicValues.put("point",""+dboxDonationVO.getDbox_do_point());

				notifyMapper.insertNotifyLog(notifyVO, dynamicValues);
			}else {
			//환불 실패시 {code : 1}
				System.out.println("환불 실패 메시지 : " + responseBody);
			}
		}else{ 
			//api 호출 실패시
			System.out.println("환불 api 호출 실패 메시지 : " + responseBody);
		}

	}
}