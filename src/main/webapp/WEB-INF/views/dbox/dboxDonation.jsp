<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<div class="text-center nanum" style="min-height:500px;">
	<h2 class="mt-5">기부하기 완료</h2>
	<br>
	<div class="custom-block-body shadow rounded mt-2" style="width:300px;margin: 0 auto;">
		<!-- 제목 -->
		<span class="badge text-bg-success mb-3"><img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" style="height:1rem;">${dbox.dcate_name}</span>
		<h5 class="mb-3">${dbox.dbox_title}</h5>
		<!-- 팀 이름 -->
		<p><img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_team_photo}" class="team-profile-photo me-2">${dbox.dbox_team_name}</p>
		기부해주셔서 감사합니다.
	</div>
	<br>
	<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content'" style="width:300px;">기부한 기부박스로 이동</button>
</div>