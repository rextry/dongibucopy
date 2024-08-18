$(function(){
	let rowCount=6;
	let currentPage;
	let count;
	let category='';
	let order;
	let keyfield;
	let keyword;
	
	/* ===========================
	 * 		카테고리 검색
	 * =========================== */
	if(window.location.search != ''){
		// 현재 페이지의 URL 가져오기 및 decode
	    let searchUrl = decodeURI(window.location.href);
		console.log("현재 페이지 URL : " + searchUrl);
	    // URL에서 파라미터 부분 추출하기
	    let query = searchUrl.split('?')[1];
		console.log("?뒤로 추출한URL : " + query);
	    // 파라미터를 '&'로 분리하여 배열로 만들기
	    let params = query.split('&');
		console.log("&로 분리한 배열 : " + params);
		
		// 파라미터 배열에서 찾기
		$.each(params,function(index, param) {
		    let keyValue = param.split('=');
		    if (keyValue[0] == 'category') {
		        category = keyValue[1]; // category 파라미터의 값
		        console.log("category : " + category);
		    }
		    if (keyValue[0] == 'order') {
		        order = keyValue[1]; // order 파라미터의 값
		        console.log("order : " + order);
		    }
		    if (keyValue[0] == 'keyfield') {
		        keyfield = keyValue[1]; // keyfield 파라미터의 값
		        console.log("keyfield : " + keyfield);
		    }
		    if (keyValue[0] == 'keyword') {
		        keyword = keyValue[1]; // keyword 파라미터의 값
		        console.log("keyword : " + keyword);
		    }
		});
	}
		
		
	/* ===========================
	 * 		조회
	 * =========================== */	
	$('#order').change(function(){
	
	location.href='list?category='+category
					 +'&keyfield='+$('#keyfield').val()
					 +'&keyword='+$('#keyword').val()
					 +'&order='+$('#order').val();
	});
	/* ===========================
	 * 		기부박스 목록
	 * =========================== */	
	function selectList(pageNum){
		currentPage = pageNum;
		
		//서버와 통신
		$.ajax({
			url:'dboxList',
			type:'get',
			data:{
				keyfield:keyfield,
				keyword:keyword,
				order:order,
				category:category,
				pageNum:pageNum,
				rowCount:rowCount},//왼쪽은 AjaxController의 @RequestParam으로 받음 
			dataType:'json',
			contentType: 'application/json; charset=utf-8',
			beforeSend:function(){
				$('#loading').show();//로딩 이미지 표시
			},
			complete:function(){
				//success와 error 콜백이 호출된 후에 호출
				$('#loading').hide();//로딩 이미지 숨김
			},
			success:function(param){
				count = param.count;

				$('#category_output').empty();
				if(category=='' || category==null){
					/*$('#category_output').append('<button type="button" class="btn btn-sm btn-outline-success active mb-2" onclick="location.href=\'list\'">전체</button>');*/
					$('#category_output').append(`<a href="list" class="category-link tags-block-link active">전체</a>`);								
				}else{
					/*$('#category_output').append('<button type="button" class="btn btn-sm btn-outline-success mb-2" onclick="location.href=\'list\'">전체</button>');			*/		
					$('#category_output').append(`<a href="list" class="category-link tags-block-link">전체</a>`);								
				}
				let category_output = '';
				$(param.category_list).each(function(index,item){
					if(item.dcate_num == category){
/*						category_output += ' <button type="button" class="btn btn-sm btn-outline-success active mb-2" onclick="location.href=\'list?category='+item.dcate_num+'\'"><img src="../upload/'+item.dcate_icon+'" style="height:1rem;">'+item.dcate_name+'</button>'						
						category_output += ` <button type="button" class="btn btn-sm btn-outline-success active mb-2" onclick="location.href=\'list?category='+item.dcate_num+'\'">
											<img src="../upload/'+item.dcate_icon+'" style="height:1rem;">'+item.dcate_name+'</button>`;		*/	
						category_output += `<a href="list?category=${item.dcate_num}" class="category-link tags-block-link active"><img src="../upload/${item.dcate_icon}" style="height:1rem;">${item.dcate_name}</a>`
					}else{
/*						category_output += ' <button type="button" class="btn btn-sm btn-outline-success mb-2" onclick="location.href=\'list?category='+item.dcate_num+'\'"><img src="../upload/'+item.dcate_icon+'" style="height:1rem;">'+item.dcate_name+'</button>'						
*/						category_output += `<a href="list?category=${item.dcate_num}" class="category-link tags-block-link"><img src="../upload/${item.dcate_icon}" style="height:1rem;">${item.dcate_name}</a>`
					}
				});
				$('#category_output').append(category_output);
				
				
				
				if(pageNum == 1){
					//처음 호출시는 해당 ID의 div의 내부 내용물을 제거
					$('#output').empty();
				}
				
				$(param.list).each(function(index,item){
					let output = '<div class="col-lg-4 col-md-6 col-12 nanum" style="margin-bottom: 30px;">';
					output += '		<div class="custom-block-wrap">';
					output += '		<div class="image-wrapper">';
					output += '		<img src="../upload/dbox/'+item.dbox_photo+'" class="custom-block-image img-fluid" style="height:14rem;">';
					//console.log('dbox_photo' + item.dbox_photo);
					output += '		</div>';
					
					output += '   	<div class="custom-block">';
					output += '     	<div class="custom-block-body">';
					output += '         	<h5 class="mb-3" style="min-height:4rem;">'+item.dbox_title+'</h5>';
					output += '       			<span class="badge mb-3"><img src="../upload/'+item.dcate_icon+'" style="height:1rem;">'+item.dcate_name+'</span>';
					if(item.dbox_team_photo!=null){
					output += '       			<p><img src="../upload/dbox/'+item.dbox_team_photo+'" class="team-profile-photo me-1">'+item.dbox_team_name+'</p>';						
					}else{
					output += '       			<p><img src="../images/teamProfile.png" class="team-profile-photo me-1">'+item.dbox_team_name+'</p>';												
					}
					output += '       			<div class="progress" role="progressbar" aria-label="기부박스 달성률" aria-valuenow="'+Math.floor(item.total/item.dbox_goal*100)+'" aria-valuemin="0" aria-valuemax="100">';
					output += '       				<div class="progress-bar progress-bar-striped bg-success" style="width: '+Math.floor(item.total/item.dbox_goal*100)+'%"></div>';
					output += '       			</div>';
					output += '					<div class="align-items-center my-2">';
					output += '						<p class="text-end">';
					output += '							<strong>달성률 : </strong>'+Math.floor(item.total/item.dbox_goal*100)+'%';
					output += '						</p>';
					output += '						<p class="text-end">';
					output += '							<strong>현재모금액 : '+item.total.toLocaleString()+'원</strong><br>';
					output += '							<small>목표금액 : '+item.dbox_goal.toLocaleString()+'원</small>';
					output += '						</p>';
					output += '					</div>';
					output += '				</div>';
					
					output += '				<a href="../dbox/'+item.dbox_num+'/content" class="custom-btn btn">기부하기</a>';
					output += '	  		</div>';
					output += '	 	 </div>';
					output += '	  </div>';
					//문서 객체에 추가
					$('#output').append(output);
				});
				
				
				console.log("currentPage:"+currentPage);
				console.log("count:"+count);
				console.log("rowCount:"+rowCount);
				
				//paging button 처리
				if(currentPage>=Math.ceil(count/rowCount)){
					//다음 페이지가 없음
					$('.paging-button').hide();
				}else{
					//다음 페이지가 존재
					$('.paging-button').show();
				}
			},
			error:function(){
				alert('네트워크 오류 발생');
			}
		});
	}
	//다음 댓글 보기 버튼 클릭시 데이터 추가
	$('.paging-button button').click(function(){
		selectList(currentPage + 1);
	});

	
		
	/* ===========================
	 * 초기 데	이터(목록) 호출
	 * =========================== */		
	selectList(1);
});