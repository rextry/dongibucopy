<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/member/member.findpassword.js"></script>
  <div class="container-scroller nanum">
    <div class="container-fluid page-body-wrapper full-page-wrapper">
      <div class="content-wrapper d-flex align-items-center auth px-0">
        <div class="row w-100 mx-0">
          <div class="col-lg-4 mx-auto">
            <div class="auth-form-light text-left py-5 px-4 px-sm-5">
            
              <h4>비밀번호 찾기</h4>
			  <form action="findPasswordResult" method="get" id="member_password" class="mt-3">
			  
                <div class="form-group">
		            <label for="mem_email">이메일</label>
		            <input type="text" id="mem_email" name="mem_email" class="form-control form-control-lg mb-2" maxlength="50"/>
		            <span id="email_check_msg" style="color:#dc3545"><c:if test="${!empty email_msg}">${email_msg}</c:if></span>
                </div>

                <div class="mt-3 d-flex justify-content-center align-items-center">
                  <button class="btn btn-block btn-primary font-weight-medium auth-form-btn nanum custom-btn">비밀번호 찾기</button>
                </div>
                <br>
              </form>
              
            </div>
          </div>
        </div>
      </div>
      <!-- content-wrapper ends -->
    </div>
    <!-- page-body-wrapper ends -->
  </div>
  <!-- container-scroller -->
  <!-- plugins:js -->
  <script src="${pageContext.request.contextPath}/t2/vendors/js/vendor.bundle.base.js"></script>
  <!-- endinject -->
  <!-- Plugin js for this page -->
  <script src="${pageContext.request.contextPath}/t2/vendors/bootstrap-datepicker/bootstrap-datepicker.min.js"></script>
  <!-- End plugin js for this page -->
  <!-- inject:js -->
  <script src="${pageContext.request.contextPath}/t2/js/off-canvas.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/hoverable-collapse.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/template.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/settings.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/todolist.js"></script>
  <!-- endinject -->