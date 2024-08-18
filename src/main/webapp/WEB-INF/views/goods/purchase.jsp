<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<div>
    <h2>Purchase Page</h2>
    <form id="purchaseForm" method="post" action="${pageContext.request.contextPath}/goods/purchase">
        <input type="text" id="imp_uid" name="imp_uid" placeholder="Imp UID" required>
        <button type="submit">Submit</button>
    </form>
    <button type="button" id="verify-payment-btn">Verify Payment</button>
    <button type="button" id="purchase-btn">Purchase</button>
</div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v2/iamport.js"></script>
<script src="${pageContext.request.contextPath}/js/goods/purchase.js"></script>
