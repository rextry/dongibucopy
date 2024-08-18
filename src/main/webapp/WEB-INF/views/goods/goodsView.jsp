<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script>
    let itemName = "${goods.item_name}";
    let itemPrice = "${goods.item_price}";
    let buyerName = "${sessionScope.user.mem_nick}";
    let itemNum = "${goods.item_num}";
    let pageContextPath = "${pageContext.request.contextPath}";  
    
    function addToCart() {
        var form = document.getElementById('cartForm');
        form.submit();
    }
</script>

<section class="section-padding nanum col-6 mx-auto">
    <div class="container">
    <h4 class="mb-4">${goods.item_name}</h4>
    
    <div class="detail-info d-flex">
       	<div class="g-photo-div me-4"><img src="${pageContext.request.contextPath}${goods.item_photo}" width="300" height="300" class="my-photo2"></div>
    	<div>
    		<div class="g-basic-info">
	        	<div class="mb-1">재고: ${goods.item_stock}</div>
	        	<div class="mb-1">카테고리: 
    <c:choose>
        <c:when test="${goods.dcate_num == 1}">독거노인기본생활 지원</c:when>
        <c:when test="${goods.dcate_num == 2}">청년 고립 극복 지원</c:when>
        <c:when test="${goods.dcate_num == 3}">유기동물 구조와 보호</c:when>
        <c:when test="${goods.dcate_num == 4}">미혼모(한부모가정)</c:when>
        <c:when test="${goods.dcate_num == 5}">해외 어린이 긴급구호</c:when>
        <c:when test="${goods.dcate_num == 6}">위기가정 아동지원</c:when>
        <c:when test="${goods.dcate_num == 7}">쓰레기 문제 해결</c:when>
        <c:when test="${goods.dcate_num == 8}">장애 어린이 재활 지원</c:when>
    </c:choose>
</div> 
	        	<div class="mb-1">가격: ${goods.item_price}</div>
    		</div>
        	<div class="d-flex mb-1" style="height:36px"><label class="me-1" style="width:5rem">수량:</label><input class="form-control"
        		type="number" id="quantity" name="quantity" value="1" min="1" max="${goods.item_stock}" class="me-2">
        		<form id="purchaseForm" method="post">
		            <input type="hidden" name="merchantUid" value="${goods.item_num}_${System.currentTimeMillis()}">
		            <input type="hidden" id="goods_do_price" name="amount" value="${goods.item_price}">
		            <input type="button" value="구매하기" class="btn btn-outline-success active" id="buy_now_button" style="height:100%">
		        </form>
        	</div>
		    <div>		
		        <form id="cartForm" action="${pageContext.request.contextPath}/cart/insert" method="post">
		            <input type="hidden" name="item_num" value="${goods.item_num}">
		            <input type="hidden" name="item_price" value="${goods.item_price}">
		            <c:if test="${not empty sessionScope.user}">
		                <input type="hidden" name="mem_num" value="${sessionScope.user.mem_num}">
		            </c:if>
		            <div class="d-flex mb-1" style="height:36px">
		            	<label for="cart_quantity" class="me-1" style="width:5rem">수량:</label><input class="form-control"
		             	type="number" id="cart_quantity" name="cart_quantity" value="1" min="1" max="${goods.item_stock}">
		            	<input type="button" value="장바구니" class="btn btn-outline-success active" onclick="addToCart()">
		            </div>
		        </form>
			</div>
    	</div>
    </div>
    

	
    <div class="detail-content">${goods.item_detail}</div>
	
	<div class="align-right">
		<input type="button" value="목록" class="g-custom-btn" onclick="location.href='list'">
	</div>
	<hr size="1" width="100%">
	</div>
</section>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const quantityInput = document.getElementById('quantity');
        const stock = parseInt("${goods.item_stock}");
        
        quantityInput.addEventListener('input', function() {
            if (this.value > stock) {
                alert('재고 수량을 초과할 수 없습니다.');
                this.value = stock;
            } else if (this.value < 1) {
                this.value = 1;
            }
        });
    });
</script>
<!-- 다음 주소 검색 API -->
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

<!-- 모달 창 -->
<div class="modal fade nanum" id="staticBackdrop" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
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
                <div class="mb-2 d-flex justify-content-start align-items-center">
                    <label for="goods_do_point" class="form-label g-buy-label" style="width:30%">사용할 포인트</label>
                    <input type="number" class="form-control calculate" id="goods_do_point" placeholder="사용할 포인트 입력" style="width:50%">
                </div>
                <!-- 결제 금액 출력 필드 -->
                <div class="mb-3">
                    <label class="form-label g-buy-label" style="width:30%">결제 금액</label>
                    <span id="pay_sum">${goods.item_price}</span>
                </div>
                <!-- 주소 입력 필드 -->
                <div class="mb-3">
                    <label for="delivery_address" class="form-label g-buy-label">배송 주소</label>
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
<script src="${pageContext.request.contextPath}/js/goods/purchase.js"></script>
