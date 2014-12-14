<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var ds_type      = 1;
	var masterdb     = "dataset";
	var detaildb     = "datadetail";
	var temp_masterdb = "tempset";
	
	var settingspage = 22;
	var bDebug       = false;
	var step         = 20;
	var sep          = ";";
	var safeurl       = false;
	


%>

<!--#INCLUDE FILE = "DATA_export.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
