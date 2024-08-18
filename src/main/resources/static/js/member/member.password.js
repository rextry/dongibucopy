$(function() {
	let cur_pw_checked = 0;
	/*===============================
		마이페이지 - 비밀번호 변경
	================================*/
	//현재 비밀번호 체크
	$('#current_pw').on('blur', function() {
		const currentPassword = $(this).val();

		$.ajax({
			url: 'checkPassword',
			method: 'POST',
			data: { currentPassword: currentPassword },
			dataType: 'json',
			success: function(param) {
				const feedbackElement = $('#password_feedback');
				const inputElement = $('#current_pw');
				feedbackElement.show();
				if (param.result == "logout") {
					alert('로그인 후 사용하세요');
                    location.href = "../login";
				} else if (param.result == "matched") {
					cur_pw_checked = 1;
					feedbackElement.text('비밀번호가 일치합니다.');
					feedbackElement.css('color', 'green');

					inputElement.css('border-color', 'green');
				} else if (param.result == "notMatched" && currentPassword != "") {
					cur_pw_checked = 0;
					feedbackElement.text('비밀번호가 일치하지 않습니다.');
					feedbackElement.css('color', '#dc3545');

					inputElement.css('border-color', '#dc3545');
					inputElement.val('');
				} else if (currentPassword == "") {
					cur_pw_checked = 0;
					feedbackElement.text('');
					feedbackElement.css('color', 'black');
				
					inputElement.css('border-color', 'black');
				} else if (param.result == "logout") {
					alert('로그인 후 이용해주세요');
				}
			},
			error: function() {
				alert('네트워크 오류 발생');
			}
		});
	});

	//현재 비밀번호 다시 입력시 알림 메세지 없애기
	$('#current_pw').on('keydown', function() {
		const feedbackElement = $('#password_feedback');
		const inputElement = $('#current_pw');
		cur_pw_checked = 0;
		feedbackElement.text('');
		feedbackElement.css('color', 'black');

		inputElement.css('border-color', 'black');
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
		if (pw_checked == 0 || cur_pw_checked == 0) {
			event.preventDefault();
		}
	});
});