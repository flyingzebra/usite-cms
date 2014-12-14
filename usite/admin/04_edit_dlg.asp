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
	
	var rev_type = 4;
	var rev_typedesc = "agenda"
	var perm_languages = oDB.getSetting(zerofill(rev_type,2)+"_L");	
		
	var imglen = 1;
	var bUpload = false;
	var bSaved  = false;
	var bDebug  = false;

	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var refid = Request.QueryString("refid").Item?Number(Request.QueryString("refid").Item.toString().decrypt("nicnac")):"";

	var bExists = Number( oDB.get("SELECT rev_id from "+_db_prefix+"review where rev_id="+id) )==Number(id);
	var now = new Date(oDB.get("SELECT UNIX_TIMESTAMP()")*1000);

	var languages = oDB.getrows("SELECT distinct ws_lngcode,ws_lngname from "+_db_prefix+"website " + ( perm_languages.length>0 ? ( "where ws_lngcode IN ("+perm_languages+")" ) :( "where ws_lngcode IN ('"+_language.substring(0,2)+"')" )  )   );		
	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_"+_language.substring(0,2)).split(",");
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_type);
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;
	
	var refid = refid?refid:id;
	
	var ctxtwidth = 26;
	var ctxawidth = 23;
	var ctxaheight = 10;
	//var my_date=new Date("October 12, 1988 13:14:00")

	var calendarfrom = new Date("January 1, 2004 00:00:00");
	var calendarto =   new Date("January 1, 2006 00:00:00");

	calendarfrom.setDate(1);
	calendarfrom.setHours(0,0,0,0);
	calendarto.setDate(1);
	calendarto.setHours(0,0,0,0);

	var oGUI		= new GUI();
	var oCalendar   = new oGUI.CALENDAR();		// subclass instances
	var oButton		= new oGUI.BUTTON();
	
	oCalendar.monthname = ["J A N U A R I","F E B R U A R I","M A A R T","A P R I L","M E I","J U N I","J U L I","A U G U S T U S","S E P T E M B E R","O K T O B E R","N O V E M B E R","D E C E M B E R"]
	var monthbg = ["d_jan.jpg","d_feb.jpg","d_mar.jpg","d_apr.jpg","d_may.jpg","d_jun.jpg","d_jul.jpg","d_aug.jpg","d_sep.jpg","d_oct.jpg","d_nov.jpg","d_dec.jpg"]		

	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_from","rev_to","rev_rev","rev_rt_cat","rev_address","rev_phone","rev_fax","rev_email","rev_publisher","rev_date_published","rev_url","rev_actimg","rev_mod_acc_id","rev_mod_date","rev_lng_code") 
	var formfld  = new Array("id"    ,"title",   "desc"   ,"header",   "from",   "to",   "rev",  "category" ,"address",   "phone",   "fax",   "email",         "publisher"   ,"pub_date",          "url",   "actimg"   ,"mod_acc"	  ,"mod_date"       ,"language"    ,"datelog" )
	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;
		
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////

	try { var Upload = Server.CreateObject("Persits.Upload.1");  var FormCollection = Upload.Form; bUpload = true; } catch(e) {}
	try { var Count = Upload.Save(Server.Mappath ("../images/upload")); bSave = true; } catch(e) {}

	/////////////////////////////////////////////////////////////
	//  C O L L E C T   M U L T I P A R T   F O R M - D A T A  //
	/////////////////////////////////////////////////////////////
	
	
	var bSubmitted = false;
	if (bUpload==true)
		bSubmitted = !new Enumerator(FormCollection).atEnd();

	var formarr = new Array();
	formarr[0] = id;

	if (!bSubmitted)
	{
		formarr = oDB.getrows("SELECT "+tablefld.join(",")+" from "+_db_prefix+"review where rev_id="+id);
		var found = oDB.getrows("select ad_date from "+_db_prefix+"agdetail where ad_ag_id="+id);
		for (var i=0; i<found.length; i++)
			found[i] = new Date(found[i]).format("%Y-%m-%d");
		var foundstr = "," + found.join(",") + ",";
		
		formarr[enumfld["desc"]] = formarr[enumfld["desc"]]?Server.HTMLEncode(formarr[enumfld["desc"]]):"";
		
		var x=0;
		var detailarr = new Array();
		if(bDebug)
			Response.Write("READING CALENDAR DATA<br>");
		for (var date_inc=new Date(calendarfrom); date_inc < calendarto && x<2000 ; date_inc = new Date(date_inc-(-1000*60*60*24))   )
		{
			
			detailarr[x++] = foundstr.indexOf(date_inc.format(",%Y-%m-%d,"))>=0?1:0;
			if(bDebug)
				Response.Write(date_inc.format(",%Y-%m-%d,")+" "+detailarr[x++]+"<br>")
		}
		

		formarr[enumfld["datelog"]] = detailarr.join("");
	}
	else
	{
		for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var idx = enumfld[objEnum.item().name];
			formarr[idx] = objEnum.item().value; //? ("\""+Server.HTMLEncode(objEnum.item().value.replace(/\x22/g,"\\\""))+"\""):"\"\""
		}
	}	

	//////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S	//
	//////////////////////////////////////////

	//  CATEGORIES

	var oTREE		= new oGUI.TREE();
	
	oTREE.init();
	var tree		= oTREE.load(categories);
	var rev_categories = oTREE.combobox("name=category size=1",formarr[enumfld["category"]]);

	//  L A N G U A G E S
	
	var rev_language = "";
	var rev_languages = "<select name=language><option value=0 "+(!formfld[enumfld["language"]]?"selected":"")+">";
	for (var i=0;i<languages.length;i+=2)
	{	
		if (formarr[enumfld["language"]]==languages[i])
		{
			rev_language = languages[i+1];
			rev_languages += "<option value="+languages[i]+" selected>"+languages[i+1];
		}
		else
			rev_languages += "<option value="+languages[i]+">"+languages[i+1];
	}
	rev_languages += "</select>";
	
	var translate_action = "window.open('add_rev_language_dlg.asp?id="+(formfld[enumfld["refid"]]?formfld[enumfld["refid"]].toString().encrypt("nicnac"):refid.toString().encrypt("nicnac"))+"')";

	///////////////////////
	//  S E C U R I T Y  //
	///////////////////////

	if (formarr[enumfld["pub"]] & 4)
	{
		Response.Clear();
		Response.Write("<script>window.close()</script>");
		Response.End();
	}

	/////////////////////////////////
	//  R E S I Z E   I M A G E S  //
	/////////////////////////////////
	
	if (bUpload)
	{
		var FileCollection = Upload.Files;
	
		var dbnamearr = ["rev_img1","rev_img2"]
		var resizearr = ["100x100","220x100"];
	
		var i = 0;
	
		for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var obj = objEnum.item();
			//Response.Write(obj.name+"<br>"+obj.path+"<br>"+obj.size+"<br>")
			//Response.Write(obj.path.substring(obj.path.length-4,obj.path.length))
			
			if (obj.path.substring(obj.path.length-4,obj.path.length)==".jpg")
			{
				var imgnr = Number(obj.name.substring(4,5));
				var iactimg = enumfld["actimg"];
				formarr[iactimg] = formarr[iactimg] ? (formarr[iactimg] | Math.pow(2,imgnr-1)) : Math.pow(2,imgnr-1);
				var jpeg = Server.CreateObject("Persits.Jpeg");
				jpeg.open( obj.path );
				resizetoRect(jpeg,resizearr[imgnr-1]);

				//obj.ToDatabase(oDB.connectstring,"UPDATE revgallery SET "+dbnamearr[i]+"=?,rev_alias='"+myname+"',rev_url='"+mywebsite+"',rev_email='"+myemail+"',rev_txt='"+mytext+"' WHERE rev_id="+id);
				jpeg.Save(Server.MapPath("../images/agenda") + "\\img"+zerofill(id,10)+"_"+imgnr+".jpg");
			}
			i++;		
		}		
	}
	
	function resizetoRect(picobj,size)
	{
		var sizes = size.split("x");
		var sizex = Number(sizes[0]);
		var sizey = Number(sizes[1]);
		
		if (picobj.height==sizey && picobj.width==sizex)
			return;
			
		maxheight = sizey;
		maxwidth = sizex;		
		
		if (  (picobj.height*sizex/picobj.width) < maxheight )
			resizetoHeight(picobj,sizey,maxwidth);
		else
			resizetoWidth(picobj,sizex,maxheight)
	}	
	
	function resizetoSquare(picobj,size)
	{
		if (picobj.height==size && picobj.width==size)
			return;
			
		maxheight = size;
		maxwidth = size;

		if (  (picobj.height*size/picobj.width) < maxheight )
			resizetoHeight(picobj,size,maxwidth);
		else
			resizetoWidth(picobj,size,maxheight)
	}
	
	function resizetoHeight(picobj,height,maxwidth)
	{
	    picobj.width  *= height/picobj.height;
		picobj.height = height;
		
		if (maxwidth && picobj.width>maxwidth)
		{
			xoffset = (picobj.width-maxwidth)/2
			picobj.Crop(xoffset, 0, maxwidth+xoffset, height );
		}

	}
	
	function resizetoWidth(picobj,width,maxheight)
	{
		picobj.height *= width/picobj.width;
		picobj.width  = width;
	
		if (maxheight && picobj.height>maxheight)
		{
			yoffset = (picobj.height-maxheight)/2
			picobj.Crop(0, yoffset, width, maxheight+yoffset);
		}
	}
	
	/////////////////////////////////
	//  R E A D  D A T E  L O G S  //
	/////////////////////////////////
	
	var purged = new Array();
	var datelog = formarr[enumfld["datelog"]]?formarr[enumfld["datelog"]]:"";
	var arrdatelog = new Array();
	var j=0;
	if(bDebug)
		Response.Write("<br>READING DATE LOGS<br>");
	
	for (var i=0;i<datelog.length;i++)
		if (datelog.substring(i,i+1)!="0")
		{
			arrdatelog[j++] = new Date(calendarfrom - (-i*1000*60*60*24));
			if(bDebug)
				Response.Write(new Date(calendarfrom - (-i*1000*60*60*24))+"<br>")
		}
	
	var from = arrdatelog[0];
	var to =   arrdatelog[arrdatelog.length-1];
	if (to=="")
		to = from;

	formarr[enumfld["from"]] = from?from.format("%Y-%m-%d %H:%M:%S"):from;
	formarr[enumfld["to"]]   = to?to.format("%Y-%m-%d %H:%M:%S"):to;

	if (bExists==true)
	{
		formarr[enumfld["mod_acc"]] = Session("uid");
		formarr[enumfld["mod_date"]] = now.format("%Y-%m-%d %H:%M:%S");
	}
	else
	{
		formarr[enumfld["crea_acc"]] = Session("uid");
		formarr[enumfld["crea_date"]] = now.format("%Y-%m-%d %H:%M:%S");
	}
	
	
	
	
	///////////////////////////////////////
	//  D A T A B A S E   S T O R A G E  //
	///////////////////////////////////////


	var botharr = new Array();
	for (var i=1;i<tablefld.length;i++)
		botharr[i-1] = tablefld[i] + "=\"" + (formarr[i] && typeof(formarr[i])=="string"?formarr[i].replace(/\x22/g,"\\\""):formarr[i]?formarr[i]:"null") + "\"" 


	var singlearr = new Array();
	for (var i=0;i<tablefld.length;i++)
		singlearr[i] = (typeof(formarr[i])=="string"?formarr[i].replace(/\x22/g,"\\\""):formarr[i]);


	formarr[enumfld["from"]] = from?from.format("%d-%m-%Y"):"";
	formarr[enumfld["to"]]   = to?to.format("%d-%m-%Y"):"";

	//Response.Write("SELECT rev_id from "+_db_prefix+"review where rev_id="+id+" : "+oDB.get("SELECT rev_id from "+_db_prefix+"review where rev_id="+id) )
	//Response.Write(formarr.length)

	if (bSubmitted)
	{
		if (bExists==true)
		{
			var SQL = "update "+_db_prefix+"review  set " + botharr.join(",") + " where rev_id="+id
			//Response.Write("<!--"+SQL+"-->\r\n");
			try { oDB.exec(SQL) }
			catch(e)
			{ Response.Write("<!--"+SQL+"-->\r\n")}
		}
		else
		{
			var SQL = "insert into "+_db_prefix+"review ("+tablefld.join(",")+") values (\""+singlearr.join("\",\"")+"\")"
			//Response.Write("<!--"+SQL+"-->\r\n");
			try { oDB.exec(SQL) }
			catch (e)
			{ Response.Write("<!--"+SQL+"-->\r\n") }
		}
		
		var ia=0,ib=0;
		
		var fmtdatelog = new Array();
		for (var i=0; i<arrdatelog.length; i++)
			fmtdatelog[i] = arrdatelog[i].format("%Y-%m-%d");
		
		// DELETE OBSOLETE EMPTY RECORDS
		var SQL = "delete from "+_db_prefix+"agdetail where ad_ag_id="+id+" and ad_date not in (\""+fmtdatelog.join("\",\"")+"\")" 
		//  ADD THIS TO THE QUERY IF AGDETAIL TABLE EXTENDED  :  " and ad_timefrom is null and ad_desc is null"
		oDB.exec(SQL);
		//Response.Write("<!--"+SQL+"-->\r\n")
		
		var found = oDB.getrows("SELECT ad_date FROM "+_db_prefix+"agdetail where ad_ag_id="+id);
		
		for (var i=0; i<found.length; i++)
			found[i] = new Date(found[i]).format("%Y-%m-%d");
		
		var foundstr = "," + found.join(",") + ",";
		
		//Response.Write("<br><br>"+foundstr+"<br><br>")
		//Response.Write(datelogarr+"<br><br>")
		
		for (var i=0; i<fmtdatelog.length; i++)
			if (foundstr.indexOf(fmtdatelog[i])<0)
			{
				var SQL = "insert into "+_db_prefix+"agdetail (ad_ag_id,ad_date) values(\""+id+"\",\""+fmtdatelog[i]+"\")"
				oDB.exec(SQL)
				//Response.Write("<!--"+SQL+"-->\r\n")
			}
	}

	
	if (formarr[enumfld["mode"]]=="admin_agenda")
	{
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>")
	}
	// UPDATE OTHER ITEMS
		//oDB.exec("UPDATE revgallery SET rev_alias='"+myname+"',rev_url='"+mywebsite+"',rev_email='"+myemail+"',rev_txt='"+mytext+"' WHERE rev_id="+id);

%>

<STYLE>
	.qtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.qtable td{ background-color:white;padding-left: 2px;padding-right: 2px;padding-top: 2px;padding-bottom: 2px;white-space: nowrap;}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
</STYLE>

<script language="JavaScript" src="../includes/GUI.js"></script>

<script>
	function filldates (datefr,dateto)
	{
		if (!datefr && !dateto)
		{
			var answer = confirm ("Clear date range ?")
			if (answer)	
				document.frames('datesel').window.location = "../scripts/DateDlg.asp?d=<%=(calendarfrom.format("%m%Y")+"-"+calendarto.format("%m%Y"))%>&log=";
			return
		}

		try { var fr = datefr.toDate() }
		catch(e) { date_error(); return }
		
		if (typeof(fr)!="object")
			{ date_error(); return }
	
		if (datefr && dateto)
		{
			try { var to = dateto.toDate() }
			catch(e) { adate_error(); return }
			
			if (typeof(to)!="object")
				{ date_error(); return }
			
			if (to <= fr)
				{ var x = to; to = fr; fr = x }
			
			var answer = confirm ("Fill all dates between\r\n"+fr.format("%d-%m-%Y")+" and "+to.format("%d-%m-%Y")+" ?")
			if (answer)
				fill(fr,to);
			return
		}
		
		if (datefr)
		{
			var answer = confirm ("Select "+fr.format("%d-%m-%Y")+" ?")
			if (answer)
				fill(fr,fr);
			return
		}
	
	}
		
	function date_error()
	{
		alert("Error in date format, these are the correct formats :\r\nDDMMYY or DD-MM-YY or DD-MM-YYYY or YYYY-MM-DD HH:MM:SS");
	}
	
	function fill(fr,to)
	{
		var datearr = "";
		var ONE_DAY = 1000 * 60 * 60 * 24
				
		var start = Math.round( (fr.getTime() - <%=calendarfrom.getTime()%>)/ONE_DAY );
		var end = Math.round( (to.getTime() - <%=calendarfrom.getTime()%>)/ONE_DAY );
		var len = Math.round( <%=calendarto.getTime()-calendarfrom.getTime()%>/ONE_DAY)+1;
		
		for(var i=0;i<len;i++)
			datearr += (i>=start && i<=end)?1:0;

		document.frames('datesel').window.location = src="../scripts/DateDlg.asp?d=<%=(calendarfrom.format("%m%Y")+"-"+calendarto.format("%m%Y"))%>&log="+datearr
	}
</script>

<form method="post" name="main" ENCTYPE="multipart/form-data" action=#down>

<center>


<table  cellspacing=1 class=gtable border=1>
<tr>
	<td align=right style=background-color:white>title »</td><td align=right style=background-color:#e0e0e0><INPUT name=title type=text value="<%=formarr[enumfld["title"]]%>" size=<%=ctxtwidth%> maxlength="60"></td>
	<td align=left style=background-color:#e0e0e0 rowspan=3 style=text-align:center>
			<table>
			<tr>
					<td valign=bottom><table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center <%if (formarr[enumfld["actimg"]] & 1) {%> background=../images/agenda/<%="img"+zerofill(id,10)+"_1.jpg?"+(Math.floor(Math.random()*10000)) %> <%}%>><p align=left><%=oButton.get("main.actimg.value=main.actimg.value&(1^0xff);main.submit();","../../images/exit.gif","../../images/exit.gif","remove image")%></p>JPG<br>Image<br><br><input TYPE=FILE SIZE=1 NAME=FILE1 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;">&nbsp;&nbsp;&nbsp;</td></tr></table></td>
					<td valign=bottom><table height=100 width=220 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center <%if (formarr[enumfld["actimg"]] & 2) {%> background=../images/agenda/<%="img"+zerofill(id,10)+"_2.jpg?"+(Math.floor(Math.random()*10000)) %> <%}%>><p align=left><%=oButton.get("main.actimg.value=main.actimg.value&(2^0xff);main.submit();","../../images/exit.gif","../../images/exit.gif","remove image")%></p>JPG<br>Image<br><br><input TYPE=FILE SIZE=1 NAME=FILE2 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;">&nbsp;&nbsp;&nbsp;</td></tr></table></td>
			</tr>
			</table>
	</td>
	<td align=left style=background-color:white rowspan=3>« image</td>
</tr>
<tr><td align=right style=background-color:white>description »<td align=right style=background-color:#e0e0e0><INPUT name=desc type=text value="<%=formarr[enumfld["desc"]]%>" size=<%=ctxtwidth%> maxlength="100"></td>
<tr><td align=right style=background-color:white>header »<td align=right style=background-color:#e0e0e0><TEXTAREA NOWRAP name=header type=text size=<%=ctxtwidth%> rows=3><%=formarr[enumfld["header"]]%></TEXTAREA></td>


<tr><td colspan=4 align=center style=background-color:#e0e0e0>


<!--TEXTAREA name=rev rows=<%=ctxaheight%> cols=<%=ctxawidth*3%>><%=formarr[enumfld["rev"]]%></TEXTAREA></td-->

<%editor()%>

</tr>
<tr><td align=right style=background-color:white>category »</td><td align=right style=background-color:#e0e0e0><%=rev_categories%></td><td align=left style=background-color:#e0e0e0><input name=language type=hidden value="<%=formarr[enumfld["language"]]%>"><%=/*refid?*/rev_language/*:rev_languages*/%><%if (perm_languages.length>0) { %><br><input type=button value='Add translation' onclick=<%=translate_action%> style='font-family:Verdana;font-size:10px'><%}%></td><td align=left style=background-color:white>« language</td></tr>
<tr><td align=right style=background-color:white>email »</td><td align=right style=background-color:#e0e0e0><INPUT name=email type=text value="<%=formarr[enumfld["email"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0 rowspan=2><TEXTAREA NOWRAP name=address type=text size=<%=ctxtwidth%> rows=3><%=formarr[enumfld["address"]]%></TEXTAREA></td><td align=left rowspan=2 style=background-color:white>« address</td></tr>
<tr><td align=right style=background-color:white>phone »</td><td align=right style=background-color:#e0e0e0><INPUT name=phone type=text value="<%=formarr[enumfld["phone"]]%>" size=<%=ctxtwidth%>></td></tr>
<tr><td align=right style=background-color:white>fax »</td><td align=right style=background-color:#e0e0e0><INPUT name=fax type=text value="<%=formarr[enumfld["fax"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=url type=text value="<%=formarr[enumfld["url"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« website</td></tr>
<tr><td align=right style=background-color:white>publisher »</td><td align=right style=background-color:#e0e0e0><INPUT name=publisher type=text value="<%=formarr[enumfld["publisher"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=pub_date type=text value="<%=typeof(formarr[enumfld["pub_date"]])=="date"?new Date(formarr[enumfld["pub_date"]]).format("%Y-%m-%d"):formarr[enumfld["pub_date"]]%>" size=<%=ctxtwidth%> title="<%="created:" + (typeof(formarr[enumfld["crea_date"]])=="date"?new Date(formarr[enumfld["crea_date"]]).format("%Y-%m-%d"):formarr[enumfld["crea_date"]]) + "                    modified:" + (typeof(formarr[enumfld["mod_date"]])=="date"?new Date(formarr[enumfld["mod_date"]]).format("%Y-%m-%d"):formarr[enumfld["mod_date"]])%>"></td><td align=left style=background-color:white>« pub&nbsp;date<br>yyyy-mm-dd</td></tr>
<tr><td align=right style=background-color:white>startdate »</td><td align=right style=background-color:#e0e0e0><INPUT name=from type=text value="<%=formarr[enumfld["from"]]%>" size=<%=ctxtwidth%> title="DDMMYY | DD-MM-YY(YY) | YYYY-MM-DD HH:MM:SS"></td><td align=left style=background-color:#e0e0e0><INPUT name=to type=text value="<%=formarr[enumfld["to"]]%>" size=<%=ctxtwidth-4%> title="DDMMYY | DD-MM-YY(YY) | YYYY-MM-DD HH:MM:SS"><input type=button value=Fill onclick=filldates(main.from.value,main.to.value)></td><td align=left style=background-color:white>« enddate</td></tr>
<tr><td colspan=4 align=center style=background-color:#e0e0e0><iframe src="../scripts/DateDlg.asp?d=<%=(calendarfrom.format("%m%Y")+"-"+calendarto.format("%m%Y"))%>&log=<%=formarr[enumfld["datelog"]]%>" id="datesel" name=datesel width="570" height="150"></iframe></td></tr>
</table>

<br>
<A NAME="down"></A>
<center>
<input type=button value='cancel' onclick='top.close()'>&nbsp;&nbsp;&nbsp;&nbsp;<input type=button value='save' onclick="main.datelog.value=document.frames('datesel').document.main.log.value;main.mode.value='admin_agenda';main.submit();">

<!--input type=button value="save" onclick="main.datelog.value=document.frames('datesel').document.main.log.value;main.submit();"-->
</center>

</center>

<input type=hidden name=mode>
<input type=hidden name=actimg value=<%=formarr[enumfld["actimg"]]%>>
<input type=hidden value="<%=formarr[enumfld["datelog"]]%>" name="datelog" size=80> 

</form>




<%
	function editor()
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

<!--form id="myform" method="GET" action=""-->

<textarea name="rev" id="rev" style="width:620; height:200" class=utable>
<%=formarr[enumfld["rev"]]%>
</textarea>
<br>

<!--input type=button onclick='alert(main.box2.value)'-->

<script language="javascript1.2">
editor_generate('rev'); // field, width, height
</script>


<!--a href="javascript:editor_insertHTML('box2','<font style=\'background-color: yellow\'>','</font>');">Highlight selected text</a> -
<a href="javascript:editor_insertHTML('box2',':)');">Insert Smiley</a-->

<%
	}
%>

<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
