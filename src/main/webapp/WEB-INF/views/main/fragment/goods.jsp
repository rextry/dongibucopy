<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- section 내에 들어갈 내용을 div 내에 작성해주세요 --%>
<%-- section의 높이는 컨텐츠의 길이에 따라 자동 조정됩니다 --%>
<%-- 메인 페이지의 css 파일은 /DontGibuUp/src/main/resources/static/css/main.css 파일 내에 있습니다. --%>
<%-- css 설정이 필요하면 해당 파일 내의 적절한 섹션에서 수정해주세요 (git 충돌 주의) --%>
<!-- 최신 상품 섹션 시작 -->
<h6 class="latestGoods title-style">필요한 상품 사고 기부도 하고</h6>
<div id="latestGoods">
    <div class="latest-goods-item nanum">
        <div class="card" onclick="location.href='${pageContext.request.contextPath}/goods/detail?item_num=${todayGoods.item_num}'" style="cursor: pointer;">
            <img src="${pageContext.request.contextPath}${todayGoods.item_photo}" class="card-img-top" alt="${todayGoods.item_name}">
            <div class="card-body">
                <p class="card-title">${todayGoods.item_name}</p>
                <p class="card-price">가격: ${todayGoods.item_price}원</p>
                <p class="card-stock">재고: ${todayGoods.item_stock}ea</p>
            </div>
        </div>
    </div>
</div>
<!-- 최신 상품 섹션 끝 -->
<style>
#latestGoods {
    padding: 20px;
    border-radius: 8px;
    text-align: center;
}

#latestGoods h6 {
    color: #5a6f80;
    font-weight: bold;
    margin-bottom: 20px;
}

.latest-goods-item {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 20px;
}

.latest-goods-item .card {
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    width: 100%;
    max-width: 300px; /* Max width for card */
    overflow: hidden;
    transition: box-shadow 0.3s ease-in-out;
    position: relative;
    text-decoration: none;
    color: inherit;
}

.latest-goods-item .card:hover {
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.latest-goods-item .card-img-top {
    width: 100%;
    height: auto; /* Adjusted to keep aspect ratio */
    object-fit: cover;
    transition: transform 0.3s ease;
}

.latest-goods-item .card:hover .card-img-top {
    transform: scale(1.1);
}

.latest-goods-item .card-body {
    padding: 10px;
    text-align: left;
}

.latest-goods-item .card-title,
.latest-goods-item .card-price,
.latest-goods-item .card-stock{
    font-size: 1rem;
    color: #555;
    margin: 5px 0;
}

.latest-goods-item .card-title {
    font-size: 1.25rem;
    font-weight: bold;
    color: #333;
}
</style>
