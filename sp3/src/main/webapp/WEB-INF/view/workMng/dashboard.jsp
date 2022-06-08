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
<link href='http://www.openhiun.com/hangul/nanumbarungothic.css' rel='stylesheet' type='text/css'>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
<style type="text/css">
body {
  font-family: 'Nanum Barun Gothic', sans-serif;
}
</style>
<script type="text/javascript" >
$(document).ready(function(){
	// 날씨 api
	var url1 ="<%=cp%>/workMng/getWeatherData";
	ajaxJSON(url1,"post", "W");
	
	// 코로나 api 
	var url2 ="<%=cp%>/workMng/getCovidData";
	ajaxJSON(url2,"post", "C");
	
	// list 출력 
	var url3 ="<%=cp%>/workMng/selectList";
	ajaxJSON(url3,"post", "L");

});

function ajaxJSON(url, method, div) {
	$.ajax({
		type:method,
		url:url,
		//data,
		dataType:"json",
		success:function(data) {
				if(div === "W"){
					console.log("W : " +data.result);
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
				}
				if(div === "C"){
					console.log("C : " +data.result);
					if(data.result == 'success'){
						var todayCount = setTodayCovidData(data);
						$("#covidInfo").text('총 확진자 : ' + data.decideCnt);
						$("#todayCount").text('( + ' + todayCount + ' )');
					}else{
						$("#cMsg").text("현재 코로나19 관련 정보를 불러올 수 없습니다.");
					}
				}
				if(div === "L"){
					if(data.todoList != null){
						var todoList = data.todoList;
						selectTodoList(todoList);
					}
					
					if(data.planList != null){
						var planList = data.planList;
						selectPlanList(planList);
					}
					
					if(data.memoList != null){
						var memoList = data.memoList;
						selectMemoList(memoList);
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

function setTodayCovidData(data){
	return Number(data.decideCnt) - Number(data.beforeDecideCnt);
}

function selectTodoList(todoList){
	var html = '';
	for(var i=0; i<todoList.length; i++){
		var data = todoList[i];
		html += '<tr>';
		html += '<td style="display: none;">' + data.toDoNum + '</td>';
		html += '<td style="padding-right: 5px;"> <input type="checkbox" id='+data.toDoNum+'> </td>';
		html += '<td>' + data.todoCreatDt + '</td>';
		html += '<td>' + data.todoSubject + '</td>';
		html += "</tr>";	
	}
	$("#todoListTb").append(html);
}

function selectPlanList(planList){
	var html = '';
	for(var i=0; i<planList.length; i++){
		var data = planList[i];
		html += '<tr>';
		html += '<td style="display: none;">' + data.planNum + '</td>';
		html += '<td>' + data.planCreatDt + '</td>';
		html += '<td style="color: #3799F3; padding: 0 5px">' + data.planTm + '</td>';
		html += '<td>' + data.planSubject + '</td>';
		html += "</tr>";
	}
	console.log(html);
	$("#planListTb").append(html);
}

function selectMemoList(memoList){
	var html = '';
	for(var i=0; i<memoList.length; i++){
		var data = memoList[i];
		html += '<tr>';
		html += '<td style="display: none;">' + data.memoNum + '</td>';
		html += '<td>' + data.memoCreatDt + '</td>';
		html += '<td>' + data.memoSubject + '</td>';
		html += "</tr>";
	}
	$("#memoListTb").append(html);
}
</script>

<body>
<div class="body-container" style="width: 900px; height: 600px; padding-top: 80px; padding-bottom: 80px;">
	<div style="width: 60%; height: 100%; float: left;">
		<ul>
			<li class="boardTitle">
			   <span class="leftPadding"> TO DO LIST</span>
				<div id="todoList" style="font-size: 14px; font-weight: 700px; color: #000000; padding: 10px;">
					<table class="table">
						<tbody id="todoListTb">
						</tbody>
					</table>
				</div>
			</li>
		</ul>
		<ul>
			<li class="boardTitle">
			    <span class="leftPadding">  MEMO </span>
				<div id="memoList" style="font-size: 14px; font-weight: 700px; color: #000000; padding: 10px;">
					<table class="table">
						<tbody id="memoListTb">
						</tbody>
					</table>
				</div>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="width: 90%">
			    <span class="leftPadding">  TODAY PLAN </span>
				<div id="planList" style="font-size: 14px; font-weight: 700px; color: #000000; padding: 10px;">
					<table class="table">
						<tbody id="planListTb">
						</tbody>
					</table>
				</div>
			</li>
		</ul>
	</div>
	<div style="width: 40%; height: 100%; float: left;">
		<ul>
			<li class="boardTitle" style="min-width: 340px;">
			     <span class="leftPadding">  WEATHER </span>
			   <p id="tmperature" style="color: #FAD82C; padding-top: 15px;"> </p> 
			   <p id="rain" style="color: #399DCC"> </p> 
			   <p id="wMsg" style="font-family: 'Nanum Barun Gothic', sans-serif;"> </p>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="min-width: 340px;">	
			     <span class="leftPadding">  COVID-19	</span>
			   	  <p id="covidInfo" style="color: red; padding-top: 15px;"></p> <span id="todayCount" style="font-size: 15px; font-weight: 700; color: red;"></span>
				  <p id="cMsg" style="font-family: 'Nanum Barun Gothic', sans-serif;"> </p>
			</li>
		</ul>
	</div>
</div>
</body>