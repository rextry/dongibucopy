<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
    <title>Result</title>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function() {
            alert("${message}");
            setTimeout(function() {
                window.location.href = "${uri}";
            }, 500); // 1초 후에 리디렉션
        });
    </script>
</head>
<body>
    <!-- Body content, if any -->
</body>
</html>