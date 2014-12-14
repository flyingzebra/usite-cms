<%@ Language=JavaScript %>

<HTML>
<head>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
<BODY topmargin=0 leftmargin=0 bottommargin=0 rightmargin=0>
<form name=main method=post>

<%

if(Request.Form("sub").Item=="Encode")
{
	var inp = Request.Form("inp").Item;
	var out = inp?escape(inp):"";
}

if(Request.Form("sub").Item=="Decode")
{
	var inp = Request.Form("inp").Item;
	var out = inp?unescape(inp):"";
}


%>

<center>

<textarea name=inp style=width:600;height:200><%=inp%></textarea><br>

<textarea name=out style=width:600;height:200><%=out%></textarea><br>

<input name=sub type=submit value=Encode>&nbsp;&nbsp;&nbsp;<input name=sub type=submit value=Decode>

</center>

</form>
</BODY>
</HTML>