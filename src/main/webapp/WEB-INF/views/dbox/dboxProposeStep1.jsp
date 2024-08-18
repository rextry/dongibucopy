<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- Step1 시작 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
$(function(){
	$('#step1').submit(function(event){
		//체크박스 검사
		if($('.validation_checkbox:checked').length!=3){
			alert('안내사항을 읽고 체크박스를 체크해주세요.');
			return false;
		}  
	});
});
</script>
<section class="section-padding nanum">
	<div class="container p-0">
		<jsp:include page="/WEB-INF/views/dbox/nav_dbox.jsp"/>
		<div class="propose-body">
		
			<form:form action="step1" id="step1" modelAttribute="dboxVO">	
				<form:errors element="div" cssClass="error-color"/><!-- 필드가 없는 에러메세지 -->
				<ul class="pr-form-content">
					<li class="pr-li-item">
						<form:label path="dcate_num" class="d-flex mb-2"><h3 class="pr-form-label mb-0">카테고리 선택</h3><span class="validation-check validation-dot"></span></form:label>
						<form:select path="dcate_num" cssClass="form-control">
							<option disabled="disabled" selected>선택해주세요.</option>
							<c:forEach var="category" items="${list}">
								<form:option value="${category.dcate_num}">${category.dcate_name}</form:option>
							</c:forEach>
						</form:select>
						<form:errors path="dcate_num" cssClass="error-color"/>
					</li>
					<li class="pr-li-item">
						<h3 class="pr-form-label">모금 진행 일정과 과정</h3>
						<ul>
							<li class="mb-1">1.기부박스 제안</li>
							<li class="mb-1">2.기부박스 심사</li>
							<li class="mb-1">3.기부박스 진행</li>
							<li class="mb-1">4.기부박스 종료 및 후기 작성</li>
						</ul>
					</li>
					<li class="pr-li-item">
						<h3 class="pr-form-label">돈기부업 기본 모금검토 기준</h3>
						<ul>
							<li class="mb-1">개인의 이익이 아닌 공익을 위한 모금이어야 합니다.</li>
							<li class="mb-1">프로젝트팀이 사업 수행 능력이나 경험이 있어야 합니다.</li>
							<li class="mb-1">사업집행에 대한 구체적 근거와 계획이 필요합니다.</li>
							<li class="mb-1">영리 목적의 프로젝트는 진행이 어렵습니다.</li>
						</ul>
					</li>
					<li>
						<div class="d-flex align-items-center mb-1">
							<input type="checkbox" class="validation_checkbox me-1" id="ckbox1"><label for="ckbox1">모금검토 기준을 꼼꼼히 확인하였습니다.</label>
						</div>
						<div class="d-flex align-items-center mb-1">
							<input type="checkbox" class="validation_checkbox me-1" id="ckbox2"><label for="ckbox2">동일한 내용으로 이중모금을 진행하지 않겠습니다.</label>				
						</div>
						<div class="d-flex align-items-center mb-1">
							<input type="checkbox" class="validation_checkbox me-1" id="ckbox3"><label for="ckbox3">투명한 기부금 집행을 위한 모금심사를 받겠습니다.</label>
						</div>
					</li>
				</ul>	
				<div class="d-flex justify-content-end">
					<form:button class="pr-custom-btn">다음 단계로</form:button>
				</div>
			</form:form>
		</div>
	</div>
</section>
<!-- Step1 끝 -->