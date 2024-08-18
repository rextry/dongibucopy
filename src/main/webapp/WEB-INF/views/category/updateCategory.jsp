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
<form:form action="updateCategory" enctype="multipart/form-data" modelAttribute="donationCategoryVO">
    <input type="hidden" name="dcate_num" value="${donationCategoryVO.dcate_num}">

    <ul>
        <li>
            <label for="iconUpload">기부카테고리 아이콘</label>
            <input type="file" name="iconUpload" id="iconUpload">
            <div class="file-detail">
                (${donationCategoryVO.dcate_icon}) 파일이 등록되어 있습니다.
            </div>
        </li>
        <li>
            <label for="bannerUpload">기부카테고리 배너</label>
            <input type="file" name="bannerUpload" id="bannerUpload">
            <div class="file-detail">
                (${donationCategoryVO.dcate_banner}) 파일이 등록되어 있습니다.
            </div>
        </li>
        <li>
            <label for="dcate_name">카테고리명</label>
            <form:input path="dcate_name" id="dcate_name" placeholder="카테고리명을 입력하세요."/>
            <form:errors path="dcate_name" cssClass="error-color"/>
        </li>
        <li>
            <label for="dcate_charity">연결되는 기부처</label>
            <form:input path="dcate_charity" id="dcate_charity" placeholder="연결되는 기부처를 입력하세요"/>
            <form:errors path="dcate_charity" cssClass="error-color"/>
        </li>
        <li>
            <label for="dcate_content">기부처 설명</label>
            <form:textarea path="dcate_content" id="dcate_content" placeholder="기부처에 대한 설명을 입력하세요"/>
            <form:errors path="dcate_content"/>
        </li>
    </ul>

    <div class="align-center">
        <input type="submit" value="등록">
        <input type="button" value="취소" onclick="location.href='/category/categoryList'">
    </div>
</form:form>

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
