<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<script type="text/javascript">
// clone을 사용하는 경우
$(function(){
	$("form input[name=upload]").change(function(){
		if(! $(this).val()) return;
		
		var b=false;
		$("form input[name=upload]").each(function(){
			if(! $(this).val()) {
				b=true;
				return;
			}
		});
		if(b) return false;
			
		var $tr = $(this).closest("tr").clone(true); // 이벤트도 복제
		$tr.find("input").val("");
		$("#tb").append($tr);
	});
});

</script>

<script type="text/javascript">
    function sendOk() {
        var f = document.noticeForm;

    	var str = f.memoSubject.value;
        if(!str) {
            alert("제목을 입력하세요. ");
            f.memoSubject.focus();
            return;
        }
    	f.action="<%=cp%>/workMng/insertList";
        f.submit();
    }
</script>

<div class="body-container" style="width: 700px;">
    <div class="body-title">
        <h3><i class="far fa-clipboard"></i> TO DO LIST </h3>
    </div>
    
    <div>
			<form name="noticeForm" method="post" enctype="multipart/form-data">
			  <input type="hidden" name="saveDiv" value="M">
			  <table style="width: 100%; margin: 20px auto 0px; border-spacing: 0px; border-collapse: collapse;">
				  <tbody id="tb">
					  <tr align="left" height="40" style="border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc;"> 
					      <td width="100" bgcolor="#eeeeee" style="text-align: center;">제&nbsp;&nbsp;&nbsp;&nbsp;목</td>
					      <td style="padding-left:10px;"> 
					        <input type="text" name="memoSubject" maxlength="100" class="boxTF" style="width: 95%;" value="${dto.subject}">
					      </td>
					  </tr>
	
					  <tr align="left" height="40" style="border-bottom: 1px solid #cccccc;"> 
					      <td width="100" bgcolor="#eeeeee" style="text-align: center;">작성자</td>
					      <td style="padding-left:10px;"> 
					          ${sessionScope.member.userName}
					      </td>
					  </tr>
					  <tr style="border-bottom: 1px solid #cccccc;"> 
					      <td width="100" bgcolor="#eeeeee" style="padding-top:5px; text-align: center;" valign="top">내&nbsp;&nbsp;&nbsp;용</td>
					      <td valign="top" style="padding:5px 0px 5px 10px;" align="left"> 
					        <textarea name="memoContent" id="content" cols="72" class="boxTA" style="width:97%; height: 70px;"></textarea>
					      </td>
					  </tr>

	              </tbody>
			  </table>
			
			  <table style="width: 100%; margin: 0px auto; border-spacing: 0px;">
			     <tr height="45"> 
			      <td align="center" >
			        <button type="button" class="btn" onclick="sendOk();">등록하기</button>
			        <button type="reset" class="btn">다시입력</button>
			        <button type="button" class="btn" onclick="javascript:location.href='<%=cp%>/workMng/dashboard';">등록취소</button>
			      </td>
			    </tr>
			  </table>
			</form>
    </div>
    
</div>