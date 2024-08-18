<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>신고</h2>
		</div>
	<div class="mb-3">
		<a href="report?">전체</a> |
		<a href="report?status=0">처리중</a> |
		<a href="report?status=1">승인</a> |
		<a href="report?status=2">반려</a>
	</div>
	<c:if test="${empty list}">
	<div class="result-display">신고 내역이 없습니다.</div>
	</c:if>
	<c:if test="${!empty list}">
	<table class="table table-clean table-hover">
		<thead>
			<tr>
				<th>신고번호</th>
				<th>신고자</th>
				<th>피신고자</th>
				<th>종류</th>
				<th>내용</th>
				<th>일자</th>
				<th>처리 상태</th>
				<th>답변</th>
			</tr>
		</thead>
		<tbody>
			<!-- 데이터 행 추가 -->
			<c:forEach var="report" items="${list}">
				<tr class="align-center">
					<td>${report.report_num}</td>
					<td>${report.mem_num}</td>
					<td>${report.reported_mem_num}</td>
					<td>
					<c:if test="${report.report_type == 1}">스팸/광고</c:if>
					<c:if test="${report.report_type == 2}">폭력/위협</c:if>
					<c:if test="${report.report_type == 3}">혐오발언/차별</c:if>
					<c:if test="${report.report_type == 4}">음란물/부적절한 콘텐츠</c:if>
					<c:if test="${report.report_type == 5}">챌린지 인증</c:if>
               		</td>
					<td class="clickable-text" onclick="location.href='report/reply?report_num=${report.report_num}'">
					<span class="report-content">${report.report_content}</span> <c:if test="${!empty report.report_filename}"><img src="${pageContext.request.contextPath}/images/attach-file.png" width="15px"></c:if>
					</td>
					<td>${report.report_date}</td>					
					<td>
					<c:if test="${report.report_status == 0}">처리중</c:if>
					<c:if test="${report.report_status == 1}">승인</c:if>
					<c:if test="${report.report_status == 2}">반려</c:if>
					</td>
					<td>
					<c:if test="${empty report.report_reply}">
					<button class="btn m-0" onclick='location.href="report/reply?report_num=${report.report_num}"'>
					답변 하기
					</button>
					</c:if>
					<c:if test="${!empty report.report_reply}">
					답변완료
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
