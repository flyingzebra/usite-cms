<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

	var ds_type   = 22;
	var masterdb  = "paramset";
	var detaildb  = "";
	var settingspage = 0;
	var bDebug    = false;

	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	var bDelete = oDB.permissions([zerofill(ds_type,2)+"_delete"]);	
	
	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
	{
		Response.Redirect("index.asp")
	}	

	function quote( str )
	{
		if(str && str!=null && typeof(str)=="string")
			str = str.replace(/\x22/g,"\\\"");
		else
			str = str || typeof(str)=="number"?str:"";
		return "\""+str+"\"";
	}	
	
	var s = Request.QueryString("s").Item;
	var dt = oDB.get("select rev_id from usite_review where rev_rt_typ = 22 and rev_title=\""+s+"\" and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 LIMIT 0,1")
	var ds = Request.QueryString("dt").Item?Number(Request.QueryString("dt").Item.toString().decrypt("nicnac")):-1;
    var fid = Request.QueryString("fid").Item;
	var sSQL = "select ds_id from usite_paramset where ds_rev_id="+(dt?dt:-1)+" and ds_title="+ds+" and ds_desc = \"["+fid+"]\" and ds_pub & 9 = 1 LIMIT 0,1"
	var id = oDB.get(sSQL);
	id = id?id:-1;


	/////////////////////////////////////
	//    L O A D   S E T T I N G S    //
	/////////////////////////////////////
	
	var oSETTINGS = new SETTINGS();
	oSETTINGS.id = dt;
	oSETTINGS.load();
	
	
	var enumsettings = new Array();
	if(oSETTINGS.settingdata["FIELD_PROPERTIES"].length>0)
		for(var i=0;i<oSETTINGS.settingdata["FIELD_PROPERTIES"].length;i+=oSETTINGS.paramtablefld.length)
			enumsettings[oSETTINGS.settingdata["FIELD_PROPERTIES"][i+1]] = i+1;
			
	var enumlistsettings = new Array();
	if(oSETTINGS.settingdata["LIST_PROPERTIES"].length>0)
		for(var i=0;i<oSETTINGS.settingdata["LIST_PROPERTIES"].length;i+=oSETTINGS.paramtablefld.length)
			enumlistsettings[oSETTINGS.settingdata["LIST_PROPERTIES"][i+1]] = i+1;
	
	var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
	var enumfld = new Array();
	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;		
	
	var sSQL = "select rev_title from usite_review where rev_rt_typ = 22 and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 order by rev_title"
	var settingnames = oDB.getrows(sSQL);

	var sub_topicnames =  settingnames.length==0?oSETTINGS.settingnames:settingnames;
	var sub_topictitles = settingnames.length==0?oSETTINGS.settingnames:settingnames;
	var ext = zerofill(ds_type,2)+"_cfg_dlg.asp?dt="+Request.QueryString("dt").Item+"&dt2="+Request.QueryString("dt2").Item+"&id="+Request.QueryString("id").Item+"&fid="+Request.QueryString("fid").Item+"&s=";
	
	var sub_menulinks = new Array();
	for(var i=0;i<sub_topicnames.length;i++)
	   sub_menulinks[i] = ext+sub_topicnames[i];
	

	//Response.Write("TODO: DELETE BUTTON !")
	
%>



<div id="topheader">
	<div id="tabheader">
		<ul>
		<%
			for(i=0;i<sub_topicnames.length;i++)
				//if (oDB.permissions([sub_topicnames[i]]))
					Response.Write("<li"+(sub_topicnames[i]==s?" id=current":"")+"><a href="+sub_menulinks[i]+" title=\""+sub_topicnames[i]+"\" style=font-size:x-small>"+sub_topictitles[i].split("<br>").join(" ")+"</a></li>")
		%>
		</ul>
	</div>
</div>


<!--#INCLUDE FILE = "DATA_rec_dlg.asp" -->
<!--#INCLUDE FILE = "../skins/adfooter.asp" -->


