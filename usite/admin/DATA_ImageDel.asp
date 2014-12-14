<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../includes/GUI.asp" -->


<HTML>
<head>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
<BODY topmargin=0 leftmargin=0 bottommargin=0 rightmargin=0>
<form name=main method=post>

<%
var oGUI		= new GUI();
var Path = Server.Mappath("../images/upload");
var FSO=Server.CreateObject("Scripting.FileSystemObject");
if(typeof(_dir)!="string")
	var _dir = Session("dir");
if(typeof(_ws)!="string")
	var _ws	= _dir.substring(0,_dir.lastIndexOf("_"));
var bDebug = true;

/*
var id = Request.QueryString("id").Item?Number(Request.QueryString("id").Item.toString().decrypt("nicnac")):0;
var dt = Request.QueryString("dt").Item?Number(Request.QueryString("dt").Item.toString().decrypt("nicnac")):0;
var idx = Request.QueryString("i").Item?Request.QueryString("i").Item:"";
var idir = Request.QueryString("idir").Item?Request.QueryString("idir").Item:"";
var iwidth = Request.QueryString("iwidth").Item;


var imagewidth = iwidth?Number(iwidth):150;
*/
//var Folder = FSO.GetFolder(Path);
//var FileCollection = Folder.Files;

%>

<table cellspacing=0 cellpadding=25 bgcolor=#E0E0E0 width=550 border=0>
<tr>
	<td width=501 valign=top background=../images/feldman_texture.gif>
		<table cellspacing=0 cellpadding=0>
			<%
			var narr = Request.QueryString("narr").Item().decrypt("nicnac");
			var idir = Request.QueryString("idir").Item?Request.QueryString("idir").Item:"";
			var delimg = Request.Form("delimg").Item;
			
			delimg = delimg?delimg.toString().decrypt("nicnac"):"";
			
			Response.Write("<span style=font-family:Arial><strong>Delete this image permanently ? Click image to delete</strong></span><br><input type=image src=../"+idir+"/images/"+escape(narr)+" border=0></a>");
			Response.Write("<input type=hidden name=delimg value=\""+narr.toString().encrypt("nicnac")+"\">")
			//Response.Write("<br>"+delimg+"*<br>"+narr+"*<br>")
			if(delimg == narr)
			{
			   var fs			= Server.CreateObject("Scripting.FileSystemObject");
			   var source_path	= Server.Mappath("../"+_ws+"/images")+"\\";
			   var dest = source_path+narr
				//oDB.getrows("select * from usite_review where rev_dir_lng = "belgiancheer" and rev_rt_typ in (1,23)")
				try {fs.DeleteFile(dest); Response.Write("IMAGE DELETED PERMANENTLY")}catch(e){if (bDebug) Response.Write("*delete* "+dest+": "+e+" "+e.description)};
			}
			%>
		</table>
	</td>
</tr>
</td>
</table>

</form>
</BODY>
</HTML>