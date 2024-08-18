$(function(){
    // 좋아요 상태 조회
    function selectFav(chal_num){
        $.ajax({
            url: `${contextPath}/challenge/getFav`,
            type: 'get',
            data: {chal_num: chal_num},
            dataType: 'json',
            success: function(param){
                displayFav(param);
            },
            error: function(){
                alert('네트워크 오류 발생');
            }
        });
    }

    // 좋아요 버튼 클릭 이벤트
    $('#likeBtn').click(function(){
        $.ajax({
            url: `${contextPath}/challenge/writeFav`,
            type: 'post',
            data: {chal_num: $('#likeBtn').attr('data-num')},
            dataType: 'json',
            success: function(param){
                if(param.result == 'logout'){
                    alert('로그인 후 좋아요를 눌러주세요');
                } else if(param.result == 'success'){
                    displayFav(param);
                } else {
                    alert('좋아요 등록/삭제 오류 발생');
                }
            },
            error: function(){
                alert('네트워크 오류 발생');
            }
        });
    });

    // 좋아요 상태 표시
    function displayFav(param){
        if(param.status == 'yesFav') {
            $('#likeIcon').removeClass('bi-heart').addClass('bi-heart-fill');
            $('#likeBtn').addClass('clicked');
        } else if(param.status == 'noFav') {
            $('#likeIcon').removeClass('bi-heart-fill').addClass('bi-heart');
            $('#likeBtn').removeClass('clicked');
        } else {
            alert('좋아요 표시 오류 발생');
        }
        $('#output_fcount').text(param.count);
    }

    // 초기 좋아요 상태 조회
    selectFav($('#likeBtn').attr('data-num'));
});