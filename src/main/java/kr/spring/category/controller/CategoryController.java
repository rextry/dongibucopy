package kr.spring.category.controller;

import java.io.IOException;
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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.spring.category.service.CategoryService;
import kr.spring.category.vo.DonationCategoryVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.payuid.service.PayuidService;
import kr.spring.payuid.vo.PayuidVO;
import kr.spring.subscription.vo.SubscriptionVO;
import kr.spring.util.FileUtil;
import kr.spring.util.PagingUtil;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
public class CategoryController {
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private PayuidService payuidService;

	//기부 카테고리 및 기부처 리스트 호출
	@GetMapping("/admin/categoryList")
	public String categoryList(Model model) {

		Map<String,Object> map = 
				new HashMap<String,Object>();

		//전체,검색 레코드수
		int count = categoryService.getListCount(map);

		List<DonationCategoryVO> list = null;
		if(count > 0) {
			list = categoryService.selectList();
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);

		return "categoryList";
	}

	//기부 카테고리 및 기부처 등록 폼 호출
	@GetMapping("/category/insertCategory")
	public String insertCategoryForm(Model model) {
		model.addAttribute("donationCategoryVO", new DonationCategoryVO());
		return "insertCategory";
	}



	//기부 카테고리 및 기부처 등록
	@Controller
	public class DonationCategoryController {

		@Autowired
		private CategoryService categoryService;

		@PostMapping("/category/insertCategory")
		public String submit(@Valid DonationCategoryVO donationCategoryVO,
				BindingResult result,
				HttpServletRequest request,
				HttpSession session,
				Model model) throws IllegalStateException, IOException {
			// 로깅
			log.debug("<<카테고리 및 기부처 저장>> : " + donationCategoryVO);

			// 유효성 체크 결과 오류가 있으면 폼 호출
			if (result.hasErrors()) {
				if (donationCategoryVO.getIconUpload() == null || donationCategoryVO.getIconUpload().isEmpty()) {
					result.rejectValue("iconUpload", "error.iconUpload", "기부처 아이콘을 업로드해야 합니다.");
				}
				if (donationCategoryVO.getBannerUpload() == null || donationCategoryVO.getBannerUpload().isEmpty()) {
					result.rejectValue("bannerUpload", "error.bannerUpload", "기부처 배너를 업로드해야 합니다.");
				}
				return "insertCategory";
			}

			// 파일 업로드
			MultipartFile iconFile = donationCategoryVO.getIconUpload();
			MultipartFile bannerFile = donationCategoryVO.getBannerUpload();

			if (iconFile != null && !iconFile.isEmpty()) {
				String iconFileName = FileUtil.createFile(request, iconFile);
				donationCategoryVO.setDcate_icon(iconFileName);
			}

			if (bannerFile != null && !bannerFile.isEmpty()) {
				String bannerFileName = FileUtil.createFile(request, bannerFile);
				donationCategoryVO.setDcate_banner(bannerFileName);
			}

			// 기부 카테고리 등록
			categoryService.insertDonationCategory(donationCategoryVO);

			// View 메시지 처리
			model.addAttribute("message", "카테고리 및 기부처가 등록되었습니다.");
			model.addAttribute("url", request.getContextPath() + "/category/categoryList");

			return "common/resultAlert";
		}
	}

	//기부 카테고리 상세
	@GetMapping("/category/categoryDetail")
	public ModelAndView detailCategory(long dcate_num, HttpSession session, Model model) {
		model.addAttribute("subscriptionVO", new SubscriptionVO());
		log.debug("dcate_num : " + dcate_num);
		DonationCategoryVO category = categoryService.selectDonationCategory(dcate_num);
		log.debug("donationcategoryVO : " + category);
		MemberVO user = (MemberVO)session.getAttribute("user");
		
		System.out.println("user : " + user);
		
		ModelAndView modelAndView = new ModelAndView("categoryDetail");
		modelAndView.addObject("category", category);
		modelAndView.addObject("subscriptionVO", new SubscriptionVO()); // 폼 데이터 초기화
		modelAndView.addObject("user", user);
		if(user!=null) {

			List<PayuidVO> list = payuidService.getPayUId(user.getMem_num());
			model.addAttribute("list", list);
		}
		return modelAndView;
	} 

	//기부 카테고리 삭제
	@GetMapping("/category/deleteCategory")
	public String submitDelete(long dcate_num, HttpServletRequest request) {
		log.debug("<<기부 카테고리 삭제>> : dcate_num : " + dcate_num );
		DonationCategoryVO categoryVO = categoryService.selectDonationCategory(dcate_num);


		if(categoryVO.getDcate_icon()!=null) {
			FileUtil.removeFile(request, categoryVO.getDcate_icon());
		}
		categoryService.deleteDonationCategory(dcate_num);	

		return  "redirect:/category/categoryList";
	}
	// 카테고리 수정 폼 호출
	@GetMapping("/category/updateCategory")
	public String formUpdate(long dcate_num,Model model) {
		log.debug("dcate_num : " + dcate_num);
		DonationCategoryVO categoryVO = 
				categoryService.selectDonationCategory(dcate_num);
		model.addAttribute("donationCategoryVO", categoryVO);

		return "categoryUpdate";
	} 

	//카테고리 및 기부처 수정
	@PostMapping("/category/updateCategory")
	public String submitUpdate(@Valid DonationCategoryVO categoryVO, 
			BindingResult result, 
			Model model, 
			HttpServletRequest request) throws IllegalStateException, IOException {
		log.debug("<<카테고리 수정>> : " + categoryVO);

		// 유효성 체크 결과 오류가 있으면 폼 호출
		if (result.hasErrors()) {
			// 유효성 체크시 오류 있을 시 파일 정보 잃어버림
			DonationCategoryVO vo = categoryService.selectDonationCategory(categoryVO.getDcate_num());
			categoryVO.setDcate_icon(vo.getDcate_icon());
			categoryVO.setDcate_banner(vo.getDcate_banner());
			return "categoryUpdate";
		}

		// DB에 저장된 파일 정보 구하기
		DonationCategoryVO db_category = categoryService.selectDonationCategory(categoryVO.getDcate_num());

		// 파일 업로드 처리
		MultipartFile iconFile = categoryVO.getIconUpload();
		MultipartFile bannerFile = categoryVO.getBannerUpload();

		// 기존 파일명 저장
		String oldIconFilename = db_category.getDcate_icon();
		String oldBannerFilename = db_category.getDcate_banner();

		if (iconFile != null && !iconFile.isEmpty()) {
			String iconFileName = FileUtil.createFile(request, iconFile);
			categoryVO.setDcate_icon(iconFileName);
		} else {
			categoryVO.setDcate_icon(db_category.getDcate_icon());
		}

		if (bannerFile != null && !bannerFile.isEmpty()) {
			String bannerFileName = FileUtil.createFile(request, bannerFile);
			categoryVO.setDcate_banner(bannerFileName);
		} else {
			categoryVO.setDcate_banner(db_category.getDcate_banner());
		}

		// 카테고리 수정
		categoryService.updateDonationCategory(categoryVO);

		// 기존 파일 삭제 처리
		if (iconFile != null && !iconFile.isEmpty() && !categoryVO.getDcate_icon().equals(oldIconFilename)) {
			FileUtil.removeFile(request, oldIconFilename);
		}

		if (bannerFile != null && !bannerFile.isEmpty() && !categoryVO.getDcate_banner().equals(oldBannerFilename)) {
			FileUtil.removeFile(request, oldBannerFilename);
		}

		model.addAttribute("message", "카테고리 수정완료");
		model.addAttribute("url", request.getContextPath() + "/category/categoryDetail?dcate_num=" + categoryVO.getDcate_num());

		return "common/resultAlert";
	}


}
