<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 30;
	var cat_type = 2;
	var bCrosslanguage = true;
	var bDataManager   = true;
	var rev_cols = new Array("rev_rt_cat","rev_title","rev_desc");
	
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
		
	if(oDB.permissions([zerofill(rev_type,2)+"_admin"]))
		var rev_fnct = new Array("def","iedit");
	else
		var rev_fnct = new Array("iedit");
		
		
	var insfld = new Array();
	insfld["rev_title"] = "";
	insfld["rev_desc"] =  "";
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
