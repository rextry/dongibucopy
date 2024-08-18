<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link href="${pageContext.request.contextPath}/css/goods.css" rel="stylesheet">


<div class="container mt-5">
    <h4>구매내역</h4>
    <div class="mb-4 align-right">
        <button class="default-btn btn-large g-list-btn" onclick="location.href='${pageContext.request.contextPath}/goods/list'">상품 목록</button>
    </div>
    <c:if test="${not empty purchaseList}">
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
                <tr>
                    <th>구매 번호</th>
                    <th>상품명</th>
                    <th>사진</th>
                    <th>총액</th>
                    <th>사용한 포인트</th>
                    <th>구매일</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="purchase" items="${purchaseList}">
                    <tr>
                        <td>${purchase.purchase_num}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty purchase.item_name}">
                                    ${purchase.item_name}
                                </c:when>
                                <c:otherwise>
                                    장바구니 구매
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty purchase.item_photo}">
                                    <img src="${pageContext.request.contextPath}${purchase.item_photo}" alt="${purchase.item_name}" class="img-thumbnail" width="100" height="100">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/upload/goods/default.png" alt="장바구니 구매" class="img-thumbnail" width="100" height="100">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${purchase.amount}</td>
                        <td>${purchase.point_used}</td>
                        <td><fmt:formatDate value="${purchase.payDate}" pattern="yyyy-MM-dd" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${purchase.payStatus == 0}">
                                    결제완료
                                </c:when>
                                <c:when test="${purchase.payStatus == 2}">
                                    환불완료
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                    <c:forEach var="item" items="${purchase.cart_items}">
                        <tr>
                            <td colspan="2">${item.item_name}</td>
                            <td colspan="2"><img src="${pageContext.request.contextPath}${item.item_photo}" alt="${item.item_name}" class="img-thumbnail" width="50" height="50"></td>
                            <td colspan="2">${item.price * item.cart_quantity}</td>
                            <td colspan="2">${item.cart_quantity}</td>
                        </tr>
                    </c:forEach>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty purchaseList}">
        <p>구매 내역 없음</p>
    </c:if>
</div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/goods/refund.js"></script>
