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
<style type="text/css">
.title {
	font-weight: bold;
	font-size:13pt;
	margin-bottom:10px;
	font-family: 나눔고딕, "맑은 고딕", 돋움, sans-serif;
}
</style>

<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery.min.js"></script>
<script type="text/javascript">

</script>

</head>
<body>
<div style="width: 600px; margin: 30px auto 10px;">
<table style="width: 100%; border-spacing: 0px;">
<tr height="40">
	<td align="left" class="title">
		| 방명록
	</td>
</tr>
</table>

<form name="guestForm">
  <table style="width: 100%; border-spacing: 0px; border-collapse: collapse;">
  <tr height="40" style="border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc;"> 
      <td width="100" bgcolor="#eeeeee" style="text-align: center;">작성자</td>
      <td style="padding-left:10px;" align="left"> 
        <input type="text" name="name" id="name" size="35" maxlength="20" class="boxTF">
      </td>
  </tr>
  
  <tr style="border-bottom: 1px solid #cccccc;"> 
      <td width="100" bgcolor="#eeeeee" style="padding-top:5px; text-align: center;" valign="top">내&nbsp;&nbsp;&nbsp;용</td>
      <td valign="top" style="padding:5px 0px 5px 10px;" align="left"> 
        <textarea name="content" id="content" cols="72" class="boxTA" style="width:97%; height: 70px;"></textarea>
      </td>
  </tr>
  </table>

  <table style="width: 100%; margin: 0px auto; border-spacing: 0px;">
     <tr align="right"> 
      <td height="45">
          <button type="button" id="btnSend" class="btn">등록하기</button>
          <button type="reset" class="btn">다시입력</button>
      </td>
    </tr>
  </table>
</form>

<div id="listGuest" style="width:100%;">
	<table style="width: 100%; margin: 15px auto 10px; table-layout:fixed; word-break:break-all; border-spacing: 0; border-collapse: collapse;">
		<thead>
			<tr height="35">
				<td width="50%">
					<span style="color: #3EA9CD; font-weight: 700;">방명록</span>
					<span>[목록]</span>
				</td>
				<td width="50%">&nbsp;</td>
			</tr>
		</thead>
		<tbody id="listGuestBody"></tbody>
	</table>
</div>

</div>

</body>
</html>