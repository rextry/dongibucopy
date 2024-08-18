<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- 기부박스 관리 시작 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<section class="section-padding nanum">
	<div class="container">
		<div class="mb-4">
 			<h2>기부박스 관리</h2>
 		</div>
 		
	<form action="dboxAdmin" id="search_form" method="get">
		<ul class="search" style="width:60%;text-align:center">
			<li>
				<select name="keyfield" id="keyfield">
					<option value="1" <c:if test="${param.keyfield == 1}">selected</c:if>>기부박스 번호</option>
					<option value="2" <c:if test="${param.keyfield == 2}">selected</c:if>>기부박스 제목</option>
					<option value="3" <c:if test="${param.keyfield == 3}">selected</c:if>>회원 번호</option>
					<option value="4" <c:if test="${param.keyfield == 4}">selected</c:if>>팀명</option>
					<option value="5" <c:if test="${param.keyfield == 5}">selected</c:if>>카테고리명</option>
				</select>
			</li>
			<li>
				<input type="search" name="keyword" id="keyword" value="${param.keyword}">
			</li>
			<li>
				<input type="submit" value="찾기">
			</li>
		</ul>
		<div class="status-check align-center">
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck0" value="0"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '0'}">checked</c:if></c:forEach>>
			  <label for="statusCheck0">신청완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck1" value="1"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '1'}">checked</c:if></c:forEach>>
			  <label for="statusCheck1">심사완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck2" value="2"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '2'}">checked</c:if></c:forEach>>
			  <label for="statusCheck2">신청반려</label>
			</div>
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck3" value="3"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '3'}">checked</c:if></c:forEach>>
			  <label for="statusCheck3">진행중</label>
			</div>
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck4" value="4"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '4'}">checked</c:if></c:forEach>>
			  <label for="statusCheck4">진행완료</label>
			</div>
			<div class="form-check form-check-inline">
			  <input name="status" class="form-check-input" type="checkbox" id="statusCheck5" value="5"  <c:forEach var="status" items="${paramValues.status}"><c:if test="${status == '5'}">checked</c:if></c:forEach>>
			  <label for="statusCheck5">진행중단</label>
			</div>
		</div>
		<div class="align-right">
			<select id="order" name="order">
				<option value="1" <c:if test="${param.order == 1}">selected</c:if>>최신순</option>
				<option value="2" <c:if test="${param.order == 2}">selected</c:if>>오래된순</option>
			</select>
		</div>
		<script>
		$('#order').change(function() {
		    $('#search_form').submit();               
		});
		</script>
	</form>
	<c:if test="${count == 0}">
	<div class="result-display">표시할 기부박스가 없습니다.</div>
	</c:if>
	<c:if test="${count > 0}">
	<div>총 ${count} 건의 레코드</div>
	<table class="striped-table">
		<!-- 목록 제목 -->
		<tr>
			<th class="align-center">기부박스 번호</th>
			<th class="align-center">회원 번호</th>
			<th class="align-left" style="width:20%;">기부박스 제목</th>
			<th class="align-left">팀명(기관/단체)</th>
			<th class="align-left">카테고리</th>
			<th class="align-center">등록일</th>
			<th class="align-center">진행 상태</th>
			<th class="align-center">상태 관리</th>
		</tr>
		<!-- 목록 내용 -->
		<c:forEach var="dbox" items="${list}">
		<tr class="mem-item">
			<td class="align-center">${dbox.dbox_num}</td>			
			<td class="align-center">${dbox.mem_num}</td>
			<td class="align-left"><a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content">${dbox.dbox_title}</a></td>
			<td class="align-left">
				<span class="badge">
				<c:if test="${dbox.dbox_team_type == 1}">
				기관
				</c:if>
				<c:if test="${dbox.dbox_team_type == 2}">
				개인/단체
				</c:if>
				</span>
				<br>				
				${dbox.dbox_team_name}
			</td>
			<td class="align-left">
				<img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" style="height:1rem;">${dbox.dcate_name}
			</td>
			<td class="align-center">${dbox.dbox_rdate}
			<td class="dbox_status align-center">
			<c:if test="${dbox.dbox_status == 0}">
			<span style="color:blue">신청완료</span>
			</c:if>
			<c:if test="${dbox.dbox_status == 1}">
			<span style="color:magenta">심사완료</span>
			</c:if>
			<c:if test="${dbox.dbox_status == 2}">
			<span style="color:red">신청반려</span>
			</c:if>
			<c:if test="${dbox.dbox_status == 3}">
			<b>진행중</b>
			</c:if>
			<c:if test="${dbox.dbox_status == 4}">
			진행완료
			</c:if>
			<c:if test="${dbox.dbox_status == 5}">
			<span style="color:red">진행중단</span>
			</c:if>
			</td>
			<td class="text-center">
			<button type="button" class="btn btn-sm btn-outline-success mt-3" onclick="location.href='dboxAdminStatus/${dbox.dbox_num}'">관리</button>
			</td>
		</tr>
		</c:forEach>
	</table>
	<div class="align-center">${page}</div>
	</c:if>
</div>
</section>

<!-- 기부박스 관리 끝 -->