<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 2;

	var oGUI = new GUI();

	var oDB = new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false || oDB.permissions([zerofill(rev_type,2)+"_admin"])==false)
		Response.Redirect("index.asp")

	var languages = oDB.getSetting(zerofill(rev_type,2)+"_L");
	
	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_"+_language.substring(0,2)).split(",");
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_type);
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;
		
	var oTREE		= new oGUI.TREE();
	
	oTREE.init();
	var tree		   = oTREE.load(categories);
	var rev_categories = oTREE.combobox("name=category size=1");

	// INIT
	var attr = "name=category size=1";
	var dflt = "";

	var interval = 3;
	var indent = "----------------------------------------------------------------";

	var tmp = "";
	for (var i=0;i<oTREE.treedata.length;i+=oTREE.out_interleave)
	{
		var prev_level = oTREE.treedata[i+1-oTREE.out_interleave];
		var curr_level = oTREE.treedata[i+1];
		var next_level = oTREE.treedata[i+1+oTREE.out_interleave];
	
		tmp += (indent.substring(0,oTREE.treedata[i+1]-1))+" "+oTREE.treedata[i]+" "+oTREE.treedata[i+2];
		
		
		if(next_level > curr_level)
			tmp += " childs";
		
		if(prev_level < curr_level)
			tmp += " firstchild";		
		
		if(next_level < curr_level || !next_level)
			tmp += " lastchild";
			

			
		tmp += "<br>";
	}

	var imgarr = new Array(
							"treenode.gif"
							,"treelastnode.gif"
							,"treemnode.gif"
							,"treemlastnode.gif"
							,"treepnode.gif"
							,"treeplastnode.gif"
							,"treevertline.gif"
						  );

%>

<%
	for(var i=0;i<imgarr.length;i++)
	{
		Response.Write("<img src=../includes/images/"+imgarr[i]+">");
	}
%>

<br><br>

<%=tmp%>
