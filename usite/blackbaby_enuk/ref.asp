
<%
	var bDebug		= false;
	var bSQLDebug   = false;
	var _notify		= "";

	var _host		= Request.ServerVariables("HTTP_HOST").Item;
	var _url		= Request.ServerVariables("URL").Item;
	var _urlarr		= _url.split("/");
	var _proj		= _urlarr[1];
	var _dir		= _urlarr[2];
	var _language	= _urlarr[2].substring(_urlarr[2].lastIndexOf("_")+1,_urlarr[2].length);
	var _isolanguage= _language.substring(0,2)+"-"+_language.substring(2,4);
	var _rsspath    = "http://www.theartserver.be/theartserver/"+_language+"/";
	var _ws			= _urlarr[2].substring(0,_urlarr[2].lastIndexOf("_"));
	var _page		= _urlarr[3];
	
	var npos      = _page.lastIndexOf(".");
	var _pagename = npos>0?_page.substring(0,npos):_page;
	var _pageext  = npos>0?_page.substring(npos,_page.length):"";
	var _urlpart  = _page.substring(0,_page.lastIndexOf("_"));

	var _app_db_prefix = "usite_";
	var bSplitLanguages  = false;
	if(typeof(_db_prefix)!="string")
		var _db_prefix = _app_db_prefix+(bSplitLanguages?(_language+"_"):"");

	_masterdb = "dataset";
	_detaildb = "datadetail";

%>
<!--#INCLUDE file = "../includes/GUI.asp" -->
<!--#INCLUDE file = "../includes/FORM.asp" -->
<!--#INCLUDE file = "../includes/DB.asp" -->
<!--#INCLUDE file = "inc.asp" -->
<!--#INCLUDE FILE = "../includes/USITE_GUI.asp" -->

<%
	_T["searchbar_names"]			= new Array("press","magazine")
	_T["searchbar_images"]			= new Array("s_press.gif","magazine");


	// TEMPLATE & PAGE LOADER

	var _oDB		= new DB();		// database object from DB.asp
	_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	_oDB.getSettings(_oDB.oCO.ConnectString);
	var _oGUI		= new GUI();
	var oUSITE_GUI  = new USITE_GUI();
	var oMENU		= new oUSITE_GUI.MENU();
	var id			= Request.QueryString("id").Item;
	var rev_rt_cat	= Request.QueryString("P").Item;
	var rev_id 		= id?id.decrypt("nicnac"):"";

	var _ds = Request.QueryString("d").Item;
	_ds = _ds?_ds.toString().decrypt("nicnac"):-1;
	var _dsid = 0;

	function DATA()
	{
		this.itemo = new Array();
		this.parse = DATA_parse;
		this.namecache_data = new Array();
		this.namecache_flds = new Array();
		this.namecache_enum = new Array();
	}
	var oDATA = new DATA();
	
	function DATA_parse(_str)
	{
	   var _tmplfield 	= new Array();
	   var _templdata 	= new Array();
	   var _str_arr 	= _str? _str.split("{_"):new Array();
	   
	   for(var _i=1;_i<_str_arr.length;_i++)
	   {
			var curfield = _str_arr[_i]?_str_arr[_i].substring(0,_str_arr[_i].indexOf("_}")):"";
			_tmplfield[_i] = curfield;
			var curarg   = "";
			
			if(curfield && curfield.indexOf("{")>=0 && curfield.indexOf("}")>=0 && curfield.indexOf("}") > curfield.indexOf("{"))
			{
				curarg   = curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"))
				curfield = curfield.substring(0,curfield.indexOf("{"));
			}
			
			//Response.Write(curfield+"["+curarg+"]="+this.item[curarg]+"<br>")
			
			switch(curfield)
			{
				case "DATA":
					//Response.Write(curfield+" "+curarg+"<br>")
					
					_templdata[_i] = this.itemo[curarg]?this.itemo[curarg]:"";
				break;
				case "FETCHDB_URL":
					var _txt = "";
					var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_dir+"\" and (rev_pub & 8) = 0 and rev_rt_cat = "+curarg+" order by rev_id desc limit 0,1"
					if(curarg && isNaN(Number(curarg))==false)
						var _txt = _oDB.get(sSQL);
					if(_txt)
						_templdata[_i] = escape(HTMLDecode(_txt).replace(/\<[^\>]+\>/g, ""));
				break;
			}
	   }
	   
	   for(var _i=1;_i<_str_arr.length;_i++)
	   {
		   //_str = _str.replace("{_"+_tmplfield[_i]+"_}",_templdata[_i]?_templdata[_i]:("{_"+_tmplfield[_i]+"_}"))
		   _str = _str.replace("{_"+_tmplfield[_i]+"_}",_templdata[_i]?_templdata[_i]:(_tmplfield[_i].indexOf("DATA")==0?"":("{_"+_tmplfield[_i]+"_}")) )
		   Response.Write("_str.replace('{_"+_tmplfield[_i]+"_}',"+(_templdata[_i]?_templdata[_i]:("{_"+_tmplfield[_i].toUpperCase()+"_}"))+"')<br>");
	   }
	 
	   return _str
	}

	function loadXML(_xmlstr)
	{
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM")
		xmlDoc.async="false";
		
		if(_xmlstr)
		{
			xmlDoc.loadXML(_xmlstr)
			if(xmlDoc.parseError.errorCode!=0)
			{
				var txt="Error Code: " + xmlDoc.parseError.errorCode + "\n"
				txt=txt+"Error Reason: " + xmlDoc.parseError.reason
				txt=txt+"Error Line: " + xmlDoc.parseError.line
				xmlDoc.loadXML("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
			}
		}
		return xmlDoc
	}

	function HTMLDecode(strHTML)
	{
	   strHTML = strHTML.replace(/&quot;/g,String.fromCharCode(0x0022));
	   strHTML = strHTML.replace(/&amp;/g,String.fromCharCode(0x0026));
	   strHTML = strHTML.replace(/&lt;/g,String.fromCharCode(0x003c));
	   strHTML = strHTML.replace(/&gt;/g,String.fromCharCode(0x003e));
	   //strHTML = strHTML.replace(/<br>/ig,"\r\n");
	   //strHTML = strHTML.replace(/<p/ig,"\r\n<p");
	   strHTML = strHTML.replace(new RegExp("&"+"nbsp;","g"),String.fromCharCode(0x00a0));
	   return strHTML;
	}

	function argparser(_str)
	{
		var _enum = new Array();
		if(_str)
		{
			if(_str.substring(0,6)=="&quot;")
				_str = _str.substring(6,_str.length-6);
			else
				_str = _str.charAt(0)=="\"" ? _str.substring(1,_str.length-1) : ("id="+_str);
			var _parr = new String(_str).split(/,|=/);

			for(var _i=0;_i<_parr.length;_i+=2)
			{
			   _enum[_parr[_i]] = _enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1];
			   _enum[_i/2] = _parr[_i];
			   if(bDebug)
					Response.Write("_enum["+_parr[_i]+"] = "+(_enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1])+"<br>\r\n")
			}
			if(bDebug)
				Response.Write("<br>("+_str+")<br>");
		}
		return _enum;
	}

	//Response.Write(typeof(bTemplate)+" "+!!bTemplate+"<br>");

	if(typeof(bTemplate)=="undefined")
		var bTemplate = true;
		
	//Response.Write(typeof(bTemplate)+" "+!!bTemplate+"<br>");

	var sSQL = "select rev_rev,rev_header,rev_rt_cat from "+_db_prefix+"review where rev_dir_lng=\""+_dir+"\" and (rev_pub & 1) = 1";
	if(bTemplate)
		sSQL += " and ((rev_rt_typ=16 "+( rev_rt_cat>0?("and (rev_rt_cat="+rev_rt_cat+" or rev_rt_cat=0)"):"")+" "+( rev_id>0?("and rev_id="+rev_id):"")+")";
	else
		sSQL += " and 0 "
	if(id || rev_rt_cat)	
		sSQL += " or  (rev_rt_typ=14 "+( rev_rt_cat>0?("and rev_rt_cat="+rev_rt_cat):"")+" "+( rev_id>0?("and rev_id="+rev_id):"")+")"; 
	else
		sSQL += " or  (rev_rt_typ=14 and (rev_pub & 2) = 2)";
	if(bTemplate)
		sSQL += ")";
	sSQL += " order by rev_rt_typ desc";
	
	if(bDebug)
		Response.Write("<!--\r\n\r\n\r\n\r\n\r\n"+sSQL+"\r\n\r\n\r\n\r\n\r\n-->");
	
	_txtarr = _oDB.getrows(sSQL);

	var _templtext  = _txtarr[0];
	var _tempxmlstr = "<"+"?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n"
					  +"<ROOT xmlns:NBOX=\"http://blackbaby.org/ns/GUI\">\r\n"
					  + _txtarr[1]
					  +"</ROOT>";
	var _bodytext   = _txtarr[3];
	
	//var _bodyxmlstr = "<"+"?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n"
	//				  +"<ROOT xmlns:NBOX=\"http://blackbaby.org/ns/GUI\">\r\n"
	//				  + _txtarr[4]
	//				  +"</ROOT>";	
	
	if(!rev_rt_cat)
		rev_rt_cat = _txtarr[5];

	// PARSE TEMPLATE XML
	var XMLObj = Server.CreateObject("Microsoft.XMLDOM");
	XMLObj.async = "false";
	XMLObj.loadXML(_tempxmlstr);
	var bXMLValid = XMLObj.parseError.errorCode == 0;
	//Response.Write(XMLObj.getElementsByTagName("ROOT").item(0).childNodes[0]+" ")
	//Response.End();
	
	if(bXMLValid && XMLObj.getElementsByTagName("ROOT").item(0).childNodes[0]!=null)
		bXMLValid = XMLObj.getElementsByTagName("ROOT").item(0).childNodes[0].tagName?true:false;

	// READ THE AVAILABLE FIELD NAMES
	var _tmplfld = new Array();
	var arr = _templtext?_templtext.split("{_"):new Array();	// SEARCH FOR FUNCTION CALLS INSIDE TEMPLATE
	var arr2 = _bodytext?_bodytext.split("{_"):new Array();   // SEARCH FOR FUNCTION CALLS INSIDE BODYTEXT
	arr = arr.concat(arr2);
	
	for(var i=1;i<arr.length;i++)
		_tmplfld[i-1] = arr[i].substring(0,arr[i].indexOf("_}"));

	// INDEXING & INITIALISING
	var _enumtmpl  = new Array();
	var _templdat = new Array();
	
	for(var i=0;i<_tmplfld.length;i++)
	{
		_templdat[i] = "";
		_enumtmpl[_tmplfld[i]] = i;
	}

	var _enumextra = new Array();  // ENUMERATE EXTRA TAG NAMES FOR MENU FUNCTIONS
	for(var j=oMENU.enumtypes["rt_name"];j<oMENU.types.length;j+=oMENU.in_interleave)
		_enumextra[oMENU.types[j]] = j;	
		
	// DISPLAY ALL THE TEMPLATE ELEMENTS IN DEBUG MODE
	if(bDebug)
		Response.Write("TEMPLATEFIELDS DETECTED: "+_tmplfld+"<br>");

	if(bDebug)
		Response.Write("<br><br>C U M U L A T I V E   P R O C E S S I N G<br><br>")

	var j=0;
	var itemcount 	= new Array();
	var itemname 	= new Array();
	var itemarg 	= new Array();
	var itemdata 	= new Array();
	var interleave  = new Array();
	
	for(var i=0;i<_tmplfld.length;i++)
	{
		var curfield = _tmplfld[i];
		//if(curfield && curfield.indexOf("{")>=0 && curfield.indexOf("}")>=0 && curfield.indexOf("}") > curfield.indexOf("{"))
		//{
			var name = curfield.substring(0,curfield.indexOf("{"));
			
			if(itemcount[name])
			{
				itemarg[name] += ","+curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"));
				itemcount[name]++;
			}
			else
			{
				itemarg[name] 	 = new Array();
				itemname[i]      = name;
				itemcount[name]  = 1;
				
				itemarg[name] = curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"))
				itemcount[name]++;
				j++;
			}
			
			if(bDebug)
			{
				Response.Write("itemarg['"+name+"'] = "+itemarg[name]+"<br>")
			}
			
		//}
	}
	
	if(bDebug)
		Response.Write("<br>");

	
	for(var i=0;i<_tmplfld.length;i++)
	{
		var curfield = itemname[i];
		
		switch(curfield)
		{
			case "GFXFIFO":
			/*
				var cats = new Array();
				for(var j=0;j<curarg.length;j+=2)
					cats[j] = curarg[j][0];
				
				var sSQL = "select rev_id from "+_db_prefix+"review where rev_pub & 2 = 2 and rev_pub & (1<<15) > 0";
				var arr = _oDB.getrows(sSQL);
				
				_templdat[i] += curarg+"<br>"+sSQL+"<br>";
				for(var j=0;j<curarg.length;j+=2)
				{
					
				}
			*/
			break;
			case "PDFFIFO":
				// this case doesn't use any arguments (all arguments are gathered into itemarg[curfield])
				
				var tablefld = ["rev_id","rev_cropping","rev_date_published"];
				var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_pub & 2 = 2 and rev_pub & (1<<15) > 0 and rev_rt_typ = 20 order by rev_desc desc";
				
				itemdata[curfield] 	= _oDB.getrows(sSQL);
				interleave[name] 	= tablefld.length;
								
				if(bDebug)
					Response.Write("itemdata['"+curfield+"'] = "+itemdata[curfield]+"<br>");
			break;
			
			
		}
	}
	
	if(bDebug)
		Response.Write("<br>");

	if(bDebug)
		Response.Write("<br><br>D I R E C T   P R O C E S S I N G<br><br>");
	
	for(var i=0;i<_tmplfld.length;i++)
	{
		var curfield = _tmplfld[i];
		var curarg   = "";
		if(curfield && curfield.indexOf("{")>=0 && curfield.indexOf("}")>=0 && curfield.indexOf("}") > curfield.indexOf("{"))
		{
			curarg   = curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"));
			curfield = curfield.substring(0,curfield.indexOf("{"));
		}
		
		if(bDebug)
			Response.Write("TAG "+curfield+"<br>");
		
		switch(curfield)
		{
			case "IMGDIR":
				_templdat[i] += "../"+_dir+"/images";
			case "NBSP":
				_templdat[i] += "&nbsp;";
			break;
			case "QUOT":
			    _templdat[i] += "\"";
			break;
			case "RND":
				_templdat[i] += Math.round(Math.random()*100000);
			break;
			case "DIR":
				_templdat[i] += _dir;
			break;
			case "WS":
				_templdat[i] += _ws;
			break;			
			case "LEFT_AREA_SEARCH":
				
				_templdat[_tmplfld[i]] = "";
				
				var panewidth = 220;
				var paneheight = 600;
				var batchpath = "../images/batch/";
				var iiconspath = "../images/";
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				else
				{
					_oGUI.NBOX.param["NBOX:lm"] 		= 48;
					_oGUI.NBOX.param["NBOX:rm"] 		= 186;
					_oGUI.NBOX.param["NBOX:tw"] 		= _oGUI.NBOX.param["NBOX:lm"] + _oGUI.NBOX.param["NBOX:rm"] + 1;
					_oGUI.NBOX.param["NBOX:titlewidth"] = 240;
					_oGUI.NBOX.param["NBOX:bTail"] 		= false;
					_oGUI.NBOX.param["NBOX:leftcaddy"] 	= true;
					_oGUI.NBOX.param["NBOX:rightcaddy"] = false;
					
					_oGUI.NBOX.param["NBOX:dottedline"] = false;
					_oGUI.NBOX.param["NBOX:openbody"]   = true;
					_oGUI.NBOX.param["NBOX:lineheight"] = 33;
				}
				
				// S E A R C H	
				var checkit = "";
				var search =
				"<form method=post action=search.asp name=search>"
				+"<input class=border name=s style=\"width:140px;height:20px\">"
				+"&nbsp;<input type=\"submit\" style=\"font-size:10px;height:20px\" value='"+_T["OK"]+"' onclick=\""+checkit+"\"><br>"
				//+"<a href=# class=small>"+_T["advanced_search"]+" &gt;&gt;</a></div>"				
				+"<table cellspacing=0 cellpadding=0><tr><td></form></td></tr></table>"
				
				_oGUI.NBOX.add(_T["search"],search);
				_oGUI.NBOX.add("","");
				
				_templdat[i] += _oGUI.NBOX.get("","","")
				
				_oGUI.NBOX.param["NBOX:dottedline"] = true;
				_oGUI.NBOX.param["NBOX:openbody"]   = false;
				_oGUI.NBOX.param["NBOX:lineheight"] = 12;	
			break;
			case "LEFT_AREA_INIT":
				_templdat[_tmplfld[i]] = "";
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				_templdat[i] += "\r\n";
			break;			
			case "LEFT_AREA_SUBSCRIBE":
				_templdat[_tmplfld[i]] = "";
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				
				var checkit = "if (document.subscribe('e-mail').value && document.subscribe('e-mail').value.indexOf('@')>0 && document.subscribe('e-mail').value.indexOf('.')>0) document.subscribe.submit(); else alert('"+_T["email_fillin"]+"')";
				
				var newsletter =
				"<form method=post action="+_T["newsletter_url_submit"]+" name=subscribe>"
				+"<div>"+_T["email_fillin"]
				+"<input type=hidden name=language value="+_language+">"
				+(Request.QueryString("p").Item=="1"?("<br><b>"+_T["newsletter_activated"]+"</b>&nbsp;&nbsp;"):"")
				+"<input class=border name=e-mail style=\"width:140px;height:20px\">"
				+"&nbsp;<input type=button style=\"font-size:10px;height:20px\" value='"+_T["OK"]+"' onclick=\""+checkit+"\">"
				//+"<br><a href=11_index.asp class=small>"+_T["newsletter_link"]+" &gt;&gt;</a>"
				+"</div><table cellspacing=0 cellpadding=0><tr><td></form></td></tr></table>"
				//+"<a href=# class=smallgreen>&gt;&gt; Laatste nieuwsbrieven</a>";
				
				_oGUI.NBOX.add("<a href=11_index.asp class=small><img src=\"../images/ii_email2.gif\" alt=\"envelope\" border=0></a>",newsletter);
				_templdat[i] += _oGUI.NBOX.get(batchpath+"t24_"+_T["free_newsletter"]+".png","11_index.asp",_T["free_newsletter_tip"]);
				
			break;
			case "LEFT_AREA_NEWS":
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}
				
				// P E R S B E R I C H T E N		 
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_pub","rev_date_published","rev_header");
				var extraSQL = "order by rev_date_published desc LIMIT 0,5";
				var SQL = "select "+tablefld.join(",")+" from "+(_oGUI.param["dbtable"]?_oGUI.param["dbtable"]:(_app_db_prefix+"press"))+" where (rev_pub & 1) = 1 "+/*"and rev_rt_typ = 10 "+*/ "and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
				
				var overview = _oDB.getrows( SQL );
				var _news = overview;
				var _news_tablefld = tablefld;
				var r = 0;
				for (var j=0; j<overview.length;j+=tablefld.length)
				{
					var relurl = (_oGUI.param["page"]?_oGUI.param["page"]:"press")+"#"+base64encode(overview[j].toString());//"10_detail.asp?id="+overview[j].toString().encrypt("nicnac");
					var linkurl = "http://www.theartserver.be/theartserver/"+_language+"/"+relurl;	
					var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
					var imgurl = "";//<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
					var fromto = "<p class=footnote style=\"text-align:right\">";
					if (typeof(overview[j+7])=="date")				
						fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=\"color:#A0B5BF\">"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
					fromto += "</p>";
					
					var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
					var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
									
					_oGUI.NBOX.add(fromto,imgurl+link+txt);
				}
				//var morexml = "<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
				//var more = "<table align=right><tr><td class=footnote><a href=\""+_T["press_link"]+"\">"+_T["press_view_all"]+"</a></td><td>"+morexml+"</td></tr></table>";
  				//_oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=10_index.asp>cliquez ici</a>");
  				//_oGUI.NBOX.add("",more)
  				
				_templdat[i] += _oGUI.NBOX.get(batchpath+"t24_"+_T["press"]+".png","10_index.asp",_T["press_tip"])
			break;
			
			case "LEFT_AREA_TOP":
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}
				
				// P E R S B E R I C H T E N		 
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_pub","rev_date_published","rev_header");
				var extraSQL = "order by rev_date_published desc LIMIT 0,5";
				var SQL = "select "+tablefld.join(",")+" from "+(_oGUI.param["dbtable"]?_oGUI.param["dbtable"]:(_app_db_prefix+"press"))+" where (rev_pub & 1) = 1 "+/*"and rev_rt_typ = 10 "+*/ "and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
				
				var overview = _oDB.getrows( SQL );
				var _news = overview;
				var _news_tablefld = tablefld;
				var r = 0;
				for (var j=0; j<overview.length;j+=tablefld.length)
				{
					var relurl = (_oGUI.param["page"]?_oGUI.param["page"]:"press")+"#"+base64encode(overview[j].toString());//"10_detail.asp?id="+overview[j].toString().encrypt("nicnac");
					var linkurl = "http://www.theartserver.be/theartserver/"+_language+"/"+relurl;	
					var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
					var imgurl = "";//<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
					var fromto = "<p class=footnote style=\"text-align:right\">";
					if (typeof(overview[j+7])=="date")				
						fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=\"color:#A0B5BF\">"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
					fromto += "</p>";
					
					var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
					var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
									
					_oGUI.NBOX.add(fromto,imgurl+link+txt)	
				}
				//var morexml = "<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
				//var more = "<table align=right><tr><td class=footnote><a href=\""+_T["press_link"]+"\">"+_T["press_view_all"]+"</a></td><td>"+morexml+"</td></tr></table>";
				
  				//_oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=10_index.asp>cliquez ici</a>");
  				//_oGUI.NBOX.add("",more)
  				
				_templdat[i] += _oGUI.NBOX.get(batchpath+"t24_"+_T["press"]+".png","10_index.asp",_T["press_tip"])
			break;			
			
			case "LEFT_AREA_ARTICLES":
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}
				
				// P E R S B E R I C H T E N		 
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_pub","rev_date_published","rev_header");
				var extraSQL = "order by rev_id desc LIMIT 0,5";
				var sSQL = "select "+tablefld.join(",")+" from "+(_oGUI.param["dbtable"]?_oGUI.param["dbtable"]:(_app_db_prefix+"review"))+" where (rev_pub & 1) = 1 and rev_rt_typ = 2 "+extraSQL;
				
				var overview = _oDB.getrows( sSQL );
				var _news = overview;
				var _news_tablefld = tablefld;
				var r = 0;
				for (var j=0; j<overview.length;j+=tablefld.length)
				{
					var relurl = (_oGUI.param["page"]?_oGUI.param["page"]:"articles")+"#"+base64encode(overview[j].toString());//"10_detail.asp?id="+overview[j].toString().encrypt("nicnac");
					var linkurl = "http://www.theartserver.be/theartserver/"+_language+"/"+relurl;	
					var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
					var imgurl = "";//<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
					var fromto = "<p class=footnote style=\"text-align:right\">";
					if (typeof(overview[j+7])=="date")				
						fromto +=   /*new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br>"*/ new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage);	
					fromto += "</p>";
					
					var txt =  overview[j+1]?overview[j+1].substring(0,85):"";		
					var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
									
					_oGUI.NBOX.add(fromto,imgurl+link+txt)	
				}
				//var morexml = "<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
				//var more = "<table align=right><tr><td class=footnote><a href=\""+_T["press_link"]+"\">"+_T["press_view_all"]+"</a></td><td>"+morexml+"</td></tr></table>";
				
  				//_oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=10_index.asp>cliquez ici</a>");
  				//_oGUI.NBOX.add("",more)
				
				_templdat[i] += _oGUI.NBOX.get(batchpath+"t24_"+_T["articles"]+".png","02_index.asp",_T["articles_tip"])
			break;			
			
			
			case "LEFT_AREA_SPONSORS":
				
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}
				
				_oGUI.NBOX.param["NBOX:bTopsegment"] = true;
				
  				_oGUI.NBOX.add(
					"</td><td width=\"181\" style=\"background-color:#FFFBF0;padding-left:5px;padding-right:0px;\"><table align=right><tr><td class=footnote></td><td></td></tr></table></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg3"]+"\" width=5></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg6"]+"\" width=1><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh9"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td></tr></table>"
					+"<table cellspacing=\"0\" cellpadding=\"0\" width=\"241\" class=small><tr><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg5"]+"\" width=\"1\"><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh8"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg1"]+"\"  width=\"43\" style=\"padding-left:0px;padding-right:5px;text-align:right\"></td><td width=\"181\" style=\"background-color:#FFFBF0;padding-left:5px;padding-right:0px;\"><table align=left><tr><td class=small>Met bijzondere dank aan:</td><td></td></tr></table></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg3"]+"\" width=5></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg6"]+"\" width=1><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh9"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td></tr></table>"
					+"<table cellspacing=\"0\" cellpadding=\"0\" width=\"241\" class=small><tr><td bgcolor=\"#B9B9BE\" width=\"1\"><img src=\"../images/spc.gif\" alt=\"decoration\" width=\"1\" height=\"2\"></td><td width=\"10\" style=\"padding-left:0px;padding-right:5px;text-align:right;background-color:#F4F0ED\"></td><td width=\"214\" style=\"padding-left:0px;padding-right:0px;background-color:#FFFBF0\">"
						+"<table cellspacing=\"1\" cellpadding=\"0\" width=203 bgcolor=\"#808080\"><tr><td bgcolor=\"#FFFFFF\">"
							+"<CENTER>"
							+"<img src=\"../images/spc.gif\" height=\"9\" alt=\"decoration\"><br>"
							//+(_oGUI.param["title"]?_oGUI.param["title"]:_T["structuralsponsors_img"])+"<br>"
							+(_oGUI.param["banner"]?_oGUI.param["banner"].split(",").join(""):"")+"<br>"
							//"<a href=http://www.schleiper.com target=_blank><img src=../art-event/images/schleiper_59_42.gif border=0 hspace=1 vspace=1></a><a href=http://www.nobel.be target=_blank><img src=../art-event/images/nobel_59_42.gif border=0 hspace=1 vspace=1></a><a href=http://www.theartserver.be target=_blank><img src=../art-event/images/tas_59_42.gif border=0 hspace=1 vspace=1></a><br>"
							+"<img src=\"../images/spc.gif\" height=\"9\" alt=\"decoration\"><br>"
							+"</CENTER>"
						+"</td></tr></table>"
						
					+"</td><td bgcolor="+_oGUI.NBOX.param["NBOX:bg3"]+" width=5></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg6"]+"\" width=1><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh9"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td></tr></table>"
					+"<table cellspacing=0 cellpadding=0 width=241 class=small><tr><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg5"]+"\" width=\"1\"><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh8"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg1"]+"\" width=\"43\" style=\"padding-left:0px;padding-right:5px;text-align:right\"></td><td width=\"181\" style=\"background-color:#FFFBF0;padding-left:5px;padding-right:0px;\"><table align=right><tr><td class=footnote></td><td></td></tr></table></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg3"]+"\" width=5></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg6"]+"\" width=1><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh9"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td></tr></table>"
					+"<table cellspacing=0 cellpadding=0 width=241 class=small><tr><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg5"]+"\" width=\"1\"><img src=\""+_oGUI.NBOX.param["NBOX:path"]+_oGUI.NBOX.param["NBOX:sh8"]+"\" alt=\"decoration\" width=\"1\" height=\"2\"></td><td bgcolor=\""+_oGUI.NBOX.param["NBOX:bg1"]+"\" width=\"43\" style=\"padding-left:0px;padding-right:5px;text-align:right\">"
				,"");
				_templdat[i] += _oGUI.NBOX.get("","","")
				
				_oGUI.NBOX.param["NBOX:bTopsegment"] = false;
				
			break;
			
			case "SPONSORS":
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}
			
		    _templdat[i] += "<table cellspacing=1 cellpadding=0 "+(_oGUI.param["width"]?("width="+_oGUI.param["width"]):"")+"><tr><td>"
								//+"<CENTER>"
								//+"<img src=\"../images/spc.gif\" height=\"9\" alt=\"decoration\"><br>"
								+(_oGUI.param["banner"]?_oGUI.param["banner"].split(",").join(""):"")
								//"<a href=http://www.schleiper.com target=_blank><img src=../art-event/images/schleiper_59_42.gif border=0 hspace=1 vspace=1></a><a href=http://www.nobel.be target=_blank><img src=../art-event/images/nobel_59_42.gif border=0 hspace=1 vspace=1></a><a href=http://www.theartserver.be target=_blank><img src=../art-event/images/tas_59_42.gif border=0 hspace=1 vspace=1></a><br>"
								//+"<img src=\"../images/spc.gif\" height=\"9\" alt=\"decoration\"><br>"
								//+"</CENTER>"
						 +"</td></tr></table>";
			break;			
			
			case "PDFFIFO":
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
				{
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				}			
				/*
				var pos = 2*itemdata[curfield].length-itemarg[curfield].length*interleave-itemcount[curfield]*interleave				
				_templdat[i] += itemdata[curfield][pos];
				itemcount[curfield]--
				*/
				
				var argarr = curarg?curarg.split(","):"";
				
				var pos = Number(argarr[0]-1)*interleave[curfield];
				
				var txt = argarr[2]?new Date(itemdata[curfield][pos+2]).format(argarr[2].substring(1,argarr[2].length-1),_language.substring(0,2)).toUpperCase().replace(/&NBSP;/g,"&nbsp;"):"";
				var cropsizename = itemdata[curfield][pos+1]?itemdata[curfield][pos+1].split(",")[0].replace(/x/,"_"):"VAR_VAR";
				var linka = argarr[1]?("<a href=pdfindex_Q_P_E_"+argarr[1]+"_A_pdf_E_"+itemdata[curfield][pos]+".asp>"):"";
				var linkb = argarr[1]?"</a>":"";
				
				_templdat[i] += "<span class=small>"+txt+"</span><br>"+box_on()+linka+"<img src=../"+_ws+"/images/img"+zerofill(itemdata[curfield][pos],10)+"_"+cropsizename+".jpg alt='thumbnail of a pdf file'>"+linkb+box_off();
				
			break;
			
			case "LEFT_AREA_QUOTE":
			
				// C I T A T I O N
				
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_date_published","rev_author","rev_header");
				var extraSQL = "order by rev_date_published desc LIMIT 0,1";
				var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"press where (rev_pub & 1) = 1 "+/*"and rev_rt_typ = 10 "+*/ "and rev_rt_cat = 132 and rev_date_published < SYSDATE() "+extraSQL;
				var overview = _oDB.getrows( SQL );
				    
				var r = 0;
				for (var j=0; j<overview.length;j+=tablefld.length)
				{
					var fromto = "";
					if (typeof(overview[j+3])=="date")				
						fromto += "<span class=footnote><b>" + new Date(overview[j+3]).format("%d %b",_isolanguage)+ "</b> " +  new Date(overview[j+3]).format("%H:%M",_isolanguage)+ "</span>";	
					var txt =  overview[j+5]?("<table cellspacing=0 cellpadding=0><tr><td class=footnote><b>\""+overview[j+5]+"\"</b></td></tr><tr><td class=footnote style=\"text-align:right\">"+overview[j+4]+"</td></tr></table>"):"";			
					_oGUI.NBOX.add(fromto,txt);
				}
				
				if(mode=="login")
					_oGUI.NBOX.param["NBOX:bTail"] = false;
				else
					_oGUI.NBOX.param["NBOX:bTail"] = true;	
					
				_templdat[i] += _oGUI.NBOX.get(batchpath+"t24_"+_T["quote"]+".png","10_quotes.asp",_T["quote_tip"])			
			
			break;	
			
			case "LEFT_AREA_DATETIME":
				var adminbutton = "";
				if ( ("<"+Session("uid")+">") == Session("uidcrc") )
				{
					adminbutton = "<a href=../admin/menu.asp>admin</a> | "
				}
				_templdat[i] = "<table cellspacing=\"1\" cellpadding=\"2\" bgcolor=\"#EAEAEA\" height=\"12\"><tr><td bgcolor=\"#FFFFFF\" style=\"font-family:Verdana;font-size:10px;color:#D0D0D0\">"+adminbutton+"<a href=#top>top</a> | "+(new Date().format("%d %m %Y %H:%M"))+"</td></tr></table>";
			break;
			
			case "DATETIME":
				var adminbutton = "";
				if ( ("<"+Session("uid")+">") == Session("uidcrc") )
				{
					adminbutton = "<a href=../admin/menu.asp>admin</a> | "
				}
				
				if(curarg)
					_templdat[i] = new Date().format(curarg.substring(1,curarg.length-1));
				else
					_templdat[i] = new Date().format("%d %m %Y %H:%M");
			break;			
			
			case "LEFT_AREA":
				
				if(curarg)
				{
					var argset = argparser(curarg);
					
					if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					{
						_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
						_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					}					
					
					_oGUI.NBOX.param["NBOX:titleimg"] = "../images/batch/"+argset["img"];
					
					var pubcond = argset["pubcond"]?argset["pubcond"].split("-"):new Array(9,1);
					
					var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub","rev_url");
					var extraSQL =   (argset["timecond"]=="fromnow"?" and ds_datetime01 <= sysdate() order by ds_datetime01 desc ":"")
									+(argset["limit"]?(" LIMIT 0,"+argset["limit"]):"");
					var sSQL = "select "+tablefld.join(",")+" from "+_app_db_prefix+"review"+","+_app_db_prefix+"dataset where ds_rev_id = "+argset["id"]+" and rev_id = ds_rev_id and (ds_pub & "+pubcond[0]+") = "+pubcond[1]+" and rev_dir_lng = '"+_ws+"'"+extraSQL;
					
					var enumfldd = new Array();					
					for(var j=tablefld.length;j>=0;j--)
						enumfldd[tablefld[j]] = j;					
					
					if(argset["dat"])
					{
						var overview = new Array();
						var inargs = argparser("\""+unescape(argset["dat"])+"\"");
						
						var tablefld = inargs["flds"].split("|");
						var overview = inargs["vals"].split("|");

						var enumfldd = new Array();					
						for(var j=tablefld.length;j>=0;j--)
							enumfldd[tablefld[j]] = j;		
					}
					else
						var overview = _oDB.getrows( sSQL );
								
					//Response.Write(sSQL+"<br><br>")
					
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var dt = overview[j+enumfldd["ds_datetime01"]];
						var url = overview[j+enumfldd["rev_url"]];
						
						var leftcol = ""
						var lnk1 = "<a class=small href=\""+(url?(overview[j+enumfldd["ds_id"]]?(url.replace(/\.asp/,"_A_I_E_"+overview[j+enumfldd["ds_id"]]+".asp")):url):"")+"\" title=\""+overview[j+enumfldd["ds_desc"]]+"\">";
						var lnk2 = "</a>";
						
						if(argset["thumb"])
						{
							var tarr = argset["thumb"].split("-");
							leftcol = 
							 "<table cellspacing=0 cellpadding=0 align=right><tr><td width=41 height=1 align=left><img src=../images/pix.gif width=39 height=1></td></tr><tr><td><img src=../images/pix.gif width=1 height=37>"
							+lnk1+"<img src='../"+_ws+"/images/img"+zerofill(overview[j+enumfldd["ds_rev_id"]],10)+"_"+zerofill(overview[j+enumfldd["ds_id"]],6)+"_"+zerofill(tarr[0],3)+"_"+tarr[1]+".jpg' border=0>"+lnk2
							+"<img src=../images/ibox27.gif width=3 height=37></td></tr><tr><td><img src=../images/ibox28.gif width=41 height=3></td></tr></table>"
						}
						else
							leftcol = "<p class=footnote align=right>"+(typeof(dt)=="date"?new Date(dt).format("%H:%M",_isolanguage):"")+"<br><span style=color:#A0B5BF>"+(typeof(dt)=="date"?new Date(dt).format("%d&nbsp;%b",_isolanguage):"")+"</span></p>"
						
						_oGUI.NBOX.add(leftcol,lnk1+overview[j+enumfldd["ds_title"]]+lnk2);
					}	
					_templdat[i] += _oGUI.NBOX.get("","","");
					
					var key = (argset["cache"]?argset["cache"]:curfield)+argset["id"];
					oDATA.namecache_flds[key] = tablefld;
					oDATA.namecache_enum[key] = enumfldd;
					oDATA.namecache_data[key] = overview;				
					
				}
			break;
			
			case "LEFT_AREA_TAIL":
				_templdat[i] += _oGUI.NBOX.tailHTML();
			break;
			
			case "NEWS":
				if(curarg)
				{
					var argset = argparser(curarg);
					var pgnav = "";
					
					if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					{
						_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
						_oGUI.NBOX.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
					}
					
					_oGUI.NBOX.param["NBOX:titleimg"] = argset["titleimg"]?("../images/batch/"+argset["titleimg"]):"../images/ibox3.gif";
					_oGUI.NBOX.param["NBOX:title_ext"] = argset["title_ext"]?("../images/"+argset["title_ext"]):"../images/ibox3.gif";
					_oGUI.NBOX.param["NBOX:titlewidth"] = argset["titlewidth"]?argset["titlewidth"]:350;
					
					_oGUI.NBOX.param["NBOX:leftcaddy"] = false;
					_oGUI.NBOX.param["NBOX:bTail"] = true;
					_oGUI.NBOX.param["NBOX:lm"] = argset["lm"]?argset["lm"]:90;
					_oGUI.NBOX.param["NBOX:rm"] = argset["rm"]?argset["rm"]:400;
					_oGUI.NBOX.param["NBOX:tw"] = _oGUI.NBOX.param["NBOX:lm"] + _oGUI.NBOX.param["NBOX:rm"]+ 80;	
					
					var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub","rev_url");
					var extraSQL =   (argset["timecond"]=="fromnow"?" and ds_datetime01 >= sysdate() order by ds_datetime01 desc ":"")
									+(argset["limit"]?(" LIMIT 0,"+argset["limit"]):"");
					var sSQL = "select "+tablefld.join(",")+" from "+_app_db_prefix+"review"+","+_app_db_prefix+"dataset where ds_rev_id = "+argset["id"]+" and rev_id = ds_rev_id and (ds_pub & 9) = 1 and rev_dir_lng = '"+_ws+"'"+extraSQL;
					
					var overview = _oDB.getrows( sSQL );
					
					var enumfldd = new Array();					
					for(var j=tablefld.length;j>=0;j--)
						enumfldd[tablefld[j]] = j;
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var dt = overview[j+enumfldd["ds_datetime01"]];
						var url = overview[j+enumfldd["rev_url"]];
						//var txt = "<b>"+overview[j+enumfldd["ds_title"]]+"</b>" + (overview[j+enumfldd["ds_desc"]]?("<br><i>"+overview[j+enumfldd["ds_desc"]]+"</i>"):"") + (overview[j+enumfldd["ds_header"]]?("<br><br>"+overview[j+enumfldd["ds_header"]]):"");
						
						var imgurl = "";
						var imgpath = "../"+_ws+"/images/"
						if((overview[j+enumfldd["ds_num01"]]&1)==1)
							imgurl = "<img src='"+imgpath+"img"+zerofill(overview[j+enumfldd["ds_rev_id"]],10)+"_"+zerofill(overview[j+enumfldd["ds_id"]],6)+"_005_0.jpg' border=1 align=right>"
						
						var lnk = "";
						
						if(overview[j+enumfldd["ds_data01"]])
						{
							var bExternalLink = overview[j+enumfldd["ds_data01"]].indexOf(_host)<0; 
							lnk = "<a href="+(overview[j+enumfldd["ds_data01"]].indexOf("http://")<0?"http://":"")+overview[j+enumfldd["ds_data01"]]+" class=small"+(bExternalLink?" target=_blank":"")+">"+_T["readmore"]+" <img src=../images/ii_pijlen.gif border=0></a>"
						}
						
						var txt = "<a name="+base64encode(overview[j+enumfldd["ds_id"]].toString())+"></a>"
							+(overview[j+enumfldd["ds_title"]]?("<b>" + overview[j+enumfldd["ds_title"]] 
							+"</b><br>"):"") + (overview[j+enumfldd["ds_desc"]]?("<i>" + overview[j+enumfldd["ds_desc"]] 
							+"</i><br><br>"):"") + (overview[j+enumfldd["ds_header"]]?("<div align=justify>"+overview[j+enumfldd["ds_header"]]+" " 
							+ "</div>"):"");
						
						_oGUI.NBOX.add("<p class=footnote align=right>"+(typeof(dt)=="date"?new Date(dt).format("%H:%M",_isolanguage):"")+"<br><span style=color:#A0B5BF>"+(typeof(dt)=="date"?new Date(dt).format("%d&nbsp;%b",_isolanguage):"")+"</span></p>", imgurl+txt+lnk );
					}
					_templdat[i] += "<center>"+_oGUI.NBOX.get("","","")+"</center><table width=545><tr><td>"+pgnav+"</td></tr></table>"
				}
			break;
			
			case "RQ":
				if(curarg)
				{
					_templdat[i] += Request.QueryString(curarg).Item;
				}
			break;
						
			
			case "EVENTSTITLE":
				if(curarg)
				{
					var argset = argparser(curarg);
					//var key = (argset["cache"]?argset["cache"]:curfield)+argset["id"];
					//var tablefld  = oDATA.namecache_flds[key];
					//var enumfld   = oDATA.namecache_enum[key];
					//var overview  = oDATA.namecache_data[key];
					//var imgnr = (Number(Request.QueryString("I").Item)-1)*tablefld.length;
					//_templdat[i] += overview[imgnr+enumfld["ds_title"]];
					
					var sSQL = "select ds_title from "+_app_db_prefix+"dataset where ds_rev_id = "+argset["id"]+" and ds_id = "+Number(Request.QueryString("I").Item)+" and (ds_pub & 9) = 1 limit 0,1"
					_templdat[i] = _oDB.get(sSQL);
				}
			break;
			case "EVENTS":
				if(curarg)
				{
					var argset = argparser(curarg);
					var key = (argset["cache"]?argset["cache"]:"EVENTSTITLE")+argset["id"];
					var tablefld  = oDATA.namecache_flds[key];
					var enumfld   = oDATA.namecache_enum[key];
					var overview  = oDATA.namecache_data[key];
					
					
					var crlf="\r\n";
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						_templdat[i] += "<table cellspacing=0 cellpadding=3 width=580 height=150>"
						+"	<tr>"
						+"		<td height=135 valign=top width=160>"
						+"		<table cellpadding=0 cellspacing=0 align=left><tr><td><table cellpadding=0 cellspacing=0><tr><td width=100>"
						+"		<table cellspacing=0 cellpadding=1 width=150 height=100><tr><td bgcolor=black><br><center><a href=\"index_Q_P_E_"+argset["details"]+"_A_I_E_"+overview[j+enumfld["ds_id"]]+".asp\"><img src='../"+_ws+"/images/img"+zerofill(overview[j+enumfld["ds_rev_id"]],10)+"_"+zerofill(overview[j+enumfld["ds_id"]],6)+"_010_00_0.jpg' name='animg0' style='filter:blendTrans(duration=0.8)' border=0></a></center><br></td></tr></table>	"
						+"      </td></tr></table></td><td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td></tr><tr><td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td><td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td></tr></table>"
						+"		</td>"
						+"		<td rowspan=2 valign=top style=text-align:left>"
						+"                                                        <span class=title>"+overview[j+enumfld["ds_title"]]+"</span><br>"
						+"                                                        <span class=voetnoot>"+overview[j+enumfld["ds_desc"]]+"</span><br><br>"
						+"                                                        <span class=body>"+overview[j+enumfld["ds_header"]]
						+"                                                        <a href=\"index_Q_P_E_"+argset["details"]+"_A_I_E_"+overview[j+enumfld["ds_id"]]+".asp\" class=voetnoot> Gallery&nbsp;&gt;&gt;&gt;</a></span>"
						+"		</td>"
						+"	</tr>"
						+"</table>";
					}
					/*
					_templdat[i] +="<script>"+crlf
								 +"var frm = new Array();"+crlf
								 +"var animgobj = new Array();"+crlf
					
					var lines = new Array(overview.length/tablefld.length);
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var picbase = "../"+_ws+"/images/img"+zerofill(overview[j+enumfld["ds_rev_id"]],10)+"_"+zerofill(overview[j+enumfld["ds_id"]],6);
						var n = j/tablefld.length;
						lines[j] = "animgobj["+n+"] = document.images.animg"+n+";"+crlf;
								  +"frm["+n+"] = new Array( 3,new Image(),3,new Image(),3,new Image(),3,new Image(),3,new Image(),3,new Image() );"+crlf;
								  +"frm["+n+"][1].src = '"+picbase+"_010_0.jpg';"+crlf;
								  +"frm["+n+"][3].src = '"+picbase+"_011_0.jpg';"+crlf;
								  +"frm["+n+"][5].src = '"+picbase+"_012_0.jpg';"+crlf;
								  +"frm["+n+"][7].src = '"+picbase+"_013_0.jpg';"+crlf;
								  +"frm["+n+"][9].src = '"+picbase+"_014_0.jpg';"+crlf;
								  +"frm["+n+"][11].src = '"+picbase+"_015_0.jpg';"+crlf;
					}
					
					_templdat[i] += lines.join(crlf)+"</script>"+crlf;
					
					_templdat[i] += "<script>"+crlf
								+"function fadein(newimgobj,curimgobj)"+crlf
								+"{"+crlf
								+"	try {curimgobj.filters.blendTrans.apply();}catch(e){};"+crlf
								+"	curimgobj.src=newimgobj.src;"+crlf
								+"	try {curimgobj.filters.blendTrans.play();}catch(e){};"+crlf
								+"}"+crlf
								+"var t=0;"+crlf
								+"var clk    = 750;  // roundtrip time"+crlf
								+"var s_clk   = Math.round(clk/frm.length);	 // single sequence execution time"+crlf
								+"var anim = new Array();	// img sequence numbers"+crlf
								+"var atim = new Array(); // time interval counter"+crlf
								+"var istep = 2;"+crlf
								+"var log = \"\";"+crlf
								+"function gorefresh()"+crlf
								+"{"+crlf
								+"	setTimeout('gorefresh()',s_clk);"+crlf
								+"if(t<frm.length)"+crlf
								+"	{"+crlf
								+"		anim[t] = typeof(anim[t])!='undefined'?anim[t]:istep;"+crlf
								+"		atim[t] = atim[t]?atim[t]:1;"+crlf
								+"atim[t] = atim[t]<(frm[t][anim[t]]*2) ? (atim[t]+1):1;"+crlf
								+"if (atim[t]==1)"+crlf
								+"{"+crlf
								+"if (frm[t][anim[t]]>0)"+crlf
								+"  anim[t] = anim[t]<(frm[t].length-istep)?(anim[t]+istep):0;  // iterate animation"+crlf
								+"			if (frm[t][anim[t]]>0)"+crlf
								+"				fadein( frm[t][anim[t]+1],animgobj[t]);"+crlf
								+"		}"+crlf
								+"	}"+crlf
								+"	t++;"+crlf
								+"	if(t>=(clk/s_clk))"+crlf
								+"		t=0;"+crlf
								+"}"+crlf
								+"window.onload=gorefresh;"+crlf
								+"</script>"+crlf
					*/
				}
			break;
			
			case "EVENTSGALLERY":
				if(curarg)
				{
					var argset = argparser(curarg);
					var key = (argset["cache"]?argset["cache"]:curfield)+argset["id"];
					var tablefld  = oDATA.namecache_flds[key];
					var enumfld   = oDATA.namecache_enum[key];
					var overview  = oDATA.namecache_data[key];
					
					var crlf = "\r\n";
					
					var imgnr = Number(Request.QueryString("I").Item-1)*tablefld.length;
					_templdat[i]  += "<a name=bodytop><table><tr>"
					for(var n=0;n<6;n++)
					{
						_templdat[i] +=  "<td>"
										+"		<table cellpadding=0 cellspacing=0 align=left><tr><td><table cellpadding=0 cellspacing=0><tr><td width=100>"
										+"		<table cellspacing=0 cellpadding=1 width=150 height=100><tr><td bgcolor=black><br><center><a href=\"index_Q_P_E_"+rev_rt_cat+"_A_I_E_"+overview[imgnr+enumfld["ds_id"]]+"_A_Z_E_"+(n+1)+".asp#bodytop\"><img src='../"+_ws+"/images/img"+zerofill(overview[imgnr+enumfld["ds_rev_id"]],10)+"_"+zerofill(overview[imgnr+enumfld["ds_id"]],6)+"_"+zerofill(n+10,3)+"_0.jpg' name='animg0' style='filter:blendTrans(duration=0.8)' border=0></a></center><br></td></tr></table>	"
										+"      </td></tr></table></td><td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td></tr><tr><td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td><td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td></tr></table>"
										+"</td>"
										+((n%3)==2?"</tr>":"");
						
					}
					_templdat[i]  += ((n%3)!=2?"</tr>":"")+"</table>"
					
					// DETAIL IMAGE
					var innersize = 500;
					var outersize = 530;
					var imgnr = Number(Request.QueryString("I").Item-1)*tablefld.length;
					var n=Request.QueryString("Z").Item
					n = n?Number(n):1;
					
					var nextn = n>=6?1:(n+1);
					_templdat[i] +=  "<a name=detailtop>"		
									+"<table cellpadding=0 cellspacing=0 align=left><tr><td><table cellpadding=0 cellspacing=0><tr><td width="+innersize+">"
									+"		<table cellspacing=0 cellpadding=1 width="+outersize+" height="+innersize+"><tr><td bgcolor=black><br><center><a href=\"index_Q_P_E_"+rev_rt_cat+"_A_I_E_"+overview[imgnr+enumfld["ds_id"]]+"_A_Z_E_"+nextn+".asp#detailtop\"><img src='../"+_ws+"/images/img"+zerofill(overview[imgnr+enumfld["ds_rev_id"]],10)+"_"+zerofill(overview[imgnr+enumfld["ds_id"]],6)+"_"+zerofill(n+10-1,3)+"_1.jpg' name='animg0' style='filter:blendTrans(duration=0.8)' border=0></a></center><br></td></tr></table>	"
									+"      </td></tr></table></td><td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td></tr><tr><td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td><td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td></tr></table>"
									+"</a>"
				}
			break;			
			
			
			case "COLUMN":
				if(curarg)
				{
					var argset = argparser(curarg);
					var key = (argset["cache"]?argset["cache"]:curfield)+argset["id"];
					var pubcond = argset["pubcond"]?argset["pubcond"].split("-"):new Array(9,1);
					var tarr = argset["thumb"]?argset["thumb"].split("-"):new Array(4,1);
					
					var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub","rev_url");
					var extraSQL = (argset["limit"]?(" LIMIT 0,"+argset["limit"]):"");
					var sSQL = "select "+tablefld.join(",")+" from "+_app_db_prefix+"review"+","+_app_db_prefix+"dataset where ds_rev_id = "+argset["id"]+" and rev_id = ds_rev_id and (ds_pub & "+pubcond[0]+") = "+pubcond[1]+" and rev_dir_lng = '"+_ws+"'"+extraSQL;
					//Response.Write(sSQL);
					var overview = _oDB.getrows( sSQL );
					
					var enumfldd = new Array();
					for(var j=tablefld.length;j>=0;j--)
						enumfldd[tablefld[j]] = j;
					
					oDATA.namecache_flds[key] = tablefld;
					oDATA.namecache_enum[key] = enumfldd;
					oDATA.namecache_data[key] = overview;
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						_templdat[i] +=
						 "<div class=body style=\"margin:4px;text-align:left;padding:0px 0px 8px 0px\">";
						 
						var title	= overview[j+enumfldd["ds_title"]];
						var desc	= overview[j+enumfldd["ds_desc"]];
						var dt		= overview[j+enumfldd["ds_datetime01"]];
						 
						if((Number(overview[j+enumfldd["ds_num01"]])&1) == 1 && (title || desc))
						{
							if(overview[j+enumfldd["ds_data01"]])
								var lnk = overview[j+enumfldd["ds_data01"]]?(overview[j+enumfldd["ds_data01"]].replace(/^www\./,"http://www.")):"";
							else
								var lnk = argset["lid"]?("index_Q_P_E_"+argset["lid"]+"_A_I_E_"+overview[j+enumfldd["ds_id"]]+".asp"):"";
							var target = overview[j+enumfldd["ds_data01"]] && overview[j+enumfldd["ds_data01"]].indexOf(_ws)<0?" target=_blank":""
							
							_templdat[i] +=
							 "  <table cellspacing=\"0\" cellpadding=\"0\" width=\"45\" align=\"left\" style=margin-right:3px>"		
							+"  	<tr><td width=\"42\" background=\"../images/lbox2.gif\" bgcolor=\"#000\">"
							      +"<a href=\""+lnk+"\" title=\""+title+"\""+target+">"
							      +"<img src='../"+_ws+"/images/img"+zerofill(overview[j+enumfldd["ds_rev_id"]],10)+"_"+zerofill(overview[j+enumfldd["ds_id"]],6)+"_"+zerofill(tarr[0],3)+"_"+tarr[1]+".jpg' border=1 style=border-color:black>"
							      +"</a></td><td width=3></td></tr>"
							+"  	<tr><td width=\"42\" height=\"3\" background=\"../images/lbox1.gif\"></td></tr>"
							+"  </table>";
						}
						
						var comments = "";
						if(argset["cid"])
						{
							var sSQL = "select count(*) from "+_app_db_prefix+"dataset where (ds_pub & 9) = 1 and ds_rev_id = "+overview[j+enumfldd["ds_rev_id"]]+" and ds_num01 = "+overview[j+enumfldd["ds_id"]]
							var count = _oDB.get(sSQL);
							var commenttitle = Number(count)==1?_T["comment"]:_T["comments"];
							commenttitle = commenttitle.charAt(0).toUpperCase()+commenttitle.substring(1,commenttitle.length)
							comments = "<FONT color=#dadada>|</FONT> <a href=\"index_Q_P_E_"+argset["cid"]+"_A_I_E_"+overview[j+enumfldd["ds_id"]]+".asp\"><IMG title=\""+_T["commentlink"]+"\" src=\"../images/ii_comments.gif\" border=0></a> "+count+" "+commenttitle
						}
						
						_templdat[i] +=
						 "<a class=more href=\""+lnk+"\""+target+">"+title+"</a>"
						+overview[j+enumfldd["ds_desc"]]
						+"</div>"
						+"<DIV class=body style=\"PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 8px; MARGIN: 4px; PADDING-TOP: 0px; TEXT-ALIGN: left\">"
						+"<SPAN class=small>"
						+(overview[j+enumfldd["ds_data01"]]?"":("<a href=\""+lnk+"\""+target+">"))
						+"<IMG title=\""+(overview[j+enumfldd["ds_data01"]]?"":_T["permalink"])+"\" src=\"../images/ii_permalink.gif\" border=0>"
						+(overview[j+enumfldd["ds_data01"]]?"":("</a>"))
						+" "+(typeof(dt)=="date"?new Date(dt).format( argset["dateformat"]?argset["dateformat"]:"%d&nbsp;%b&nbsp;%Y" ,_isolanguage):"")
						+" "+comments
						+"</SPAN></DIV>"
						+"<img src=../spc.gif width=220 height=1>"
						
					}
				}
		/*
				// THIS SHOULD BE LOADED ONLY ONCE (LOAD THE ENTIRE TREE AT ONCE FOR GOD SAKE !!!)
			
				var sSQL = "select rt_name from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\" and (rt_pub & 1) = 1  and rt_id = "+curarg;
				var title = _oDB.get(sSQL)
						
				_templdat[i] += ""
				+"<h3><a href=#>"+title+"</a></h3>"
				
				+"<div class=body style=\"margin:4px;text-align:left;padding:0px 0px 8px 0px\">"
				+"  <table cellspacing=\"0\" cellpadding=\"0\" width=\"42\" align=\"left\">"		
				+"  	<tr><td width=\"42\" background=\"../images/lbox2.gif\" bgcolor=\"#000\"><a href=\"/publications/bulletproof/\" title=\"More info about the book\"><img src=\"http://www.theartserver.be/theartserver/images/review/img0000007121_1.jpg\" width=\"37\" style=\"border:1px solid #000\"></a></td></tr>"
				+"  	<tr><td width=\"42\" height=\"3\" background=\"../images/lbox1.gif\"></td></tr>"
				+"  </table>"		
				+"	<a class=\"more\" href=\"/publications/bulletproof/\">De macht van het bouwen</a>"
				+"	Hoe macht en geld de wereld aanzien geven is de ondertitel van een boeiend geschreven boek waarin de journalist en architectuurciriticus Deyan Sudjic zijn zoektocht afrondt naar de relatie tussen macht en architectuur in de twintigste eeuw."
				+"</div>"
				
				+"<div class=body style=\"margin:4px;text-align:left;padding:0px 0px 8px 0px\">"
				+"  <table cellspacing=\"0\" cellpadding=\"0\" width=\"42\" align=\"left\">"		
				+"  	<tr><td width=\"42\" background=\"../images/lbox2.gif\" bgcolor=\"#000\"><a href=\"/publications/bulletproof/\" title=\"More info about the book\"><img src=\"http://www.theartserver.be/theartserver/images/music/img0000007415_1.jpg\" width=\"37\" style=\"border:1px solid #000\"></a></td></tr>"
				+"  	<tr><td width=\"42\" height=\"3\" background=\"../images/lbox1.gif\"></td></tr>"
				+"  </table>"		
				+"	<a class=\"more\" href=\"/publications/bulletproof/\">Belgium. Musical Visions.</a>"
				+"Deze dubbel-cd is geen anthologie van de Belgische pianomuziek. De pianiste Thérèse Malengreau heeft een denkbeeldig concertprogramma samengesteld."
				+"</div>"
			*/
			break;			
			
			case "MENU_TOPBAR":
				_templdat[i] = " ";
			break;
			case "MENU_BAR":
			
				if(curarg)
				{
					if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
						_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
						
					var tablefld = new Array("rt_id","rt_name");
					var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"reviewtype where (rt_pub & 1) = 1 and rt_dir_lng = \""+_dir+"\" and rt_parent_id = "+curarg+" and rt_name not like \"[%]\" order by rt_index";
					var overview = _oDB.getrows( sSQL );
					
					//Response.Write(sSQL)
					
					_templdat[i] = 
					 "<table cellspacing=0 cellpadding=0 height=18 class=tab>"
					+"<tr>";
					
					var _tab_selected = rev_rt_cat;
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var bon      = overview[j]==_tab_selected;
						var bprevon  = overview[j-tablefld.length]==_tab_selected;
						var bfirst   = j==0;
						var blast    = j==(overview.length-tablefld.length);
						
						var link1 = "";
						var link2 = "</a>";
						if(overview[j])
							link1 = "<a href="+(_oGUI.param["P"+overview[j]]?_oGUI.param["P"+overview[j]]:"index")+"_Q_P_E_"+overview[j]+".asp style=\"text-decoration:none\">";
						else
							link2 = "";
						
						if(bfirst)
							_templdat[i] += "<td><img src=../images/"+(bon?"tab_first_on.gif":"tab_first_off.gif")+" width=19 height=18></td>";
						else if(bprevon)
							_templdat[i] += "<td><img src=../images/tab_prev_on.gif width=19 height=18></td>";
						else
							_templdat[i] += "<td><img src=../images/"+(bon?"tab_next_on.gif":"tab_both_off.gif")+" width=19 height=18></td>";
						
						_templdat[i] += "<td background=../images/"+(bon?"tab_body_on.gif":"tab_body_off.gif")+">"+link1+overview[j+1]+link2+"&nbsp;</td>";
						
						if(blast)
							_templdat[i] += "<td><img src=../images/"+(bon?"tab_last_on.gif":"tab_last_off.gif")+" width=4 height=18></td>";
					}
						
					_templdat[i] +=
					 "</tr>"
					+"</table>";			
				}
				
				//_templdat[i] = "(argument="+curarg+")";
			break;
		
/*
			case "VMENU_BAR_OLD":
			
				if(curarg)
				{
					var argset = argparser(curarg);
					
					var tablefld = new Array("rt_id","rt_name");
					var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"reviewtype where (rt_pub & 1) = 1 and rt_dir_lng = \""+_dir+"\" and rt_id <> rt_parent_id and rt_parent_id = "+argset["id"];
					var overview = _oDB.getrows( SQL );
					
					_templdat[i] = 
					 "<div id=\"navlist\">\r\n<ul>\r\n";
					 
					var _tab_selected = rev_rt_cat;
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var bon      = overview[j]==_tab_selected;
						var bprevon  = overview[j-tablefld.length]==_tab_selected;
						var bfirst   = j==0;
						var blast    = j==(overview.length-tablefld.length);
						
						var link1 = "";
						var link2 = "</a>";
						if(overview[j])
							link1 = "<a href=index_Q_P_E_"+overview[j]+".asp style=\"text-decoration:none\">";
						else
							link2 = "";		
						
						if(argset["case"]=="uppercase")
							overview[j+1] = overview[j+1]?overview[j+1].toUpperCase():""
						
						_templdat[i] += "<li"+(bon?" id=uberlink":"")+">"+link1+overview[j+1]+link2+"</li>\r\n";
					}
					_templdat[i] += "</ul>\r\n</div>\r\n";			
				}
				//_templdat[i] = "(argument="+curarg+")";
			break;
*/
			
			case "VMENU_BAR":
				
				if(curarg)
				{
					var argset = argparser(curarg);
					
					var tablefld = new Array("rt_id","rt_name");
					var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"reviewtype where (rt_pub & 1) = 1 and rt_dir_lng = \""+_dir+"\" and rt_id <> rt_parent_id and rt_parent_id = "+argset["id"]+" order by rt_index";
					var overview = _oDB.getrows( SQL );
					
					_templdat[i] = 
					 "<div id=\"navlist\">\r\n";
					 
					var _tab_selected = rev_rt_cat;
					
					for(var j=0;j<overview.length;j+=tablefld.length)
					{
						var bon      = overview[j]==_tab_selected;
						var bprevon  = overview[j-tablefld.length]==_tab_selected;
						var bfirst   = j==0;
						var blast    = j==(overview.length-tablefld.length);
						
						var link1 = "";
						var link2 = "</a>";
						if(overview[j])
							link1 = "<a href=index_Q_P_E_"+overview[j]+".asp "+(bon?"selected":"")+" style=\"text-decoration:none\">";
						else
							link2 = "";		
						
						if(argset["case"]=="uppercase")
							overview[j+1] = overview[j+1]?overview[j+1].toUpperCase():""
						
						_templdat[i] += "<div"+(bon?" id=uberlink":"")+">"+link1+overview[j+1]+link2+"</div>\r\n";
					}
					_templdat[i] += "</div>\r\n";			
				}
				//_templdat[i] = "(argument="+curarg+")";
			break;		
			
			case "NAV_ICONS":
				_templdat[i] = " ";
			break;
			case "BODY":
				_templdat[i] = _bodytext;
			break;
			case "BODY_RIGHT":
			break;
			case "RIGHT_AREA":
				_templdat[i] = "<table cellspacing=0 cellpadding=0 width=220><tr><td bgcolor=\"#BCB8B5\" width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 alt=\"decoration\"></td><td width=220 bgcolor=white></td></tr></table>";
				//_templdat[i] = "<table cellpadding=0 cellspacing=0 width=220><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 border=0></td><td colspan=2><A href=http://www.schleiper.com/ target=_blank><IMG src=http://www.nobel.be/theartserver/images/ads/schleiper_220_110.gif border=0></A><br></td></tr><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 border=0></td><td colspan=2><A href=http://www.talent2005.be/ target=_blank><IMG onmouseover=this.src='http://www.nobel.be/theartserver/images/ads/talent2005b_220.gif' onmouseout=this.src='http://www.nobel.be/theartserver/images/ads/talent2005_220.gif' alt= hspace=0 src=http://www.nobel.be/theartserver/images/ads/talent2005_220.gif border=0></A><br></td></tr><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 border=0></td><td colspan=2><OBJECT id=scrolltext_piron codeBase=http://active.macromedia.com/flash4/cabs/swflash.cab#version=4,0,0,0 height=100 width=220 classid=clsid:D27CDB6E-AE6D-11cf-96B8-444553540000><PARAM NAME=_cx VALUE=5821><PARAM NAME=_cy VALUE=2646><PARAM NAME=FlashVars VALUE=><PARAM NAME=Movie VALUE=../images/ads/scrolltext_piron.swf><PARAM NAME=Src VALUE=../images/ads/scrolltext_piron.swf><PARAM NAME=WMode VALUE=Window><PARAM NAME=Play VALUE=-1><PARAM NAME=Loop VALUE=-1><PARAM NAME=Quality VALUE=Low><PARAM NAME=SAlign VALUE=><PARAM NAME=Menu VALUE=-1><PARAM NAME=Base VALUE=><PARAM NAME=AllowScriptAccess VALUE=always><PARAM NAME=Scale VALUE=ShowAll><PARAM NAME=DeviceFont VALUE=0><PARAM NAME=EmbedMovie VALUE=0><PARAM NAME=bgcolor VALUE=000000><PARAM NAME=SWRemote VALUE=><PARAM NAME=MovieData VALUE=><PARAM NAME=SeamlessTabbing VALUE=1><embed name=scrolltext_piron src=../images/ads/scrolltext_piron.swf quality=low bgcolor=\"#000\"000 width=220 height=100    type=application/x-shockwave-flash pluginspage=http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash></embed></OBJECT><br></td></tr><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=6 border=0></td><td width=5></td><td width=215><h2 class=home>Vous organisez ou comptez organiser un événement ?&nbsp;</h2><table cellpadding=0 cellspacing=0 class=body><tr valign=top><td width=60><table cellspacing=0 cellpadding=0 align=left class=small><tr><td width=54 height=1 align=left><img src=../images/pix.gif width=52 height=1></td></tr><tr><td><img src=../images/pix.gif width=1 height=50><a href=13_detail_Q_id_E_d29c2a7d03e14358.asp#AA6g><img src=../images/promo/img0000003744_t50_1.jpg alt=Leur  publication sur nobel est entièrement gratuite. border=0></a><img src=../images/ibox27.gif width=3 height=50></td></tr><tr><td><img src=../images/ibox28.gif width=54 height=3></td></tr></table><span align=left class=small></span></td><td class=small style=text-align=left><a href=13_detail_Q_id_E_d29c2a7d03e14358.asp#AA6g>Leur  publication sur nobel est entièrement gratuite.</a><br>Un agenda est à votre disposition si vous souhaitez faire connaître un événement que vous organisez en relation directe avec le monde de l'art ...</td></tr><tr><td colspan=2 class=small><a href=13_detail_Q_id_E_d29c2a7d03e14358.asp#AA6g>détails...</a></td></tr></table></td></tr><tr><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=6 border=0></td><td width=5></td><td>&nbsp;</td></tr><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 border=0></td><td colspan=2><A href=https://www.paypal.com/fr/mrb/pal=TE7GPP3LUQMLE target=_blank><IMG src=http://www.nobel.be/theartserver/images/ads/paypal_fr.gif border=0></A><br></td></tr><tr valign=top><td bgcolor=#BCB8B5 width=1 valign=top><img SRC=../images/nbox4.gif width=1 height=1 border=0></td><td colspan=2><TABLE cellspacing=0 cellpadding=0 width=220><TBODY><TR><TD bgcolor=#f4f0ee></TD></TR></TBODY></TABLE><br></td></tr><tr><td colspan=3 height=1 bgcolor=#BCB8B5></td></tr></table>"
				
			break;
			case "CENTRAL_FOOTER":
				if(bXMLValid==true && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0) && XMLObj.getElementsByTagName("ROOT/"+curfield).item(0).hasChildNodes==true)
					_oGUI.initXML(XMLObj.getElementsByTagName("ROOT/"+curfield));
				_templdat[i] = _oGUI.param["text"];
			break;	
			case "UP":
				_templdat[i] = "<";
			break;
			case "DN":
				_templdat[i] = ">";
			break;
			case "SEARCH_GOCYCLING":
				if(curarg)
				{
					var ds = Request.QueryString("d").Item?Request.QueryString("d").Item.toString().decrypt("nicnac"):0;
					var oFORM = new FORM();
					var oPARSE = new oFORM.PARSE();
					oPARSE.get(_templdat[_enumtmpl["BODY"]]);
					var curargarr = csv2array(curarg);
					
					var formvalue = new Array();
					for(var j=0;j<oPARSE.unames.length;j++)
						formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;
					
					var searchclause = " and (0 ";
					searchclause += formvalue["datejj"]&&formvalue["datemm"]&&formvalue["dateaa"]?(" or DATE(ds_datetime01) = \""+formvalue["dateaa"]+"-"+formvalue["datemm"]+"-"+formvalue["datejj"]+"\""):"";
					searchclause += formvalue["localite"]?(" or ds_title like \"%"+formvalue["localite"]+"%\""):"";
					searchclause += formvalue["denomination"]?(" or ds_desc like \"%"+formvalue["denomination"]+"%\""):"";
					searchclause += ")"
					
					var titles = "<TR width=600><TD width=30>&nbsp;</TD><TD ALIGN=left VALIGN=\"center\"><FONT CLASS=description>"+curargarr.join("</TD>\r\n<TD ALIGN=left VALIGN=center><FONT CLASS=description>")+"</td></tr>\r\n"
								+"<TR><TD width=30>&nbsp;</TD><TD colspan=10><HR></TD></TR>\r\n";
								
					var rfields = new Array("CONCAT(ds_id,'&nbsp;&nbsp;')","CONCAT(DATE_FORMAT(ds_datetime01,'%d/%m/%Y'),'&nbsp;&nbsp;')","ds_title","ds_desc","IF(ds_data01,ds_header,CONCAT(ds_header,' <a href=mailto:',ds_data01,' title=',ds_data01,'><img src=../images/ii_email2.gif alt=envelope></a>'))")		
					var sSQL = "select "+rfields.join(",")+" from "+_db_prefix+"dataset where (ds_pub & 1) = 1 and ds_rev_id = "+ds+" "+searchclause+" order by ds_datetime01,ds_title";
					if(bDebug)
						Response.Write(sSQL+"<br><br>")
					
					var results = _oDB.getrows(sSQL);		
						
					var r = new Array(Math.round(results.length/rfields.length));
					
					if(results.length>0)
					{
						for(var j=0;j<results.length;j+=rfields.length)
							r[j/rfields.length] = "<TR width=600><TD width=30>&nbsp;</TD><TD ALIGN=left VALIGN=center><FONT CLASS=description>"+results.slice(j,j+rfields.length).join("</TD>\r\n<TD ALIGN=left VALIGN=center><FONT CLASS=description>")+"</td></tr>"
					}
					else
						r[0] = "<TR><TD width=30>&nbsp;</TD><TD colspan=10>"+_T["noresults"]+"...</TD></TR>\r\n"; 
					
					_templdat[i] = "<TABLE width=600 cellpadding=0 cellspacing=0>"+titles+r.join("\r\n")+"</TABLE>";
				}
			break;
			
			case "SEARCH_SPORT":
				if(curarg)
				{
					var ds = Request.QueryString("d").Item?Request.QueryString("d").Item.toString().decrypt("nicnac"):0;
					var argset = argparser(curarg);
					
					var oFORM = new FORM();
					var oPARSE = new oFORM.PARSE();
					oPARSE.get(_templdat[_enumtmpl["BODY"]]);
					var curargarr = csv2array(unescape(argset["titles"]));
					var sqlargarr = csv2array(unescape(argset["columns"]));
					
					var formvalue = new Array();
					for(var j=0;j<oPARSE.unames.length;j++)
						formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;
					
					var searchclause = " and (0 ";
					searchclause += formvalue["datejj"]&&formvalue["datemm"]&&formvalue["dateaa"]?(" or DATE(ds_datetime01) = \""+formvalue["dateaa"]+"-"+formvalue["datemm"]+"-"+formvalue["datejj"]+"\""):"";
					searchclause += formvalue["localite"]?(" or ds_title like \"%"+formvalue["localite"]+"%\""):"";
					searchclause += formvalue["denomination"]?(" or ds_desc like \"%"+formvalue["denomination"]+"%\""):"";
					searchclause += ")"
					
					var titles = "<TR width=600><TD width=30>&nbsp;</TD><TD ALIGN=left VALIGN=\"center\"><FONT CLASS=description>"+curargarr.join("</TD>\r\n<TD ALIGN=left VALIGN=center><FONT CLASS=description>")+"</td></tr>\r\n"
								+"<TR><TD width=30>&nbsp;</TD><TD colspan=10><HR></TD></TR>\r\n";
								
					var rfields = sqlargarr;
					var sSQL = "select "+rfields.join(",")+" from "+_db_prefix+"dataset where (ds_pub & 1) = 1 and ds_rev_id = "+ds+" "+searchclause+" order by ds_datetime01,ds_title";
					if(bDebug)
						Response.Write(sSQL+"<br><br>")
					
					var results = _oDB.getrows(sSQL);		
						
					var r = new Array(Math.round(results.length/rfields.length));
					
					if(results.length>0)
					{
						for(var j=0;j<results.length;j+=rfields.length)
							r[j/rfields.length] = "<TR width=600><TD width=30>&nbsp;</TD><TD ALIGN=left VALIGN=center><FONT CLASS=description>"+results.slice(j,j+rfields.length).join("</TD>\r\n<TD ALIGN=left VALIGN=center><FONT CLASS=description>")+"</td></tr>"
					}
					else
						r[0] = "<TR><TD width=30>&nbsp;</TD><TD colspan=10>"+_T["noresults"]+"...</TD></TR>\r\n"; 
					
					_templdat[i] = "<TABLE width=600 cellpadding=0 cellspacing=0>"+titles+r.join("\r\n")+"</TABLE>";
				}
			break;			
			
			case "HIDDENFORMDATA":
				var ds = Request.QueryString("d").Item?Request.QueryString("d").Item.toString().decrypt("nicnac"):0;
				var dsid = Request.QueryString("dsid").Item?Request.QueryString("dsid").Item:0;
				
				// R E A D   M E T A   D A T A			
				
				var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
				var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+ds;
				var dataset = _oDB.getrows(sSQL);				
				
				var enumdatafld = new Array();
				for (var j=0; j<datafld.length ; j++)
					enumdatafld[datafld[j]] = j;
				
				var XMLObj = loadXML(dataset[enumdatafld["rev_rev"]]);
				var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
				
				// R E A D   D A T A
				
				var sSQL = "select rd_dt_id,rd_text from "+_db_prefix+"datadetail where rd_recno = "+dsid+" and rd_ds_id = "+ds;
				var data = _oDB.getrows(sSQL);	
				
				var enumdata = new Array();
				for(var j=0; j<data.length; j+=2)
					enumdata[data[j]] = data[j+1]
				
				var formtags = new Array();
				for(var j=0;j<hfields.length;j++)
				{
					var valueID = hfields.item(j).text;
					var name  = hfields.item(j).getAttribute("name");
					valueID = Number(valueID.substring(1,valueID.length-1));
					formtags[j] = "<input type=hidden name="+name+" value=\""+(enumdata[valueID]?enumdata[valueID]:"")+"\">";
				}
				
				_templdat[i] = formtags.join("\r\n")
			break;
			
			case "FORMNAMEARRAY":
				var ds = Request.QueryString("d").Item?Request.QueryString("d").Item.toString().decrypt("nicnac"):0;
				var dsid = Request.QueryString("dsid").Item?Request.QueryString("dsid").Item:0;
				
				// R E A D   M E T A   D A T A			
				
				var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
				var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+ds;
				var dataset = _oDB.getrows(sSQL);				
				
				var enumdatafld = new Array();
				for (var j=0; j<datafld.length ; j++)
					enumdatafld[datafld[j]] = j;
				
				var XMLObj = loadXML(dataset[enumdatafld["rev_rev"]]);
				var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
				
				var formtags = new Array();
				_templdat[i] = hfields.item(0).getAttribute("name");
				for(var j=1;j<hfields.length;j++)
					_templdat[i] += "\",\""+hfields.item(j).getAttribute("name");
				
				
			break;
			
			case "QLIST_INFO":
			    if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					var str = unescape(curarg.split("\"")[3]);
					
					var argset = argparser(curarg);
					ds = argset["ds"]?argset["ds"].toString().decrypt("nicnac"):ds;
					
					var revfld = new Array("rev_title","rev_desc");
					var sSQL = "select "+revfld.join(",")+" from "+_db_prefix+"review where rev_id = "+ds+" and (rev_pub & 1) = 1"
					var revparam = _oDB.getrows(sSQL);
					
					var revdat = new Array(revparam.length);
					for(var j=revfld.length;j>=0;j--)
						revdat[revfld[j]] = revparam[j];
					
					str = str.replace(/{_TITLE_}/g,revdat["rev_title"]);
					str = str.replace(/{_DESC_}/g,revdat["rev_desc"]);
					str = str.replace(/({_*_})/g,"");
					
					_templdat[i] = str;
				}
			break;
			
			case "QLIST_GOCYCLING":
				if(curarg)
				{
					var oFORM = new FORM();
					var oPARSE = new oFORM.PARSE();
					oPARSE.get(_templdat[_enumtmpl["BODY"]]);
					var formvalue = new Array();
					for(var j=0;j<oPARSE.unames.length;j++)
						formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;
						
					var searchclause = " and (0 ";
					searchclause += formvalue["datejj"]&&formvalue["datemm"]&&formvalue["dateaa"]?(" or DATE(ds_datetime01) = \""+formvalue["dateaa"]+"-"+formvalue["datemm"]+"-"+formvalue["datejj"]+"\""):"";
					searchclause += formvalue["localite"]?(" or ds_title like \"%"+formvalue["localite"]+"%\""):"";
					searchclause += formvalue["denomination"]?(" or ds_desc like \"%"+formvalue["denomination"]+"%\""):"";
					searchclause += ")"				
				}
				
				
			case "QLIST":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					//var ds = curarg.substring(curarg.indexOf("\"")+1,curarg.indexOf(",")-1).toString().decrypt("nicnac")
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"].toString().decrypt("nicnac"):ds
					
					if(typeof(searchclause)!="string" && searchclause)
					{
						var oFORM = new FORM();
						var oPARSE = new oFORM.PARSE();
						oPARSE.get(_templdat[_enumtmpl["BODY"]]);
						var formvalue = new Array();
						for(var j=0;j<oPARSE.unames.length;j++)
							formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;
						
						var searchclause = "";
					}
					else
						var searchclause = "";
					
					// R E A D   M E T A   D A T A
					
					var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
					var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+ds;
					var dataset = _oDB.getrows(sSQL);
					
					if(bDebug)
						Response.Write(sSQL+"<br>")
					
					var enumdatafld = new Array();
					for (var j=0; j<datafld.length ; j++)
						enumdatafld[datafld[j]] = j;	
						
					// R E A D   X M L   H E A D E R S E T
					
					if(bDebug)
						Response.Write("QLIST XML "+Server.HTMLEncode(dataset[enumdatafld["rev_header"]])+"<br>");
					
					var XMLObj = loadXML(dataset[enumdatafld["rev_header"]]);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var header = new Array();
					var enumheader = new Array();
					for(var j=0;j<hfields.length;j++)
					{
						header[j] = hfields.item(j).text
						//Response.Write(header[j]+" "+hfields.item(j).getAttribute("name")+"<br>")
						curarg = curarg.replace(new RegExp("\\["+header[j].substring(1,header[j].length-1)+"\\]","g"),hfields.item(j).getAttribute("name")  ) 
					}
					
					// SPECIAL INSTRUCTIONS
					//curarg = curarg.replace(new RegExp("\\[0\\]","g"),"ds_id"); 
					
					
					curarg = HTMLDecode(curarg).replace(new RegExp(String.fromCharCode(160),"g")," ") // OTHERWISE, THE QUERY WILL NOT RUN
					
					var argset = argparser(curarg);   // PARSE INITIALISATION PARAMETERS
					
					var curargarr = csv2array(curarg);
					var curargarr = curargarr.slice(1,curargarr.length);
					
					var sSQL = new String("select "+curargarr.join(",")+" from "+_db_prefix+"dataset where ds_rev_id="+ds+" and (ds_pub & 1) = 1 " + searchclause + (argset["orderby"]?(" order by "+argset["orderby"]):""));
					var dat = _oDB.getrows(sSQL.toString());
					
					if(bDebug)
						Response.Write(sSQL+"<br>")
					
					var r = new Array();
					for(var j=0;j<dat.length;j+=curargarr.length)
					{
						var row = Math.round(j/curargarr.length);
						r[row] = "<TR><TD>"+dat.slice(j,j+curargarr.length).join("</td><td>")+"</TD></TR>\r\n";
					}
					_templdat[i] =   r.length>0?r.join("\r\n"):" ";
				}
				//Response.Write(_templdat[i]+"*")
			break;

			case "QTLIST":
				if(curarg)
				{
					//bDebug = true;
					var arg = argparser(curarg);
					//bDebug = false;
					
					arg["select"] = unescape(arg["select"]);
					
					
					// REPLACE VALUES BETWEEN BARCETS WITH TABLE DATA
					
					
					// R E A D   M E T A   D A T A
					
					var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
					var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+arg["ds"];
					var dataset = _oDB.getrows(sSQL);
					
					if(bDebug)
						Response.Write(sSQL+"\r\n<br>")
					
					var enumdatafld = new Array();
					for (var j=0; j<datafld.length ; j++)
						enumdatafld[datafld[j]] = j;	
						
					// R E A D   X M L   H E A D E R S E T
					
					if(bDebug)
						Response.Write("QLIST XML "+Server.HTMLEncode(dataset[enumdatafld["rev_header"]])+"<br>");
					
					var XMLObj = loadXML(dataset[enumdatafld["rev_header"]]);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var header = new Array();
					var enumheader = new Array();
					for(var j=0;j<hfields.length;j++)
					{
						header[j] = hfields.item(j).text
						//Response.Write(header[j]+" "+hfields.item(j).getAttribute("name")+"<br>");
						
						
						var _from = "\\["+header[j].substring(1,header[j].length-1)+"\\]"
						var _to   = hfields.item(j).getAttribute("name")
						
						for(k=0;arg[k];k++)
							arg[arg[k]] = arg[arg[k]].replace(new RegExp(_from,"g"),_to);
						
					}

					
					var searchclause = "";
					var selectarr = csv2array(arg["select"])
					
					var sSQL = new String("select "+selectarr.join(",")+" from "+_db_prefix+"dataset where ds_rev_id="+arg["ds"]+" and (ds_pub & 1) = 1 " + searchclause + (arg["orderby"]?(" order by "+arg["orderby"]):""));
					
					//Response.Write(sSQL)
					
					var dat = _oDB.getrows(sSQL.toString());
					
					if(bDebug)
						Response.Write(sSQL+"<br>")
					
					var r = new Array();
					for(var j=0;j<dat.length;j+=selectarr.length)
					{
						var row = Math.round(j/selectarr.length);
						r[row] = "<TR><TD>"+dat.slice(j,j+selectarr.length).join("</td><td>")+"</TD></TR>\r\n";
					}
					_templdat[i] =   r.length>0?r.join("\r\n"):" ";


				}
			break;	

			
			case "QULIST":
				if(curarg)
				{

					curarg = unescape(curarg.substring(1,curarg.length-1));
					
					//Response.Write("\r\n\r\n"+curarg+"\r\n\r\n")
					
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					//var ds = curarg.substring(curarg.indexOf("\"")+1,curarg.indexOf(",")-1).toString().decrypt("nicnac");
					
					
					bDebug = true;
					//var curargarr = csv2array(curarg);
					var argset = argparser(curarg);
					bDebug = false;
					
					
					var ds = argset["ds"]?argset["ds"].toString().decrypt("nicnac"):ds
					
					if(typeof(searchclause)!="string" && searchclause)
					{
						var oFORM = new FORM();
						var oPARSE = new oFORM.PARSE();
						oPARSE.get(_templdat[_enumtmpl["BODY"]]);
						var formvalue = new Array();
						for(var j=0;j<oPARSE.unames.length;j++)
							formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;
						
						var searchclause = "";
					}
					else
						var searchclause = "";
					
					// R E A D   M E T A   D A T A
					
					var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
					var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+ds;
					var dataset = _oDB.getrows(sSQL);
					
					//if(bDebug)
						Response.Write(sSQL+"\r\n<br>")
					
					var enumdatafld = new Array();
					for (var j=0; j<datafld.length ; j++)
						enumdatafld[datafld[j]] = j;	
						
					// R E A D   X M L   H E A D E R S E T
					
					if(bDebug)
						Response.Write("QLIST XML "+Server.HTMLEncode(dataset[enumdatafld["rev_header"]])+"<br>");
					
					var XMLObj = loadXML(dataset[enumdatafld["rev_header"]]);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var header = new Array();
					var enumheader = new Array();
					for(var j=0;j<hfields.length;j++)
					{
						header[j] = hfields.item(j).text
						//Response.Write(header[j]+" "+hfields.item(j).getAttribute("name")+"<br>")
						curarg = curarg.replace(new RegExp("\\["+header[j].substring(1,header[j].length-1)+"\\]","g"),hfields.item(j).getAttribute("name")  ) 
					}
					
					// SPECIAL INSTRUCTIONS
					//curarg = curarg.replace(new RegExp("\\[0\\]","g"),"ds_id"); 
					
					
					curarg = HTMLDecode(curarg).replace(new RegExp(String.fromCharCode(160),"g")," ") // OTHERWISE, THE QUERY WILL NOT RUN
					
					var argset = argparser(curarg);
					
					var curargarr = csv2array(curarg);
					var curargarr = curargarr.slice(1,curargarr.length);
					
					var sSQL = new String("select "+curargarr.join(",")+" from "+_db_prefix+"dataset where ds_rev_id="+ds+" and (ds_pub & 1) = 1 " + searchclause + (argset["orderby"]?(" order by "+argset["orderby"]):""));
					
					if(bDebug)
						Response.Write(sSQL+"*<br>")
					
					var dat = _oDB.getrows(sSQL.toString());
					

					
					var r = new Array();
					for(var j=0;j<dat.length;j+=curargarr.length)
					{
						var row = Math.round(j/curargarr.length);
						r[row] = "<TR><TD>"+dat.slice(j,j+curargarr.length).join("</td><td>")+"</TD></TR>\r\n";
					}
					_templdat[i] =   r.length>0?r.join("\r\n"):" ";
					

				}
				
				
				//Response.Write(_templdat[i]+"*")
			break;
			
			case "SAVEDATASET":
			case "SIMSAVEDATASET":
				
				var sim = "SIMSAVEDATASET";
				
				//var ds = Request.QueryString("D").Item?Request.QueryString("D").Item.toString().decrypt("nicnac"):0;
				var oFORM = new FORM();
				var oPARSE = new oFORM.PARSE();
				oPARSE.get(_templdat[_enumtmpl["BODY"]]);
				var curargarr = csv2array(curarg);
				
				//var formvalue = new Array();
				//for(var j=0;j<oPARSE.unames.length;j++)
				//	formvalue[oPARSE.unames[j]] = Request.Form(oPARSE.unames[j]).Item;	
				
				// R E A D   M E T A   D A T A
				
				var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
				var sSQL = "select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+_ds;
				var dataset = _oDB.getrows(sSQL);
				
				var enumdatafld = new Array();
				for (var j=0; j<datafld.length ; j++)
					enumdatafld[datafld[j]] = j;					
				
				// R E A D   X M L   H E A D E R S E T
				
				var XMLObj = loadXML(dataset[enumdatafld["rev_header"]]);
				var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
				
				var header = new Array();
				var enumheader = new Array();
				for(var j=0;j<hfields.length;j++)
				{
					header[j] = hfields.item(j).text;
					var hID = header[j] ? Number(header[j].replace(/\[([0-9]+)\]/,"$1")) : ""
					enumheader[hID] = hfields.item(j).getAttribute("name");
				}						
				
				// R E A D   X M L   D A T A S E T
				
				var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
				var dsfld  = new Array("ds_id","ds_rev_id","ds_title","ds_desc","ds_header","ds_datetime01","ds_num01","ds_num02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
				
				var XMLObj = loadXML(dataset[enumdatafld["rev_rev"]]);
				var fields = XMLObj.getElementsByTagName("ROOT/row/field");
				var enumformID = new Array();
				var enumds = new Array();
				
				//var dsid = _oDB.takeanumber(_db_prefix+"dataset");
				var dsid = _oDB.get("select MAX(ds_id) from "+_app_db_prefix+"dataset where ds_rev_id = "+_ds);
				dsid = dsid ? Number(dsid+1) : 1;
				
				var k = 0;
				var arr = new Array();
				for(var j=0;j<fields.length;j++)
				{
					var name    = fields.item(j).getAttribute("name");
					var fieldID = fields.item(j).text ? Number(fields.item(j).text.replace(/\[([0-9]+)\]/,"$1")) : "";
					var value   = Request.Form(name).Item;
					if(bDebug)
						Response.Write("FORM FETCH '"+name+"' '"+fieldID+"' '"+value+"'<br>");
					
					if(value)
					{
						var val = value.replace(/"/g,"\\\"").trim();   // SOLVE QUOTE PROBLEM 
						
						
						//  LITLLE HACK
						if(val && val.toUpperCase()=="{_DATA{DS_ID}_}")
							val = dsid;
						
						
						arr[k++] = _ds+","+fieldID+","+dsid+",\""+val+"\"";   			// DATADETAIL
						enumds[enumheader[fieldID]] = val; 								// DATASET
						
						//Response.Write("enumds["+enumheader[fieldID]+"] = "+value+"<br>");
					}
				}
				
				oDATA.itemo["ds_id"] = dsid;
				oDATA.itemo["ds_num01"] = enumds["ds_num01"];
				
				
				
				if(bDebug)
				{
					Response.Write("oDATA.item[\"ds_id\"] = "+oDATA.itemo["ds_id"]+"<br>")
					Response.Write("oDATA.item[\"ds_num01\"] = "+oDATA.itemo["ds_num01"]+"<br>")			
				}
				
				// S A V E   R A W   D A T A
				
				var iSQL = "insert into "+_db_prefix+"datadetail ("+rawfld.join(",")+") values ("+arr.join("),(")+")";
				
				if(bSQLDebug)
					Response.Write(iSQL+"<br>")
				
				iSQL = replacebeforesave(iSQL);
				
				if(bSQLDebug)
					Response.Write(iSQL+"<br>")
				
				if(curfield != sim)
					_oDB.exec(iSQL);
				
				if(bDebug || curfield == sim)
					Response.Write(iSQL.replace(/\),\(/g , ")</br>,("  ).replace(/\) values \(/gi,") values<br>(")+"<br>");
				
				// S A V E   H E A D E R   D A T A
				
				var data = new Array();
				data[0] = dsid;
				data[1] = _ds;
				data[2] = "\""+(enumds["ds_title"]?enumds["ds_title"]:"")+"\"";
				data[3] = "\""+(enumds["ds_desc"]?enumds["ds_desc"]:"")+"\"";
				data[4] = "\""+(enumds["ds_header"]?enumds["ds_header"]:"")+"\"";
				data[5] = "\""+(enumds["ds_datetime01"]?enumds["ds_datetime01"]:"")+"\"";
				data[6] = enumds["ds_num01"]?enumds["ds_num01"]:"0";
				data[7] = enumds["ds_num02"]?enumds["ds_num02"]:"0";			
				data[8] = "\""+(enumds["ds_data01"]?enumds["ds_data01"]:"")+"\"";
				data[9] = "\""+(enumds["ds_data02"]?enumds["ds_data02"]:"")+"\"";
				data[10] = "\""+(enumds["ds_data03"]?enumds["ds_data03"]:"")+"\"";
				data[11] = "\""+(enumds["ds_data04"]?enumds["ds_data04"]:"")+"\"";
				data[12] = "\""+(enumds["ds_data05"]?enumds["ds_data05"]:"")+"\"";
				data[13] = "\""+(enumds["ds_data06"]?enumds["ds_data06"]:"")+"\"";	
				data[14] = 0;
				
				if(bDebug)
					for(var k=0;k<data.length;k++)
						Response.Write("data["+k+"] = "+data[k]+"<br>")
				
				iSQL = "insert into "+_db_prefix+"dataset ("+dsfld.join(",")+") values (" + data.join(",") + ")";
				
				if(bSQLDebug)
					Response.Write(iSQL+"<br>")				
				
				iSQL = replacebeforesave(iSQL);
				
				if(bSQLDebug)
					Response.Write(iSQL+"<br>")			
				
				Response.Write("<!--"+Server.HTMLEncode(iSQL)+"-->")
				
				if(curfield != sim)
					_oDB.exec(iSQL);
					
				if(bDebug || curfield == sim)
					Response.Write(iSQL+"<br>");
					
				_templdat[i] = " ";
			break;
			
			case "UPDATEDATASET":
				_templdat[i] = " ";
			break;
			
			case "EMAILDATASET":
			case "SIMEMAILDATASET":
			var sim = "SIMEMAILDATASET";
			
				// T O D O   F E T C H   F O R M   D A T A ,   U N E S C A P E   A N D   P A R S E   A R G U M E N T S
				function parsemail(str)
				{
					var parsemail_enum = new Array();
					//var parsemail_arr = str.split(new RegExp(params.join("|")));
					
					str = str.replace(/\?/,"&");
					str = str.replace(/(mailto):/i,"&$1=$1=");
					str = str.replace(/&(from)=/i,"&$1=$1=");
					str = str.replace(/&(subject)=/i,"&$1=$1=");
					str = str.replace(/&(sender)=/i,"&$1=$1=");
					str = str.replace(/&(cc)=/i,"&$1=$1=");
					str = str.replace(/&(bcc)=/i,"&$1=$1=");
					str = str.replace(/&(att)=/i,"&$1=$1=");
					str = str.replace(/&(body)=/i,"&$1=$1=");
					
					
					var parsemail_arr = str.split(/&mailto=|&from=|&subject=|&sender=|&cc=|&bcc=|&att=|&body=/);
					
					//Response.Write(parsemail_arr.join("<br>"))
					
					for(var parsemail_i=0;parsemail_i<parsemail_arr.length;parsemail_i++)
					{
						var pargs =  parsemail_arr[parsemail_i];
						var val = pargs.substring(pargs.indexOf("=")+1,pargs.length)
						parsemail_enum[pargs.substring(0,pargs.indexOf("="))] = val?val:"";
					}
					return parsemail_enum;
				}
				
				var emailarg = new Array();
				if(curarg)
				{
					var arr = csv2array(curarg);
					if(arr.length==1)
					{
						var formarg = Request.Form(arr[0]).Item;
						emailarg = parsemail(replacebeforesave(unescape(formarg)));
						
						//Response.Write(Server.HTMLencode(unescape(formarg))+"<br><br>")
						if(bDebug || sim==curfield)
						{
							Response.Write("mailto="+emailarg["mailto"]+"<br><br>");
							Response.Write("from="+emailarg["from"]+"<br><br>");
							Response.Write("subject="+oDATA.parse(emailarg["subject"])+"<br><br>");
							Response.Write("sender="+emailarg["sender"]+"<br><br>");
							Response.Write("cc="+emailarg["cc"]+"<br><br>");
							Response.Write("bcc="+emailarg["bcc"]+"<br><br>");
							Response.Write("att="+emailarg["att"]+"<br><br>");
							Response.Write("body="+emailarg["body"]+"<br><br>");
						}
					}
				}
				
				var Mail = Server.CreateObject("Persits.Mailsender");
				Mail.Host     	= "blackbaby.org";
				Mail.LogonUser ("blackbaby.org", "MXadmin", "xxlmxadmin");
				Mail.From 	  	= emailarg["from"];
				Mail.FromName   = emailarg["sender"];
				Mail.Subject 	= oDATA.parse(emailarg["subject"]);
				Mail.Body 		= emailarg["body"];
				
				
				if(emailarg["mailto"])
				{
					var mailtoarr = emailarg["mailto"].split(",")
					for(var j=0;j<mailtoarr.length;j++)
					{
						Mail.AddAddress(mailtoarr[j]);
						if(bDebug || sim==curfield)
							Response.Write("Mail.AddAddress("+mailtoarr[j]+");<br>")
					}
				}
				
				if(emailarg["cc"])
				{
					var ccarr = emailarg["cc"].split(",")
					for(var j=0;j<ccarr.length;j++)
					{
						Mail.AddCC(ccarr[j]);
						if(bDebug || sim==curfield)
							Response.Write("Mail.AddCC("+ccarr[j]+");<br>")
					}
				}
				
				if(emailarg["bcc"])
				{
					var bccarr = emailarg["bcc"].split(",")
					for(var j=0;j<bccarr.length;j++)
					{
						Mail.AddBcc(bccarr[j]);
						if(bDebug || sim==curfield)
							Response.Write("Mail.AddBcc("+bccarr[j]+");<br>")
					}
				}
				
				if(emailarg["att"])
				{
					var attarr = emailarg["att"].split(",")
					for(var j=0;j<attarr.length;j++)
					{
						attarr[j] = attarr[j]?(Server.MapPath("../"+_ws+"/")+"\\"+attarr[j].replace(new RegExp("/","g"),"\\")):""
						
						Mail.AddAttachment(attarr[j]);
						if(bDebug || sim==curfield)
							Response.Write("Mail.AddAttachment('"+attarr[j]+"')<br>");
					}
				}				
				
				Mail.Queue 	= true;
					
				try
				{	
					if(curfield!=sim)
						Mail.Send();
				}
				catch (e)
				{
					var returnpage = "index.asp";
					Response.Write("<BR><BR><CENTER>Mail sender failed,<BR><BR> " + (e.number & 0xFFFF).toString(16) + " " + e.description + "<BR><BR> please contact <a href=mailto:blackbaby@pandora.be>administrator</a><BR><BR><INPUT type='button' value='Back' onclick=document.location='"+returnpage+"' id='button'1 name='button'1></CENTER>");
					Response.End();
				}					
				
				
				_templdat[i] = " " ;
			break;
			case "TAS_WHATSNEW":
				_templdat[i] = "<style>\r\n"
						+"a.more:link { color: #469;; text-decoration: none; border-bottom: 1px dotted #bbb; }\r\n"
						+"a.more:visited { color: #54A; text-decoration: none; border-bottom: 1px dotted #bbb; padding-right: 7px; background: url(../images/more-blue.gif) no-repeat 100% 5px; font-family:Lucida Grande, Trebuchet MS, Verdana, sans-serif;font-size:110%;font-weight:bold; }\r\n"
						+"a.more:hover { color: #024; border-bottom-style: solid;font-family:Lucida Grande, Trebuchet MS, Verdana, sans-serif;font-size:110%;font-weight:bold; }\r\n"
						+"a.more { font-family:Lucida Grande, Trebuchet MS, Verdana, sans-serif;font-size:110%;font-weight:bold;padding-right: 7px; background: url(../images/more-blue.gif) no-repeat 100% 5px;}\r\n"
						+"</style>\r\n"
				+"<table><tr><td style=\"text-align:left\" class=body>"
				+"<a href=\"publications/articles\" title=\"Markup and Style articles\" class=\"more\">Kunst in Amerika</a><br>"
				+"Deze reeks geeft een overzicht van invloedrijke kunstenaars en kunstromingen in Amerika.<br>"
				+"<table cellspacing=\"0\" cellpadding=\"0\"><tr><td class=small style=\"padding:3px 0px 8px 0px\"><img src=\"../images/ii_permalink.gif\" title=\"Permanente link naar dit artikel\"> 21 Dec 2005</td></tr></table>"
				
				+"<a href=\"publications/interviews\" title=\"Interviews with Dan\" class=\"more\">Interviews</a><br>"
				+"Kom regelmatig terug op deze rubriek, en ontdek een nieuw of recent vertaald interview.<br>"
				+"<table cellspacing=\"0\" cellpadding=\"0\"><tr><td class=small style=\"padding:3px 0px 8px 0px\"><img src=\"../images/ii_permalink.gif\" title=\"Permanente link naar dit artikel\"> 06 Dec 2005</td></tr></table>"
				
				//+"<a href=\"publications/interviews\" title=\"Interviews with Dan\" class=\"more\">Laatste artikels</a><br>"
				
				+"<a href=\"publications/interviews\" title=\"Interviews with Dan\" class=\"more\">KunstQuiz</a><br>"
				+"Test je hier kunstkennis online, en leer elke dag iets bij.  Terugkeren is de boodschap, regelmatig komen er vragen bij.<br>"
				+"<table cellspacing=0 cellpadding=0><tr><td class=small style=\"padding:3px 0px 8px 0px\"><img src=\"../images/ii_permalink.gif\" title=\"Permanente link naar dit artikel\"> 01 Dec 2005</td></tr></table>"				


/*
				var _tasdb_prefix = "tas_nlbe_"
		
				var catimg = new Array("ii_home.gif","ii_gallery.gif","ii_articles.gif","ii_music.gif","ii_agenda.gif","ii_film.gif","ii_interview.gif","ii_magazines.gif","ii_books.gif","ii_favorites.gif");
				var cattitle = new Array("portaal"      ,"galerie"        ,"artikels"        ,"muziek"     ,"agenda"        ,"films"      ,"interviews"      ,"magazines"       ,"boeken"      ,"favorieten");
		
				//   TAS CHOICE   =  A R T I K E L S   +  M U Z I E K   +   B O E K E N  +   F A V O R I E T E N
		
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_date_published"," rev_rt_typ","rev_actimg","rev_pub","''")		
				var extraSQL = " order by rev_date_published desc  LIMIT 0,3";
				
				var SQL = "select "+tablefld.join(",")+" from "+_tasdb_prefix+"review where (rev_pub & 1) = 1 and (rev_pub & 2) = 2 and rev_rt_typ <> 4 and rev_rt_typ <> 13 "+extraSQL+" ";
		
				var overview = _oDB.getrows( SQL );
				var r = 0;
				
				_templdat[i] += "<table class=\"small\" cellpadding=0 cellspacing=0 border=0>\r\n"
				_templdat[i] += "<COLGROUP><COL width=70 align=right valign=top></COL><COL width=5></COL><COL valign=top></COL></COLGROUP>\r\n"
				_templdat[i] += "<tr><td colspan=3><img src=../images/spc.gif width=6 height=6></td></tr>"
		
		
				for (var j=0; j<overview.length;j+=tablefld.length)
				{
					//var relurl = zerofill(overview[j+4],2)+"_detail.asp?id="+overview[j].toString().encrypt("nicnac");
					var relurl = zerofill(overview[j+4],2)+"_detail_Q_id_E_"+overview[j].toString().encrypt("nicnac")+".asp";
		
					if(overview[j+4]==9)
						var relurl = "09_index.asp#"+base64encode(overview[j].toString());
		
					var linkurl = "http://www.theartserver.be/theartserver/"+_language+"/" + relurl;
		
					var from = "<a href="+zerofill(overview[j+4],2)+"_index.asp><img src=\"../images/"+catimg[overview[j+4]]+"\" align=left title=\""+cattitle[overview[j+4]]+"\" hspace=2 border=0></a>";
					if (typeof(overview[j+3])=="date")
					{
						from += new Date(overview[j+3]).format("%d %b","nl-be");
						var ynow = new Date().format("%Y");
						var yfrom = new Date(overview[j+3]).format("%Y");
						if ( yfrom && ynow != yfrom )
							from += " <br></b><span class=voetnoot>" + yfrom + "</span><b>";
					}
					var txt =  "<a href=\""+relurl+"\" title=\""+overview[j+2]+"\">" + (overview[j+1]?overview[j+1].substring(0,85):"") + "</a>";
					_templdat[i] += "<tr><td>"+from+"</td><td></td><td>"+txt+"<br><br></td></tr>\r\n";
				}
*/
				_templdat[i] += "</td></tr></table>\r\n"
			
			break;
			case "TAS_NEWSHEADER":
				_templdat[i]  = "<table><tr><td style=\"text-align:left\">"
				_templdat[i] += "<h2 class=greentag>Laatste persbericht (2u geleden)</h2><a href=\"#\" id=titlelink>Johan van Hell (1889-1952)</a><br>";
				_templdat[i] += "<div class=body style=\"border-bottom:1px solid #eaeaea;margin: 0 0 5 0;padding-bottom:10px;\"><img src='http://www.theartserver.be/theartserver/images/news/img0000007460_1.jpg' style='border:1px solid #000' alt='press image' align='right'>In het Arnhemse Museum voor Moderne Kunst loopt nog tot 12 februari 2006 de tentoonstelling \"Van de straat. Het engagement van Johan van Hell 1889-1952\". Aanvankelijk maakte de sociaal-democratische schilder en tekenaar  Johannes Gerardus Diederik van Hell landschappen en portretten die zich kenmerken door een impressionistische toets. In de jaren twintig ontwikkelde hij de voor hem typerende... <a href=10_more.asp?id=d69f2b700500fc9f#AB0j class=small target=_blank>Lees meer <img src=http://www.theartserver.be/theartserver/images/ii_pijlen.gif alt='lees meer'></a></div>";
				_templdat[i] += "<span class=small><img src=\"../images/ii_permalink.gif\" title=\"Permanente link naar dit artikel\"> 20 Dec 2005 <font color=\"#DADADA\">|</font> <img src=\"../images/ii_comments.gif\" title=\"Link naar de commentaren\"> 320 Commentaren</span>" 
				_templdat[i] += "</td></tr></table>";
			break;
			case "TAS_PUBLICATIONS":
							
			case "ICONTRAY":
			
			_templdat[i] +=
				 "<TABLE style=\"MARGIN-BOTTOM: 10px\" cellSpacing=0 cellPadding=0>"
				+"<TBODY>"
				+"<TR>"
				+"<TD vAlign=top><A "
				+"href=\"http://www.blackbaby.be/usite/sparklingideas_enuk/index_Q_P_E_34.asp\"><IMG "
				+"alt=\"\" hspace=0 "
				+"src=\"http://www.blackbaby.org/usite/sparklingideas/images/i_aboutus.gif\" "
				+"border=0></A> "
				+"<P class=small style=\"TEXT-ALIGN: center\">about us</P></TD>"
				+"<TD vAlign=top><A "
				+"href=\"http://www.blackbaby.be/usite/sparklingideas_enuk/index_Q_P_E_35.asp\"><IMG "
				+"alt=\"\" hspace=0 "
				+"src=\"http://www.blackbaby.org/usite/sparklingideas/images/i_team.gif\" "
				+"border=0></A> "
				+"<P class=small style=\"TEXT-ALIGN: center\">team</P></TD>"
				+"<TD vAlign=top><A "
				+"href=\"http://www.blackbaby.be/usite/sparklingideas_enuk/index_Q_P_E_36.asp\"><IMG "
				+"alt=\"\" hspace=0 "
				+"src=\"http://www.blackbaby.org/usite/sparklingideas/images/i_services.gif\" "
				+"border=0></A> "
				+"<P class=small style=\"TEXT-ALIGN: center\">services</P></TD>"
				+"<TD vAlign=top><A "
				+"href=\"http://www.blackbaby.be/usite/sparklingideas_enuk/index_Q_P_E_37.asp\"><IMG "
				+"alt=\"\" hspace=0 "
				+"src=\"http://www.blackbaby.org/usite/sparklingideas/images/i_events.gif\" "
				+"border=0></A> "
				+"<P class=small style=\"TEXT-ALIGN: center\">events</P></TD>"
				+"<TD vAlign=top><A "
				+"href=\"http://www.blackbaby.be/usite/sparklingideas_enuk/index_Q_P_E_408.asp\"><IMG "
				+"alt=\"\" hspace=0 "
				+"src=\"http://www.blackbaby.org/usite/sparklingideas/images/i_contact.gif\" "
				+"border=0></A> "
				+"<P class=small "
				+"style=\"TEXT-ALIGN: center\">contact</P></TD></TR></TBODY></TABLE>";
				
			break;
			
			case "BOXOPEN":
				if(curarg)
				{
					var arg = argparser(curarg);
					switch(arg["type"])
					{
						case "round":
							_templdat[i] += "\r\n\r\n<table cellspacing=0 cellpadding=0 border=0>"
											+"<tr><td width=4 height=4 background=../images/rbox1.gif></td><td background=../images/rbox5.gif></td><td width=4 height=4 background=../images/rbox2.gif></td></tr>"
											+"<tr><td background=../images/rbox7.gif></td><td bgcolor=#F7F7F7>\r\n\r\n"
						break;
					}
					_templdat[i] += " "
				}
				else
					_templdat[i] += "<div style=\"border: 1px solid #D0D0D5;width:520px;padding:10px;margin:10px\">"
			break;
			
			case "BOXCLOSE":
				if(curarg)
				{
					var arg = argparser(curarg);
					switch(arg["type"])
					{
						case "round":
						       _templdat[i] += "\r\n\r\n</td><td background=../images/rbox8.gif></td></tr>"
											  +"<tr><td width=4 height=4 background=../images/rbox3.gif></td><td background=../images/rbox6.gif></td><td width=4 height=4 background=../images/rbox4.gif></td></tr>"
											  +"</table>\r\n\r\n";
						break;
					}
					_templdat[i] += "";
				}
				else			
					_templdat[i] += "</div>"
			break;
			
			case "SHADOWBOXOPEN":
				_templdat[i] += 	"<table cellpadding=0 cellspacing=0>"
									+"<tr>"
									+"<td><table cellpadding=0 cellspacing=0><tr><td>"
			break;
			
			case "SHADOWBOXCLOSE":
				var argset = argparser(curarg);
				var imgpath = argset["imgpath"]?argset["imgpath"]:"../images/";
				var borderwidth = argset["borderwidth"]?Number(argset["borderwidth"]):15;
				
				if(argset["imgpath"])
				{
					var borderwidth = argset["borderwidth"]?Number(argset["borderwidth"]):15;
					_templdat[i] += "</td></tr></table></td>"
									+"<td valign=top background="+imgpath+"sbox2.gif><img src="+imgpath+"sbox1.gif WIDTH="+borderwidth+" HEIGHT="+borderwidth+"></td>"
									+"</tr>"
									+"<tr>"
									+"<td align=left background="+imgpath+"sbox4.gif><img src="+imgpath+"sbox3.gif WIDTH="+borderwidth+" HEIGHT="+borderwidth+"></td>"
									+"<td><img src="+imgpath+"sbox5.gif WIDTH="+borderwidth+" HEIGHT="+borderwidth+"></td>"
									+"</tr>"
									+"</table>";
				}
				else
				{
					_templdat[i] += "</td></tr></table></td>"
									+"<td valign=top background="+imgpath+"sbox2.gif><img src="+imgpath+"sbox1.gif WIDTH=10 HEIGHT=14></td>"
									+"</tr>"
									+"<tr>"
									+"<td align=left background="+imgpath+"sbox4.gif><img src="+imgpath+"sbox3.gif WIDTH=14 HEIGHT=11></td>"
									+"<td><img src="+imgpath+"sbox5.gif WIDTH=10 HEIGHT=11></td>"
									+"</tr>"
									+"</table>";
				}
			break;	
			
			case "GALLERY":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					
					var txt = "";
					argset["bordercolor"] = argset["bordercolor"]?argset["bordercolor"]:"#000000";
					
					// TODO GET argset["thumb"],argset["dbcol"] AUTOMATICALLY FROM DEF !!!!!!!!!!!!!!!!!
					
					if(argset["thumb"])
					{
						var tablefld = new Array("ds_id","''","''");
						if(argset["bottomtext"])
							tablefld[1] = unescape(argset["bottomtext"]);
						if(argset["toptext"])
							tablefld[2] = unescape(argset["toptext"]);
						
						var sSQL = "select "+tablefld.join(",")+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds
						    +" "+(argset["selfield"]?(     " and CONCAT(\",\","+argset["selfield"]+",\",\")  LIKE \"%,"+Request.QueryString(argset["selarg"])+",%\""  ):"")
							+" and ds_pub&9=1 and "+argset["dbcol"]+"&1=1"+(argset["dborder"]?(" order by IF("+argset["dborder"]+" is null,999999999,"+argset["dborder"]+")"):"")

						var arr = _oDB.getrows(sSQL);
						//Response.Write(sSQL)
						
						var tarr = argset["thumb"].split("-");
						var txtarr = new Array(arr.length);
						var imgpath = argset["imgpath"]?argset["imgpath"]:"../images/";
						var url = "index_Q_P_E_"+(argset["details"]?argset["details"]:rev_rt_cat)+".asp";
						var borderwidth = argset["borderwidth"]?Number(argset["borderwidth"]):15;
						
						for(var j=0;j<arr.length;j+=tablefld.length)
						{
							var leftcol = "";
							var lnk1 = "<a class=gallerylink href=\""+(url?url.replace(/\.asp/,"_A_I_E_"+arr[j]+".asp"):"")+"\">";
							var lnk2 = "</a>";
							
							if(argset["imgpath"])
							{
								txtarr[j] =
								(j>0 && (j%(argset["columns"]))==0 ?"</td></tr><tr><td>":"")
								+"<TABLE cellSpacing=0 cellPadding=0 align=left>"
								+"<TR>"
								+	"<TD>"
								+		"<TABLE cellSpacing=0 cellPadding=0>"
								+		"<TR>"
								+			"<TD width=100>"
								+				"<TABLE height=100 cellSpacing=0 cellPadding="+borderwidth+">"
								+				"<TR>"
								+					"<TD bgColor="+argset["bordercolor"]+">"
								+						"<CENTER>"
								+                       lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(arr[j],6)+"_"+zerofill(tarr[0],3)+"_"+tarr[1]+".jpg' border=0>"
								+						(arr[j+1]?arr[j+1]:"<br>")
								+                       lnk2+"</CENTER>"
								+			        "</TD>"
								+				"</TR>"
								+				"</TABLE>"
								+			"</TD>"
								+		"</TR>"
								+		"</TABLE>"
								+	"</TD>"
								+	"<TD vAlign=top background="+imgpath+"sbox2.gif><IMG height=15 src="+imgpath+"sbox1.gif width=15></TD>"
								+"</TR>"
								+"<TR>"
								+	"<TD align=left background="+imgpath+"sbox4.gif><IMG height=15 src="+imgpath+"sbox3.gif width=15></TD>"
								+	"<TD><IMG height=15 src="+imgpath+"sbox5.gif width=15></TD>"
								+"</TR>"
								+"</TABLE>"							
							}
							else
							{
								txtarr[j] =
								(j>0 && (j%(argset["columns"]))==0 ?"</td></tr><tr><td>":"")
								+"<TABLE cellSpacing=0 cellPadding=0 align=left>"
								+"<TR>"
								+	"<TD>"
								+		"<TABLE cellSpacing=0 cellPadding=0>"
								+		"<TR>"
								+			"<TD width=100>"
								+				"<TABLE height=100 cellSpacing=0 cellPadding=1 width=150>"
								+				"<TR>"
								+					"<TD bgColor="+argset["bordercolor"]+"><BR>"
								+						"<CENTER>"
								+                       lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(arr[j],6)+"_"+zerofill(tarr[0],3)+"_"+tarr[1]+".jpg' border=0>"
								+						"<br>"+(arr[j+1]?arr[j+1]:"<br>")
								+                       lnk2+"</CENTER>"
								+			        "</TD>"
								+				"</TR>"
								+				"</TABLE>"
								+			"</TD>"
								+		"</TR>"
								+		"</TABLE>"
								+	"</TD>"
								+	"<TD vAlign=top background="+imgpath+"sbox2.gif><IMG height=14 src="+imgpath+"sbox1.gif width=10></TD>"
								+"</TR>"
								+"<TR>"
								+	"<TD align=left background="+imgpath+"sbox4.gif><IMG height=11 src="+imgpath+"sbox3.gif width=14></TD>"
								+	"<TD><IMG height=11 src="+imgpath+"sbox5.gif width=10></TD>"
								+"</TR>"
								+"</TABLE>"
							}
						}
					}
					
					_templdat[i] += "<table><tr><td>"+txtarr.join("</td><td>")+"</td></tr></table>";
				}
			break;
			case "GALLERYDETAIL":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					var nr = Request.QueryString("I").Item;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					var pubcond = argset["pubcond"]?argset["pubcond"].split("-"):new Array(9,1);
					nr = argset["nr"]?argset["nr"]:nr;
					nr = nr=="random"?_oDB.get("select ds_id from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+" and ds_pub&"+pubcond[0]+"="+pubcond[1]+" ORDER BY RAND() LIMIT 1"):Number(nr);
					var attr = argset["attr"]?unescape(argset["attr"]):"border=0";
					//Response.Write(nr+"*<br>")
					
					if(argset["thumb"])
					{
						//var sSQL = "select ds_title from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+" and ds_pub&9=1 and "+argset["dbcol"]+"&1=1 and ds_id = "+nr
						//var arr = _oDB.getrows(sSQL);
						
						var lnk1="";
						var lnk2="";
						var tarr = argset["thumb"].split("-");
						
						_templdat[i] += "<IMG style='FILTER: blendTrans(duration=0.8)' src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+tarr[1]+".jpg' "+attr+">"
					}
				}
				
			break;
			
			case "DATACACHE":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					var nr = Request.QueryString("I").Item;
					
					//Response.Write(curarg+" "+argset["ds"])
					
					oDATA.namecache_enum["length"] = typeof(oDATA.namecache_enum["length"])=="number"?(oDATA.namecache_enum["length"]+1):1;
					var key = curfield+"_"+(argset["cache"]?argset["cache"]:oDATA.namecache_enum["length"]);
					
					//---------------------------------------------------------
					
					var sSQL = "select rd_dt_id,rd_text from "+_app_db_prefix+"datadetail where rd_ds_id = "+ds+(nr?(" and rd_recno = "+nr):"");
					var arr = _oDB.getrows(sSQL);
					
					//Response.Write(sSQL+"<br>")
					
					// FILL CACHE DATA WITH DATADETAIL
					oDATA.namecache_data[key] = new Array();					
					for(var j=arr.length-2;j>=0;j-=2)
					{
						oDATA.namecache_data[key][arr[j]] = arr[j+1];
						//Response.Write("oDATA.namecache_data["+key+"]["+arr[j]+"] = "+arr[j+1]+"<br>")
					}
					
					oDATA.namecache_data[key][0] = ds;
					
					
					//Response.Write(oDATA.namecache_data["DATACACHE_1"][11]+"#<br><br>")			
					//---------------------------------------------------------
					
					// R E A D   X M L   H E A D E R S E T
					var sSQL = "select rev_header from "+_db_prefix+"review where rev_id = "+ds;
					var rev_header = _oDB.get(sSQL);
					
					var XMLObj = loadXML(rev_header);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var arr = new Array();
					for(var j=0;j<hfields.length;j++)
					{
						var fid = hfields.item(j).text.toString();
						arr[j] = fid.substring(1,fid.length-1)+","+hfields.item(j).getAttribute("name");
					}					
					
					var sSQL = "select "+arr.join(",")+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+(nr?(" and ds_id = "+nr):"");
					//Response.Write(sSQL);
					
					var arr = _oDB.getrows(sSQL);
					
					// FILL CACHE DATA WITH DATASET
					//oDATA.namecache_data[key] = new Array();					
					for(var j=arr.length-2;j>=0;j-=2)
					{
						oDATA.namecache_data[key][arr[j]] = arr[j+1];
						//Response.Write("oDATA.namecache_data["+key+"]["+arr[j]+"] = "+arr[j+1]+"<br><br>")
					}
					//Response.End();
					//Response.Write(oDATA.namecache_data["DATACACHE_1"][11]+"#<br><br>")			
					
					//---------------------------------------------------------
					
					var tablefld  = oDATA.namecache_flds[key];
					var enumfld   = oDATA.namecache_enum[key];
					var overview  = oDATA.namecache_data[key];
					
					
					if(bDebug)
					{
						Response.Write("<small>");
						Response.Write("tablefld   = oDATA.namecache_flds[\""+key+"\"]; ("+tablefld+")<br>");
						Response.Write("enumfld   = oDATA.namecache_enum[\""+key+"\"]; ("+enumfld+")<br>");
						Response.Write("overview   = oDATA.namecache_flds[\""+key+"\"]; ("+overview+")<br>");
						Response.Write("</small>");
					}
					
					
					_templdat[i] += "<!--DATACACHE{"+curarg+"}-->";
				}
			break;
			
			case "XDATA":
			case "DATA":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds     = argset["ds"]?argset["ds"]:ds;
					var nr     = Request.QueryString("I").Item;
					var args   = argparser(curarg);
					var idxa   = args["id"]?args["id"].toString().split("."):0; 
					var key    = "DATACACHE_"+(idxa[1]?(idxa[1]+"_"):"1");
					var val    = curfield=="XDATA"?oDATA.namecache_data[key][idxa[0]]:Server.HTMLEncode(oDATA.namecache_data[key][idxa[0]]).replace(/'/g,"&#39;");
					var tarr   = argset["thumb"]?argset["thumb"].split("-"):"";
					
					//Response.Write(val.toLowerCase().indexOf("<body")+" "+val.toLowerCase().indexOf("</body"));
					
					switch(argset["type"])
					{
						case "csv":   _templdat[i] += val?unescape(val.split(",")[argset["n"]?argset["n"]:0]):" "; break;
				                case "http":   _templdat[i] += val.indexOf("http://")==0?val:("http://"+val); break;		
                                                case "img":   _templdat[i] += "<img src='../"+_ws+"/images/img"+zerofill(oDATA.namecache_data[key][0],10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(tarr[1],2)+"_"+tarr[2]+".jpg' border=0>"; break;
						case "url":   _templdat[i] += val.split(",")[argset["n"]?argset["n"]:0]?("<a href=index_Q_P_E_"+argset["details"]+"_A_I_E_"+val.split(",")[argset["n"]?argset["n"]:0]+".asp>"):"<a>"; break;
						case "date":  _templdat[i] += val?new Date(val.split(",")[argset["n"]?argset["n"]:0]).format(argset["format"],_isolanguage):" "; break;						
						default: 	   _templdat[i] += val?val:"";
					}
				}
			break;
			
			case "FORM":
				if(curarg)
				{
					var argset = argparser(curarg);
					var ds     = argset["ds"]?argset["ds"]:0;
					var nr     = Request.QueryString("I").Item;
					var args   = argparser(curarg);
					var idxa   = args["id"]?args["id"].toString().split("."):0; 
					var key    = "DATACACHE_"+(idxa[1]?(idxa[1]+"_"):"1");
					var val    = oDATA.namecache_data[key][idxa[0]];
					var tarr   = argset["thumb"]?argset["thumb"].split("-"):"";
					
					var curfieldID = args["id"];
					var filepath = "../"+_ws+"/images";
					
					_templdat[i] += val?val:"";
				}
			break;

			case "GALLERYREQ":
				if(curarg)
				{
					var argset = argparser(curarg);
					var ds     = argset["ds"]?argset["ds"]:0;
					var nr     = Request.QueryString("I").Item;
					var args   = argparser(curarg);
					var idxa   = args["id"]?args["id"].toString().split("."):0; 
					var key    = "DATACACHE_"+(idxa[1]?(idxa[1]+"_"):"1");
					var val    = curfield=="XDATA"?oDATA.namecache_data[key][idxa[0]]:Server.HTMLEncode(oDATA.namecache_data[key][idxa[0]]).replace(/'/g,"&#39;");
					var tarr   = argset["thumb"]?argset["thumb"].split("-"):"";
					
					var curfieldID = args["id"];
					var filepath = "../"+_ws+"/images";
					
					var filebase    = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3);
					var fs			= Server.CreateObject("Scripting.FileSystemObject");
					var source_path	= Server.Mappath("../images/upload")+"\\";
					var dest		= Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
					
					_templdat[i] += "<table><tr>"
					for(var j=0;j<16;j++)
					{
					
					if((j%4)==0 && j>0)
					     _templdat[i]  += "</tr><tr>"
					
					_templdat[i]  +="<td><table cellspacing=0 cellpaddig=0><tr><td><table height=100 width=100 bgcolor=black cellspacing=1 align=left><tr><td style=font-size:12px;background-color:white align=center  background=../arobar/images/img0000001415_000001_"+zerofill(idxa,3)+"_"+zerofill(j,2)+"_0.jpg?"+(Math.floor(Math.random()*10000))+" valign=top>"
								   +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main.portrait.value=main.portrait.value^((1<<(3))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
								   +"<a href=disp.asp?d=%3Chtml%3E%3Cbody%20bgcolor%3Dblack%20leftmargin%3D0%20topmargin%3D0%20rightmargin%3D0%20bottommargin%3D0%3E%3Ctable%20height%3D%27100%25%27%20width%3D%27100%25%27%20cellspacing%3D0%20cellpadding%3D0%3E%3Ctr%3E%3Ctd%20valign%3Dmiddle%20align%3Dcenter%3E%3Cimg%20src%3D../arobar/images/src0000001415_000001_"+zerofill(idxa,3)+".jpg%3F6523%20onclick%3Dwindow.close%28%29%3E%3C/td%3E%3C/tr%3E%3C/table%3E%3C/body%3E%3C/html%3E target=_blank><IMG border='0' name='b0' src='../images/full_green.gif'' onclick='' hspace=3 vspace=2 title='full screen' align=right></a><br><br>JPG<br>Image<br><br>"
								   +"<input SIZE=1 name=FILE"+zerofill(idxa,3)+" type=FILE value=7  onchange=main.portrait.value=(main.portrait.value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">"
								   +"&nbsp;&nbsp;&nbsp;</td></tr></table></td></tr></tr><td><input name=ddd size=12></td></tr></table></td>";
								   

					}
					_templdat[i] += "</table>"
					
				}
			break;		
				
			case "BULKGALLERY":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					var nr = Request.QueryString("I").Item
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					
					
					var txt = "";
					var textarr = new Array();
					
					argset["bordercolor"] = argset["bordercolor"]?argset["bordercolor"]:"#000000";
					
					// TODO GET argset["thumb"],argset["dbcol"] AUTOMATICALLY FROM DEF !!!!!!!!!!!!!!!!!
					
					if(argset["thumb"])
					{
						var sSQL = "select "+argset["dbcol"]+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+" and ds_id = "+nr+" and ds_pub&9=1"
						var arr = _oDB.getrows(sSQL);
						
						var actimg = arr[0];
						var bitlength = actimg==0?0:Number(actimg).toString(2).length;
						
						var tarr = argset["thumb"].split("-");
						var txtarr = new Array(arr.length);
						
						var b=0;
						for(var j=0;j<bitlength;j++)
						{
							if(((actimg>>j)&1)==1)
							{
								var leftcol = "";
								var url = "index_Q_P_E_"+(argset["details"]?argset["details"]:rev_rt_cat)+".asp";
								var lnk1 = "<a class=small href=\""+(url?url.replace(/\.asp/,"_A_I_E_"+nr+"_A_N_E_"+j+".asp"):"")+"\">";
								var lnk2 = "</a>";
								
								txtarr[j] =
								(b>0 && (b%(argset["columns"]))==0 ?"</td></tr><tr><td>":"")
								+"<TABLE cellSpacing=0 cellPadding=0 align=left>"
								+"<TR>"
								+	"<TD>"
								+		"<TABLE cellSpacing=0 cellPadding=0>"
								+		"<TR>"
								+			"<TD width=100>"
								+				"<TABLE height=100 cellSpacing=0 cellPadding=1 width=150>"
								+				"<TR>"
								+					"<TD bgColor="+argset["bordercolor"]+"><BR>"
								+						"<CENTER>"
								+                       lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(j,2)+"_"+tarr[1]+".jpg' border=0>"+lnk2+"</CENTER><BR>"
								//   http://www.blackbaby.be/usite/sparklingideas/images/img0000000990_000001_010_02_0.jpg?3692
								+					"</TD>"
								+				"</TR>"
								+				"</TABLE>"
								+			"</TD>"
								+		"</TR>"
								+		"</TABLE>"
								+	"</TD>"
								+	"<TD vAlign=top background=../images/sbox2.gif><IMG height=14 src=../images/sbox1.gif width=10></TD>"
								+"</TR>"
								+"<TR>"
								+	"<TD align=left background=../images/sbox4.gif><IMG height=11 src=../images/sbox3.gif width=14></TD>"
								+	"<TD><IMG height=11 src=../images/sbox5.gif width=10></TD>"
								+"</TR>"
								+"</TABLE>"
								
								b++;
							}
							
							
						}
					}
					
					_templdat[i] += "<table><tr><td>"+txtarr.join("</td><td>")+"</td></tr></table>";
				}
			break;
			case "BULKGALLERYDETAIL":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					var nr = Request.QueryString("I").Item;
					var sq = Request.QueryString("N").Item;
					var url = "index_Q_P_E_"+rev_rt_cat+".asp";
					
					
					if(argset["thumb"])
					{
						
						//var sSQL = "select ds_title from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+" and ds_pub&9=1 and "+argset["dbcol"]+"&1=1 and ds_id = "+nr
						//var arr = _oDB.getrows(sSQL);
						
						var lnk1="";
						var lnk2="";
						var tarr = argset["thumb"].split("-");
						if(argset["link"]=="next")
						{
							var sSQL = "select "+argset["dbcol"]+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+" and ds_pub&9=1 and ds_id = "+nr;
							var arr = _oDB.getrows(sSQL);
							
							var actimg = arr[0];
							var bitlength = actimg==0?0:Number(actimg).toString(2).length;
							
							var mark = new Array();
							for(var j=0;j<bitlength;j++)
							{
								if(((actimg>>j)&1)==1 && typeof(mark["first"])!="number")
									mark["first"] = j;
								
								if(((actimg>>j)&1)==1 && typeof(mark["next"])!="number" && typeof(mark["current"])=="number")
									mark["next"] = j;
									
								if(((actimg>>j)&1)==1 && j==Number(sq))
									mark["current"] = j;
							}
							mark["next"]=(mark["next"]?mark["next"]:mark["first"])
							
							//Response.Write(mark["current"])
							
							lnk1 = "<a href=\""+(url?url.replace(/\.asp/,"_A_I_E_"+nr+"_A_N_E_"+mark["next"]+".asp"):"")+"\">";
							lnk2 = "</a>"
						}
						
						_templdat[i] += lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(sq,2)+"_"+tarr[1]+".jpg' border=0>"+lnk2;
					}
				}
			break;
			case "BULKGALLERYHREF":
				if(curarg)
				{
					var argset = argparser(curarg);
					var nr = Request.QueryString("I").Item;
					_templdat[i] += "href=index_Q_P_E_"+argset["id"]+"_A_I_E_"+nr+".asp";
				}
			break;
			
			case "AGENDA":
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					var nr = Request.QueryString("I").Item;
					var pubcond = argset["pubcond"]?argset["pubcond"].split("-"):new Array(9,1);
					var tarr = argset["thumb"].split("-");
					var columnwidth = argset["columnwidth"]?argset["columnwidth"]:500;
					var bcolumnsplit = false;
					var url = "index_Q_P_E_"+(argset["details"]?argset["details"]:rev_rt_cat)+".asp";
					
					var sSQL = "select count(*) from "+_app_db_prefix+"dataset where ds_rev_id = "+ds
					+(nr?(" and ds_id = "+nr):"")
					+" and ds_pub & "+pubcond[0]+" = "+pubcond[1];
					var count = Number(_oDB.getrows(sSQL)[0]);
					
					
					
					var maxrec = 100;
					var ipp = argset["ipp"]?Number(argset["ipp"]):10; // ITEMS PER PAGE
					var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):1;
					
					// PAGE NAVIGATOR
					var spp = 15;  // MAX NAVIGATIONBAR WIDTH
					var n = Math.round(count/ipp+0.499);
					var begin = 0;
					
					var pgnav = "";
					if (pag == 0)
						pgnav += "<font color=#800000 title='"+_T["nav_max"]+" "+maxrec+" "+_T["nav_items"]+"'><b>"+_T["nav_all"]+"</b></font>&nbsp;&nbsp; ";
					else
					{
						pgnav += "<a href=?pag=0#subtop title='"+_T["nav_max"]+" "+maxrec+" "+_T["nav_items"]+"' class=small>"+_T["nav_all"]+"</a>&nbsp;&nbsp; ";
						
						if (pag>1)
							pgnav += "<a href=?pag="+(pag-1)+"#subtop><img src=../images/lnav.gif border=0 title='"+_T["nav_prevpage"]+"' style=vertical-align:text-top></A>&nbsp;&nbsp;";
						begin = pag-Math.round(spp/2)<0 ? 0 : (pag-Math.round(spp/2));
						begin = spp/2>(n-pag-1) ? (n-spp) : begin;
						begin = begin<=0 ? 0 : begin;
					}
					
					for( var j=begin+1 ; j <= begin+spp && j <= n ; j++ )
							if (j == pag)
								pgnav += "<font color=#800000><b>["+j+"]</b></font>&nbsp;&nbsp;";
							else
								pgnav += "<a href=?pag="+j+"#subtop class=small>["+j+"]</a>&nbsp; ";
					
					if (pag<n)
						pgnav += "<a href=?pag="+(pag+1)+"#subtop><img src=../images/rnav.gif border=0 title='"+_T["nav_nextpage"]+"' style=vertical-align:text-top></a>";
					
					
					oDATA.namecache_enum["length"] = typeof(oDATA.namecache_enum["length"])=="number"?(oDATA.namecache_enum["length"]+1):1;
					var key = curfield+"_"+(argset["cache"]?argset["cache"]:oDATA.namecache_enum["length"]);				
					oDATA.namecache_data[key] = new Array();	
					
					// R E A D   X M L   H E A D E R S E T
					var sSQL = "select rev_header from "+_db_prefix+"review where rev_id = "+ds;
					var rev_header = _oDB.get(sSQL);
					
					
					
					var XMLObj = loadXML(rev_header);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var arr = new Array();
					var fld = new Array();
					
					fld[0] = 0;
					
					for(var j=0;j<hfields.length;j++)
					{
						fid = hfields.item(j).text.toString();
						fld[fid.substring(1,fid.length-1)] = j+1 
						
						arr[j] = hfields.item(j).getAttribute("name");
					}
					
					var limit = pag==0 ? (" LIMIT 0,"+maxrec) : (" LIMIT "+(pag-1)*ipp+","+ipp);	
					
					var sSQL = "select ds_id,"+arr.join(",")+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds
					+(nr?(" and ds_id = "+nr):"")
					+" and ds_pub & "+pubcond[0]+" = "+pubcond[1]
					+(argset["orderby"]?(" order by "+argset["orderby"]):"")
					+limit;
					
					var overview = _oDB.getrows(sSQL);
					
					_templdat[i] += pgnav
								  +"<br><br>"
					              +"<table cellspacing=0 cellpadding=0>"
								  +"<tr><td width=10></td><td valign=top  width="+columnwidth+"><!--br-->"
					
					var ippl = ipp*fld.length;
					if (pag==0)
						ippl = overview.length>(maxrec*fld.length)?(maxrec*fld.length):overview.length;
					var ipps = pag==0?0:ippl*(pag-1);
					
					for( var j=ipps ; j < (ipps+ippl) && j<overview.length ; j+= fld.length )
					{
						var nr = overview[j+fld[0]];
						var lnk1 = "<a class=small href=\""+(url?url.replace(/\.asp/,"_A_I_E_"+nr+".asp"):"")+"\">";
						var lnk2 = "</a>";	
						
						var imgurl1 = lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(0,2)+"_"+tarr[1]+".jpg' border=0>"+lnk2;
						var imgurl2 = lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(1,2)+"_"+tarr[1]+".jpg' border=0>"+lnk2;
						var imgurl3 = lnk1+"<IMG src='../"+_ws+"/images/img"+zerofill(ds,10)+"_"+zerofill(nr,6)+"_"+zerofill(tarr[0],3)+"_"+zerofill(2,2)+"_"+tarr[1]+".jpg' border=0>"+lnk2;
							
						
						var img = "<table align=right cellspacing=5><tr><td>"+sbox(imgurl1,100)+"</td><td>"+sbox(imgurl2,100)+"</td><td>"+sbox(imgurl3,100)+"</td></tr></table>";
						var fromto = "";
						
						if (typeof(overview[j+fld[3]])=="date")
						{
							fromto += new Date(overview[j+fld[3]]).format("%d %b",_isolanguage);
							var yfrom = new Date(overview[j+fld[3]]).format("%Y");
							var yto = "";
							var ynow = new Date().format("%Y");
							if (typeof(overview[j+fld[4]])=="date")
								if (new Date(overview[j+fld[3]]).format("%d%m%Y") != new Date(overview[j+fld[4]]).format("%d%m%Y"))
								{
									fromto += " - "+new Date(overview[j+fld[4]]).format("%d %b",_isolanguage);
									yto = new Date(overview[j+fld[4]]).format("%Y");
								}
							if (  ynow != yfrom || yto && ynow != yto)
								fromto += " <span class=voetnoot>" + yfrom +( (yto && yfrom!=yto)?("-"+yto):"" ) + "</span>";
						}
						
						_templdat[i] +="<p style=font-family:Arial;>"+img+"<span style=font-size:x-small><b>"+overview[j+fld[1]]+"</b><br><span class=bodybold>"+fromto+"</span><br><br></span><span class=body2>"+overview[j+fld[2]]+" "+lnk1+_T["readmore"]+"&nbsp;&gt;&gt;&gt;</a></span></p><br>\r\n";
						
						var middle = pag==0 ? (Math.round((ippl/fld.length-1.5)/2)*fld.length) : ( ipps+Math.round((ippl/fld.length-1.5)/2)*fld.length )
						if (j == middle && bcolumnsplit==true)
							_templdat[i] += "<br></td><td width=10></td><td width=1 style=background-color:#E0E0E0></td><td width=10></td><td valign=top  width="+columnwidth+"><!--br-->"	
						
					}
					
					_templdat[i] +="</td><td width=10></td></tr>"
								  +"</table>";
					
					//_templdat[i] += pgnav+"<!--DATACACHE{"+curarg+"}-->";
				}
			break;	
			
			case "DYNTITLE":
				if(curarg)
				{
					var fncname = "dyntitle"+zerofill(Math.abs(_oDB.crc32(curarg)),6);
					var argset = argparser(curarg);

					_templdat[i] += "<SCRIPT>\r\n"
					             +  "window.onload = "+fncname+";\r\n"
					             +  "function "+fncname+"(){\r\n";
								 for (key in argset)
									if(key && key!="0")
										_templdat[i] += "document.getElementById('"+key+"').innerHTML = \"" + argset[key]+"\";\r\n";
					_templdat[i] += "}\r\n"
					               +"</SCRIPT>\r\n";
				}
			break;
			
			case "U":
				if(curarg)
				{
					_templdat[i] += unescape(curarg.substring(1,curarg.length-1));
				}				
			break;
			

			case "PAGETITLE":
				if(curarg)
				{
					var argset = argparser(curarg);
					var key = (argset["cache"]?argset["cache"]:curfield)+argset["id"];
					var pubcond = argset["pubcond"]?argset["pubcond"].split("-"):new Array(9,1);
					
					var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub","rev_url");
					var extraSQL = (argset["limit"]?(" LIMIT 0,"+argset["limit"]):"");
					var sSQL = "select "+tablefld.join(",")+" from "+_app_db_prefix+"review"+","+_app_db_prefix+"dataset where ds_rev_id = "+argset["id"]+" and rev_id = ds_rev_id and (ds_pub & "+pubcond[0]+") = "+pubcond[1]+" and rev_dir_lng = '"+_ws+"'"+extraSQL;
					
					var overview = _oDB.getrows( sSQL );
					
					var enumfldd = new Array();					
					for(var j=tablefld.length;j>=0;j--)
							enumfldd[tablefld[j]] = j;
					oDATA.namecache_flds[key] = tablefld;
					oDATA.namecache_enum[key] = enumfldd;
					oDATA.namecache_data[key] = overview;						
					
					if(overview.length>0)
					{
						var imgnr = Number(Request.QueryString("I").Item-1)*tablefld.length;
						_templdat[i] += overview[imgnr+enumfldd["ds_title"]]
									  +"<p class=small>"+overview[imgnr+enumfldd["ds_desc"]]+"</p>";
					}
				}
			break;
			
			case "PAGE":
				if(curarg)
				{
					var arg = argparser(curarg);
					var key = (arg["cache"]?arg["cache"]:"PAGETITLE")+arg["id"];
					var tablefld  = oDATA.namecache_flds[key];
					var enumfld   = oDATA.namecache_enum[key];
					var overview  = oDATA.namecache_data[key];
					
					if(overview && overview.length>0)
					{
						var imgnr = Number(Request.QueryString("I").Item-1)*tablefld.length;
						
						/*
						var template = overview[imgnr+enumfld["ds_header"]];
						
						var oTEMPLATE				= new TEMPLATE();
						oTEMPLATE.namecache_enum	= oDATA.namecache_enum[key];
						oTEMPLATE.param				= arg;
						
						var j = Number(Request.QueryString("I").Item-1)*tablefld.length;
						oTEMPLATE.param["ds_id"]	= arg["id"];
						oTEMPLATE.param["QUEUENR"]	= new String(Request.QueryString("I").Item);
						oTEMPLATE.namecache_data	= oDATA.namecache_data[key].slice(j,j+oDATA.namecache_flds[key].length);
						
						//Response.Write(oTEMPLATE.namecache_data)
						
						_templdat[i] 				+= oTEMPLATE.parse(template);					
						*/
						
						_templdat[i] += overview[imgnr+enumfld["ds_header"]];
					}
				
				}
			break;
			
			case "EXEC":

				var arg = argparser(curarg);
				if(arg["script"])
				{
					_templdat[i] = "<!--EXEC-->";//unescape(arg["script"]);
					eval(unescape(arg["script"]));
				}
				else if(arg["scriptid"])
				{
					var rid = arg["scriptid"].toString().decrypt("nicnac");
					var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_ws+"\" and (rev_pub & 9) = 1 and rev_id = "+rid+" limit 0,1"
					var script = _oDB.get(sSQL);
					
					_templdat[i] = "<!--EXEC-->";
					eval(script);
				}
			break;
			


			case "TREE":
				var arg = argparser(curarg);

				var xmlStr = "";
				
				var tabs = new Array(10);
				for(var j=0;j<10;j++)
					tabs[j] = arg["utab"];
				tabs = tabs.join("");
				var tabseq ="\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
				
				function parseXMLTREE(node,level,arg,target)
				{
					
					if(node.childNodes.length>0)
					{ 
						
					  for(var n=0;n<node.childNodes.length;n++)
					  {
						level++;
						
						if(node.nodeType==1 && node.nodeName=="field")
						{
							var chnode = node.childNodes[n];
							try
							{
								if(chnode.getAttribute("name").charAt(0)!="[" && (!chnode.getAttribute("pub") || Number((chnode.getAttribute("pub"))&1)==1 ) )
								{
									if(plevel==0)
										plevel = level-1;
									_templdat[i] += TREEdisp(chnode.getAttribute("name"),level-3,chnode.getAttribute("id"),arg,node.childNodes[n].childNodes.length>0?1:0,level-plevel);
									plevel = level;
								}
							}
							catch(e) { _templdat[i] += "MALFORMED XML<br>" }
						}
						
						if(node.childNodes[n].childNodes.length>0)
						{
							parseXMLTREE(node.childNodes[n],level,arg,target);
						}						
						
						level--;
					  }
					}
				}
				
				function TREEdisp(_title,_level,_id,_arg,_prediff,_postdiff)
				{
					var _str = "";
					switch(_arg["type"]?_arg["type"].toLowerCase():"")
					{
						case "ul":
							
							if(_prediff==0 && _postdiff==0)
								_str = tabseq.substring(0,_level)+"<li><a href=\"index_Q_P_E_"+_id+".asp\">"+String(_title)+"</a></li>\r\n";
							else if(_prediff==1 && _postdiff==0)
								_str = tabseq.substring(0,_level)+"<li class=\"submenu\"><a href=\"index_Q_P_E_"+_id+".asp\">"+String(_title)+"</a>\r\n"+tabseq.substring(0,_level+1)+"<ul class=\"level"+(_level+1)+"\">\r\n";
							else if(_prediff==0 && _postdiff==1)
								_str = tabseq.substring(0,_level)+"<li><a href=\"index_Q_P_E_"+_id+".asp\">"+String(_title)+"</a></li>\r\n"
							else if(_prediff==1 && _postdiff==-1)
								_str = tabseq.substring(0,_level+1)+"</ul>\r\n"+tabseq.substring(0,_level)+"</li>\r\n"+tabseq.substring(0,_level)+"<li class=\"submenu\"><a href=\"index_Q_P_E_"+_id+".asp\">"+String(_title)+"</a>\r\n"
								      +tabseq.substring(0,_level+1)+"<ul class=\"level"+(_level+1)+"\">\r\n"
							else
								_str = tabseq.substring(0,_level+1)+"</ul>\r\n"+tabseq.substring(0,_level)+"</li>\r\n"+tabseq.substring(0,_level)+"<li><a href=\"index_Q_P_E_"+_id+".asp\">"+String(_title)+"</a></li>\r\n"
						
							return /*"*"+_prediff+" "+_postdiff+"*"+*/_str;
						default:
							return _arg["utab"].substring(0,_arg["utab"].length*(_level-4))+_arg["utxt1"]+"<a href=index_Q_P_E_"+_id+".asp>"+String(_title)+"</a>"+_arg["utxt2"]+"\r\n";
					}
				}
				
				
				
				var arg = argparser(curarg);
				var sSQL = "select rev_rev from "+_app_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 2 and rev_dir_lng = \""+_dir+"\" limit 0,1"
				var rev_rev = _oDB.get(sSQL);
				
				if(rev_rev)
				{
					arg["utxt1"] = arg["utxt1"]?unescape(arg["utxt1"]):"";
					arg["utxt2"] = arg["utxt2"]?unescape(arg["utxt2"]):"<br>";
					arg["utab"]  = arg["utab"]?unescape(arg["utab"]):"&nbsp;&nbsp;&nbsp;";	
				
					var XMLObj  = loadXML(rev_rev);
					var bXMLValid = XMLObj.parseError.errorCode == 0;
					
					var plevel = 0;
					if(bXMLValid)
						parseXMLTREE(XMLObj,0,arg,rev_rt_cat)
					else
						_templdat[i] = "INVALID XML";
				}
				else
					_templdat[i] = "NO XML FOUND: "+sSQL;
				
			break;
			
			case "TEMPLATE":
				if(curarg)
				{
					
				
					var arg = argparser(curarg);
					// ds  = dataset
					// sel = section ID to select for
					// selfield = DBfield on which to select
					// orderby  = DBfield for sorting
					
					var template = "<DIV class=header_text style=\"MARGIN-TOP: 0px\" align=left>\r\n"
              				  +"<IMG style=\"MARGIN-RIGHT: 20px\" alt=\"\" hspace=0 src=\"http://www.hilarywallis.net/usite/hilarywallis/images/img0000001222_000002_009_1.jpg\" height=40 width=100  align=left border=1><STRONG>\r\n"
						      +"{_DATA{0}_}\r\n"
						      +"</STRONG></DIV>\r\n"
						      +"<DIV class=main_text style=\"MARGIN-TOP: 4px\" align=justify>\r\n"
						      +"{_DATA{1}_}\r\n"
						      +"</DIV>\r\n";
							  
					var template = arg["tmpl"]?unescape(arg["tmpl"]):"";
					
					// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
					
					var deftablefld = new Array("rev_url","rev_header","rev_rev","rev_publisher");	
					
					var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+arg["ds"];
					var tabledefs = _oDB.getrows(sSQL);
					if(arg["debug"]=="true")
					   _templdat[i] += "\r\n\r\n<!--"+sSQL+"-->\r\n\r\n";
					
					var header		= tabledefs[1];
					var publisher 	= tabledefs[3];
					
					var key = (arg["cache"]?arg["cache"]:curfield)+arg["ds"];
					var nr  = Request.QueryString("I").Item?Request.QueryString("I").Item:arg["nr"];
					var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
					var sep = (arg["sep"]?unescape(arg["sep"]):"");
					
					
					////////////////////////////////////////////////////////////////
					
					oDATA.namecache_flds[key]  = new Array();
					oDATA.namecache_enum[key]  = new Array();
					oDATA.namecache_data[key]  = new Array();
					
					// E X T E R N A L  D A T A B A S E   S E L E C T I O N
					if(publisher && publisher!=null)
					{
						var arr = publisher.split(",");
						_masterdb = arr[0];
						_detaildb = arr[1];
					}
					
					
					//         O V E R R U L E   ! !
					//_detaildb = false;
					
					//  PLEASE ANALYSE WHAT HAPPENS IF DETAILDB DOESNT EXTIST


						// FETCH MASTER DB
						//Response.Write("fetch master DB");
						
						// R E A D   X M L   H E A D E R S E T
						var sSQL = "select rev_header from "+_db_prefix+"review where rev_id = "+arg["ds"];
						var rev_header = _oDB.get(sSQL);
						
						var XMLObj  = loadXML(rev_header);
						var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
						
						var arr = new Array();
						var arrid = new Array();
						for(var j=0;j<hfields.length;j++)
						{
							var fid 	= hfields.item(j).text.toString();
							var name 	= hfields.item(j).getAttribute("name");
							var num 	= Number(fid.substring(1,fid.length-1));
							arr[j] 		= name;
							arrid[j]    = fid;
							
							oDATA.namecache_enum[key][num]  = j+1;
							
							// TODO ANALYSE NAMECACHE FOR MULTIVALUES
							//Response.Write("oDATA.namecache_enum["+key+"]["+num+"] = "+(j+1)+"\r\n")
							
							oDATA.namecache_flds[key][j+1]  = name;
						}
						
						var nr = Request.QueryString("I").Item;
						nr = arg["nr"]?arg["nr"]:nr;
						
						var sel  = arg["sel"]?arg["sel"]:nr;   
						
						arg["P"] = rev_rt_cat;
						sel  = arg["selvar"]?arg[arg["selvar"]]:sel;
						
						if(arg["ipp"])
						{
							/////////////////////////////////////
							//  P A G E   N A V I G A T I O N  //
							/////////////////////////////////////
							
							var cSQL = "select count(*) from "+_app_db_prefix+_masterdb+" where "
								+" ds_rev_id = "+arg["ds"]
								+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1]
								+(arg["selfield"]?(" and "+arg["selfield"]+" = "+sel):"")
								+(arg["datelimit"]?(" and "+arg["datelimit"]+"<SYSDATE()"):"");
							
							var overviewlength = Number(_oDB.get(cSQL))*arr.length;
							
							bSpiderSafeURL = typeof(SiderSafeURL)=="string";
							var _extraurl = "";
							
							var ipp = arg["ipp"]?arg["ipp"].split("-"):"";
							var spp = ipp[1]; // MAX NAVIGATIONBAR WIDTH
							var ipp = ipp[0]; // ITEMS PER PAGE
							var bnavdir = arg["navdir"]=="reverse"?true:false;
							
							var n = Math.round(overviewlength/(ipp*arr.length)+0.499);
							var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):(bnavdir?n:1);
							
							var maxrec = 10000;
							
							var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(bnavdir?(n-pag)*ipp:(pag-1)*ipp)+","+ipp);
							var navclass = arg["navclass"]?("class="+arg["navclass"]):"";
							
							var begin = 0;
							
							var pgnav = "";
							var prevpg = bnavdir?(pag+(pag<n?1:0)):(pag-(pag>1?1:0));
							//Response.Write(pag+1);
							
							if (pag == 0)
								pgnav += "<font color=#800000 title='"+(_T["max_items"]?_T["max_items"].replace(/_#_/g,maxrec):"")+"'><b>"+_T["nav_all"]+"</b></font>&nbsp;";
							else
							{
								pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+"_Q_pag_E_0"+SpiderSafeExt+_extraurl+""):"?pag=0"+_extraurl+"")+" title='"+(_T["nav_max_items"]?_T["nav_max_items"].replace(/_#_/g,maxrec):"*nav_max_items*")+"' "+navclass+">"+_T["nav_all"]+"</a>&nbsp; ";
										
								//if (pag>1)
									pgnav += "<a "+navclass+" href=?pag="+(bnavdir?n:1)+_extraurl+">"+_T["nav_begin"]+"</a>&nbsp; "
										  +  "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+prevpg+_extraurl+" "+navclass+" style=font-weight:800><span title='"+_T["nav_prev"]+"'></span></A>&nbsp;&nbsp;";
								begin = pag-Math.round(spp/2)<0 ? 0 : (pag-Math.round(spp/2));
								begin = spp/2>(n-pag-1) ? (n-spp) : begin;
								begin = begin<=0 ? 0 : begin;
							}
							
							for( var j=begin+1 ; j <= begin+spp && j <= n ; j++ )
							{
								var altj = (bnavdir?n-j+1:j)
								if (altj == pag)
									pgnav += "<font color=#800000><b>["+altj+"]</b></font>&nbsp;";
								else
									pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+altj+_extraurl+" "+navclass+">["+altj+"]</a>&nbsp;";
							}
							
							var nextpg = bnavdir?(pag-(pag>1?1:0)):(pag+(pag<n?1:0));
							//if (pag<n)
								pgnav += "&nbsp;<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+nextpg+_extraurl+" "+navclass+" style=font-weight:800><span title='"+_T["nav_next"]+"'></span></a>&nbsp;"
										+ "&nbsp;<a "+navclass+" href=?pag="+(bnavdir?1:n)+_extraurl+" title='"+n+"'>"+_T["nav_end"]+"</a>";
							
							var ippl = ipp*arr.length;
							if (pag==0)
								ippl = overviewlength>(maxrec*arr.length)?(maxrec*arr.length):overviewlength;
							var ipps = pag==0?0:ippl*(pag-1);
						}
						
						/*
						var sSQL = "select ds_id,"+arr.join(",")+" from "+_app_db_prefix+_masterdb+" where "
							+" ds_rev_id = "+arg["ds"]
							+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1]							
							+(arg["selfield"]?(" and "+arg["selfield"]+" = \""+sel+"\""):"") // like \""+sel+"\"  REMOVED FOR HILARYWALLIS BUG !!!!!
							+(arg["datelimit"]?(" and "+arg["datelimit"]+"<SYSDATE()"):"")
							+(arg["orderby"]?(" order by "+arg["orderby"]):"")
							+" "+(arg["ipp"]?limit:"")
							//+(nr?(" and ds_id = "+nr):"");  // COMMENTED FOR HILARY WALLIS !!!!!!!!!!!!!!
						*/
						
						if(_ws!="visemagazine")
						{
						var sSQL = "select ds_id"+(arr.length>0?"ds_id":"")+arr.join(",")+" from "+_app_db_prefix+"dataset where "
							+" ds_rev_id = "+arg["ds"]
							+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1]							
							+(arg["selfield"]?(" and "+arg["selfield"]+" = "+(isNaN(Number(sel))?("\""+sel+"\""):sel  )):"")
							+(arg["datelimit"]?(" and "+arg["datelimit"]+"<SYSDATE()"):"")
							+(arg["orderby"]?(" order by "+arg["orderby"]):"")
							+" "+(arg["ipp"]?limit:"")
						}
						else
						{
							var sSQL = "select ds_id,"+(arr.length>0?"ds_id":"")+arr.join(",")+" from "+_app_db_prefix+"dataset where "
								+" ds_rev_id = "+arg["ds"]
								+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1]							
								+(arg["selfield"]?(" and "+arg["selfield"]+" like \"%"+sel+"%\""):"")
								+(arg["datelimit"]?(" and "+arg["datelimit"]+"<SYSDATE()"):"")
								+(arg["orderby"]?(" order by "+arg["orderby"]):"")
								+" "+(arg["ipp"]?limit:"")						
						}
						
						if(arg["debug"]=="true")
							_templdat[i] += "\r\n\r\n<!--"+sSQL+"-->\r\n\r\n";
						
						//Response.Write(_detaildb && nr)
						
					
						
						
						//Response.Write("\r\n\r\n"+sSQL+"\r\n\r\n")
						oDATA.namecache_data[key] = _oDB.getrows(sSQL);
						
						if(arg["debug"]=="true")
							_templdat[i] += "\r\n\r\n<!-- oDATA.namecache_data["+key+"] = \""+oDATA.namecache_data[key]+"\" -->\r\n\r\n";
						
						
						
	/*
						if(_detaildb && nr)
						{
							Response.Write(arrid.join(","))
						
							//Response.Write("\r\n\r\n"+sSQL+"\r\n\r\n")
							var sSQL = "SELECT rd_dt_id,rd_text FROM "+_app_db_prefix+_detaildb+" where rd_ds_id  = "+arg["ds"]+" and rd_recno = "+nr;
							var buf = _oDB.getrows(sSQL);
							for(var j=0;j<buf.length;j+=2)
							{
									//oDATA.namecache_enum[key][buf[j]] = arr.length+buf[j]
							}
							
							//Response.Write("\r\n\r\n"+sSQL+"\r\n\r\n")
						}	
*/
					
						
						sSQL = "";
						
						
						
						if(bDebug)
						{
							Response.Write("\r\n\r\n<small>\r\n");
							Response.Write("overview   = oDATA.namecache_flds[\""+key+"\"]; ("+(oDATA.namecache_flds[key])+")\r\n<br>\r\n");
							Response.Write("overview   = oDATA.namecache_data[\""+key+"\"]; ("+(oDATA.namecache_data[key])+")\r\n<br>\r\n");
							Response.Write("\r\n\r\n</small>\r\n\r\n");
						}
						
						
						_templdat[i] += ""
									 +(arg["ipp"]?(pgnav+"<br><br>"):"");		
						
						

										  
					
					var oTEMPLATE				= new TEMPLATE();
					oTEMPLATE.namecache_enum	= oDATA.namecache_enum[key];
					oTEMPLATE.param				= arg;
					
					var scale = oDATA.namecache_flds[key].length
					var middle = Math.floor(((oDATA.namecache_data[key].length/scale)/2)-0.5)*scale
					
					var usplit1 = arg["usplit1"]?unescape(arg["usplit1"]):"";
					var usplit2 = arg["usplit2"]?unescape(arg["usplit2"]):"";
					
					if(usplit1 && usplit2)
						_templdat[i] += "\r\n<TABLE>\r\n\t</TR>\r\n"+usplit2;
					
					for(j=0;j<oDATA.namecache_data[key].length;j+=scale)
					{
						//Response.Write(j+"<br>");
						oTEMPLATE.param["ds_id"]	= oDATA.namecache_data[key][j];
						
						oTEMPLATE.param["QUEUENR"]	= new String((j/oDATA.namecache_flds[key].length));
						oTEMPLATE.namecache_data	= oDATA.namecache_data[key].slice(j,j+oDATA.namecache_flds[key].length);
						
						
						
						_templdat[i] 				+= (j>0 && sep?sep:"")+oTEMPLATE.parse(template);
						
						if(j==middle)
							_templdat[i] += usplit1 + usplit2;
					}
					
					if(usplit1 && usplit2)
						_templdat[i] += usplit1+"\r\n\t</TR>\r\n</TABLE>\r\n"
						
					if(bDebug)
					{
						Response.Write("<table border=1>\r\n");
						
						Response.Write("<tr>");
						
						for(j=0;j<oDATA.namecache_flds[key].length;j++)
						{
							Response.Write("<td>"+oDATA.namecache_flds[key][j]+" "+oTEMPLATE.namecache_enum[j]+"</td>")
						}
						
						
						Response.Write("</td></tr>\r\n");
						
						
						for(j=0;j<oDATA.namecache_data[key].length;j+=oDATA.namecache_flds[key].length)
						{
							Response.Write("<tr><td>");
							Response.Write(oDATA.namecache_data[key].slice(j,j+oDATA.namecache_flds[key].length).join("</td><td>"));
							Response.Write("</td></tr>\r\n");
						}
						Response.Write("</table>");
					}					
					
					
 				}
				
				function TEMPLATE()
				{
					this.parse = TEMPLATE_parse;
					this.namecache_data = new Array();
					this.namecache_enum = new Array();
					this.param = new Array();
				}
				
				function TEMPLATE_parse(_str)
				{
					//Response.Write("*"+this.namecache_data+"*<br>")
					
					var _tmplfield 	= new Array();
	   				var _templdata 	= new Array();
	   				var _str_arr 	= _str? _str.split("{_"):new Array();
					
					//Response.Write(escape(_str)+"*<br>")
					
	   				for(var _i=1;_i<_str_arr.length;_i++)
	   				{
						var _curfield = _str_arr[_i]?_str_arr[_i].substring(0,_str_arr[_i].indexOf("_}")):"";
						_tmplfield[_i] = _curfield;
						
						var _curarg   = "";
						
						if(_curfield && _curfield.indexOf("{")>=0 && _curfield.indexOf("}")>=0 && _curfield.indexOf("}") > _curfield.indexOf("{"))
						{
							_curarg   = _curfield.substring(_curfield.indexOf("{")+1,_curfield.indexOf("}"));
							_curfield = _curfield.substring(0,_curfield.indexOf("{"));
						}
						
						//Response.Write(_curfield+"["+_curarg+"]="/*+this.item[_curarg]*/+"<br>");
						
						
						switch(_curfield)
						{
							case "DATA":
								//Response.Write(this.namecache_data[ this.namecache_enum[_curarg] ]+" "+_curarg+"<br>");
								//Response.Write("*"+this.namecache_enum[_curarg]+"*")
								if(_curarg.indexOf("\"")<0)
								{
									var _value = this.namecache_data[ this.namecache_enum[_curarg] ];
									_templdata[_i] = _value?_value:"";
								}
								else
								{
									var _arg = argparser(_curarg);
									_arg["txt1"]  = _arg["txt1"]?_arg["txt1"]:"";
									_arg["txt2"]  = _arg["txt2"]?_arg["txt2"]:"";
									_arg["utxt1"] = _arg["utxt1"]?unescape(_arg["utxt1"]):"";
									_arg["utxt2"] = _arg["utxt2"]?unescape(_arg["utxt2"]):"";
									
									//Response.Write("/"+_arg["usplittag"]+"/");
									
									// TODO  ANALYSE NAMECACHE
									//Response.Write(typeof(this.namecache_data[ this.namecache_enum[_arg["id"]] ]));
									
									var _value = this.namecache_data[ this.namecache_enum[_arg["id"]] ];
									if(_arg["type"] && _arg["type"].substring(0,5)=="multi")
									{
										// TODO handlde csv multivalues
									}
									
									_templdata[_i] = _value?(_arg["txt1"]+_arg["utxt1"]+_value+_arg["txt2"]+_arg["utxt2"]):(_arg["dtxt"]?_arg["dtxt"]:"");	
								}
							break;
							case "UDATA":
								if(_curarg.indexOf("\"")<0)
								{
									var _value = unescape(this.namecache_data[ this.namecache_enum[_curarg] ]);
									_templdata[_i] = _value?_value:"";
								}
								else
								{
									var _arg = argparser(_curarg);
									_arg["txt1"]  = _arg["txt1"]?_arg["txt1"]:"";
									_arg["txt2"]  = _arg["txt2"]?_arg["txt2"]:"";
									_arg["utxt1"] = _arg["utxt1"]?unescape(_arg["utxt1"]):"";
									_arg["utxt2"] = _arg["utxt2"]?unescape(_arg["utxt2"]):"";									
									
									var _value = unescape(this.namecache_data[ this.namecache_enum[_arg["id"]] ]);
									
									if(_arg["replacefrom"])
									{
										_value = _value.replace(new RegExp(_arg["replacefrom"],"g"),this.namecache_data[_arg["replacefld"] ]);
									}
									
									_templdata[_i] = _value?(_arg["txt1"]+_arg["utxt1"]+_value+_arg["txt2"]+_arg["utxt2"]):"";	
								}							
							break;
							case "REFDATA":
								var _arg = argparser(_curarg);
								var _value = this.namecache_data[ this.namecache_enum[_arg["id"] ] ];
								if(_value)
								{
									var sSQL = "select ds_title from "+_db_prefix+"dataset where ds_rev_id = "+_arg["refds"]+" and ds_id = "+(_value?_value:0)
									_value =  _oDB.get(sSQL);
								}
								_templdata[_i] = _value?_value:"";
							break;
							case "IMG":
								//Response.Write(this.namecache_data[ this.namecache_enum[_curarg] ]+" "+_curarg+"<br>");
								//Response.Write(this.param["ds_pub"]+" ")
								
								var _arg = argparser(_curarg);
								_arg["txt1"]  = _arg["txt1"]?_arg["txt1"]:"";
								_arg["txt2"]  = _arg["txt2"]?_arg["txt2"]:"";
								_arg["utxt1"] = _arg["utxt1"]?unescape(_arg["utxt1"]):"";
								_arg["utxt2"] = _arg["utxt2"]?unescape(_arg["utxt2"]):"";
								
								var _value = Number(this.namecache_data[ this.namecache_enum[_arg["id"] ] ]);
								
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],1);
								
								if((_value&1)==1)
									_templdata[_i] = 
									(_value&1==1)?(_arg["txt1"]+_arg["utxt1"]
									+"../"+_ws+"/images/img"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(tarr[0],3)+"_"+(tarr[2]?zerofill(tarr[1],2):tarr[1])+(tarr[2]?("_"+tarr[2]):"")+".jpg"
									+_arg["txt2"]+_arg["utxt2"]):"";
								else
									_templdata[_i] = " ";
									
							break;
							
							case "RES":
								//Response.Write(this.namecache_data[ this.namecache_enum[_curarg] ]+" "+_curarg+"<br>");
								var _arg = argparser(_curarg);
								_arg["txt1"]  = _arg["txt1"]?_arg["txt1"]:"";
								_arg["txt2"]  = _arg["txt2"]?_arg["txt2"]:"";
								_arg["utxt1"] = _arg["utxt1"]?unescape(_arg["utxt1"]):"";
								_arg["utxt2"] = _arg["utxt2"]?unescape(_arg["utxt2"]):"";
								
								var _value = this.namecache_data[ this.namecache_enum[_arg["id"] ] ];
								
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],1);
								_templdata[_i] = 
									_value?(_arg["txt1"]+_arg["utxt1"]
									+"../"+_ws+"/res/src"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(tarr[0],3)+"_"+(tarr[2]?zerofill(tarr[1],2):tarr[1])+(tarr[2]?("_"+tarr[2]):"")+".jpg"
									+_arg["txt2"]+_arg["utxt2"]):"";									
							break;							
							case "FILE":
								//Response.Write(this.namecache_data[ this.namecache_enum[_curarg] ]+" "+_curarg+"<br>");
								var _arg = argparser(_curarg);
								_arg["icon"]  = _arg["icon"]?_arg["icon"]:"";
								_arg["txt1"]  = _arg["txt1"]?_arg["txt1"]:"";
								_arg["txt2"]  = _arg["txt2"]?_arg["txt2"]:"";
								_arg["utxt1"] = _arg["utxt1"]?unescape(_arg["utxt1"]):"";
								_arg["utxt2"] = _arg["utxt2"]?unescape(_arg["utxt2"]):"";
								
								var _value = this.namecache_data[ this.namecache_enum[_arg["id"] ] ];
								var _valuearr = _value?_value.split(","):new Array();
								
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],1);
								
								_templdata[_i] = "";
								for(var _j=0;_j<_valuearr.length;_j++)
								{
									_templdata[_i] += 
										_valuearr[_j]?("<a href=disp.asp?d="+escape("<html></head></head><body leftmargin=0 rightmargin=0 topmargin=0 bottommargin=0>"
										+"<iframe width=100% height=100% src=../"+_ws+"/res/src"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(tarr[0],3)+"_"+_j+_valuearr[_j]+">"
										+"</body></html>")+" target=blank>"+_arg["txt1"]+_arg["utxt1"]+(_j+1)+_arg["txt2"]+_arg["utxt2"]+"</a>"):" ";
										
									//Response.End();
								}
							break;
							case "GALLERY_ZOOM":
								var _arg = argparser(_curarg);
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],0);
								var zarr = _arg["zoom"]?_arg["zoom"].split("-"):new Array(_arg["id"],1);
								var _value = Number(this.namecache_data[ this.namecache_enum[_arg["id"]] ]);
								var _attr = _arg["attr"]?(" "+_arg["attr"]):"";
								var _style = _arg["style"]?(" style="+_arg["style"]):"";
								var bitlength = _value==0?0:_value.toString(2).length;
								
								//Response.Write(_value.toString(2))
								
								for(var _j=0;_j<bitlength;_j++)
								{
									if(((_value>>_j)&1)==1)
									{
										var imgbase = "../"+_ws+"/images/img"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(_arg["id"],3)+"_"+zerofill(_j,2)+"_";
										var command = " onclick=\"window.open('disp.asp?d="+escape("<html><head><title>Zoom</title></head><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+imgbase+zarr[0]+".jpg onclick=window.close()></td></tr></table></body></html>")+"','zoom','width=550,height=550,scrollbars=yes,toolbar=yes,location=yes,resizable=yes'); return false\" "
										_templdata[_i] = (_templdata[_i]?_templdata[_i]:"")
										                 +"<a href="+imgbase+zarr[0]+".jpg target=_blank "+command+">"
										                 +"<img src="+imgbase+(tarr[1]?tarr[1]:0)+".jpg "+_attr+_style+">"
														 +"</a>\r\n";
									}
								}							
								_templdata[_i] = _templdata[_i]?_templdata[_i]:" "
							
							
							/*
								var _arg = argparser(_curarg);
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],1);
								var zarr = _arg["zoom"]?_arg["zoom"].split("-"):new Array(_arg["id"],1);
								var _value = Number(this.namecache_data[ this.namecache_enum[_arg["id"]] ]);
								var _attr = _arg["attr"]?(" "+_arg["attr"]):"";
								var _style = _arg["style"]?(" style="+_arg["style"]):"";
								var bitlength = _value==0?0:_value.toString(2).length;
								
								_templdata[_i] = "";
								for(var _j=0;_j<bitlength;_j++)
								{
									if(((_value>>_j)&1)==1)
									{
										var imgbase = "../"+_ws+"/images/img"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(_arg["id"],3)+"_"+zerofill(_j,2)+"_";		
										var command = " onclick=\"window.open('disp.asp?d="+escape("<html><head><title>Zoom</title></head><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+imgbase+zarr[0]+".jpg onclick=window.close()></td></tr></table></body></html>")+"','zoom','width=550,height=550,scrollbars=yes,toolbar=yes,location=yes,resizable=yes'); return false\" "
										_templdata[_i] += "<a href="+imgbase+zarr[0]+".jpg target=_blank "+command+"><img src=\""+imgbase+tarr[0]+".jpg\" border=0></a>";
									}
								}
							*/
							
							break;
							case "GALLERY":
								var _arg = argparser(_curarg);
								var tarr = _arg["thumb"]?_arg["thumb"].split("-"):new Array(_arg["id"],0);
								var _value = Number(this.namecache_data[ this.namecache_enum[_arg["id"]] ]);
								var _attr = _arg["attr"]?(" "+_arg["attr"]):"";
								var _style = _arg["style"]?(" style="+_arg["style"]):"";
								var bitlength = _value==0?0:_value.toString(2).length;
								
								//Response.Write(_value.toString(2))
								
								for(var _j=0;_j<bitlength;_j++)
								{
									if(((_value>>_j)&1)==1)
										_templdata[_i] = (_templdata[_i]?_templdata[_i]:"")+"<img src=../"+_ws+"/images/img"+zerofill(this.param["ds"],10)+"_"+zerofill(this.param["ds_id"],6)+"_"+zerofill(_arg["id"],3)+"_"+zerofill(_j,2)+"_"+(tarr[1]?tarr[1]:0)+".jpg"+_attr
										+_style+">";
								}
							break;
							
							case "A":
								var _arg = argparser(_curarg);
								_templdata[_i] = "index_Q_P_E_"
										+(_arg["details"]?_arg["details"]:rev_rt_cat)
										+(this.param["ds_id"]?("_A_I_E_"+this.param["ds_id"]):"")
										+(this.param["sel"]?("_A_SEL_E_"+this.param["sel"]):"")
										+".asp";
							break;
							case "DATE":
								var _arg = argparser(_curarg);
								var fmt = _arg["fmt"]?_arg["fmt"]:"%b %d %H:%M";
								var _value = new Date(this.namecache_data[ this.namecache_enum[_arg["id"]] ]);
								_templdata[_i] = (_value - new Date(0))==0?" ":_value.format(fmt,_isolanguage);
							break;
							case "QUEUENR":
								_templdata[_i] = this.param["QUEUENR"];
							case "RECID":
								_templdata[_i] = this.param["ds_id"];								
							break;
						}
						
						
					}
					
				   for(var _i=1;_i<_str_arr.length;_i++)
				   {
					   //_str = _str.replace("{_"+_tmplfield[_i]+"_}",_templdata[_i]?_templdata[_i]:("{_"+_tmplfield[_i]+"_}"));
					   _str = _str.replace("{_"+_tmplfield[_i]+"_}",_templdata[_i]?_templdata[_i]:(_tmplfield[_i].indexOf("DATA")==0?"":("{_"+_tmplfield[_i]+"_}")));
					   
					   //Response.Write("_str.replace('{_"+_tmplfield[_i]+"_}',"+(_templdata[_i]?_templdata[_i]:("{_"+_tmplfield[_i].toUpperCase()+"_}"))+"')<br>");
				   }					
					
					return _str;
				}


			break;	



			case "DISTINCTSQL":
				if(curarg)
				{
					var unarg = unescape(curarg).replace(/&quot;/gi,"\"");
					var pos = unarg.indexOf(",");
					
					var step = Number(unarg.substring(0,pos));
					var sSQL = unarg.substring(pos+2,unarg.length-1);
					//_templdat[i] += len+"<br>"+arg;
					
					var arr = _oDB.getrows(sSQL)
					
					var prev = "";
					_templdat[i] += "<table class=text>"
					for(var j=0;j<arr.length;j+=step)
					{
						if(prev!=arr[j])
						{
							_templdat[i] += "</table>\r\n";
							_templdat[i] += "<br>"+arr[j]+"\r\n";
							_templdat[i] += "<table class=text>\r\n";
							prev = arr[j];
							
						}
						
						_templdat[i] += "<tr><td>"+arr.slice(j+1,j+step).join("</td><td>")+"</td></tr>"
					}
					_templdat[i] += "</table>"
				}
			break;


			case "COUNTER":
				var eSQL = "update usite_infoset set ds_num01 = ds_num01 + 1 where ds_title=\""+_dir+"\"";
				_oDB.exec(eSQL);
				
				_templdat[i] += "<!--COUNTER="+_oDB.get("select ds_num01 from usite_infoset where ds_title=\""+_dir+"\"")+"-->";
			break;
/*
			case "COUNTER":
				var filepath = "../"+_ws+"/xml";
				var FSO	= Server.CreateObject("Scripting.FileSystemObject");
				var now = new Date();
				var filename = now.format("%Y%m%d")
				var dest = Server.MapPath(filepath+"\\cnt"+filename+".tmp");
				
				var ip = Request.ServerVariables("REMOTE_ADDR").Item;
				
				
				if(!FSO.FileExists(dest))
				{
					var fileObj = FSO.CreateTextFile(dest,true,false);
					fileObj.Write(ip);
					fileObj.Close();
				}
				else
				{
					var ForAppending = 8;
					var fileObj = FSO.OpenTextFile(dest,ForAppending,false);

					
					fileObj.Close();				
				}
				_templdat[i] += "<!--COUNTER-->"
			break;
*/



/*
// DATACACHE
				if(curarg)
				{
					var ds = Request.QueryString("ds").Item?Request.QueryString("ds").Item.toString().decrypt("nicnac"):-1;
					
					var argset = argparser(curarg);
					var ds = argset["ds"]?argset["ds"]:ds;
					var nr = Request.QueryString("I").Item;
					
					//Response.Write(curarg+" "+argset["ds"])
					
					oDATA.namecache_enum["length"] = typeof(oDATA.namecache_enum["length"])=="number"?(oDATA.namecache_enum["length"]+1):1;
					var key = curfield+"_"+(argset["cache"]?argset["cache"]:oDATA.namecache_enum["length"]);
					
					//---------------------------------------------------------
					
					var sSQL = "select rd_dt_id,rd_text from "+_app_db_prefix+"datadetail where rd_ds_id = "+ds+(nr?(" and rd_recno = "+nr):"");
					var arr = _oDB.getrows(sSQL);
					
					//Response.Write(sSQL+"<br>")
					
					// FILL CACHE DATA WITH DATADETAIL
					oDATA.namecache_data[key] = new Array();					
					for(var j=arr.length-2;j>=0;j-=2)
					{
						oDATA.namecache_data[key][arr[j]] = arr[j+1];
						//Response.Write("oDATA.namecache_data["+key+"]["+arr[j]+"] = "+arr[j+1]+"<br>")
					}
					
					oDATA.namecache_data[key][0] = ds;
					
					
					//Response.Write(oDATA.namecache_data["DATACACHE_1"][11]+"#<br><br>")			
					//---------------------------------------------------------
					
					// R E A D   X M L   H E A D E R S E T
					var sSQL = "select rev_header from "+_db_prefix+"review where rev_id = "+ds;
					var rev_header = _oDB.get(sSQL);
					
					var XMLObj = loadXML(rev_header);
					var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
					
					var arr = new Array();
					for(var j=0;j<hfields.length;j++)
					{
						var fid = hfields.item(j).text.toString();
						arr[j] = fid.substring(1,fid.length-1)+","+hfields.item(j).getAttribute("name");
					}					
					
					var sSQL = "select "+arr.join(",")+" from "+_app_db_prefix+"dataset where ds_rev_id = "+ds+(nr?(" and ds_id = "+nr):"");
					//Response.Write(sSQL);
					
					var arr = _oDB.getrows(sSQL);
					
					// FILL CACHE DATA WITH DATASET
					//oDATA.namecache_data[key] = new Array();					
					for(var j=arr.length-2;j>=0;j-=2)
					{
						oDATA.namecache_data[key][arr[j]] = arr[j+1];
						//Response.Write("oDATA.namecache_data["+key+"]["+arr[j]+"] = "+arr[j+1]+"<br><br>")
					}
					//Response.End();
					//Response.Write(oDATA.namecache_data["DATACACHE_1"][11]+"#<br><br>")			
					
					//---------------------------------------------------------
					
					var tablefld  = oDATA.namecache_flds[key];
					var enumfld   = oDATA.namecache_enum[key];
					var overview  = oDATA.namecache_data[key];
					
					
					_templdat[i] += "<!--DATACACHE{"+curarg+"}-->";
				}
*/










	
			
			default:
				// PROCESS ADDITIONAL TAGS  (DYNAMICALLY DEFINED)
				if(typeof(_enumextra[curfield])=="number")
				{
					//if(bDebug)
						//Response.Write(curfield+" = BINGO ("+curarg+") !!!!!!<br>")
						
						//////////////////////////////////
						//  G E T   M E N U   D A T A   //
						//////////////////////////////////
						
						// INITIALISE MENU TREE
						var oTREE		= new _oGUI.TREE();
						oTREE.init();
						oTREE.bDebug = bDebug;		
						
						// SELECT QUERY
						var enumcatfld = new Array();
						var catfld  = new Array("rt_id","rt_parent_id","rt_index","1 as rt_level","rt_name","rt_typ","rt_pub");
						var namefld = new Array("rt_id","rt_parent_id","rt_index",""             ,"rt_name","rt_typ","rt_pub");	
						var typefld = new Array("number","number"     ,"number"  ,"number"       ,"string"						,"number","number");
						var sSQL = "select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\" and (rt_pub & 1) = 1  order by rt_index";
						
						if(bDebug)
							Response.Write(sSQL+"<BR><BR>");
						
						for (var j=0; j<catfld.length ; j++)
							enumcatfld[catfld[j]] = j;
						
						oTREE.in_interleave = catfld.length;
						
						// GET FROM DATABASE
						var categories = _oDB.getrows(sSQL);
						
						// FILL NULL-FIELDS WITH ID (NULL FIELDS CANNOT BE SORTED PROPERLY)
						var id_enum = enumcatfld["rt_id"];
						var txt_enum = enumcatfld["rt_"+_language.substring(0,2)];
						for (var j=0;j<categories.length;j+=catfld.length)
							if(!categories[j+txt_enum])
								categories[j+txt_enum] = "["+categories[j+id_enum]+"]";
						
						var data = 	categories;
						
						// BUILD TREE
						var tree		   = oTREE.load(categories);
						//var rev_categories = oTREE.combobox("name=category size=1");
						
						// INIT
						var attr = "name=category size=1";
						var dflt = "";
						
						var interval = 3;
						var indent = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
						oTREE.indexit(data);	
						
						var enumcatfld = new Array();
						var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
						var categories = oMENU.types;
						for (var j=0; j<catfld.length ; j++)
							enumcatfld[catfld[j]] = j;
						
						var idxcatfld = new Array()
						for (var j=0; j<categories.length ; j+=catfld.length)
							idxcatfld[categories[j]] = j;
						
						
						var menuID		 = Number(curarg);
						var rendermethod = curfield;
						
						//Response.Write(_tempxmlstr+"****")
						
						oMENU.load(oTREE,menuID,rendermethod,_tempxmlstr,_ws);
						var arr = oMENU.GENlinear(Number(rev_rt_cat));
						
						// ELIMINATE PARANTHESIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
						for(var j=0;j<arr.length;j++)
						{
							arr[j] = arr[j].indexOf("[")>=0?"":arr[j];
						}
						
						_templdat[i] = arr.join("");
						
						//Response.Write(rendermethod+"****");
				}
			break;
		}
	}

	
	if(bDebug)
	{
		
		for(var i=0;i<_templdat.length;i++)
		{
			Response.Write("<b>"+_tmplfld[i]+"</b><br>")
			Response.Write("<span style=\"background-color:#FFFF00\">"+Server.HTMLEncode(_templdat[i])+"</span><br><br>");
		}
	}
	
	function replacebeforesave(str)
	{
		//return str.replace(new RegExp("{_DATA{DS_ID}_}","gi"),dsid)
		return str;
	}

%>