package kr.spring.goods.controller;

import kr.spring.goods.service.PurchaseService;
import kr.spring.goods.vo.PurchaseVO;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class adminController {

    @Autowired
    private PurchaseService purchaseService;
    
    @Autowired
    private NotifyService notifyService;

    @GetMapping("/admin/purchaseList")
    public String getPurchaseList(Model model) {
        List<PurchaseVO> purchaseList = purchaseService.getAllPurchases();
        model.addAttribute("purchaseList", purchaseList);
        return "adminPurchase";
    }

    @PostMapping("/admin/updateDeliveryStatus")
    public String updateDeliveryStatus(@RequestParam("imp_uid") String impUid, @RequestParam("deliveryStatus") String deliveryStatus) {
        // 배송 상태 업데이트
        purchaseService.updateDeliveryStatusByImpUid(impUid, deliveryStatus);
        
        // PurchaseVO 가져오기
        PurchaseVO purchaseVO = purchaseService.getPurchaseByImpUid(impUid);
        
        // 알림 생성
        if (purchaseVO != null) {
            NotifyVO notifyVO = new NotifyVO();
            notifyVO.setMem_num(purchaseVO.getMem_num()); // 알림 받을 회원 번호
            
            // 알림 타입 설정 (배송 시작: 18, 배송 완료: 19 등)
            int notifyType = 0;
            if ("배송 시작".equals(deliveryStatus)) {
                notifyType = 18;
                notifyVO.setNotify_type(notifyType);
                notifyVO.setNot_url("/goods/detail?item_num=" + purchaseVO.getItem_num()); // 알림을 누르면 반환할 URL
                
                // 동적 데이터 매핑
                Map<String, String> dynamicValues = new HashMap<>();
                dynamicValues.put("purchase_num", String.valueOf(purchaseVO.getPurchase_num())); // 알림 템플릿 참조
                
                // NotifyService 호출
                notifyService.insertNotifyLog(notifyVO, dynamicValues); // 알림 로그 찍기
            } else if ("배송 완료".equals(deliveryStatus)) {
                notifyType = 19;
                notifyVO.setNotify_type(notifyType);
                notifyVO.setNot_url("/goods/detail?item_num=" + purchaseVO.getItem_num()); // 알림을 누르면 반환할 URL
                
                // 동적 데이터 매핑
                Map<String, String> dynamicValues = new HashMap<>();
                dynamicValues.put("purchase_num", String.valueOf(purchaseVO.getPurchase_num())); // 알림 템플릿 참조
                
                // NotifyService 호출
                notifyService.insertNotifyLog(notifyVO, dynamicValues); // 알림 로그 찍기
            } else {
            	return "redirect:/admin/purchaseList";
            }
            
        }
        
        return "redirect:/admin/purchaseList";
    }
}