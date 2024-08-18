package kr.spring.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import kr.spring.cs.service.CSService;
import kr.spring.cs.vo.InquiryVO;
import kr.spring.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class WriterCheckInterceptor implements HandlerInterceptor {

    @Autowired
    private CSService csService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        log.debug("<<===로그인 회원번호와 작성자 회원번호 일치 여부 체크===>>");

        // 세션에서 로그인 사용자 정보 가져오기
        HttpSession session = request.getSession();
        MemberVO user = (MemberVO) session.getAttribute("user");

        // 객체의 식별자를 파라미터나 경로 변수에서 가져오기
        long objId;
        String uri = request.getRequestURI();
        
        if (uri.contains("/inquiry/")) {
            objId = Long.parseLong(request.getParameter("inquiry_num")); // 문의의 경우
        } else {
            // 다른 객체에 대한 처리 필요
            return true; // 예외 상황 처리 방식에 따라 수정 필요
        }

        boolean isWriter = false;

        if (uri.contains("/inquiry/")) {
            // 문의 객체 처리
            InquiryVO inquiry = csService.selectInquiryDetail(objId);
            if (user != null && inquiry != null && user.getMem_num() == inquiry.getMem_num()) {
                isWriter = true;
            }
        }

        if (!isWriter) {
            log.debug("<<로그인 회원번호와 작성자 회원번호 불일치>>");

            request.setAttribute("message", "잘못된 접근입니다");
            request.setAttribute("url", request.getContextPath() + "/");

            // 포워드 방식으로 화면 호출
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/common/resultAlert.jsp");
            dispatcher.forward(request, response);
            return false;
        }

        log.debug("<<로그인 회원번호와 작성자 회원번호 일치>>");
        return true;
    }
}
