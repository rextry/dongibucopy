<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    var contextPath = "${pageContext.request.contextPath}";
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/password.js"></script>
<section class="section-padding">
<div class="container mt-4 nanum">
	<h4 class="mb-4">비밀번호 수정</h4>
	<div class="row justify-content-left main-content-container">
		<div>
			<form id="verify_form">
					<div class="form-group row mb-3">
						<label class="col-sm-2 col-form-label">인증번호</label>
						<div class="col-sm-10 d-flex flex-column">
							<div class="d-flex justify-content-start">
								<input type="text" id="vcode" class="form-control me-3" placeholder="이메일로 전송된 인증번호를 입력해주세요" style="width: 70%;" />
								<input type="submit" class="custom-btn btn" value="확인" />
							</div>
							<div>
								<span id="vcode_feedback"></span>
							</div>
						</div>
					</div>
			</form>
			<form:form action="changePassword" id="change_password" modelAttribute="memberVO">
				<div class="form-group row mb-3">
					<form:label path="mem_pw" class="col-sm-2 col-form-label">새 비밀번호</form:label>
					<div class="col-sm-10 d-flex flex-column">
						<form:password path="mem_pw" placeholder="영문,숫자 혼합 8~12자리" class="form-control" style="width: 86%;" />
						<form:errors path="mem_pw" cssClass="text-danger"></form:errors>
					</div>
				</div>
				<div class="form-group row mb-3">
					<label class="col-sm-2 col-form-label">비밀번호 확인</label>
					<div class="col-sm-10">
						<input type="password" id="check_pw" class="form-control" style="width: 86%;" >
						<%-- 비밀번호/확인 일치여부 체크 --%>
						<span id="check_pw_msg"></span>
					</div>
				</div>
				<div class="btn-center mt-3 mb-5">
					<form:button class="custom-btn btn">수정</form:button>
				</div>
			</form:form>
		</div>
	</div>
</div>
</section>