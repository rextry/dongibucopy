package kr.spring.dbox.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.dbox.vo.DboxBudgetVO;
import kr.spring.dbox.vo.DboxDonationVO;
import kr.spring.dbox.vo.DboxResultVO;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.subscription.vo.SubscriptionVO;

@Mapper 
public interface DboxMapper {
	//Dbox 등록
	@Select("SELECT dbox_seq.nextval FROM dual")
	public Long selectDboxNum();//Dbox 번호 생성
	public Long insertDbox(DboxVO dbox);//Dbox 입력
	@Insert("INSERT INTO dbox_budget (dbox_bud_num,dbox_num,dbox_bud_purpose,dbox_bud_price) "
							+ "VALUES(dbox_budget_seq.nextval,dbox_seq.currval,#{dbox_bud_purpose},#{dbox_bud_price})")
	public void insertDboxBudget(DboxBudgetVO dboxBudget);//Dbox 모금액 사용 계획 입력	
	@Select("SELECT dbox_seq.currval FROM dual")
	public Long curDboxNum();//Dbox 현재 번호 선택
	//Dbox 수정
	@Update("UPDATE dbox SET dbox_status=#{dbox_status} WHERE dbox_num=#{dbox_num}")
	public void updateDboxStatus(long dbox_num,int dbox_status);
	@Update("UPDATE dbox SET dbox_acomment=#{dbox_acomment} WHERE dbox_num=#{dbox_num}")
	public void updateDboxAcomment(long dbox_num,String dbox_acomment);
	
	//Dbox 데이터 가져오기
	public Integer selectListCount(Map<String, Object> map);//Dbox 개수
	public List<DboxVO> selectList(Map<String, Object> map);//Dbox 목록	
	public Integer selectAdminListCount(Map<String, Object> map);//Dbox 관리자개수
	public List<DboxVO> selectAdminList(Map<String, Object> map);//Dbox 관리자목록
	@Select("SELECT * FROM dbox WHERE dbox_status=#{dbox_status}")
	public List<DboxVO> selectStatusUpdateList(int dbox_status);//Dbox 업데이트 목록
	@Select("SELECT * FROM (SELECT * FROM dbox WHERE dbox_status = 3 ORDER BY dbox_num DESC) WHERE ROWNUM <= 5")
	public List<DboxVO> mainDboxList();//메인 기부박스 최신 목록 5개
	@Select("SELECT * FROM dbox JOIN dona_category USING(dcate_num) WHERE dbox_num=#{dbox_num}")
	public DboxVO selectDbox(long dbox_num);//Dbox 선택
	
	//Dbox 기부계획
	@Select("SELECT * FROM dbox_budget WHERE dbox_num=#{dbox_num}")
	public List<DboxBudgetVO> selectDboxBudgets(long dbox_num);
	
	//Dbox 기부하기
	public void insertDboxDonation(DboxDonationVO dboxDonationVO);//기부하기 등록
	@Select("SELECT * FROM dbox_donation JOIN member USING(mem_num) LEFT OUTER JOIN member_detail USING(mem_num) WHERE dbox_num=#{dbox_num} ORDER BY dbox_do_num DESC")
	public List<DboxDonationVO> selectDboxDonations(long dbox_num);//기부하기 목록 가져오기
	@Select("SELECT COUNT(*) FROM dbox_donation JOIN member USING(mem_num) LEFT OUTER JOIN member_detail USING(mem_num) WHERE dbox_num=#{dbox_num}")
	public Integer selectDboxDonationsCount(long dbox_num);//기부하기 갯수 가져오기
	@Select("SELECT SUM(dbox_do_price) FROM dbox_donation WHERE dbox_num=#{dbox_num}")
	public Long selecDoantionTotal(long dbox_num);//기부 총액 가져오기
	
	//Dbox 결과보고
	@Select("SELECT * FROM dbox_result WHERE dbox_num=#{dbox_num}")
	public DboxResultVO selectDboxResult(long dbox_num);//결과보고 가져오기
	
	//환불신청시 결제상태 변경
	@Update("UPDATE dbox_donation SET dbox_do_status=#{dbox_do_status} WHERE dbox_do_num=#{dbox_do_num}")
	public void updatePayStatus(long dbox_do_num, long dbox_do_status);
	
	
	/*마이페이지*/
	//제안한 기부박스 개수
	@Select("SELECT COUNT(*) FROM dbox WHERE mem_num=#{mem_num}")
	public int getDboxCountbyMem_num(Map<String, Object> map);
	//제안한 기부박스 현황 확인
	public List<DboxVO> getDboxByMem_num(Map<String, Object> map);
	//기부박스 중단된 impuid 불러오기
	@Select("SELECT * FROM dbox_donation WHERE dbox_num =#{dbox_num}")
	public List<DboxDonationVO> getDboxDonationVODboxNum(long dbox_num);

	
}