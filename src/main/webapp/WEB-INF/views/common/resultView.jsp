<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${accessTitle}</title>
<style>
    .centered-content {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        text-align: center;
        animation: fadeIn 2s ease-in-out;
        font-size: 5vw; /* Viewport width의 5% */
        color: #333;
        height: 100vh; /* Viewport height */
        white-space: nowrap; /* 줄바꿈 방지 */
        font-family: '맑은 고딕', sans-serif;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    input[type="button"] {
       margin-top: 10px;
        padding: 4px 20px;
        border: 1px solid #09aa5c;
        border-radius: 2px;
        color: #fff;
        background-color: #09aa5c;
        font-weight: bold;
        cursor: pointer;
    }

    input[type="button"]:hover {
        margin-top: 10px;
        padding: 4px 20px;
        border: 1px solid #09aa5c;
        border-radius: 2px;
        background-color: #FFF;
        color: #09aa5c;
        transition: 0.2s ease-out;
        font-weight: bold;
        cursor: pointer;
    }
</style>
</head>
<body>
<div class="centered-content fade-in">
    ${accessMsg}
    <p>
    <input type="button" value="${accessBtn}" onclick="location.href='${accessUrl}'">
</div>
</body>
</html>
