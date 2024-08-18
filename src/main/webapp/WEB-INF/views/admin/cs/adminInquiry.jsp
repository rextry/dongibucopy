<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>1:1 문의</h2>
		</div>
		<div class="mb-3">
			<a href="inquiry?status=1">전체</a> |
			<a href="inquiry?status=2">처리됨</a> |
			<a href="inquiry?status=3">답변 필요</a>
		</div>
		<c:if test="${empty list}">
		<div class="result-display">문의 내역이 없습니다.</div>
		</c:if>
		<c:if test="${!empty list}">
		<table class="table table-clean table-hover">
			<thead>
				<tr>
					<th>문의번호</th>
					<th>분류</th>
					<th class="col-6">제목</th>
					<th>회원</th>
					<th>일자</th>
					<th>답변</th>
				</tr>
			</thead>
			<tbody>
				<!-- 데이터 행 추가 -->
				<c:forEach var="inquiry" items="${list}">
					<tr class="align-center">
						<td>${inquiry.inquiry_num}</td>
						<td><c:if
								test="${inquiry.inquiry_category == 0}">
	               정기기부
	               </c:if> <c:if
								test="${inquiry.inquiry_category == 1}">
	               기부박스
	               </c:if> <c:if
								test="${inquiry.inquiry_category == 2}">
	               챌린지
	               </c:if> <c:if
								test="${inquiry.inquiry_category == 3}">
	               굿즈샵
	               </c:if> <c:if
								test="${inquiry.inquiry_category == 4}">
	               기타
	               </c:if></td>
						<td class="clickable-text" onclick="location.href='inquiry/reply?inquiry_num=${inquiry.inquiry_num}'">
						${inquiry.inquiry_title} <c:if test="${!empty inquiry.inquiry_filename}"><img src="${pageContext.request.contextPath}/images/attach-file.png"></c:if>
						</td>
						<td>${inquiry.mem_nick}(${inquiry.mem_email})</td>					
						<td>${inquiry.inquiry_date}</td>
						<td class="d-flex align-items-center justify-content-center">
							<c:if test="${!empty inquiry.inquiry_reply}">
							처리됨
							</c:if>
							<c:if test="${empty inquiry.inquiry_reply}">
							<button class="btn m-0" onclick='location.href="inquiry/reply?inquiry_num=${inquiry.inquiry_num}"'>
							답변 하기
							</button>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="align-center">${page}</div>
		</c:if>
	</div>
</section>
