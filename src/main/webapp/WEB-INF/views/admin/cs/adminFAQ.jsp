<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
</script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/admin/admin.faq.js"></script>
	
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
			<h2>자주 하는 질문 (FAQ)</h2>
		</div>
		<div class="mb-4 tag-blocks-admin">
			<a class="tags-block-link"  href="faq?">전체</a> <a class="tags-block-link"  href="faq?category=0">정기기부</a> <a
				class="tags-block-link"  href="faq?category=1">기부박스</a> <a class="tags-block-link"  href="faq?category=2">챌린지</a>
			<a class="tags-block-link"  href="faq?category=3">굿즈샵</a> <a class="tags-block-link"  href="faq?category=4">기타</a>
		</div>
		<c:if test="${!empty list}">
			<ul id="faq_list">
				<c:forEach var="faq" items="${list}">
					<li class="faq-item d-flex mt-0">
						<div class="me-3"><img src="${pageContext.request.contextPath}/images/letter-q.png" width="40rem"></div>
						<div class="faq-content-div">
							<div class="faq-category-text mb-1">
							<c:if test="${faq.faq_category == 0}">
							정기기부
							</c:if>
							<c:if test="${faq.faq_category == 1}">
							기부박스
							</c:if>
							<c:if test="${faq.faq_category == 2}">
							챌린지
							</c:if>
							<c:if test="${faq.faq_category == 3}">
							굿즈샵
							</c:if>
							<c:if test="${faq.faq_category == 4}">
							기타
							</c:if>
							</div>
							<div class="faq-question-text">${faq.faq_question}</div>
							<div class="mt-3">
								<div class="faq-answer-text">${faq.faq_answer}</div>
								<div class="button-container">
									<input type="button" class="modifyBtn" data-num="${faq.faq_num}" value="수정"/>
									<input type="button" class="deleteBtn" data-num="${faq.faq_num}" value="삭제"/>			
								</div>						
							</div>
						</div>
					</li>
				</c:forEach>
			</ul>
		</c:if>
		
		<div class="col-lg-9 col-12 form-div">
			<form id="insert_faq" class="custom-form donate-form" method="post"
				role="form">
				<h3 class="mb-4">FAQ 등록하기</h3>
				<div class="row">
					<div class="col-lg-12 col-12">
						<h5 class="mb-3 custom-form-label">카테고리</h5>
					</div>

					<div class="col form-check-group mb-0 radio-option">
						<div class="form-check form-check-radio">
							<input class="form-check-input" type="radio"
								name="faq_category" id="regularDonation" value="0"> <label
								class="form-check-label custom-form-check-label" for="regularDonation"> 정기기부
							</label>
						</div>
					</div>

					<div class="col form-check-group mb-0 radio-option">
						<div class="form-check form-check-radio">
							<input class="form-check-input" type="radio"
								name="faq_category" id="donationBox" value="1"> <label
								class="form-check-label custom-form-check-label" for="donationBox"> 기부박스
							</label>
						</div>
					</div>

					<div class="col form-check-group mb-0 radio-option">
						<div class="form-check form-check-radio">
							<input class="form-check-input" type="radio"
								name="faq_category" id="challenge" value="2"> <label
								class="form-check-label custom-form-check-label" for="challenge"> 챌린지
							</label>
						</div>
					</div>

					<div class="col form-check-group mb-0 radio-option">
						<div class="form-check form-check-radio">
							<input class="form-check-input" type="radio"
								name="faq_category" id="goodsShop" value="3"> <label
								class="form-check-label custom-form-check-label" for="goodsShop"> 굿즈샵
							</label>
						</div>
					</div>

					<div class="col form-check-group mb-0 radio-option">
						<div class="form-check form-check-radio">
							<input class="form-check-input" type="radio"
								name="faq_category" id="other" value="4"> <label
								class="form-check-label custom-form-check-label" for="other"> 기타
							</label>
						</div>
					</div>

					<div class="mt-0 mb-3">
						<span id="category_check_msg"></span>
					</div>

					<div class="col-lg-12 col-12">
						<h5 class="mt-1 custom-form-label">질문</h5>
					</div>

					<div class="col-lg-12 col-12 mt-2">
						<input type="text" name="faq_question" id="faq_question"
							class="form-control">
						<span id="question_check_msg"></span>
					</div>

					<div class="col-lg-12 col-12">
						<h5 class="mt-4 pt-1 custom-form-label">내용</h5>
					</div>
					
					<div class="col-lg-12 col-12 mt-2">
						<textarea id="faq_answer" name="faq_answer" class="form-control" class="col-lg-10"></textarea>
						<span id="answer_check_msg"></span>
					</div>

					<div class="col-lg-12 col-12 mt-2 d-flex justify-content-center">
						<div class="col-lg-3">
							<button type="submit" class="form-control mt-4">등록</button>
						</div>
					</div>
				</div>
			</form>
		</div>
		
		</div>
</section>




