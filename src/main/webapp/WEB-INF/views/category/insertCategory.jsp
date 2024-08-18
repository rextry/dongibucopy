<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- 게시판 글쓰기 시작 -->
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- include ckeditor js -->
<script src="${pageContext.request.contextPath}/js/ckeditor.js"></script>
<script src="${pageContext.request.contextPath}/js/uploadAdapter.js"></script>
<form:form action="insertCategory" method="post" enctype="multipart/form-data" modelAttribute="donationCategoryVO">
    <ul>
        <li>
            <form:label path="iconUpload">기부카테고리 아이콘</form:label>
            <input type="file" name="iconUpload" id="iconUpload">
            <form:errors path="iconUpload" cssClass="error-color"/>
        </li>
        <li>
            <form:label path="bannerUpload">기부카테고리 배너</form:label>
            <input type="file" name="bannerUpload" id="bannerUpload">
            <form:errors path="bannerUpload" cssClass="error-color"/>
        </li>
        <li>
            <form:input path="dcate_name" placeholder="카테고리명을 입력하세요."/>
            <form:errors path="dcate_name" cssClass="error-color"/>
        </li>
        <li>
            <form:input path="dcate_charity" placeholder="연결되는 기부처를 입력하세요" id="dcate_charity"/>
            <form:errors path="dcate_charity" cssClass="error-color"/>
        </li>
        <li>
            <form:textarea path="dcate_content" id="dcate_content" placeholder="기부처에 대한 설명을 입력하세요"/>
            <form:errors path="dcate_content"/>
            <script>
                function MyCustomUploadAdapterPlugin(editor) {
                    editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
                        return new UploadAdapter(loader);
                    }
                }

                ClassicEditor
                    .create(document.querySelector('#dcate_content'), {
                        extraPlugins: [MyCustomUploadAdapterPlugin]
                    })
                    .then(editor => {
                        window.editor = editor;
                    })
                    .catch(error => {
                        console.error('There was a problem initializing the editor.', error);
                    });
            </script>
        </li>
    </ul>

    <div class="align-center">
        <input type="submit" value="등록">
        <input type="button" value="취소" onclick="location.href='categoryList'">
    </div>
</form:form>
