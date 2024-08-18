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
	
	//정지 버튼 클릭
	$('.suspendBtn').click(function() {
		let mem_nick = $(this).data('nick');
		let mem_num = $(this).data('num');
		
		let mem_item = $(this).closest('.mem-item');
		
		if (confirm(`${mem_nick} 회원을 정지 처리하시겠습니까?`)) {
			$.ajax({
				url:'suspendMember',
				data: {mem_num:mem_num},
				type: 'post',
				dataType: 'json',
				success: function(param) {
					if (param.result == 'logout') {
						alert('로그인 후 이용해주세요');
						location.href = contextPath + '/member/login';
					} else if (param.result == 'success') {
						mem_item.find('.mem-status').text('정지');
						mem_item.find('.suspendBtn').attr('disabled','disabled');
						mem_item.find('.activateBtn').removeAttr('disabled');
						alert('정지되었습니다');
					} else if (param.result == 'noAuthority') {
						alert('관리자 권한이 없습니다');
						location.reload();
					} else {
						alert('회원 정지 오류 발생');
					}
				},
				error: function() {
					alert('네트워크 오류 발생');
				}
			});
		}
	});
	
	//제명 버튼 클릭
	$('.expelBtn').click(function() {
		let mem_nick = $(this).data('nick');
		let mem_num = $(this).data('num');
		
		let mem_item = $(this).closest('.mem-item');
		
		if (confirm(`${mem_nick} 회원을 제명하시겠습니까?`)) {
			$.ajax({
				url:'expelMember',
				data: {mem_num:mem_num},
				type: 'post',
				dataType: 'json',
				success: function(param) {
					if (param.result == 'logout') {
						alert('로그인 후 이용해주세요');
						location.href = contextPath + '/member/login';
					} else if (param.result == 'success') {
						mem_item.find('.mem-status').text('탈퇴');
						mem_item.find('.suspendBtn').attr('disabled','disabled');
						mem_item.find('.activateBtn').attr('disabled','disabled');
						mem_item.find('.expelBtn').attr('disabled','disabled');
						alert('제명되었습니다');
					} else if (param.result == 'noAuthority') {
						alert('관리자 권한이 없습니다');
						location.reload();
					} else {
						alert('회원 제명 오류 발생');
					}
				},
				error: function() {
					alert('네트워크 오류 발생');
				}
			});
		}
	});
	
	//활성화 버튼 클릭
	$('.activateBtn').click(function() {
		let mem_nick = $(this).data('nick');
		let mem_num = $(this).data('num');
		
		let mem_item = $(this).closest('.mem-item');
		
		if (confirm(`${mem_nick} 회원을 활성화 처리하시겠습니까?`)) {
			$.ajax({
				url:'activateMember',
				data: {mem_num:mem_num},
				type: 'post',
				dataType: 'json',
				success: function(param) {
					if (param.result == 'logout') {
						alert('로그인 후 이용해주세요');
						location.href = contextPath + '/member/login';
					} else if (param.result == 'success') {
						mem_item.find('.mem-status').text('일반');
						mem_item.find('.activateBtn').attr('disabled','disabled');
						mem_item.find('.suspendBtn').removeAttr('disabled');
						alert('활성화되었습니다');
					} else if (param.result == 'noAuthority') {
						alert('관리자 권한이 없습니다');
						location.reload();
					} else {
						alert('회원 활성화 오류 발생');
					}
				},
				error: function() {
					alert('네트워크 오류 발생');
				}
			});
		}
	});
});