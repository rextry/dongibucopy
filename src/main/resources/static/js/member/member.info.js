$(function() {
	/*===============================
		  회원 프로필사진 수정
	================================*/
	$('#photo_choice').click(function() {
		$('#mem_photo').click();

		//처음 화면에 보여지는 이미지 읽기
		let photo_path = $('.my-photo').attr('src');

		//파일 선택 이벤트 연결
		$('#mem_photo').change(function() {
			my_photo = this.files[0]; //선택한 이미지 저장
			if (!my_photo) { //선택하려다 취소한 경우
				$('.my-photo').attr('src', photo_path);
				return;
			}

			if (my_photo.size > 1024 * 1024) {
				alert(Math.round(my_photo.size / 1024) + 'kbytes(1024kbytes까지만 업로드 가능)');
				$('.my-photo').attr('src', photo_path);
				$(this).val('');
				return;
			}

			//이미지 미리보기 처리
			const reader = new FileReader();
			reader.readAsDataURL(my_photo);

			reader.onload = function() {
				$('.my-photo').attr('src', reader.result);
			};

			//선택한 사진이 있으면 ajax 요청
			if (this.files[0]) {
				const form_data = new FormData();
				form_data.append('upload', this.files[0]);

				//서버와 통신
				$.ajax({
					url: 'modifyMemPhoto',
					type: 'post',
					data: form_data,
					dataType: 'json',
					contentType: false,
					processData: false,
					success: function(param) {
						if (param.result == 'logout') {
							alert('로그인 후 사용하세요');
							location.href = "../login";
						} else if (param.result == 'success') {
							//교체된 이미지 저장
							photo_path = $('.my-photo').attr('src'); //다시 작업할 수도 있기 때문에 저장해둠
							//삭제버튼 보이게
							$('#photo_del').show();
						} else {
							alert('파일 전송 오류 발생');
						}
					},
					error: function() {
						alert('네트워크 오류 발생');
					}
				});
			} //end of if
		}); //end of onchange
	}); //photo_choice click 이벤트

	/*===============================
		  회원 프로필사진 삭제
	================================*/
	$('#photo_del').click(function() {
		let photo_del = $(this);
		//서버와 통신
		$.ajax({
			url: 'deleteMemPhoto',
			type: 'post',
			dataType: 'json',
			success: function(param) {
				if (param.result == 'logout') {
					alert('로그인 후 사용하세요');
					location.href = "../login";
				} else if (param.result == 'success') {
					$('.my-photo').attr('src', contextPath + '/images/basicProfile.png'); //이미지 안보이게 처리
					photo_del.hide(); //삭제 버튼 안보이게
				} else {
					alert('파일 삭제 오류 발생');
				}
			},
			error: function() {
				alert('네트워크 오류 발생');
			}
		});
	});
	
	/*===============================
		닉네임 중복체크
	================================*/
	let err_msg = $('.form-error')
	let nick_check_msg = $('#nick_check_msg');
	let nick_checked = 1;
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
					} else if (param.result == "notChanged") {
						nick_checked = 1;
						err_msg.text('');
						nick_check_msg.text('');
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
		전송 버튼 매핑
	================================*/
    $('#update_btn').click(function(event) {
        event.preventDefault();
        $('#update_btn_hide').click();
    });

	/*===============================
		전송방지
	================================*/
	$('#member_update').submit(function() {
		
		if (nick_checked == 0) {
			$('#mem_nick').trigger('blur');
			return false;
		}
		
		let phone2 = $('#phone2').val();
		let phone3 = $('#phone3').val();
		
		console.log('phone2:', phone2);
		console.log('phone3:', phone3);
		
		let birth_year = $('#birth_year').val();
		let birth_month = $('#birth_month').val();
		let birth_day = $('#birth_day').val();
		
		if (phone2 == "" && phone3 == "") {// phone2와 phone3 둘 다 빈 문자열인 경우를 처리
		    $('#mem_phone').val('');
		} else { 
		    $('#mem_phone').val('010' + phone2 + phone3);
		}
		
		$('#mem_birth').val(formatBirthDate(birth_year, birth_month, birth_day));
		
	});

  const yearSelect = $('#birth_year');
  const monthSelect = $('#birth_month');
  const daySelect = $('#birth_day');
  
  const birthYear = $('#birth_year').attr('data-year');
  const birthMonth = $('#birth_month').attr('data-month');
  const birthDay = $('#birth_day').attr('data-day');
  
  console.log(birthYear, birthMonth, birthDay);

  // 년도 옵션 추가
  const currentYear = new Date().getFullYear();
  for (let year = currentYear; year >= 1900; year--) {
    yearSelect.append(`<option value="${year}">${year}</option>`);
  }

  // 월 옵션 추가
  const months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  $.each(months, function(index, month) {
    monthSelect.append(`<option value="${month}">${month}</option>`);
  });

  // 일 옵션 추가 (1일부터 31일까지)
  for (let day = 1; day <= 31; day++) {
    daySelect.append(`<option value="${day}">${day}</option>`);
  }
  
   // 서버에서 전달된 값으로 미리 선택
  if (birthYear) {
    yearSelect.val(birthYear);
  }
  if (birthMonth) {
    monthSelect.val(birthMonth);
  }
  if (birthDay) {
    daySelect.val(birthDay);
  }

});

function formatBirthDate(year, month, day) {
    // 월과 일이 한 자리 수일 경우 앞에 0을 붙여줌
    let birth_month = ('0' + month).slice(-2);
    let birth_day = ('0' + day).slice(-2);

    // 결과를 합쳐서 반환
    return year + birth_month + birth_day;
}