<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<section class="section-padding nanum col-8 mx-auto">
	<div class="container">
		<div class="mb-0 align-center">
			<a class="category-link tags-block-link" href="list">전체</a>
			<c:forEach var="entry" items="${categories}" varStatus="status">
				<c:if test="${status.index < 4}">
					<a class="category-link tags-block-link"
						href="list?dcate_num=${entry.key}">${entry.value}</a>
				</c:if>
			</c:forEach>
		</div>
		<div class="align-center">
			<c:forEach var="entry" items="${categories}" varStatus="status">
				<c:if test="${status.index >= 4}">
					<a class="category-link tags-block-link"
						href="list?dcate_num=${entry.key}">${entry.value}</a>
				</c:if>
			</c:forEach>
		</div>
		<form action="list" id="search_form" method="get" class="mb-4 mt-4"
			style="width: 100%">
			<input type="hidden" name="dcate_num" value="${dcate_num}">
			<div class="search d-flex justify-content-end">
				<div style="display: none">
					<select name="keyfield" id="keyfield" class="form-control">
						<option value="1"
							<c:if test="${param.keyword != null}">selected</c:if>>상품명</option>
					</select>
				</div>
				<div class="me-1">
					<input type="search" name="keyword" id="keyword"
						value="${param.keyword}" class="form-control">
				</div>
				<div>
					<input type="submit" value="찾기" class="form-control g-custom-btn">
				</div>
			</div>
			<br>
			<div class="align-right">
				<script type="text/javascript">
                    $('#order').change(function() {
                        location.href = 'list?category=${param.category}&keyfield=' + $('#keyfield').val() + '&keyword=' + $('#keyword').val() + '&order=' + $('#order').val());
                    });
                </script>
				<c:if
					test="${sessionScope.user != null && sessionScope.user.mem_status == 9}">
					<input type="button" value="상품 등록" onclick="location.href='write'" style="padding: 6px 12px; border-radius: 5px; background-color: #597081; color: white; border: none; cursor: pointer;">
					<input type="button" value="구매 관리"
						onclick="location.href='${pageContext.request.contextPath}/admin/purchaseList'" style="padding: 6px 12px; border-radius: 5px; background-color: #597081; color: white; border: none; cursor: pointer;">
				</c:if>
				<input type="button" value="장바구니"
					onclick="location.href='${pageContext.request.contextPath}/cart/list'" style="padding: 6px 12px; border-radius: 5px; background-color: #597081; color: white; border: none; cursor: pointer;">
			</div>
		</form>
		<c:if test="${count == 0}">
			<div class="result-display">표시할 상품이 없습니다.</div>
		</c:if>
		<c:if test="${count > 0}">
			<div class="row">
				<c:forEach var="goods" items="${list}">
					<c:if
						test="${sessionScope.user != null && sessionScope.user.mem_status == 9 || goods.item_status == 1}">
						<div class="col-md-3 mb-4">
							<div class="card h-100 goods-item">

								<a href="detail?item_num=${goods.item_num}"> <img
									src="${pageContext.request.contextPath}${goods.item_photo}"
									class="card-img-top mb-3" alt="${goods.item_name}"
									style="width: 100%; height: 160px; object-fit: cover">
								</a>

								<div
									class="card-body pb-3 px-3 d-flex flex-column justify-content-between">
									<h5 class="card-title">${goods.item_name}</h5>
									<p class="card-text">
										<strong>가격:</strong>
										<fmt:formatNumber value="${goods.item_price}" type="number"
											groupingUsed="true" />
										원<br> <strong>재고:</strong> ${goods.item_stock} ea
									</p>
									<a href="detail?item_num=${goods.item_num}"
										class="btn custom-btn"
										style="width: 100%; height: 15px; line-height: 0; font-size: 0.9rem">상세보기</a>
									<c:if
										test="${sessionScope.user != null && sessionScope.user.mem_status == 9}">
										<div class="mt-2">
											<a
												href="${pageContext.request.contextPath}/goods/update?item_num=${goods.item_num}"
												class="btn btn-secondary">상품정보 변경</a>
											<form
												action="${pageContext.request.contextPath}/goods/delete"
												method="post" style="display: inline;">
												<input type="hidden" name="item_num"
													value="${goods.item_num}"> <input type="submit"
													value="삭제" onclick="return confirm('정말로 삭제하시겠습니까?');"
													class="btn btn-danger">
											</form>
										</div>
									</c:if>
								</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</c:if>
	</div>
</section>