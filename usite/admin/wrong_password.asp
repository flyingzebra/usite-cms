<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../languages/admin.asp" -->
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<html>
<head>
	<style type="text/css" media="screen">@import "../css/aesm_layout.css";</style>
	<style type="text/css" media="screen">@import "../css/topnav.css";</style>
	<style type="text/css" media="screen">@import "../css/sidenav.css";</style>
</head>
<body>
<table cellspacing="0" cellpadding="0">
<tr>
	<td valign="top" width="570">
	<table cellspacing=0 cellpadding=0>
	<tr>
		<td><img SRC="../images/spc.gif" border="0" WIDTH="331" HEIGHT="400"></td>
		<td align=center class=body>
		<small>
		<br><br>
		<%=_T["admin_wrongpassword"]%>
		<br>
		<br>
		<a href="<%=Request.ServerVariables("HTTP_REFERER")%>" style=color:#765><%=_T["admin_clickhere"]%></a>
		</small>
		</td>
	</tr>
	</table>
	</td>
	<td valign="top" width="300" class="body">

	</td>
</tr>
</table>
</body>
</html>
