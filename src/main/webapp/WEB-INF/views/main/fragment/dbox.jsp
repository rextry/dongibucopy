<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- section 내에 들어갈 내용을 div 내에 작성해주세요 --%>
<%-- section의 높이는 컨텐츠의 길이에 따라 자동 조정됩니다 --%>
<%-- 메인 페이지의 css 파일은 /DontGibuUp/src/main/resources/static/css/main.css 파일 내에 있습니다. --%>
<%-- css 설정이 필요하면 해당 파일 내의 적절한 섹션에서 수정해주세요 (git 충돌 주의) --%>

<div>
	<div class="title-style ">최근에 시작된 기부박스</div>
	<div class="list-group">
	<c:forEach var="dbox" items="${dboxList}" varStatus="loop">
		<div class="list-group-item dbox-main${loop.index + 1}" style="border: none;padding-left:0;">
			<a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content">
				<img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_photo}" width="70" height="50"> <small class="nanum"><b>${dbox.dbox_title}</b></small>
			</a>
		</div>
	</c:forEach>
	</div>
</div>