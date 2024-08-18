package kr.spring.dbox.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Select;

import kr.spring.dbox.vo.DboxBudgetVO;
import kr.spring.dbox.vo.DboxDonationVO;
import kr.spring.dbox.vo.DboxResultVO;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.refund.vo.RefundVO;
import kr.spring.subscription.vo.SubscriptionVO;

public interface DboxService {
	//Dbox 등록
	public Long insertDbox(DboxVO dbox);//Dbox 등록
	
	//Dbox 수정
	public void updateDboxStatus(long dbox_num,int dbox_status);//Dbox Status 수정
	public void updateDboxAcomment(long dbox_num,String dbox_acomment);//Dbox Acomment 수정
	
	//Dbox 데이터 가져오기
	public Integer selectListCount(Map<String, Object> map);//Dbox 개수
	public List<DboxVO> selectList(Map<String, Object> map);//Dbox 목록
	public Integer selectAdminListCount(Map<String, Object> map);//Dbox 관리자개수
	public List<DboxVO> selectAdminList(Map<String, Object> map);//Dbox 관리자목록
	public List<DboxVO> selectStatusUpdateList(int dbox_status);//Dbox 업데이트 목록
	public DboxVO selectDbox(long dbox_num);//Dbox 개별 데이터
	public List<DboxVO> mainDboxList();//메인 기부박스 최신 목록 5개
	
	//Dbox 기부계획
	public List<DboxBudgetVO> selectDboxBudgets(long dbox_num);//기부계획 목록 불러오기
	
	//Dbox 기부하기
	public void insertDboxDonation(DboxDonationVO dboxDonationVO);//기부하기 등록
	public List<DboxDonationVO> selectDboxDonations(long dbox_num);//기부하기 목록 
	public Integer selectDboxDonationsCount(long dbox_num);//기부하기 개수
	public Long selecDoantionTotal(long dbox_num);//기부 총액 데이터
	
	//Dbox 결과보고
	public DboxResultVO selectDboxResult(long dbox_num);//기부 결과 개별 데이터
	
	public void updatePayStatus(long dbox_do_num, long dbox_do_status);
	
	/*마이페이지*/
	//제안한 기부박스 개수
	public int getDboxCountbyMem_num(Map<String, Object> map);
	//제안한 기부박스 현황 확인
	public List<DboxVO> getDboxByMem_num(Map<String, Object> map);
	
	public List<DboxDonationVO> getDboxDonationVODboxNum(long dbox_num);
	
	public void refund(RefundVO refundVO , DboxDonationVO dboxDonationVO);
}