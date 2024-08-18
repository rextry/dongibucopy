package kr.spring.category.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.spring.category.service.CategoryService;
import kr.spring.category.vo.DonationCategoryVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.util.FileUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CategoryAjaxController {
	@Autowired
	private CategoryService categoryService;
	
	//업로드 파일 삭제
	@PostMapping("/category/deleteFile")
	@ResponseBody
	public Map<String,String> processFile(
						  Long dcate_num,
			              HttpSession session,
			              HttpServletRequest request){
		log.debug("업로드 파일 삭제 dcate_num : " + dcate_num);
		Map<String,String> mapJson = 
				      new HashMap<String,String>();
		MemberVO user = 
				(MemberVO)session.getAttribute("user");
		if(user==null) {
			mapJson.put("result", "logout");
		}else {
			DonationCategoryVO db_category = 
					categoryService.selectDonationCategory(dcate_num); 
			//로그인한 회원번호와 작성자 회원번호 일치 여부 체크
			categoryService.deleteFile(dcate_num);
			FileUtil.removeFile(request, db_category.getDcate_icon());
			
			mapJson.put("result", "success");
			}
		return mapJson;
	}
}








