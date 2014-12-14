<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 22;
	var bCrosslanguage = true;
	var rev_cols = new Array("rev_title","rev_desc");
	var rev_fnct = new Array("def","edit");	
	var masterdb  = "paramset";
	var detaildb  = "";
	var bDebug = true;	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
