$(document).ready(function () {
		// 익명 여부 체크박스 상태 변경 시 이벤트 처리
		$('#anonymousCheck').change(function() {
				if ($(this).is(':checked')) {
					$('#sub_name').val('익명');
				} else {
					$('#sub_name').val('');
				}
			});

		// 결제 수단 변경 시 이벤트 처리
	    $('.payment-method').click(function() {
	        var radio = $(this).find('input[type="radio"]');
	        if (radio.length) {
	            radio.prop('checked', true);
	            $('.payment-method').removeClass('selected');
	            $(this).addClass('selected');
	            
	            if (radio.val() === 'easy_pay') { //간편결제 선택시
	                $('#card-options').slideUp();
	                $('.easypay-container').slideDown();
	                // 선택된 카드의 체크 해제
	                $('input[name="selectedCard"]').prop('checked', false);
	                $('#newCardname').val('');
	                $('#newCardNickname').slideUp();
	            } else { 		//카드 결제 선택시
	                $('.easypay-container').slideUp();
	                $('#card-options').slideDown();
	             // 선택된 이지페이 수단 체크 해제
	                $('.easypay_method').removeClass('selected');
	            }
	        }
	    });

	    // 새 카드 등록 클릭 시 이벤트 처리 
		$('#newCard').click(function() {
                    $('#newCardNickname').slideDown();
        $('.oldCard').click(function(){
                    $('#newCardNickname').slideUp(function() {
                        $('#newCardname').val('');
                    });
				});
			});
	    
		$('.easypay_method').click(function() {
			var radio = $(this).find('input[type="radio"]');
			if (radio.length) {
				radio.prop('checked', true);
				$('.easypay_method').removeClass('selected');
				$(this).addClass('selected');
			}
		});

			//조건체크
			$('#registerSubscription').submit(function(event) {
				// 기부 금액 체크박스 중 하나가 선택되었는지 확인
				if (!$("input[name='sub_price']").is(":checked")) {
					alert("기부 금액을 선택해주세요.");
					return false;
				}
				if (!$("input[name='sub_method']").is(":checked")) {
					alert("결제수단을 선택해주세요");
					return false;
				}
				if (!$("input[type='checkbox']").is(":checked")) {
					if ($('#sub_name').val().trim() == '') {
						alert("익명 기부 선택이나 기부하실 이름을 입력해주세요.");
						return false;
					}
				}
				// 간편결제를 선택했으나, 간편결제 플랫폼을 선택하지 않은 경우
				if($('#easy_pay').is(":checked") && !$("input[name='easypay_method']").is(":checked")){
					alert('사용하실 간편결제 플랫폼을 선택해주세요.');
					return false;
				}
				// 카드를 선택했으나, 어떤 카드를 사용할지 선택하지 않은 경우
				if($('#card').is(":checked") && !$("input[name='selectedCard']").is(":checked")){
					alert('사용하실 카드를 선택해주세요.');
					return false;
				}
				//  새 카드 등록을 선택했으나, 카드 별명을 입력하지 않았을 때
				if($('#card').is(":checked") && $('#newCard').is(":checked") && $('#newCardname').val().trim() == ''){
					alert('등록하실 카드의 별명을 명시해주세요.');
					return false;
				}
			});
			
			$('input[name="selectedCard"]').change(function() {
				if ($(this).val() == 'newCard') {
					$('#newCardNickname').show();
					$('#card_nickname').val('');
				} else {
					$('#newCardNickname').hide();
					$('#card_nickname').val($(this).val());
				}
			});
			$('#newCardname').on('input', function() {
				$('#card_nickname').val($(this).val());
			});

			$('#paybutton').click(function() {
				// mem_num의 값을 가져옴
				var mem_num = $('#mem_num').val();
				// 만약 mem_num이 비어있으면(로그인되어 있지 않으면)
				if (!mem_num) {
					// 로그인 페이지로 리다이렉트
					window.location.href = '/member/login'; // 로그인 페이지의 URL로 수정 필요
				} else {
					// mem_num이 존재하면 정상적으로 기부 시작하기 로직 실행
					$('#staticBackdrop').modal('show'); // 모달 창 열기 등
				}
			});
		 	let today = new Date();
       		// 다음 달의 오늘 날짜 계산
         	if (today.getDate() > 28) {
     
            $("#paymentDateInfo").text(28);
            $("#sub_date").val(28);
	}
});