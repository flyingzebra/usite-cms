<%@ Language=JavaScript %>
<%

	var bDebug		= false;
	var _host		= Request.ServerVariables("HTTP_HOST").Item;
	var _url		= Request.ServerVariables("URL").Item;
	var _urlarr		= _url.split("/");
	var _proj		= _urlarr[1];
	var _dir		= _urlarr[2];
	var _language	= _urlarr[2].substring(_urlarr[2].lastIndexOf("_")+1,_urlarr[2].length);
	var _isolanguage= _language.substring(0,2)+"-"+_language.substring(3,5);
	var _ws			= _urlarr[2].substring(0,_urlarr[2].lastIndexOf("_"));
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
<!--#INCLUDE file = "../languages/dutch.asp" -->
<!--#INCLUDE FILE = "../includes/USITE_GUI.asp" -->
<%
	var _oDB		= new DB();		// database object from DB.asp
	_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	_oDB.getSettings(_oDB.oCO.ConnectString);

	var enumfld = new Array();
	var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
	for(var i=tablefld.length-1;i>=0;i--)
		enumfld[tablefld[i]] = i;
	enumfld["subtitle"] = i++;

	var sSQL = "select "+tablefld+" from usite_blackbabyset where ds_rev_id = 659 and ds_data01 = \"http://www."+_host.replace(/www\./,"")+"\"";
	//Response.Write("<!--"+sSQL+"-->");
	//Response.Write(host);
	//Response.End();
	var arr = _oDB.getrows(sSQL);

	Response.Write("<!--\r\n\r\n  "+sSQL+" \r\n\r\n-->");

	if(arr.length==0)
	{
		LangArr = new Array();
		arr[enumfld["ds_header"]] = _host.replace(/www\./,"")
		arr[enumfld["name"]] = _host.replace(/www\./,"")
		var subtitle = "unknown domain name";
	}
	else	
	{
		var sSQL = "select rev_rev from usite_review where rev_rt_typ = 21 and rev_dir_lng = \""+arr[enumfld["ds_title"]]+"\" and rev_pub & 9 = 1 order by rev_pub desc LIMIT 0,1";
		var txt = _oDB.get(sSQL);
		var bSplashFound = !!txt;
		
		if(bSplashFound && (arr[enumfld["ds_pub"]]&9)==1)
		{
			Response.Write(txt);
		}
		else
		{
			var sSQL = "select rd_text from usite_blackbabydetail where rd_ds_id = 659 and rd_dt_id = 9 and rd_recno = "+arr[enumfld["ds_id"]];
			var subtitle = _oDB.get(sSQL);
			var LangArr = arr[enumfld["ds_desc"]].split(" ");	
			
			if(LangArr.length==1 && (arr[enumfld["ds_pub"]]&9)==1)
					Response.Redirect(LangArr[0].replace(/([a-z][a-z])([a-z][a-z])/g,arr[enumfld["ds_data01"]]+"/usite/"+arr[enumfld["ds_title"]]+"_$1$2/index.asp"));
			else
			{
				%>
				<P align=center>&nbsp;</P>
				<P align=center><FONT face="Tahoma, Arial, Helvetica, sans-serif" size=4></FONT>&nbsp;</P>
				<P align=center><FONT face="Tahoma, Arial, Helvetica, sans-serif" size=5><%=arr[enumfld["ds_header"]]%></FONT></P>
				<P align=center><FONT size=4 face="Tahoma, Arial, Helvetica, sans-serif"><%=subtitle%></FONT></P>
				<P align=center><IMG alt="" hspace=0 src="http://www.blackbaby.org/usite/images/potlood.jpg" border=0><br><%=LangArr.join(" ").replace(/([a-z][a-z])([a-z][a-z])/g,"<a href="+arr[enumfld["ds_data01"]]+"/usite/"+arr[enumfld["ds_title"]]+"_$1$2/login.asp><img src=../images/ii_$1.gif border=0></a>")%></P>
				<%				
			}
		}
	}
	Response.End();
%>
