<%@ Language=JavaScript %>
<html>
<head>
<title>µSuite CMS</title>
  <meta NAME="author" CONTENT="Freddy Vandriessche">
  <meta HTTP-EQUIV="Content-Language" CONTENT="French">
  <style type="text/css" media="screen">@import "../includes/style.css";</style>
  <style type="text/css" media="screen">@import "../includes/topnav.css";</style>
  <style type="text/css" media="screen">@import "../includes/sidenav.css";</style>
  <style>
  BODY
  {
	MARGIN-TOP: 0px;
	MARGIN-LEFT: 0px;
    BACKGROUND-COLOR: black;
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
<table bgcolor="white" cellspacing="0" cellpadding="0" width="100%">
<tr>
	<td valign="top" width="765" style="background:#FFFFFF url(../images/ads/bb_partnerlogo_bg.gif) repeat-x top">
		<!-- M E N U   B A R -->
		<table cellspacing="0" cellpadding="0" border="0" >
		<tr height="6">
			<td WIDTH="603"><img SRC="../images/nbox1.gif" WIDTH="603" HEIGHT="6" border="0"></td>
			<td rowspan="2" bgcolor="#F7F3EF" valign="top"><a href="http://www.thecandidates.com" target="_blank"><img SRC="../images/ads/bb_partnerlogo.gif" border="0" WIDTH="162" HEIGHT="24"></a></td>
		</tr>
		<tr height="33">
			<td bgcolor="#F7F3EF" align="left">
				&nbsp;&nbsp;&nbsp;<a href="menu.asp" class="small">A D M I N - M E N U</a>
				&nbsp;&nbsp;&nbsp;<a href="../janetzky/index.asp" class="small">W E B S I T E</a>
				&nbsp;&nbsp;&nbsp;<a href="link_activate.asp?v=d09f2e716e30ac3f0335a073fada2b9192acfe10b0c227c501ef763c" class="small">R E A C T I V A T E</a>
				&nbsp;&nbsp;&nbsp;<a href="logoff.asp?adminurl=index.asp" class="small">L O G O F F</a>
			</td>
		</tr>
		<tr height="1"><td bgcolor="#BDBABD"></td><td bgcolor="#BDBABD"></td></tr>
		</table><!-- B O D Y --><p style='font-size:70%'><form method="post" ENCTYPE="multipart/form-data" name="main" onsubmit="try{return submitForm()}catch(e){}">
<center>
&nbsp;<input type="button" src="../images/i_cancel.gif" name="act" value="cancel" onclick="top.close()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" src="../images/i_save.gif" name="act" value="save"><br><br>
<table cellspacing="2" cellpadding="2" border="0" style="font-size:11px">
<tr><td bgcolor=#EFD0D0>ID</td><td bgcolor=#E0E0E0>[8] <a href=01_id_dlg.asp?dt=d09f2e716e30ac3f012ffe250549b662&id=d09f2e716e30ac3f0a03973dfc>change/delete</a></td></tr><tr><td bgcolor=#FFE0E0 title="[1]" align=right>title&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e716e30ac3f012ffe2a01bbbe64&ds=d09f2e716e30ac3f012ffe250549b662&id= target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><input name=title type=text value="Autres oeuvres" size=40></td></tr>
<tr><td bgcolor=#FFE0E0 title="[2] section" align=right>section&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e716e30ac3f012ffe2a05a929c4&ds=d09f2e716e30ac3f012ffe250549b662&id=d09f2e716e30ac3f040187257b target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><select name=ESC002_000 >
	<option value="">
	<option value="2">Biographie
	<option value="7">Contact
	<option value="3">Critiques
	<option value="1" SELECTED>Galerie (1968 - 2011)
	<option value="5">Presse
	<option value="6">Prix
	<option value="4">Souvenirs (Rome-Londres-Bruxelles-USA)
</select>
 <a href=01_edit_dlg.asp?id=d09f2e716e30ac3f012ffc2004d5f6bc target=_blank>link</a></td></tr>
<tr><td bgcolor=#FFE0E0 title="[9] gallery" align=right>gallery&nbsp;<a href=22_rec_dlg.asp?dt=d09f2e716e30ac3f012ffe2a03f2e38b&ds=d09f2e716e30ac3f012ffe250549b662&id=d09f2e716e30ac3f030540d109&i=9&s=FIELD_PROPERTIES target=_blank><img src=../images/ii_longbuttonblue.gif onmouseover=this.src='../images/ii_longbuttonblue_alt.gif' onmouseout=this.src='../images/ii_longbuttonblue.gif' border=0></a></td><td bgcolor=#E0E0E0><table cellspacing=0 cellpadding=0><tr><td valign=top><table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center  valign=top><IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main.gallery.value=main.gallery.value^(1<<0);main.submit(); title='remove image' hspace=3 vspace=2 align=left><IMG border='0' name='b0' src='../images/full.gif'' onclick='' hspace=3 vspace=2 title='full screen' align=right><br><br>JPG<br>Image<br><br><input SIZE=1 name="FILE009_00" type=FILE value="0"  onchange=main.gallery.value=(main.gallery.value|1);main.submit() onmouseover=this.style.cursor='hand' style="background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;">&nbsp;&nbsp;&nbsp;</td></tr></table></td></tr></table><input name=gallery type=hidden value="0"><br></td></tr>
</table>
<br>
&nbsp;<input type="button" src="../images/i_cancel.gif" name="act" value="cancel" onclick="top.close()">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" src="../images/i_save.gif" name="act" value="save"><br><br>
</center>
</form>
<!-- R I C H T E X T   I N I T I A L I S E R S -->






<%
	var bDebug = false;
	var bUpload = false;
	var bSaved  = false;
	var bMultiPart = true;

	try 
	{	
		if(bMultiPart==true)
		{
			var bMultiPart = true;
			var Upload = Server.CreateObject("Persits.Upload.1");
			var FormCollection = Upload.Form;
			bUpload = true;
			Response.Write("Upload dir:"+Server.Mappath("../images/upload")+"<br>");
			var Count = Upload.Save(Server.Mappath("../images/upload")); bSaved = true;
			Response.Write("File written ("+Count+")<br>");
		}
	}
    catch(e)
	{
		Response.Write("Persits.Upload failed: "+e.description+"<br>");
		var bMultiPart = false;
	}
	
	if(bMultiPart==false)
	{
		function Upload()
		{
			this.Form = UploadForm;
		}	
		function UploadForm() {}
	}
	
	var bSubmitted = bMultiPart==true && bUpload==true?!new Enumerator(FormCollection).atEnd():(Request.TotalBytes==0?false:true);
    
	Response.Write("bSubmitted = "+bSubmitted+"<br>");
	Response.Write("bMultipart = "+bMultiPart+"<br>");

	///////////////////////////////////////
	//    L O A D   F O R M   D A T A    //
	///////////////////////////////////////		

	if(bSubmitted==false)
	{

	}
	else
	{
		// SUBMITTED = TRUE
		
		
		if(bMultiPart==true)
		{
			for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
				var obj = objEnum.item();
				var _name = obj.name;
				var _value = obj.value;
				
				Response.Write(obj.name+" = "+obj.value+"<br>");
				
				if(_name.substring(0,4)=="FILE")
				{
					var fid = Number(_name.substring(4,7));
					var imgnr = Number(_name.substring(8,10));
					
					
				}
				
			}
		}
		else
		{
			var rawform = Request.Form().Item;
			var rawform_arr = formparser(rawform);
			
			function formparser(_str)
			{
				var _arr = new Array();
				
				var rawform_arr = rawform?rawform.split("&"):"";
				for(var i=0;i<rawform_arr.length;i++)
				{
					var form_pair = rawform_arr[i]?rawform_arr[i].split("="):new Array();
					form_pair[0] = form_pair?unescape(form_pair[0]).replace(/\+/g," "):"";
					form_pair[1] = form_pair?unescape(form_pair[1]).replace(/\+/g," "):"";
					_arr[i] = new Array(form_pair[0],form_pair[1]);
				}
				return _arr;
			}
			
			for(var i=0;i<rawform_arr.length;i++)
			{
				var form_pair = rawform_arr[i];
				
				var _name = rawform_arr[i][0];
				var _value = rawform_arr[i][1];

				Response.Write(rawform_arr[i][0]+" = "+rawform_arr[i][1]+"<br>");
				
				if(_name.substring(0,4)=="FILE")
				{
					var fid = Number(_name.substring(4,7));
					var imgnr = Number(_name.substring(8,10));
					

				}
				
			}
		}
	}
%>