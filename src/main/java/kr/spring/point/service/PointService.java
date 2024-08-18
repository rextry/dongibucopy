package kr.spring.point.service;

import java.util.List;
import java.util.Map;

import kr.spring.member.vo.MemberVO;
import kr.spring.point.vo.PointVO;

public interface PointService {
	//포인트 로그찍기
	public void insertPointLog(PointVO pointVO);
	//회원별 포인트 목록
	public List<PointVO> getMemberPointList(Map<String, Object> map);
	//마이페이지 포인트 개수
	public Integer getMPointRowCount(Map<String, Object> map);
	//멤버 포인트 수정(관리자)
	public void updateMemPointByAdmin(PointVO pointVO);
}
