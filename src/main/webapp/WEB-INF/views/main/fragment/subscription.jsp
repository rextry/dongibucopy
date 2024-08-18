<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- section 내에 들어갈 내용을 div 내에 작성해주세요 --%>
<%-- section의 높이는 컨텐츠의 길이에 따라 자동 조정됩니다 --%>
<%-- 메인 페이지의 css 파일은 /DontGibuUp/src/main/resources/static/css/main.css 파일 내에 있습니다. --%>
<%-- css 설정이 필요하면 해당 파일 내의 적절한 섹션에서 수정해주세요 (git 충돌 주의) --%>
<style>
    .subscription {
        margin-top: 17vh; /* Viewport height의 10% */
        font-size: 24px;
    }
    input[type=button] {
        margin-top: 10px;
        padding: 4px 20px;
        border: 1px solid #09aa5c;
        border-radius: 2px;
        color: #fff;
        background-color: #09aa5c;
        font-weight: bold;
        cursor: pointer;
    }
    input[type=button]:hover {
        margin-top: 10px;
        padding: 4px 20px;
        border: 1px solid #09aa5c;
        border-radius: 2px;
        background-color: #FFF;
        color: #09aa5c;
        transition: 0.2s ease-out;
        font-weight: bold;
        cursor: pointer;
    }
</style>
<div class="subscription">
    <span>우리의 주변을 지키는 값진 행동,</span><br>
    <input type="button" value="정기후원하기 →" onclick="location.href='${pageContext.request.contextPath}/subscription/subscriptionMain'">
</div>
