<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp=request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" href="<%=cp%>/resource/css/style.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/dashboard.css" type="text/css">
<style type="text/css">
</style>
<script type="text/javascript" >
$(document).ready(function(){  
	var xhr = new XMLHttpRequest();
	var url = 'http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson'; /*URL*/
	var queryParams = '?' + encodeURIComponent('serviceKey') + '='+ encodeURIComponent('oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D'); /*Service Key*/
	queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
	queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('10'); /**/
	queryParams += '&' + encodeURIComponent('startCreateDt') + '=' + encodeURIComponent('20220501'); /**/
	queryParams += '&' + encodeURIComponent('endCreateDt') + '=' + encodeURIComponent('20220501'); /**/
	xhr.open('GET', url + queryParams);
	xhr.onreadystatechange = function () {
	    if (this.readyState == 4) {
	        alert('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
	    }
	};
	xhr.send('');
	console.log(encodeURIComponent('oBj4vm7AKoRsq2STsI79o%2BZHpOyN38r3Z9rzWwKV15DxpZt3%2BlZ%2F2jiqZlVu92O5rdwt%2B%2F8nylKIBEhn%2B%2FwBHQ%3D%3D'));
	console.log(this.responseText);
});
</script>

<body>
<div class="body-container" style="width: 900px; height: 600px; padding-top: 80px; padding-bottom: 80px;">
	<div style="width: 60%; height: 100%; float: left;">
		<ul>
			<li class="boardTitle">
			   | <span class="leftPadding"> TO DO LIST</span>
			</li>
		</ul>
		<ul>
			<li class="boardTitle">
			   |  <span class="leftPadding">  MEMO </span>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="width: 90%">
			   | <span class="leftPadding">  TODAY PLAN </span>
			</li>
		</ul>
	</div>
	<div style="width: 40%; height: 100%; float: left;">
		<ul>
			<li class="boardTitle">
			   |  <span class="leftPadding">  WEATHER </span>
			   <p>${weather}<p>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="float: none;">
			   |  <span class="leftPadding">  COVID-19	${covid}</span>
			   	  <p>${covid}<p>
			   	<button onclick="test();">test</button>
			</li>
		</ul>
	</div>
</div>
</body>