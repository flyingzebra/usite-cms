<%@ Language=JavaScript %>
<%
	var url = Request.QueryString("url").Item;
	var adminurl = Request.QueryString("adminurl").Item;
	//Response.Write(url);
	//Response.Write("../"+Session("_language")+"/"+adminurl);
	//Response.Flush();
	if(url)
		Response.Redirect(url);
	if(adminurl)
		Response.Redirect("../"+Session("_language")+"/"+adminurl);
%>