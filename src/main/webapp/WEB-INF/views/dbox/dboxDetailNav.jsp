<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dbox/dbox.donation.js"></script>

<section class="section-padding nanum">
	<div class="container">
		<div class="custom-block-body shadow rounded mt-5">
			<!-- 제목 -->
			<span class="badge text-bg-success mb-3"><img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" style="height:1rem;">${dbox.dcate_name}</span>
			<h5 class="mb-3">${dbox.dbox_title}</h5>
			<!-- 팀 이름 -->
			<p><img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_team_photo}" class="team-profile-photo me-2">${dbox.dbox_team_name}</p>
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
				<input type="hidden" name="mem_num" id="mem_num" value="${member.mem_num}">
				<input type="hidden" name="mem_nick" id="mem_nick" value="${member.mem_nick}">
				<input type="hidden" name="mem_email" id="mem_email" value="${member.mem_email}">
				<c:if test="${dbox.dbox_status == 3}">
				<button type="button" class="btn btn-success col-12" data-bs-toggle="modal" data-bs-target="#staticBackdrop" id="donation-btn">기부하기</button>
				</c:if>
				<c:if test="${dbox.dbox_status != 3}">
				<button type="button" class="btn btn-success col-12" data-bs-toggle="modal" data-bs-target="#staticBackdrop" id="donation-btn" disabled>기부하기</button>
				</c:if>
			</div>
		</div>
		<!-- Modal 창 -->
		<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static">
			<div class="modal-dialog">
				<div class="modal-content">
					<form:form action="donation" id="dbox_donation" modelAttribute="dboxDonationVO">
						<input type="hidden" name="dbox_num" id="dbox_num" value="${dbox.dbox_num}">
						<input type="hidden" name="mem_point" id="mem_point" value="${member.mem_point}">
						<div class="modal-header">
							<h5 class="modal-title">기부하기</h5>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						</div>
						<div class="modal-body">
							<div class="mb-3">
							  <label for="dbox_do_price" class="form-label">기부금액 입력</label>
							  <input type="text" class="form-control caculate" id="dbox_do_price" placeholder="기부할 금액을 입력해주세요.">
							</div>
							<div class="mb-3">
							  <label for="dbox_do_point" class="form-label">포인트 입력</label><small>&nbsp;&nbsp;(보유 포인트 : <span style="color:blue;"><fmt:formatNumber value="${member.mem_point}" pattern="#,###p"/>)</span></small>
							  <input type="text" class="form-control caculate" id="dbox_do_point" placeholder="사용할 포인트를 입력해주세요.">
							</div>
							<div class="text-end mb-3">
								결제금액 : <strong id="pay_sum" style="color:red;">0</strong>원<small>(기부금액 - 포인트)</small><br><br>
								<span id="no" style="color:red;"></span><br>
								<small>* 기부금은 기부금액에 기입하신 만큼 기부됩니다.</small><br>
								<!-- <small>* 포인트만 기부를 희망하시는 경우 기부금액과 포인트를 같은 값으로 기입해주세요.</small> -->
							</div>
							<input type="hidden" id="pay_price" name="pay_price" value="">
							
							<div class="mb-3">
							  <label for="dbox_do_comment" class="form-label">코멘트 입력</label>
							  <textarea class="form-control" id="dbox_do_comment" placeholder="남길 코멘트를 입력해주세요."></textarea>
							</div>
							<div class="text-end">
								<input type="checkbox" class="form-check-input annony"> 익명으로 기부하기					
							</div>
						</div>
						<div class="modal-footer text-center">
							<button type="button" class="btn btn-success col-12" id="imp_donation">기부하기</button>			
						</div>
					</form:form>
				</div>
			</div>
		</div>
		
	</div>
</section>


				