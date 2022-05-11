<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<script type="text/javascript">
function deleteBoard() {
<c:if test="${sessionScope.member.userId=='admin' || sessionScope.member.userId==dto.userId}">
	var q = "num=${dto.num}&${query}";
	var url = "<%=cp%>/bbs/delete?" + q;

	if(confirm("위 자료를 삭제 하시 겠습니까 ? ")) {
			location.href=url;
	}
</c:if>

<c:if test="${sessionScope.member.userId!='admin' && sessionScope.member.userId!=dto.userId}">
	alert("게시물을 삭제할 수  없습니다.");
</c:if>
}

function updateBoard() {
<c:if test="${sessionScope.member.userId==dto.userId}">
	var q = "num=${dto.num}&page=${page}";
	var url = "<%=cp%>/bbs/update?" + q;

	location.href=url;
</c:if>

<c:if test="${sessionScope.member.userId!=dto.userId}">
	alert("게시물을 수정할 수  없습니다.");
</c:if>
}
</script>

<script>
function login() {
	location.href="<%=cp%>/member/login";
}

function ajaxJSON(url, method, query, fn) {
	$.ajax({
		type:method,
		url:url,
		data:query,
		dataType:"json",
		success:function(data) {
			fn(data);
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

function ajaxHTML(url, method, query, selector) {
	$.ajax({
		type:method,
		url:url,
		data:query,
		success:function(data) {
			$(selector).html(data);
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

//게시글 공감 
$(function() {
	$(".btnSendBoardLike").click(function() {
		var url ="<%=cp%>/bbs/insertBoardLike";
		var n = "${dto.num}";
		var query={num:n};
		
		
		if(! confirm("게시물에 공감하십니까?")) {
			return false;
		}
		
		var fn = function(data) {
			var state = data.state;
			if(state=="false"){
				alert("게시글의 공감은 한 번만 가능합니다.");
				return
			}
			
			var count = data.boardLikeCount;
			$("#boardLikeCount").text(count);
		}
		
		ajaxJSON(url,"post",query, fn);
		
	});
});




// 댓글 리스트, 페이징 처리
$(function(){
	listPage(1);
});
function listPage(page) {
	var url="<%=cp%>/bbs/listReply";
	var query="num=${dto.num}&pageNo="+page;
	var selector="#listReply";
	
	ajaxHTML(url, "get", query, selector);
}


// 댓글 등록
$(function(){
	$(".btnSendReply").click(function(){
		var num = "${dto.num}";
		var $ta = $(this).closest("table").find("textarea");
		var content = $ta.val().trim();
		if(! content) {
			$ta.focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url="<%=cp%>/bbs/insertReply";
		var query="num="+num+"&content="+content+"&answer=0";
		var fn = function(data) {
			var state = data.state;
			if(state=="false") {
				alert("댓글을 추가하지 못했습니다.");
				return false;
			}
			
			$ta.val("");
			listPage(1);
		}
		
		ajaxJSON(url, "post", query, fn);		
	});
});


//댓글 좋아요 싫어요 
$(function() {
	$("body").on("click",".btnSendReplyLike", function() {
		var replyNum = $(this).attr("data-replyNum");
		var replyLike=$(this).attr("data-replyLike");
		var $btn=$(this);
		
		var msg = "게시물이 마음에 들지 않으십니까 ?";
		if(replyLike==1){
			msg="게시물에 공감하십니까?";
		}
		
		if(! confirm(msg)){
			return false;
		}
		
		var url ="<%=cp%>/bbs/insertReplyLike";
		var query="replyNum="+replyNum+"&replyLike="+replyLike;
		var fn = function(data){
			var state =data.state;
			if(state=="true"){
				var likeCount =data.likeCount;
				var disLikeCount=data.disLikeCount;
				
				$btn.parent("td").children().eq(0).find("span").html(likeCount); 
				$btn.parent("td").children().eq(0).find("span").html(disLikeCount); 
			}else{
				alert("게시물 공감 여부는 한 번만 가능합니다.");
			}
		};
		ajaxJSON(url, "post", query, fn);
		
	});
});



//댓글별 답글 리스트 
function listReplyAnswer(answer) {
	var url="<%=cp%>/bbs/listReplyAnswer";
	var query = {answer:answer};
	var selector="#listReplyAnswer"+answer;
	ajaxHTML(url,"get",query,selector);
}


//댓글별 답글 개수 
function countReplyAnswer(answer) {
	var url ="<%=cp%>/bbs/countReplyAnswer";
	var query = {answer:answer};
	
	var fn = function(data) {
		var count = data.count;
		var seletor = "#answerCount"+answer;
		$(seletor).text(count);
	};
	ajaxJSON(url,"post", query, fn);
}



//답글 버튼 : 댓글별 답글 폼, 댓글별 답글 리스트 출력 
$(function() {
	$("body").on("click",".btnReplyAnswerLayout", function() {
		//	   └ on 사용하지 않으면 동적 데이터 처리 불가
		var $trAnswer = $(this).closest("tr").next();
		var isVisible = $trAnswer.is(":visible");
		var replyNum = $(this).attr("data-replyNum");
		
		if(isVisible){
			$trAnswer.hide();
		}else {
			$trAnswer.show();
			
			
			//답글 리스트 
			listReplyAnswer(replyNum);
			
			
			//답글 개수
			countReplyAnswer(replyNum);
		}
		
	});
});



//댓글별 답글 등록 
$(function() {
	$("body").on("click",".btnSendReplyAnswer", function() {
		var num = "${dto.num}";
		var replyNum = $(this).attr("data-replyNum");
		var $td=$(this).closest("td");
		var content=$td.find("textarea").val().trim();
		if(! content){
			$td.find("textarea").focus();
			return false;
		}
		content=encodeURIComponent(content);
		var url = "<%=cp%>/bbs/insertReply";
		var query = "num="+num+"&content="+content+"&answer="+replyNum;
												// └ 아버지가 답글, replyNum은 answer에 담아야함 
		var fn = function(data) {
			$td.find("textarea").val("");
			
			var state=data.state;
			if(state=="true"){
				//댓글의 답글 리스트
				listReplyAnswer(replyNum);
				//댓글의 답글 개수
				countReplyAnswer(replyNum);
			}
		}
		
		ajaxJSON(url,"post", query, fn);
	});
});



// 댓글 삭제
$(function() {
	$("body").on("click",".deleteReply", function() {
		if(! confirm("게시글을 삭제 하시겠습니까?")){
			return false;
		}
		
		var replyNum = $(this).attr("data-replyNum");
		var page = $(this).attr("data-pageNo");
		
		var url = "<%=cp%>/bbs/deleteReply";
		var query = "replyNum="+replyNum+"&mode=reply";
		var fn = function(data) {
			listPage(page);
		};
		ajaxJSON(url,"post", query, fn);
	});
});


// 답글 삭제 
$(function() {
	$("body").on("click", ".deleteReplyAnswer", function() {
		if(! confirm("게시글을 삭제하시겠습니까?")){
			return false;
		}
		
		var replyNum = $(this).attr("data-replyNum");
		var answer = $(this).attr("data-answer");
		
		var url = "<%=cp%>/bbs/deleteReply";
		var query = "replyNum="+replyNum+"&mode=answer";
		
		var fn =function(data){
			listReplyAnswer(answer);
			countReplyAnswer(answer);
		};
		ajaxJSON(url, "post", query, fn);
		
	});
});





</script>

<div class="body-container" style="width: 700px;">
    <div class="body-title">
        <h3><i class="fas fa-chalkboard"></i> 게시판 </h3>
    </div>
    
    <div>
			<table style="width: 100%; margin: 20px auto 0px; border-spacing: 0px; border-collapse: collapse;">
			<tr height="35" style="border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc;">
			    <td colspan="2" align="center">
				   ${dto.subject}
			    </td>
			</tr>
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td width="50%" align="left" style="padding-left: 5px;">
			       이름 : ${dto.userName}
			    </td>
			    <td width="50%" align="right" style="padding-right: 5px;">
			        ${dto.created} | 조회 ${dto.hitCount}
			    </td>
			</tr>
			
			<tr>
			  <td colspan="2" align="left" style="padding: 10px 5px;  valign=top; height=200px;">
			      ${dto.content}
			   </td>
			</tr>
			
			<tr style="border-bottom: 1px solid #ccc;">
				<td colspan="2" height="40" align="center" style="padding-bottom: 15px">
					<button type="button" class="btn btnSendBoardLike" title="좋아요"><i class="fas fa-hand-point-up"></i>&nbsp;&nbsp;<span id="boardLikeCount">${dto.boardLikeCount}</span> </button>
				</td>
			
			</tr>
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td colspan="2" align="left" style="padding-left: 5px;">
			       첨&nbsp;&nbsp;부 :
		           <c:if test="${not empty dto.saveFilename}">
		                   <a href="<%=cp%>/bbs/download?num=${dto.num}">${dto.originalFilename}</a>
		           </c:if>
			    </td>
			</tr>
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td colspan="2" align="left" style="padding-left: 5px;">
			       이전글 :
			         <c:if test="${not empty preReadDto}">
			              <a href="<%=cp%>/bbs/article?${query}&num=${preReadDto.num}">${preReadDto.subject}</a>
			        </c:if>
			    </td>
			</tr>
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td colspan="2" align="left" style="padding-left: 5px;">
			       다음글 :
			         <c:if test="${not empty nextReadDto}">
			              <a href="<%=cp%>/bbs/article?${query}&num=${nextReadDto.num}">${nextReadDto.subject}</a>
			        </c:if>
			    </td>
			</tr>
			</table>
			
			<table style="width: 100%; margin: 0px auto 20px; border-spacing: 0px;">
			<tr height="45">
			    <td width="300" align="left">
			       <c:if test="${sessionScope.member.userId==dto.userId}">				    
			          <button type="button" class="btn" onclick="updateBoard();">수정</button>
			       </c:if>
			       <c:if test="${sessionScope.member.userId==dto.userId || sessionScope.member.userId=='admin'}">				    
			          <button type="button" class="btn" onclick="deleteBoard();">삭제</button>
			       </c:if>
			    </td>
			
			    <td align="right">
			        <button type="button" class="btn" onclick="javascript:location.href='<%=cp%>/bbs/list?${query}';">리스트</button>
			    </td>
			</tr>
			</table>
    </div>
    
    <div>
		<table style='width: 100%; margin: 15px auto 0px; border-spacing: 0px;'>
			<tr height='30'> 
				 <td align='left' >
				 	<span style='font-weight: bold;' >댓글쓰기</span><span> - 타인을 비방하거나 개인정보를 유출하는 글의 게시를 삼가 주세요.</span>
				 </td>
			</tr>
			<tr>
			   	<td style='padding:5px 5px 0px;'>
					<textarea class='boxTA' style='width:99%; height: 70px;'></textarea>
			    </td>
			</tr>
			<tr>
			   <td align='right'>
			        <button type='button' class='btn btnSendReply' style='padding:10px 20px;'>댓글 등록</button>
			    </td>
			 </tr>
		</table>
		     
		<div id="listReply"></div>
    
    </div>
    
</div>
