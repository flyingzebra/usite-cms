<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<HTML>
<head>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
<BODY topmargin=0 leftmargin=0 bottommargin=0 rightmargin=0>
<form name=main method=post>

<%

if(Request.Form("sub").Item=="Encode")
{	
	var out = Request.Form("out").Item;
	var inp = out?out.split("&"):new Array();
	for(var i=0;i<inp.length;i++)
		if(inp[i].indexOf("=")>0)
		{
			if(inp[i].split("=")[1].toString().length>0)
			{
				inp[i] = "&"+inp[i].split("=")[0]
			         + "="
					 + inp[i].split("=")[1].encrypt("nicnac")
			}
		}
	inp = inp.join(""); 	
}

if(Request.Form("sub").Item=="Decode")
{
	var inp = Request.Form("inp").Item;
	var out = inp?inp.split("&"):new Array();
	for(var i=0;i<out.length;i++)
		if(out[i].indexOf("=d0")>0)
		{
			if(out[i].split("=")[1].toString().length>0)
			{
				out[i] = "&"+out[i].split("=")[0]
			         + "="
					 + out[i].split("=")[1].decrypt("nicnac")
			}
		}
	out = out.join(""); 
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