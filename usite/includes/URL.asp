<%	
	if(typeof(_sitedir)!="string")
		var _sitedir = "";
		
	var _url = new String(Request.RawUrl)
	_url = _url.substring(_sitedir.length,_url.length);
	var _host = Request.ServerVariables["SERVER_NAME"];

%>
