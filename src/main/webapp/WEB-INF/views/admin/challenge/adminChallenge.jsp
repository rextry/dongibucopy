<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/challenge/challenge.admin.js"></script>
<section class="section-padding nanum">
    <div class="container">
        <div class="mb-4">
            <h2>챌린지 관리</h2>
        </div>
        <form action="adminChallenge" id="search_form" method="get">
            <ul class="search d-flex">
                <li class="me-2 h-100">
                    <select name="keyfield" id="keyfield" class="h-100">
                        <option value="1" <c:if test="${param.keyfield == 1}">selected</c:if>>챌린지 번호</option>
                        <option value="2" <c:if test="${param.keyfield == 2}">selected</c:if>>제목</option>
                        <option value="3" <c:if test="${param.keyfield == 3}">selected</c:if>>리더 닉네임</option>
                    </select>
                </li>
                <li class="me-2 h-100">
                    <input type="search" name="keyword" id="keyword" class="h-100 m-0" value="${param.keyword}">
                </li>
                <li class="d-flex h-100">
                    <input type="submit" value="찾기" class="me-2 h-100">
                    <button id="allResultBtn" class="h-100" style="width:3rem">전체</button>
                </li>
            </ul>
            <div class="align-right">
                <select id="order" name="order">
                    <option value="1" <c:if test="${param.order == 1}">selected</c:if>>최근 개설</option>
                    <option value="2" <c:if test="${param.order == 2}">selected</c:if>>제목</option>
                    <option value="3" <c:if test="${param.order == 3}">selected</c:if>>리더 닉네임</option>
                </select>
                <script type="text/javascript">
                    $('#order').change(function() {
                        location.href = 'adminChallenge?keyfield='
                                        + $('#keyfield').val()
                                        + '&keyword='
                                        + $('#keyword').val()
                                        + '&order=' + $('#order').val();
                    });
                </script>
            </div>
        </form>
        <c:if test="${count == 0}">
		    <div>표시할 챌린지가 없습니다.</div>
		</c:if>
		<c:if test="${count > 0}">
            <div class="mb-2">총 ${count} 건의 레코드</div>
            <table class="table table-clean table-hover">
                <thead>
					<tr>
					    <th>번호</th>
					    <th>카테고리</th>
					    <th>제목</th>
					    <th>리더</th>
					    <th>공개여부</th>
					    <th>개설일</th>
					    <th>관리</th>
					</tr>
                </thead>
                <tbody>
                    <c:forEach var="challenge" items="${list}">
                        <tr>
                            <td class="text-center">${challenge.chal_num}</td>
					        <td class="text-center">${challenge.categoryName}</td>
					        <td class="text-left"><a href="adminChallengeDetail?chal_num=${challenge.chal_num}" class="text-decoration-none">${challenge.chal_title}</a></td>
					        <td class="text-center">${challenge.mem_nick}</td>
					        <td class="text-center">${challenge.chal_public == 0 ? '공개' : '비공개'}</td>
					        <td class="text-center">${challenge.chal_rdate}</td>
					        <td class="text-center">
					        	<c:if test="${challenge.chal_phase == 0}">
					        		<button class="btn btn-custom activateBtn" data-chal-num="${challenge.chal_num}" data-phase="0">챌린지 중단</button>
					        	</c:if>
					        	<c:if test="${challenge.chal_phase == 1}">
					        		<button class="btn btn-custom activateBtn" data-chal-num="${challenge.chal_num}" data-phase="1">챌린지 중단</button>
					        	</c:if>
					        	<c:if test="${challenge.chal_phase == 2}">
					        		<button class="btn btn-custom activateBtn" disabled>챌린지 중단</button>
					        	</c:if>
					        </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="align-center">${page}</div>
        </c:if>
    </div>
</section>

<script type="text/javascript">
    $(function() {
        // 전체보기 버튼 클릭
        $('#allResultBtn').click(function() {
            $('#keyfield').val('');
            $('#keyword').val('');
            $('#order').val('');
            location.href='adminChallenge';        
        });

        // 검색 버튼 유효성 체크
        $('#search_form').submit(function(event) {
            if ($('#keyfield').val() == 1) {
                var keyword = $('#keyword').val().trim();
                if (!/^\d+$/.test(keyword)) {
                    alert('챌린지 번호는 숫자 형식만 입력 가능합니다.');
                    event.preventDefault(); // 폼 제출 중단
                }
            }
        });
    });
</script>