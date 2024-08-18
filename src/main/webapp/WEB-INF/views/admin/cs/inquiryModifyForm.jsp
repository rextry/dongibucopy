<!-- inquiryReplyModifyForm -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<form:form action="reply" id="inquiry_reply_form" modelAttribute="inquiryVO">
	<div class="mb-3">
		<form:hidden path="inquiry_title" value="${inquiry.inquiry_title}"/>
		<form:hidden path="mem_num" value="${inquiry.mem_num}"/>
		<form:hidden path="inquiry_num" value="${inquiry.inquiry_num}"/>
		<form:textarea path="inquiry_reply" class="form-control mb-1" placeholder="답변을 입력하세요"/>
		<form:errors path="inquiry_reply" cssClass="form-error"></form:errors>
	</div>
	<div>
		<form:button id="reply_btn" class="custom-btn col-12">답변 수정</form:button>
	</div>
</form:form>
<script>
$(function() {
	$('#inquiry_reply').val($('#replyContent').text());
	$('#replyContent').hide();
	$('#replyInfo').hide();
	$('#modifyBtn').hide();
});
</script>