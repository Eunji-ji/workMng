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
	var url1 ="<%=cp%>/workMng/getWeatherData";
	ajaxJSON(url1,"post", "W");
	
	var url2 ="<%=cp%>/workMng/getCovidData";
	ajaxJSON(url2,"post", "C");
});

function ajaxJSON(url, method, div) {
	$.ajax({
		type:method,
		url:url,
		//data,
		dataType:"json",
		success:function(data) {
				if(div = "W"){
					console.log("w : " +data.result);
					if(data.result == 'success'){
						if(data.tmperature != null && data.tmperature != ""){
							var tmp = Number(data.tmperature);
							if(tmp < 10){
								$("#tmperature").css("color", "#46A8ED");
							}else if(tmp > 26){
								$("#tmperature").css("color", "#F46A2D");
							}
							$("#tmperature").text(tmp + "℃");
							style="color: #F1C208;"
						}
						if(data.rain != null && data.rain != ""){
							var rain = "";
							if(data.rain == "0"){
								rain = "비가 오지 않음";
								$("#rain").css("color", "#F1C208");
							}else if(data.rain == "2"){
								rain = "눈/비"
							}else if(data.rain == "4"){
								rain = "소나기"
							}else{
								rain = "비"
							}
							$("#rain").text(rain);
						}
				}else{
					$("#wMsg").text("현재 날씨 정보를 불러올 수 없습니다.");
				}
			}else{
				console.log("c : " +data.result);
				if(data.result == 'success'){
					console.log("c : " +data.decideCnt);
					$("#covid").text(data.decideCnt);
				}else{
					$("#cMsg").text("현재 코로나19 관련 정보를 불러올 수 없습니다.");
				}
			}
		},
		beforeSend:function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", true);
		},
		error:function(jqXHR) {
			if(jqXHR.state==403) {
				login();
				return false;
			}
			
			console.log(jqXHR.responseText);
		}
	});
}
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
			   <p id="tmperature" style="color: #FAD82C; padding-top: 15px;"> </p> 
			   <p id="rain" style="color: #399DCC"> </p> 
			   <p id="wMsg"> </p>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="float: none;">
			   |  <span class="leftPadding">  COVID-19	${covid}</span>
			   	  <p id="covidInfo"> <p>
				  <p id="cMsg"> </p>
			</li>
		</ul>
	</div>
</div>
</body>