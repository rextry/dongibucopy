<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 환불 시작 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
$(document).ready(function() {
    // 툴팁 표시 및 숨김
    $('td:contains("기타")').hover(
        function(event) {
            var tooltip = $(this).find('.tooltip-text');
            tooltip.css({
                display: 'block',
                top: event.pageY + 10,
                left: event.pageX + 10
            });
        },
        function() {
            $(this).find('.tooltip-text').css('display', 'none');
        }
    );

    // 승인 버튼 클릭 이벤트
    $('.approve-btn').click(function() {
        var refund_num = $(this).data('refund-num');
        var imp_uid = $(this).data('imp-uid');
        var reason_other = $(this).data('reason-other');
        var payment_type = $(this).data('type');
        var return_point = $(this).data('return');

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/admin/approvalRefund',
            data: JSON.stringify({ refund_num: refund_num, imp_uid: imp_uid, reason_other: reason_other, payment_type: payment_type , return_point : return_point}),
            contentType: 'application/json; charset=UTF-8',
            success: function(param) {
                if (param.result === 'success') {
                    alert('환불이 승인되었습니다.');
                    location.reload();
                } else if (param.result === 'error') {
                    alert('환불 승인 중 에러 발생: ' + response.error_msg);
                } else if (param.result === 'logout') {
                    alert('로그인이 필요합니다.');
                    location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('네트워크 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
            }
        });
    });

    // 반려 버튼 클릭 이벤트
    $('.reject-btn').click(function() {
        var refund_num = $(this).data('refund-num');
        var payment_type = $(this).data('type');

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/admin/rejectionRefund',
            data: JSON.stringify({refund_num: refund_num, payment_type: payment_type}),
            contentType: 'application/json; charset=UTF-8',
            success: function(param) {
                if (param.result === 'success') {
                    alert('환불이 반려되었습니다.');
                    location.reload();
                } else if (param.result === 'logout') {
                    alert('로그인이 필요합니다.');
                    location.href = '${pageContext.request.contextPath}/login';
                } else {
                    alert('네트워크 오류가 발생했습니다.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
            }
        });
    });
});
</script>
<style>
.tooltip-text {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    padding: 5px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    z-index: 1000;
}
</style>

<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
    		<h2>환불신청 관리</h2>
    	</div>
    <div class="container">
        <div class="mb-4"></div>
        <div class="mb-3">
            <a href="refundRequest?">전체</a> |
            <a href="refundRequest?refund_status=0">처리중</a> |
            <a href="refundRequest?refund_status=1">승인</a> |
            <a href="refundRequest?refund_status=2">반려</a>
        </div>
        <c:if test="${count == 0}">
            <div class="result-display">표시할 환불신청이 없습니다</div>
        </c:if>
        <c:if test="${count > 0}">
            <div>총 ${count} 건의 레코드</div>
            <table class="striped-table">
                <tr>
                    <th class="align-center">환불신청번호</th>
                    <th class="align-center">유저번호</th>
                    <th class="align-center">구분</th>
                    <th class="align-center">결제액</th>
                    <th class="align-center">환불사유</th> 
                    <th class="align-center">신청일</th>
                    <th class="align-center">환불(반려)일</th>
                    <th class="align-center">환불상태</th>
                </tr>
                <c:forEach var="refund" items="${list}">
                    <tr class="mem-item">
                        <td class="align-center">${refund.refund_num}</td>
                        <td class="align-center"><a href="detail?mem_num=${refund.mem_num}">${refund.mem_num}</a></td>
                        <td class="align-center">
                            <c:if test="${refund.payment_type == 0}">정기기부</c:if>
                            <c:if test="${refund.payment_type == 1}">기부박스</c:if>
                            <c:if test="${refund.payment_type == 3}">굿즈샵</c:if>
                        </td>
                        <td class="align-center"><fmt:formatNumber value="${refund.amount}" type="number" pattern="#,##0"/>원</td>
                        <td class="align-center">
                            <c:choose>
                                <c:when test="${refund.reason==0}">단순변심</c:when>
                                <c:when test="${refund.reason==1}"><a href='#'>결제오류</a></c:when>
                                <c:when test="${refund.reason==2}"><a href='#'>상품문제</a></c:when>
                                <c:when test="${refund.reason==3}"><a href='#'>배송문제</a></c:when>
                                <c:when test="${refund.reason==4}">
                                    기타
                                    <span class="tooltip-text" style="display:none;">${refund.reason_other}</span>
                                </c:when>
                            </c:choose>
                        </td>
                        <td class="align-center">${refund.reg_date}</td>
                        <td class="align-center" class="mem-dstatus">
                            <c:if test="${empty refund.refund_date}">--</c:if>
                            <c:if test="${!empty refund.refund_date}">${refund.refund_date}</c:if>    
                        </td>
                        <td class="align-center">
                            <c:choose>
                                <c:when test="${refund.refund_status==0}">
                                    <input type="button" class="approve-btn" value="승인" data-refund-num="${refund.refund_num}" data-imp-uid="${refund.imp_uid}" data-reason-other="${refund.reason_other}" data-type="${refund.payment_type}"
                                    	data-return="${refund.return_point}">
                                    <input type="button" class="reject-btn" value="반려" data-refund-num="${refund.refund_num}" data-type="${refund.payment_type}">
                                </c:when>
                                <c:when test="${refund.refund_status==1}">승인</c:when>
                                <c:when test="${refund.refund_status==2}">반려</c:when>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <div class="align-center">${page}</div>
        </c:if>
    </div>
</div>
</section>
<!-- 환불 끝 -->
