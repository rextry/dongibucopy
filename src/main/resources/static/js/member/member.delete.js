/*$(function() {
	if (mem_reg_type == "1") {
		console.log("일반회원");
		
	//비밀번호 체크
	$('#mem_pw').on('blur', function() {
		const mem_pw = $(this).val();

		$.ajax({
			url: 'checkPassword',
			method: 'POST',
			data: { currentPassword: mem_pw },
			dataType: 'json',
			success: function(param) {
				const feedbackElement = $('#password_feedback');
				const inputElement = $('#mem_pw');
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
	}
});*/