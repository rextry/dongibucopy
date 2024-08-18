package kr.spring.goods.vo;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import kr.spring.cart.vo.CartVO;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PurchaseVO {
    private Long purchase_num;
    private long mem_num;
    private long item_num;
    private String item_name;
    private String imp_uid;
    private String Merchant_uid;
    private int amount;
    private int pay_price;
    private String buyer_name;
    private String buyer_email;
    private String item_photo;
    private Date payDate;
    private int payStatus;
    private String deliveryStatus;
    private int pamount; // 추가된 필드
    // 추가된 부분
    private int totalAmount;
    private String delivery_address; // 새로 추가된 필드
    private int point_used; // 새로 추가된 필드
    private Long cartItemNum;
    private String cartItemPrice;
    private int cartQuantity;
    private String cartItemName;
    private String cartItemPhoto;
    
    
    private List<CartVO> cart_items;
    
    public List<CartVO> getCart_items() {
        return cart_items;
    }
    public void setCart_items(List<CartVO> cart_items) {
        this.cart_items = cart_items;
    }
    public long getMem_num() {
        return mem_num;
    }

    public void setMem_num(long mem_num) {
        this.mem_num = mem_num;
    }
}