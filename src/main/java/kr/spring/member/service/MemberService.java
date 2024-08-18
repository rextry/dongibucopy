package kr.spring.member.service;

import java.util.List;
import java.util.Map;

import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.member.vo.PaymentVO;
import kr.spring.point.vo.PointVO;

public interface MemberService {
	//회원가입
	public void insertMember(MemberVO memberVO);

	//비밀번호 비교하기
	public boolean isCheckedPassword(MemberVO member, String rawPassword);

	//회원정보 가져오기
	public MemberVO selectMember(Long mem_num);

	//회원정보+디테일 가져오기
	public MemberVO selectMemberDetail(Long mem_num);

	//이메일로 회원정보 가져오기
	public MemberVO selectMemberByEmail(String mem_email);

	//회원 닉네임으로 회원정보 가져오기(중복 닉네임 체크)
	public MemberVO selectMemberByNick(String mem_nick);

	//추천인코드 만들기
	public String generateUniqueRCode();

	//추천인코드 중복확인
	public boolean checkIfRCodeIsUnique(String rcode);

	//추천인 코드 대조
	public Long selectMemNumByRCode(String friend_rcode);

	//멤버 토탈 불러오기
	public MemberTotalVO selectMemberTotal(long mem_num);

	//결제내역 카운트
	public int selectMemberPaymentCount(Map<String, Object> map);

	//결제내역 가져오기
	public List<PaymentVO> selectMemberPayment(Map<String, Object> map);

	//프로필사진 업데이트
	public void updateMemPhoto(MemberVO memberVO);

	//회원정보 수정
	public void updateMember(MemberVO memberVO);

	//비밀번호 수정
	public void updatePassword(MemberVO memberVO);

	//비밀번호 변경 인증코드 발급
	public String getPasswordVerificationCode();

	//회원 포인트 업데이트
	public void updateMemPoint(PointVO pointVO);

	//관리자
	//회원 리스트 선택
	public List<MemberVO> selectMemberList(Map<String, Object> map);

	//회원 레코드 수 선택
	public int selectMemberCount(Map<String, Object> map);

	//회원 status 변경
	public void updateMemStatus(MemberVO memberVO);
	
	//회원 등급 변경
	public void updateMemAuth(long mem_num,int member_auth);
	
	//회원 전체 리스트 불러오기(등업용,일반회원 이상)
	public List<MemberVO> selectAllMemberList();
}
