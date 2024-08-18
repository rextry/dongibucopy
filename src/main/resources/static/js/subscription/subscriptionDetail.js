document.addEventListener("DOMContentLoaded", function() {

    function addMonthToDateString(dateStr) {
        let [year, month, day] = dateStr.split('-').map(num => parseInt(num, 10));

        if (month < 12) {
            month += 1;
        } else {
            month = 1;
            year += 1;
        }

        month = month.toString().padStart(2, '0');
        day = day.toString().padStart(2, '0');

        return `${year}-${month}-${day}`;
    }

    if (/^\d{4}-\d{2}-\d{2}$/.test(subPayDate)) {
        let nextPayDate = addMonthToDateString(subPayDate);
        document.querySelectorAll('.next-pay-date').forEach(element => {
            element.textContent = nextPayDate;
        });
    } else {
        console.error("Invalid date format:", subPayDate);
        document.querySelectorAll('.next-pay-date').forEach(element => {
            element.textContent = "날짜 오류";
        });
    }

    $('.modify-btn').on('click', function() {
        if (!confirm('정말 해지하시겠습니까?')) return;

        var subNum = $(this).data('num');

        $.ajax({
            url: '/subscription/updateSub_status',
            type: 'POST',
            data: { sub_num: subNum },
            dataType: 'json',
            success: function(param) {
                if (param.result === 'logout') {
                    alert('로그인 후 사용해주세요');
                } else if (param.result === 'success') {
                    alert('정기기부가 중지 되었습니다.');
                    $('.modify-btn').each(function() {
                        $(this).val('해지된 정기기부').prop('disabled', true);
                        location.reload();
                    });
                } else {
                    alert('정기기부 중지 오류 발생');
                }
            },
            error: function() {
                alert('네트워크 오류 발생');
            }
        });
    });

    $('.payment-method').click(function() {
        var radio = $(this).find('input[type="radio"]');
        if (radio.length) {
            radio.prop('checked', true);
            $('.payment-method').removeClass('selected');
            $(this).addClass('selected');

            if (radio.val() === 'easy_pay') {
                $('#card-options').slideUp();
                $('.easypay-container').slideDown();
                $('input[name="selectedCard"]').prop('checked', false);
                $('#newCardname').val('');
                $('#newCardNickname').slideUp();
            } else {
                $('.easypay-container').slideUp();
                $('#card-options').slideDown();
                $('.easypay_method').removeClass('selected');
            }
        }
    });

    $('#newCard').click(function() {
        $('#newCardNickname').slideDown();
    });

    $('.oldCard').click(function() {
        $('#newCardNickname').slideUp(function() {
            $('#newCardname').val('');
        });
    });

    $('.easypay_method').click(function() {
        var radio = $(this).find('input[type="radio"]');
        if (radio.length) {
            radio.prop('checked', true);
            $('.easypay_method').removeClass('selected');
            $(this).addClass('selected');
        }
    });

    $('#modifyPayMethod').on('submit', function(event) {
        event.preventDefault();

        var form = $(this);

        if (!$("input[name='sub_method']").is(":checked")) {
            alert("결제수단을 선택해주세요");
            return false;
        }

        if ($('#easy_pay').is(":checked") && !$("input[name='easypay_method']").is(":checked")) {
            alert('사용하실 간편결제 플랫폼을 선택해주세요.');
            return false;
        }

        if ($('#card').is(":checked") && !$("input[name='selectedCard']").is(":checked")) {
            alert('사용하실 카드를 선택해주세요.');
            return false;
        }

        if ($('#card').is(":checked") && $('#newCard').is(":checked") && $('#newCardname').val().trim() === '') {
            alert('등록하실 카드의 별명을 명시해주세요.');
            return false;
        }
        $.ajax({
            url: form.attr('action'),
            type: form.attr('method'),
            data: form.serialize(),
            success: function(response) {
                if (response.result === "success") {
                    alert('결제수단이 변경되었습니다.');
                } else if (response.result === "noPayuid") {
                    alert('해당 결제수단이 등록되어 있지 않습니다.');
                } else {
                    alert('결제수단 변경에 실패했습니다. 관리자에게 문의하세요.');
                }
                location.reload();
            },
            error: function() {
                alert('서버 오류로 인해 요청이 실패했습니다. 관리자에게 문의하세요.');
            }
        });
    });

    $('input[name="selectedCard"]').change(function() {
        if ($(this).val() === 'newCard') {
            $('#newCardNickname').show();
            $('#card_nickname').val('');
        } else {
            $('#newCardNickname').hide();
            $('#card_nickname').val($(this).val());
        }
    });

    $('#newCardname').on('input', function() {
        $('#card_nickname').val($(this).val());
    });

    $('#paybutton').click(function() {
        var mem_num = $('#mem_num').val();
        if (!mem_num) {
            window.location.href = '/member/login';
        } else {
            $('#staticBackdrop').modal('show');
        }
    });
    
    

});
