<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script>
	let chalTitle = "${challenge.chal_title}";
	let chalFee = ${challenge.chal_fee};
	let memberNum = "${member.mem_num}";
	let memberNick = "${member.mem_nick}";
	let memberEmail = "${member.email}";
	let pageContextPath = "${pageContext.request.contextPath}";	
	let chalPhoto = "${challenge.chal_photo}";
	let mem_point = ${mem_point};
	let shouldIgnoreBeforeUnload = false;
	let unloadTriggered = false;

	function handleBeforeUnload(e){		
		if (shouldIgnoreBeforeUnload) {
			console.log('handleBeforeUnload 취소');
	        return; // 이벤트 핸들러를 실행하지 않음
	    }
		e.preventDefault();
		e.returnValue = '';
		
		unloadTriggered = true;   		        
	}  
	
	function handleUnload(e) {
	    if (shouldIgnoreBeforeUnload || !unloadTriggered) {
	    	console.log('handleUnload 취소');
	        return; // 이벤트 핸들러를 실행하지 않음
	    }

	    // 서버에 챌린지 세션 삭제 요청을 POST 방식으로 보냅니다.
	    const url = '/challenge/deleteImage';
	    navigator.sendBeacon(url);
	}
	
	$(function(){
		$(window).on('beforeunload', handleBeforeUnload);
		$(window).on('unload', handleUnload);	
	});	
</script>
<script src="${pageContext.request.contextPath}/js/challenge/challenge.join.pay.js"></script>

<div class="join-container nanum">
	<div class="challenge-info3">
		<c:if test="${empty challenge.chal_photo}">
			<img src="${pageContext.request.contextPath}/images/챌린지_기본이미지.jpg" alt="챌린지 사진" class="challenge-thumbnail">
		</c:if>
		<c:if test="${!empty challenge.chal_photo}">
			<img src="${pageContext.request.contextPath}/upload/${challenge.chal_photo}" alt="챌린지 사진" class="challenge-thumbnail">
		</c:if>
		<div class="challenge-details">
			<h2>${challenge.chal_title}</h2>
			<c:if test="${challenge.chal_freq == 0}">
				<p>매일</p>
			</c:if>        
			<c:if test="${challenge.chal_freq != 0}">
				<p>주 ${challenge.chal_freq}일</p>
			</c:if>
			<p>${challenge.chal_sdate} ~ ${challenge.chal_edate}</p>
		</div>
	</div>
	
	<form:form action="leaderJoin" id="challenge_join" enctype="multipart/form-data" modelAttribute="challengeJoinVO">

		<label for="charityInfo"><h6 style="color: #212529;">기부 카테고리</h6></label>
		<span class="error-color" style="display:none;">기부카테고리를 선택하세요</span>
		<span id="charityInfo"></span>
		<br><br>
		
		<c:forEach var="category" items="${categories}">
			<input type="radio" class="custom-radio" name="dcate_num" id="dcate_${category.dcate_num}" value="${category.dcate_num}" data-charity="${category.dcate_charity}">
			<label class="custom-radio-label" for="dcate_${category.dcate_num}">${category.dcate_name}</label>
		</c:forEach>

		<br><br>
		<li class="result-details">
			<p style="margin-top: 16px; font-size: 14px;">
				100% 성공 <span class="right"><span class="chal_fee_90"></span>p
				+ 추가 <span class="chal_fee_5"></span>p 환급, 
				<span class="chal_fee_10"></span>원 기부</span>
			</p>
			<p style="font-size: 14px;">
				0% 이상 성공 <span class="right"><span class="chal_fee_90"></span>p 환급, <span class="chal_fee_10"></span>원 기부</span>
			</p>
			<p style="font-size: 14px;">
				90% 미만 성공 <span class="right">성공률만큼 환급, 나머지 기부</span>
			</p>
		</li>
		<br><br>
		<div class="payment-details">
			<h6>
		        참여금 
		        <span class="amount-container">
		            <span class="amount chal_fee"></span>&nbsp;<span class="currency">원</span>
		        </span>
		    </h6>
		    <br>
		    <h6>
		        보유 포인트 
		        <span class="amount-container2">
		            <span class="amount mem-point">${mem_point}</span>&nbsp;<span class="currency">p</span>
		        </span>
		    </h6>
		    <h6>
		        사용할 포인트 
		        <span class="input-container">
		            <input type="text" class="used-point" value="0">&nbsp;<span class="currency">p</span>
		        </span>
		    </h6>
			<hr>
			<h6 style="font-size: 24px;">
				결제금액 
				<span class="amount-container">
					<span class="amount final_fee">&nbsp;</span>원
				</span>
			</h6>
		</div>
		
		<div class="align-center">
			<p style="color: #ddd;"><b>결제 조건 및 서비스 약관에 동의합니다</b></p>
			<button type="button" id="pay">결제하기</button>
		</div>
	</form:form>
</div>
