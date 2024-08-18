<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<div class="container mt-4">
	<h4 class="mb-4">1:1문의</h4>
	<div class="row justify-content-left main-content-container">
		<c:if test="${empty list}">
		<div class="result-display">문의 내역이 없습니다.</div>
		</c:if>
		<c:if test="${!empty list}">
	            <table class="table table-clean">
	                <thead>
	                    <tr>
	                        <th>분류</th>
	                        <th>제목</th>
	                        <th>일자</th>
	                        <th>답변</th>
	                    </tr>
	                </thead>
	                <tbody>
	                    <!-- 데이터 행 추가 -->
	                    <c:forEach var="inquiry" items="${list}">
	                        <tr>
	                            <td>
	                                <c:choose>
	                                    <c:when test="${inquiry.inquiry_category == 0}">정기기부</c:when>
	                                    <c:when test="${inquiry.inquiry_category == 1}">기부박스</c:when>
	                                    <c:when test="${inquiry.inquiry_category == 2}">챌린지</c:when>
	                                    <c:when test="${inquiry.inquiry_category == 3}">굿즈샵</c:when>
	                                    <c:otherwise>기타</c:otherwise>
	                                </c:choose>
	                            </td>
	                            <td class="clickable" onclick="location.href='inquiry/detail?inquiry_num=${inquiry.inquiry_num}'">
	                                ${inquiry.inquiry_title} <c:if test="${!empty inquiry.inquiry_filename}"><img src="${pageContext.request.contextPath}/images/attach-file.png" width="15px"></c:if>
	                            </td>
	                            <td>${inquiry.inquiry_date}</td>
	                            <td>
	                                <c:if test="${!empty inquiry.inquiry_reply}">
	                                    <a href='inquiry/detail?inquiry_num=${inquiry.inquiry_num}'>답변확인</a>
	                                </c:if>
	                            </td>
	                        </tr>
	                    </c:forEach>
	                </tbody>
	            </table>
		</c:if>
	</div>
</div>
