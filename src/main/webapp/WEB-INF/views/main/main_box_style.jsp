<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<%-- 상단 배너 --%>
<div class="top-banner col-lg-9">
	<jsp:include page="/WEB-INF/views/main/fragment/top_banner.jsp" />
</div>

<%-- 박스 레이아웃 --%>
<div class="main-container col-lg-9">  
    <div class="d-flex justify-content-between">
        <div class="left-section mb-0">
            <section class="main-section" id="challenge1_section">
                <jsp:include page="/WEB-INF/views/main/fragment/challenge1.jsp" />
            </section>
            <section class="main-section" id="challenge2_section">
                 <jsp:include page="/WEB-INF/views/main/fragment/challenge2.jsp" />
            </section>
            <section class="main-section" id="subscription_section">
                 <jsp:include page="/WEB-INF/views/main/fragment/subscription.jsp" />
            </section>
        </div>
        <div class="right-section">
            <section class="main-section" id="dbox_section">
                <jsp:include page="/WEB-INF/views/main/fragment/dbox.jsp" />
            </section>
            <section class="main-section" id="goods_section">
                <jsp:include page="/WEB-INF/views/main/fragment/goods.jsp" />
            </section>
        </div>
    </div>
</div>

	<!-- JAVASCRIPT FILES -->
	<script src="${pageContext.request.contextPath}/t1/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/jquery.sticky.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/click-scroll.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/counter.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/custom.js"></script>