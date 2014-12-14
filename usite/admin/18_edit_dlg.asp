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
	
	var rev_type = 16;
	var rev_cat_type = 14;
	var rev_dir = "../../";


	// LOAD FROM FILE
	
	var FSO = Server.CreateObject("Scripting.FileSystemObject")
	var Path = Server.MapPath("../");
	var Folder = FSO.GetFolder(Path);
	
	Response.Write(Path+"<br>")

	var FileCollection = Folder.Files;
	var FolderCollection = Folder.SubFolders;
	
	/*	
	var FileList = new Array();
	var i = 0;
	for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
		//if (objEnum.item().name.charAt(0)=="2")
			FileList[i++] = objEnum.item().name;


		for (var i=0;i<FileList.length;i++)
			Response.Write(FileList[i]+"<br>")
		Response.Write(FileList.length);
	*/

	var FolderList = new Array();
	var i = 0;

	for (var objEnum=new Enumerator(FolderCollection); !objEnum.atEnd() ; objEnum.moveNext())
		//if (objEnum.item().name.charAt(0)=="2")
			FolderList[i++] = objEnum.item().name;

		for (var i=0;i<FolderList.length;i++)
			Response.Write(FolderList[i]+"<br>")
		Response.Write(FolderList.length);

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
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_type+" and rt_dir_lng = \""+_dir+"\"");
		for (var i=0; i<catfld.length ; i++)
			enumcatfld[catfld[i]] = i;
			
	var enumpagfld = new Array();
	var pagfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var pages = oDB.getrows("select "+pagfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_cat_type+" and rt_dir_lng = \""+_dir+"\"");
		for (var i=0; i<pagfld.length ; i++)
			enumpagfld[pagfld[i]] = i;			

	//Response.Write("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_cat_type+" and rt_dir_lng = \""+_dir+"\"");

	//var languages = oDB.getrows( "SELECT distinct ws_lngcode, ws_lngname FROM "+_db_prefix+"website " + (    perm_languages.length>0 ? ( "where ws_lngcode IN ("+perm_languages+")" ) :( "where ws_lngcode IN ('"+_language+"')" )  )   );

	//var refcat = refcat?refcat:id;

	var ctxtwidth = 26;
	var ctxawidth = 23;
	var ctxaheight = 10;
	//var my_date=new Date("October 12, 1988 13:14:00")

	var oGUI		= new GUI();
	var oButton		= new oGUI.BUTTON();
	
	var tablefld = new Array("rev_id","rev_ref","rev_title","rev_desc","rev_header","rev_rev","rev_actimg","rev_rt_cat","rev_address","rev_phone","rev_fax","rev_crea_acc_id","rev_crea_date","rev_mod_acc_id","rev_mod_date","rev_publisher","rev_email","rev_url","rev_date_published","rev_pub" ) 
	var formfld  = new Array("id"    ,"refcat"     ,"title"    ,"desc"    ,"header"    ,"rev"    ,"actimg"    ,"category"  ,"address"    ,"phone"    ,"fax"    ,"crea_acc"       ,"crea_date"    ,"mod_acc"	     ,"mod_date"    ,"publisher"    ,"email"    ,"url"    ,"pub_date"          ,"status"    ,"act", "source")
	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;
	
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////

	try { var Upload = Server.CreateObject("Persits.Upload.1");  var FormCollection = Upload.Form; bUpload = true; } catch(e) {}
	try { var Count = Upload.Save(Server.Mappath ("../images/upload")); bSaved = true; } catch(e) {}

	//try { var Count = Upload.Save(Server.Mappath ("../../theartserver/images/upload")); bSaved = true; } catch(e) {}


	//Response.Write("*"+bUpload+"* *"+bSaved+"*"+Server.Mappath ("../images/upload")+" "+Count)

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
		formarr[enumfld["status"]] = (formarr[enumfld["status"]] & ~16) | (formarr[enumfld["source"]]=="on"?16:formarr[enumfld["status"]])


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
		botharr[i-1] = tablefld[i] + "=\"" + (typeof(formarr[i])=="string"?formarr[i].replace(/\x22/g,"\\\""):formarr[i]) + "\"" 

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
<tr>
	<td align="right" style="background-color:white"><%=_T["admin_title"]%> »</td><td align="right" style="background-color:#e0e0e0"><input name="title" type="text" value="<%=formarr[enumfld["title"]]%>" size="<%=ctxtwidth%>"></td>
	<td align="left" style="background-color:#e0e0e0" rowspan="2" style="text-align:center">
			
	<script>
	
		function loadXML(_templtext)
		{
			var XMLObj = new ActiveXObject("Microsoft.XMLDOM");
			var _tempxmlstr = "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n"
							  +"<ROOT xmlns:NBOX=\"http://blackbaby.org/ns/GUI\">\r\n"
							  + _templtext
							  +"</ROOT>";		 

			// PARSE TEMPLATE XML
			XMLObj.async = "false";
			XMLObj.loadXML(_tempxmlstr);
			var bXMLValid = XMLObj.parseError.errorCode == 0;
			if(bXMLValid==true)
				bXMLValid = XMLObj.getElementsByTagName("ROOT").item(0).childNodes.item(0).tagName?true:false;
			
			if(bXMLValid)
				return XMLObj.xml
			else
				return "invalid XML"
		}
	</script>		
	<textarea NOWRAP name="header" type="text" cols="45" rows="6"><%=formarr[enumfld["header"]]?Server.HTMLEncode(formarr[enumfld["header"]]):""%></textarea><img src=../images/ii_xmlvalid.gif onclick=alert(loadXML(document.main.header.value))>

	</td>
	<td align="left" style="background-color:white" rowspan="2">« <%=_T["admin_header"]%></td>
</tr>

<tr><td align="right" style="background-color:white"><%=_T["admin_description"]%>&nbsp;»</td><td align="right" style="background-color:#e0e0e0"><input name="desc" type="text" value="<%=formarr[enumfld["desc"]]%>" size="<%=ctxtwidth%>"></td></tr>

<tr><td colspan=4 style=background-color:#e0e0e0>
<center>
<%
if(formarr[enumfld["rev"]])
	editor();
else
	Response.Write("<input name=\"rev\" type=hidden><input type=button value=\"add report\" onclick=\"main.rev.value=' ';main.submit();\">");
%>
</center>
<small>counted <span id=textlength>0</span> report characters</small>


</td>
</tr>
<tr><td align="right" style="background-color:white"><%=_T["admin_category"]%>&nbsp;»</td><td align="right" style="background-color:#e0e0e0"><%=rev_categories%></td><td align=left style=background-color:#e0e0e0><%=rev_pages%><input name=source type=checkbox value="on"<%=(formarr[enumfld["status"]] & 16) == 16?" checked":""%>> <%=_T["admin_sourcecode"]%></td><td align="left" style="background-color:white">«&nbsp;<%=_T["admin_assignto"]%></td></tr>

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
<input type="hidden" name="actimg" value="<%=formarr[enumfld["actimg"]]%>">
<input type="hidden" name="status" value="<%=formarr[enumfld["status"]]%>">
</form>

<br><br>

<script>
function gorefresh()
{
	setTimeout("gorefresh()",5000);
	
	/*
	var plaintxt = stripHtml(main.header.value);	// remove HTML
	plaintxt = plaintxt.replace(/\s+/g,"");			// remove spaces and non-printable chars
	headerlength.innerHTML  = plaintxt.length;
	*/
	
	var plaintxt = stripHtml(main.rev.value);		// remove HTML
	plaintxt = plaintxt.replace(/\s+/g,"");			// remove spaces and non-printable chars
	textlength.innerHTML  = plaintxt.length;
}
window.onload=gorefresh;

function stripHtml(strHTML) 
{
	// Replace all newLinet with .$!$. string
	strOutput = strHTML.replace(/\n/g, ".$!$.")
	// Replace all <script>s with an empty string
	aScript=strOutput.split(/\/script>/i);
	for(i=0;i<aScript.length;i++)
		aScript[i]=aScript[i].replace(/\<script.+/i,"");
	strOutput=aScript.join('');
	// Replace all HTML tag matches with the empty string
	strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
	// Remove empty lines
	strOutput = strOutput.replace(/\.\$\!\$\.\r\s*/g,"")
	// Replace all .$!$. with the empty string
	strOutput = strOutput.replace(/\.\$\!\$\./g,"")
	// Remove empty lines
	strOutput = strOutput.replace(/\r\ \r/g,"")
	//alert(strOutput)
	return strOutput;
}

function copy_images()
{
		var answer = confirm ("Copy all images from master document ?");
		if (answer)
			alert("TODO");
		return;
}
</script>

<%


	function editor()
	{
		if( (formarr[enumfld["status"]] & 16) == 16)
		{
		%>
		<textarea name="rev" id="rev" style="width:<%=_body_width-10%>; height:500" class=utable><%=formarr[enumfld["rev"]]%></textarea>
		<%
		}
		else
		{
		%>
		<script language="Javascript1.2" src="../includes/editor.js"></script>
		<script>
			_editor_url = "../includes/";
		</script>

		<style type="text/css"><!--
		  .btn   { BORDER-WIDTH: 1; width: 26px; height: 24px; }
		  .btnDN { BORDER-WIDTH: 1; width: 26px; height: 24px; BORDER-STYLE: inset; BACKGROUND-COLOR: buttonhighlight; }
		  .btnNA { BORDER-WIDTH: 1; width: 26px; height: 24px; filter: alpha(opacity=25); }

		  body, td { font-family: arial; font-size: 12px; }
		  .headline { font-family: arial black, arial; font-size: 28px; letter-spacing: -2px; }
		  .subhead  { font-family: arial, verdana; font-size: 12px; let!ter-spacing: -1px; }
		--></style>

		<textarea name="rev" id="rev" style="width:620; height:300" class=utable><%=formarr[enumfld["rev"]]%></textarea>
		<br>

		<!--input type=button onclick='alert(main.box2.value)'-->

		<script language="javascript1.2">
		editor_generate('rev'); // field, width, height
		</script>

		<!--a href="javascript:editor_insertHTML('box2','<font style=\'background-color: yellow\'>','</font>');">Highlight selected text</a> -
		<a href="javascript:editor_insertHTML('box2',':)');">Insert Smiley</a-->

		<%
		}
	}
%>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->