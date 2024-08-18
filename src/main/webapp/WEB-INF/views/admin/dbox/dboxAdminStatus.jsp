<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 기부박스 상태 관리 시작 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dbox.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="section-padding nanum mb-0 pb-0">
	<div class="container">
		<div class="mb-4">
 			<h2>기부박스 상태 관리</h2>
 		</div>
 		<button type="button" class="btn btn-outline-success mt-2 mb-2" onclick="location.href='/admin/dboxAdmin'">목록</button>
 	<h5>기부박스 정보</h5>
 	<div class="shadow-sm p-3 mb-5 bg-body-tertiary rounded">
 		기부박스 번호 : ${dbox.dbox_num}<br>
	 	기간 : ${dbox.dbox_sdate} ~ ${dbox.dbox_edate}<br>
	 	등록일 : ${dbox.dbox_rdate}<br>
	 	상태 :  	
		<c:if test="${dbox.dbox_status == 0}">
		<span style="color:blue">신청완료</span>
		</c:if>
		<c:if test="${dbox.dbox_status == 1}">
		<span style="color:magenta">심사완료</span>
		</c:if>
		<c:if test="${dbox.dbox_status == 2}">
		<span style="color:red">신청반려</span>
		</c:if>
		<c:if test="${dbox.dbox_status == 3}">
		<b>진행중</b>
		</c:if>
		<c:if test="${dbox.dbox_status == 4}">
		진행완료
		</c:if>
		<c:if test="${dbox.dbox_status == 5}">
		<span style="color:red">진행중단</span>
		</c:if><br>
		상태변경<br>
		<form action="Change" id="status_form" method="get">
			<input type="hidden" name="dbox_num" value="${dbox.dbox_num}">
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="0"
			  	<c:if test="${dbox.dbox_status == 0}">checked</c:if> <c:if test="${dbox.dbox_status >= 1}">disabled</c:if>
			  >
			  <label for="inlineRadio1" <c:if test="${dbox.dbox_status >= 1}">style="color:#b8b8b8"</c:if>>신청완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="1"
			  	<c:if test="${dbox.dbox_status == 1}">checked</c:if> <c:if test="${dbox.dbox_status >= 2}">disabled</c:if>
			  >
			  <label for="inlineRadio2" <c:if test="${dbox.dbox_status >= 2}">style="color:#b8b8b8"</c:if>>심사완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="2"
				<c:if test="${dbox.dbox_status == 2}">checked</c:if> <c:if test="${dbox.dbox_status >= 3}">disabled</c:if>
			  >
			  <label for="inlineRadio3" <c:if test="${dbox.dbox_status >= 3}">style="color:#b8b8b8"</c:if>>신청반려</label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="3"
			  	<c:if test="${dbox.dbox_status == 3}">checked</c:if> <c:if test="${dbox.dbox_status == 2 || dbox.dbox_status >= 4}">disabled</c:if>
			  >
			  <label for="inlineRadio1" <c:if test="${dbox.dbox_status == 2 || dbox.dbox_status >= 4}">style="color:#b8b8b8"</c:if>>진행중</label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="4"
			  	<c:if test="${dbox.dbox_status == 4}">checked</c:if> <c:if test="${dbox.dbox_status == 1 || dbox.dbox_status == 5}">disabled</c:if>
			  >
			  <label for="inlineRadio2" <c:if test="${dbox.dbox_status == 1 || dbox.dbox_status == 2 || dbox.dbox_status == 5}">style="color:#b8b8b8"</c:if>>진행완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input class="form-check-input status" type="radio" name="dbox_status" value="5"
				<c:if test="${dbox.dbox_status == 5}">checked</c:if> <c:if test="${dbox.dbox_status == 2 || dbox.dbox_status == 4}">disabled</c:if>
			  >
			  <label for="inlineRadio3" <c:if test="${dbox.dbox_status == 2 || dbox.dbox_status == 4}">style="color:#b8b8b8"</c:if>>진행중단</label>
			</div>
			<div class="form-floating">
			  <textarea class="form-control" placeholder="신청반려/진행중단인 경우만 작성" id="reject" name="reject" style="height: 100px" <c:if test="${dbox.dbox_status !=2 ||  dbox.dbox_status != 4}">disabled</c:if>></textarea>
			  <label for="floatingTextarea2">신청반려/진행중단인 경우만 작성</label>
			</div>
			<button type="submit" class="btn btn-outline-success mt-2">변경</button>
	 	</form>
	 	<script>
	 	$('#status_form').submit(function(){
	 		if(!confirm('변경하시겠습니까?')){
	 			return false;
	 		}else if($('#reject').val().trim() == '' || $('#reject').val().trim() == null){
	 			if(!$('#reject').prop('disabled')){
		 			alert('내용 작성 필수');
		 			return false;	 				
	 			}
	 		}
	 	});
	 	$('.status').change(function(){
	 		if($(this).val() == '2' || $(this).val() == '5'){
	 			 $('#reject').prop('disabled', false);
	 		}else{
	 			 $('#reject').prop('disabled', true);
	 		}
	 	});
	 	</script>
	</div>
 	
 	<h5>신청자 정보</h5>
 	<div class="shadow-sm p-3 mb-5 bg-body-tertiary rounded">
 		회원 번호 : ${member.mem_num}<br>
	 	닉네임 : 	<c:if test="${!empty member.mem_photo}">
                <img src="${pageContext.request.contextPath}/upload/${member.mem_photo}" class="rounded-circle my-image">&nbsp;${member.mem_nick}&nbsp;님<br>
                </c:if>
                <c:if test="${empty member.mem_photo}">
                <img src="${pageContext.request.contextPath}/images/basicProfile.png" class="rounded-circle my-image">&nbsp;${member.mem_nick}&nbsp;님<br>
                </c:if>
	 	상태 / 등급 : 
			<c:if test="${member.mem_status == 0}">
			탈퇴회원
			</c:if>
			<c:if test="${member.mem_status == 1}">
			정지회원
			</c:if>
			<c:if test="${member.mem_status == 2}">
			일반회원
			</c:if>
			<c:if test="${member.mem_status == 9}">
			관리자
			</c:if>
			
			<c:if test="${member.auth_num == 1}">
			<img src="/images/auth/auth1.png" class="rounded-circle my-image">
			</c:if>
			<c:if test="${member.auth_num == 2}">
			<img src="/images/auth/auth2.png" class="rounded-circle my-image">
			</c:if>
			<c:if test="${member.auth_num == 3}">
			<img src="/images/auth/auth3.png" class="rounded-circle my-image">
			</c:if>
			<c:if test="${member.auth_num == 4}">
			<img src="/images/auth/auth4.png" class="rounded-circle my-image">
			</c:if>
			<c:if test="${member.auth_num == 5}">
			<img src="/images/auth/auth5.png" class="rounded-circle my-image">
			</c:if>
			<c:if test="${member.auth_num == 6}">
			<img src="/images/auth/auth6.png" class="rounded-circle my-image">
			</c:if>
	 	<br>
	 	이메일 : ${member.mem_email}<br>
	 	총 기부 횟수 : ${memberTotal.total_count}<br> 
	 	누적 기부액 : <fmt:formatNumber value="${memberTotal.total_amount}" type="number" minFractionDigits="0" maxFractionDigits="0"/>원<br> 
 	
 	</div>
 	
 	<h5>팀 정보</h5>
 	<div class="shadow-sm p-3 mb-5 bg-body-tertiary rounded">
	 	팀 : 
		 	<span class="badge">
			<c:if test="${dbox.dbox_team_type == 1}">
			기관
			</c:if>
			<c:if test="${dbox.dbox_team_type == 2}">
			개인/단체
			</c:if>
			</span>
			${dbox.dbox_team_name}
		 	<c:if test="${!empty dbox.dbox_team_photo}">
		 	<img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_team_photo}"width="50" height="50" class="profile-photo"><br>
		 	</c:if>
		 	<c:if test="${empty dbox.dbox_team_photo}">
		 	<img src="${pageContext.request.contextPath}/images/teamProfile.png" width="50" height="50" class="profile-photo"><br>
		 	</c:if>
		<c:if test="${dbox.dbox_team_type == 1}">
		사업자 번호 : ${dbox.dbox_business_rnum}<br>
		</c:if>
		팀 설명 :
			<c:if test="${!empty dbox.dbox_team_detail}">
		 	${dbox.dbox_team_detail}
		 	</c:if>
			<c:if test="${empty dbox.dbox_team_detail}">
 			미입력
		 	</c:if>
		 	<br>
 	
 	</div>
 	
 	<h5>자료 및 남길 말</h5>
 	<div class="shadow-sm p-3 mb-5 bg-body-tertiary rounded">	
		사업계획서 : ${dbox.dbox_business_plan}<br>
		금액책정 근거자료 : 
			<c:if test="${!empty dbox.dbox_budget_data}">
		 	${dbox.dbox_budget_data}
		 	</c:if>
			<c:if test="${empty dbox.dbox_budget_data}">
 			미입력
		 	</c:if>
		 	<br>
	 	계좌 : 
		 	[<c:if test="${dbox.dbox_bank == 1}">국민은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 2}">신한은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 3}">하나은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 4}">우리은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 5}">NH농협은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 6}">IBK기업은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 7}">대구은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 8}">제주은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 9}">전북은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 10}">광주은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 11}">경남은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 12}">부산은행</c:if>
		 	<c:if test="${dbox.dbox_bank == 13}">카카오뱅크</c:if>
		 	<c:if test="${dbox.dbox_bank == 14}">토스뱅크</c:if>
		 	<c:if test="${dbox.dbox_bank == 15}">케이뱅크</c:if>]
		 	${dbox.dbox_account} / ${dbox.dbox_account_name}<br>
	 	남길 말 : 
	 		<c:if test="${!empty dbox.dbox_comment}">
		 	${dbox.dbox_comment}
		 	</c:if>
			<c:if test="${empty dbox.dbox_comment}">
 			미입력
		 	</c:if>
		 	<br>
 	</div>
 	
 	<h5>예시</h5>
</div>
</section>
<!-- 기부박스 상태 관리 끝 -->