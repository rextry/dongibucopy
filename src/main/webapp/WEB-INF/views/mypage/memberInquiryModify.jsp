<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.modifyinquiry.js"></script>
<h4>문의 수정</h4>
<form:form action="modify" id="inquiry" enctype="multipart/form-data" modelAttribute="inquiryVO">
	<ul>
	<form:hidden path="inquiry_num" value="${inquiryVO.inquiry_num}" />
		<li>
			<form:label path="inquiry_category">카테고리</form:label>
			<form:select path="inquiry_category">
		    <c:forEach var="category" items="${inquiry_category}">
                <c:if test="${category.key == inquiryVO.inquiry_category}">
                    <form:option value="${category.key}" selected="selected">${category.value}</form:option>
                </c:if>
                <c:if test="${category.key != inquiryVO.inquiry_category}">
                    <form:option value="${category.key}">${category.value}</form:option>
                </c:if>
		    </c:forEach>
			</form:select>
        	<form:errors path="inquiry_category" cssClass="form-error"></form:errors>
		</li>
		<li>
			<form:input path="inquiry_title" placeholder="문의 제목" maxlength="20"/>
			<form:errors path="inquiry_title" cssClass="form-error"></form:errors>
		</li>
		<c:if test="${!empty inquiryVO.inquiry_filename}">
		<li id="filePreview">
			<label>첨부파일</label>
			<a href="file?inquiry_num=${inquiryVO.inquiry_num}">${inquiryVO.inquiry_filename}</a> <sup id="fileDelete" class="clickable">&times;</sup>
			<input type="hidden" id="file_deleted" name="file_deleted" value="0">
		</li>
		</c:if>
		<li>
			<input type="file" name="upload" id="upload" style="display:none;">
			<button id="fileupload" data-filename="${inquiryVO.inquiry_filename}">파일 업로드</button>
		</li>
		<li>
			<form:textarea path="inquiry_content" placeholder="문의 내용" maxlength="1333"/>
			<form:errors path="inquiry_content" cssClass="form-error"></form:errors>
		</li>
	</ul>
	<div class="align-center">
		<form:button class="default-btn">수정하기</form:button>
		<button id="cancelButton">취소</button>
	</div>
</form:form>