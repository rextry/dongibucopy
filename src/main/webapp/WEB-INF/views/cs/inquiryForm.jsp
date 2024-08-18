<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="nanum m-4">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 col-12 mx-auto">
                <form:form action="inquiry" id="inquiry_form" class="custom-form donate-form" enctype="multipart/form-data" modelAttribute="inquiryVO">
                    <h5 class="mb-3">1:1 문의</h5>
                    <form:hidden path="mem_num" value="${user.mem_num}" />
                    
                    <!-- Category Section -->
                    <div class="form-group mb-3">
                        <!-- <label for="inquiry_category" class="form-label">문의 카테고리</label> -->
                        <form:select path="inquiry_category" id="inquiry_category" class="form-select">
                            <c:forEach var="category" items="${inquiry_category}">
                                <c:choose>
                                    <c:when test="${category.key == ''}">
                                        <form:option value="${category.key}" selected="selected">${category.value}</form:option>
                                    </c:when>
                                    <c:otherwise>
                                        <form:option value="${category.key}">${category.value}</form:option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </form:select>
                        <form:errors path="inquiry_category" cssClass="form-error text-danger"></form:errors>
                    </div>
                    
                    <!-- Title Section -->
                    <div class="form-group mb-3">
                        <!-- <label for="inquiry_title" class="form-label">문의 제목</label> -->
                        <form:input path="inquiry_title" id="inquiry_title" placeholder="문의 제목" maxlength="20" cssClass="form-control"/>
                        <form:errors path="inquiry_title" cssClass="form-error text-danger"></form:errors>
                    </div>
                    
                    <!-- File Upload Section -->
                    <div class="form-group mb-3">
                        <!-- <label for="upload" class="form-label">파일 업로드</label> -->
                        <input type="file" name="upload" id="upload" class="form-control-file">
                    </div>
                    
                    <!-- Content Section -->
                    <div class="form-group mb-3">
                        <!-- <label for="inquiry_content" class="form-label">문의 내용</label> -->
                        <form:textarea path="inquiry_content" id="inquiry_content" cssClass="form-control" placeholder="문의 내용" maxlength="1333" cols="60" rows="5"/>
                        <form:errors path="inquiry_content" cssClass="form-error text-danger"></form:errors>
                    </div>
                    
                    <div class="text-center">
                        <form:button class="form-control mt-4">문의하기</form:button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</section>
