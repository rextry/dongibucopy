<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dboxMypage.css" type="text/css">    
    <div class="tabs">
        <button class="tab-button" onclick="location.href='dboxMyPropose'">제안한 기부박스</button>
        <button class="tab-button active" onclick="location.href='dboxMyDonation'">기부박스 기부내역</button>
    </div>