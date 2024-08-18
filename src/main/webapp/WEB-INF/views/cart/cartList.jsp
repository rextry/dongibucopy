<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 상품 목록 출력 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/goods/cart.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

<div id="contextPath" data-context-path="${pageContext.request.contextPath}"></div>

<script type="text/javascript">
function deleteSelectedCarts() {
    var selectedCarts = [];
    $('input[name="cart_num"]:checked').each(function() {
        selectedCarts.push($(this).val());
    });

    if (selectedCarts.length === 0) {
        alert('삭제할 항목을 선택해주세요.');
        return;
    }

    $.ajax({
        url: $('#contextPath').data('context-path') + '/cart/deleteSelected',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(selectedCarts),
        success: function(response) {
            if(response === 'success') {
                alert('선택된 항목들이 장바구니에서 삭제되었습니다.');
                location.reload();
            } else {
                alert('삭제 실패. 다시 시도해주세요.');
            }
        },
        error: function() {
            alert('에러가 발생했습니다. 다시 시도해주세요.');
        }
    });
}

function updateCartQuantity(cart_num) {
    var newQuantity = $('#cart_quantity_' + cart_num).val();

    $.ajax({
        url: $('#contextPath').data('context-path') + '/cart/updateQuantity',
        type: 'POST',
        data: {
            cart_num: cart_num,
            cart_quantity: newQuantity
        },
        success: function(response) {
            if (response === 'success') {
                alert('수량이 업데이트되었습니다.');
                location.reload();
            } else {
                alert('업데이트 실패. 다시 시도해주세요.');
            }
        },
        error: function() {
            alert('에러가 발생했습니다. 다시 시도해주세요.');
        }
    });
}
function updateCartQuantity(cart_num) {
    var newQuantity = $('#cart_quantity_' + cart_num).val();

    $.ajax({
        url: $('#contextPath').data('context-path') + '/cart/updateQuantity',
        type: 'POST',
        data: {
            cart_num: cart_num,
            cart_quantity: newQuantity
        },
        success: function(response) {
            if (response === 'success') {
                alert('수량이 업데이트되었습니다.');
                location.reload();
            } else {
                alert('업데이트 실패. 다시 시도해주세요.');
            }
        },
        error: function() {
            alert('에러가 발생했습니다. 다시 시도해주세요.');
        }
    });
}
</script>

<div class="page-main">
<h2>장바구니</h2>
<form action="list" id="search_form" method="get">
    <input type="hidden" name="dcate_num" value="${param.dcate_num}">
</form>
<c:if test="${count == 0}">
    <div class="result-display">표시할 상품이 없습니다.</div>
</c:if>
<c:if test="${count > 0}">
<table class="striped-table">
    <thead>
        <tr>
            <th width="80">선택</th>
            <th>사진</th>
            <th width="150">장바구니번호</th>
            <th width="350">상품명</th> <!-- 상품명 열의 너비를 400px에서 500px으로 수정 -->
            <th width="150">가격</th>
            <th>재고</th>
            <th>담은 수량</th>
            <th width="150">수량 업데이트</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="cart" items="${list}">
            <tr>
                <td class="align-center">
                    <input type="checkbox" name="cart_num" value="${cart.cart_num}" data-item-num="${pageContext.request.contextPath}${cart.goods.item_num}">
                </td>
                <td class="align-center">
                    <img src="${pageContext.request.contextPath}${cart.goods.item_photo}" class="my-photo" width="100px" height="100px">
                </td>
                <td class="align-center">${cart.cart_num}</td>
                <td class="align-left">
                    <a href="detail?item_num=${cart.goods.item_num}">${cart.goods.item_name}</a>
                </td>
                <td class="align-center">
                    <span id="price_${cart.cart_num}">
                        <fmt:formatNumber value="${cart.goods.item_price}" type="number" groupingUsed="true"/> 원
                    </span>
                </td>
                <td class="align-center">${cart.goods.item_stock} ea</td>
                <td class="align-center">
                    <input type="number" id="cart_quantity_${cart.cart_num}" value="${cart.cart_quantity}" min="1" max="${cart.goods.item_stock}" data-item-num="${cart.goods.item_num}">
                </td>
                <td class="align-center">
   				<button type="button" class="default-btn btn-large" onclick="updateCartQuantity(${cart.cart_num})">수량 변경</button>
				</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<div align="center">
    <button type="button" onclick="deleteSelectedCarts()">선택 항목 삭제</button>
    <button type="button" id="purchaseButton">선택 항목 구매</button>
</div>
<!-- 모달 창 -->
<div class="modal fade" id="staticBackdrop" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">구매 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- 포인트 입력 필드 -->
                <div class="mb-3 d-flex">
					<label class="g-buy-label" style="width:30%">보유 포인트</label>
                	<span>${user.mem_point}</span>
                </div>
                <div class="mb-3">
                    <label for="goods_do_point" class="form-label">사용할 포인트</label>
                    <input type="number" class="form-control calculate" id="goods_do_point" placeholder="사용할 포인트 입력">
                </div>
                <!-- 결제 금액 출력 필드 -->
                <div class="mb-3">
                    <label class="form-label">결제 금액</label>
                    <span id="pay_sum"></span>
                </div>
                <!-- 주소 입력 필드 -->
                <div class="mb-3">
                    <label for="delivery_address" class="form-label">배송 주소</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="delivery_address" placeholder="배송 받을 주소 입력" readonly>
                        <button type="button" class="btn btn-outline-secondary" onclick="execDaumPostcode()">주소 검색</button>
                    </div>
                </div>
                <!-- 보유 포인트 -->
                <input type="hidden" id="mem_point" value="${sessionScope.user.mem_point}">
                <!-- 결제 금액 메시지 -->
                <div id="no"></div>
                 <!-- 기부처 정보 -->
                <div id="donation_info">
                    구매 금액의 10%는 
                    <c:choose>
                        <c:when test="${goods.dcate_num == 1}">독거노인기본생활 지원</c:when>
                        <c:when test="${goods.dcate_num == 2}">청년 고립 극복 지원</c:when>
                        <c:when test="${goods.dcate_num == 3}">유기동물 구조와 보호</c:when>
                        <c:when test="${goods.dcate_num == 4}">미혼모(한부모가정)</c:when>
                        <c:when test="${goods.dcate_num == 5}">해외 어린이 긴급구호</c:when>
                        <c:when test="${goods.dcate_num == 6}">위기가정 아동지원</c:when>
                        <c:when test="${goods.dcate_num == 7}">쓰레기 문제 해결</c:when>
                        <c:when test="${goods.dcate_num == 8}">장애 어린이 재활 지원</c:when>
                        <c:otherwise>기타</c:otherwise>
                    </c:choose>
                    분야에 전달됩니다.
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="confirm_purchase_button">결제</button>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const quantityInputs = document.querySelectorAll('input[id^="cart_quantity_"]');
        
        quantityInputs.forEach(function(input) {
            const stock = parseInt(input.getAttribute('max'));

            input.addEventListener('input', function() {
                if (this.value > stock) {
                    alert('재고 수량을 초과할 수 없습니다.');
                    this.value = stock;
                } else if (this.value < 1) {
                    this.value = 1;
                }
            });
        });
    });
</script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var jibunAddr = data.jibunAddress; // 지번 주소 변수

                // 사용자가 선택한 주소를 검색 창에 넣습니다.
                document.getElementById('delivery_address').value = roadAddr ? roadAddr : jibunAddr;
            }
        }).open();
    }
</script>
<div align="center">${page}</div>
</c:if>
</div>
