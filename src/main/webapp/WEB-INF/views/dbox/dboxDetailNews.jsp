<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="text-center mt-5 mb-5">
	<img src="${pageContext.request.contextPath}/upload/dbox/${dbox.dbox_photo}" class="img-fluid"><br>
</div>

<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content'">기부박스 소개</button>
<button type="button" class="btn btn-outline-success" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/donators'">기부현황</button>
<button type="button" class="btn btn-outline-success active" onclick="location.href='${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/news'">소식</button>