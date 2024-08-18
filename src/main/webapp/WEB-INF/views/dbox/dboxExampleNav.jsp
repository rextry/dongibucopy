<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<section class="section-padding nanum">
	<div class="container">
		<div class="custom-block-body shadow rounded mt-5">
			<!-- 제목 -->
			<span class="badge text-bg-success mb-3"><img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" style="height:1rem;">${dbox.dcate_name}</span>
			<h5 class="mb-3">${dbox.dbox_title}</h5>
			<!-- 팀 이름 -->
			<p><img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_team_photo}" class="team-profile-photo">${dbox.dbox_team_name}</p>
			<!-- 목표금액, 달성률 -->
			<div class="align-items-center my-2">
				<h4 class="text-end">
					<fmt:formatNumber value="${dboxTotal}" pattern="#,###원" />
				</h4>
				<p class="text-end">
					목표금액 : <fmt:formatNumber value="${dbox.dbox_goal}" pattern="#,###원" />
				</p>
			</div>
			<!-- 달성률 바 -->
			<div class="progress" role="progressbar" aria-label="" aria-valuenow="${Math.round(dboxTotal / dbox.dbox_goal*100)}" aria-valuemin="0" aria-valuemax="100">
					<div class="progress-bar progress-bar-striped bg-success" style="width:${Math.round(dboxTotal / dbox.dbox_goal*100)}%"></div>
			</div>
			<p class="text-end">
				<strong>달성률 : </strong>${Math.round(dboxTotal / dbox.dbox_goal*100)}%
			</p>
			<!-- 기부하기 버튼 -->
			<div class="text-center mt-5">
				<button type="button" class="btn btn-success col-12 disabled" data-bs-toggle="modal" data-bs-target="#staticBackdrop" id="donation-btn">기부 준비중</button>
			</div>
		</div>
	</div>
</section>


				