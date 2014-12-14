<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 14;
	var rev_cols = new Array("rev_rt_cat","rev_title","rev_desc");
	var rev_fnct = new Array("view","edit");
	
	var insfld = new Array();
	insfld["rev_rt_cat"] =  Request.QueryString("cat").Item ? Request.QueryString("cat").Item.decrypt("nicnac") : "";	
	insfld["rev_title"] = "";
	insfld["rev_desc"] =  "";
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));	

	function PATCH_viewbutton()
	{
	
	/*
		if(!this.param["viewpath"])
		{
			var sSQL = "select CONCAT(ds_data01,\"/\",ds_data02,\"/\",\""+_dir+"\",\"/\")  from "+_app_db_prefix+"blackbabyset where ds_rev_id = 659 and ds_title=\""+_dir.split("_")[0]+"\" and ds_desc like \"%"+_dir.split("_")[1]+"%\"  LIMIT 0,1"
			//Response.Write(sSQL+"***")

			this.param["viewpath"] = oDB.get(sSQL);
		}	
	*/
    this.param["viewpath"] = "../"+_dir+"/";
		
		
		var url = bSpiderSafeURL?("index_Q_P_E_"+this.param["cat"]+".asp"):("index.asp?p="+this.param["cat"])
		if(this.param["pub"]&1)
			Response.Write("<td class=wbtn><a href="+this.param["viewpath"]+url+" target=_blank><img src=../images/i_view.gif border=0></a></td>");
		else
			Response.Write("<td class=wbtn></td>");		
	}	
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->