<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
	var contextPath = "${pageContext.request.contextPath}";
</script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/member/member.info.js"></script>
<div class="container mt-4">
    <h4 class="mb-4">회원정보 수정</h4>
    <div class="row justify-content-left main-content-container">
	<div class="col-lg-4 text-center p-0">
	    <div class="mb-3">
	        <div class="d-flex align-items-center justify-content-between photo-flex mb-4">
	            <!-- 사진 및 삭제 버튼 -->
	            <div class="position-relative">
	                <c:if test="${!empty user.mem_photo}">
	                    <img src="${pageContext.request.contextPath}/upload/${user.mem_photo}"
	                         class="border border-light photo-preview my-photo position-relative">
	                    <button id="photo_del" class="btn btn-sm position-absolute top-0 end-0"
	                            <c:if test="${empty user.mem_photo}">style="display:none;"</c:if>>
	                        x
	                    </button>
	                </c:if>
	                <c:if test="${empty user.mem_photo}">
	                    <img src="${pageContext.request.contextPath}/images/basicProfile.png"
	                         class="border border-light photo-preview my-photo position-relative">
	                    <button id="photo_del" class="btn btn-sm position-absolute top-0 end-0"
	                            <c:if test="${empty user.mem_photo}">style="display:none;"</c:if>>
	                        x
	                    </button>
	                </c:if>
	            </div>
	
	            <!-- 찾아보기 버튼 -->
	            <div class="mb-3 d-flex flex-column justify-content-end full-height">
	                <button id="photo_choice" class="btn btn-secondary btn-sm">
	                    찾아보기
	                </button>
	            </div>
	        </div>
	    </div>
	</div>
            <input type="file" id="mem_photo" accept="image/gif,image/png,image/jpeg" style="display: none;">
        </div>
		<form:form action="updateMember" id="member_update"
			modelAttribute="memberVO">
			<div class="form-group row mb-3">
				<label for="mem_email" class="col-sm-2 col-form-label">이메일</label>
				<div class="col-sm-10">
					<form:input id="mem_email" path="mem_email" readonly="true"
						disabled="true" class="form-control" />
					<form:hidden path="mem_email" />
				</div>
			</div>
			<div class="form-group row mb-3">
				<label for="mem_nick" class="col-sm-2 col-form-label">닉네임</label>
				<div class="col-sm-10">
					<form:input id="mem_nick" path="mem_nick" maxlength="10"
						class="form-control" />
					<span id="nick_check_msg"></span>
					<form:errors path="mem_nick" cssClass="form-error text-danger"></form:errors>
				</div>
			</div>
			<div class="form-group row mb-3">
				<label for="mem_name" class="col-sm-2 col-form-label">이름</label>
				<div class="col-sm-10">
					<form:input id="mem_name" path="mem_name" maxlength="10"
						class="form-control" />
					<form:errors path="mem_name" cssClass="form-error text-danger"></form:errors>
				</div>
			</div>
			<div class="form-group row mb-3">
				<form:label path="mem_phone" class="col-sm-2 col-form-label">전화번호</form:label>
				<div class="col-sm-2 no-margin">
					<input type="text" class="form-control no-margin" value="010"
						readonly>
				</div>
				<div class="col-sm-1 text-center no-margin dash">-</div>
				<div class="col-sm-2 no-margin">
					<input type="text" id="phone2" maxlength="4"
						class="form-control no-margin" value="${phone2}">
				</div>
				<div class="col-sm-1 text-center no-margin dash">-</div>
				<div class="col-sm-2 no-margin">
					<input type="text" id="phone3" maxlength="4"
						class="form-control no-margin" value="${phone3}">
				</div>
				<form:hidden path="mem_phone" />
				<form:errors path="mem_phone"
					cssClass="form-error text-danger col-sm-12"></form:errors>
			</div>
			<div class="form-group row mb-3">
				<label class="col-sm-2 col-form-label">생년월일</label>
				<div class="col-sm-2 no-margin">
					<select id="birth_year" name="birth_year"
						class="form-control no-margin" data-year="${birth_year}"></select>
				</div>
				<div class="col-sm-1 text-center no-margin label-text">년</div>
				<div class="col-sm-2 no-margin">
					<select id="birth_month" name="birth_month"
						class="form-control no-margin" data-month="${birth_month}"></select>
				</div>
				<div class="col-sm-1 text-center no-margin label-text">월</div>
				<div class="col-sm-2 no-margin">
					<select id="birth_day" name="birth_day"
						class="form-control no-margin" data-day="${birth_day}"></select>
				</div>
				<div class="col-sm-1 text-center no-margin label-text">일</div>
				<form:hidden path="mem_birth" />
				<form:errors path="mem_birth"
					cssClass="form-error text-danger col-sm-12"></form:errors>
			</div>
			<div class="btn-center mt-5">
				<a href="#" id="update_btn" class="custom-btn btn btn-primary">수정</a>
				<form:button id="update_btn_hide" style="display:none;">수정</form:button>
			</div>
		</form:form>

		<div class="d-flex justify-content-left mb-3">
			<a href="deleteAccount" class="custom-cancel-btn">회원 탈퇴하기</a>
		</div>
    </div>




<!-- JAVASCRIPT FILES -->
<script src="${pageContext.request.contextPath}/t1/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/t1/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/t1/js/jquery.sticky.js"></script>
<script src="${pageContext.request.contextPath}/t1/js/click-scroll.js"></script>
<script src="${pageContext.request.contextPath}/t1/js/counter.js"></script>
<script src="${pageContext.request.contextPath}/t1/js/custom.js"></script>
