<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type 	= 23;
	var editlink    = 27;
	
	var masterdb	= "dataset";
	var detaildb	= "datadetail";
	
	var bAdmin = false;
	var bEdit = true;
	var whereclause = " and rev_rev like \"%email%\"";
%>

<!--#INCLUDE FILE = "DATA_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
