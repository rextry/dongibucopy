<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
$(function(){
	let path=$(location).attr('pathname');
	pageNum=path.charAt(path.length-1);
	if(pageNum=='1'){
		$('#btn2').prop('disabled', true);
		$('#btn3').prop('disabled', true);
	}
	else if(pageNum=='2'){
		$('#btn3').prop('disabled', true);
	}
});
</script>
<!-- nav 시작 -->
<div class="align-center d-flex justify-content-center">
	<input type="button" id="btn1" value="1.나의 다짐" onclick="location.href='${pageContext.request.contextPath}/dbox/propose/step1'" class="nav_buttons pr-btn-left">
	<input type="button" id="btn2" value="2.팀 및 계획 작성" onclick="location.href='${pageContext.request.contextPath}/dbox/propose/step2'" class="nav_buttons">
	<input type="button" id="btn3" value="3.내용 작성" onclick="location.href='${pageContext.request.contextPath}/dbox/propose/step3'" class="nav_buttons pr-btn-right">
</div>
<hr size="3" noshade="noshade" width="100%">
<!-- nav 끝 -->