$(function(){
	$(document).on('click','.activateBtn',function(){
		let choice = confirm('정말 챌린지를 중단하시겠습니까?');
		let challenge = $(this);
		let chal_num = challenge.data('chal-num');
		let chal_phase = challenge.data('phase');
		
		if(choice){
			$.ajax({
				url:'cancelChallengeByAdmin',
				type:'post',
				data:JSON.stringify({
					chal_num:chal_num,
					chal_phase:chal_phase
				}),
				contentType: 'application/json',
				dataType:'json',
				success:function(param){
					if (param.result == 'logout') {
						alert('로그인 후 이용해주세요');
						location.reload();
					} else if (param.result == 'success') {
						alert('챌린지가 중단되었습니다');
						location.reload();
					} else if (param.result == 'noAuthority') {
						alert('관리자 권한이 없습니다');
						location.reload();
					} else {
						alert('챌린지 중단 오류 발생');
					}
				},
				error:function(){
					alert('네트워크 통신 오류');
				}
			});
		}
	});
});