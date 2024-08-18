$(function() {
    let rowCount = 3;
    let currentPage = 1;
    let loading = false;
    let hasMoreData = true;
    let chal_type = '';
    let keyword = '';
    let freqOrder = '';
    let order = '';
    var realIdx = 0;

    // 카테고리 링크 클릭 이벤트
    $('.category-link').on('click', function(e) {
        e.preventDefault();
        chal_type = $(this).data('category');
        hasMoreData = true;
        $('#output').empty();
        currentPage = 1;
        selectList(currentPage);
    });

    //인증 빈도 선택 이벤트
    $('.freqOrder').on('change', function() {
        freqOrder = $(this).val();
        hasMoreData = true;
        $('#output').empty();
        currentPage = 1;
        selectList(currentPage);
    });

    //검색 이벤트
    $('#searchTitle').on('submit', function(e) {
        e.preventDefault();
        keyword = $(this).find('input[type="search"]').val();
        if (keyword == '') {
            alert('검색어를 입력하세요');
            return false;
        }

        hasMoreData = true;
        $('#output').empty();
        currentPage = 1;
        selectList(currentPage);
    });

    //정렬 선택 이벤트
    $('.order').on('change', function() {
        order = $(this).val();
        hasMoreData = true;
        $('#output').empty();
        currentPage = 1;
        selectList(currentPage);
    });

    /*---------------------
     * 챌린지 목록
     *---------------------*/
    function selectList(page) {
        if (loading || !hasMoreData) return;

        loading = true;

        $.ajax({
            url: 'addlist',
            type: 'get',
            data: {
                pageNum: page,
                rowCount: rowCount,
                chal_type: chal_type,
                freqOrder: freqOrder,
                keyword: keyword,
                order: order,
                chal_sdate: 'list'
            },
            dataType: 'json',
            success: function(param) {

                if (page * rowCount >= param.count) {
                    hasMoreData = false;
                    const scrollTarget = document.querySelector('#scroll-target');
                    if (scrollTarget) {
                        observer.unobserve(scrollTarget);
                    }
                }
                //챌린지 목록 작업
                let output = '';
                $(param.challengeDetailsList).each(function(index, item) {
                    realIdx = (page - 1) * rowCount + index;
                    let challenge = item.challenge;
                    let isJoined = item.isJoined;
                    let currentParticipants = item.currentParticipants;

                    let sdate = new Date(challenge.chal_sdate);
                    let now = new Date();
                    now.setHours(0, 0, 0, 0); // 시간 부분을 0으로 설정
                    sdate.setHours(0, 0, 0, 0);
                    output += '<div class="col-lg-4 col-md-6 col-12 nanum" style="margin-bottom: 30px;">';
                    output += '<div class="custom-block-wrap">';
                    
                    // 이미지와 참가 인원 오버레이
                    output += '<div class="image-wrapper">';
                    if (challenge.chal_photo) {
                        output += '<img src="' + pageContext + '/upload/' + challenge.chal_photo + '" class="custom-block-image img-fluid" >'; //챌린지 썸네일
                    } else {
                        output += '<img src="' + pageContext + '/images/챌린지_기본이미지.jpg" class="custom-block-image img-fluid" >'; //챌린지 썸네일 - 기본 이미지
                    }
                    output += '<div class="participants-overlay"><i class="bi bi-person-fill"></i> ' + currentParticipants + '명</div>';
                    output += '</div>';
                    
                    output += '<div class="custom-block">';
                    output += '<div class="custom-block-body">';
                    
                    output += '<h5 class="mb-3">' + challenge.chal_title + '</h5>';
                    output += '<p>';
                    if (challenge.mem_photo) {
                        output += '<img src="' + pageContext + '/upload/' + challenge.mem_photo + '" width="20" height="20" class="profile-pic">'; //프사
                    } else {
                        output += '<img src="' + pageContext + '/images/basicProfile.png" width="20" height="20" class="profile-pic">'; //프사
                    }
                    output += ' <span>' + challenge.mem_nick + '</span>';
                    output += '</p>';

                    output += '<div class="d-flex align-items-center my-2">';
                    output += '<p class="mb-0">';
                    if (challenge.chal_freq == 7) {
                        output += '<strong>매일</strong>';
                    } else if (challenge.chal_freq == 1) {
                        output += '<strong>주 1일</strong>';
                    } else if (challenge.chal_freq == 2) {
                        output += '<strong>주 2일</strong>';
                    } else if (challenge.chal_freq == 3) {
                        output += '<strong>주 3일</strong>';
                    } else if (challenge.chal_freq == 4) {
                        output += '<strong>주 4일</strong>';
                    } else if (challenge.chal_freq == 5) {
                        output += '<strong>주 5일</strong>';
                    } else if (challenge.chal_freq == 6) {
                        output += '<strong>주 6일</strong>';
                    }
                    output += '</p>';

                    output += '<p class="ms-auto mb-0">';
                    if (sdate.getTime() == now.getTime()) {
                        output += '<strong>오늘부터 시작</strong>';
                    } else if (sdate > now) {
                        let difDays = (sdate - now) / (1000 * 60 * 60 * 24);
                        output += '<strong>' + Math.floor(difDays) + '일 뒤 시작</strong>';
                    }
                    output += '</p>';
                    output += '</div>';

                    output += '</div>';
                    output += '<a href="detail?chal_num=' + challenge.chal_num + '" class="custom-btn btn nanum">참가하기</a>';
                    output += '</div>';

                    output += '</div>';
                    output += '</div>';
                });
                $('#output').append(output);

                // 스크롤 타겟 추가 및 중복 방지
                const scrollTarget = document.querySelector('#scroll-target');
                if (scrollTarget) {
                    observer.unobserve(scrollTarget);

                    scrollTarget.remove();

                    const dif = page * rowCount - param.count;

                    console.log(realIdx);
                    console.log(param.count);
                    console.log(realIdx == param.count - 1);

                    if (realIdx == param.count - 1) {
                        const target = document.createElement('div');
                        target.id = 'scroll-target';
                        document.getElementById('output').appendChild(target);
                        if (dif == 1) {
                            target.style.width = '170px';
                            console.log(target);
                        }
                        else if (dif == 2) {
                            target.style.width = '390px';
                            return;
                        }
                    }
                }
                const target = document.createElement('div');
                target.id = 'scroll-target';
                document.getElementById('output').appendChild(target);
                observer.observe(target);

                loading = false;

            },
            error: function() {
                loading = false;
                alert('네트워크 오류');
            }
        });
    }

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting && hasMoreData) {
                currentPage++;
                selectList(currentPage);
            }
        });
    }, {
        root: null,
        rootMargin: '0px',
        threshold: 1.0
    });

    /*---------------------
     * 초기 데이터 호출
     *---------------------*/
    selectList(1);

});