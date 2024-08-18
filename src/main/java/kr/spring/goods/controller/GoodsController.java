package kr.spring.goods.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;

import org.springframework.web.bind.annotation.PostMapping;

import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.web.servlet.ModelAndView;

import kr.spring.category.service.CategoryService;
import kr.spring.category.vo.DonationCategoryVO;
import kr.spring.goods.service.GoodsService;
import kr.spring.goods.util.fileUtil;
import kr.spring.goods.vo.GoodsVO;

import kr.spring.member.vo.MemberVO;
import kr.spring.util.PagingUtil;
import kr.spring.util.StringUtil;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
public class GoodsController {
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private CategoryService categoryService;  // CategoryService 주입
    
    // 자바빈 초기화
    @ModelAttribute
    public GoodsVO initCommand() {
        return new GoodsVO();
    }

    /*===================================
     * 상품 목록 호출
     *==================================*/
    @GetMapping("/goods/list")
    public String getlist(@RequestParam(defaultValue="1") int pageNum,
                          @RequestParam(defaultValue="0") int order,
                          @RequestParam(defaultValue="0") int dcate_num,
                          String keyfield, String keyword, Model model, HttpSession session) {

        MemberVO user = (MemberVO) session.getAttribute("user");
        Integer mem_status = user != null ? user.getMem_status() : null;

        log.debug("<<mem_status>> : " + mem_status);
        log.debug("<<상품 목록 - category>> : " + dcate_num);
        log.debug("<<상품 목록 - order>> : " + order);

        Map<String, Object> map = new HashMap<>();
        map.put("dcate_num", dcate_num);
        map.put("keyfield", keyfield);
        map.put("keyword", keyword);

        int count = goodsService.selectRowCount(map);

        PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, count, 20, 10, "list", "&dcate_num=" + dcate_num + "&order=" + order);

        List<GoodsVO> list = null;
        if (count > 0) {
            map.put("order", order);
            map.put("start", page.getStartRow());
            map.put("end", page.getEndRow());

            list = goodsService.selectList(map, mem_status);
        }

        // 카테고리 정보 가져오기
        List<Map<String, Object>> categories = goodsService.getCategories();
        Map<Integer, String> categoriesMap = new HashMap<>();
        for (Map<String, Object> category : categories) {
            Integer categoryId = ((BigDecimal) category.get("DCATE_NUM")).intValue();
            String categoryName = (String) category.get("DCATE_NAME");
            categoriesMap.put(categoryId, categoryName);
        }
        model.addAttribute("categories", categoriesMap);

        model.addAttribute("count", count);
        model.addAttribute("list", list);
        model.addAttribute("page", page.getPage());
        model.addAttribute("dcate_num", dcate_num);

        return "goodsList";
    }
    /*===================================
     * 상품 상세
     *==================================*/
    @GetMapping("/goods/detail")
    public ModelAndView process(long item_num) {
        log.debug("<<게시판 글 상세 - item_num>> :" + item_num);

        GoodsVO goods = goodsService.detailGoods(item_num);
        goods.setItem_name(StringUtil.useNoHTML(goods.getItem_name()));

        return new ModelAndView("goodsView", "goods", goods);
    }

    /*===================================
     * 상품 등록(관리자)
     *==================================*/
    @GetMapping("/goods/write")
    public String form() {
        return "goodsWrite";
    }

    @PostMapping("/goods/write")
    public String submit(@Valid GoodsVO goodsVO,
                         BindingResult result,
                         HttpServletRequest request,
                         HttpSession session,
                         Model model) throws IllegalStateException, IOException {

        // 세션에서 Member_status 가져오기
        MemberVO user = (MemberVO) session.getAttribute("user");
        Integer member_status = user != null ? user.getMem_status() : null;

        // Member_status가 9가 아닌 경우 접근을 거부
        if (member_status == null || member_status != 9) {
            model.addAttribute("message", "관리자만 접근 가능합니다.");
            model.addAttribute("uri", "/goods/list");
            return "common/resultAlert";
        }

        log.debug("<<상품 등록>> : " + goodsVO);

        if (goodsVO.getUpload() == null || goodsVO.getUpload().isEmpty()) {
            result.rejectValue("upload", "fileNotFound");
        }

        // 유효성 체크 결과가 오류가 있으면 폼 호출
        if (result.hasErrors()) {
            for (FieldError f : result.getFieldErrors()) {
                log.debug("에러 필드 : " + f.getField());
            }
            return form();
        }

        // 상품 사진 업로드 처리
        String uploadedFileName = fileUtil.createFile(request, goodsVO.getUpload());
        goodsVO.setItem_photo(uploadedFileName);

        goodsService.insertGoods(goodsVO);

        model.addAttribute("message", "성공적으로 상품이 등록되었습니다.");
        model.addAttribute("uri", request.getContextPath() + "/goods/list");

        return "redirect:/goods/list";
    }

    /*===================================
     * 상품 수정하기
     *==================================*/
    @GetMapping("/goods/update")
    public String updateForm(@RequestParam("item_num") long item_num, HttpSession session, Model model) {
        MemberVO user = (MemberVO) session.getAttribute("user");

        if (user == null || user.getMem_status() != 9) {
            model.addAttribute("message", "관리자만 접근 가능.");
            model.addAttribute("uri", "/goods/list");
            return "common/resultAlert";
        }

        // 정상적으로 접근 가능한 경우 처리 로직
        GoodsVO goods = goodsService.detailGoods(item_num);
        model.addAttribute("goodsVO", goods);

        return "goods/goodsUpdate"; // 수정 페이지로 이동
    }

    @PostMapping("/goods/update")
    public String updateSubmit(@Valid @ModelAttribute("goodsVO") GoodsVO goodsVO, BindingResult result, HttpSession session, Model model) {
        // 세션에서 member_status 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
        Integer member_status = user != null ? user.getMem_status() : null;

        if (member_status == null || member_status != 9) {
            model.addAttribute("message", "관리자만 접근 가능합니다.");
            model.addAttribute("uri", "/goods/list");
            return "common/resultAlert";
        }

        // 유효성 검사 실패 시
        if (result.hasErrors()) {
            return "goods/goodsUpdate";
        }

        // 기존 데이터를 가져와서 null 체크 후 값 유지
        GoodsVO existingGoods = goodsService.detailGoods(goodsVO.getItem_num());

        if (goodsVO.getItem_photo() == null || goodsVO.getItem_photo().isEmpty()) {
            goodsVO.setItem_photo(existingGoods.getItem_photo());
        }
        if (goodsVO.getItem_name() == null || goodsVO.getItem_name().isEmpty()) {
            goodsVO.setItem_name(existingGoods.getItem_name());
        }
        if (goodsVO.getItem_price() == null) {
            goodsVO.setItem_price(existingGoods.getItem_price());
        }
        if (goodsVO.getItem_stock() == null) {
            goodsVO.setItem_stock(existingGoods.getItem_stock());
        }
        if (goodsVO.getItem_detail() == null || goodsVO.getItem_detail().isEmpty()) {
            goodsVO.setItem_detail(existingGoods.getItem_detail());
        }
        if (goodsVO.getDcate_num() == null) {
            goodsVO.setDcate_num(existingGoods.getDcate_num());
        }
        if (goodsVO.getItem_status() == null) {
            goodsVO.setItem_status(existingGoods.getItem_status());
        }

        goodsService.updateGoods(goodsVO);

        // 수정 완료 후 메시지를 띄운 뒤 상품 목록 페이지로 리디렉션
        model.addAttribute("message", "상품 정보가 수정되었습니다.");
        model.addAttribute("uri", "/goods/list");
        return "redirect:/goods/list";
    }

    /*===================================
     * 상품 삭제
     *==================================*/
    @GetMapping("/goods/delete")
    public String deleteSubmit1(@RequestParam("item_num") long item_num, HttpSession session, Model model) {
        // 세션에서 member_status 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
        Integer member_status = user != null ? user.getMem_status() : null;

        if (member_status == null || member_status != 9) {
            model.addAttribute("message", "관리자만 접근 가능합니다.");
            model.addAttribute("uri", "/goods/list");
            return "common/resultAlert";
        }

        goodsService.deleteGoods(item_num);

        return "redirect:/goods/list";
    }

    @PostMapping("/goods/delete")
    public String deleteSubmit(@RequestParam("item_num") long item_num, HttpSession session, Model model) {
        // 세션에서 member_status 확인
        MemberVO user = (MemberVO) session.getAttribute("user");
        Integer memberStatus = user != null ? user.getMem_status() : null;

        if (memberStatus == null || memberStatus != 9) {
            model.addAttribute("message", "관리자만 접근 가능합니다.");
            model.addAttribute("uri", "/goods/list");
            return "redirect:/goods/list";
        }

        goodsService.deleteGoods(item_num);

        model.addAttribute("message", "상품이 삭제되었습니다.");
        model.addAttribute("uri", "/goods/list");
        return "redirect:/goods/list";
    }


    
}
