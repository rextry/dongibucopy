<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 수정</title>
    <!-- CSS FILES -->
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/t1/css/templatemo-kind-heart-charity.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/goods.css" rel="stylesheet">
</head>
<body>
    <section class="cta-section section-padding section-bg">
        <div class="container">
            <div class="row justify-content-center align-items-center">
                <div class="col-lg-5 col-12 ms-auto">
                    <h2 class="mb-0">Make an impact. <br> Save lives.</h2>
                </div>
                <div class="col-lg-5 col-12">
                    <a href="#" class="me-4">Make a donation</a> 
                    <a href="#section_4" class="custom-btn btn smoothscroll">Become a volunteer</a>
                </div>
            </div>
        </div>
    </section>
    
    <div class="container mt-5">
        <h2 class="text-center mb-4">상품 수정 페이지</h2>
        <form action="${pageContext.request.contextPath}/goods/update" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
            <input type="hidden" name="item_num" value="${goodsVO.item_num}">
            <div class="mb-3">
                <label for="item_name" class="form-label">상품명</label>
                <input type="text" id="item_name" name="item_name" value="${goodsVO.item_name}" class="form-control" required>
                <div class="invalid-feedback">
                    상품명을 입력해 주세요.
                </div>
            </div>
            <div class="mb-3">
                <label for="item_price" class="form-label">가격</label>
                <input type="text" id="item_price" name="item_price" value="${goodsVO.item_price}" class="form-control" required>
                <div class="invalid-feedback">
                    가격을 입력해 주세요.
                </div>
            </div>
            <div class="mb-3">
                <label for="item_stock" class="form-label">재고</label>
                <input type="text" id="item_stock" name="item_stock" value="${goodsVO.item_stock}" class="form-control" required>
                <div class="invalid-feedback">
                    재고를 입력해 주세요.
                </div>
            </div>
            <div class="mb-3">
                <label for="item_photo" class="form-label">사진</label>
                <input type="file" id="item_photo" name="upload" class="form-control">
            </div>
            <div class="mb-3">
                <label for="item_detail" class="form-label">상세 설명</label>
                <textarea id="item_detail" name="item_detail" class="form-control" rows="5" required>${goodsVO.item_detail}</textarea>
                <div class="invalid-feedback">
                    상세 설명을 입력해 주세요.
                </div>
            </div>
            <div class="mb-3">
                <label for="dcate_num" class="form-label">카테고리</label>
                <select id="dcate_num" name="dcate_num" class="form-select" required>
                    <option value="1" ${goodsVO.dcate_num == 1 ? 'selected' : ''}>독거노인기본생활 지원</option>
                    <option value="2" ${goodsVO.dcate_num == 2 ? 'selected' : ''}>청년 고립 극복 지원</option>
                    <option value="3" ${goodsVO.dcate_num == 3 ? 'selected' : ''}>유기동물 구조와 보호</option>
                    <option value="4" ${goodsVO.dcate_num == 4 ? 'selected' : ''}>미혼모(한부모가정)</option>
                    <option value="5" ${goodsVO.dcate_num == 5 ? 'selected' : ''}>해외 어린이 긴급구호</option>
                    <option value="6" ${goodsVO.dcate_num == 6 ? 'selected' : ''}>위기가정 아동지원</option>
                    <option value="7" ${goodsVO.dcate_num == 7 ? 'selected' : ''}>쓰레기 문제 해결</option>
                    <option value="8" ${goodsVO.dcate_num == 8 ? 'selected' : ''}>장애 어린이 재활 지원</option>
                </select>
                <div class="invalid-feedback">
                    카테고리를 선택해 주세요.
                </div>
            </div>
            <div class="mb-3">
                <label for="item_status" class="form-label">상태</label>
                <select id="item_status" name="item_status" class="form-select" required>
                    <option value="1" ${goodsVO.item_status == 1 ? 'selected' : ''}>판매</option>
                    <option value="2" ${goodsVO.item_status == 2 ? 'selected' : ''}>미판매</option>
                </select>
                <div class="invalid-feedback">
                    상태를 선택해 주세요.
                </div>
            </div>
            <div class="text-center">
                <button type="submit" class="default-btn btn-large">수정</button>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bootstrap validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>
