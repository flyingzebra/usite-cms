<%
	var bDebug = false;
	var bChangeHistory = true;
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");

	var rev_cat_type = 14;

	var perm_languages = oDB.getSetting("LNG",zerofill(ds_type,2)+"_");
	var perm_languages = perm_languages?perm_languages:oDB.getSetting("LNG","___");
	var imglen = oDB.getSetting("IMG",zerofill(ds_type,2)+"_");
	var distributed_languages = oDB.getSetting("DIS",zerofill(ds_type,2)+"_");
	distributed_languages = !distributed_languages?("'"+_dir+"'"):distributed_languages;

	var rev_typedesc = _ws;  // = image subdirectory
	
	var relpath = "../"
	var savepath = relpath+_ws+"/images/";
	var _body_width = 500



	var imglen = 1;
	var bMultipart = true;
	var bUpload = false;
	var bSaved  = false;

	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var getid = Request.QueryString("getid").Item?Number(Request.QueryString("getid").Item.toString().decrypt("nicnac")):0;
	
	var bExists = Number( oDB.get("SELECT rev_id FROM "+_db_prefix+"review where rev_id="+id) )==Number(id);
	var now = new Date(oDB.get("SELECT UNIX_TIMESTAMP()")*1000);

	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+ds_type+" and rt_dir_lng = \""+_dir+"\"");
		for (var i=0; i<catfld.length ; i++)
			enumcatfld[catfld[i]] = i;
			
	var enumpagfld = new Array();
	var pagfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var pages = oDB.getrows("select "+pagfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_cat_type+" and rt_dir_lng = \""+_dir+"\"");
		for (var i=0; i<pagfld.length ; i++)
			enumpagfld[pagfld[i]] = i;			

	function loadXML(_xmlstr)
	{
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM")
		xmlDoc.async="false"

		xmlDoc.loadXML(_xmlstr)
		if(xmlDoc.parseError.errorCode!=0)
		{
			var txt="Error Code: " + xmlDoc.parseError.errorCode + "\n"
			txt=txt+"Error Reason: " + xmlDoc.parseError.reason
			txt=txt+"Error Line: " + xmlDoc.parseError.line
			xmlDoc.loadXML("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
		}
		return xmlDoc
	}



	var ctxtwidth = 23;
	var ctxawidth = 23;
	var ctxaheight = 10;
	//var my_date=new Date("October 12, 1988 13:14:00")

	var oGUI		= new GUI();
	var oButton		= new oGUI.BUTTON();
	
	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_address","rev_phone","rev_fax","rev_mod_acc_id","rev_mod_date","rev_email","rev_publisher","rev_date_published","rev_pub" ) 
	var formfld  = new Array("id"    ,"title"    ,"desc"    ,"address"    ,"phone"    ,"fax"    ,"mod_acc"	      ,"mod_date"    ,"email"    ,"publisher","pub_date"         ,"pub"     ,"act", "source")
	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;
	
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////
	
	try 
	{
		var Upload = Server.CreateObject("Persits.Upload.1");
		var FormCollection = Upload.Form;
		bUpload = true;
	}
        catch(e)
	{
	    bMultipart = false;
		function Upload()
		{
			this.Form = UploadForm;
		}
		
		function UploadForm() {}
	}
	
	try {var Count = Upload.Save(Server.Mappath ("../images/upload")); bSaved = true; } catch(e) {}
	try { if((new Date(Upload.Expires)).getYear() == "1899") bMultipart=false; }  catch(e) {}
	bSubmitted = bMultipart?(bUpload && !new Enumerator(FormCollection).atEnd()):(Request.TotalBytes==0?false:true);

	/////////////////////////////////////////////////////////////
	//  C O L L E C T   M U L T I P A R T   F O R M - D A T A  //
	/////////////////////////////////////////////////////////////


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
	




	if(formarr[enumfld["publisher"]])
	{
		var arr = formarr[enumfld["publisher"]].split(",");
		masterdb = arr[0];
		detaildb = arr[1];
	}



	// UPDATE DATASET WITH RAWDATA	

	if(bSubmitted==true && formarr[enumfld["act"]]!=_T["admin_save"] && detaildb)
	{
		Response.Write("<small><small>")
		
		var XMLObj = loadXML(formarr[enumfld["header"]]);
		var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
		
		//var dSQL = "delete from "+_db_prefix+masterdb+" where ds_rev_id = "+id
		//oDB.exec(dSQL);
		//Response.Write(dSQL+"<br>")
		
		//var iSQL = "insert into "+_db_prefix+masterdb+" (ds_id,ds_rev_id) select distinct rd_recno,"+id+" from "+_db_prefix+detaildb+" where rd_ds_id = "+id
		//oDB.exec(iSQL);
		//Response.Write(iSQL+"<br>")
		if(hfields.length>1)
		{
			for(var j=0;j<hfields.length;j++)
			{
				var valueID = hfields.item(j).text;
				var name  = hfields.item(j).getAttribute("name");
				var value = Number(valueID.substring(1,valueID.length-1))
				
				//Response.Write(name+" = "+valueID+"<br>");
				if(name.indexOf("ds_num")==0 || name.indexOf("ds_date")==0)
					var uSQL = "update "+_db_prefix+masterdb+" set "+name+" = null where ds_rev_id = "+id
				else
					var uSQL = "update "+_db_prefix+masterdb+" set "+name+" = '' where ds_rev_id = "+id
				
				if(bChangeHistory)
					Session("chh") = (Session("chh")?Session("chh"):"") + uSQL + "\r\n\r\n"			
				
				oDB.exec(uSQL);	
				
				if(name.indexOf("ds_date")==0)
					//var uSQL = "update "+_db_prefix+masterdb+","+_db_prefix+detaildb+" set "+name+" = DATE_ADD(DATE_ADD(STR_TO_DATE(rd_text,'%a %b %e'),INTERVAL RIGHT(rd_text,4) YEAR),INTERVAL SUBSTRING(rd_text FROM -22 FOR 8) HOUR_SECOND) where rd_ds_id = "+id+" and rd_dt_id = "+value+" and rd_recno = ds_id and ds_rev_id = rd_ds_id";
					//var uSQL = "update "+_db_prefix+masterdb+","+_db_prefix+detaildb+" set "+name+" = DATE_ADD(STR_TO_DATE(rd_text,'%Y-%m-%d'),INTERVAL SUBSTRING(rd_text,12,8) HOUR_SECOND) where rd_ds_id = "+id+" and rd_dt_id = "+value+" and rd_recno = ds_id and ds_rev_id = rd_ds_id";
					var uSQL = "update "+_db_prefix+masterdb+","+_db_prefix+detaildb+" set "+name+" = DATE_ADD(STR_TO_DATE(LEFT(rd_text,10),'%Y-%m-%d'),INTERVAL SUBSTRING(rd_text,12,8) HOUR_SECOND) where rd_ds_id = "+id+" and rd_dt_id = "+value+" and rd_recno = ds_id and ds_rev_id = rd_ds_id";

				else
					var uSQL = "update "+_db_prefix+masterdb+","+_db_prefix+detaildb+" set "+name+" = rd_text where rd_ds_id = "+id+" and rd_dt_id = "+value+" and rd_recno = ds_id and ds_rev_id = rd_ds_id";
				
				if(bChangeHistory)
					Session("chh") = (Session("chh")?Session("chh"):"") + uSQL + "\r\n\r\n"
				
				
				oDB.exec(uSQL)
				if(bDebug)
					Response.Write(uSQL+";<br>")
				
			}
		}
		Response.Write("</small></small>")
	}

	/////////////////////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S   //
	////////////////////////////////////////////////////////

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
	
	///////////////////////////////////
	//  I M A G E   H A N D L I N G  //
	///////////////////////////////////

	var ImageToAdd = "";
	if (bUpload)
	{
		var FileCollection = Upload.Files;
		var resizearr 	= new Array();
		var dbnamearr   = ["rev_img1","rev_img2","rev_img3","rev_img4","rev_img5","rev_img6"];
		var VARsizearr	= ["100x100" ,"220x100" ,"100xVAR" ,"150xVAR" ,"220xVAR" ,"500xVAR"];
		var bThumbnail	= [true      ,true      ,false     ,false     ,false     ,false];
		
		var i = 0;
		for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var obj = objEnum.item();
			var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
			


			if (ext==".jpg" || ext ==".jpeg")
			{
				var imgnr = Number(obj.name.substring(4,5));
				formarr[enumfld["pub"]] = (formarr[enumfld["pub"]]?Number(formarr[enumfld["pub"]]):0) | (1<<(16+imgnr-1));
				
				var jpeg = Server.CreateObject("Persits.Jpeg");
				jpeg.open( obj.path );

				jpeg.Quality = 95;
				
				
				
				try
				{
					if(bThumbnail[imgnr]==true)
					{
						resizetoRect(jpeg,VARsizearr[imgnr-1]);
						jpeg.Save(Server.MapPath(savepath) + "\\ico"+zerofill(id,10)+"_"+imgnr+".jpg");
					}
					else
					{
						var FileName = obj.path.substring(obj.path.lastIndexOf("\\")+1,obj.path.lastIndexOf("."));
						var size = VARsizearr[imgnr-1]
						if (rndaccessForm("maxh"+(imgnr-1)))
							size = size.replace(/VAR/,rndaccessForm("maxh"+(imgnr-1))) // FILL MAXHEIGHT PARAMETER IF AVAILABLE 
						resizetoRect(jpeg,size);
						jpeg.Save(Server.MapPath(savepath) + "\\src"+zerofill(id,10)+"_"+imgnr+"_"+FileName+".jpg");
					}
				}
				catch(e)
				{
				   Response.Write(e.description+"<br>"+savepath); 
				}




			}
			i++;		
		}
		
		for(var i=0;i<VARsizearr.length;i++)
			resizearr[i] = VARsizearr[i].replace(/VAR/,"<input name=maxh"+i+" value=\""+formarr[enumfld["maxh"+i]]+"\" size=4>")

	}	
	
	function resizetoRect(picobj,size)
	{
		var sizes = size.split("x");
		var sizex = Number(sizes[0]);
		var sizey = Number(sizes[1]);
		
		if(isNaN(sizey) || sizey==0)
		{
			resizetoWidth(picobj,sizex);
			return;
		}
		
		if(isNaN(sizex) || sizex==0)
		{
			resizetoHeight(picobj,sizey);
			return;
		}		
		
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
		botharr[i-1] = tablefld[i] + "= " + (formarr[i] && typeof(formarr[i])=="string"?("\""+formarr[i].replace(/\x22/g,"\\\"")+"\""):formarr[i]?formarr[i]:"null") 

	botharr[enumfld["pub"]-1] = tablefld[enumfld["pub"]] + " = (" + tablefld[enumfld["pub"]] + " & 255) | (" + tablefld[enumfld["pub"]] + " | "+( (formarr[enumfld["pub"]] >> 16) << 16  )+")"

	if (bSubmitted)
	{
		if (bExists==true)
		{
			var uSQL = "update "+_db_prefix+"review set " + botharr.join(",") + " where rev_id="+id			
			//Response.Write(uSQL)
			
			if(bChangeHistory)
				Session("chh") = (Session("chh")?Session("chh"):"") + uSQL + "\r\n\r\n";
			
			try { oDB.exec(uSQL) }
			catch(e)
			{ Response.Write("<!--"+uSQL+"-->\r\n")}
			
			////////////////////////////////////////////////
			
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
<tr><td align="right" style="background-color:white"><%=_T["admin_title"]%> »</td><td align="right" style="background-color:#e0e0e0" width=100><input name="title" type="text" value="<%=formarr[enumfld["title"]]%>" style="width:400px"></td></tr>
<tr><td align="right" style="background-color:white"><%=_T["admin_description"]%>&nbsp;»</td><td align="right" style="background-color:#e0e0e0" width=100><input name="desc" type="text" value="<%=formarr[enumfld["desc"]]%>" style="width:400px"></td></tr>
<tr><td align="right" style="background-color:white"><%=_T["admin_image"]%>&nbsp;»</td><td width=100><table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center <%if (formarr[enumfld["pub"]] & (1<<16)) {%> background=<%=savepath%><%="ico"+zerofill(id,10)+"_1.jpg?"+(Math.floor(Math.random()*10000)) %> <%}%>><p align=left><%=oButton.get("main.pub.value=main.pub.value^(1<<16);main.submit();","../../images/exit.gif","../../images/exit.gif","remove image")%></p>JPG<br>Image<br><br><input TYPE=FILE SIZE=1 NAME=FILE1 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;">&nbsp;&nbsp;&nbsp;</td></tr></table></td></tr>
</table>

<input type=hidden name=publisher <%=formarr[enumfld["publisher"]]%>>


<a NAME="down"></a>
<center>
<%
	var commands = "&nbsp;<input type=\"button\" value=\""+_T["admin_cancel"]+"\" onclick='top.close()'>"
				+ "&nbsp;&nbsp;&nbsp;&nbsp;"
				+ "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["admin_save"]+"\">"
%>
<br>
<%=commands%>
</center>

</center>
</form>

<br><br>
