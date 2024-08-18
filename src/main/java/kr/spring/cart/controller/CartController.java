package kr.spring.cart.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import kr.spring.cart.service.CartService;
import kr.spring.cart.vo.CartVO;
import kr.spring.goods.vo.GoodsVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.util.PagingUtil;
import lombok.extern.slf4j.Slf4j;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;
@Slf4j
@Controller
public class CartController {
    @Autowired
    private CartService cartService;

    // 자바빈 초기화
    @ModelAttribute
    public CartVO initCommand() {
        return new CartVO();
    }

    /*===================================
     *          장바구니 등록
     *==================================*/
    @PostMapping("/cart/insert")
    public String insertCart(@RequestParam("item_num") long itemNum,
                             @RequestParam("cart_quantity") long cartQuantity,
                             @RequestParam("item_price") int itemPrice,
                             @RequestParam(value = "mem_num", required = false) Long memNum,
                             HttpServletRequest request,
                             Model model) throws IllegalStateException, IOException {

        if (memNum == null) {
            model.addAttribute("message", "로그아웃 상태입니다. 로그인 해주세요.");
            model.addAttribute("url", request.getContextPath() + "/member/login");
            return "common/resultAlert";
        }
        
        log.debug("<<장바구니 등록 -item_num>> : " + itemNum);
        log.debug("<<장바구니 등록 -cart_quantity>> : " + cartQuantity);

        CartVO cart = new CartVO();
        cart.setItem_num(itemNum);
        cart.setItem_price(itemPrice);
        cart.setCart_quantity(cartQuantity);
        
        cart.setMem_num(memNum);

        cartService.insertOrUpdateCart(cart);

        model.addAttribute("message", "성공적으로 상품이 등록되었습니다.");
        model.addAttribute("url", request.getContextPath() + "/cart/list");

        return "common/resultAlert";
    }

    /*===================================
     *          장바구니 목록 호출
     *==================================*/
    @GetMapping("/cart/list")
    public String getList(@RequestParam(defaultValue = "1") int pageNum,
                          Model model,HttpSession session) {
        Map<String, Object> map = new HashMap<String, Object>();
        MemberVO memberVO = (MemberVO) session.getAttribute("user");
        // 전체, 검색 레코드 수
        int count = cartService.cartRowCount(map);

        // 페이지 처리
        PagingUtil page = new PagingUtil(pageNum, count, 8, 10, "list");

        List<CartVO> list = null;
        if (count > 0) {
            map.put("start", page.getStartRow());
            map.put("end", page.getEndRow());

            list = cartService.cartList(map);
            log.debug("<<장바구니 목록>> : " + list);
        }

        model.addAttribute("count", count);
        model.addAttribute("list", list);
        model.addAttribute("page", page.getPage());

        return "cartList";
    }

    /*===================================
     *          장바구니 항목 삭제
     *==================================*/
    @GetMapping("/delete")
    @ResponseBody
    public String deleteCart(@RequestParam("cart_num") int cart_num) {
        cartService.deleteCart(cart_num);
        return "success";
    }

    /*===================================
     *   선택된 장바구니 항목들 삭제
     *==================================*/
    @PostMapping("/cart/deleteSelected")
    @ResponseBody
    public String deleteSelectedCarts(@RequestBody List<Integer> cartNums) {
        try {
            for (int cart_num : cartNums) {
                cartService.deleteCart(cart_num);
            }
            return "success";
        } catch (Exception e) {
            log.error("장바구니 항목 삭제 중 에러 발생: ", e);
            return "fail";
        }
    }

    /*===================================
     *   선택된 장바구니 항목 수량변경
     *==================================*/
    @PostMapping("/cart/updateQuantity")
    @ResponseBody
    public String updateCartQuantity(@RequestParam("cart_num") int cart_num,
                                     @RequestParam("cart_quantity") int cart_quantity) {
        try {
            cartService.updateCartQuantity(cart_num, cart_quantity);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }
}
