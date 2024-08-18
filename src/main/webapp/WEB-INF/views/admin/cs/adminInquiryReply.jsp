<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>문의 내용</h2>
		</div>
		
	<div class="row justify-content-left main-content-container">
		<div class="col-12 ms-auto mb-5 mb-lg-0">
		<div>
			<div class="d-flex align-items-center justify-content-between col-8">
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
				<div><button onclick="location.href='../inquiry'" id="list_btn">목록</button></div>
			</div>
			
			<c:if test="${!empty inquiry.inquiry_filename}">
			<div class="contact-info mt-3 mb-4">
				<p class="d-flex align-items-center mb-2">
					<img src="${pageContext.request.contextPath}/images/document.png" class="document-image">
					<!-- 파일 다운로드 뷰 넣기 -->
					<a href="file?inquiry_num=${inquiry.inquiry_num}">${inquiry.inquiry_filename}</a>
				</p>
				<p>
					<img src="${pageContext.request.contextPath}/images/user.png" class="document-image">
					<span>${inquiry.mem_nick}(회원번호: ${inquiry.mem_num})</span>
				</p>
			</div>
			</c:if>
			
			<div class="contact-image-wrap d-flex flex-wrap mb-2 pb-0">
				<div class="d-flex flex-column justify-content-center">
					<c:if test="${inquiry.inquiry_filename.endsWith('.jpg') 
								or inquiry.inquiry_filename.endsWith('.jpeg') 
								or inquiry.inquiry_filename.endsWith('.png') 
								or inquiry.inquiry_filename.endsWith('.gif')}">
								<p><img class="content-img" src="${pageContext.request.contextPath}/upload/${inquiry.inquiry_filename}"></p>
					</c:if>
					<p id="inquiryContent">${inquiry.inquiry_content}</p>
					<p id="inquiryDateText" class="mb-1 cs-date">${inquiry.inquiry_date}</p>
				</div>
			</div>
		
		<div class="d-flex row">
			<div class="d-flex flex-column justify-content-center">
				<div class="mt-2 mb-3 col-8">
					<c:if test="${empty inquiry.inquiry_reply}">
					<form:form action="reply" id="inquiry_reply_form" modelAttribute="inquiryVO">
						<div class="mb-3">
							<form:hidden path="inquiry_title" value="${inquiry.inquiry_title}"/>
							<form:hidden path="mem_num" value="${inquiry.mem_num}"/>
							<form:hidden path="inquiry_num" value="${inquiry.inquiry_num}"/>
							<form:textarea path="inquiry_reply" class="form-control mb-1" placeholder="답변을 입력하세요"/>
							<form:errors path="inquiry_reply" cssClass="form-error"></form:errors>
						</div>
						<div>
							<form:button id="reply_btn" class="custom-btn col-12">답변 등록</form:button>
						</div>
					</form:form>
					</c:if>
					
					<c:if test="${!empty inquiry.inquiry_reply}">
					<p id="replyContent">${inquiry.inquiry_reply}</p>
					<div id="replyInfo"><p class="cs-date">답변일 <span id="inquiryRDateText">${inquiry.inquiry_rdate}</span></p></div>
						<div id="formContainer"></div>
						    <script>
						    $(function() {
						        $('#modifyBtn').click(function() {
						            $.ajax({
						                url: 'modifyForm?inquiry_num=${inquiry.inquiry_num}',
						                type: 'GET',
						                success: function(data) {
						                    $('#formContainer').html(data);
						                }
						            });
						        });
						    });
						    </script>
					</c:if>
				</div>
			</div>
		</div>
		
		<c:if test="${!empty inquiry.inquiry_reply}">
		<button id="modifyBtn" class="custom-btn col-2">수정하기</button>
		</c:if>
	</div>
</div>
</div>
</div>
</section>