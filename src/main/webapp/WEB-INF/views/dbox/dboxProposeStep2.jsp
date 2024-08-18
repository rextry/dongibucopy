<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/dbox/dbox.propose.step2.js"></script>
<!-- Step2 시작 -->
<section class="section-padding nanum">
	<div class="container p-0">
		<jsp:include page="/WEB-INF/views/dbox/nav_dbox.jsp"/>
		<div class="propose-body">
		
			<form:form action="step2" id="step2" modelAttribute="dboxVO" enctype="multipart/form-data">	
				<form:errors element="div" cssClass="error-color"/><%-- 필드가 없는 에러메세지 --%>
				<ul class="pr-form-content">
					<%-- 팀 유형 --%>
					<li class="pr-li-item">
						 <form:label path="dbox_team_type" class="d-flex mb-2"><h3 class="pr-form-label">팀 유형</h3><span class="validation-check validation-dot"></span></form:label>
		   				 <div class="d-flex align-items-center"><input type="radio" name="dbox_team_type" value="1" id="ckbox1" class="me-1"/><label for="ckbox1">기관</label></div>
		   				 <div class="d-flex align-items-center"><input type="radio" name="dbox_team_type" value="2" id="ckbox2" class="me-1"/><label for="ckbox2">개인</label></div>
		   				 <form:errors path="dbox_team_type" cssClass="form-error"></form:errors>
					</li>
					<%-- 팀명 --%>
					<li class="pr-li-item">
						<form:label path="dbox_team_name" class="d-flex mb-2"><h3 class="pr-form-label">팀명</h3><span class="validation-check validation-dot"></span></form:label>
						<form:input path="dbox_team_name" placeholder="팀명을 작성해주세요" cssClass="form-control"/>
						<form:errors path="dbox_team_name" cssClass="form-error"></form:errors>				
					</li>
					<!-- 팀 유형=기관일 시, 사업자등록번호  -->
					<li id="dbox_business" class="pr-li-item"></li>
					<%-- 팀 대표이미지 등록 --%>
					<li class="pr-li-item">
						<form:label path="dbox_team_photo_file" class="d-flex mb-2"><h3 class="pr-form-label">팀 대표이미지 등록</h3></form:label>
						<p>
						팀의 로고나 대표할 수 있는 이미지로 등록해주세요.<br>
						*미등록시 기본 이미지가 노출됩니다.
						</p>
						<img id="preview" src="${pageContext.request.contextPath}/images/teamProfile.png" width="100" height="100" class="profile-photo mb-2">
						<input type="file" name="dbox_team_photo_file" id="dbox_team_photo_file" class="form-control" accept="image/gif,image/png,image/jpeg" >
					</li>
					<%-- 프로젝트 팀 소개 --%>
					<li class="pr-li-item">
						<form:label path="dbox_team_detail" class="d-flex mb-2"><h3 class="pr-form-label">프로젝트 팀 소개</h3><span class="validation-check validation-dot"></span></form:label>
						<p class="d-flex justify-content-end mb-1"><span id="team_detail_letter">500/500</span></p>
						<form:textarea path="dbox_team_detail"  placeholder="프로젝트 팀 소개 문구 1~3줄 적어주세요" cssClass="form-control"/>
						<form:errors path="dbox_team_detail" cssClass="form-error"></form:errors>				
					</li>
					<%-- 계좌번호 (은행선택,예금주명,계좌번호) --%>
					<li class="pr-li-item">
						<form:label path="dbox_bank" class="d-flex mb-2"><h3 class="pr-form-label">계좌번호</h3><span class="validation-check validation-dot"></span></form:label>
						<div class="d-flex justify-content-between">
							<form:select path="dbox_bank" cssClass="form-control">
								<option disabled="disabled" selected>은행 선택</option>
								<form:option value="1">국민은행</form:option>
								<form:option value="2">신한은행</form:option>
								<form:option value="3">하나은행</form:option>
								<form:option value="4">우리은행</form:option>
								<form:option value="5">NH농협은행</form:option>
								<form:option value="6">IBK기업은행</form:option>
								<form:option value="7">대구은행</form:option>
								<form:option value="8">제주은행</form:option>
								<form:option value="9">전북은행</form:option>
								<form:option value="10">광주은행</form:option>
								<form:option value="11">경남은행</form:option>
								<form:option value="12">부산은행</form:option>
								<form:option value="13">카카오뱅크</form:option>
								<form:option value="14">토스뱅크</form:option>
								<form:option value="15">케이뱅크</form:option>
							</form:select>
							<form:errors path="dbox_bank" cssClass="error-color"/>
			
							<form:input path="dbox_account_name" placeholder="예금주명" cssClass="form-control"/>
							<form:errors path="dbox_account_name" cssClass="form-error"></form:errors>	
							
							<form:input path="dbox_account" placeholder="계좌번호" cssClass="form-control"/>
							<form:errors path="dbox_account" cssClass="form-error"></form:errors>	
						</div>
					</li>
					<%-- 기부박스 희망기간 --%>
					<li class="pr-li-item">
						<form:label path="dbox_sdate" class="d-flex mb-2"><h3 class="pr-form-label">기부박스 희망기간</h3><span class="validation-check validation-dot"></span></form:label>
						<div class="d-flex justify-content-between align-items-center">
							<form:input path="dbox_sdate" type="date"  cssClass="form-control"/> ~
							<form:errors path="dbox_sdate" cssClass="form-error"></form:errors>	
							<form:input path="dbox_edate" type="date"  cssClass="form-control"/>
							<form:errors path="dbox_edate" cssClass="form-error"></form:errors>	
						</div>			
					</li>
					<%-- 모금액 사용 계획 --%>
					<li class="pr-li-item">
						<form:label path="dboxBudget.dbox_bud_purpose" class="d-flex mb-2"><h3 class="pr-form-label">모금액 사용계획</h3><span class="validation-check validation-dot"></span></form:label>
						<p>
						세부내역을 구체적으로 입력해주세요.<br>
						아래 사항 위반시 심사를 통해 환수 조치 될 수 있습니다.<br><br>
						
						 · 사용계획을 허위로 기재하거나 근거가 불충분한 경우<br>
						 · 동일한 스토리 및 예산 항목으로 이중 모금 진행시<br>
						 · 모금액을 입금 받기 전 과거 지출한 내용을 포함한 경우
						</p>
						<div id="dbox_budget"></div>
						<input type="button" id="dbox_budget_add" name="dbox_budget_add" value="지출항목 추가" class="form-control mb-3"><p class="align-right" style="padding-right:50px;">총합 : <span id="budget_sum">0</span>원</p>
						<input type="hidden" id="dbox_goal" name="dbox_goal" value="">
					</li>
					<%-- 심사위원에게 남길 말 --%>
					<li class="pr-li-item">
						<form:label path="dbox_comment" class="d-flex mb-2"><h3 class="pr-form-label">심사위원에게 남길 말</h3></form:label>
						<p class="d-flex justify-content-end mb-1"><span id="comment_letter">1000/1000</span></p>
						<form:textarea path="dbox_comment" cssClass="form-control" placeholder="심사위원에게 남길 말을 적어주세요"/>
						<form:errors path="dbox_comment" cssClass="form-error"></form:errors>				
					</li>
					<%-- 자료 첨부 --%>
					<li class="pr-li-item">
						<h3 class="pr-form-label mb-3">자료 첨부</h3>
						<form:label path="dbox_business_plan_file" class="d-flex">세부사업계획서<span class="validation-check validation-dot ms-1"></span></form:label>
						<input type="file" name="dbox_business_plan_file" id="dbox_business_plan_file" class="form-control">
						<form:errors path="dbox_business_plan_file" cssClass="form-error"></form:errors>
						<form:label path="dbox_budget_data_file" class="mt-3">금액 책정 근거자료</form:label>
						<input type="file" name="dbox_budget_data_file" id="dbox_budget_data" class="form-control">
					</li>
				</ul>	
				<div class="d-flex justify-content-end">
					<form:button class="pr-custom-btn">다음 단계로</form:button>
				</div>
			</form:form>
		</div>
	</div>
</section>
<!-- Step2 끝 -->
