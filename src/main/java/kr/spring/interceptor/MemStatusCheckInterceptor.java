package kr.spring.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import kr.spring.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MemStatusCheckInterceptor implements HandlerInterceptor {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		log.debug("<<MemStatusCheckInterceptor 진입>>");

		HttpSession session = request.getSession();
		MemberVO user = (MemberVO) session.getAttribute("user");

		//일반/관리자/정지회원 검사
		if (user.getMem_status() == 1) { //정지회원
			session.setAttribute("error", "정지회원입니다.");
			response.sendRedirect(request.getContextPath() + "/member/login");
			return false;
		} else if (user.getMem_status() == 9) { //관리자
			return true;
		} else { //일반회원
			String requestURI = request.getRequestURI();
			if (requestURI.contains("/admin/")) {
				session.removeAttribute("user");
				session.setAttribute("error", "접근 권한이 없습니다.");
				response.sendRedirect(request.getContextPath() + "/member/login");
				return false;
			} else {
				return true;
			}
		}
	}
}
