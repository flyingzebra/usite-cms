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
var dt = Request.QueryString("dt").Item?Number(Request.QueryString("dt").Item.toString().decrypt("nicnac")):0;
var idx = Request.QueryString("i").Item?Request.QueryString("i").Item:"";
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
			
			var filenames = new Array()
			for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
				filenames[filenames.length] = objEnum.item().name;
			}
			
			
			for (var i=0;i<filenames.length;i++)
			{
			  var strFileName = filenames[i];
			  var iname = "i"+zerofill(i,10);
			  
			  //Response.Write(strFileName.substring(3,13)+" "+zerofill(dt,10)+" "+strFileName.substring(21,24)+"<br>")
			  if(     strFileName.substring(0,3)=="img"
					&& strFileName.substring(3,13)==zerofill(dt,10)
					&& strFileName.substring(21,24)==zerofill(idx,3))
			  {
				var namearr = strFileName.split("_");
				var photoname = strFileName.replace(new RegExp(namearr[0]+"_"+namearr[1]+"_"+namearr[2]+"_"+namearr[3]+"_"+namearr[4]+"_","g"),"");
				
				
				Response.Write("<tr><td valign=top style=font-size:15px;font-family:Georgia;font-weight:bold><img src=../"+idir+"/images/"+escape(strFileName)+"> "+photoname
				+"<a href=DATA_ImageDel.asp?narr="+namearr.join("_").encrypt("nicnac")+"&idir="+idir+" target=_blank><img src=../images/i_delete.gif border=0></a>"
				+"<br><br></td></tr>\r\n");
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