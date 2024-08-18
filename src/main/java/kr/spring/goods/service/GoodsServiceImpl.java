package kr.spring.goods.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import kr.spring.goods.dao.GoodsMapper;
import kr.spring.goods.vo.GoodsVO;



@Service
@Transactional
public class GoodsServiceImpl implements GoodsService {
    @Autowired
    GoodsMapper goodsMapper;


    @Override
    public void insertGoods(GoodsVO goods) {
        goodsMapper.insertGoods(goods);
    }

    @Override
    public List<GoodsVO> selectList(Map<String, Object> map, Integer mem_status) {
        if (mem_status == null || mem_status != 9) {
            map.put("item_status", 1); // 일반 사용자라면 item_status가 1인 상품만 조회하도록 필터링
        }
        return goodsMapper.selectList(map);
    }

    @Override
    public Integer selectRowCount(Map<String, Object> map) {
        return goodsMapper.selectRowCount(map);
    }

    @Override
    public void updateGoods(GoodsVO goodsVO) {
        goodsMapper.updateGoods(goodsVO);
    }

    @Override
    public GoodsVO detailGoods(long item_num) {
        return goodsMapper.detailGoods(item_num);
    }

    @Override
    public void deleteGoods(long item_num) {
        goodsMapper.deleteCartItems(item_num); // 자식 레코드 먼저 삭제
        goodsMapper.deleteGoods(item_num); // 부모 레코드 삭제
    }
    @Override
    public List<Map<String, Object>> getCategories() {
        return goodsMapper.getCategories();
    }

	@Override
	public void updatePayStatus(long purchase_num, long pay_status) {
		goodsMapper.updatePayStatus(purchase_num, pay_status);
	}

	 @Override
	    public GoodsVO todayGoods() {
	        return goodsMapper.selectTodayGoods(); // 최신 상품 하나만 반환
	    }
   
}
