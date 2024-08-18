package kr.spring.subscription.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.subscription.dao.Sub_paymentMapper;
import kr.spring.subscription.vo.Sub_paymentVO;

@Service
@Transactional
public class Sub_paymentServiceImpl implements Sub_paymentService{
	@Autowired
	Sub_paymentMapper Sub_paymentMapper;
	
	@Override
	public void insertSub_payment(Sub_paymentVO subpaymentVO) {
		Sub_paymentMapper.insertSub_payment(subpaymentVO);
	}

	@Override
	public long getSub_payment_num() {
		return Sub_paymentMapper.getSub_payment_num();
	}

	@Override
	public Sub_paymentVO getSub_paymentByDate(long mem_num) {
		return Sub_paymentMapper.getSub_paymentByDate(mem_num);
	}

	@Override
	public List<Sub_paymentVO> getSub_payment() {
		return Sub_paymentMapper.getSub_payment();
	}

	@Override
	public List<Sub_paymentVO> getSub_paymentByMem_num(Map<String,Object> map) {
		return Sub_paymentMapper.getSub_paymentByMem_num(map);
	}

	@Override
	public int getSub_paymentCountByMem_num(Map<String,Object> map) {
		return Sub_paymentMapper.getSub_paymentCountByMem_num(map);
	}

	@Override
	public List<Sub_paymentVO> getSub_paymentBySub_num(long sub_num) {
		return Sub_paymentMapper.getSub_paymentBySub_num(sub_num);
	}

	@Override
	public void updateSubPayStatus(long sub_pay_num, long sub_pay_status) {
		Sub_paymentMapper.updateSubPayStatus(sub_pay_num, sub_pay_status);
	}

}
