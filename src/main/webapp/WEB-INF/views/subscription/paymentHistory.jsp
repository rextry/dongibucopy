<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/subscriptionList.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/subscription/subscriptionList.js"></script>
<div class="page-container">
    <div class="tabs">
        <button class="tab-button" onclick="location.href='subscriptionList'">나의 정기기부 목록</button>
        <button class="tab-button active" onclick="location.href='paymentHistory'">정기기부 결제내역</button>
    </div>
    <div id="paymentHistory" class="tab-content active">
        <div class="page-main">
            <h3>나의 정기기부 결제내역</h3>
            <form action="paymentHistory" id="search_form" method="get">
                <input type="hidden" name="category" value="${param.category}">
                <ul class="search">
                    <li>
                        <select name="keyfield" id="keyfield">
                            <option value="1" <c:if test="${param.keyfield == 1}">selected</c:if>>기부처</option>
                            <option value="2" <c:if test="${param.keyfield == 2}">selected</c:if>>결제수단</option>
                        </select>
                    </li>
                    <li><input type="search" name="keyword" id="keyword" value="${param.keyword}"></li>
                    <li><input type="submit" value="찾기"></li>
                </ul>
            </form>
            <script type="text/javascript">
                $(document).ready(function() {
                    $('#search_form').submit(function(event) {
                        if ($('#keyword').val().trim() === '') {
                            alert('검색어를 입력하세요');
                            $('#keyword').focus();
                            return false; // 폼 제출을 막습니다.
                        }
                    });
                });
            </script>
            <c:if test="${payCount == 0}">
                <div class="result-display">표시할 게시물이 없습니다.</div>
            </c:if>
            <c:if test="${payCount > 0}">
             <div class="align-left">
            	<span class="small">(결제일로부터 21일이 지나면 환불이 불가능합니다.)</span>
            </div>
                <table class="striped-table">               
                    <tr>	
                        <th>결제일</th>
                        <th>기부처</th>
                        <th>결제수단</th>
                        <th>결제금액</th>      
                    </tr>
                    <c:forEach var="subpayment" items="${paylist}">
                        <tr>
                            <td class="align-center">${subpayment.sub_pay_date}</td>
                            <td class="align-center"><a href="/category/categoryDetail?dcate_num=${subpayment.dcate_num}">${subpayment.dcate_charity}</a></td>
                            <td class="align-center">   
                                    <c:choose>
                                        <c:when test="${subpayment.sub_method == 'card'}">
                                            카드 / ${subpayment.card_nickname}
                                        </c:when>
                                        <c:when test="${subpayment.sub_method == 'easy_pay'}">
                                            간편결제 / ${subpayment.easypay_method}
                                        </c:when>
                                        <c:otherwise>
                                            알 수 없음
                                        </c:otherwise>
                                    </c:choose>                              
                            </td>
                            <td class="align-center sub-price">${subpayment.sub_price}</td>
                        </tr>
                    </c:forEach>
                </table>
               
                <div class="align-center">${page}</div>
            </c:if>
        </div>
    </div>
</div>
