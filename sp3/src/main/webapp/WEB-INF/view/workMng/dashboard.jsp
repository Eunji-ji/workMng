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
<meta name="_csrf" content="${_csrf.token}"/>
<title>Insert title here</title>
	
<link rel="stylesheet" href="<%=cp%>/resource/css/style.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/dashboard.css" type="text/css">
<link href='http://www.openhiun.com/hangul/nanumbarungothic.css' rel='stylesheet' type='text/css'>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
<link rel="stlyesheet" href="<%=cp%>/resource/css/font-awesome.min.css" type="text/css">
<style type="text/css">
body {
  font-family: 'Nanum Barun Gothic', sans-serif;
}
.material-symbols-outlined {
  font-variation-settings:
  'FILL' 0,
  'wght' 400,
  'GRAD' 0,
  'opsz' 48
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

function ajaxJSON(url, method, div, param) {
	$.ajax({
		type:method,
		url:url,
		data:param,
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
							var html = "";
							if(data.rain == "0"){
								rain = "비가 오지 않음";
								$("#rain").css("color", "#F1C208");
								html = '<img src="<%=cp%>/resource/images/sunny.png" style="width: 85px; padding: 5px 80px;">';
								$("#apiDivIcon").append(html);
							}else{
								if(data.rain == "2"){
									rain = "눈/비"
								}else if(data.rain == "4"){
									rain = "소나기"
								}else{
									rain = "비"
								}
								html = '<img src="<%=cp%>/resource/images/umbrella.png" style="width: 85px; padding: 5px 80px;">';
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
						var decideCnt = fcNumberFormat(data.decideCnt);

						$("#covidInfo").text('총 확진자 : ' + decideCnt);
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
				if(div === "D"){
					if(data.result == 'success'){
						$("#todoListTb tr").remove();
						$("#planListTb tr").remove();
						$("#memoListTb tr").remove();
						alert("삭제되었습니다.");
						selectList();
					}else{
						alert("삭제가 되지 않았습니다. 다시 시도해주세요.");
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

// 오늘 추가 확진자 수 구하기
function setTodayCovidData(data){
	var decideCnt = data.decideCnt != undefined && data.decideCnt != null ? true : false;
	var beforeDecideCnt = data.beforeDecideCnt != undefined && data.beforeDecideCnt != null ? true : false;
	
	var todayCnt = 0; 
	if(decideCnt && beforeDecideCnt){
		todayCnt = Number(data.decideCnt) - Number(data.beforeDecideCnt);
		todayCnt = fcNumberFormat(todayCnt); 
	}
	return todayCnt;
}

function selectTodoList(todoList){
	var html = '';
	for(var i=0; i<todoList.length; i++){
		var data = todoList[i];
		html += '<tr>';
		html += '<td style="display: none;">' + data.toDoNum + '</td>';
		html += '<td style="padding-right: 5px;"> <input type="checkbox" id='+data.toDoNum+'> </td>';
		if(data.importance == 'Y'){
			html += '<td> <i class="fas fa-star" style="color:#EDD03F; padding: 0 	5px"></i> </td>';
		}else{
			html += '<td> <i class="far fa-star" style="color:#EDD03F; padding: 0 5px"></i> </td>';	
		}
		/* html += '<td>' + data.todoCreatDt + '</td>'; */
		html += '<td id="todoSubject">' + data.todoSubject + '</td>';
		html += '<td style="min-width: 40px;"><input type="button" value="삭제" class="deleteBtn" id="deleteTodoBtn"></td>';
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
		html += '<td style="width:145px; color: #3799F3; padding: 0 5px">' + data.planTm + '</td>';
		html += '<td align="left" style="min-width: 40px;">' + data.planSubject + '</td>';
		html += '<td style="min-width: 40px;"><input type="button" value="삭제" class="deleteBtn" id="deletePlanBtn"></td>';
		html += "</tr>";
	}
	$("#planListTb").append(html);
}

function selectMemoList(memoList){
	var html = '';
	for(var i=0; i<memoList.length; i++){
		var data = memoList[i];
		var url = "<%=cp%>/workMng/selectMemoContents?memoNum=";
		url += data.memoNum;
		html += '<tr>';
		html += '<td style="display: none;">' + data.memoNum + '</td>';
		/* html += '<td>' + data.memoCreatDt + '</td>'; */
		html += '<td> <a href="'+url +'">' + data.memoSubject + '</td> </a>';
		html += '<td style="min-width: 40px;"><input type="button" value="삭제" class="deleteBtn" id="deleteMemoBtn"></td>';
		html += "</tr>";
	}
	$("#memoListTb").append(html);
}

$(document).on("click", "#deleteTodoBtn", function(){
	if(confirm("삭제하시겠습니까?")){
		var checkBtn = $(this);
		var tr = checkBtn.parent().parent();
		var td = tr.children();
		var no = td.eq(0).text();
		var param = {num : no, saveDiv : "T"};
		url = "<%=cp%>/workMng/deleteList";
		console.log(no);
		ajaxJSON(url,"post", "D", param);
	}
});

$(document).on("click", "#deletePlanBtn", function(){
	if(confirm("삭제하시겠습니까?")){
		var checkBtn = $(this);
		var tr = checkBtn.parent().parent();
		var td = tr.children();
		var no = td.eq(0).text();
		var param = {num : no, saveDiv : "P"};
		url = "<%=cp%>/workMng/deleteList";
		ajaxJSON(url,"post", "D", param);
	}
});

$(document).on("click", "#deleteMemoBtn", function(){
	if(confirm("삭제하시겠습니까?")){
		var checkBtn = $(this);
		var tr = checkBtn.parent().parent();
		var td = tr.children();
		var no = td.eq(0).text();
		var param = {num : no, saveDiv : "M"};
		url = "<%=cp%>/workMng/deleteList";
		ajaxJSON(url,"post", "D", param);
	}
});

function selectList(){
	// list 출력 
	var url3 ="<%=cp%>/workMng/selectList";
	ajaxJSON(url3,"post", "L");
}; 

function fcNumberFormat(value){
	return value.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
};

/* let ul = document.querySelector('ul');
const checkClick = (i) => {
   if(ul.children[i].querySelector('td').style.textDecorationLine === "line-through"){
      ul.children[i].querySelector('td').style.textDecorationLine = '';
   } else {
      ul.children[i].querySelector('td').style.textDecorationLine = "line-through"
   }
}

for(let i = 0; i < ul.childElementCount; i++){
   ul.children[i].querySelector('input').value = i
   ul.children[i].querySelector('input').setAttribute('onClick', `checkClick(${i})`);
} */
</script>

<body>
<div class="body-container" style="width: 930px; height: 600px; margin-top: 40px; margin-bottom: 40px; background: #F8F8F8; border-radius: 27px; padding: 30px 20px">
	<div style="width: 60%; height: 100%; float: left;">
		<ul>
			<li class="boardTitle">
			   <span class="leftPadding"> TO DO LIST <a href="javascript:location.href='<%=cp%>/workMng/createTodoList';"><i class="far fa-edit" style="color: #03324F"></i></a></span> 
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
			    <span class="leftPadding">  MEMO <a href="javascript:location.href='<%=cp%>/workMng/createMemoList';"><i class="far fa-edit" style="color: #03324F"></i></a></span>
				<div id="memoList" style="font-size: 14px; font-weight: 700px; color: #000000; padding: 10px;">
					<table class="table">
						<tbody id="memoListTb">
						</tbody>
					</table>
				</div>
			</li>
		</ul>
		<ul>
			<li class="boardTitle" style="width: 93%; padding-top: 20px;">
			    <span class="leftPadding">  TODAY PLAN <a href="javascript:location.href='<%=cp%>/workMng/createPlanList';"><i class="far fa-edit" style="color: #03324F"></i></a></span>
				<div id="planList" style="font-size: 14px; font-weight: 700px; color: #000000; padding: 10px;">
					<table class="table">
						<tbody id="planListTb">
						</tbody>
					</table>
				</div>
			</li>
		</ul>
	</div>
	<div class="apiDiv">
		<ul>
			<li class="boardTitle">
			     <span class="leftPadding">  WEATHER </span>
			   <div id="apiDivIcon">
			   </div>
			   <div id="tmpArea" class="tmpArea">
				   <p id="tmperature" style="color: #FAD82C; padding-top: 15px;"> </p> 
				   <p id="rain" style="color: #399DCC"> </p> 
				   <p id="wMsg" style="font-family: 'Nanum Barun Gothic', sans-serif;"> </p>
			   </div>
			</li>
		</ul>
		<ul>
			<li class="boardTitle">	
			     <span class="leftPadding">  COVID-19	</span>
				     <img src='<%=cp%>/resource/images/covid.png' style="width: 70px; padding: 15px 80px;">
			    <div id="tmpArea" class="tmpArea">
			   	  <p id="covidInfo" style="color: red; padding-top: 15px;"></p> <span id="todayCount" style="font-size: 15px; font-weight: 700; color: red;"></span>
				  <p id="cMsg" style="font-family: 'Nanum Barun Gothic', sans-serif;"> </p>
				</div>
			</li>
		</ul>
	</div>
</div>
</body>