package kr.spring.goods.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.cart.dao.CartMapper;
import kr.spring.cart.service.CartService;
import kr.spring.cart.vo.CartVO;
import kr.spring.goods.dao.GoodsMapper;
import kr.spring.goods.dao.PurchaseMapper;
import kr.spring.goods.vo.PurchaseVO;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PurchaseServiceImpl implements PurchaseService {

    @Autowired
    private PurchaseMapper purchaseMapper;
    
    @Autowired
    private GoodsMapper goodsMapper;
    
    @Override
    public void insertPurchase(PurchaseVO purchaseVO) {
        purchaseMapper.insertPurchase(purchaseVO);
        
    }
    
    @Autowired
	NotifyService notifyService;

    @Override
    @Transactional
    public void insertPurchaseWithCartItems(PurchaseVO purchaseVO) {
    	 Long purchaseNum = purchaseMapper.getSeq();
         purchaseVO.setPurchase_num(purchaseNum);
        // 1. purchase 테이블에 데이터 삽입
        purchaseMapper.insertPurchaseWithCartItems(purchaseVO);
        log.debug("Inserted purchase: " + purchaseVO);
        
     // 2. 각 CartVO에 purchaseNum 설정 및 purchase_item 테이블에 삽입
        for (CartVO cartItem : purchaseVO.getCart_items()) {
            cartItem.setPurchase_num(purchaseVO.getPurchase_num());
            purchaseMapper.insertPurchaseItems(cartItem);
            log.debug("Inserted purchase item: " + cartItem);
        }
        
    }
    @Override
    public List<CartVO> getPurchaseItems(long purchase_num) {
        return purchaseMapper.getPurchaseItems(purchase_num);
    }

	/*
	 * @Override public void processRefund(RefundVO refundVO) {
	 * purchaseMapper.insertRefund(refundVO); }
	 */
    public List<PurchaseVO> getPurchaseListByMember(long memNum) {
        List<PurchaseVO> purchaseList = purchaseMapper.getPurchaseListByMember(memNum);
        for (PurchaseVO purchase : purchaseList) {
            if (purchase.getPurchase_num() != null) {
                List<CartVO> cartItems = purchaseMapper.getPurchaseItems(purchase.getPurchase_num());
                purchase.setCart_items(cartItems);
            } else {
                log.error("purchaseNum is null for purchase: " + purchase);
            }
        }
        return purchaseList;
    }

    @Override
    public Long getLastInsertedPurchaseNum() throws Exception {
        return purchaseMapper.getLastInsertedPurchaseNum();
    }
    
    @Override
    public List<PurchaseVO> getAllPurchases() {
        return purchaseMapper.getAllPurchases();
    }
    
    @Override
    public PurchaseVO getPurchaseByImpUid(String impUid) {
        return purchaseMapper.getPurchaseByImpUid(impUid); // 새로운 메소드 구현
    }
    
    @Override
    public void updateDeliveryStatus(int purchaseNum, String deliveryStatus) {
        purchaseMapper.updateDeliveryStatus(purchaseNum, deliveryStatus);
    }
    
    @Override
    public void updateDeliveryStatusByImpUid(String impUid, String deliveryStatus) {
        purchaseMapper.updateDeliveryStatusByImpUid(impUid, deliveryStatus);
    }
    
    @Override
    public void updateRefundStatus(String impUid, int status) {
        purchaseMapper.updateRefundStatus(impUid, status);
    }


	@Override
	public Long getSeq() {
		return purchaseMapper.getSeq();
	}

	@Override
	public void insertPurchaseItems(CartVO cartItem) {
		purchaseMapper.insertPurchaseItems(cartItem);
		
	}
	
	 @Override
	    public void updateStock(Long item_num, Long cart_quantity, Integer quantity) {
	        Map<String, Object> paramMap = new HashMap<>();
	        paramMap.put("item_num", item_num);
	        paramMap.put("cart_quantity", cart_quantity);
	        paramMap.put("quantity", quantity);
	        goodsMapper.updateStock(paramMap);
	    }

	
	 @Override
	    @Transactional
	    public void updateStock(Map<String, Object> paramMap) {
	        goodsMapper.updateStock(paramMap);
	    }

	

	
}