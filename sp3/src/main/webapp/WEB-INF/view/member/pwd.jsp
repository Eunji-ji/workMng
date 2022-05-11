<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<style type="text/css">
.lbl {
   position:absolute; 
   margin-left:15px; margin-top: 17px;
   color: #999999; font-size: 11pt;
}
.loginTF {
  width: 340px; height: 35px;
  padding: 5px;
  padding-left: 15px;
  border:1px solid #999999;
  color:#333333;
  margin-top:5px; margin-bottom:5px;
  font-size:14px;
  border-radius:4px;
}
</style>
<script type="text/javascript">
	function bgLabel(ob, id) {
	    if(!ob.value) {
		    document.getElementById(id).style.display="";
	    } else {
		    document.getElementById(id).style.display="none";
	    }
	}

	function sendOk() {
        var f = document.pwdForm;

        var str = f.userPwd.value;
        if(!str) {
            alert("\n패스워드를 입력하세요. ");
            f.userPwd.focus();
            return;
        }

        f.action = "<%=cp%>/member/pwd";
        f.submit();
	}
</script>

<div class="body-container">
    <div style="width:420px; margin: 0px auto; padding-top:90px;">
	
    	<div style="text-align: center;">
        	<span style="font-weight: bold; font-size:27px; color: #424951;">패스워드 재확인</span>
        </div>
	
		<form name="pwdForm" method="post" action="">
		  <table style="width:100%; margin: 20px auto; padding:30px;  border-collapse: collapse; border: 1px solid #DAD9FF;">
		  <tr style="height:50px;"> 
		      <td style="padding-left: 30px; text-align: left;">
		          정보보호를 위해 패스워드를 다시 한 번 입력해주세요.
		      </td>
		  </tr>

		  <tr style="height:60px;" align="center"> 
		      <td> 
		        &nbsp;
		        <input type="text" name="userId" class="loginTF" maxlength="15"
		                   tabindex="1"
		                   value="${sessionScope.member.userId}"
                           readonly="readonly">
		           &nbsp;
		      </td>
		  </tr>
		  <tr align="center" height="60"> 
		      <td>
		        &nbsp;
		        <label for="userPwd" id="lblUserPwd" class="lbl" >패스워드</label>
		        <input type="password" name="userPwd" id="userPwd" class="loginTF" maxlength="20" 
		                   tabindex="2"
                           onfocus="document.getElementById('lblUserPwd').style.display='none';"
                           onblur="bgLabel(this, 'lblUserPwd');">
		        &nbsp;
		      </td>
		  </tr>
		  <tr align="center" height="65" > 
		      <td>
		        &nbsp;
		        <button type="button" onclick="sendOk();" class="btnConfirm">확인</button>
				<input type="hidden" name="mode" value="${mode}">
		        &nbsp;
		      </td>
		  </tr>
		  <tr align="center" height="10" > 
		      <td>&nbsp;</td>
		  </tr>
	    </table>
		</form>
		           
	    <table style="width:100%; margin: 10px auto 0; border-collapse: collapse;">
		  <tr align="center" height="30" >
		    	<td><span style="color: blue;">${message}</span></td>
		  </tr>
		</table>
	</div>
</div>