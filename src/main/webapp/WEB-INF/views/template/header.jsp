<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <meta name="description" content="">
    <meta name="author" content="">

    <title>Don Gibu Up</title>

    <!-- CSS FILES -->
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/templatemo-kind-heart-charity.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet">
</head>

<body id="section_1">

	<header class="site-header">
        <div class="container">
            <div class="row col-12">

                <div class="col-lg-8 col-12 d-flex flex-wrap">
                    <p class="d-flex me-4 mb-0">
                        <i class="bi-geo-alt me-2"></i>
                        서울특별시 강남구 역삼동 테헤란로 132 한독약품빌딩 8층
                    </p>

                    <p class="d-flex mb-0">
                        <i class="bi-envelope me-2"></i>

                        <a href="mailto:charity@dongibuup.org">
                            charity@dongibuup.org
                        </a>
                    </p>
                </div>
				<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
				<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.notify.js"></script>
                <div class="col-lg-3 col-12 ms-auto d-lg-block d-none">
                    <ul class="social-icon">
                        <li class="social-icon-item">
                            <a href="#" class="social-icon-link bi-instagram"></a>
                        </li>

                        <li class="social-icon-item">
                            <a href="#" class="social-icon-link bi-facebook"></a>
                        </li>

                        <li class="social-icon-item">
                            <a href="#" class="social-icon-link bi-twitter"></a>
                        </li>
                        
                        <li class="social-icon-item">
                            <a href="#채팅" class="social-icon-link bi-chat-dots"></a>
                        </li>
                        
                        <c:if test="${!empty user}">
	                    <li class="social-icon-item nav-item dropdown nanum" id="notify_icon" data-memnum="${user.mem_num}">
	                        <a href="#알림" class="social-icon-link bi-bell-fill">
							    <span class="notification-badge" style="display:none;"></span>
							</a>
	                        <ul id="notify_icon_list" class="custom-dropdown-menu dropdown-menu dropdown-menu-light px-2" aria-labelledby="navbarLightDropdownMenuLink">
	                            <li><a class="dropdown-item" href="#알림"></a></li>
	                        </ul>
	                    </li>
	                    </c:if>

                    </ul>
                </div>

            </div>
        </div>
    </header>

    <nav class="navbar navbar-expand-lg bg-light shadow-lg">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/main/main">
                <img src="${pageContext.request.contextPath}/t1/images/logo.png" class="logo img-fluid" alt="Kind Heart Charity">
                <span>
                    Don Gibu Up
                    <small class="nanum">돈기부업 :)&nbsp;함께하는 기부활동</small>
                </span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
					<li class="nav-item nanum" id="home-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/main/main">Home</a>
					</li>
					
					<li class="nav-item nanum" id="subscription-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/subscription/subscriptionMain">정기기부</a>
					</li>
					
					<li class="nav-item nanum" id="dbox-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/dbox/list">기부박스</a>
					</li>
					
					<li class="nav-item nanum" id="challenge-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/challenge/list">챌린지</a>
					</li>
					
					<li class="nav-item nanum" id="goods-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/goods/list">굿즈샵</a>
					</li>
					
					<li class="nav-item nanum" id="cs-nav">
					    <a class="nav-link click-scroll" href="${pageContext.request.contextPath}/cs/faqlist">고객센터</a>
					</li>

                    
                    <c:if test="${empty user}">
                    <li class="nav-item ms-3 nanum">
                        <a class="nav-link custom-btn custom-border-btn btn" href="${pageContext.request.contextPath}/member/login">로그인/회원가입</a>
                    </li>
                    </c:if>
                    
                    <c:if test="${!empty user && user.mem_status != 9}"><!-- 일반회원 -->
                    <li class="nav-item ms-3 dropdown nanum">
                        <a class="nav-link custom-btn custom-border-btn dropdown-toggle" id="navbarLightDropdownMenuLink" aria-expanded="false">
                        <c:if test="${!empty user.mem_photo}">
                        <img src="${pageContext.request.contextPath}/upload/${user.mem_photo}" class="rounded-circle my-image">&nbsp;${user.mem_nick}님</a>
                        </c:if>
                        <c:if test="${empty user.mem_photo}">
                        <img src="${pageContext.request.contextPath}/images/basicProfile.png" class="rounded-circle my-image">&nbsp;${user.mem_nick}님</a>
                        </c:if>

                        <ul class="dropdown-menu dropdown-menu-light" aria-labelledby="navbarLightDropdownMenuLink">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/myPage/memberInfo"><small>나의 정보</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/subscription/subscriptionList"><small>나의 기부</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/challenge/join/list?status=on"><small>나의 챌린지</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/goods/purchaseHistory"><small>나의 주문</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/myPage/inquiry"><small>나의 문의</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/logout"><small>로그아웃</small></a></li>
                        </ul>
                    </li>
                    </c:if>
                    <c:if test="${!empty user && user.mem_status == 9}"><!-- 관리자 -->
                    <li class="nav-item ms-3 dropdown nanum">
                        <a class="nav-link custom-btn custom-border-btn dropdown-toggle" id="navbarLightDropdownMenuLink" aria-expanded="false" href="${pageContext.request.contextPath}/admin/manageMember">
                        <c:if test="${!empty user.mem_photo}">
                        <img src="${pageContext.request.contextPath}/upload/${user.mem_photo}" class="rounded-circle my-image">&nbsp;${user.mem_nick}님</a>
                        </c:if>
                        <c:if test="${empty user.mem_photo}">
                        <img src="${pageContext.request.contextPath}/images/basicProfile.png" class="rounded-circle my-image">&nbsp;${user.mem_nick}님</a>
                        </c:if>
                        
                        <ul class="dropdown-menu dropdown-menu-light" aria-labelledby="navbarLightDropdownMenuLink">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/myPage/memberInfo"><small>나의 정보</small></a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/logout"><small>로그아웃</small></a></li>
                        </ul>
                    </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>

	<!-- JAVASCRIPT FILES -->
	<script src="${pageContext.request.contextPath}/t1/js/jquery.min.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/bootstrap.min.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/jquery.sticky.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/click-scroll.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/counter.js"></script>
	<script src="${pageContext.request.contextPath}/t1/js/custom.js"></script>
	
	<script>
	    $(document).ready(function() {
	        var currentPage = window.location.pathname;
	        var basePath = '${pageContext.request.contextPath}';
	
	        var navItems = {
	            '/main': '#home-nav',
	            '/subscription': '#subscription-nav',
	            '/dbox': '#dbox-nav',
	            '/challenge': '#challenge-nav',
	            '/goods': '#goods-nav',
	            '/cs': '#cs-nav'
	        };
	
	        $.each(navItems, function(path, selector) {
	            if (currentPage.startsWith(basePath + path)) {
	                $('.nav-item').find('a').removeClass('active');
	                $(selector).find('a').removeClass('inactive');
	                $(selector).find('a').addClass('active');
	            }
	        });
	    });
	</script>

