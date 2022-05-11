<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<script type="text/javascript">
//엔터 처리
$(function(){
	   $("input").not($(":button")).keypress(function (evt) {
	        if (evt.keyCode == 13) {
	            var fields = $(this).parents('form,body').find('button,input,textarea,select');
	            var index = fields.index(this);
	            if ( index > -1 && ( index + 1 ) < fields.length ) {
	                fields.eq( index + 1 ).focus();
	            }
	            return false;
	        }
	     });
});
</script>
<div class="header-top">
    <div class="header-left">
        <p style="margin: 2px;">
            <a href="<%=cp%>/" style="text-decoration: none;">
                <span style="width: 200px; height: 70; position: relative; left: 0; top:20px; color: #2984ff; filter: mask(color=red) shadow(direction=135) chroma(color=red);font-style: italic; font-family: arial black; font-size: 30px; font-weight: bold;">SPRING</span>
            </a>
        </p>
    </div>
    <div class="header-right">
        <div style="padding-top: 20px;  float: right;">
               <span style="color:blue;">${sessionScope.member.userName}</span>님
                &nbsp;|&nbsp;
               <a href="<%=cp%>/">로그아웃</a>
                &nbsp;|&nbsp;
               <a href="<%=cp%>/">정보수정</a>
        </div>
    </div>
</div>

<div class="menu">
    <ul class="nav">
        <li><a href="<%=cp%>/admin">Home</a></li>
        <li><a href="#">회원관리</a></li>
        <li><a href="#">커뮤니티관리</a></li>
        <li><a href="#">스터디관리</a></li>
        <li><a href="#">고객센터관리</a></li>
			
        <li style="float: right;"><a href="#"><span style="font-size: 17px; font-weight: 700;">▦</span></a></li>
    </ul>      
</div>
