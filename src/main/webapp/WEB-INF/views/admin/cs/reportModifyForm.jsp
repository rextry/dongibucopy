<!-- reportReplyModifyForm -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<form:form action="reply" modelAttribute="reportVO">
	<div class="mb-3">
		<form:hidden path="mem_num" value="${report.mem_num}"/>
		<form:hidden path="report_num" value="${report.report_num}"/>
		<div class="mb-3">
			<c:if test="${report.report_status == 1}">
			<form:radiobutton path="report_status" value="1" id="report_status_1" checked="checked" />
		       <label for="report_status_1">승인</label><br>
			<form:radiobutton path="report_status" value="2" id="report_status_2" />
		       <label for="report_status_2">반려</label><br>	
			</c:if>
			<c:if test="${report.report_status == 2}">
			<form:radiobutton path="report_status" value="1" id="report_status_1" />
		       <label for="report_status_1">승인</label><br>
			<form:radiobutton path="report_status" value="2" id="report_status_2" checked="checked" />
		       <label for="report_status_2">반려</label><br>	
			</c:if>
		</div>
		<form:textarea path="report_reply" class="form-control mb-1" placeholder="답변을 입력하세요"/>
		<form:errors path="report_reply" cssClass="form-error"></form:errors>
	</div>

	<div>
		<form:button id="reply_btn" class="custom-btn col-12">답변 수정</form:button>
	</div>
</form:form>
<script>
$(function() {
	$('#report_reply').val($('#replyContent').text());
	$('#replyContent').hide();
	$('#replyInfo').hide();
	$('#modifyBtn').hide();
});
</script>