<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<!-- Admin 메뉴 시작 -->
      <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <ul class="nav">
        	  <li class="nav-item">
            <p><br>
          </li>
          <li class="nav-item">
            <a class="nav-link">
              <span class="menu-title"><h4 class="mb-3" style="color: #5A6F80;">ADMIN</h4></span>
            </a>
          </li>
          <li class="nav-item nav-category">USER</li>
          <li class="nav-item">
            <a class="nav-link" data-bs-toggle="collapse" href="#ui-basic" aria-expanded="false" aria-controls="ui-basic">
              <i class="menu-icon mdi mdi-account-circle-outline"></i>
              <span class="menu-title">회원관리</span>
              <i class="menu-arrow"></i> 
            </a>
            <div class="collapse" id="ui-basic">
              <ul class="nav flex-column sub-menu">
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/manageMember">회원정보</a></li>
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/managePoint">포인트</a></li>
              </ul>
            </div>
          </li>
          <li class="nav-item nav-category">PAGES</li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/categoryList">
              <i class="menu-icon mdi mdi-lan"></i>
              <span class="menu-title">카테고리</span>
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-bs-toggle="collapse" href="#charts" aria-expanded="false" aria-controls="charts">
              <i class="menu-icon mdi mdi-database-plus"></i>
              <span class="menu-title">기부활동</span>
              <i class="menu-arrow"></i>
            </a>
            <div class="collapse" id="charts">
              <ul class="nav flex-column sub-menu">
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/AdminSubscription">정기기부</a></li>
              	<li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/dboxAdmin">기부박스</a></li>
              </ul>
            </div>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/adminChallenge">
              <i class="menu-icon mdi mdi-account-multiple-outline"></i>
              <span class="menu-title">챌린지</span>
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" data-bs-toggle="collapse" href="#chartsa" aria-expanded="false" aria-controls="chartsa">
              <i class="menu-icon mdi mdi mdi-shopping"></i>
              <span class="menu-title">굿즈샵</span>
              <i class="menu-arrow"></i>
            </a>
            <div class="collapse" id="chartsa">
              <ul class="nav flex-column sub-menu">
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/purchaseList">구매관리</a></li> 
              </ul>
            </div>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/admin/refundRequest">
              <i class="menu-icon mdi mdi mdi-cancel"></i>
              <span class="menu-title">환불신청</span>
            </a>
          </li>
          <li class="nav-item nav-category">HELP</li>
          <li class="nav-item">
            <a class="nav-link" data-bs-toggle="collapse" href="#auth" aria-expanded="false" aria-controls="auth">
              <i class="menu-icon mdi mdi mdi-help-circle-outline"></i>
              <span class="menu-title">고객센터</span>
              <i class="menu-arrow"></i>
            </a>
            <div class="collapse" id="auth">
              <ul class="nav flex-column sub-menu">
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/cs/faq">FAQ</a></li>
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/cs/inquiry">1:1문의</a></li>
                <li class="nav-item"> <a class="nav-link" href="${pageContext.request.contextPath}/admin/cs/report">신고</a></li>
              </ul>
            </div>
          </li>
<!--           <li class="nav-item nav-category">STATS</li>
          <li class="nav-item">
            <a class="nav-link" href="#">
              <i class="menu-icon mdi mdi-chart-line"></i>
              <span class="menu-title">통계</span>
            </a>
          </li> -->
          <li class="nav-item">
            <p><br>
          </li>
        </ul>
      </nav>
<!-- Admin 메뉴 끝 -->