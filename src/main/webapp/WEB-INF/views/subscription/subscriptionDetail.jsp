<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<meta charset="UTF-8">
<title>Subscription Page</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/subscriptionDetail.css" type="text/css">
<script>
    // 서버에서 전달된 템플릿 변수를 JavaScript 변수로 설정
    var subPayDate = "${sub_paydate}".trim();
    var cancelDate = "${cancel_date}".trim();
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/subscription/subscriptionDetail.js"></script>
<div class="tabs">
    <button class="tab-button active" onclick="location.href='subscriptionList'">나의 정기기부 목록</button>
    <button class="tab-button" onclick="location.href='paymentHistory'">정기기부 결제내역</button>
</div>
<div>
    <div class="item_subscribe">
        <dl class="header-item">
            <dt>
                <img src="${pageContext.request.contextPath}/upload/${category.dcate_icon}" alt="기부처 아이콘"> ${category.dcate_name} /
                ${category.dcate_charity}
                <c:if test="${subscription.sub_status == 0}">
                     &nbsp; <span class="focus">정기 기부중</span> 입니다.
                </c:if>
            </dt>
            <dd>
                <c:if test="${subscription.sub_status == 1}">
                    <span class="small"> 해지됨 (${cancel_date})</span>
                </c:if>
            </dd>
        </dl>
        <div class="cont-item">
            <dl class="info-item">
                <dt>
                    시작일 :<span class="reg_date">${reg_date}</span> <br> <br>
                    기간 :<span class="reg_date">${reg_date}</span> ~
                    <c:if test="${subscription.sub_status == 0}">
                        <span class="next-pay-date"></span> <br><br>
                    </c:if>
                    <c:if test="${subscription.sub_status == 1}">
                        ${cancel_date} <br><br>
                    </c:if>
                    결제수단 : &nbsp;
                    <c:choose>
                        <c:when test="${subscription.sub_method == 'card'}">카드 / ${subscription.card_nickname}</c:when>
                        <c:when test="${subscription.sub_method == 'easy_pay'}">간편결제 / ${subscription.easypay_method}</c:when>
                        <c:otherwise>알 수 없음</c:otherwise>
                    </c:choose>
                </dt>
                <dd>
                    이번 결제&nbsp;&nbsp;
                    <fmt:formatNumber value="${subscription.sub_price}" type="number" />
                    원 (결제일 ${sub_paydate})<br> <br>
                    <c:if test="${subscription.sub_status == 0}">
                        다음 결제&nbsp;&nbsp; <fmt:formatNumber value="${subscription.sub_price}" type="number" />원 (결제일 <span class="next-pay-date"></span>)
                    </c:if>
                    <c:if test="${subscription.sub_status == 1}">
                        다음 결제 --
                    </c:if>
                    <br>
                    <div class="align-right">
                        <button type="button" class="update-payment-btn" data-bs-toggle="modal" data-bs-target="#staticBackdrop">변경</button>
                        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">결제수단 변경</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body align-center">
                                        <form:form id="modifyPayMethod" modelAttribute="subscriptionVO" action="modifyPayMethod" method="post" style="width: 465px;">
                                            <input type="hidden" name="dcate_num" value="${category.dcate_num}">
                                            <input type="hidden" name="mem_num" value="${user.mem_num}" id="mem_num">
                                            <input type="hidden" name="sub_num" value="${subscription.sub_num}" id="sub_num">
                                            <input type="hidden" name="card_nickname" id="card_nickname">
                                            <input type="hidden" name="sub_date" id="sub_date" />
                                            <div class="form-group">
                                                <label>결제 수단을 선택해주세요</label><br> <small>이미 등록된 결제수단으로만 변경할 수 있습니다.</small><br> <br>
                                                <div class="payment-methods">
                                                    <label class="payment-method" for="card"> <form:radiobutton path="sub_method" id="card" value="card" />카드 &nbsp;&nbsp;&nbsp; </label>
                                                    <label class="payment-method" for="easy_pay"> <form:radiobutton path="sub_method" id="easy_pay" value="easy_pay" />간편결제 </label>
                                                </div>
                                            </div>
                                            <!-- 카드 옵션 -->
                                            <div id="card-options" style="display: none;">
                                                <label>등록한 카드 목록</label><br>
                                                <div class="form-group align-left">
                                                    <c:forEach var="card" items="${paylist}">
                                                        <!-- 카드 닉네임이 현재 사용중인 카드와 다를 때만 표시 -->
                                                        <c:if test="${not empty card.card_nickname and card.card_nickname != subscription.card_nickname}">
                                                            <div>
                                                                <input type="radio" class="oldCard" name="selectedCard" value="${card.card_nickname}" id="card_${card.card_nickname}"> <label for="card_${card.card_nickname}"> ${card.card_nickname}</label>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <!-- 간편 결제 수단 라디오 버튼 -->
                                            <div class="form-group easypay-container" style="display: none;">
                                                <!-- 간편 결제 수단 -->
                                                <div class="form-group easypay-container" style="display: none;">
                                                    <label>등록한 간편 결제</label><br>
                                                    <div class="easypay_methods">
                                                        <c:forEach var="card" items="${paylist}">
                                                            <c:if test="${card.easypay_method != subscription.easypay_method}">
                                                                <c:choose>
                                                                    <c:when test="${card.easypay_method == 'kakao'}">
                                                                        <label class="easypay_method" for="kakao"> <form:radiobutton path="easypay_method" id="kakao" value="kakao" /> <img src="../upload/카카오페이 로고.jpg" width="40" style="border-radius: 25%"></label>
                                                                    </c:when>
                                                                    <c:when test="${card.easypay_method == 'payco'}">
                                                                        <label class="easypay_method" for="payco"> <form:radiobutton path="easypay_method" id="payco" value="payco" /> <img src="../upload/페이코 로고.jpg" width="40" style="border-radius: 25%"></label>
                                                                    </c:when>
                                                                </c:choose>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">변경</button>
                                        </form:form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </dd>
            </dl>
        </div>
        <c:if test="${subscription.sub_status == 0}">
            <input type="button" value="해지하기" class="modify-btn" data-num="${subscription.sub_num}">
        </c:if>
        <c:if test="${subscription.sub_status == 1}">
            <input type="button" value="해지된 정기기부" class="modify-btn" disabled="disabled">
        </c:if>
        <div class="paymentHistory">
            <h3>정기기부 결제내역</h3>
            <span class="small">총 기부 횟수 : ${count}회</span>
            <span class="notice"> (결제일로부터 21일이 지나면 환불이 불가능합니다.)</span>
            <form:form id="refund_form" modelAttribute="refundVO" action="paymentRefund" method="post">
                <form:hidden path="mem_num" value="${payment.mem_num}" />
                <c:forEach var="payment" items="${list}">
    <div class="payment">
        <div class="check-box">
            <input type="radio" name="refund" value="${payment.sub_pay_date}" class="refund-radio" 
                   data-price="${payment.sub_price}" data-num="${payment.sub_pay_num}" 
                   data-num2="${payment.sub_num}" data-status="${payment.sub_pay_status}">
        </div>
        <div class="align-left">
            <small>${payment.sub_pay_date}</small><br>
            ${category.dcate_name} / ${category.dcate_charity}<br>
        </div>
        <div class="align-right">
            결제액
            <fmt:formatNumber value="${payment.sub_price}" type="number" />
            원 <br>
            결제상태 : <span id="paymentStatus">
                <c:choose>
                    <c:when test="${payment.sub_pay_status == 0}">
                        결제완료
                    </c:when>
                    <c:when test="${payment.sub_pay_status == 1}">
                        환불신청중
                    </c:when>
                    <c:when test="${payment.sub_pay_status == 2}">
                        환불완료
                    </c:when>
                    <c:when test="${payment.sub_pay_status == 3}">
                        환불불가
                    </c:when>
                </c:choose>
            </span>
        </div>
    </div>
</c:forEach>

                <div class="refund-info">
                    환불사유<br> <br>
                    <label><input type="radio" name="reason" value="0"> 단순변심</label>
                    <label><input type="radio" name="reason" value="1"> 결제오류</label>
                    <label><input type="radio" name="reason" value="4"> 기타</label><br>
                    <input type="text" name="otherReason" id="otherReason" placeholder="기타 환불 사유 입력" disabled><br>
                    <div class="total-refund">
                        환불액: <span id="totalAmount">0</span> 원
                    </div>
                    <input type="submit" value="환불신청">
                </div>
            </form:form>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // 오늘 날짜를 구함
    var today = moment();

    // 모든 라디오 버튼을 검사하여 비활성화 조건을 체크
    $('.refund-radio').each(function() {
        var payDateStr = $(this).val();
        var paymentStatus = parseInt($(this).data('status'), 10); // data-status에서 값을 가져와 정수로 변환

        try {
            var payDate = moment(payDateStr, "YY년 MM월 DD일/HH:mm");
            if (!payDate.isValid()) {
                throw new Error("Invalid date format");
            }
            var dayDiff = today.diff(payDate, 'days');

            // 결제 상태가 '결제완료'가 아니거나 결제일로부터 21일이 지났을 경우 비활성화
            if (paymentStatus !== 0 || dayDiff > 21) {
                $(this).prop('disabled', true);
            }
        } catch (e) {
            console.error("날짜 형식을 파싱하는 중 오류 발생: " + e);
        }
    });

    $('input[name="reason"]').change(function() {
        if ($(this).val() === '4') {
            $('#otherReason').prop('disabled', false); // 활성화
        } else {
            $('#otherReason').val('');
            $('#otherReason').prop('disabled', true); // 비활성화
        }
    });

    // 라디오 버튼 변경 시 환불액 업데이트
    $('input[name="refund"]').change(function() {
        var selectedRefund = $('.refund-radio:checked');
        if (selectedRefund.length) {
            var refundAmount = selectedRefund.data('price');
            $('#totalAmount').text(refundAmount.toLocaleString());
        } else {
            $('#totalAmount').text('0'); // 선택된 항목이 없으면 0으로 설정
        }
    });

    $('#refund_form').submit(function(e) {
        e.preventDefault();

        var selectedRefund = $('.refund-radio:checked');
        var refundAmount = selectedRefund.data('price');
        var refundPayNum = selectedRefund.data('num');
        var refundReason = $('input[name="reason"]:checked').val();
        var otherReason = $('#otherReason').val();

        // 선택된 라디오 버튼이 있는지 확인
        if (!selectedRefund.length) {
            alert('환불할 결제를 선택하세요.');
            return false; // 폼 제출 방지
        }

        // 환불 사유가 기타인 경우, 기타 사유 입력 칸이 비어 있으면 경고 메시지 표시
        if (refundReason === '3' && otherReason.trim() === '') {
            alert('기타 환불 사유를 입력하세요.');
            return false; // 폼 제출 방지
        }

        var formData = {
            sub_pay_num: selectedRefund.data('num'),
            amount: refundAmount,
            imp_uid: "merchant_uid" + selectedRefund.data('num'),
            reason: refundReason,
            reason_other: otherReason
        };

        $.ajax({
            url: '/subscription/paymentRefund',
            type: 'POST',
            data: formData,
            dataType: 'json',
            success: function(param) {
                if (param.result === 'success') {
                    alert('환불 신청이 완료되었습니다.');
                    location.reload();
                }
            },
            error: function() {
                alert('오류가 발생했습니다.');
            }
        });
    });
});

</script>
