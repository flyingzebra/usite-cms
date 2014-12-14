<%
	var bDebug		= false;
	var _notify		= "e-e-c-@pandora.be";

	var _host		= Request.ServerVariables("HTTP_HOST").Item;
	var _url		= Request.ServerVariables("URL").Item;
	var _urlarr		= _url.split("/");
	var _proj		= _urlarr[1];
	var _dir		= _urlarr[2];
	var _language	= _urlarr[2].substring(_urlarr[2].lastIndexOf("_")+1,_urlarr[2].length);
	var _isolanguage= _language.substring(0,2)+"-"+_language.substring(3,5);
	var _ws			= _urlarr[2].substring(0,_urlarr[2].lastIndexOf("_")<0?_urlarr[2].length:_urlarr[2].lastIndexOf("_"));
	var _page		= _urlarr[3];
	
	var npos = _page.lastIndexOf(".");
	var _pagename = npos>0?_page.substring(0,npos):_page;
	var _pageext  = npos>0?_page.substring(npos,_page.length):"";
	var _urlpart = _page.substring(0,_page.lastIndexOf("_"));

	var _app_db_prefix = "usite_";
	var bSplitLanguages  = false;
	if(typeof(_db_prefix)!="string")
		var _db_prefix = _app_db_prefix+(bSplitLanguages?(_language+"_"):"");	
%>
<!--#INCLUDE file = "../includes/GUI.asp" -->
<!--#INCLUDE file = "../includes/DB.asp" -->

<%
	// TEMPLATE & PAGE LOADER


	
	var _oDB		= new DB();		// database object from DB.asp
	_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	_oDB.getSettings(_oDB.oCO.ConnectString);
	var _oGUI		= new GUI();

	_txtarr = new Array()

	var _bodytext  = _txtarr[0];
	var _templtext = _txtarr[1]; 

	// READ THE AVAILABLE FIELD NAMES
	var _tmplfld = new Array();

	// INDEXING & INITIALISING
	var a_enumfld  = new Array();
	var _templdat = new Array();
	
	for(var i=0;i<_tmplfld.length;i++)
	{
		_templdat[i] = "";
		a_enumfld[_tmplfld[i]] = i;
	}
	
	// DISPLAY ALL THE TEMPLATE ELEMENTS IN DEBUG MODE
	if(bDebug)
		Response.Write(_tmplfld);


%>

