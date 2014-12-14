<%
	if(typeof(_sitedir)!="string")
		var _sitedir = "/new_artesoris/";

	var _url = Request.ServerVariables("URL").Item;
	var _url = _url.substring(_sitedir.length,_url.length);
	
%>
