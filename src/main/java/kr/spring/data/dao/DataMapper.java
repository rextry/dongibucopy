package kr.spring.data.dao;

import org.apache.ibatis.annotations.Mapper;

import kr.spring.data.vo.TotalVO;

@Mapper
public interface DataMapper {
	//메인페이지 누적기부횟수, 누적기부금
	public TotalVO selectTotalMain();
}
