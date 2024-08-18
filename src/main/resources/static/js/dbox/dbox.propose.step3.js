$(function(){
	//기부박스 대표이미지
	let photo_path = $('#preview').attr('src');
	$('#dbox_photo_file').change(function(){
		
		my_photo = this.files[0]; //선택한 이미지 저장
		if (!my_photo) { //선택하려다 취소한 경우
			$('#preview').attr('src', photo_path);
			return;
		}

		if (my_photo.size > 10240 * 1024) {
			alert(Math.round(my_photo.size / 1024) + 'kbytes(10240kbytes까지만 업로드 가능)');
			$('#preview').attr('src', photo_path);
			$('#dbox_photo_file').val('');
			return;
		}

		//이미지 미리보기 처리
		const reader = new FileReader();
		reader.readAsDataURL(my_photo);

		reader.onload = function() {
			$('#preview').attr('src', reader.result);
		};
	});
	$('#step3').submit(function(){
	//기부박스 제목 유효성체크
	if($('#dbox_title').val().trim()=='' || !(/^.{0,50}$/).test($('#dbox_title').val())){
		alert('기부박스 제목 입력 필수(최대50자)');
		$('#dbox_title').val('').focus();
		return false;
	}
	//기부박스 대표이미지 유효성체크
	if($('#dbox_photo_file').val().trim()==''){
		alert('기부박스 대표이미지 업로드 필수');
		$('#dbox_photo_file').val('').focus();
		return false;
	}
	//기부박스 내용 유효성체크
	if($('#dbox_content').val().trim()==''){
		alert('기부박스 내용 입력 필수');
		$('#dbox_content').val('').focus();
		return false;
	}
		
	});//end of submit
});