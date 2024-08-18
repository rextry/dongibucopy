<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<head>
    <meta charset="UTF-8">
    <title>챌린지 인증 작성</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/challenge.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<div class="verify-container">
	    <div class="header">
	        <h5>[ ${chal_title} ] 인증</h5>
	    </div>
	    <form:form id="challenge_verify" enctype="multipart/form-data" modelAttribute="challengeVerifyVO">
	        <form:hidden path="chal_joi_num"/>
	        <form:hidden path="chal_num" value="${chal_num}"/>
	        
	        <div class="form-section">
	            <label>인증 방법</label>
	            <p>${chal_verify}</p>
	        </div>
	        
	        <div class="form-section">
	            <form:label path="upload">인증 사진<span class="mandatory">*</span></form:label>
	            <form:input type="file" path="upload" id="uploadImage" onchange="previewImage(event)"/>
	            <form:errors path="upload" cssClass="error"/>
	        </div>
	        
	        <!-- 미리보기 이미지 요소 추가 -->
	        <div>
	            <div class="image-preview">
	                <img id="imagePreview" src="#" alt="Image Preview" style="display: none;"/>
	            </div>
	        </div>
	        
	        <div class="form-section">
	            <form:label path="chal_content">한줄평</form:label>
	            <form:textarea path="chal_content" rows="5" placeholder="오늘 인증은 어떠셨나요?"/>
	        </div>
	        
	        	<div class="submit-button">
			    <input type="button" value="취소" class="cancel-button" onclick="history.back();"/>
			    <button type="submit" class="submit-button2">등록</button>
			</div>
	    </form:form>
	</div>
</body>
<script>
    function previewImage(event) {
        var reader = new FileReader();
        reader.onload = function(){
            var output = document.getElementById('imagePreview');
            output.src = reader.result;
            output.style.display = 'block';
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>