<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 33;
	var cat_type = 2;
	var bCrosslanguage = true;
	var bDataManager   = true;
	var rev_cols = new Array("rev_rt_cat","rev_title","rev_desc");
	var rev_fnct = new Array("def","edit");
	var insfld = new Array();
	insfld["rev_title"] = "";
	insfld["rev_desc"] =  "";
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
