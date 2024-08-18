$(function() {
	$.ajax({
		url: '/member/getUnreadCount',
		type: 'get',
		dataType: 'json',
		success: function(param) {
					if (param.result == 'logout') {
					} else if (param.result == 'success') {
						if (param.unreadCount > 0) {
							$('.notification-badge').show();
						} else {							
							$('.notification-badge').hide();
						}
					} else {
						alert('알림 불러오기 오류 발생');
					}
		},
		error: function() {
			alert('네트워크 오류 발생');
		}
	});
	
	
	let hideTimeout;
	let notificationsLoaded = false;

	$('#notify_icon').on('mouseenter', function() {
    clearTimeout(hideTimeout);
    if (!notificationsLoaded) {
        $.ajax({
            url: '/member/getNotification',
            type: 'GET',
            dataType: 'json',
            success: function(param) {
                if (param.result == 'logout') {
                    alert('로그인 후 사용하세요');
                    location.href = "../login";
                } else if (param.result == 'success') {
                    var notifyList = param.list;
                    $('#notify_icon_list').empty();
                    // 리스트가 존재하는지 확인
                    if (Array.isArray(notifyList) && notifyList.length > 0) {
                        // 반복문을 통해 리스트 항목을 생성하고 추가
                        notifyList.forEach(function(item) {
                            // 알림이 발생한 시간을 계산
                            var notificationTime = new Date(item.not_datetime);                            
                            var currentTime = new Date();                      
                            var timeDiff = Math.abs(currentTime - notificationTime);
                            var timeAgo;

                            // 시간 차이를 분, 시간, 일 단위로 변환
                            var diffMinutes = Math.floor(timeDiff / (1000 * 60));
                            var diffHours = Math.floor(timeDiff / (1000 * 60 * 60));
                            var diffDays = Math.floor(timeDiff / (1000 * 60 * 60 * 24));

                            if (diffMinutes < 60) {
                                timeAgo = diffMinutes + '분 전';
                            } else if (diffHours < 24) {
                                timeAgo = diffHours + '시간 전';
                            } else {
                                timeAgo = diffDays + '일 전';
                            }

                            // 각 항목으로 <li> 요소 생성
                            var listItem = $(`
                                <li class="notify-item-a px-2 py-1 border-bottom border-1 clickable" data-num="${item.not_num}" data-url="${item.not_url}">
                                    <small>${item.not_message} (${timeAgo})</small>
                                </li>
                            `);

                            // 읽지 않은 항목의 배경색을 연한 하늘색으로 설정
                            if (item.not_read_datetime === null) {
                                listItem.css('background-color', '#e6f1fa');
                            } else {  // 읽은 항목의 배경색을 연한 회색으로 설정
                                listItem.css('background-color', '#f5f5f5');
                            }

                            // 생성한 <li> 요소를 <ul>에 추가
                            $('#notify_icon_list').append(listItem);
                        });
                    } else {
                        var emptyMessage = $('<li class="px-2 py-1"><small>최근 14일 간 알림이 없습니다.</small></li>');
                        $('#notify_icon_list').append(emptyMessage);
                    }

                    notificationsLoaded = true; // 데이터를 로드했음을 표시
                    $('#notify_icon_list').addClass('show');
                } else {
                    alert('알림 불러오기 오류 발생');
                }
            },
            error: function() {
                alert('네트워크 오류 발생');
            }
        });
    } else {
        $('#notify_icon_list').addClass('show');
    }
});


	$('#notify_icon').on('mouseleave', function() {
		hideTimeout = setTimeout(function() {
			$('#notify_icon_list').removeClass('show');
		}, 300);
	});

	$('#notify_icon_list').hover(
		function() {
			clearTimeout(hideTimeout);
		},
		function() {
			hideTimeout = setTimeout(function() {
				$('#notify_icon_list').removeClass('show');
			}, 300);
		}
	);

	$(document).on('click', '.notify-item-a', function() {
		let not_num = $(this).data('num');
		let not_url = $(this).data('url');
		$.ajax({
			url: '/member/readNotification',
			type: 'post',
			data: {not_num: not_num},
			dataType: 'json',
			success: function(param) {
					if (param.result == 'logout') {
						alert('로그인 후 사용하세요');
						location.href = "../login";
					} else if (param.result == 'success') {
						location.href=not_url;
					} else {
						alert('알림 불러오기 오류 발생');
					}
			},
			error: function() {
				alert('네트워크 오류 발생');
			}
		});
	});
});