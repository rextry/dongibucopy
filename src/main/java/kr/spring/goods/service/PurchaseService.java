package kr.spring.goods.service;

import java.util.List;
import java.util.Map;

import kr.spring.cart.vo.CartVO;
import kr.spring.goods.vo.PurchaseVO;

public interface PurchaseService {
	void insertPurchase(PurchaseVO purchaseVO);
    List<CartVO> getPurchaseItems(long purchase_num);

	/* void processRefund(RefundVO refundVO); */
    List<PurchaseVO> getPurchaseListByMember(long memNum);
    List<PurchaseVO> getAllPurchases();
    void updateDeliveryStatus(int purchaseNum, String deliveryStatus);
    void updateRefundStatus(String impUid, int status);
    void insertPurchaseWithCartItems(PurchaseVO purchaseVO);
    void insertPurchaseItems(CartVO cartVO);
    Long getSeq();
    void updateDeliveryStatusByImpUid(String impUid, String deliveryStatus);
    void updateStock(Map<String, Object> paramMap);
    void updateStock(Long item_num, Long cart_quantity, Integer quantity);
    Long getLastInsertedPurchaseNum() throws Exception; // 추가된 메서드
    PurchaseVO getPurchaseByImpUid(String impUid); // 새로운 메소드 추가
}