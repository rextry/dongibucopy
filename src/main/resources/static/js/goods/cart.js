let totalAmount;
let pointUsed; // 전역 변수로 설정
document.addEventListener("DOMContentLoaded", function() {
    let itemName = "${goods.item_name}";
    let itemPrice = "${goods.item_price}";
    let buyerName = "${sessionScope.user.mem_nick}";
    let itemNum = "${goods.item_num}";
    let pageContextPath = document.getElementById('contextPath').dataset.contextPath; 
    

    if (document.getElementById("purchaseButton")) {
        document.getElementById("purchaseButton").addEventListener("click", function() {
			// 선택된 항목을 가져옴
			var selectedItems = $('input[name="cart_num"]:checked');
			
			if (selectedItems.length === 0) {
			    alert("선택된 항목이 없습니다.");
			    return;
			}
			
            $('#staticBackdrop').modal('show');
            updateTotalAmount();
        });
    }

    $(document).on('keyup', '.calculate', function() {
        updateTotalAmount();
    });

    document.getElementById('confirm_purchase_button').addEventListener('click', function() {
        confirmPurchase(pageContextPath);
    });
});

function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

function updateTotalAmount() {
    var selectedCarts = [];
    $('input[name="cart_num"]:checked').each(function() {
        var cartNum = $(this).val();
        var quantity = $('#cart_quantity_' + cartNum).val();
        var price = parseInt($('#price_' + cartNum).text().replace(/,/g, ''), 10);
        selectedCarts.push({ item_num: parseInt(cartNum, 10), cart_quantity: parseInt(quantity, 10), price: price });
    });

    totalAmount = 0;
    selectedCarts.forEach(cart => {
        totalAmount += cart.price * cart.cart_quantity;
    });

    let point =$('#goods_do_point').val();
    
    console.log(point);
    
	if (point == '' || point == null) {
		point = 0;
	} else {
		point = parseInt($('#goods_do_point').val());
	}
    
    let mem_point = parseInt($('#mem_point').val());

    if (point > mem_point) {
        $('#goods_do_point').val(mem_point);
        point = mem_point;
    }

    if (totalAmount === point) {
        totalAmount = 0;
    } else if (totalAmount > point) {
        totalAmount -= point;
    } else if (totalAmount < point) {
        $('#no').html('<small>기부금액보다 포인트가 클 수 없습니다.</small>');
        return;
    }
    pointUsed = point; // 전역 변수로 설정
    $('#pay_sum').text(totalAmount.toLocaleString());
    $('#pay_price').val(totalAmount);
}

function confirmPurchase(pageContextPath) {
	
    let buyerName = "${sessionScope.user.mem_nick}";
    let deliveryAddress = document.getElementById('delivery_address').value;

    var selectedCarts = [];
    let hasInvalidStock = false; // 재고 부족 여부 확인 변수
    $('input[name="cart_num"]:checked').each(function() {
        var cartNum = $(this).val();
        var itemNum = $('#cart_quantity_' + cartNum).data('item-num'); // Ensure this is set correctly in HTML
        var quantity = $('#cart_quantity_' + cartNum).val();
        var stock = parseInt($('#stock_' + cartNum).text()); // 재고 확인
        if (stock < 1) {
            hasInvalidStock = true;
        }
        var price = parseInt($('#price_' + cartNum).text().replace(/,/g, ''), 10);
        selectedCarts.push({ item_num: parseInt(itemNum, 10), cart_quantity: parseInt(quantity, 10), price: price });
        // 재고 부족시 에러 메시지
    });
    if (hasInvalidStock) {
        alert("재고가 부족하여 구매할 수 없습니다.");
        return;
    }

    let pamount = totalAmount; // 결제금액 - 포인트
    let pay_price = totalAmount + pointUsed; // 포인트를 적용하기 전의 총 결제 금액

    if (totalAmount === 0 && pointUsed > 0) {
        if (confirm('전액 포인트로 결제하시겠습니까?')) {
            $.ajax({
                url: pageContextPath + '/goods/purchaseComplete',
                method: 'POST',
                data: JSON.stringify({
                    imp_uid: null,
                    merchant_uid: "dongibuup",
                    pamount: 0,
                    pay_price: pay_price,
                    pay_status: 0,
                    item_name: "장바구니 구매",
                    buyer_name: buyerName,
                    cart_items: selectedCarts,
                    point_used: pointUsed, // 사용된 포인트 추가
                    delivery_address: deliveryAddress // 주소 값 추가
                }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(param) {
                    if (param.result == 'logout') {
                        alert('로그인 후 사용하세요.');
                    } else if (param.result == 'success') {
                        alert('포인트 결제가 완료되었습니다.');
                        window.location.href = pageContextPath + '/goods/purchaseHistory';
                    }
                },
                error: function() {
                    alert('포인트 결제 오류 발생');
                }
            });
        }
        return;
    }

    if (totalAmount >= 1 && totalAmount <= 99) {
        alert('결제는 100원 이상부터 가능합니다.');
        return;
    }

    IMP.init("imp63281573");
    IMP.request_pay(
        {
            pg: "tosspayments",
            merchant_uid: "merchant_" + new Date().getTime(),
            name: "장바구니 구매",
            pay_method: "card",
            amount: totalAmount,
            buyer_name: buyerName,
            currency: "KRW",
        },
        (rsp) => {
            if (!rsp.error_code) {
                $.ajax({
                    url: pageContextPath + '/goods/paymentVerify/' + rsp.imp_uid,
                    method: 'POST',
                }).done(function(data) {
                    if (data.response.status == 'paid') {
                        $.ajax({
                            url: pageContextPath + '/goods/purchaseFromCart',
                            method: 'POST',
                            data: JSON.stringify({
                                imp_uid: rsp.imp_uid,
                                merchant_uid: rsp.merchant_uid,
                                pamount: totalAmount,
                                pay_price: pay_price,
                                status: data.response.status,
                                item_name: "장바구니 구매",
                                buyer_name: buyerName,
                                cart_items: selectedCarts,
                                point_used: pointUsed, // 사용된 포인트 추가
                                delivery_address: deliveryAddress // 주소 값 추가
                            }),
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            success: function(param) {
                                if (param.result == 'success') {
                                    alert('구매가 완료되었습니다.');
                                    window.location.href = pageContextPath + '/goods/purchaseHistory';
                                } else {
                                    alert('구매 처리 중 오류가 발생했습니다.');
                                }
                            },
                            error: function(xhr, status, error) {
                                alert('구매 처리 오류 발생: ' + error);
                            }
                        });
                    } else {
                        alert('결제 검증 중 오류가 발생했습니다.');
                    }
                }).fail(function(jqXHR, textStatus, errorThrown) {
                    alert('결제 검증 요청 실패: ' + errorThrown);
                });
            } else {
                alert('결제에 실패했습니다: ' + rsp.error_msg);
            }
        }
    );
}
