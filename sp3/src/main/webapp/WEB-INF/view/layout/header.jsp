<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<div class="header-top">
    <div class="header-left">
        <p style="margin: 2px;">
            <a href="<%=cp%>/" style="text-decoration: none;">
                <span style="width: 200px; height: 70; position: relative; left: 0; top:20px; color: #2984ff; filter: mask(color=red) shadow(direction=135) chroma(color=red);font-style: italic; font-family: arial black; font-size: 30px; font-weight: bold;">WorkManager</span>
            </a>
        </p>
    </div>
    <div class="header-right">
        <div style="padding-top: 20px;  float: right;">
            <c:if test="${empty sessionScope.member}">
                <a href="<%=cp%>/member/login">로그인</a>
                    &nbsp;|&nbsp;
                <a href="<%=cp%>/member/member">회원가입</a>
            </c:if>
            <c:if test="${not empty sessionScope.member}">
                <span style="color:blue;">${sessionScope.member.userName}</span>님
                &nbsp;|&nbsp;
                <a href="<%=cp%>/member/logout">로그아웃</a>
                &nbsp;|&nbsp;
                <a href="<%=cp%>/member/pwd">정보수정</a>
                <c:if test="${sessionScope.member.userId=='admin'}">
                    &nbsp;|&nbsp;
                    <a href="<%=cp%>/admin">관리자</a>
                </c:if>
            </c:if>
        </div>
    </div>
</div>

<div class="menu">
    <ul class="nav">
    
	    <c:if test="${not empty sessionScope.member}">
        <li>
            <a href="<%=cp%>/workMng/dashboard">마이페이지</a>
        </li>
		</c:if>

        <li>
            <a href="#">커뮤니티</a>
            <ul>
                <li><a href="<%=cp%>/guest/guest">방명록</a></li>
                <li><a href="<%=cp%>/bbs/list">게시판</a></li>
                <li><a href="#">답변형 게시판</a></li>
                <li><a href="#">자료실</a></li>
                <li><a href="#">포토갤러리</a></li>
                <li><a href="#">채팅</a></li>
            </ul>
        </li>

        <li>
            <a href="#">고객센터</a>
            <ul>
                <li><a href="#" style="margin-left:150px; " onmouseover="this.style.marginLeft='150px';">자주하는질문</a></li>
                <li><a href="<%=cp%>/notice/list">공지사항</a></li>
                <li><a href="#">질문과 답변</a></li>
                <li><a href="#">1:1 문의</a></li>
                <li><a href="#">이벤트</a></li>
            </ul>
        </li>

        <li style="float: right;"><a href="#"><span style="font-size: 17px; font-weight: 700;">▦</span></a></li>
    </ul>      
</div>
