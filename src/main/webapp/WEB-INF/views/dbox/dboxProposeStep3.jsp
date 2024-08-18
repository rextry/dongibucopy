<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>   
<!-- include ckeditor js -->
<script src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/js/ckeditor.js"></script>
<script src="${pageContext.request.contextPath}/js/uploadAdapter.js"></script>
<script src="${pageContext.request.contextPath}/js/dbox/dbox.propose.step3.js"></script>
<!-- Step3 시작 -->
<section class="section-padding nanum">
	<div class="container p-0">
		<jsp:include page="/WEB-INF/views/dbox/nav_dbox.jsp"/>
		<div class="propose-body mx-0">
		
			<form:form action="step3" id="step3" modelAttribute="dboxVO" enctype="multipart/form-data">	
				<form:errors element="div" cssClass="error-color"/><%-- 필드가 없는 에러메세지 --%>
				<ul class="pr-form-content">
					<%-- 기부박스 제목 --%>
					<li class="pr-li-item">
						<form:label path="dbox_title" class="d-flex mb-2"><h3 class="pr-form-label">기부박스 제목</h3><span class="validation-check validation-dot"></span></form:label>
						<form:input path="dbox_title" placeholder="제목을 작성해주세요" cssClass="form-control" style="width:420px;"/>
						<form:errors path="dbox_title" cssClass="form-error"></form:errors>				
					</li>
					<%-- 기부박스 대표이미지 --%>
					<li class="pr-li-item">
						<form:label path="dbox_photo_file" class="d-flex mb-2"><h3 class="pr-form-label">기부박스 대표이미지</h3><span class="validation-check validation-dot"></span></form:label>
						<img id="preview" src="${pageContext.request.contextPath}/images/dboxProfile.png" width="420" height="288" class="mb-2"><br>
						<input type="file" name="dbox_photo_file" id="dbox_photo_file" accept="image/gif,image/png,image/jpeg" class="form-control" style="width:420px;">
						<form:errors path="dbox_photo_file" cssClass="error-color"/>
					</li>
					<%-- 기부박스 내용 작성 --%>
					<li class="pr-li-item">
						<form:label path="dbox_content" class="d-flex mb-2"><h3 class="pr-form-label">기부박스 내용 작성</h3><span class="validation-check validation-dot"></span></form:label>
						<form:textarea path="dbox_content"/>
						<form:errors path="dbox_content" cssClass="error-color"/>
						<script>
						 function MyCustomUploadAdapterPlugin(editor) {
							    editor.plugins.get('FileRepository').createUploadAdapter = (loader) => {
							        return new UploadAdapter(loader);
							    }
							}
						 
						 ClassicEditor
				            .create( document.querySelector( '#dbox_content' ),{
				            	extraPlugins: [MyCustomUploadAdapterPlugin]
				            })
				            .then( editor => {
								window.editor = editor;
							} )
				            .catch( error => {
				                console.error( error );
				            } );
					    </script> 
					</li>
				</ul>
				<div class="d-flex justify-content-end">
					<form:button class="pr-custom-btn">다음 단계로</form:button>
				</div>
			</form:form>
			
		</div>
	</div>
</section>
<!-- Step3 끝 -->