package kr.spring.payuid.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.payuid.dao.PayuidMapper;
import kr.spring.payuid.vo.PayuidVO;

@Service
@Transactional
public class PayuidServiceImpl implements PayuidService{
	
	@Autowired
	PayuidMapper payuidMapper;
	
	@Override
	public void registerPayUId(PayuidVO payuidVO) {
		payuidMapper.registerPayUId(payuidVO);
	}

	@Override
	public void deletePayuid(String pay_uid) {
		payuidMapper.deletePayuid(pay_uid);
	}

	@Override
	public List<PayuidVO> getPayUId(long mem_num) {
		return payuidMapper.getPayUId(mem_num);
	}

	@Override
	public PayuidVO getPayuidByMethod(PayuidVO payuidVO) {
		return payuidMapper.getPayuidByMethod(payuidVO);
	}

	@Override
	public PayuidVO getPayuidVOByPayuid(String pay_uid) {
		return payuidMapper.getPayuidVOByPayuid(pay_uid);
	}

	@Override
	public String generateUUIDFromMem_num(long mem_num) {
		String source = String.valueOf(mem_num);
        String uuid = source + UUID.randomUUID();
        return uuid.toString();
	}


}
