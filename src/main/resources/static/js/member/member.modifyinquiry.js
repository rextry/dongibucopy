$(function() {
    /*===============================
                파일 수정
    =================================*/
    // 파일 선택 이벤트 연결
    $('#upload').change(function() {
		
        let file = this.files[0];
        my_photo = this.files[0]; // 선택한 이미지 저장

        if (!file) { // 선택하려다 취소한 경우
        	if (file_deleted == 1) {
				$('#filePreview').hide();
				$('#upload').show();
        		$('#fileupload').hide();
        		return;
			} else {
	            $('#filePreview').show();
	            $('#upload').hide();
	        	$('#fileupload').show();
	            return;
			}
        }

        if (file.size > 52428800) {
            alert(Math.round(file.size / 1024) + 'kbytes(1024kbytes까지만 업로드 가능)');
        	if (file_deleted == 1) {
				$('#filePreview').hide();
				$('#upload').show();
        		$('#fileupload').hide();
        		return;	
			} else {
	            $('#filePreview').show();
	            $('#upload').hide();
	        	$('#fileupload').show();
	            return;			
			}
        }

		$('#filePreview').hide();
       	$('#upload').show();
        $('#fileupload').hide();

    }); // end of onchange

    // 파일 수정 버튼 클릭 이벤트
    $('#fileupload').click(function(event) {
		event.preventDefault();
        $('#upload').click(); // 실제 파일 업로드 버튼 클릭
    });

    //파일 삭제 버튼 클릭 이벤트
    $('#fileDelete').click(function() {
		$('#file_deleted').val("1");
		$('#filePreview').hide();
       	$('#upload').show();
        $('#fileupload').hide();
	});
});
