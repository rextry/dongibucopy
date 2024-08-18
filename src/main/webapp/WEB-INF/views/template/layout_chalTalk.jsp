<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><tiles:getAsString name="title"/></title>
<tiles:insertAttribute name="css" ignore="true"/>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/images/favicon.png"/>
</head>
<body>
	<tiles:insertAttribute name="body"/>
</body>
</html>