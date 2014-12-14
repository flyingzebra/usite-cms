<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 2;
	var cat_type = 2;
	var bCrosslanguage = true;
	var bDataManager   = true;
	var rev_cols = new Array("rev_title","rev_desc");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
		
	if(oDB.permissions([zerofill(rev_type,2)+"_admin"]))
		var rev_fnct = new Array("ldf","iedit","run");
	else
		var rev_fnct = new Array("run");
		
	var insfld = new Array();
	insfld["rev_title"] = "query"
	insfld["rev_header"] = 
	 "<"+"?"+"xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\r\\n"
	+"<ROOT>\\r\\n"
	+"  <row>\\r\\n"
	+"    <field name=\\\"ds_title\\\">[1]</field>\\r\\n"				
	+"    <field name=\\\"ds_desc\\\">[2]</field>\\r\\n"
	+"    <field name=\\\"ds_header\\\">[3]</field>\\r\\n"
	+"    <field name=\\\"ds_data01\\\">[4]</field>\\r\\n"
	+"    <field name=\\\"ds_data02\\\">[5]</field>\\r\\n"	
	+"    <field name=\\\"ds_data03\\\">[6]</field>\\r\\n"
	+"    <field name=\\\"ds_data04\\\">[7]</field>\\r\\n"			
	+"  </row>\\r\\n"
	+"</ROOT>\\r\\n"
	
	insfld["rev_rev"] = 
	 "<"+"?xml version=\\\"1.0\\\" encoding=\\\"UTF-8\\\"?>\\r\\n"
	+"<ROOT>\\r\\n"
	+"  <row>\\r\\n"
	+"    <field name=\\\"field\\\">[1]</field>\\r\\n"				
	+"    <field name=\\\"link\\\">[2]</field>\\r\\n"
	+"    <field name=\\\"criteria\\\">[3]</field>\\r\\n"
	+"    <field name=\\\"orderby\\\">[4]</field>\\r\\n"
	+"    <field name=\\\"format\\\">[5]</field>\\r\\n"
	+"    <field name=\\\"destination\\\">[6]</field>\\r\\n"
	+"    <field name=\\\"navigation\\\">[7]</field>\\r\\n"			
	+"  </row>\\r\\n"
	+"</ROOT>\\r\\n"
	insfld["rev_publisher"] = "dataset"	
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
