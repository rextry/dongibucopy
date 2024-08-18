$(function() {
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

	let err_msg = $('.form-error')
	/*===============================
		이메일 중복체크
	================================*/
	let email_check_msg = $('#email_check_msg');
	let email_checked = 0;
	$('#mem_email').blur(function() {
		if ($('#mem_email').val().trim() != '' && $('#mem_email').val().includes("@")) {
			//서버와 통신
			$.ajax({
				url: '/member/checkEmail',
				type: 'get',
				data: { mem_email: $('#mem_email').val() },
				dataType: 'json',
				success: function(param) {
					if (param.result == "exist") {
						email_checked = 0;
						err_msg.text('');
						email_check_msg.text('사용할 수 없는 이메일입니다');
						email_check_msg.css('color', '#dc3545');
					} else if (param.result == "notExist") {
						email_checked = 1;
						err_msg.text('');
						email_check_msg.text('사용 가능한 이메일입니다');
						email_check_msg.css('color', 'green');
					} else {
						alert('이메일 체크 오류 발생');
					}
				},
				error: function() {
					alert('네트워크 오류 발생');
				}
			});
		}

	});

	//이메일 다시 입력시 알림 메세지 없애기
	$('#mem_email').on('keyup', function() {
		email_checked = 0;
		email_check_msg.text('');
	});


	/*===============================
		닉네임 중복체크
	================================*/
	let nick_check_msg = $('#nick_check_msg');
	let nick_checked = 0;
	$('#mem_nick').blur(function() {
		if ($('#mem_nick').val().trim()) {
			//서버와 통신
			$.ajax({
				url: '/member/checkNick',
				type: 'get',
				data: { mem_nick: $('#mem_nick').val() },
				dataType: 'json',
				success: function(param) {
					if (param.result == "exist") {
						nick_checked = 0;
						err_msg.text('');
						nick_check_msg.text('사용할 수 없는 닉네임입니다');
						nick_check_msg.css('color', '#dc3545');
					} else if (param.result == "notExist") {
						nick_checked = 1;
						err_msg.text('');
						nick_check_msg.text('사용 가능한 닉네임입니다');
						nick_check_msg.css('color', 'green');
					} else {
						alert('닉네임 체크 오류 발생');
					}
				},
				error: function() {
					alert('네트워크 오류 발생');
				}
			});
		}

	});

	//닉네임 다시 입력시 알림 메세지 없애기
	$('#mem_nick').on('keyup', function() {
		nick_checked = 0;
		nick_check_msg.text('');
	});

	/*===============================
		전송방지
	================================*/
	$('#member_signup').submit(function(event) {
		if (pw_checked == 0 || email_checked == 0 || nick_checked == 0) {
			$('#mem_email').trigger('blur');
			$('#mem_nick').trigger('blur');
			$('#check_pw').trigger('blur');
		}
	});

	$('#member_social_signup').submit(function(event) {
		if (nick_checked == 0 && $('#mem_nick').val().trim().length != 0) {
			//이벤트 트리거 일으키기
			event.preventDefault();
			$('#mem_nick').trigger('blur');
		}
	});
});
