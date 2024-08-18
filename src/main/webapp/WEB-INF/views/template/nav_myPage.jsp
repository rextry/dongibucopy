<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<!-- MyPage 메뉴 시작 -->
<c:if test="${!empty user && user.mem_status != 9}"><!-- 일반회원 -->
	<h4 class="mb-3" style="color: #5A6F80;">MYPAGE</h4>	
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">나의 정보</h5>
		<a href="${pageContext.request.contextPath}/member/myPage/memberInfo" class="category-block-link"> 회원정보 수정</a>
		<c:if test="${user.mem_reg_type == 1}">
		<a href="${pageContext.request.contextPath}/member/myPage/changePassword" class="category-block-link"> 비밀번호 수정</a>
		</c:if>
		<a href="${pageContext.request.contextPath}/member/myPage/inviteFriendEvent" class="category-block-link"> 친구초대</a>
		<a href="${pageContext.request.contextPath}/member/myPage/point" class="category-block-link"> 포인트</a>
		<a href="${pageContext.request.contextPath}/member/myPage/payment" class="category-block-link"> 결제내역</a>
	</div>
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">기부활동</h5>
		<a href="${pageContext.request.contextPath}/subscription/subscriptionList" class="category-block-link"> 정기기부</a>
		<a href="${pageContext.request.contextPath}/dbox/myPage/dboxMyPropose" class="category-block-link"> 기부박스</a>
	</div>
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">챌린지</h5>
		<a href="${pageContext.request.contextPath}/challenge/join/list?status=pre" class="category-block-link"> 시작 전 챌린지</a>
		<a href="${pageContext.request.contextPath}/challenge/join/list?status=on" class="category-block-link"> 참가중인 챌린지</a>
		<a href="${pageContext.request.contextPath}/challenge/join/list?status=post" class="category-block-link"> 완료된 챌린지</a>
	</div>
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">굿즈샵</h5>
		<a href="${pageContext.request.contextPath}/goods/purchaseHistory" class="category-block-link">구매 내역</a>
		<a href="${pageContext.request.contextPath}/cart/list" class="category-block-link"> 장바구니</a>
	</div>
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">고객센터</h5>
		<a href="${pageContext.request.contextPath}/member/myPage/inquiry" class="category-block-link"> 1:1 문의</a>
		<a href="${pageContext.request.contextPath}/member/myPage/report" class="category-block-link"> 신고</a>
	</div>
</c:if>
<c:if test="${!empty user && user.mem_status == 9}"><!-- 관리자 -->
	<h4 class="mb-3" style="color: #5A6F80;">MYPAGE</h4>	
	<div class="category-block d-flex flex-column">
		<h5 class="mb-3">나의 정보</h5>
		<a href="${pageContext.request.contextPath}/member/myPage/memberInfo" class="category-block-link"> 회원정보 수정</a>
		<c:if test="${user.mem_reg_type == 1}">
		<a href="${pageContext.request.contextPath}/member/myPage/changePassword" class="category-block-link"> 비밀번호 수정</a>
		</c:if>
	</div>
</c:if>
<!-- MyPage 메뉴 끝 -->
