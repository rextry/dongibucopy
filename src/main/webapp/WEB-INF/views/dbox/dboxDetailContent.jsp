<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<section class="section-padding nanum">
	<div class="container">
		<div class="text-center mt-5 mb-5">
			<img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_photo}" class="img-fluid dbox-main-img"><br>
		</div>
		<div class="mb-2">
			<button type="button" class="btn btn-outline-success active" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content'">기부박스 소개</button>
			<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/donators'">기부현황</button>
			<%-- <button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/news'">소식</button> --%>
		</div>
		<br>
		<div class="px-1">${dbox.dbox_content}</div><br>
		<br>
		<div class="bud-box">
			<div>
				<div class="bud-box-label mb-3">기부금 사용계획</div>
				<c:forEach var="budget" items="${dboxBudget}">
				<div class="d-flex justify-content-between align-items-center">
					<div class="bud-purpose">
					${budget.dbox_bud_purpose}
					</div>
				    <div class="flex-grow-1">
				        <hr size="1">
				    </div>
					<div class="bud-price">
						<fmt:formatNumber value="${budget.dbox_bud_price}" pattern="#,##0" /> 원
					</div>
				</div>
				</c:forEach>
			</div>
		</div>
		</div>
</section>
