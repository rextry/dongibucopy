<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div class="col-lg-6 col-md-6 col-12">

</div>

    <div id="topBannerCarousel" class="carousel slide col-12" data-bs-ride="carousel" data-bs-interval="4000">
        <div class="carousel-inner">
             <!-- 첫 번째 슬라이드 -->
            <div id="top_first_slide" class="carousel-item active p-0 w-100">
				<div class="d-block w-100">
					<div class="custom-text-box d-flex align-items-center mb-lg-0 justify-content-start">
						<div class="banner-title d-flex justify-content-center flex-column">
							<div>함께</div>
							<div>만든</div>
							<div>변화들</div>
						</div>
						<div class="d-flex flex-column">
							<div class="counter-thumb">
								<span class="counter-text">누적 기부횟수</span>
	
								<div class="d-flex align-items-end">
									<span class="counter-number" data-from="1" data-to="${totalVO.total_count}"
										data-speed="1000"></span> <span class="counter-number-text">회</span>
								</div>
					
							</div>
					
							<div class="counter-thumb mt-4">
								<span class="counter-text">누적 기부금</span>
	
								<div class="d-flex align-items-end">
									<span class="counter-number" data-from="1" data-to="${totalVO.total_amount}"
										data-speed="1000"></span> <span class="counter-number-text">원</span>
								</div>
					
							</div>
						</div>
					</div>
				</div>
            </div>

        	<!-- 두 번째 슬라이드 -->
            <div id="top_second_slide" class="carousel-item p-0 w-100 nanum">
                <div class="d-block w-100">
					<div class="cta-section section-padding section-bg">
						<div class="container">
							<div class="row justify-content-center align-items-center col-12">
					
								<div class="col-lg-6 col-12 ms-auto">
									<h2 class="mb-0 second-slide-text">
										자기계발과 기부를 동시에? <br> Don Gibu Up!
									</h2>
								</div>
					
								<div class="col-lg-5 col-12">
									<a href="${pageContext.request.contextPath}/challenge/list"
										class="custom-btn btn smoothscroll">챌린지 참여하기</a>
								</div>
					
							</div>
						</div>
					</div>
                </div>
            </div>
<!--             세 번째 슬라이드
            <div class="carousel-item">
                <div class="d-block w-100">
                    <h2>세 번째 슬라이드</h2>
                    <p>여기는 세 번째 슬라이드의 HTML 콘텐츠입니다. 이미지, 텍스트 등 무엇이든 넣을 수 있습니다.</p>
                </div>
            </div> -->
        </div>
        
        
    </div>
    
<script>
$(document).ready(function() {
    $('.counter-number').countTo({
        speed: 3000,               // 카운트 완료까지 걸리는 시간 (ms)
        refreshInterval: 100,     // 업데이트 주기 (ms)
        decimals: 0,              // 소수점 자릿수
        formatter: function(value, settings) {
            // 천 단위 구분 기호를 추가하는 함수
            var parts = value.toFixed(settings.decimals).split(".");
            parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            return parts.join(".");
        },
        onUpdate: function(value) {
            // 업데이트 시 호출되는 함수 (필요 시 추가적인 로직을 넣을 수 있습니다)
        },
        onComplete: function(value) {
            // 완료 시 호출되는 함수 (필요 시 추가적인 로직을 넣을 수 있습니다)
        }
    });
});
</script>