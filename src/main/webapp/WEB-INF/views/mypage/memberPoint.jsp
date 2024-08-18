<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script>
	//페이지 로드 후 제이쿼리를 이용한 자바스크립트 실행
	$(document).ready(
			function() {
				var list = ${listJson}; // 서버에서 넘어온 데이터
				
			    // 리스트를 역순으로 정렬
			    list.reverse();

				let remainingPoint = 0;
				$.each(list, function(index, point) {
					var pointNum = point.point_num;
					remainingPoint = calculateRemainingPoint(point,
							remainingPoint); // calculateRemainingPoint는 잔여 포인트를 계산하는 함수
					updateRemainingPoint(pointNum, remainingPoint); // 테이블 열 업데이트
				});

				function calculateRemainingPoint(point, remainingPoint) {
					return remainingPoint + point.point_amount;
				}

				function updateRemainingPoint(pointNum, remainingPoint) {
					$('#remain_' + pointNum).text(remainingPoint);
				}
			});
</script>
<div class="container mt-4">
	<h4 class="mb-4">포인트</h4>
	<div class="row justify-content-left main-content-container">
		<c:if test="${count == 0}">
		<div class="result-display">포인트 거래 내역이 없습니다.</div>
		</c:if>
		<c:if test="${count > 0}">
            <table class="table table-clean">
                <thead>
                    <tr>
                        <th>분류</th>
                        <th>일자</th>
                        <th>내역</th>
                        <th>포인트</th>
                        <th>잔여포인트</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 데이터 행 추가 -->
                    <c:forEach var="point" items="${list}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${point.pevent_type >= 10 && point.pevent_type < 20}">적립</c:when>
                                    <c:when test="${point.pevent_type >= 20 && point.pevent_type < 30}">사용</c:when>
                                    <c:when test="${point.pevent_type >= 30 && point.pevent_type < 40}">환불</c:when>
                                    <c:when test="${point.pevent_type >= 40 && point.pevent_type < 50}">회수</c:when>
                                    <c:otherwise>기타</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${point.point_date}</td>
                            <td>${point.pevent_detail}</td>
                            <td>${point.point_amount}</td>
                            <td id="remain_${point.point_num}"></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
		<div class="align-center">${page}</div>
		</c:if>
	</div>
</div>