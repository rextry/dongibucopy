package kr.spring.goods.service;

import java.util.List;
import java.util.Map;



import kr.spring.goods.vo.GoodsVO;


public interface GoodsService {
	void insertGoods(GoodsVO goods);
    List<GoodsVO> selectList(Map<String, Object> map, Integer mem_status);
    Integer selectRowCount(Map<String, Object> map);
    void updateGoods(GoodsVO goodsVO);
    GoodsVO detailGoods(long item_num);
    void deleteGoods(long item_num);
    // 카테고리명을 가져오는 메서드 추가
    List<Map<String, Object>> getCategories();
	public void updatePayStatus(long purchase_num, long pay_status);
	GoodsVO todayGoods(); // 단일 상품 반환
}