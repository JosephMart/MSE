<%@ LANGUAGE="VBSCRIPT"%>
<html>
<%
PageTitle = "MSE Web Form"
FormProcess = Request.ServerVariables("SCRIPT_NAME")
homeURL="/"

subject=Request("subject")

strUA = Request.ServerVariables("HTTP_USER_AGENT")
If InStr(strUA, "MSIE") Then  'it's a Microsoft Browser
  intVersion = CInt(Mid(strUA, InStr(strUA, "MSIE") + 5, 1)) 
  If intVersion > 3 Then
     isNewIE=True
     textCols=100
  Else
     isNewIE=False	'Is old IE
     textCols=75
  End If
Else
  isNewIE=False	'Is Non-IE
  textCols=75
End If
%>
<head>
<TITLE><%= PageTitle %></TITLE>
<style>
<!--
body  { font-family: arial, helvetica; font-size: 10px }
table { background-color: #cccccc; font-size: 9pt; padding: 3px }
td    { color: #000000; background-color: #cccccc; border-width: 0px }
th    { color: #ffffff; background-color: #0000cc; border-width: 0px }
h2    { font-family: arial, helvetica; font-size: 12pt; font-weight: bold }
a     { font-family: arial, helvetica; font-size: 10px; font-style: normal; line-height: normal; font-variant: normal; text-transform: none; color: yellow; text-decoration: none}
a:hover {color: red}
.smallText { font-family: arial, helvetica; font-size: 10px }
-->
</style>

<script language="javascript">
function menu(n) {
	document.writeln('<p align="center">[ ');
	document.writeln('<a href="<%=homeURL%>" class="SmallLink">Home</a> | <a href="javascript:history.go(-' + n + ');" class="SmallLink">Go Back</a> | <a href="javascript:alert(\'Fill in the required form to send us a question via email.\\n\\nWe will reply to the email address you enter in the form.\');" class="SmallLink">Help</a>');
	document.writeln(' ]</p>');
}
function noBlanks(frmText) {
	var deBlank=frmText.value.replace(/ */gi, '');
	if (frmText.value != deBlank) {
		frmText.value=deBlank;
		alert("Blanks not allowed in email address!");
		frmText.focus();
		return false
	} else {
		return true
	}
}
function isEmail() {
	if ((/\@/.test(document.frm1.email.value)) & (/\./.test(document.frm1.email.value))) {
			return true;
	} else {
		alert("Not a valid email address!");
		document.frm1.email.focus();
		return false;
	}
}
function tooShort(frmText,minLength,strName) {
	var val = frmText.value;
	if (val.length < minLength) {
		alert('Invalid entry for your ' + strName + '!');
		frmText.focus();
		return true;
	} else { 
		return false;
	}
}
function tooLong(frmText,maxLength,strName) {
	var val = frmText.value;
	if (val.length > maxLength) {
		alert('Invalid entry for your ' + strName +'!');
		frmText.focus();
		return true;
	} else {
		return false;
	}
}
function validate() {
	if (!noBlanks(document.frm1.email)) {return false;}
	else { if (!isEmail()) {return false;}
	else { if (tooShort(document.frm1.name,2,'name')) { return false; }
	else { if (tooShort(document.frm1.email,6,'email')) { return false; }
	else { if (tooShort(document.frm1.message,2,'message')) { return false; }
	else { return true; }
	}}}}
}
</script>
</head>
<body bgcolor="#000066" text="#ffffff">
<div align="center"><center>
<form name="frm1" id="oFrm1" method="POST" action="email.asp">
<%
If Request("sendIt")=1 Then
	%>
<script language="javascript">
menu(2);
</script>
<br><br><br>
<!--#include virtual="/cyw/include/errAlert.asp"-->

	<%
	strFrom=Request("name") & " <" & Request("email") & ">"
	strTo="MSE <sales@martinsen.com>"
	strSubj=Request("subject")
	strMsg=Request("message")
	isHTML=false

	If SendEmail(strTo, strFrom, strSubj, strMsg, isHTML) Then
		%>
		<p align="center" class="BigRedText">Your message has been sent!</p><%
	Else
		%><p align="center" class="BigRedText">Error in sending message!</p>
		<br><br><p align="center">Please try sending your message again later.</p><%
	End If
Else
	%>
	<center>[ <a href="<%=homeURL%>">Home</a> | <a href="javascript:history.go(-1);">Go Back
    </a>]
<table border="2" cellpadding="2" cellspacing="2" width="684">
    <tr>
      <th  colspan="2" width="670"><b>MSE Web Mail Form</b></th>
    </tr>
    <tr>
      <td width="46"><b>Name:</b></td>
      <td width="616"><input type="text" name="name" size="32" value="<%=name%>"></td>
    </tr>
    <tr>
      <td width="46"><b>Email:</b></td>
      <td width="616"><input type="text" name="email" size="32" value="<%=email%>">*
        <span class="smallText">Your email address will remain confidential and not shared or sold.</span></td>
    </tr>
    <tr>
      <td width="46"><b>Subject:</b></td>
      <td width="616"><input type="text" name="subject" size="82" value="<%=subject%>"></td>
    </tr>
    <tr>
      <td colspan="2" width="670"><b>Message:</b></td>
    </tr>
    <tr>
      <td colspan="2" width="670"><textarea rows="13" name="message" cols="81"></textarea></td>
    </tr>
    <tr>
      <td colspan="2" align="center" width="670">
        <input type="button" value="Send" name="send" onclick="if(validate()) document.frm1.submit();">&nbsp; 
        <input type="reset" value="Reset" name="reset">
        <input type="hidden" name="h" value="<%=Replace(homeURL,"/.","")%>">
        <input type="hidden" name="sendIt" value="1">
        </td>
    </tr>
  </table>
<div align="center">
	<script language="javascript">
		menu(1);
	</script>
</div>   
<script language="javascript">
if (frm1.name.value=='') { 
	frm1.name.focus();
} else { 
	if (frm1.email.value=='') { 
		frm1.email.focus();
	} else { 
		if (frm1.subject.value=='') {
			frm1.subject.focus()
		} else { 
			frm1.message.focus()
		}
	}
}
    </script>
  
<% End If %>
</form>
</body>
</html>