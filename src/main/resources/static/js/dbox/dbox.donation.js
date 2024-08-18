$(function(){
	//기부하기 버튼 클릭시 비로그인이면 로그인 페이지로

	$('#donation-btn').click(function() {
		// mem_num의 값을 가져옴
		var mem_num = $('#mem_num').val();
		// 만약 mem_num이 비어있으면(로그인되어 있지 않으면)
		if (!mem_num) {
			// 로그인 페이지로 리다이렉트
			window.location.href = '/member/login'; // 로그인 페이지의 URL로 수정 필요
		} else {
			// mem_num이 존재하면 정상적으로 기부 시작하기 로직 실행
			$('#staticBackdrop').modal('show'); // 모달 창 열기 등
		}
	});
	const button = document.getElementById('imp_donation');
	const form = document.getElementById('dbox_donation');

    /*==============================
     * 		결제창 계산
     *=============================*/
	//keyup마다 payTotal 함수 실행
	$(document).on('keyup','.caculate',function(){
		payTotal();
	});
	//결제창 계산 함수
	function payTotal(){
		let total = 0;
		let pt = parseInt($('#dbox_do_point').val());
		let pr = parseInt($('#dbox_do_price').val());
		let mem_point = parseInt($('#mem_point').val());
		if(pt > mem_point){//포인트가 보유포인트보다 많을 시 보유포인트로 값이 변경
			$('#dbox_do_point').val(mem_point);
			pt=mem_point;
		}
		$('#no').empty();//span 메세지 초기화
		if(isNaN(pr) && !isNaN(pt)){//price 미입력, point 입력시 0원 
			total = 0;
		}else if(isNaN(pr) && isNaN(pt)){//price 미입력, point 미입력시 0원
			total = 0;
		}else if(!isNaN(pr) && isNaN(pt)) {//price 입력, point 미입력시 price값이 결제금액
			total =  pr;
		}else if(pr < pt){//기부금보다 포인트가 클 경우 결제금액0원 설정 및 span메세지 노출
			total = 0;
			$('#no').append('<small>기부금액보다 포인트가 클 수 없습니다.</small>');
		}else{//정상 입력시 결제금액 : price-point
			total = pr-pt;			
		}
		//결제금액 #,###으로 노출
		$('#pay_sum').text(total.toLocaleString());
		//input hidden값을 결제금액으로 설정
		$('#pay_price').val(total);
	}
	/*==============================
     * 		결제 실행 
     *=============================*/
	const onClickPay = async () =>{
		
		/*========== 서버로 넘길 데이터 값 설정 ==========*/
		
        const dbox_num = document.getElementById('dbox_num').value;
        const price = document.getElementById('dbox_do_price').value;
        const comment = document.getElementById('dbox_do_comment').value;
        const mem_nick = document.getElementById('mem_nick').value;
        const mem_email = document.getElementById('mem_email').value;

       	//포인트는 값보정이 필요하므로 let 사용
        let point = document.getElementById('dbox_do_point').value;
       	//포인트 미입력시 0으로 설정
       	if (point==null || point==''){
			point='0';
		}
       	//0:기명, 1:익명 기부 설정
       	let annony = 0;
       	if($('.annony:checked').length==1){
			annony = 1;
		}  
		//amount로 보낼 계산된 결제금액 pay_price에 값 입력
		let pay_price =$('#pay_price').val();
		
		console.log("dbox_num : " + dbox_num);
		console.log("pay_price : " + pay_price);
		console.log("price : " + price);
		console.log("point : " + point);
		console.log("comment : " + comment);
		console.log("annony : " + annony);
		console.log("mem_nick : " + mem_nick);
		console.log("mem_email : " + mem_email);
		
		/*==========결제 실행 - 1.전액 포인트,2.결제금액1~99원,3.결제금액100원이상 ==========*/
		
		//1.전액 포인트 결제 시
		if(price >0 && point==price){
			if(confirm('전액 포인트로 기부하시겠습니까?')){
				$.ajax({//전액 포인트 기부 ajax
					url:'/dbox/donation',
					method:'POST',
					data:JSON.stringify({//*전액 포인트 결제시 imp_uid를 Mapper에서 등록제외시켜야함.
						dbox_num:dbox_num,//기부박스 번호
						price:price,//기부금액
						point:point,//포인트
						comment:comment,//남길말
						pay_status:0,//결제완료:0
						annony:annony,//익명
					}),
					contentType:'application/json; charset=utf-8',
					dataType:'json',
					success: function(param){
						if(param.result == 'logout'){
							alert('로그인 후 사용하세요.');
						}else if(param.result == 'success'){
							alert('기부 하기가 완료되었습니다.');
							form.submit();
						}
					},
					error:function(){
						alert('기부하기 오류 발생');
					}
				});//end of 전액 포인트 기부 ajax		
			}
			
		//2.결제금액이 1~99원일 경우
		}else if(pay_price >=1 && pay_price <=99){
			alert('결제는 100원 이상부터 가능합니다.');
		//3.결제금액이 100원 이상일 경우 결제창 실행
		}else{
			//포트원 API 사용
	        IMP.init("imp04826433");
			IMP.request_pay({
				pg:"tosspayments.iamporttest_3",
				pay_method:"card",
				amount:pay_price,
				name:"기부하기"+dbox_num,
				merchant_uid:"merchant_" + new Date().getTime(),
				buyer_name: mem_nick,
           		buyer_email: mem_email,
				currency:"KRW"
			}, function(response){
				if(!response.error_code){
					$.ajax({//결제 검증
						url:'/dbox/payment/' + response.imp_uid,
						method: 'POST',
						data:JSON.stringify({pay_price:pay_price}),
						dataType:'json',
						contentType:'application/json; charset=utf-8',
					}).done(function(data){
						if(data.response.status=='paid'){
							$.ajax({//결제 구현 ajax
								url:'/dbox/donation',
								method:'POST',
								data:JSON.stringify({
									dbox_num:dbox_num,//기부박스 번호
		 							pay_price:data.response.amount,//결제금액
									price:price,//기부금액
									point:point,//포인트
									dbox_imp_uid:response.imp_uid,//imp_uid
									comment:comment,//남길말
									pay_status:0,//결제완료:0
									annony:annony,//익명
								}),
								contentType:'application/json; charset=utf-8',
								dataType:'json',
								success: function(param){
									if(param.result == 'logout'){
										alert('로그인 후 사용하세요.');
									}else if(param.result == 'success'){
										alert('기부 하기 결제가 완료되었습니다.');
										form.submit();
									}
								},
								error:function(xhr, status, error){
									alert('기부하기 오류 발생 : ' + error)
								}
							});//end of 결제 구현 ajax
						}else if(data.response.status=='failed'){
							alert('결제 위조 오류');
						}else{
							alert('결제 검증 오류');
						}
					}).fail(function(jqXHR,textStatus,errorThrown){//결제 실패
						alert('결제 검증 요청 실패 : ' + errorThrown);
					});//end of 결제 검증 ajax
				}else{
					alert('결제에 실패했습니다. : ' + response.error_msg);
				}		
			});//end of function(response)
		}//end of 100원이상 결제
			
	};
	
	button.addEventListener("click", onClickPay);
});
 