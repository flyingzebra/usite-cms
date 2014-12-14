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

var id = Request.QueryString("id").Item?Number(Request.QueryString("id").Item.toString().decrypt("nicnac")):0;
var idir = Request.QueryString("idir").Item?Request.QueryString("idir").Item:"";
var iwidth = Request.QueryString("iwidth").Item;

var imagewidth = iwidth?Number(iwidth):150;
var Folder = FSO.GetFolder(Path);
var FileCollection = Folder.Files;

%>

<table cellspacing=0 cellpadding=25 bgcolor=#E0E0E0 width=550 border=0>
<tr>
	<td width=501 valign=top background=../images/feldman_texture.gif>
		<table cellspacing=0 cellpadding=0>
			<%
			var i=0;			
			
			var Path = Server.Mappath("../"+idir+"/images");

			var Folder = FSO.GetFolder(Path);
			var FileCollection = Folder.Files;
			for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
			  i++;
			  var strFileName = objEnum.item().name;
			  var iname = "i"+zerofill(i,10);
			  
			  //Response.Write(strFileName+"<br>")
			  if(strFileName.substring(3,13)==zerofill(id,10))
			  {
				var namearr = strFileName.split("_");
				var photoname = strFileName.replace(new RegExp(namearr[0]+"_"+namearr[1]+"_","g"),"");
				
				
				Response.Write("<tr><td valign=top style=font-size:15px;font-family:Georgia;font-weight:bold><img src=../images/"+idir+"/"+escape(strFileName)+"> "+photoname+"<br><br></td></tr>\r\n");
			  }
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