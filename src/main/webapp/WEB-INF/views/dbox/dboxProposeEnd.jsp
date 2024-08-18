<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<section class="section-padding nanum">
	<div class="container p-0 text-center">
		<h4 class="mb-4">기부박스 제안이 완료되었습니다.</h4>
		<ul style="list-style:none;margin:auto;" class="col-4 text-start mt-3 mb-3">
			<li class="d-flex mb-2"><span class="pr-end-label">제목</span> <span class="pr-end-content">${dbox.dbox_title}</span></li>
			<li class="d-flex mb-2"><span class="pr-end-label">팀명</span> <span class="pr-end-content">${dbox.dbox_team_name}</span></li>
			<li class="d-flex mb-2"><span class="pr-end-label">기부처</span> <span class="pr-end-content"><span class="badge mb-2"><img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" style="height:1rem;"> ${dbox.dcate_name}</span></span></li>
			<li class="d-flex mb-2"><span class="pr-end-label">목표금액</span> <span class="pr-end-content"><fmt:formatNumber value="${dbox.dbox_goal}" pattern="#,###원"/></span></li>
			<li class="d-flex mb-2"><span class="pr-end-label">기간</span> <span class="pr-end-content">${dbox.dbox_sdate} ~ ${dbox.dbox_edate}</span></li>	
		</ul>
		<button type="button" class="pr-custom-btn col-3" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox_num}/example'">기부박스 제안 보러가기</button>
	</div>
</section>