<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="container mt-4">
	<h4 class="mb-4">문의 내용</h4>
	<div class="row justify-content-left main-content-container">
		<div class="col-12 ms-auto mb-5 mb-lg-0">
		<div>
			<div class="d-flex align-items-center">
				<span id="inquiryCategoryText">
					   <c:if test="${inquiry.inquiry_category == 0}">정기기부</c:if>
					   <c:if test="${inquiry.inquiry_category == 1}">기부박스</c:if>
					   <c:if test="${inquiry.inquiry_category == 2}">챌린지</c:if>
					   <c:if test="${inquiry.inquiry_category == 3}">굿즈샵</c:if>
					   <c:if test="${inquiry.inquiry_category == 4}">기타</c:if>
				</span>
				<h5 class="mb-0" id="inquiryTitle">${inquiry.inquiry_title}</h5>
			</div>
			
			<c:if test="${!empty inquiry.inquiry_filename}">
			<div class="contact-info mt-3 mb-4">
				<p class="d-flex align-items-center mb-2">
					<img src="${pageContext.request.contextPath}/images/document.png" class="document-image">
					<!-- 파일 다운로드 뷰 넣기 -->
					<a href="file?inquiry_num=${inquiry.inquiry_num}">${inquiry.inquiry_filename}</a>
				</p>
			</div>
			</c:if>
			
			<div class="contact-image-wrap d-flex flex-wrap mb-2 pb-0">
				<div class="d-flex flex-column justify-content-center">
					<p>${inquiry.inquiry_content}</p>
					<p class="mb-1 cs-date">${inquiry.inquiry_date}</p>
				</div>
			</div>

			<div class="d-flex">
				<div class="d-flex flex-column justify-content-center">
					<div class="mt-2 mb-3">
						<c:if test="${empty inquiry.inquiry_reply}">
						<p>아직 답변이 등록되지 않았습니다.</p>
						</c:if>
						<c:if test="${!empty inquiry.inquiry_reply}">
						<p>${inquiry.inquiry_reply}</p>
						<div><p class="cs-date">답변일 <span id="inquiryRDateText">${inquiry.inquiry_rdate}</span></p></div>
						</c:if>
					</div>
				</div>
			</div>
			<c:if test="${empty inquiry.inquiry_reply}">
			<button id="editButton" onclick="location.href='modify?inquiry_num=${inquiry.inquiry_num}'">수정</button>
			</c:if>
			<button id="deleteButton">삭제</button>
			<button onclick="location.href='../inquiry'">목록</button>
			<script>
				$('#deleteButton').click(function() {
					if (confirm("삭제 하시겠습니까?")) {
					    alert("문의가 삭제되었습니다");
					    location.href='delete?inquiry_num=${inquiry.inquiry_num}'
					}
				});
			</script>
			
		</div>
		</div>
		
	</div>
</div>