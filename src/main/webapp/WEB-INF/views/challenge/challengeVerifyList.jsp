<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
	let contextPath = '${pageContext.request.contextPath}';
	let chal_num = ${challenge.chal_num};
	let chal_joi_num = ${chal_joi_num};
	let user_joi_num = ${chal_joi_num};
	let rowCount = 3;
	let pageSize = 10;
	var currentPage;
	let isLeader = ${isLeader};
</script>
<div class="challenge-summary">
	<div class="challenge-header2">
		<c:if test="${empty challenge.chal_photo}">
        	<img src="${pageContext.request.contextPath}/images/챌린지_기본이미지.jpg" alt="챌린지 사진">
        </c:if>
        <c:if test="${!empty challenge.chal_photo}">
        	<img src="${pageContext.request.contextPath}/upload/${challenge.chal_photo}" alt="챌린지 사진">
        </c:if>
		<div class="challenge-info-overlay">			
			<h2 class="challenge-title nanum">
				<a href="${pageContext.request.contextPath}/challenge/detail?chal_num=${challenge.chal_num}" style="color: white; text-decoration: none;">
					${challenge.chal_title}
				</a>
			</h2>
			<div class="details">
				<a href="#" onclick="history.back(); return false;" style="color: white; text-decoration: none;">	
					<button class="gray2-custom">목록으로</button>
				</a>
			</div>		
		</div>	    
	</div>
	<br>
		<div class="challenge-stats2">
			<div class="challenge-stat2-item">
				<span>인증 빈도</span>&nbsp;&nbsp;
				<c:if test="${chalFreq == 0}">
					<span>매일</span>
				</c:if>
				<c:if test="${chalFreq != 0}">
					<span>주 ${chalFreq}일</span>
				</c:if>
			</div>
			<div class="challenge-stat2-item">
				<span>기간</span>&nbsp;&nbsp;
				<span>${chal_sdate} ~ ${chal_edate}</span>
			</div>
			<div class="challenge-stat2-item1">
			    <span>달성률</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <span style="color: #198754;"><b>${achievementRate}%</b></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    <div class="progress progress-md">
			        <div class="progress-bar bg-success" role="progressbar" style="width: ${achievementRate}%" 
			        aria-valuenow="${achievementRate}" aria-valuemin="0" aria-valuemax="100"></div>
			    </div>
			</div>
			<div class="challenge-stat2-item2">
				<span>인증 성공</span> &nbsp;&nbsp;
				<span style="color: #5bc1ac;">${successCount}회</span>
			</div>
			<div class="challenge-stat2-item2">
				<span>인증 실패</span>&nbsp;&nbsp;
				<span style="color: #FA5151;">${failureCount}회</span>
			</div>
			<div class="challenge-stat2-item2">
				<span>남은 인증</span>&nbsp;&nbsp;
				<span style="color: #909090;">${remainingCount}회</span>
			</div>
			<div class="challenge-stat2-item2">
				<c:choose>
					<c:when test="${status == 'post'}">
						<button class="btn-custom" disabled>완료된 챌린지</button>
					</c:when>
					<c:when test="${hasCompletedWeeklyVerify}">
						<button class="btn-custom" disabled>이번주 인증 완료</button>
					</c:when>
					<c:when test="${hasTodayVerify}">
						<button class="btn-custom" disabled>오늘 인증 완료</button>
					</c:when>					
					<c:otherwise>
						<button class="btn-custom"
							onclick="location.href='${pageContext.request.contextPath}/challenge/verify/write?chal_joi_num=${chal_joi_num}&status=${status}'">인증하기</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="challenge-verify-stats">
			<div class="verify-stats-nav">
				<span id="verify_my_states">나의 인증 현황</span> | 
				<span id="join_member_list">참가자 인증 현황</span>
			</div>
			<div id="verify_content"></div>						
		</div>
</div>

<!-- 모달 창 구조 추가 -->
<div id="photoModal" class="custom-modal">
    <span class="custom-close">&times;</span>
    <img class="custom-modal-content" id="modalImage">
</div>

<script src="${pageContext.request.contextPath}/js/challenge/challenge.verify.js"></script>