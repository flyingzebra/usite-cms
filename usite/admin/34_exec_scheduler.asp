<%@ Language=JavaScript %>


<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<%
//Response.Write(new Date()+"<br>")
//Response.Write(new Date(new Date()-(-1000*60*60*24*60)).format("%d/%m/%Y %H:%M:%S"))
 
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var val = "log.txt";
var path = "..\\admin\\logs\\"+val;


var _oDB		= new DB();		// database object from DB.asp
_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
_oDB.getSettings(_oDB.oCO.ConnectString);  

try
{

  var arr = _oDB.getrows("select rev_title,rev_rev from usite_review where rev_rt_typ = 34")

  var s = FSO.CreateTextFile(Server.MapPath(path), true);
  s.WriteLine(arr.join("\r\n"));
  s.Close();
  

  
  
}
catch(e)
{
   Response.Write(e.description+"<br>")
}


%>