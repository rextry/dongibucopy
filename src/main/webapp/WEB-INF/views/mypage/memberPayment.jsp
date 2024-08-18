<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript"
    src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
$(document).ready(function() {
    // 체크박스 비활성화 로직 추가
    $('input[name="refundCheck"]').each(function() {
        var paymentType = $(this).data('type');
        var paymentDateString = $(this).data('date'); // 결제일을 데이터 속성으로 가져옴
        var paymentDate = new Date(paymentDateString); // 결제일을 Date 객체로 변환
        var currentDate = new Date();
        var payStatus = $(this).data('status');
        var threeWeeksInMillis = 3 * 7 * 24 * 60 * 60 * 1000;

		    if (paymentType == 2 || (currentDate - paymentDate > threeWeeksInMillis) || payStatus != 0) {
            $(this).prop('disabled', true);
            $(this).closest('tr').find('td:eq(8)').append('<span class="disabled-reason">(환불 불가)</span>');
        }
    });

    $('input[name="refundCheck"]').on('click', function() {
        var paymentType = $(this).data('type');
        var impUid = $(this).data('id');
        var amount = $(this).data('amount');
        var reasonDiv = $('.reason-div');
        var refundButton = $('#refundButton');

        if (paymentType == "0") {
            impUid = "merchant_uid" + impUid;
        }

        var point = $(this).closest('tr').find('td:eq(6)').text().replace('P', '').trim();
        var status = $(this).closest('tr').find('td:eq(7)').text();
        var detail = $(this).closest('tr').find('td:eq(3)').text().trim();
        var paymentId = $(this).next('input[name="paymentId"]').val();

        var paymentTypeText = "";
        if (paymentType == "0") {
            paymentTypeText = "정기기부";
        } else if (paymentType == "1") {
            paymentTypeText = "기부박스";
        } else if (paymentType == "3") {
            paymentTypeText = "굿즈샵";
        }

        $('#selectedPaymentType').text(paymentTypeText);
        $('#selectedImpUid').text(impUid);
        $('#selectedPoint').text(point);
        $('#selectedStatus').text(status.trim());
        $('#selectPayment').text(detail);

        reasonDiv.empty();

        if (paymentType == 3) {
            reasonDiv.append('<label><input type="radio" name="reason" value="0"> 단순변심</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="1"> 결제오류</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="2"> 상품문제</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="3"> 배송문제</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="4"> 기타</label>');
        } else {
            reasonDiv.append('<label><input type="radio" name="reason" value="0"> 단순변심</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="1"> 결제오류</label>');
            reasonDiv.append('<label><input type="radio" name="reason" value="4"> 기타</label>');
        }

        refundButton.prop('disabled', false);

        $('#hiddenPaymentType').val(paymentType);
        $('#hiddenImpUid').val(impUid);
        $('#hiddenPoint').val(point);
        $('#hiddenAmount').val(amount);
        $('#hiddenId').val(paymentId);
    });

    $(document).on('change', 'input[name="reason"]', function() {
        if ($(this).val() === '4') {
            $('#otherReason').prop('disabled', false);
        } else {
            $('#otherReason').prop('disabled', true).val('');
        }
    });

    $('#refundForm').on('submit', function(event) {
        event.preventDefault();
        var selectedReason = $('input[name="reason"]:checked').val();

        if (!selectedReason) {
            alert('환불 사유를 선택해주세요.');
            return;
        }

        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/myPage/paymentRefund',
            data: $('#refundForm').serialize(),
            dataType: 'json',
            success: function(param) {
                if (param.result === 'logout') {
                    alert('로그인이 필요합니다.');
                    location.href = '${pageContext.request.contextPath}/member/login';
                } else if (param.result === 'success') {
                    alert('환불 신청이 완료되었습니다.');
                    location.reload();
                } else {
                    alert('환불 신청에 실패했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error(error);
                alert('환불 신청 중 오류가 발생했습니다.');
            }
        });
    });
});

</script>
<style>
    .refund-info {
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 20px;
        width: 500px;
        background-color: #f9f9f9;
        margin: 20px auto;
    }

    .refund-info h3 {
        margin-top: 0;
        font-size: 1.5em;
        color: #333;
    }

    .reason-div {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 15px;
    }

    .reason-div label {
        display: flex;
        align-items: center;
        font-size: 1em;
    }

    .reason-div input[type="radio"] {
        margin-right: 8px;
    }

    #otherReason {
        margin-top: 10px;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-bottom: 15px;
    }

    .total-refund {
        font-size: 1.2em;
        font-weight: bold;
        color: #333;
        margin-bottom: 15px;
    }

    input[type="submit"] {
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 4px;
        padding: 10px 15px;
        font-size: 1em;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
        background-color: #0056b3;
    }
</style>
<div class="container mt-4">
    <h4 class="mb-4">결제내역</h4>
    <div class="row justify-content-left main-content-container">
        <c:if test="${count == 0}">
        <div class="result-display">결제내역이 없습니다.</div>
        </c:if>
        <c:if test="${count > 0}">
        	<div class="align-left">
        		<small>챌린지 결제는 현재 페이지에서 환불 신청할 수 없습니다.</small>
        	</div>
            <table class="table table-clean align-center">
                <thead>
                    <tr>
                        <th></th>
                        <th>분류</th>
                        <th>일자</th>
                        <th>내역</th>
                        <th>결제액</th>
                        <th>기부액</th>
                        <th>사용포인트</th>
                        <th>결제상태</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 데이터 행 추가 -->
                    <c:forEach var="payment" items="${list}">
                        <tr>
                            <td>
                                <input type="radio" name="refundCheck" data-type="${payment.type}" data-id="${payment.payment_id}" data-amount="${payment.price}" id="refund_radio_${payment.payment_id}" data-date="${payment.pay_date}"
                                data-status="${payment.status}">
                                <input type="hidden" name="paymentId" value="${payment.id}">                           
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${payment.type == 0}">정기기부</c:when>
                                    <c:when test="${payment.type == 1}">기부박스</c:when>
                                    <c:when test="${payment.type == 2}">챌린지</c:when>
                                    <c:when test="${payment.type == 3}">굿즈샵</c:when>
                                </c:choose>
                            </td>
                            <td>${fn:substring(payment.pay_date, 0, 10)}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${payment.type == 0}"><a href="${pageContext.request.contextPath}/subscription/subscriptionDetail?sub_num=${payment.id}">[${payment.ref}] 카테고리 정기기부</a></c:when>
                                    <c:when test="${payment.type == 1}"><a href="#">[${payment.ref}] 기부박스 기부</a></c:when>
                                    <c:when test="${payment.type == 2}"><a href="#">[${payment.ref}] 챌린지 참여금</a></c:when>
                                    <c:when test="${payment.type == 3}"><a href="#">굿즈샵에서 상품 구매 [구매번호 : ${payment.id}]</a></c:when>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${payment.price}" type="number" minFractionDigits="0" maxFractionDigits="0"/></td>
                            <td>
                                <c:if test="${payment.type == 2}">${payment.donation}</c:if>
                                <c:if test="${payment.type < 2}"><fmt:formatNumber value="${payment.price}" type="number" minFractionDigits="0" maxFractionDigits="0"/></c:if>
                                <c:if test="${payment.type == 3}"><fmt:formatNumber value="${payment.donation}" type="number" minFractionDigits="0" maxFractionDigits="0"/></c:if>
                            </td>
                            <td>${payment.point}P</td>
                            <td>
                                <c:choose>
                                    <c:when test="${payment.status == 0}">
                                        결제완료
                                    </c:when>
                                    <c:when test="${payment.status == 1}">
                                        환불신청
                                    </c:when>
                                    <c:when test="${payment.status == 2}">
                                        결제취소(환불)
                                    </c:when>
                                    <c:when test="${payment.status == 3}">
                                        환불불가
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>
    <div class="align-center">
    	${page}
    </div>
</div>

<div class="refund-info">
    <h3>환불 신청</h3>
    <form id="refundForm">
        <input type="hidden" name="payment_type" id="hiddenPaymentType">
        <input type="hidden" name="imp_uid" id="hiddenImpUid">
        <input type="hidden" name="return_point" id="hiddenPoint">
        <input type="hidden" name="amount" id="hiddenAmount">
        <input type="hidden" name="id" id="hiddenId">

        <div>결제 분류 : <span id="selectedPaymentType"></span></div>
        <div>사용 포인트 : <span id="selectedPoint"></span></div>
        <div>결제 내역 : <span id="selectPayment"></span></div>

        <div class="reason-div">
            <!-- 환불 사유가 여기 추가됩니다. -->
        </div>
        <input type="text" name="reason_other" id="otherReason" placeholder="기타 사유 입력" disabled>

        <div>
            <input type="submit" value="환불 신청" id="refundButton">
        </div>
    </form>
</div>