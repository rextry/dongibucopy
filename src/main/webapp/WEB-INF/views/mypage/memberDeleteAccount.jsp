<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    let mem_reg_type = "${user.mem_reg_type}";
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.delete.js"></script>
<div class="container mt-4">
	<h4 class="mb-4">회원탈퇴</h4>
	<div class="row justify-content-left main-content-container">
		<div class="mb-4">
			<p class="mb-0">그동안 돈기부업을 이용해주셔서 감사합니다.</p>
			<p class="pt-0">회원탈퇴 시 계정 복구는 불가능하며 보유하신 포인트는 모두 소멸되니 이를 양지하여 주시기 바랍니다.</p>
		</div>
		<div>
			<form:form action="deleteAccount" id="delete_account" modelAttribute="memberVO">
				<c:if test="${user.mem_reg_type == 1}">
				<div class="form-group row mb-3">
					<form:label path="mem_pw" class="col-sm-2 col-form-label">비밀번호</form:label>
					<div class="col-sm-10">
						<form:password path="mem_pw" class="form-control"/>
						<form:errors path="mem_pw" cssClass="text-danger"></form:errors>
					</div>
				</div>
				</c:if>
				<div class="btn-center mt-5">
					<form:button class="custom-btn btn">회원탈퇴</form:button>
				</div>
			</form:form>
		</div>
	</div>
</div>