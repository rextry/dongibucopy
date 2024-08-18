<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.signup.js"></script>
  <div class="container-scroller nanum">
    <div class="container-fluid page-body-wrapper full-page-wrapper">
      <div class="content-wrapper d-flex align-items-center auth px-0">
        <div class="row w-100 mx-0">
          <div class="col-lg-4 mx-auto">
            <div class="auth-form-light text-left py-5 px-4 px-sm-5">
            
              <h4 class="mb-3">회원가입</h4>
				<form:form action="oauth" id="member_social_signup"  modelAttribute="memberVO">
					<input type="hidden" name="mem_reg_type" value="${memberVO.mem_reg_type}"/>
					<input type="hidden" name="mem_social_id" value="${memberVO.mem_social_id}"/>
					<input type="hidden" name="mem_email" value="${memberVO.mem_email}" />
					<div class="mb-3">
						<div class="d-flex col-9 mb-3">
							<label for="mem_email" class="col-3">이메일*</label>
							<span class="col-9">${memberVO.mem_email}</span>
						</div>
						<div class="d-flex col-9 mb-3">
							<form:label path="mem_nick" cssClass="col-3">닉네임*</form:label>
							<form:input path="mem_nick"  maxlength="10" cssClass="form-control col-9"/>
							<span id="nick_check_msg"></span>
							<form:errors path="mem_nick" cssClass="form-error"></form:errors>
						</div>
						<div class="d-flex col-9">
							<form:label path="friend_rcode" cssClass="col-3">추천인 코드(선택)</form:label>
							<form:input path="friend_rcode" cssClass="form-control col-9"  maxlength="8" value="${rcode}"/>
							<form:errors path="friend_rcode" cssClass="form-error"></form:errors>
						</div>
					</div>
					<div class="align-center">
						<form:button class="default-btn">Signup</form:button>
					</div>
				</form:form>
            </div>
          </div>
        </div>
      </div>
      <!-- content-wrapper ends -->
    </div>
    <!-- page-body-wrapper ends -->
  </div>