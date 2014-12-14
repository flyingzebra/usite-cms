<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->

<%
	Session("uid") = "";
	var url = Request.QueryString("url").Item;
	var adminurl = Request.QueryString("adminurl").Item;

	if(url)
		Response.Redirect(url);
	if(adminurl)
		Response.Redirect("../"+Session("dir")+"/"+adminurl);
		
	Response.Redirect("../"+Session("dir")+"/login.asp");
	
%>