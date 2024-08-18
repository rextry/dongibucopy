package kr.spring.point.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import kr.spring.member.vo.MemberVO;
import kr.spring.point.vo.PointVO;

@Mapper
public interface PointMapper {
	//포인트 로그
	@Insert("INSERT INTO point_log(point_num,mem_num,pevent_type,point_amount) VALUES(point_log_seq.nextval,#{mem_num},#{pevent_type},#{point_amount})")
	public void insertPointLog(PointVO pointVO);

	//마이페이지 포인트 목록
	public List<PointVO> getMemberPointList(Map<String, Object> map);

	//마이페이지 포인트 개수
	@Select("SELECT COUNT(*) FROM point_log WHERE mem_num=#{mem_num}")
	public Integer getMPointRowCount(Map<String, Object> map);
}
