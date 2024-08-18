package kr.spring.cart.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.cart.vo.CartVO;

@Mapper
public interface CartMapper {
	//장바구니 목록 출력
	public List<CartVO>cartList(Map<String,Object>map);
	public Integer cartRowCount(Map<String, Object> map);
	int checkCartItem(CartVO cartVO); // 항목 존재 여부 확인
    void updateCartQuantity(CartVO cartVO); // 수량 업데이트
    void insertCart(CartVO cartVO); // 항목 삽입
	//장바구니 아이템 삭제
	@Delete("DELETE FROM cart WHERE cart_num=#{cart_num}")
	public void deleteCart(int cart_num);
	CartVO selectCart(int cart_num);
	 // 장바구니 아이템 수량 업데이트
    @Update("UPDATE cart SET cart_quantity = #{cart_quantity} WHERE cart_num = #{cart_num}")
    public void updateCartQuantityByCartNum(@Param("cart_num") int cart_num, @Param("cart_quantity") int cart_quantity);
    
    //회원탈퇴
    //회원별 cart_num 구하기
    @Select("DELETE FROM cart WHERE mem_num=#{mem_num}")
    public List<CartVO> deleteCartsByMember(long mem_num);
    
}
