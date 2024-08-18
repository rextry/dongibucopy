package kr.spring.refund.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.refund.dao.RefundMapper;
import kr.spring.refund.vo.RefundVO;

@Service
@Transactional
public class RefundServiceImpl implements RefundService{
	@Autowired
	RefundMapper refundMapper;

	@Override
	public void insertRefund(RefundVO refundVO) {
		refundMapper.insertRefund(refundVO);
	}

	@Override
	public List<RefundVO> getRefundList(Map<String,Object> map) {
		return refundMapper.getRefundList(map);
	}

	@Override
	public List<RefundVO> getRefundListByMemnum(Map<String,Object> map) {
		return refundMapper.getRefundListByMemnum(map);
	}

	@Override
	public void deleteRefund(long refund_num) {
		refundMapper.deleteRefund(refund_num);
	}

	@Override
	public void updateRefundStatus(long refund_num, int status) {
		refundMapper.updateRefundStatus(refund_num, status);
	}

	@Override
	public int getRefundCount(Map<String, Object> map) {
		return refundMapper.getRefundCount(map);
	}

	@Override
	public RefundVO getRefundVOByReNum(long refund_num) {
		return refundMapper.getRefundVOByReNum(refund_num);
	}
}
