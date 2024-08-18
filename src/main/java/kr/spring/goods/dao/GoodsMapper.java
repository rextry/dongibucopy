package kr.spring.goods.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.goods.vo.GoodsVO;

@Mapper
public interface GoodsMapper {
	public List<GoodsVO> selectList(Map<String,Object> map);
	public Integer selectRowCount(Map<String,Object> map);
	//상품 등록 - xml
	public void insertGoods(GoodsVO goods);
	//상품 상세
	@Select("SELECT * FROM item WHERE item_num=#{item_num}")
	public GoodsVO detailGoods(long item_num);
	//@Update("UPDATE item SET item_name=#{item_name}, item_price=#{item_price},item_stock=#{item_stock}, item_photo=#{item_photo,jdbcType=VARCHAR}, item_detail=#{item_detail}, dcate_num=#{dcate_num}, item_status=#{item_status} WHERE item_num=#{item_num}")
	public void updateGoods(GoodsVO goods);
	 @Delete("DELETE FROM item WHERE item_num=#{item_num}")
	public void deleteGoods(long item_num);
	// 자식 레코드 삭제 메서드 추가
	@Delete("DELETE FROM cart WHERE item_num = #{item_num}")
	public void deleteCartItems(long item_num);
	void updateStock(Map<String, Object> paramMap);
	public GoodsVO selectTodayGoods();
	List<Map<String, Object>> getCategories();
	
	//환불신청시 결제상태 변경
	@Update("UPDATE purchase SET pay_status=#{pay_status} WHERE purchase_num=#{purchase_num}")
	public void updatePayStatus(long purchase_num, long pay_status);
}
