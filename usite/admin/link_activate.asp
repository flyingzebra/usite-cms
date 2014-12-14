<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->

<%

///////////////////////////////////////////////
//  G E T  I N P U T   P A R A M E T E R S   //
///////////////////////////////////////////////

var v = Request.QueryString("v").Item?Request.QueryString("v").Item.decrypt("nicnac"):"";
var varr = v.split(",");
var uid = varr[0];
var dir = varr[1];

//Response.Write(uid+" "+dir+"<br>");
//Response.End();
	
var bDebug = false;
	
function debug(str)
{
	if (!bDebug) return;			
	Response.Write(str+"<br>");
	Response.Flush();
}
	
debug(varr);

//////////////////////////////////////////////////////////////////
//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
//////////////////////////////////////////////////////////////////
	
var oDB		= new DB();		// database object from DB.asp
var pass = 0;
var error = "";

///////////////////////////////////////////
//  G E N E R A T E   S Q L   Q U E R Y	 //
///////////////////////////////////////////


oDB.loginsec = function DBloginsec (_usr,_psw)
{
	Session("con") = this.oCO.Conn;
	Session("uid") = _usr;
}

Session("dir") = dir;
oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");

debug("oDB.login(uid)")

oDB.login(uid);

debug("uid="+uid)

pass = oDB.loginValid()?pass:1

debug("pass="+pass)

//Response.Write(Session("uid"));
//Response.End();


if (pass==0)
{
	//var SQL = "select acc_id from "+_db_prefix+"acc where acc_name='"+usr+"' and acc_psw='"+psw+"'"
	//debug(SQL);
		
	debug("_db_prefix = "+_db_prefix)	
		
	var formdata2 = new Array();
	formdata2[0] = oDB.getanumber(_db_prefix+"settings");
	formdata2[1] = uid;
	formdata2[2] = "'PERM'"; 

	debug("userid found : "+oDB.getanumber(_db_prefix+"settings"));
		
	var SQL = "select s_acc_id from "+_db_prefix+"settings where s_acc_id="+formdata2[1]+" and s_name="+formdata2[2]
	debug(SQL);
	var result = oDB.get(SQL)
}

if (!bDebug)
	Response.Redirect("menu.asp");
	
%>