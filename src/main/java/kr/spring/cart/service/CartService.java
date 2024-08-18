package kr.spring.cart.service;

import java.util.List;
import java.util.Map;

import kr.spring.cart.vo.CartVO;

public interface CartService {
    public void insertOrUpdateCart(CartVO cartVO); // 메서드 이름 변경
    public List<CartVO> cartList(Map<String, Object> map);
    public Integer cartRowCount(Map<String, Object> map);
    public void deleteCart(int cart_num);
    public void updateCartQuantity(int cart_num, int cart_quantity);
}
