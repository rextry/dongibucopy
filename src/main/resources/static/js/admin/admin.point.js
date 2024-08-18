$(function() {
	//전체보기 버튼 클릭
	$('#allResultBtn').click(function() {
		$('#keyfield').val('');
		$('#keyword').val('');
		$('#order').val('');
		location.href='manageMember';		
	});
	
	//검색 버튼 유효성 체크
	$('#search_form').submit(function(event) {
		if ($('#keyfield').val() == 1) {
			var keyword = $('#keyword').val().trim();
            if (!/^\d+$/.test(keyword)) {
                alert('회원번호는 숫자 형식만 입력 가능합니다.');
                event.preventDefault(); // 폼 제출 중단
            }
		}
	});
	
	$('.updatePointBtn').click(function () {
		let point_input = $(this).closest('td').find('.member-point');
		let mem_point = point_input.val();
		let mem_num = $(this).data('num');
		
		$.ajax({
			url:'updatePoint',
			data: {mem_num:mem_num, mem_point:mem_point},
			type: 'post',
			dataType: 'json',
			success: function(param) {
				if (param.result == 'logout') {
					alert('로그인 후 이용해주세요');
					location.href = contextPath + '/member/login';
				} else if (param.result == 'success') {
					point_input.val(mem_point);
					alert('포인트가 수정되었습니다');
				} else if (param.result == 'noAuthority') {
					alert('관리자 권한이 없습니다');
					location.reload();
				} else {
					alert('포인트 수정 오류 발생');
				}
			},
			error: function() {
				alert('네트워크 오류 발생');
			}
		});
		console.log(mem_point);
	});
});