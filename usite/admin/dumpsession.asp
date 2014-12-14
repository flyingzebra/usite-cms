<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<HTML>
<body>
	<%	
		var con	= Session("con");
		var lng	= Session("_language");
		var uid = Session("uid");
		var uidcrc = Session("uidcrc");
		
		Response.Write(con+"<br>");
		Response.Write(lng+"<br>");
		Response.Write(uid+"<br>");
		Response.Write(uidcrc+"<br>");
		
	%>
</body>
</HTML>
