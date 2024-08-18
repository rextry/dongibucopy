package kr.spring.data.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.data.dao.DataMapper;
import kr.spring.data.vo.TotalVO;

@Service
@Transactional
public class DataServiceImpl implements DataService {
	
	@Autowired
	DataMapper dataMapper;

	@Override
	public TotalVO selectTotalMain() {
		return dataMapper.selectTotalMain();
	}

}
