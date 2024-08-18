<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="nanum m-4">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 col-12 mx-auto">
                <form:form action="report" id="report_form" class="custom-form donate-form" enctype="multipart/form-data" modelAttribute="reportVO">
                    <h5 class="mb-3">신고</h5>
                    <form:hidden path="mem_num"/>
                    <form:hidden path="chal_num"/>
                    <form:hidden path="chal_rev_num"/>
                    <form:hidden path="dbox_re_num"/>
                    <form:hidden path="reported_mem_num"/>
                    <form:hidden path="report_source"/>
                    <c:if test="${report_source == 1}">
	                    <form:hidden path="chal_num"/>                
                    </c:if>
                    <c:if test="${report_source == 2}">
	                    <form:hidden path="chal_rev_num"/>                
                    </c:if>
                    <c:if test="${report_source == 4}">
	                    <form:hidden path="dbox_re_num"/>                
                    </c:if>
                    <div class="form-group mb-3 d-flex align-items-center">
                        <label class="form-label col-2">피신고자</label>
                        <form:input path="reported_mem_nick" readonly="${true}" class="form-control"></form:input>
                    </div>
                    
                    <!-- Category Section -->
                     <div class="form-group mb-3">
                        <form:select path="report_type" id="report_type" class="form-select">
                            <c:forEach var="type" items="${report_type}">
                                <c:choose>
                                    <c:when test="${type.key == ''}">
                                        <form:option value="${type.key}" selected="selected">${type.value}</form:option>
                                    </c:when>
                                    <c:otherwise>
                                        <form:option value="${type.key}">${type.value}</form:option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </form:select>
                        <form:errors path="report_type" cssClass="form-error text-danger"></form:errors>
                    </div>


                    <!-- File Upload Section -->
                    <div class="form-group mb-3">
                        <input type="file" name="upload" id="upload" class="form-control-file">
                    </div>
                    
                    <!-- Content Section -->
                    <div class="form-group mb-3">
                        <form:textarea path="report_content" id="report_content" cssClass="form-control" placeholder="신고 내용" maxlength="1333" cols="60" rows="5"/>
                        <form:errors path="report_content" cssClass="form-error text-danger"></form:errors>
                    </div>
                    
                    <div class="text-center">
                        <form:button class="form-control mt-4">신고하기</form:button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</section>
