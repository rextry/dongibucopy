package kr.spring.member.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.siot.IamportRestClient.exception.IamportResponseException;

import kr.spring.cs.vo.FaqVO;
import kr.spring.member.service.MemberDeleteService;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.point.service.PointService;
import kr.spring.point.vo.PointVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MemberAjaxController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PointService pointService;
	
	@Autowired
	private NotifyService notifyService;
	
	@Autowired
	private MemberDeleteService memberDeleteService;

	/*===============================
	   		이메일 중복 체크
	================================*/
	@GetMapping("/member/checkEmail")
	@ResponseBody
	public Map<String, String> checkEmail(MemberVO memberVO) {
		log.debug("<<이메일 중복체크>> : " + memberVO.getMem_email());
		
		Map<String, String> mapAjax = new HashMap<String, String>();

		MemberVO existingMember = memberService.selectMemberByEmail(memberVO.getMem_email());

		if (existingMember != null) {
			mapAjax.put("result", "exist");
		} else {
			mapAjax.put("result", "notExist");
		}

		return mapAjax;
	}

	/*===============================
		닉네임 중복 체크
	================================*/
	@GetMapping("/member/checkNick")
	@ResponseBody
	public Map<String, String> checkNick(MemberVO memberVO, HttpSession session) {
		log.debug("<<닉네임 중복체크>> : " + memberVO.getMem_nick());
		
		Map<String, String> mapAjax = new HashMap<String, String>();

		MemberVO existingMember = memberService.selectMemberByNick(memberVO.getMem_nick());

		if (existingMember != null) {
			mapAjax.put("result", "exist");
		} else {
			mapAjax.put("result", "notExist");
		}
		
		//회원정보 수정 페이지에서 중복체크 할 경우
		MemberVO user = (MemberVO)session.getAttribute("user");
		if (user != null && existingMember != null) {
			if (user.getMem_nick().equals(memberVO.getMem_nick())) {
				mapAjax.put("result", "notChanged");
			}
		}
		log.debug("<<닉네임 중복체크>> : " + mapAjax.toString());
		return mapAjax;
	}
	
	/*===============================
			비밀번호 인증번호 검증
	================================*/
	//비밀번호 인증번호 검증
	@GetMapping("/member/findPasswordResult/verify")
	@ResponseBody
	public Map<String, Object> verifyVCode(String vcode, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();
		
		String verificationCode = (String) session.getAttribute("verificationCode");
		
		log.debug("<<세션 vcode>> : " + verificationCode);
		log.debug("<<사용자 vcode>> : " + vcode);
		if (verificationCode.equals(vcode)) {
			mapAjax.put("result", "isVerified");
		} else {
			mapAjax.put("result", "isNotVerified");
		}
		
		return mapAjax;
	}
	
	/*===================================
	 * 				회원 알림
	 *==================================*/
	//안읽은 알림 개수
	@ResponseBody
	@GetMapping("/member/getUnreadCount")
	public Map<String, Object> getUnreadCount(HttpSession session, Model model) {
		MemberVO user = (MemberVO) session.getAttribute("user");
		Map<String, Object> mapAjax = new HashMap<String, Object>();
		
		if (user == null) {
			mapAjax.put("result", "logout");
		} else {
			int unreadCount = notifyService.countUnreadNot(user.getMem_num());
			mapAjax.put("unreadCount", unreadCount);
			mapAjax.put("result", "success");	
		}
		
		return mapAjax;
	}
	
	
	//알림 목록
	@ResponseBody
	@GetMapping("/member/getNotification")
	public Map<String, Object> getNotification(HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else {
			List<NotifyVO> list = notifyService.selectNotListByMemNum(user.getMem_num());
			log.debug("<<회원 알림>> : " + list);
			mapAjax.put("list", list);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}
	
	//알림 읽기
	@ResponseBody
	@PostMapping("/member/readNotification")
	public Map<String, Object> readNotification(long not_num, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else {
			notifyService.readNotifyLog(not_num);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}

	/*===================================
	 * 			관리자 회원관리
	 *==================================*/
	//회원 정지
	@ResponseBody
	@PostMapping("/admin/suspendMember")
	public Map<String, Object> suspendMemberAjax(long mem_num, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			MemberVO memberVO = new MemberVO();
			memberVO.setMem_num(mem_num);
			memberVO.setMem_status(1);
			memberService.updateMemStatus(memberVO);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}
	
	//회원 사용
	@ResponseBody
	@PostMapping("/admin/activateMember")
	public Map<String, Object> activateMemberAjax(long mem_num, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			MemberVO memberVO = new MemberVO();
			memberVO.setMem_num(mem_num);
			memberVO.setMem_status(2);
			memberService.updateMemStatus(memberVO);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}
	
	//회원 제명 
	@ResponseBody
	@PostMapping("/admin/expelMember")
	public Map<String, Object> ExpelMemberAjax(long mem_num, HttpSession session) throws IamportResponseException, IOException {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			memberDeleteService.deleteAccount(mem_num);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}
	
	//관리자 포인트 수정
	@ResponseBody
	@PostMapping("/admin/updatePoint")
	public Map<String, Object> updatePointAjax(long mem_num, int mem_point, HttpSession session) {
		Map<String, Object> mapAjax = new HashMap<String, Object>();

		MemberVO user = (MemberVO) session.getAttribute("user");

		if (user == null) {
			// 로그인 안 됨
			mapAjax.put("result", "logout");
		} else if (user.getMem_status() != 9) {
			mapAjax.put("result", "noAuthority");
		} else {
			PointVO pointVO = new PointVO(50, mem_point, mem_num);
			pointService.updateMemPointByAdmin(pointVO);
			mapAjax.put("result", "success");
		}

		return mapAjax;
	}
}
