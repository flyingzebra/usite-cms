<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 26;
	var rev_cols = new Array("rev_email","rev_title","rev_desc","rev_url");
	var rev_fnct = new Array("view","edit");
	var insfld = new Array();
	insfld["rev_title"] = "pop.mailprotect.be";
	insfld["rev_desc"] =  "simple";
	insfld["rev_url"]  =  "http://webmail.2go.be/index.pl";
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
