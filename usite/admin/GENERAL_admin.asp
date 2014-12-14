<%

	var bDebug = false;
	bSpiderSafeURL = false;
	var bChangeHistory = true;
	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
		
	if(typeof(bAdmin)!="boolean")
		var bAdmin = oDB.permissions([zerofill(rev_type,2)+"_admin"]);
	if(typeof(bEdit)!="boolean")
		var bEdit = oDB.permissions([zerofill(rev_type,2)+"_edit"]);
	if(typeof(bEdit)!="boolean")
		var bView = oDB.permissions([zerofill(rev_type,2)+"_view"]);	
	if(typeof(bGui)!="boolean")
		var bGui = oDB.permissions([zerofill(rev_type,2)+"_gui"]);	

	//Response.Write(rev_type+" "+(bAdmin?"bAdmin":"")+" "+(bEdit?"bEdit":"")+" "+(bGui?"bGui":""))

	var sSQL = "SELECT rd_text FROM usite_blackbabydetail WHERE rd_dt_id = 26 and rd_ds_id = 661 and rd_recno = "+_uid;
	var arr = oDB.get(sSQL);
	arr = arr?arr.split(","):new Array();
	
	var allowdb = "";
	
	var dbperm = new Array();
	for(var j=0;j<arr.length;j++)
	{
		//Response.Write(arr[j]+"<br>")
		var subarr = arr[j].split(".");
		if(subarr[1]==rev_type)
			dbperm[dbperm.length] = subarr[2];	
	}
	if(dbperm.length>0)
		allowdb += dbperm.length>0?dbperm.join(","):"";
	


	//var bGui = true

	if(typeof(whereclause)!="string")
		var whereclause = "";
	if(typeof(editlink)!="number")
		var editlink = rev_type;

	if(typeof(bCrosslanguage)!="boolean")
		var bCrosslanguage = false;	

	if(typeof(bDataManager)!="boolean")
		var bDataManager = false;			
	
	if(typeof(template_types)!="string")
		var template_types = "0";
	
	if(typeof(rev_cols)!="object")
		var rev_cols = new Array("rev_title","rev_desc");

	if(typeof(rev_fnct)!="object")
		var rev_fnct = new Array("edit");

	if(typeof(insfld)!="object")
		var insfld = new Array();

	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false && bView==false))
		Response.Redirect("index.asp");

	var _extraurl = Request.QueryString("sp").Item?("&sp="+escape(Request.QueryString("sp").Item)):"";


	function quote( str )
	{
		return "'"+(!str || str==null?"":str.replace(/\x27/g,"\\'"))+"'";
	}
	
	var languages = oDB.getSetting(zerofill(rev_type,2)+"_L");
	var choice = "";

	var cat = Request.QueryString("cat").Item?Number(Request.QueryString("cat").Item.toString().decrypt("nicnac")):0;



	/////////////////////////////////////////////
	//  D E F I N E  Q U E R Y  C O L U M N S  //
	/////////////////////////////////////////////

	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_rt_typ","rev_rt_cat","rev_url","rev_email","rev_crea_acc_id","rev_mod_acc_id","rev_pub","rev_date_published","rev_crea_date","rev_mod_date");

	var checkarr =    ["on","sum","lck","del"];
	var checktitles = _T["_checktitles"];
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;


    /////////////////////////////////////////////
	//   S E A R C H                           //
	/////////////////////////////////////////////
	
	var search = "";
	if(typeof(rev_search)!="undefined")
	{	
		search += "<center><table cellspacing=1 cellpadding=10 bgcolor=#000000 align=center><tr><td bgcolor=#DADADA>"
		+"<table>"
		
		for(var i=0;i<rev_search.length;i++)
		{
			var val = Request.Form(rev_search[i][1]).Item;
			search +="<tr><td><span class=small>"+rev_search[i][0]+"</span></td><td><input type=text name=\""+rev_search[i][1]+"\" value=\""+(val?val.replace(/"/g,"&quot;"):"")+"\"></td></tr>"
		}
		search +="<tr><td></td><td><input type=submit value="+_T["search"]+"> &nbsp; <a href=?pag=1&id=d1922e7c6d35ad32002df2210524714c class=small>[wissen]</a></td></tr></table><br>"
		+"</td></tr></table><br>"
	}



    /////////// COMBO-BOX ////////////////////



	



	var choice = "";
	var cattypes = new Array();
	
	var pos = 0;
	cattypes[pos+enumfld["rev_title"]] = "freeform dataset";
	cattypes[pos+enumfld["rev_rt_typ"]] = rev_type;

	var pos = 1*tablefld.length;
	cattypes[pos+enumfld["rev_title"]] = "column definitions";
	cattypes[pos+enumfld["rev_rt_typ"]] = 22;	
	cattypes[pos+enumfld["rev_pub"]] = 2;
	
	
    // ADD HERE


	if(template_types!="0")
	{
		// INVOKE EXTRA CATEGORIES
		var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_rt_typ in ("+template_types+") and rev_dir_lng = \""+(bCrosslanguage?_ws:_dir)+"\""+(cat>0?(" and rev_rt_cat = "+cat):"")+" and (rev_pub & 9) = 1 order by rev_title,rev_desc ";
		//Response.Write(SQL);
		cattypes = cattypes.concat(oDB.getrows(SQL));
		
	}
	
	var enum_datatempl = new Array(); 
	for(var i=0;i<cattypes.length;i+=tablefld.length)
	{
		enum_datatempl[cattypes[i]] = i/tablefld.length;
	}	
	
	var datatempl_ref = Number(Request.Form("datatempl_ref").Item);	
	if(datatempl_ref)
	{
		pos = enum_datatempl[datatempl_ref];
		insfld["rev_ref"] = pos;
		switch(pos)
		{
			case 0: break;
			case -1:
					insfld["rev_title"] = "LIST_PROPERTIES"
					insfld["rev_header"] = 
					 "<"+"?"+"xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\r\\n"
					+"<ROOT>\\r\\n"
					+"  <row>\\r\\n"
					+"    <field name=\\\"ds_title\\\">[1]</field>\\r\\n"				
					+"    <field name=\\\"ds_desc\\\">[2]</field>\\r\\n"
					+"    <field name=\\\"ds_header\\\">[3]</field>\\r\\n"
					+"    <field name=\\\"ds_data01\\\">[4]</field>\\r\\n"
					+"    <field name=\\\"ds_data02\\\">[5]</field>\\r\\n"
					+"    <field name=\\\"ds_data03\\\">[6]</field>\\r\\n"				
					+"  </row>\\r\\n"
					+"</ROOT>\\r\\n"
					
					insfld["rev_rev"] = 
					 "<"+"?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\r\\n"
					+"<ROOT>\\r\\n"
					+"  <row>\\r\\n"
					+"    <field name=\\\"datasetID\\\">[1]</field>\\r\\n"				
					+"    <field name=\\\"columnID\\\">[2]</field>\\r\\n"
					+"    <field name=\\\"columnName\\\">[3]</field>\\r\\n"
					+"    <field name=\\\"type\\\">[4]</field>\\r\\n"
					+"    <field name=\\\"format\\\">[5]</field>\\r\\n"
					+"    <field name=\\\"attr\\\">[6]</field>\\r\\n"			
					+"  </row>\\r\\n"
					+"</ROOT>\\r\\n"
					insfld["rev_publisher"] = "paramset"		
			break;
			default:	
				insfld["rev_title"] 	= "copy_of_"+cattypes[pos*tablefld.length+enumfld["rev_title"]];
				insfld["rev_header"] 	= cattypes[pos*tablefld.length+enumfld["rev_header"]];
				insfld["rev_rev"] 		= cattypes[pos*tablefld.length+enumfld["rev_rev"]];
				insfld["rev_publisher"] = cattypes[pos*tablefld.length+enumfld["rev_publisher"]];
				insfld["rev_header"] 	= insfld["rev_header"] ? insfld["rev_header"].replace(/\r\n/g,"\\r\\n").replace(/"/g,"\\\"") : "";
				insfld["rev_rev"] 		= insfld["rev_rev"] ? insfld["rev_rev"].replace(/\r\n/g,"\\r\\n").replace(/"/g,"\\\"") : "";
				insfld["rev_ref"]		= pos;
		}
	}

	var k = 0;
	var permitteddatasets = new Array();
	var enumtypes = new Array();
	var enumpermit = new Array();
	for(var i=0;i<cattypes.length;i+=tablefld.length)
	{
		if( cattypes[i+enumfld["rev_rt_typ"]] == rev_type || (","+template_types+",").indexOf(","+cattypes[i+enumfld["rev_rt_typ"]]+",")>=0 )
		{
			permitteddatasets[k++] = i;
			//Response.Write(cattypes[i+enumfld["rev_rt_typ"]] +" "+  (i/tablefld.length) + cattypes[i+enumfld["rev_title"]] +"<br>");
			enumtypes[i/tablefld.length] = cattypes[i+enumfld["rev_title"]];
			//enumpermit[cattypes[i+enumfld["rev_id"]]] = i;
		}
	}

	
	if(permitteddatasets.length <= 1 || (bEdit==true && bAdmin==false))
		choice += "<input type=\"hidden\" name=\"datatempl_ref\" value=\""+(permitteddatasets[0]/tablefld.length)+"\">";
	else
	{
		var choice = "<select name=\"datatempl_ref\">\r\n";
		choice += "<option value=\"\">\r\n";
		for(var i=0;i<permitteddatasets.length;i++)
		{
			//var bSelected = Request.Form("datatempl_ref").Item?((permitteddatasets[i]/tablefld.length)==Request.Form("datatempl_ref").Item?true:false):((cattypes[permitteddatasets[i]+enumfld["rev_pub"]] & 2) == 2?true:false)
			
			var bSelected = Request.Form("datatempl_ref").Item == cattypes[permitteddatasets[i]+enumfld["rev_id"]];
			
			//choice += "<option value=\""+(permitteddatasets[i])+"\""+(bSelected?" selected":"")+">"+ cattypes[enumpermit[permitteddatasets[i]]+enumfld["rev_title"]]+"\r\n"
			choice += "<option value=\""+(cattypes[permitteddatasets[i]+enumfld["rev_id"]])+"\""+(bSelected?" selected":"")+">"+ cattypes[permitteddatasets[i]+enumfld["rev_title"]]+" - "+cattypes[permitteddatasets[i]+enumfld["rev_desc"]]+"\r\n";
		}
		choice += "</select>\r\n<br>\r\n";
		
		//Response.Write(permitteddatasets[1]+" "+tablefld.length)
	}



    /////////// COMBO-BOX ////////////////////



	var dayfr = new Date();
	var dayto = new Date(dayfr);

	var fr = dayfr.format("%Y-%m-%d %H:%M:%S");
	var to = dayto.format("%Y-%m-%d %H:%M:%S");

	var colnames = new Array();
	colnames["rev_title"]  = "T I T L E";
	colnames["rev_desc"]   = "D E S C";
	colnames["rev_email"]  = "E - M A I L";
	colnames["rev_url"]    = "U R L";
	colnames["rev_rt_cat"] = "PAGE";



	var act = Request.Form("act").Item;
	

	
	if(act)
	{
		if(act.indexOf(",")>0)
			act = act.substring(0,act.indexOf(","))
	}


	var data = new Array();
	
	if (act && act.indexOf(_T["new"])>=0)
	{
		data[0] = oDB.takeanumber(_app_db_prefix+"review");
		data[1] = "\""+(bCrosslanguage?_ws:_dir)+"\"";
		data[2] = rev_type;
		data[3] = Session("uid");
		data[4] = "\""+(insfld["rev_title"]?insfld["rev_title"]:"")+"\"";
		data[5] = "\""+(insfld["rev_desc"]?insfld["rev_desc"]:"")+"\"";
		data[6] = "\""+(insfld["rev_header"]?insfld["rev_header"]:"")+"\"";
		data[7] = "\""+(insfld["rev_rev"]?insfld["rev_rev"]:"")+"\"";
		data[8] = "\""+(insfld["rev_publisher"]?insfld["rev_publisher"]:"")+"\"";
		data[9] = insfld["rev_rt_cat"]?insfld["rev_rt_cat"]:"null";
		data[10] = "SYSDATE()";

		var iSQL = "insert into "+_db_prefix+"review (rev_id,rev_dir_lng,rev_rt_typ,rev_crea_acc_id,rev_title,rev_desc,rev_header,rev_rev,rev_publisher,rev_rt_cat,rev_crea_date) values (" + data.join(",") + ")";
		if(bChangeHistory)
			Session("chh") = (Session("chh")?Session("chh"):"") + iSQL + "\r\n\r\n";
		oDB.exec(iSQL);
		if(bDebug)
			Response.Write(iSQL+"<br><br>");
	}

	var checkformarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		checkformarr[new String(checkarr[i])] = Request.Form("chk_"+checkarr[i]).Item;

	var bSubmitted	  = Request.TotalBytes==0?false:true;
	if (act == _T["refresh"] || act== '')
		bSubmitted = false;	
		
	// GENERATE CHECKBOX ARRAY PARAMETERS

	var pubarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		if (checkformarr[checkarr[i]])
		{
			var tmp = checkformarr[new String(checkarr[i])].split(",");
			for (var j=0 ; j<tmp.length ; j++)
				pubarr[new Number(tmp[j])] = pubarr[new Number(tmp[j])]?(pubarr[new Number(tmp[j])] + (1<<i) ):(1<<i);
		}
	
	//////////////////////////////////////////////////////////////
	//  P A G E   N A V I G A T I O N  I N I T I A L I S E R S  //
	//////////////////////////////////////////////////////////////
	
	var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):1;
	var spp = 10;  // MAX NAVIGATIONBAR WIDTH
	var ipp = 25; // ITEMS PER PAGE
	var maxrec = 1000;		
	
	// Q U E R Y
	
	var lSQL = "select count(*) from "+_db_prefix+"review where rev_rt_typ = "+rev_type+" and rev_dir_lng = \""+(bCrosslanguage?_ws:_dir)+"\""+(cat>0?(" and rev_rt_cat = "+cat):"")+" and (rev_pub & 8) = 0";
	var overviewlength = oDB.get(lSQL)*tablefld.length;
	
	//Response.Write(lSQL+"<br><br>")	

	var listfilter = ""
	
	
	var allowdbf = Request.QueryString("db").Item;
	if(allowdbf && allowdbf.decrypt("nicnac")!="nicnac")
		allowdb = allowdb?(allowdb+","+allowdbf.decrypt("nicnac")):allowdbf.decrypt("nicnac");

	if(oDB.permissions([zerofill(rev_type,2)+"_edit"]) && !oDB.permissions([zerofill(rev_type,2)+"_admin"]) && !allowdbf)
		listfilter += " and  0 ";
	//else if (oDB.permissions([zerofill(rev_type,2)+"_edit"]) && allowdbf  && allowdbf.decrypt("nicnac")=="nicnac")
	//	listfilter += "and rev_id IN ("+allowdbf+") ";
	else if (oDB.permissions([zerofill(rev_type,2)+"_edit"]) && allowdb)
		listfilter += "and rev_id IN ("+allowdb+") ";
		
		//Response.Write(listfilter)
		
	if(typeof(rev_search)!="undefined")
	{
		for(var i=0;i<rev_search.length;i++)
		{ 
			var val = Request.Form(rev_search[i][1]).Item;
			if(val)
			{	
				idval = val.length>8?val.decrypt("nicnac"):val;
				if(isNaN(idval) || !idval)
				    listfilter += " and "+rev_search[i][1]+" LIKE \"%"+val.replace(/"/g,"\\\"")+"%\" "
				else
					listfilter += " and rev_id = "+idval+" ";
			}
		}
	}
	
	

	
	var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(pag-1)*ipp+","+ipp);
	var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_rt_typ = "+rev_type+" and rev_dir_lng = \""+(bCrosslanguage?_ws:_dir)+"\""+(cat>0?(" and rev_rt_cat = "+cat):"")+" "+listfilter+" and (rev_pub & 8) = 0 order by rev_title,rev_desc "+limit;
	if(bDebug)
		Response.Write("<br><br>" + SQL);
	var overview = oDB.getrows(SQL);


	/////////////////////////////////////
	//  P A G E   N A V I G A T I O N  //
	/////////////////////////////////////
 

	var n = Math.round(overviewlength/(ipp*tablefld.length)+0.499);
	var begin = 0;

	var pgnav = "";	

	
	
	if(bAdmin || !bGui)
	{
		if (pag == 0)
			pgnav += "<font color=#800000 title='"+(_T["nav_max_items"]?_T["nav_max_items"].replace(/_#_/g,maxrec):"")+"'><b>["+_T["nav_all"]+"]</b></font>&nbsp;&nbsp; ";
		else
		{
			pgnav += "<a href="+(bSpiderSafeURL?(SpiderSafeURL+"_Q_pag_E_0"+SpiderSafeExt+_extraurl+"#subtop"):"?pag=0"+_extraurl+"#subtop")+" title='"+(_T["nav_max_items"]?_T["nav_max_items"].replace(/_#_/g,maxrec):"")+"' class=small>["+_T["nav_all"]+"]</a>&nbsp;&nbsp; ";
					
			//if (pag>1)
				pgnav += "<a href=?pag=1#subtop class=small>["+_T["nav_start"]+"]</a>&nbsp; "
					  +  "<a href="+(bSpiderSafeURL?(SpiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag-(pag>1?1:0))+_extraurl+"#subtop><img src=../images/lnav.gif border=0 title='"+_T["nav_prev"]+"' style=vertical-align:text-top></A>&nbsp;&nbsp;";
			begin = pag-Math.round(spp/2)<0 ? 0 : (pag-Math.round(spp/2));
			begin = spp/2>(n-pag-1) ? (n-spp) : begin;
			begin = begin<=0 ? 0 : begin;
		}
	
		for( var i=begin+1 ; i <= begin+spp && i <= n ; i++ )
				if (i == pag)
					pgnav += "<font color=#800000><b>["+i+"]</b></font>&nbsp;&nbsp;";
				else
					pgnav += "<a href="+(bSpiderSafeURL?(SpiderSafeURL+SpiderSafeExt):"")+"?pag="+i+_extraurl+"#subtop class=small>["+i+"]</a>&nbsp; ";
	
		//if (pag<n)
			pgnav += "<a href="+(bSpiderSafeURL?(SpiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag+(pag<n?1:0))+_extraurl+"#subtop><img src=../images/rnav.gif border=0 title='"+_T["nav_next"]+"' style=vertical-align:text-top></a>"
					+ "&nbsp;<a href=?pag="+n+_extraurl+"#subtop class=small title='"+n+"'>["+_T["nav_end"]+"]</a>";
	}
	
	var ippl = ipp*tablefld.length;
	if (pag==0)
		ippl = overviewlength>(maxrec*tablefld.length)?(maxrec*tablefld.length):overviewlength;
	var ipps = pag==0?0:ippl*(pag-1);
	



	// E M A I L   C O L L E C T I O N
	
	var emailref = new Array();
	var nameref = new Array();
	var users = oDB.getrows("select ds_id,ds_data03,ds_title,ds_desc from "+_db_prefix+"blackbabyset where ds_rev_id = 661");

	for (var i=0; i<users.length ; i+=4)
	{
		emailref[users[i]] = users[i+1];
		nameref[users[i]] = users[i+2] + " "+ users[i+3];
	}
	
	
	
	// C A T E G O R Y   C O L L E C T I O N
	
	var catref = new Array();
	var cats = oDB.getrows("select rt_id,rt_name from "+_db_prefix+"reviewtype where rt_id <> rt_parent_id and rt_typ = "+rev_type);
	for (var i=0; i<cats.length ; i+=2)
		catref[cats[i]] = cats[i+1];

	// U P D A T E

	if (act == _T["save"] || act == _T["delete"])
	{
		var bDoUpdate = true;
		var txt = "";
		
		for( var i=0 ; i < overview.length ; i+= tablefld.length )
		{
			var check_mask = (1<<(checkarr.length))-1
			var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
			
			if ((pub & check_mask) != (overview[i+enumfld["rev_pub"]] & check_mask) && (Number(pub) & 8) && bCrosslanguage==true)
			{
				bDoUpdate = false;
				
				var deftablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub");
				var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+overview[i+enumfld["rev_id"]]
				var datadef = oDB.getrows(sSQL);
				var defenumfld = new Array();
				for (var j=0; j<deftablefld.length ; j++)
					defenumfld[deftablefld[j]] = j;
					
				if(datadef[defenumfld["rev_publisher"]] && datadef[defenumfld["rev_publisher"]]!=null)
				{
					var arr = datadef[defenumfld["rev_publisher"]].split(",");
					var dmasterdb = arr[0];
					var ddetaildb = arr[1];
				}
				else
				{
					var dmasterdb = "dataset";
					var ddetaildb = "datadetail";
				}
				
				// lookup if any data exists
				var cSQL = "select count(*) from "+_db_prefix+dmasterdb+" where ds_rev_id = "+overview[i+enumfld["rev_id"]];
				var datasetlen = oDB.get(cSQL);
				
				if(ddetaildb)
				{
					var cSQL = "select count(*) from "+_db_prefix+ddetaildb+" where rd_ds_id = "+overview[i+enumfld["rev_id"]];
					var datadetaillen = oDB.get(cSQL);
				}
				
				txt +=  (dmasterdb && datasetlen>0?("<b>"+dmasterdb+" "+overview[i+enumfld["rev_id"]]+"</b> "+datasetlen+" "+_T["nav_items"]+"<br>"):"")
					   +(ddetaildb && datadetaillen>0?("<b>"+ddetaildb+"</b> "+datadetaillen+" "+_T["nav_items"]+"<br>"):"")
				
				if(dmasterdb && act == _T["delete"])
				{
					var dSQL = "delete from "+_db_prefix+dmasterdb+" where ds_rev_id = "+overview[i+enumfld["rev_id"]];
					//Response.Write("TODO !! "+dSQL+"<br>");
					oDB.exec(dSQL);
					Response.Write("DELETED "+datasetlen+" rows from "+dmasterdb+" "+overview[i+enumfld["rev_id"]]+"<br>");
				}
				
				if(ddetaildb && act == _T["delete"])
				{
					var dSQL = "delete from "+_db_prefix+ddetaildb+" where rd_ds_id = "+overview[i+enumfld["rev_id"]];
					//Response.Write("TODO !! "+dSQL+"<br>");
					oDB.exec(dSQL);
					Response.Write("DELETED "+datasetlen+" rows from "+ddetaildb+" "+overview[i+enumfld["rev_id"]]+"<br>");
				}
			}
		}
		
		
		
		
		if(!txt || act == _T["archive"])
			bDoUpdate = true;
		
		if(bDoUpdate)
		{
			for( var i=0 ; i < overview.length ; i+= tablefld.length )
			{
				var check_mask = (1<<(checkarr.length))-1
				var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
				if ((pub & check_mask) != (overview[i+enumfld["rev_pub"]] & check_mask))
				{
					//var history =  overview[i+enumfld["rev_id"]] + ",\"" + fr + "\",\"" +  Session("uid") + "\",\"" +((pub&1)==1?"+":"-") + "\",\"" + ( typeof(overview[i+enumfld["rev_date_published"]])=="date"?new Date(overview[i+enumfld["rev_date_published"]]).format("%d-%m-%Y %H:%M"):""  ) + "\",\"" + (overview[i+enumfld["rev_title"]]?overview[i+enumfld["rev_title"]].substring(0,35):"") + "\"<br>";
					var uSQL = "update "+_db_prefix+"review set rev_pub = (rev_pub & ~"+check_mask+") | "+pub+" where rev_id = "+overview[i+enumfld["rev_id"]];
					
					if(bChangeHistory)
						Session("chh") = (Session("chh")?Session("chh"):"") + uSQL + "\r\n\r\n";
					
					//Response.Write(uSQL)
					oDB.exec(uSQL);
				}
			}
		}
		
		//Response.Write(SQL+"<br>");
		//Response.Flush();
		var overview = oDB.getrows(SQL);
	}

	var commands = "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["refresh"]+"\" style=height:17px;font-size:9px>";
	if(bAdmin)
	{
		commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["new"]+"\" style=height:17px;font-size:9px>";
		commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["save"]+"\" style=height:17px;font-size:9px>";
	}

%>

<STYLE>
	.qtable { font-family: Verdana; font-size: 10px;}
	.qtable td{ padding-left: 1px;padding-right: 1px;padding-top: 1px;padding-bottom: 1px;white-space: nowrap;}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
	.wbtn { background-color:#FFFFFF; }
	.gchk { background-color:#E0E0E0; }
</STYLE>

<form method=post name=main>

<%=search%>

<%

		if(txt)
			Response.Write("<center>"+sbox("<table cellspacing=0 cellpadding=5><tr><td bgcolor=#FFFFFF class=body>"+txt+"<br><input type=submit name=act value=\""+_T["delete"]+"\"> <input type=submit name=act value=\""+_T["archive"]+"\"></td></tr></table>")+"</center>");


%>


<%=choice%>
<center>
<%=commands%>&nbsp;&nbsp;<%=overviewlength<ipp?"":pgnav%><br><br>

<%



var oPATCH = new PATCH();
oPATCH.param["ztype"] = zerofill(rev_type,2);


if(bGui)
{


Response.Write("<table><tr>")

//rev_fnct.length=rev_fnct.length?rev_fnct.length-1:0;

	for(var i=0;i<rev_fnct.length;i++)
	{
		if(rev_fnct[i]=="iedit")
			rev_fnct[i] = "";
	}

	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
		
		switch(overview[i+enumfld["rev_pub"]] & 3)
		{
			case 1: var rowcolor = " style=background-color:#EAEAFF"; break;
			case 2: var rowcolor = " style=background-color:#EAFFEA"; break;
			case 3: var rowcolor = " style=background-color:#CADFDF"; break;
			default: var rowcolor = ""; break;
		}
		
		if (overview[i+enumfld["rev_title"]])
			overview[i+enumfld["rev_title"]] = overview[i+enumfld["rev_title"]].substring(0,35)
			
		if (overview[i+enumfld["rev_desc"]])
			overview[i+enumfld["rev_desc"]] = "<br><small>"+overview[i+enumfld["rev_desc"]]+"</small>";
		
		if (overview[i+enumfld["rev_email"]])
			overview[i+enumfld["rev_email"]] = "<a href=mailto:"+overview[i+enumfld["rev_email"]]+">"+overview[i+enumfld["rev_email"]]+"</a>";			
		
		oPATCH.param["id"]  = overview[i+enumfld["rev_id"]];
		oPATCH.param["cid"] = oPATCH.param["id"].toString().encrypt("nicnac");
		oPATCH.param["extraurl"] = _extraurl;
		oPATCH.param["pub"] = overview[i+enumfld["rev_pub"]];
		oPATCH.param["cat"] = overview[i+enumfld["rev_rt_cat"]];
		
		// CONVERT REV_RT_CAT INTO READABLE CAT NAMES
		var catname = enumtypes[oPATCH.param["cat"]];
		if(catname) overview[i+enumfld["rev_rt_cat"]] = catname;		
		
		if((i/tablefld.length % 5) == 4)
			Response.Write("</tr><tr>");
		
		if((oPATCH.param["pub"]&9)==1 || bAdmin==true)
		{
			Response.Write("<td width=180 height=180>");
		
			Response.Write("<table cellspacing=0 cellpadding=0>");
			Response.Write("<tr><td>");
			if(((oPATCH.param["pub"] >> 16) & 1) == 1)
				var linkstr = "<img src=../"+_ws+"/images/ico"+zerofill(oPATCH.param["id"],10)+"_1.jpg border=0 height=100 width=100>";
			else
				var linkstr = "<img src=../images/i_database.gif border=0 height=100 width=100>";

			if((oPATCH.param["pub"]&4)==0)
				linkstr = sbox("<a href="+oPATCH.param["ztype"]+"_edit_dlg.asp?id="+oPATCH.param["cid"]+_extraurl+" "+(rev_fnct[_i]=="edit"?"target=_blank":"")+">"+linkstr+"</a>")
			else
				linkstr = linkstr.replace(/border=0/,"border=1");
		
		    //if((pub&1)!=1) linkstr = "<a href="+oPATCH.param["ztype"]+"_edit_dlg.asp?id="+oPATCH.param["cid"]+_extraurl+" "+(rev_fnct[_i]=="edit"?"target=_blank":"")+">edit</a>"
		
			Response.Write(linkstr);
			
			if(bAdmin)
			{
				Response.Write("</td></tr><tr><td>");
				
				for (var j=0;j<checkarr.length;j++)
					Response.Write("<span class=gchk><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["rev_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></span>");
				
				var i_crea = overview[i+enumfld["rev_crea_acc_id"]];
				var i_mod = overview[i+enumfld["rev_mod_acc_id"]];
				
				Response.Write("&nbsp;<span class=small><a href='mailto:"+emailref[i_crea]+"' title='"+nameref[i_crea]+" "+new Date(overview[i+enumfld["rev_crea_date"]]).format("%d-%m-%Y %H:%M:%S")+"'>"+(i_crea?i_crea:"")+"</a></span>"); // title
				Response.Write("&nbsp;<span class=small><a href='mailto:"+emailref[i_mod]+"' title='"+nameref[i_mod]+" "+new Date(overview[i+enumfld["rev_mod_date"]]).format("%d-%m-%Y %H:%M:%S")+"'>"+(i_mod?i_mod:"")+"</a></span>"); // desc
			}
			
			Response.Write("</td></tr><tr><td align=center>");
			Response.Write("<table cellspacing=0 cellpadding=0><tr><td>");
			
			oPATCH.controlbuttons(rev_fnct,true);
			
			Response.Write("</td><td>");
			for(var j=0;j<rev_cols.length;j++)
			{
				var value = overview[i+enumfld[rev_cols[j]]];
				switch(rev_cols[j])
				{
					default:
						Response.Write("<span class=body>"+(value?value:"")+"</span>");
				}
			}
			Response.Write("</td></tr></table>");
			
			Response.Write("</td></tr>");
			Response.Write("</table>");
		}
		
		Response.Write("</td>");
		
		
	}	

Response.Write("</tr></table>");




}
else
{
%>

<table cellspacing=1 class=qtable width=570>
<colgroup>
<%
	if(bAdmin)
	{
		Response.Write("<col>\r\n<col>\r\n");
		for (var i=1;i<checkarr.length;i++)
			Response.Write("<col style=\"text-align:center;\" bgcolor=#E0E0E0>\r\n");
		
		Response.Write("<col style=\"text-align:center;\">\r\n<col style=\"text-align:center;\">\r\n");
		
		for(var j=0;j<rev_cols.length;j++)
			Response.Write("<col style=\"text-align:right;\">\r\n");  	
	}	
%>
</colgroup>
<tr>
<%="<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:35 title='"+rev_fnct.join("'></td><td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:35 title='")+"'></td>"%>

<%
	if(bAdmin)
	{
		for (var i=0;i<checkarr.length;i++)
			Response.Write("<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='"+checktitles[i]+"'>"+checkarr[i]+"</td>");
%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='Created by'>C</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='Modified by'>M</td>
<%
	}
	
	for(var j=0;j<rev_cols.length;j++)
		Response.Write("<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold>"+colnames[rev_cols[j]]+"</td>\r\n");
%>
</tr>
<%

	
	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
		
		switch(overview[i+enumfld["rev_pub"]] & 3)
		{
			case 1: var rowcolor = " style=background-color:#EAEAFF"; break;
			case 2: var rowcolor = " style=background-color:#EAFFEA"; break;
			case 3: var rowcolor = " style=background-color:#CADFDF"; break;
			default: var rowcolor = ""; break;
		}			
		
		if (overview[i+enumfld["rev_title"]])
			overview[i+enumfld["rev_title"]] = overview[i+enumfld["rev_title"]].substring(0,35);
		
		if (overview[i+enumfld["rev_email"]])
			overview[i+enumfld["rev_email"]] = "<a href=mailto:"+overview[i+enumfld["rev_email"]]+">"+overview[i+enumfld["rev_email"]]+"</a>";			
	
		
		oPATCH.param["id"]  = overview[i+enumfld["rev_id"]];
		oPATCH.param["cid"] = oPATCH.param["id"].toString().encrypt("nicnac");
		oPATCH.param["extraurl"] = _extraurl;
		oPATCH.param["pub"] = overview[i+enumfld["rev_pub"]];
		oPATCH.param["cat"] = overview[i+enumfld["rev_rt_cat"]];
		
		// CONVERT REV_RT_CAT INTO READABLE CAT NAMES
		var catname = enumtypes[oPATCH.param["cat"]];
		if(catname) overview[i+enumfld["rev_rt_cat"]] = catname;		
		
		Response.Write("<tr"+rowcolor+">");
		Response.Write(oPATCH.controlbuttons(rev_fnct))
		
		if(bAdmin)
		{
			for (var j=0;j<checkarr.length;j++)
				Response.Write("<td class=gchk><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["rev_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></td>");
			
			var i_crea = overview[i+enumfld["rev_crea_acc_id"]];
			var i_mod = overview[i+enumfld["rev_mod_acc_id"]];
			
			Response.Write("<td><a href='mailto:"+emailref[i_crea]+"' title='"+nameref[i_crea]+" "+new Date(overview[i+enumfld["rev_crea_date"]]).format("%d-%m-%Y %H:%M:%S")+"'>"+(i_crea?i_crea:"")+"</a></td>"); // title
			Response.Write("<td><a href='mailto:"+emailref[i_mod]+"'  title='"+nameref[i_mod]+" "+new Date(overview[i+enumfld["rev_mod_date"]]).format("%d-%m-%Y %H:%M:%S")+"'>"+(i_mod?i_mod:"")+"</a></td>"); // desc
		}
		
		for(var j=0;j<rev_cols.length;j++)
		{
			var value = overview[i+enumfld[rev_cols[j]]]
			switch(rev_cols[j])
			{
				default:
					Response.Write("<td>"+(value?value:"")+"</td>");
			}
		}
		Response.Write("</tr>\r\n");
	}	
%>
</table>
<%
}
%>

<br><%=commands%>&nbsp;&nbsp;<%=overviewlength<ipp?"":pgnav%>
</center>
<br>

<input type=hidden name=act>
</form>