<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/admin/admin.report.js"></script>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>신고 내용</h2>
		</div>
			<div class="row justify-content-left main-content-container">
				<div class="col-12 ms-auto mb-5 mb-lg-0">
					<div>

						<div class="d-flex align-items-center justify-content-between col-8">
							<div class="d-flex align-items-center">
			 					<span id="reportCategoryText"> 
			 							<c:if test="${report.report_type == 1}">스팸/광고</c:if> 
			 							<c:if test="${report.report_type == 2}">폭력/위협</c:if> 
			 							<c:if test="${report.report_type == 3}">혐오발언/차별</c:if> 
			 							<c:if test="${report.report_type == 4}">음란물/부적절한 콘텐츠</c:if>
								</span> 			
							</div>
							<div><button onclick="location.href='../report'" id="list_btn">목록</button></div>
						</div>
					
						<c:if test="${!empty report.report_filename}">
						<div class="contact-info mt-3">
							<p class="d-flex align-items-center mb-2">
								<img src="${pageContext.request.contextPath}/images/document.png" class="document-image">
								<!-- 파일 다운로드 뷰 넣기 -->
								<a href="file?report_num=${report.report_num}">${report.report_filename}</a>
							</p>
						</div>
						</c:if>
						<p class="mb-2 mt-4">
							<img src="${pageContext.request.contextPath}/images/user.png" class="document-image">
							<span>${report.mem_nick}</span> (<span>${report.mem_num}</span>)
						</p>
						<p id="reported_mem">
							<img src="${pageContext.request.contextPath}/images/report.png" class="report-image">
							<span>${report.reported_mem_nick}</span> (<span>${report.reported_mem_num}</span>)
							<button class="expelBtn ms-2" data-nick="${report.reported_mem_nick}"
								data-num="${report.reported_mem_num}"
								<c:if test="${report.reported_mem_status == 9}">disabled</c:if>>제명</button>
							<button class="suspendBtn"
								data-nick="${report.reported_mem_nick}"
								data-num="${report.reported_mem_num}"
								<c:if test="${report.reported_mem_status != 2}">disabled</c:if>>정지</button>
						</p>
						
						<div class="contact-image-wrap d-flex flex-wrap mb-2 pb-0">
							<div class="d-flex flex-column justify-content-center">
								<c:if test="${report.report_filename.endsWith('.jpg') 
											or report.report_filename.endsWith('.jpeg') 
											or report.report_filename.endsWith('.png') 
											or report.report_filename.endsWith('.gif')}">
											<p><img class="content-img" src="${pageContext.request.contextPath}/upload/${report.report_filename}"></p>
								</c:if>
								<p>${report.report_content}</p>
								<p class="mb-1 cs-date">${report.report_date}</p>
							</div>
						</div>
	
					<div class="d-flex row">
					<div class="d-flex flex-column justify-content-center">
						<div class="mt-2 mb-3 col-8">
						<c:if test="${empty report.report_reply}">
							<form:form action="reply" id="report_reply_form" modelAttribute="reportVO">
								<div class="mb-3">
									<form:hidden path="mem_num" value="${report.mem_num}" />
									<form:hidden path="report_num" value="${report.report_num}" />
									<div class="mb-3">
										<form:radiobutton path="report_status" value="1"
											id="report_status_1" />
										<label for="report_status_1">승인</label>
										<form:radiobutton path="report_status" value="2"
											id="report_status_2" />
										<label for="report_status_2">반려</label>
									</div>
									<form:textarea path="report_reply" class="form-control mb-1" placeholder="답변을 입력하세요"/>
									<form:errors path="report_reply" cssClass="form-error"></form:errors>
								</div>
								<div>
									<form:button id="reply_btn" class="custom-btn col-12">답변 등록</form:button>
								</div>
							</form:form>
						
						</c:if>

						<c:if test="${!empty report.report_reply}">
						<p>
							<span id="report_status" class="d-flex justify-content-center align-items-center mb-2 mt-3">
								<c:if test="${report.report_status == 0}">미처리</c:if>
								<c:if test="${report.report_status == 1}">승인</c:if>
								<c:if test="${report.report_status == 2}">반려</c:if>
							</span>
						</p>
						<p id="replyContent">${report.report_reply}</p>
						<div id="replyInfo"><p class="cs-date">답변일 <span id="reportRDateText">${report.report_rdate}</span></p></div>

							<div id="formContainer"></div>
							    <script>
							    $(function() {
							        $('#modifyBtn').click(function() {
							            $.ajax({
							                url: 'modifyForm?report_num=${report.report_num}',
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

				<c:if test="${!empty report.report_reply}">
				<button id="modifyBtn" class="custom-btn col-2">수정하기</button>
				</c:if>
				</div>
			</div>
		</div>
	</div>

</section>