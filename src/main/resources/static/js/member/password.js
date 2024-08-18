$(function() {
	/*===============================
	비밀번호 찾기 - 비밀번호 변경
	================================*/
	let vcode_checked = 0;
	$('#verify_form').submit(function(event) {
		let vcode_feedback = $('#vcode_feedback');
		let vcode_input = $('#vcode')
		if ($('#vcode').val().trim() == '') {
			vcode_feedback.text('인증번호를 입력해주세요');
			vcode_feedback.css('color', '#dc3545');
			vcode_feedback.css('border-color', '#dc3545');
			return false;
		}
		
		$.ajax({
			url: '/member/findPasswordResult/verify',
			data: {vcode: $('#vcode').val()},
			type: 'get',
			dataType:'json',
			success: function(param) {
				if (param.result == "isVerified") {
					vcode_checked = 1;
					vcode_feedback.text('인증번호가 일치합니다');
					vcode_feedback.css('color', 'green');
					vcode_input.css('border-color', 'green');
				} else if (param.result == "isNotVerified") {
					vcode_checked = 0;
					vcode_feedback.text('인증번호가 일치하지 않습니다');
					vcode_feedback.css('color', '#dc3545');
					vcode_input.css('border-color', '#dc3545');
				}
			},
			error: function() {
				alert('네트워크 오류 발생');
			}
		});
		
		event.preventDefault();
	});
	
	//새 비밀번호 다시 입력시 알림 메세지 없애기
	$('#mem_pw').on('keydown', function() {
		const feedbackElement = $('.form-error');
		const inputElement = $('#mem_pw');
		const inputElement2 = $('#check_pw');
		feedbackElement.text('');
		feedbackElement.css('color', 'black');
		inputElement.css('border-color', 'black');
		inputElement2.css('border-color', 'black');
	});
	
	/*===============================
		비밀번호 일치 확인
	================================*/
	let check_pw_msg = $('#check_pw_msg');
	let pw_checked = 0;

	$('#check_pw').blur(function() {
		if ($('#mem_pw').val().trim() != '') {
			if ($('#mem_pw').val() == $('#check_pw').val()) {
				pw_checked = 1;
				check_pw_msg.text('비밀번호가 일치합니다');
				$('#mem_pw').css('border-color', 'green');
				$('#check_pw').css('border-color', 'green');
				check_pw_msg.css('color', 'green');
			} else {
				pw_checked = 0;
				check_pw_msg.text('비밀번호가 일치하지 않습니다');
				$('#mem_pw').css('border-color', '#dc3545');
				$('#check_pw').css('border-color', '#dc3545');
				check_pw_msg.css('color', '#dc3545');
			}
		}
	}); 

	//비밀번호나 비밀번호확인 다시 입력시 알림 메세지 없애기
	$('#mem_pw, #check_pw').on('keyup', function() {
		pw_checked = 0;
		check_pw_msg.text('');
		$('.text-danger').text('');
	});

	//비밀번호 다시 입력시 비밀번호 확인 지우기
	$('#mem_pw').on('keyup', function() {
		pw_checked = 0;
		$('#check_pw').val('');
	});
	
	/*===============================
		전송방지
	================================*/
	$('#change_password').submit(function(event) {
		if (pw_checked == 0 || vcode_checked == 0) {
			event.preventDefault();
		}
	});
});