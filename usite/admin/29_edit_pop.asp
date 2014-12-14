<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

	var rev_type = 29;

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");
	
	var bTinyMce = Request.QueryString("tinymce").Item?(Request.QueryString("tinymce").Item=="true"):oDB.permissions(["tinymce"]);	
	
	var perm_languages = oDB.getSetting(zerofill(rev_type,2)+"_L");
	var _uid = Session("uid");
	var _dir = Session("dir");
	var rev_typedesc = _ws;  // = image subdirectory
	
	var relpath = "../"
	var savepath = relpath+_ws+"/images/";

	var imglen = 1;
	var bUpload = false;
	var bSaved  = false;

	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var bExists = Number( oDB.get("SELECT rev_id from "+_db_prefix+"review where rev_id="+id) )==Number(id);
	var now = new Date(oDB.get("SELECT UNIX_TIMESTAMP()")*1000);

	//var languages = oDB.getrows("SELECT distinct ws_lngcode,ws_lngname from "+_db_prefix+"website " + ( perm_languages.length>0 ? ( "where ws_lngcode IN ("+perm_languages+")" ) :( "where ws_lngcode IN ('name')" )  )   );		
	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var sSQL = "select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\""
	var categories = oDB.getrows(sSQL)// and rt_typ = "+rev_type);
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;
		

	var enumtmplfld = new Array();
	var tmplfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
	var templates = oDB.getrows("select "+tmplfld.join(",")+" from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\" and rt_typ = 16");
	for (var i=0; i<tmplfld.length ; i++)
		enumtmplfld[tmplfld[i]] = i;

	var ctxtwidth = 35;
	//var my_date=new Date("October 12, 1988 13:14:00")

	var oGUI		= new GUI();
	var oButton		= new oGUI.BUTTON();
	
	var tablefld = new Array("rev_id","rev_ref","rev_title","rev_desc","rev_header","rev_rev","rev_rt_cat","rev_phone","rev_fax"  ,"rev_url","rev_email","rev_address","rev_publisher","rev_date_published","rev_crea_date","rev_mod_acc_id","rev_mod_date", "rev_dir_lng","rev_pub" ) 
	var formfld  = new Array("id"    ,"refcat","title"    ,"desc"    ,"header"    ,"rev"    ,"category"  ,"phone"    ,"fax"      ,"url"    ,"email"    ,"address"    ,"publisher"    ,"pub_date"          ,"crea_date"    ,"mod_acc"	    ,"mod_date"    , "language"   ,"pub"    ,"act","source")
	var formfunction = new Array();
	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;
	
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////

	var bMultipart = true;
	try { var Upload = Server.CreateObject("Persits.Upload.1");  var FormCollection = Upload.Form; bUpload = true; } catch(e) { bMultipart=false}
	try { var Count = Upload.Save(Server.Mappath ("../images/upload")); bSave = true; } catch(e) {}

	/////////////////////////////////////////////////////////////
	//  C O L L E C T   M U L T I P A R T   F O R M - D A T A  //
	/////////////////////////////////////////////////////////////
	
	var bSubmitted = false;
	if (bUpload==true && bMultipart)
		bSubmitted = !new Enumerator(FormCollection).atEnd();
	else
		bSubmitted = Request.TotalBytes==0?false:true;	
	
	
	if (bUpload==true)
		bSubmitted = !new Enumerator(FormCollection).atEnd();


	var formarr = new Array();
	formarr[0] = id;
	var act = "";

	if (!bSubmitted)
	{		
		formarr = oDB.getrows("SELECT "+tablefld.join(",")+" FROM "+_db_prefix+"review where rev_id="+id);
		
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
			{
				formarr[i] = Request.Form(formfld[i]).Item!=null?Request.Form(formfld[i]).Item:"";
				//Response.Write(formfld[i]+" "+Request.Form(formfld[i]).Item+"<br>")
			}
			act = Request.Form("act").Item;
		}

		if(formarr[enumfld["date_published"]])
			formarr[enumfld["date_published"]] = formarr[enumfld["date_published"]].toString().toDate();
	}	

    function rndaccessForm(name)
	{
		for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
			if(objEnum.item().name==name)
				return objEnum.item().value?objEnum.item().value:"";
		return "";
	}	

	/////////////////////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S				   //
	/////////////////////////////////////////////////////////

	// SOURCE CODE
	
	if(bSubmitted)
	{
		formarr[enumfld["pub"]] = Number(formarr[enumfld["pub"]]) & ~16 | (formarr[enumfld["source"]]=="on"?16:0)
		formfunction[enumfld["pub"]] = "(" + tablefld[enumfld["pub"]] + " & ~16 | " + (formarr[enumfld["source"]]=="on"?16:0) + ")"
	}

	//  CATEGORIES

	var oTREE		= new oGUI.TREE();
	
	oTREE.init();
	var tree		   = oTREE.load(categories);
	var rev_categories = oTREE.combobox("name=category size=1",formarr[enumfld["category"]]);

	// TEMPLATES
	
	/*
	var enumtmplfld = new Array();
	var tmplfld  = ("rev_id,rev_title,rev_desc,rev_pub,rev_ref").split(",");
	var templates = oDB.getrows("select "+tmplfld.join(",")+" from "+_db_prefix+"review where rev_dir_lng = \""+_dir+"\" and rev_rt_typ = 16 and (rev_pub & 1) = 1");
	for (var i=0; i<tmplfld.length ; i++)
		enumtmplfld[tmplfld[i]] = i;	
	*/
	
	oTREE.init();
	var tree		   = oTREE.load(templates);
	var rev_templates = oTREE.combobox("name=refcat size=1",formarr[enumfld["refcat"]]);
	
	
	// CHECKING ALGORITHM
	
	String.prototype.indexOneOf = function (_oneof)
	{
		var _minpos = this.indexOf(Server.HTMLEncode(_oneof[0]));
		if(_minpos<0)
			_minpos = this.length;
		for(var _i=1;_i<_oneof.length;_i++)
		{
			var _pos = this.indexOf(_oneof[_i])
			if(_pos>=0 && _pos<_minpos)
				_minpos = _pos;
		}
		return _minpos;
	}	

	///////////////////////////////
	//  S E C U R I T Y  //
	///////////////////////////////
/*
	if (formarr[enumfld["pub"]] & 4)
	{
		Response.Clear();
		Response.Write("<script>window.close()</script>");
		Response.End();
	}
*/

	/////////////////////////////////
	//  R E S I Z E   I M A G E S  //
	/////////////////////////////////
	/*
	if (bUpload)
	{
		var FileCollection = Upload.Files;
	
		var dbnamearr = ["rev_img1","rev_img2"]
		var resizearr = ["100x100","500x0"];
	
		var i = 0;
	
		for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var obj = objEnum.item();
			
			if (obj.path.substring(obj.path.length-4,obj.path.length)==".jpg")
			{
				var imgnr = Number(obj.name.substring(4,5));
				var iactimg = enumfld["actimg"];
				formarr[iactimg] = formarr[iactimg] ? (formarr[iactimg] | Math.pow(2,imgnr-1)) : Math.pow(2,imgnr-1);
				var jpeg = Server.CreateObject("Persits.Jpeg");
				jpeg.open( obj.path );
				resizetoRect(jpeg,resizearr[imgnr-1]);

				jpeg.Save(Server.MapPath(savepath) + "\\img"+zerofill(id,10)+"_"+imgnr+".jpg");
				
				ImageToAdd =  "<img src=\""+savepath+"img"+zerofill(id,10)+"_"+imgnr+".jpg?"+(Math.floor(Math.random()*10000))+">";
			}
			i++;		
		}		
	}
	*/

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
				jpeg.Quality = 85;
				
				if(bThumbnail[imgnr]==true)
				{
					resizetoRect(jpeg,VARsizearr[imgnr-1]);
					jpeg.Save(Server.MapPath(savepath) + "\\img"+zerofill(id,10)+"_"+imgnr+".jpg");
				}
				else
				{
					var FileName = obj.path.substring(obj.path.lastIndexOf("\\")+1,obj.path.lastIndexOf(".")).replace(/ /g,"_");
					var size = VARsizearr[imgnr-1];
					if (rndaccessForm("maxh"+(imgnr-1)))
						size = size.replace(/VAR/,rndaccessForm("maxh"+(imgnr-1))) // FILL MAXHEIGHT PARAMETER IF AVAILABLE 
					resizetoRect(jpeg,size);
					jpeg.Save(Server.MapPath(savepath) + "\\img"+zerofill(id,10)+"_"+imgnr+"_"+FileName+".jpg");
					//Response.Write(Server.MapPath(savepath) + "\\src"+zerofill(id,10)+"_"+imgnr+"_"+FileName+".jpg")
				}
			}
			i++;		
		}
		
		for(var i=0;i<VARsizearr.length;i++)
			resizearr[i] = VARsizearr[i].replace(/VAR/,"<input name=maxh"+i+" value=\""+rndaccessForm("maxh"+i)+"\" size=4>")

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
		
		//Response.Write(typeof(formarr[enumfld["crea_date"]])=="string" && formarr[enumfld["crea_date"]].length==0)
		
		formarr[enumfld["crea_date"]] = typeof(formarr[enumfld["crea_date"]])=="string" && formarr[enumfld["crea_date"]].length==0?now.format("%Y-%m-%d %H:%M:%S"):formarr[enumfld["crea_date"]]
		
		//Response.Write("<br>"+formarr[enumfld["crea_date"]]+"<br>")
		
		formarr[enumfld["rev"]] = ImageToAdd + formarr[enumfld["rev"]];
	}

	var botharr = new Array();
	for (var i=1;i<tablefld.length;i++)
	{
        if(formfunction[i])
			botharr[i-1] = tablefld[i] + "=" + formfunction[i];
		else
			botharr[i-1] = tablefld[i] + "=" + (formarr[i] && typeof(formarr[i])=="string"?("\""+formarr[i].replace(/\x22/g,"\\\"")+"\""):formarr[i]?formarr[i]:"null");
	}

	if (bSubmitted)
	{
		if (bExists==true)
		{
			formarr[enumfld["mod_date"]] = now.format("%Y-%m-%d %H:%M:%S");
		
			var SQL = "update "+_db_prefix+"review  set " + botharr.join(",") + " where rev_id="+id
			//Response.Write(SQL);
			//Response.Write("<!--"+SQL+"-->\r\n");
			
			try { oDB.exec(SQL) }
			catch(e)
			{ 
				//Response.Write("<!--"+SQL+"-->\r\n")
			}
		}
	}
	
	
	// MAILING LIST OPTIONS

	var sSQL = "select rev_id,rev_title,rev_desc,rev_pub from usite_review where rev_rt_typ in (1,23) and rev_dir_lng = \""+_ws+"\" and rev_rev like \"%email%\" order by rev_title,rev_desc"

	var ml = oDB.getrows(sSQL);
	var mopt_arr = new Array();
	for(var i=0;i<ml.length;i+=4)
		mopt_arr[i/4] = "\t<option value="+ml[i]+(Number(formarr[enumfld["email"]])==ml[i] || (formarr[enumfld["email"]]=="" && formarr[enumfld["header"]]=="" && (ml[i+3]&3)==3)?" selected":"")+">["+ml[i]+"] "+(ml[i+1]?ml[i+1]:("["+(i/4)+"]"))+" "+(ml[i+2]?ml[i+2]:"")
	
	//Response.Write(sSQL)

	var key = Request.QueryString("pagename").Item+Request.QueryString("ses").Item;
	Session(key) = formarr[enumfld["rev"]];
	
	if(formarr[enumfld["email"]])
		Session(key+"_1") = "["+formarr[enumfld["email"]]+"]"
	else
		Session(key+"_1") = formarr[enumfld["header"]]?formarr[enumfld["header"]].replace(/\r\n/g,"<br>"):"";
	
	var tagarr = new Array();
	var img_arr = formarr[enumfld["rev"]]?formarr[enumfld["rev"]].split(/<IMG/gi):new Array();
	for(var j=1;j<img_arr.length;j++)
	{
		var tagc = img_arr[j].substring(0,img_arr[j].indexOf(">"))
		tagc = tagc.substring(tagc.indexOf("src=")+4,tagc.length)
		if(tagc.charAt(0)=="\"")
			tagc = tagc.substring(1,tagc.substring(1,tagc.length).indexOf("\"")+1);
		else
			tagc = tagc.substring(0,tagc.indexOf(" "));
		tagc = tagc.substring(tagc.lastIndexOf("/")+1,tagc.length)
		
		tagarr[j-1] = Server.MapPath("..").replace(/\\/g,"/")+"/"+_ws+"/images/"+tagc
	}
	Session(key+"_3") = tagarr.join(","); 
	
	
	if (bSubmitted)
	{
	Response.Write("<script>try{"
	 +" window.opener.document.panel.sender.value='"+formarr[enumfld["title"]]+"';"
	 +" window.opener.document.panel.subject.value='"+formarr[enumfld["desc"]]+"';"
	 +" window.opener.document.panel.submit();} catch(e) {}"
	 +"</script>");
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

<form method="post" name="main" <%=bMultipart==true?"ENCTYPE=\"multipart/form-data\"":""%> action=#down>

<script>
function inimanimouse()
{
	if(main.email.value=='')
	{
		main.header.readOnly=false;
		main.header.style.backgroundColor='#FFFFFF';
	}
	else
	{
		main.header.readOnly=true;
		main.header.style.backgroundColor='#C0C0C0';
	}
}
</script>

<center>
<table  cellspacing=1 class=gtable border=1>
<tr><td align=right style=background-color:white>mailinglist »</td><td align=right style=background-color:#e0e0e0><select name=email onchange="try{ inimanimouse(); }catch(e){}"><option><%=mopt_arr.join("\r\n")%></select></td><td rowspan=4><TEXTAREA NOWRAP name=header type=text cols=<%=ctxtwidth%> rows=6><%=formarr[enumfld["header"]]%></TEXTAREA></td><td rowspan=2 align=right style=background-color:white>« custom&nbsp;list</td></tr>
<tr><td align=right style=background-color:white>sender »</td><td align=right style=background-color:#e0e0e0><INPUT name=title type=text value="<%=formarr[enumfld["title"]]%>" size=<%=ctxtwidth%>></td>
<tr><td align=right style=background-color:white>subject »</td><td align=right style=background-color:#e0e0e0><INPUT name=desc type=text value="<%=formarr[enumfld["desc"]]%>" size=<%=ctxtwidth%>></td></tr>
<tr><td align=right style=background-color:white><%=_T["admin_category"]%> »</td><td align=right style=background-color:#e0e0e0><%=rev_categories%></td></tr>


<tr><td colspan=4 align=center style=background-color:#e0e0e0>
  
	<table cellspacing=0 cellpadding=0 border=0>
	<tr><td><iframe src="ImagePick.asp?dt=<%=Request.QueryString("id").Item%>&idir=<%=rev_typedesc%>&iwidth=500" width="570" height="150"></iframe></td>
	<td>
		<table align=right>
			<tr><td><%=resizearr?resizearr[2]:""%><br><input TYPE=FILE SIZE=1 NAME=FILE3 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;"></td></tr>
			<tr><td><%=resizearr?resizearr[3]:""%><br><input TYPE=FILE SIZE=1 NAME=FILE4 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;"></td></tr>
			<tr><td><%=resizearr?resizearr[4]:""%><br><input TYPE=FILE SIZE=1 NAME=FILE5 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;"></td></tr>
			<tr><td><%=resizearr?resizearr[5]:""%><br><input TYPE=FILE SIZE=1 NAME=FILE6 onchange=main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;"></td></tr>							
		</table>
	</td>
	</tr>
	</table>

</td></tr>

<tr><td colspan=4 style=background-color:#e0e0e0>

<center><%editor()%></center>
<small>counted <span id=textlength>0</span> characters, <span id=spclength>0</span> spaces</small>

</td>
</tr>
<!--tr><td align="right" style="background-color:white"><%=_T["admin_category"]%>&nbsp;»</td><td align="right" style="background-color:#e0e0e0"><%=rev_categories%></td><td align=left style=background-color:#e0e0e0><%=rev_templates%><input name=source type=checkbox value="on"<%=(formarr[enumfld["pub"]] & 16) == 16?" checked":""%>><%=_T["admin_sourcecode"]%>  <a href=urlencode.asp target=_blank>urlencode</a>  </td><td align="left" style="background-color:white">«&nbsp;<%=_T["admin_skin"]%></td></tr-->

<!--tr><td align=right style=background-color:white>email »</td><td align=right style=background-color:#e0e0e0><INPUT name=email type=text value="<%=formarr[enumfld["email"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0 rowspan=2><TEXTAREA NOWRAP name=address type=text size=<%=ctxtwidth%> rows=3><%=formarr[enumfld["address"]]%></TEXTAREA></td><td align=left rowspan=2 style=background-color:white>« address</td></tr-->
<!--tr><td align=right style=background-color:white>phone »</td><td align=right style=background-color:#e0e0e0><INPUT name=phone type=text value="<%=formarr[enumfld["phone"]]%>" size=<%=ctxtwidth%>></td></tr-->

<!--tr><td align=right style=background-color:white>fax »</td><td align=right style=background-color:#e0e0e0><INPUT name=fax type=text value="<%=formarr[enumfld["fax"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=url type=text value="<%=formarr[enumfld["url"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:white>« url</td></tr-->
<!--tr><td align=right style=background-color:white>publisher »</td><td align=right style=background-color:#e0e0e0><INPUT name=publisher type=text value="<%=formarr[enumfld["publisher"]]%>" size=<%=ctxtwidth%>></td><td align=left style=background-color:#e0e0e0><INPUT name=pub_date type=text value="<%=typeof(formarr[enumfld["pub_date"]])=="date"?new Date(formarr[enumfld["pub_date"]]).format("%Y-%m-%d"):formarr[enumfld["pub_date"]]%>" size=<%=ctxtwidth%> title="<%="created:" + (typeof(formarr[enumfld["crea_date"]])=="date"?new Date(formarr[enumfld["crea_date"]]).format("%Y-%m-%d"):formarr[enumfld["crea_date"]]) + "                    modified:" + (typeof(formarr[enumfld["mod_date"]])=="date"?new Date(formarr[enumfld["mod_date"]]).format("%Y-%m-%d"):formarr[enumfld["mod_date"]])%>"></td><td align=left style=background-color:white>« pub&nbsp;date<br>yyyy-mm-dd</td></tr-->

</table>

<br>
<A NAME="down"></A>
<center>
<input type=button value='cancel' onclick='top.close()'>&nbsp;&nbsp;&nbsp;&nbsp;<input type=submit value='save'>
</center>

</center>

<input type=hidden name=language value="<%=_dir%>">
<input type=hidden name=mode>
<input type=hidden name=actimg value=<%=formarr[enumfld["actimg"]]%>>
<input type=hidden name=crea_date value="<%=typeof(formarr[enumfld["crea_date"]])=="date"?new Date(formarr[enumfld["crea_date"]]).format("%Y-%m-%d %H:%M:%S"):formarr[enumfld["crea_date"]]%>">
<input type="hidden" name="pub" value="<%=formarr[enumfld["pub"]]%>">
</form>




<script>
try
{
window.onload=inimanimouse();
}
catch(e)
{}

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
		if( (formarr[enumfld["pub"]] & 16) == 16)
		{
		%>
		<textarea name="rev" id="rev" style="width:<%=_body_width-10%>; height:300" class=utable><%=formarr[enumfld["rev"]]%></textarea>
		<%
		}
		else
		{
			if(bTinyMce)
			{
			%>
				<textarea name="rev" id="rev" style="width:620; height:300" class=utable><%=formarr[enumfld["rev"]]%></textarea>
			
				<script language="Javascript" type="text/javascript" src="../includes/tinymce/jscripts/tiny_mce/tiny_mce_src.js"></script>
	
				<script language="javascript" type="text/javascript">
				function fileBrowserCallBack(field_name, url, type, win) {
					// This is where you insert your custom filebrowser logic
					alert("Example of filebrowser callback: field_name: " + field_name + ", url: " + url + ", type: " + type);
					// Insert new URL, this would normaly be done in a popup
					win.document.forms[0].elements[field_name].value = "someurl.htm";
				}
				</script>
				<script>
						tinyMCE.init({
							mode : "exact",
							elements : "rev",
							theme : "advanced",
							language : "en",
							height : 500,
							width : 540,
							plugins : "table,advhr,advimage,advlink,insertdatetime,preview,zoom,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,-emotions,fullpage",
							theme_advanced_buttons1_add_before : "save,newdocument,separator",
							theme_advanced_buttons1_add : "fontselect,fontsizeselect",
							theme_advanced_buttons2_add : "separator,insertdate,inserttime,preview,separator,forecolor,backcolor",
							theme_advanced_buttons2_add_before: "cut,copy,paste,pastetext,pasteword,separator,replace,separator",
							theme_advanced_buttons3_add_before : "tablecontrols,separator",
							theme_advanced_buttons3_add : "emotions,iespell,flash,separator,print,separator,ltr,rtl,separator,fullscreen,fullpage",
							theme_advanced_toolbar_location : "top",
							theme_advanced_toolbar_align : "left",
							theme_advanced_path_location : "bottom",
							content_css : "example_full.css",
							plugin_insertdate_dateFormat : "%d-%m-%Y",
							plugin_insertdate_timeFormat : "%H:%M:%S",
							extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
							external_link_list_url : "example_link_list.js",
							external_image_list_url : "example_image_list.js",
							flash_external_list_url : "example_flash_list.js",
							file_browser_callback : "fileBrowserCallBack",
							theme_advanced_resize_horizontal : false,
							theme_advanced_resizing : true,
							apply_source_formatting : true
						});
				</script>
				<!-- /TinyMCE -->
				<!-- Self registrering external plugin, load the plugin and tell TinyMCE where it's base URL are -->
				<script language="javascript" type="text/javascript" src="../includes/tinymce/jscripts/tiny_mce/plugins/emotions/editor_plugin.js"></script>
				<!--script language="javascript" type="text/javascript">tinyMCE.setPluginBaseURL('emotions', '../includes/tinymce/jscripts/tiny_mce/plugins/emotions');</script-->
				<script language="javascript" type="text/javascript">tinyMCE.setPluginBaseURL('emotions', '../includes/tinymce/jscripts/tiny_mce/plugins/emotions');</script>			
	
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
	}
	
	if(bTinyMce)
		Response.Write("<a href=14_edit_dlg.asp?id="+Request.QueryString("id").Item+"&tinymce=false>old cms</a>")
	else
		Response.Write("<a href=14_edit_dlg.asp?id="+Request.QueryString("id").Item+"&tinymce=true>new cms</a>")	


%>

<br>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
