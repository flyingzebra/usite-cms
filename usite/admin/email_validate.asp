<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->

<%

///////////////////////////////////////////////
//  G E T  I N P U T   P A R A M E T E R S   //
///////////////////////////////////////////////

var v = Request.QueryString("v").Item?Request.QueryString("v").Item.decrypt("nicnac"):"";
var varr = v.split(",");
var usr = varr[0];
var psw = varr[1];
var language = varr[2];
var permission = varr[3];
	
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
	
oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
oDB.login(usr,psw);
pass = oDB.loginValid()?pass:1
if (pass==0)
{
	var SQL = "select acc_id from "+_db_prefix+"acc where acc_name='"+usr+"' and acc_psw='"+psw+"'"
	debug(SQL);
		
	var formdata2 = new Array();
	formdata2[0] = oDB.getanumber(_db_prefix+"settings");
	formdata2[1] = oDB.get(SQL);
	formdata2[2] = "'PERM'";
	formdata2[3] = "'"+permission+"'";	 

	debug("userid found : "+oDB.getanumber(_app_db_prefix+"settings"));
		
	var SQL = "select s_acc_id from "+_db_prefix+"settings where s_acc_id="+formdata2[1]+" and s_name="+formdata2[2]+" and s_value="+formdata2[3]
	debug(SQL);
	var result = oDB.get(SQL)

	if (!result)
	{
		try
		{
		
				var SQL = "insert into "+_db_prefix+"settings (s_id,s_acc_id,s_name,s_value) values ("+formdata2.join(",")+")";
				debug(SQL);	
				if (!bDebug)
				{
					formdata2[0] = oDB.takeanumber(_app_db_prefix+"settings ");
					oDB.exec(SQL);
				}
		}
		catch(e)
		{ 
			error = "user already subscribed";
		}
	}
}

if (!bDebug)
	Response.Redirect("menu.asp");
	
%>