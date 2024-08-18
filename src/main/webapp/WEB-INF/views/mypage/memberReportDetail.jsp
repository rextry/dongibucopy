<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="container mt-4">
	<h4 class="mb-4">신고 내용</h4>
	<div class="row justify-content-left main-content-container">
		<div class="col-12 ms-auto mb-5 mb-lg-0">
		<div>
			<div class="d-flex align-items-center">
				<span id="reportCategoryText">
					<c:if test="${report.report_type == 1}">스팸/광고</c:if>
					<c:if test="${report.report_type == 2}">폭력/위협</c:if>
					<c:if test="${report.report_type == 3}">혐오발언/차별</c:if>
					<c:if test="${report.report_type == 4}">음란물/부적절한 콘텐츠</c:if>
				</span>
			</div>
			
			<c:if test="${!empty report.report_filename}">
			<div class="contact-info mt-3 mb-4">
				<p class="d-flex align-items-center mb-2">
					<img src="${pageContext.request.contextPath}/images/document.png" class="document-image">
					<!-- 파일 다운로드 뷰 넣기 -->
					<a href="file?report_num=${report.report_num}">${report.report_filename}</a>
				</p>
				<p>
					<img src="${pageContext.request.contextPath}/images/report.png" 
					class="report-image">피신고자: ${report.reported_mem_nick}</p>
			</div>
			</c:if>
			
			<div class="contact-image-wrap d-flex flex-wrap mb-2 pb-0">
				<div class="d-flex flex-column justify-content-center">
					<p>${report.report_content}</p>
					<p class="mb-1 cs-date">${report.report_date}</p>
				</div>
			</div>

			<div class="d-flex">
				<div class="d-flex flex-column justify-content-center">
					<div class="mt-2 mb-3">
						<c:if test="${empty report.report_reply}">
						<p>아직 답변이 등록되지 않았습니다.</p>
						</c:if>
						<c:if test="${!empty report.report_reply}">
						<p>${report.report_reply}</p>
						<div><p class="cs-date">답변일 <span id="reportRDateText">${report.report_rdate}</span></p></div>
						</c:if>
					</div>
				</div>
			</div>
			<c:if test="${report.report_status == 0}">
				<button id="deleteButton">삭제</button>
				<script>
					$('#deleteButton').click(function() {
						if (confirm("삭제 하시겠습니까?")) {
						    alert("신고가 삭제되었습니다");
						    location.href='delete?report_num=${report.report_num}'
						}
					});
				</script>
			</c:if>
			<button onclick="location.href='../report'">목록</button>
			
		</div>
		</div>
		
	</div>
</div>