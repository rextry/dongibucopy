<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$('.user-faq-item').on('click', function() {
			var $this = $(this);
			var $answer = $this.find('.faq-answer-text');

			// 슬라이드 다운으로 나타나지 않은 경우만 슬라이드 다운
			if ($answer.is(':visible')) {
				$answer.hide(); // 이미 보이는 경우 즉시 숨김
			} else {
				// 모든 다른 답변을 숨기기
				$('.faq-answer-text').not($answer).hide();
				// 클릭된 답변을 슬라이드 다운으로 부드럽게 나타나게 함
				$answer.slideDown();
			}
		});
	});
</script>

<section class="news-detail-header-section text-center nanum">
	<div class="section-overlay"></div>

	<div class="container">
		<div class="row">

			<div class="col-lg-12 col-12">
				<h1 class="text-white">FAQ(자주 하는 질문)</h1>
			</div>

		</div>
	</div>
</section>
<section class="section-padding nanum">
	<div class="container">
		<div class="align-right">
			<button class="custom-btn" onclick="location.href='inquiry'">1:1 문의하기</button>
		</div>
		<div class="mb-3">
			<a class="tags-block-link"  href="faqlist?">전체</a> <a class="tags-block-link"  href="faqlist?category=0">정기기부</a> <a
				class="tags-block-link"  href="faqlist?category=1">기부박스</a> <a class="tags-block-link"  href="faqlist?category=2">챌린지</a>
			<a class="tags-block-link"  href="faqlist?category=3">굿즈샵</a> <a class="tags-block-link"  href="faqlist?category=4">기타</a>
		</div>
		<c:if test="${empty list}">
			<div class="result-display">등록된 질문이 없습니다.</div>
		</c:if>
		<c:if test="${!empty list}">
			<ul id="faq_list">
				<c:forEach var="faq" items="${list}">
					<li class="user-faq-item d-flex mt-0">
						<div class="me-3"><img src="${pageContext.request.contextPath}/images/letter-q.png" width="40rem"></div>
						<div>
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
							<div class="faq-answer-text mt-3" style="display: none">${faq.faq_answer}</div>
						</div>
					</li>
				</c:forEach>
			</ul>
		</c:if>
	</div>
</section>