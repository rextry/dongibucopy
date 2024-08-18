<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title><tiles:getAsString name="title" /></title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dboxDetail.css" type="text/css">
	<tiles:insertAttribute name="css" ignore="true" />

	<!-- Required meta tags -->
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>Star Admin2 </title>
	<!-- plugins:css -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/feather/feather.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/mdi/css/materialdesignicons.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/ti-icons/css/themify-icons.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/typicons/typicons.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/simple-line-icons/css/simple-line-icons.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/css/vendor.bundle.base.css">
	<!-- endinject -->
	<!-- Plugin css for this page -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/vendors/datatables.net-bs4/dataTables.bootstrap4.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/js/select.dataTables.min.css">
	<!-- End plugin css for this page -->
	<!-- inject:css -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/t2/css/vertical-layout-light/style.css">
	<!-- endinject -->
	<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png"/>
</head>
<body>
<div id="main">
	<div id="main_header">
		<tiles:insertAttribute name="header" />
	</div>
	<div class="page-body-wrapper nanum">
		<tiles:insertAttribute name="nav" />
		
		<div class="main-panel">
	        <div class="content-wrapper">
	          <div class="row">
	            <div class="col-sm-12">
	              <div class="home-tab">
	                <div class="tab-content tab-content-basic">
	                  <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview"> 
							<div id="page_body_admin">
								<tiles:insertAttribute name="AdmminBody"/>
							</div>	
							<div class="side-height">
								<div id="page_body_d">
									<tiles:insertAttribute name="detailBody"/>
								</div>
								<div id="page_nav_d">
									<tiles:insertAttribute name="detailNav"/>
								</div>
							</div>
					  </div>
					</div>
				  </div>
				</div>
			  </div>
			</div>
		</div>
	</div>
	<div id="main_footer" class="page-clear">
		<tiles:insertAttribute name="footer" />
	</div>
</div>

  <!-- plugins:js -->
  <script src="${pageContext.request.contextPath}/t2/vendors/js/vendor.bundle.base.js"></script>
  <!-- endinject -->
  <!-- Plugin js for this page -->
  <script src="${pageContext.request.contextPath}/t2/vendors/chart.js/Chart.min.js"></script>
  <script src="${pageContext.request.contextPath}/t2/vendors/bootstrap-datepicker/bootstrap-datepicker.min.js"></script>
  <script src="${pageContext.request.contextPath}/t2/vendors/progressbar.js/progressbar.min.js"></script>

  <!-- End plugin js for this page -->
  <!-- inject:js -->
  <script src="${pageContext.request.contextPath}/t2/js/off-canvas.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/hoverable-collapse.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/template.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/settings.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/todolist.js"></script>
  <!-- endinject -->
  <!-- Custom js for this page-->
  <script src="${pageContext.request.contextPath}/t2/js/dashboard.js"></script>
  <script src="${pageContext.request.contextPath}/t2/js/Chart.roundedBarCharts.js"></script>
  <!-- End custom js for this page-->
</body>
</html>