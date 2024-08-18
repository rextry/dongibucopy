<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    var contextPath = "${pageContext.request.contextPath}";
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.password.js"></script>
<div class="container mt-4">
	<h4 class="mb-4">비밀번호 수정</h4>
	<div class="row justify-content-left main-content-container">
		<div>
			<form:form action="changePassword" id="change_password" modelAttribute="memberVO">
				<div class="form-group row mb-3">
					<label class="col-sm-2 col-form-label">현재 비밀번호</label>
					<div class="col-sm-10">
						<input type="password" id="current_pw" name="current_pw" class="form-control"/>
						<span id="password_feedback" style="display:none;"></span>
					</div>
				</div>
				<div class="form-group row mb-3">
					<form:label path="mem_pw" class="col-sm-2 col-form-label">새 비밀번호</form:label>
					<div class="col-sm-10">
						<form:password path="mem_pw" placeholder="영문,숫자 혼합 8~12자리" class="form-control"/>
						<form:errors path="mem_pw" cssClass="text-danger"></form:errors>
					</div>
				</div>
				<div class="form-group row mb-3">
					<label class="col-sm-2 col-form-label">비밀번호 확인</label>
					<div class="col-sm-10">
						<input type="password" id="check_pw" class="form-control">
						<%-- 비밀번호/확인 일치여부 체크 --%>
						<span id="check_pw_msg"></span>
					</div>
				</div>
				<div class="btn-center mt-5">
					<form:button class="custom-btn btn">수정</form:button>
				</div>
			</form:form>
		</div>
	</div>
</div>