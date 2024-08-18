package kr.spring.point.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.member.dao.MemberMapper;
import kr.spring.point.dao.PointMapper;
import kr.spring.point.vo.PointVO;

@Service
@Transactional
public class PointServiceImpl implements PointService {
	
	@Autowired
	PointMapper pointMapper;
	
	@Autowired
	MemberMapper memberMapper;
	
	//포인트 로그
	public void insertPointLog(PointVO pointVO) {
		pointMapper.insertPointLog(pointVO);
	}

	@Override
	public List<PointVO> getMemberPointList(Map<String, Object> map) {
		return pointMapper.getMemberPointList(map);
	}

	@Override
	public Integer getMPointRowCount(Map<String, Object> map) {
		return pointMapper.getMPointRowCount(map);
	}

	//관리자
	@Override
	public void updateMemPointByAdmin(PointVO pointVO) {
		PointVO pointVO2 = new PointVO();
		pointVO2.setPoint_amount(pointVO.getPoint_amount() - memberMapper.selectMemberDetail(pointVO.getMem_num()).getMem_point());
		pointVO2.setPevent_type(pointVO.getPevent_type());
		pointVO2.setMem_num(pointVO.getMem_num());
		memberMapper.updateMemPointByAdmin(pointVO);
		pointMapper.insertPointLog(pointVO2);
	}
	
}
