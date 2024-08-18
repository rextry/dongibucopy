package kr.spring.member.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.util.FileUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyPageAjaxController {
	@Autowired
	private MemberService memberService;

	/*===============================
	   		프로필 사진 수정
	================================*/
	@PostMapping("/member/myPage/modifyMemPhoto")
	@ResponseBody
	public Map<String, String> processMemPhoto(MemberVO memberVO, HttpSession session, HttpServletRequest request) {
		// ajax 통신이기 때문에 인터셉터를 쓰면 안됨(로그인 화면이 중간에 보여질 수 없음)
		Map<String, String> mapAjax = new HashMap<String, String>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		if (user == null) {
			mapAjax.put("result", "logout");
		} else { // 로그인 된 경우
			try {
				if (memberVO.getUpload() != null) {
					// 파일명이 존재할 경우
					// 파일 업로드
					String filename = FileUtil.createFile(request, memberVO.getUpload());

					// 기존 파일 삭제
					FileUtil.removeFile(request, user.getMem_photo());

					// db에 저장
					memberVO.setMem_num(user.getMem_num());
					memberVO.setMem_photo(filename);

					memberService.updateMemPhoto(memberVO);

					// 세션에 저장된 user 정보 업데이트
					user.setMem_photo(filename);

					// 세션에 업데이트된 user 객체 저장
					session.setAttribute("user", user);

					log.debug("<<프로필 사진 세션 저장>> : " + user.getMem_photo());

					mapAjax.put("result", "success");
				}
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				mapAjax.put("result", "error");
			}
		}

		return mapAjax;
	}

	/*===============================
			프로필 사진 삭제
	================================*/
	@PostMapping("member/myPage/deleteMemPhoto")
	@ResponseBody
	public Map<String, String> deleteMemPhoto(HttpSession session, HttpServletRequest request) {
		// ajax 통신이기 때문에 인터셉터를 쓰면 안됨(로그인 화면이 중간에 보여질 수 없음)
		Map<String, String> mapAjax = new HashMap<String, String>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		if (user == null) {
			mapAjax.put("result", "logout");
		} else { // 로그인 된 경우
			try {

				// 기존 파일 삭제
				FileUtil.removeFile(request, user.getMem_photo());

				// db에 저장
				MemberVO memberVO = new MemberVO();
				memberVO.setMem_num(user.getMem_num());
				memberVO.setMem_photo("");

				memberService.updateMemPhoto(memberVO);

				// 세션에 저장된 user 정보 업데이트
				user.setMem_photo("");

				// 세션에 업데이트된 user 객체 저장
				session.setAttribute("user", user);

				log.debug("<<프로필 사진 삭제>>");

				mapAjax.put("result", "success");

			} catch (IllegalStateException e) {
				e.printStackTrace();
				mapAjax.put("result", "error");
			}
		}

		return mapAjax;
	}

	/*===============================
			비밀번호 확인
	================================*/
	@PostMapping("member/myPage/checkPassword")
	@ResponseBody
	public Map<String, String> checkPassword(HttpSession session, HttpServletRequest request) {
		Map<String, String> mapAjax = new HashMap<String, String>();
		MemberVO user = (MemberVO) session.getAttribute("user");
		
		if (user == null) {
			mapAjax.put("result", "logout");
		} else {
			MemberVO memberVO = memberService.selectMember(user.getMem_num());
			if (memberService.isCheckedPassword(memberVO, request.getParameter("currentPassword"))) {
				mapAjax.put("result", "matched");
			} else {
				mapAjax.put("result", "notMatched");
			}
		}
		return mapAjax;
	}
	
}



























