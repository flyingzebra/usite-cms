<%@ Language=JavaScript  %>
<%@ Page aspCompat="True" %>
<html>
<head>
<title>µSuite CMS</title>
  <meta NAME="author" CONTENT="Freddy Vandriessche">
  <meta HTTP-EQUIV="Content-Language" CONTENT="French">

  <style>
  BODY
  {
	MARGIN-TOP: 0px;
	MARGIN-LEFT: 0px;
    BACKGROUND-COLOR: white;
  }
  
#tabheader {
  float:left;
  width:100%;
  background:#E6E2DE url("../images/tab_brown_bg.gif") repeat-x bottom;
  font-size:93%;
  line-height:normal;
  padding-left:180px
  }
  </style>
  
  
  
</head>
<body id="home">
<a name="top"></a>
<!-- B O D Y -->true false<p style='font-size:70%'><form method="post" name="main" ENCTYPE="multipart/form-data" onsubmit="try{return submitForm()}catch(e){}">
<center>
&nbsp;<input type="button" src="../images/i_cancel.gif" name="act" value="cancel" onclick="top.close()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" src="../images/i_save.gif" name="act" value="save"><br><br>
<table cellspacing="2" cellpadding="2" border="0" style="font-size:11px">
<tr><td bgcolor=#EFD0D0>ID</td><td bgcolor=#E0E0E0>[32] <a href=23_id_dlg.asp?dt=d09f2e7c6d36ac3e032afb2100fc602d&id=d09f2e7c6d36ac3e012b04de2584>change/delete</a></td></tr><tr><td bgcolor=#FFE0E0 title="[1]" align=right>title&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e7c6d36ac3e0329fb240566baaf&ds=d09f2e7c6d36ac3e032afb2100fc602d&id= target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><input name=title type=text value="" size=40></td></tr>
<tr><td bgcolor=#FFE0E0 title="[2]" align=right>permission_code&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e7c6d36ac3e0329fb240451e077&ds=d09f2e7c6d36ac3e032afb2100fc602d&id= target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><input name=permission_code type=text value="" size=40></td></tr>
<tr><td bgcolor=#FFE0E0 title="[3]" align=right>exec&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e7c6d36ac3e0329fb2404208a45&ds=d09f2e7c6d36ac3e032afb2100fc602d&id= target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><input name=exec type=text value="" size=40></td></tr>
<tr><td bgcolor=#FFE0E0 title="[4] IMG" align=right>image&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e7c6d36ac3e0329fb24054231ee&ds=d09f2e7c6d36ac3e032afb2100fc602d&id=d09f2e7c6d36ac3e0502618553 target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><table height=100 width=100 bgcolor=black cellspacing=1 align=left><tr><td style=font-size:12px;background-color:white align=center  valign=top><IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main.image.value=main.image.value^((1<<(3))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left><a href=disp.asp?d=%3Chtml%3E%3Cbody%20bgcolor%3Dblack%20leftmargin%3D0%20topmargin%3D0%20rightmargin%3D0%20bottommargin%3D0%3E%3Ctable%20height%3D%27100%25%27%20width%3D%27100%25%27%20cellspacing%3D0%20cellpadding%3D0%3E%3Ctr%3E%3Ctd%20valign%3Dmiddle%20align%3Dcenter%3E%3Cimg%20src%3D../blackbaby/images/src0000001313_000032_004.jpg%3F4109%20onclick%3Dwindow.close%28%29%3E%3C/td%3E%3C/tr%3E%3C/table%3E%3C/body%3E%3C/html%3E target=_blank><IMG border='0' name='b0' src='../images/full_green.gif'' onclick='' hspace=3 vspace=2 title='full screen' align=right></a><br><br>JPG<br>Image<br><br><input SIZE=1 name="FILE004" type=FILE value=""  onchange=main.image.value=(main.image.value|1);main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;">&nbsp;&nbsp;&nbsp;</td></tr></table><input name=image type=hidden value=""><br></td></tr>
</table>
<br>
&nbsp;<input type="button" src="../images/i_cancel.gif" name="act" value="cancel" onclick="top.close()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" src="../images/i_save.gif" name="act" value="save"><br><br>
</center>
</form>
<!-- R I C H T E X T   I N I T I A L I S E R S -->


		<a name="login"></a>
</body>
</html>



<%
	var bDebug = true;
	var bMultipart = true;
	var bUpload = false;
	var bSaved  = false;
	var detaildb = false;
	var headername = new Array();
	var _db_prefix = "usite"
	var masterdb = "masterdb"
	var id = 0;
	var upload_path = Server.Mappath ("../images/upload");
	//var upload_path = "C:/"

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
			this.Files = new Array();
		}
		
		function UploadForm() {}
	}

	try {var Count = Upload.Save(upload_path); bSaved = true; } catch(e) { Response.Write("File not saved, check security. error:"+e.description) }
	try { if((new Date(Upload.Expires)).getYear() == "1899") bMultipart=false; }  catch(e) {}
	bSubmitted = bMultipart?((bUpload && !new Enumerator(FormCollection).atEnd())):(Request.TotalBytes==0?false:true);
	
	if(bDebug)
	{	
		Response.Write("Count="+Count+"<br>")
		Response.Write("upload_path="+upload_path+"<br>")
		Response.Write("bSubmitted="+bSubmitted+"<br>");
		Response.Write("bMultipart="+bMultipart+"<br>");
		Response.Write("bUpload="+bUpload+"<br>")
		Response.Write("Totalbytes="+Request.TotalBytes+"<br>")
		Response.Write("formcollection="+(!new Enumerator(FormCollection).atEnd())+"<br>")
		
		for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var obj = objEnum.item();
			var idx = enumforms[obj.name];
			Response.Write(idx+"<br>")
		}
	}
		
		
		///////////////////////////////////////
		//    L O A D   F O R M   D A T A    //
		///////////////////////////////////////		
		
		
		var rfld = new Array("rd_dt_id","rd_text");
		
		if(bSubmitted==false)
		{
			
			if(detaildb)
			{
				// L O A D   F R O M   D A T A D E T A I L


			}
			else
			{
				// L O A D   F R O M   D A T A S E T

			}
		}
		else
		{
		
		
			////////////////////////////////////
			//  FORM INPUT - DATA COLLECTING  //
			////////////////////////////////////
			
			// USING IMPICIT ARRAY DECLARATION >> COLLECTION >> ENUMERATOR
			
			var formarr = new Array();
			var namearr = new Array();
			
			if(bMultipart==false)
			{
			    var FormCollection = new Array();
				nextact = Request.Form("nextact").Item?Request.Form("nextact").Item:"";
				for(var i=0;i<fieldID.length;i++)
				{
					var v_name = fields.item(i).getAttribute("name");
					var v_value = Request.Form(v_name).Item?Request.Form(v_name).Item:"";
					FormCollection[i] = {"name":v_name,"value":v_value};
					if(bDebug)
					{
						Response.Write("form name='"+v_name+"' value='"+v_value+"' <br>\r\n")
					}
				}
			}
			
			
			//////////////////////////////////////////////////////
			//  FORM INPUT - DATA CONDITIONING TOWARDS DATABASE //
			//////////////////////////////////////////////////////
			
			var enumforms = new Array();
			for(var i=0;i<fieldID.length;i++)
				enumforms[fields.item(i).getAttribute("name")] = i;				
			
			for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
				var obj = objEnum.item();
				var idx = enumforms[obj.name];
				
				var en = enumsettings[fields.item(idx).text];
				var enl = enumlistsettings[fields.item(idx).text];			
				var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
				var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
				
				
				
				if(obj.name=="nextact")
					nextact = obj.value;
				
				//Response.Write(obj.name+"<br>")

				if(idx || idx==0)
				{
					if(type=="number")
						formarr[idx] = obj.value?Math.round(Number(obj.value.replace(/,/,"."))*100):"";
					else
						formarr[idx] = obj.value;
				}
				else if(obj.name.substring(0,3).toUpperCase()=="ESC")
				{
					var fid = Number(obj.name.substring(3,6));
					idx = enumforms[ enumdataset[fid] ];
					
					var en = enumsettings[fields.item(idx).text];
					var enl = enumlistsettings[fields.item(idx).text];
					var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
					var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];					
					
					var args = argsplitter(format);
					var arg  = argparser(args[1]);
					var dbsep = arg["dbsep"]?arg["dbsep"]:",";
					var AddSep = formarr[idx] && formarr[idx].lastIndexOf(dbsep) == formarr[idx].length-dbsep.length ? "" : dbsep;
					
					formarr[idx] = ((formarr[idx]?(formarr[idx]+AddSep):"")+escape(obj.value)).replace(/,*$/,"");
					//Response.Write(formarr[idx]+" "+format+"<br>")
					
				}
				else if(obj.name.substring(0,3).toUpperCase()=="CSV")
				{
					var fid = Number(obj.name.substring(3,6))
					idx = enumforms[ enumdataset[fid] ];
					
					var en = enumsettings[fields.item(idx).text];
					var enl = enumlistsettings[fields.item(idx).text];
					var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
					var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];						
					
					if (type=="multistring" && format.substring(0,3)=="csv")
						formarr[idx] = (formarr[idx]?(formarr[idx]+","):"")+"\""+(obj.value?obj.value.replace(/"/g,"&quot;"):"")+"\"";
					else if(type=="multinumber")
						formarr[idx] = (formarr[idx]?(formarr[idx]+","):"")+(obj.value?Math.round(Number(obj.value.replace(/,/,"."))*(format.substring(0,3)=="EUR"?100:1)):"");					
					else
						formarr[idx] = (formarr[idx]?(formarr[idx]+","):"")+"\""+obj.value+"\"";
					
					// EXCLUDE BLANK FIELDS FROM DATABASE
					formarr[idx]=formarr[idx].replace(/,""/g,"").replace(/,*$/,"");
					// CLEAR REMAINING QUOTE PAIR
					if(formarr[idx]=="\"\"")
						formarr[idx] = ""
				}
				else if(obj.name.substring(0,3)=="CHK")
				{
					var fid = Number(obj.name.substring(3,6));
					var did = Number(obj.name.substring(7,10));
					var idx = enumforms[ enumdataset[fid] ];
					var en = enumsettings[fields.item(idx).text];
					var enl = enumlistsettings[fields.item(idx).text];
					var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
					var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
					
					if (type=="number" && format.substring(0,5)=="check")
					{
						formarr[idx] = (typeof(formarr[idx])=="number"?formarr[idx]:0)+(Number(obj.value)<<did);
						//Response.Write(formarr[idx].toString(2)+" "+did+"<br>");
					}
				}
				//Response.Write("MultiPartRequest formarr["+idx+"] ("+format+") ("+obj.name+") = "+formarr[idx]+"<br>");
			}
			
			if(bDebug)
			{
				Response.Write("<br>L O A D I N G &nbsp; F O R M &nbsp; D A T A<br><br>");
				
				for(var i=0;i<DBfieldID.length;i++)
					Response.Write("fieldID["+DBfieldID[i]+"] = "+formarr[i]+"<br>");
				Response.Write("<br>");
			}			
		}
		

%>






