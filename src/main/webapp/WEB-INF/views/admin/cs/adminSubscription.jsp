<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 회원 관리 시작 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/subscription/admin.subscription.js"></script>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>정기기부 관리</h2>
		</div>
	<form action="AdminSubscription" id="search_form" method="get">
		<ul class="search">
			<li>
				<select name="keyfield" id="keyfield">
					<option value="1" <c:if test="${param.keyfield == 1}">selected</c:if>>기부처/카테고리</option>
					<option value="2" <c:if test="${param.keyfield == 2}">selected</c:if>>유저번호</option>
				</select>
			</li>
			<li>
				<input type="search" name="keyword" id="keyword" value="${param.keyword}">
			</li>
			<li>
				<input type="submit" value="찾기">
				<button id="allResultBtn">전체</button>
			</li>
		</ul>
	</form>
	<c:if test="${count == 0}">
	<div class="result-display">표시할 회원이 없습니다.</div>
	</c:if>
	<c:if test="${count > 0}">
	<div>총 ${count} 건의 레코드</div>
	<table class="striped-table">
		<tr>
			<th class="align-center">정기기부번호</th>
			<th class="align-center">유저번호/기부자명</th>
			<th class="align-center">기부처</th>
			<th class="align-center">기부액</th>
			<th class="align-center">결제일</th>
			<th class="align-center">결제수단</th>
		</tr>
		<c:forEach var="subscription" items="${list}">
		<tr class="mem-item">
			<td class="align-center">${subscription.sub_num}</td>
			<td class="align-center"><a href="detail?mem_num=${subscription.mem_num}">${subscription.mem_num} / ${subscription.sub_name}</a></td>
			<td class="align-center">${subscription.dcate_name} / ${subscription.dcate_charity}</td>
			<td class="align-center"><fmt:formatNumber value="${subscription.sub_price}" type="number" pattern="#,##0"/>원</td>
			<td class="align-center">매월 ${subscription.sub_ndate}일</td>
			<td class="align-center" class="mem-'dstatus">
				<c:choose>
                    <c:when test="${subscription.sub_method == 'card'}">
                        카드 / ${subscription.card_nickname}
                    </c:when>
                    <c:when test="${subscription.sub_method == 'easy_pay'}">
                        간편결제 / ${subscription.easypay_method}
                    </c:when>
                    <c:otherwise>
                        알 수 없음
                    </c:otherwise>
                </c:choose>             
			</td>
		</tr>
		</c:forEach>
	</table>
	<div class="align-center">${page}</div>
	</c:if>
</div>
</section>
<!-- 회원 목록 끝 -->