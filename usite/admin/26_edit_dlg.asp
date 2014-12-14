<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");
	
	var rev_type = 26;
	var rev_dir = "../images/gallery";

	var perm_languages = oDB.getSetting("LNG",zerofill(rev_type,2)+"_");
	var perm_languages = perm_languages?perm_languages:oDB.getSetting("LNG","___");
	var imglen = oDB.getSetting("IMG",zerofill(rev_type,2)+"_");
	var distributed_languages = oDB.getSetting("DIS",zerofill(rev_type,2)+"_");
	distributed_languages = !distributed_languages?("'"+_dir+"'"):distributed_languages;
	
	//var imglen = 1;
	var bUpload = false;
	var bSaved  = false;

	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var getid = Request.QueryString("getid").Item?Number(Request.QueryString("getid").Item.toString().decrypt("nicnac")):0;
	
	//var refcat = Request.QueryString("refcat").Item?Number(Request.QueryString("refcat").Item.toString().decrypt("nicnac")):"";
	//var recurse = Request.QueryString("recurse").Item?Request.QueryString("recurse").Item:"";
	var bExists = Number( oDB.get("SELECT rev_id FROM "+_db_prefix+"review where rev_id="+id) )==Number(id);
	var now = new Date(oDB.get("SELECT UNIX_TIMESTAMP()")*1000);

	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\"")// and rt_typ = "+rev_type);
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;
			
	var ctxtwidth = 26;
	var ctxawidth = 23;
	var ctxaheight = 10;
	//var my_date=new Date("October 12, 1988 13:14:00")

	var oGUI		= new GUI();
	var oButton		= new oGUI.BUTTON();
	
	var tablefld = new Array("rev_id","rev_ref","rev_title","rev_desc","rev_header","rev_rev","rev_rt_cat","rev_address","rev_phone","rev_fax","rev_mod_acc_id","rev_mod_date","rev_publisher","rev_email","rev_url","rev_date_published","rev_pub","rev_code" ,"rev_author","rev_finish") 
	var formfld  = new Array("id"   ,"refcat"       ,"title"    ,"desc"    ,"header"   ,"rev"    ,"category"  ,"address"   ,"phone"    ,"fax"    ,"mod_acc"	    ,"mod_date"    ,"publisher"    ,"email"   ,"url"    ,"pub_date"         ,"status","code"     ,"author"   ,"finish"     ,"act", "source")
	var formfunction = new Array();
	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;
	
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////

	try { var Upload = Server.CreateObject("Persits.Upload.1");  var FormCollection = Upload.Form; bUpload = true; } catch(e) {}
	try { var Count = Upload.Save(Server.Mappath ("../images/upload")); bSaved = true; } catch(e) {}

	/////////////////////////////////////////////////////////////
	//  C O L L E C T   M U L T I P A R T   F O R M - D A T A  //
	/////////////////////////////////////////////////////////////
	
	//var bMultipart = skin_mode==0?false:true;
	bMultipart = false;

	var bSubmitted = false;
	if (bUpload==true && bMultipart)
		bSubmitted = !new Enumerator(FormCollection).atEnd();
	else
		bSubmitted = Request.TotalBytes==0?false:true;

	var formarr = new Array();
	formarr[0] = id;
	var act = "";

	if (!bSubmitted)
	{
		var load_id = getid?getid:id;		
		formarr = oDB.getrows("SELECT "+tablefld.join(",")+" FROM "+_db_prefix+"review where rev_id="+load_id);
		
		// OVERWRITE TO CURRENT LANGUAGE WHEN GETTING A RECORD FROM ANOTHER LANGUAGE
		if (getid>0)
			formarr[enumfld["language"]] = _dir;
		
		if(formarr[enumfld["date_published"]]==null)
			formarr[enumfld["date_published"]] = new Date();
		else
			formarr[enumfld["date_published"]] = new String(formarr[enumfld["date_published"]]);
	}
	else
	{
		if(bMultipart==true)
		{
			for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
				var idx = enumfld[objEnum.item().name];
				formarr[idx] = objEnum.item().value; //? ("\""+Server.HTMLEncode(objEnum.item().value.replace(/\x22/g,"\\\""))+"\""):"\"\""
			}
		}
		else
		{
			var formarr = new Array();
			for (var i=0;i<formfld.length;i++)
				formarr[i] = Request.Form(formfld[i]).Item;
			act = Request.Form("act").Item;
		}

		if(formarr[enumfld["date_published"]])
			formarr[enumfld["date_published"]] = formarr[enumfld["date_published"]].toString().toDate();
	}

		


	/////////////////////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S   //
	////////////////////////////////////////////////////////

	// REF_ID
	
	var refcat = formarr[enumfld["refcat"]]
	if(bSubmitted)
	{
		formarr[enumfld["status"]] = Number(formarr[enumfld["status"]]) & ~16 | (formarr[enumfld["source"]]=="on"?16:0)
		formfunction[enumfld["status"]] = "(" + tablefld[enumfld["status"]] + " & ~16 | " + (formarr[enumfld["source"]]=="on"?16:0) + ")"
	}


	//  CATEGORIES  (BINARY TREE)

	var oGUI		= new GUI();
	
	var oTREE		= new oGUI.TREE();
	var tree		= oTREE.load(categories);
	var rev_categories = oTREE.combobox("name=category size=1",formarr[enumfld["category"]]);

	var tree	  = oTREE.load(pages);
	var rev_pages = oTREE.combobox("name=refcat size=1",formarr[enumfld["refcat"]]);

	///////////////////////
	//  S E C U R I T Y  //
	///////////////////////

	if ((oDB.get("SELECT rev_pub FROM "+_db_prefix+"review where rev_id="+id) & 4) == 4)
	{
		Response.Clear();
		Response.Write("<script>window.close()</script>");
		Response.End();
	}

	///////////////////////////////////////
	//  D A T A B A S E   S T O R A G E  //
	///////////////////////////////////////

	if (bSubmitted && bExists==true)
	{
		formarr[enumfld["mod_acc"]] = Session("uid");
		formarr[enumfld["mod_date"]] = now.format("%Y-%m-%d %H:%M:%S");
	}
	
	var header_str = formarr[enumfld["header"]];
	
	var botharr = new Array();
	for (var i=1;i<tablefld.length;i++)
	{
        if(formfunction[i])
			botharr[i-1] = tablefld[i] + "=" + formfunction[i];
		else
			botharr[i-1] = tablefld[i] + "= " + (formarr[i] && typeof(formarr[i])=="string"?("\""+formarr[i].replace(/\x22/g,"\\\"")+"\""):formarr[i]?formarr[i]:"null");
	}

	var singlearr = new Array();
	for (var i=0;i<tablefld.length;i++)
		singlearr[i] = (typeof(formarr[i])=="string"?formarr[i].replace(/\x22/g,"\\\""):formarr[i]);

	if (bSubmitted)
	{
		if (bExists==true)
		{
			var uSQL = "update "+_db_prefix+"review set " + botharr.join(",") + " where rev_id="+id			
			//Response.Write(uSQL)
			
			try { oDB.exec(uSQL) }
			catch(e)
			{ Response.Write("<!--"+uSQL+"-->\r\n")}
			
				
			////////////////////////////////////////////////
			
		}
		else
		{
			var SQL = "insert into "+_db_prefix+"review ("+tablefld.join(",")+") values (\""+singlearr.join("\",\"")+"\")"
			try { oDB.exec(SQL) }
			catch (e)
			{ Response.Write("<!--"+SQL+"-->\r\n") }
		}
		
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");
	}
%>

<style>
	.qtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.qtable td{ background-color:white;padding-left: 2px;padding-right: 2px;padding-top: 2px;padding-bottom: 2px;white-space: nowrap;}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
</style>


<form method="post" name="main" <%=bMultipart==true?"ENCTYPE=\"multipart/form-data\"":""%> action="#down">

<center>

<table cellspacing="1" class="gtable" border="1" width="<%=_body_width%>">
<tr><td align=right style=background-color:white>email »</td><td align=right style=background-color:#e0e0e0><INPUT name=email type=text value="<%=formarr[enumfld["email"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=desc type=text value="<%=formarr[enumfld["desc"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« interface</td></tr>
<tr height=20><td colspan=4></td></tr>
<tr><td align=right style=background-color:white>POP3 server »</td><td align=right style=background-color:#e0e0e0><INPUT name=title type=text value="<%=formarr[enumfld["title"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=fax type=text value="<%=formarr[enumfld["fax"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« POP3 port</td></tr>
<tr><td align=right style=background-color:white>POP3 login »</td><td align=right style=background-color:#e0e0e0><INPUT name=address type=text value="<%=formarr[enumfld["address"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=publisher type=password value="<%=formarr[enumfld["publisher"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« POP3 password</td></tr>
<tr height=20><td colspan=4></td></tr>
<tr><td align=right style=background-color:white>SMTP server »</td><td align=right style=background-color:#e0e0e0><INPUT name=author type=text value="<%=formarr[enumfld["author"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=header type=text value="<%=formarr[enumfld["header"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« SMTP port</td></tr>
<tr><td align=right style=background-color:white>SMTP login »</td><td align=right style=background-color:#e0e0e0><INPUT name=finish type=text value="<%=formarr[enumfld["finish"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=code type=password value="<%=formarr[enumfld["code"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« SMTP password</td></tr>
<tr height=20><td colspan=4></td></tr>
<tr><td></td><td></td><td align=left style=background-color:#e0e0e0><INPUT name=url type=text value="<%=formarr[enumfld["url"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« url</td></tr>
</table>

<a NAME="down"></a>
<center>
<%
	var commands = "&nbsp;<input type=\"button\" name=\"act\" value=\""+_T["admin_cancel"]+"\" onclick='top.close()'>"
				+ "&nbsp;&nbsp;&nbsp;&nbsp;"
				+ "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["admin_save"]+"\">"
%>
<br>
<%=commands%>
<!--input type=button value='cancel' onclick='top.close()'>&nbsp;&nbsp;&nbsp;&nbsp;<input type=button value='save' onclick="main.mode.value='admin_review';main.submit();"-->
</center>

</center>


<input type="hidden" name="mode">
<input type="hidden" name="crea_date" value="<%=typeof(formarr[enumfld["crea_date"]])=="date"?new Date(formarr[enumfld["crea_date"]]).format("%Y-%m-%d %H:%M:%S"):formarr[enumfld["crea_date"]]%>">
<input type="hidden" name="status" value="<%=formarr[enumfld["status"]]%>">
</form>

<br><br>





<!--#INCLUDE FILE = "../skins/adfooter.asp" -->