<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> 
<section class="section-padding nanum">
	<div class="container">
		<div class="text-center mt-5 mb-5">
			<img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_photo}" class="img-fluid"><br>
		</div>
		
		<div class="mb-2">
			<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content'">기부박스 소개</button>
			<button type="button" class="btn btn-outline-success active" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/donators'">기부현황</button>
			<%-- <button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/news'">소식</button> --%>
		</div>
		<br>
		
		<div class="row">
		<!-- start -->
		<c:if test="${dboxDonations.size() <= 0}">
		<div class= "custom-block-body">
			<p>아직 기부자가 없습니다.</p>
		</div>
		</c:if>
		<c:if test="${dboxDonations.size() > 0}">
		<c:forEach var="donators" items="${dboxDonations}">
			<div class="col-lg-6 col-md-6 col-6 mb-5">
				<div class="custom-block-wrap shadow">
					<div class="custom-block">
						<div class="custom-block-body">
							<h5 class="mb-3"><fmt:formatNumber value="${donators.dbox_do_price}" pattern="#,###"/>원 기부</h5>
							<%-- 기명 기부 --%>
							<c:if test="${donators.dbox_do_annony == 0}">
								<%-- 닉네임 --%>
								${donators.mem_nick}
								<%-- 프로필 사진 --%>
								<c:if test="${!empty donators.mem_photo}">
						  	 		<img src="${pageContext.request.contextPath}/upload/${donators.mem_photo}" class="donator-profile-photo">
							    </c:if>
							    <c:if test="${empty donators.mem_photo}">
							 	  	<img src="${pageContext.request.contextPath}/images/basicProfile.png" class="donator-profile-photo">
							    </c:if>
							</c:if>
							<%-- 익명 기부 --%>
							<c:if test="${donators.dbox_do_annony == 1}">
								익명 기부
								<img src="${pageContext.request.contextPath}/images/basicProfile.png" class="donator-profile-photo">
							</c:if>
							<%-- 코멘트 --%>
							<c:if test="${!empty donators.dbox_do_comment}">
								<p>${donators.dbox_do_comment}</p>
							</c:if>
							<%-- 미작성시 기본 멘트 --%>
							<c:if test="${empty donators.dbox_do_comment}">
								<p>조용히 기부합니다.</p>
							</c:if>
							${donators.dbox_do_reg_date}
						</div>
					</div>
				</div>
			</div>
		</c:forEach>
		</c:if>
		</div>
		<!-- end -->
	</div>
</section>