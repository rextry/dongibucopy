package kr.spring.cart.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.cart.dao.CartMapper;
import kr.spring.cart.vo.CartVO;

@Service
@Transactional
public class CartServiceImpl implements CartService {

    @Autowired
    CartMapper cartMapper;

    @Override
    public void insertOrUpdateCart(CartVO cartVO) {
        // 기존 항목이 있는지 확인
        int count = cartMapper.checkCartItem(cartVO);
        if (count > 0) {
            // 기존 항목이 있으면 수량 업데이트
            cartMapper.updateCartQuantity(cartVO);
        } else {
            // 기존 항목이 없으면 새로 삽입
            cartMapper.insertCart(cartVO);
        }
    }

    @Override
    public List<CartVO> cartList(Map<String, Object> map) {
        return cartMapper.cartList(map);
    }

    @Override
    public Integer cartRowCount(Map<String, Object> map) {
        return cartMapper.cartRowCount(map);
    }

    @Override
    public void deleteCart(int cart_num) {
        cartMapper.deleteCart(cart_num);
    }

    @Override
    public void updateCartQuantity(int cart_num, int cart_quantity) {
        cartMapper.updateCartQuantityByCartNum(cart_num, cart_quantity);
    }
}
