package kr.spring.member.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.member.vo.MemberVO;
import kr.spring.member.vo.PaymentVO;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.point.vo.PointVO;

@Mapper
public interface MemberMapper {
	/*---------------------------------------
					회원 가입
	---------------------------------------*/
	//회원 시퀀스 생성
	@Select("SELECT member_seq.nextval FROM DUAL")
	public long selectMemNum();
	
	//회원가입
	public void insertMember(MemberVO memberVO);
	public void insertMemberDetail(MemberVO memberVO);
	
	//회원정보 가져오기
	@Select("SELECT * FROM member WHERE mem_num=#{mem_num}")
	public MemberVO selectMember(Long mem_num);
	
	//회원정보+디테일 가져오기
	@Select("SELECT * FROM member LEFT OUTER JOIN member_detail USING(mem_num) WHERE mem_num=#{mem_num}")
	public MemberVO selectMemberDetail(Long mem_num);

	//회원 이메일로 회원정보 가져오기(중복 이메일 체크)
	@Select("SELECT a.*, b.mem_photo mem_photo, b.mem_point mem_point FROM member a LEFT OUTER JOIN member_detail b ON(a.mem_num = b.mem_num) WHERE mem_email=#{mem_email}")
	public MemberVO selectMemberByEmail(String mem_email);
	
	//추천코드로 회원정보 가져오기
	@Select("SELECT mem_num FROM member_detail WHERE mem_rcode=#{friend_rcode}")
	public Long selectMemNumByRCode(String friend_rcode);
	
	//회원 포인트 업데이트
	@Update("UPDATE member_detail SET mem_point=mem_point+#{point_amount} WHERE mem_num=#{mem_num}")
	public void updateMemPoint(PointVO pointVO);
	
	//회원 포인트 업데이트(관리자)
	@Update("UPDATE member_detail SET mem_point=#{point_amount} WHERE mem_num=#{mem_num}")
	public void updateMemPointByAdmin(PointVO pointVO);
	
	//중복 추천인 코드 체크
	@Select("SELECT COUNT(*) FROM member_detail WHERE mem_rcode=#{rcode}")
	public int checkRCodeExists(String rcode);
	
	//회원 닉네임으로 회원정보 가져오기(중복 닉네임 체크)
	@Select("SELECT * FROM member WHERE mem_nick=#{mem_nick}")
	public MemberVO selectMemberByNick(String mem_nick);
	
	/*---------------------------------------
				마이페이지
	---------------------------------------*/
	//멤버 토탈 불러오기
	public MemberTotalVO selectMemberTotal(long mem_num);
	
	//프로필사진 수정
	@Update("UPDATE member_detail SET mem_photo=#{mem_photo}, mem_mdate=SYSDATE WHERE mem_num=#{mem_num}")
	public void updateMemPhoto(MemberVO memberVO);
	
	//회원정보 수정
	public void updateMember(MemberVO memberVO);
	public void updateMemberDetail(MemberVO memberVO);
	
	//비밀번호 수정
	@Update("UPDATE member SET mem_pw=#{mem_pw} WHERE mem_num=#{mem_num}")
	public void updatePassword(MemberVO memberVO);
	
	//결제내역 카운트
	public int selectMemberPaymentCount(Map<String, Object> map);
	
	//결제내역 가져오기
	public List<PaymentVO> selectMemberPayment(Map<String, Object> map);
	
	//회원탈퇴(status 변경)
	@Update("UPDATE member SET mem_status=0, mem_pw='' WHERE mem_num=#{mem_num}")
	public void deleteMember(long mem_num);
	
	//회원탈퇴 - member_detail 삭제
	
	/*---------------------------------------
				관리자 회원관리
	---------------------------------------*/
	//회원 리스트 선택
	public List<MemberVO> selectMemberList(Map<String, Object> map);
	//회원 레코드 수 선택
	public int selectMemberCount(Map<String, Object> map);
	//회원 status 수정(정지, 사용)
	@Update("UPDATE member SET mem_status=#{mem_status} WHERE mem_num=#{mem_num}")
	public void updateMemStatus(MemberVO memberVO);
	//회원 detail 삭제
	@Delete("DELETE FROM member_detail WHERE mem_num=#{mem_num}")
	public void deleteMemberDetail(long mem_num);
	//회원 등급 변경
	@Update("UPDATE member SET auth_num=#{member_auth} WHERE mem_num=#{mem_num}")
	public void updateMemAuth(long mem_num,int member_auth);
	//회원 전체 리스트 불러오기(등업용,일반회원 이상)
	@Select("SELECT * FROM member WHERE mem_status >= 2")
	public List<MemberVO> selectAllMemberList();
}
