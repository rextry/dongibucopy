<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!-- 게시판 글쓰기 시작 -->
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="${pageContext.request.contextPath}/js/ckeditor.js"></script>
<script src="${pageContext.request.contextPath}/js/uploadAdapter.js"></script>
<!-- CSS FILES -->
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/templatemo-kind-heart-charity.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/goods.css" rel="stylesheet">
     
    
<br><br><br>
<div class="page-main">
	<h2>상품 등록</h2>
	<form:form action="write" id="goods_register"
		enctype="multipart/form-data"
							modelAttribute="goodsVO">
	<ul>
		<li>
		 	<form:label path="dcate_num">분류</form:label><br>
		 	<form:select path="dcate_num">
		 		<option disabled="disabled" selected>선택하세요</option>
		 		<form:option value="1">독거노인기본생활 지원</form:option>
		 		<form:option value="2">청년 고립 극복 지원</form:option>
		 		<form:option value="3">유기동물 구조와 보호</form:option>
		 		<form:option value="4">미혼모(한부모가정)</form:option>
		 		<form:option value="5">해외 어린이 긴급구호</form:option>
		 		<form:option value="6">위기가정 아동지원</form:option>
		 		<form:option value="7">쓰레기 문제 해결</form:option>
		 		<form:option value="8">장애 어린이 재활 지원</form:option>
		 	</form:select>
		 	<form:errors path="dcate_num" cssClass="error-color"/>
		</li>
		
		<li>상품명<br>
		 	<form:input path="item_name"/>
		 	<form:errors path="item_name" cssClass="error-color"/>
		</li>
		<li>가격<br>
		 	<form:input path="item_price"/>
		 	<form:errors path="item_price" cssClass="error-color"/>
		</li>
		<li>수량<br>
		 	<form:input path="item_stock"/>
		 	<form:errors path="item_stock" cssClass="error-color"/>
		</li>
		<li>
		 	<form:textarea path="item_detail"/>
		 	<form:errors path="item_detail" cssClass="error-color"/>
		 	<script>
                function MyCustomUploadAdapterPlugin(editor) {
                    editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
                        return new UploadAdapter(loader);
                    }
                }
             
                ClassicEditor
                .create(document.querySelector('#item_detail'), {
                    extraPlugins: [MyCustomUploadAdapterPlugin],
                    height: 400, // 에디터의 높이를 400px로 설정합니다.
                    toolbar: {
                        items: [
                            'heading', '|',
                            'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', '|',
                            'insertTable', 'tableColumn', 'tableRow', 'mergeTableCells', '|',
                            'undo', 'redo'
                        ]
                    },
                    table: {
                        contentToolbar: [ 'tableColumn', 'tableRow', 'mergeTableCells' ]
                    },
                    licenseKey: '',
                    
                })
                .then(editor => {
                    window.editor = editor;
                    editor.editing.view.change(writer => {
                        writer.setStyle(
                            'height',
                            '400px',
                            
                            editor.editing.view.document.getRoot()
                        );
                    });
                })
                .catch(error => {
                    console.error(error);
                });
            </script>
		</li>
		<li>
		 	<form:label path="item_photo">파일업로드</form:label>
		 	<input type="file" name="upload" id="upload">
		 	<form:errors path="upload" cssClass="error-color"/>
		</li><br>
		 <li>
            <form:label path="item_status">판매 상태</form:label>
            <form:select path="item_status">
                <form:option value="1">판매 중</form:option>
                <form:option value="0">미판매</form:option>
            </form:select>
            <form:errors path="item_status" cssClass="error-color"/>
        </li>
	</ul>						
	<div class="align-center">
    <form:button class="default-btn btn-large">등록</form:button>
    <input type="button" value="목록"
           class="default-btn btn-large"
           onclick="location.href='list'">
	</div>				
	</form:form>

<!-- 게시판 글쓰기 끝 -->
</div>
