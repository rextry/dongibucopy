$(function() {
	$('#member_password').submit(function() {
		if ($('#mem_email').val().trim() == "") {
			$('#email_check_msg').text('이메일을 입력해주세요');
			$('#email_check_msg').css('color', '#dc3545');
			$('#mem_email').val('').focus();
			return false;
		}
		
		// 이메일 형식 검증
         if ($('#mem_email').val().indexOf('@') === -1) {
            $('#email_check_msg').text('올바른 이메일 형식으로 입력해주세요');
            $('#email_check_msg').css('color', '#dc3545');
            $('#mem_email').focus();
            return false;
        }
        
        //유효성 검사 통과할 경우
        $('#email_check_msg').css('color', 'black');
        location.href='findPasswordResult';
	});
	
	$('#mem_email').keydown(function() {
		$('#email_check_msg').text('');
		$('#email_check_msg').css('color', 'black');
	});
});