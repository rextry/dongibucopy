<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dboxMypage.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>

<div class="page-container">
    <div class="tabs">
        <button class="tab-button active" onclick="location.href='dboxMyPropose'">제안한 기부박스</button>
        <!-- <button class="tab-button" onclick="location.href='dboxMyDonation'">기부박스 기부내역</button> -->
    </div>
    <div id="dboxMyPropose" class="tab-content active">
        <div class="page-main">
            <h4>제안한 기부박스</h4>
            <c:if test="${count == 0}">
                <div class="result-display">제안한 기부박스가 없습니다.</div>
            </c:if>
            <c:if test="${count > 0}">
                <c:forEach var="dbox" items="${list}">
                    <div class="item_dbox">
                        <dl class="header-item">
                            <dt class="d-flex flex-column align-items-start dbox-title-dt">
                                <span style="font-size:1.25rem" class="mb-2">
                                	<c:if test="${dbox.dbox_status==0}"><a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/example">${dbox.dbox_title}</a></c:if>
									<c:if test="${dbox.dbox_status==1}"><a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/example">${dbox.dbox_title}</a></c:if>
                                    <c:if test="${dbox.dbox_status==2}">${dbox.dbox_title}</c:if>
                                    <c:if test="${dbox.dbox_status==3}"><a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content">${dbox.dbox_title}</a></c:if>
                                    <c:if test="${dbox.dbox_status==4}"><a href="${pageContext.request.contextPath}/dbox/${dbox.dbox_num}/content">${dbox.dbox_title}</a></c:if>
                                    <c:if test="${dbox.dbox_status==5}">${dbox.dbox_title}</c:if>
                                </span>
                                <span><img src="${pageContext.request.contextPath}/upload/${dbox.dcate_icon}" alt="기부처 아이콘" width="30">${dbox.dcate_name}</span>
                            </dt>
                            <dd>
                                <a href="#" class="dbox-link" data-dbox-num="${dbox.dbox_num}">
                                    <c:if test="${dbox.dbox_status==0}">신청완료</c:if>
                                    <c:if test="${dbox.dbox_status==1}">심사완료</c:if>
                                    <c:if test="${dbox.dbox_status==2}">신청반려</c:if>
                                    <c:if test="${dbox.dbox_status==3}">진행중</c:if>
                                    <c:if test="${dbox.dbox_status==4}">진행완료</c:if>
                                    <c:if test="${dbox.dbox_status==5}">진행중단</c:if>
                                </a>
                            </dd>
                        </dl>
                        <div class="cont-item">
                            <dl class="info-item">
                                <dt>목표금액</dt>
                                <dd><fmt:formatNumber value="${dbox.dbox_goal}" pattern="#,##0" /> 원</dd>
                            </dl>
                            <dl class="info-item">
                                <dt>현재 모금액</dt>
                                <dd><fmt:formatNumber value="${dbox.total}" pattern="#,##0" /> 원</dd>
                            </dl>
                            <dl class="info-item">
                                <dt>기간</dt>
                                <dd>${dbox.dbox_sdate}  ~  ${dbox.dbox_edate}</dd>
                            </dl>
                        </div>
                    </div>
                    
					<!-- 모달 구조 -->
					<div class="modal fade" id="dboxModal" tabindex="-1" role="dialog" aria-labelledby="dboxModalLabel" aria-hidden="true">
					  <div class="modal-dialog modal-dialog-centered" role="document">
					    <div class="modal-content">
					      <div class="modal-header">
					        <h5 class="modal-title" id="dboxModalLabel">
                                <c:if test="${dbox.dbox_status==0}">신청완료</c:if>
                                <c:if test="${dbox.dbox_status==1}">심사완료</c:if>
                                <c:if test="${dbox.dbox_status==2}">신청반려</c:if>
                                <c:if test="${dbox.dbox_status==3}">진행중</c:if>
                                <c:if test="${dbox.dbox_status==4}">진행완료</c:if>
                                <c:if test="${dbox.dbox_status==5}">진행중단</c:if>
					        </h5>
					      </div>
					      <div class="modal-body">
					        <c:forEach var="dbox" items="${list}">
					          <div id="dboxContent${dbox.dbox_num}" class="dbox-content" style="display: none;">
								<c:if test="${dbox.dbox_status==0}">
									기부박스 신청이 완료되었습니다.<br>
									심사를 기다려주세요.
								</c:if>
                                <c:if test="${dbox.dbox_status==1}">
									기부박스 개설이 승인되었습니다.<br>
									설정하신 시작일에 모금이 시작됩니다.
								</c:if>
                                <c:if test="${dbox.dbox_status==2}">
                                	${dbox.dbox_acomment}
                                </c:if>
                                <c:if test="${dbox.dbox_status==3}">
									현재 모금중인 기부박스입니다.
								</c:if>
                                <c:if test="${dbox.dbox_status==4}">
									기부박스 모금이 완료되었습니다.
								</c:if>
                                <c:if test="${dbox.dbox_status==5}">
									${dbox.dbox_acomment}
								</c:if>
					          </div>
					        </c:forEach>
					      </div>
					      <div class="modal-footer">
					        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
					      </div>
					    </div>
					  </div>
					</div>
					
                </c:forEach>
            </c:if>
        </div><!-- end of Page-main -->
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<script>
$(document).ready(function() {
  $('.dbox-link').on('click', function(e) {
    e.preventDefault();
    
    var dboxNum = $(this).data('dbox-num');
    
    // 모든 dbox-content 요소를 숨깁니다.
    $('.dbox-content').hide();
    
    // 해당 dboxNum에 맞는 내용만 표시합니다.
    $('#dboxContent' + dboxNum).show();
    
    // 모달을 표시합니다.
    $('#dboxModal').modal('show');
  });

  // 모달 'X' 버튼과 '닫기' 버튼 클릭 이벤트
  $('#dboxModal .close, #dboxModal .btn-secondary').on('click', function() {
    $('#dboxModal').modal('hide');
  });
});
</script>