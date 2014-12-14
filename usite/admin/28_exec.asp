<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 28;
	var cat_type = 2;
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	

	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
		
	if(typeof(bExec)!="boolean")
		var bExec = oDB.permissions([zerofill(rev_type,2)+"_run"]);
		
	if(bExec)
	{
		var script = oDB.get("select rev_rev from usite_review where rev_id = "+Request.QueryString("s").Item.toString().decrypt("nicnac"))
		eval(script)
		//Response.Write(script)
	}
	//else
	//	Response.Write("*******"+zerofill(rev_type,2)+"_run")
	
%>
