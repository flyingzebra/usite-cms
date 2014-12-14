<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->

<%
	var bDebug = false;
	var rev_type = 12;
	
	///////////////////////////////////////////////
	//  G E T  I N P U T   P A R A M E T E R S   //
	///////////////////////////////////////////////

	var m = Request.QueryString("m").Item;  // MANAGEMENT NAME (e.g. 12_admin)
	var p = Request.QueryString("p").Item;  // ???
	var v = Request.QueryString("v").Item?Request.QueryString("v").Item.decrypt("nicnac"):"";
	var cat = Request.QueryString("cat").Item; // PERM or SITE
	var varr = v.split(",");
	var uid = varr[0];
	var dir = varr[1];

	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var oGUI = new GUI();
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false || oDB.permissions([zerofill(rev_type,2)+"_admin"])==false)
		Response.Redirect("index.asp")

	if(m && v && dir=="?")
	{
		// REDIRECT TO THE RIGHT MANAGEMENT
		var tablefld = new Array("ws_name","ws_dir","ws_lng");
		var enumfld = new Array();
 		for (var i=0; i<tablefld.length ; i++)
			enumfld[tablefld[i]] = i;

		var overview = oDB.getrows("SELECT ws_name,ws_dir,ws_lng FROM "+_db_prefix+"settings,"+_db_prefix+"website where s_acc_id = "+uid+" and s_name = \"SITE\" and  ws_dir like s_value order by ws_name,ws_lng");
		if(overview.length==tablefld.length)
		{
			// FOUND 1 WEBSITE
			//Response.Write("found 1");
			Response.Redirect(m.toString().decrypt("nicnac")+"_Q_v_E_"+(uid+","+overview[enumfld["ws_dir"]]+"_"+overview[enumfld["ws_lng"]]+",").toString().encrypt("nicnac")+".asp");
		}
		else if(overview.length>tablefld.length)
		{
			// FOUND MULTIPLE WEBSITES
			Response.Write("<html><head><link rel=stylesheet href=../includes/style.css type=text/css></head><body>");
			for(var i=0;i<overview.length;i+=tablefld.length)
			{
				Response.Write("<a class=small href="+m.toString().decrypt("nicnac")+"_Q_v_E_"+(uid+","+overview[i+enumfld["ws_dir"]]+"_"+overview[i+enumfld["ws_lng"]]+",").toString().encrypt("nicnac")+".asp><span style=color:#800000>"+overview[i+enumfld["ws_lng"]]+"</span> "+overview[i+enumfld["ws_name"]]+"</a><br>");
			}
			Response.Write("</body></html>");
			Response.End();
		}

		//Response.Redirect(m.toString().decrypt("nicnac")+"_Q_m_v_E_"+v+".asp");
	}
	

	var q = Request.QueryString("detail");



	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_rev","rev_rt_typ","rev_rt_cat","rev_finish","rev_code","rev_publisher","rev_phone","rev_fax","rev_email","rev_url","rev_actimg","rev_pub");
	var checkarr = ["on","sum","lck","hid"];
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;

	var id,p;
	if (Request.QueryString("id").Item)
		var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
		
	if (Request.QueryString("p").Item)
		var p = Request.QueryString("p").Item.toString().decrypt("nicnac");

	var bSubmitted	  = Request.TotalBytes==0?false:true;
	var formarr = new Array();


	//  L A N G U A G E S
/*	
	var rev_language = "";
	var rev_languages = "<select name=language><option value=0 "+(!formfld[enumfld["language"]]?"selected":"")+">";
	for (var i=0;i<languages.length;i+=2)
	{	
		if (formarr[enumfld["language"]]==languages[i])
		{
			rev_language = languages[i+1];
			rev_languages += "<option value="+languages[i]+" selected>"+languages[i+1];
		}
		else
			rev_languages += "<option value="+languages[i]+">"+languages[i+1];
	}
	rev_languages += "</select>";
	
	var translate_action = "window.open('add_rev_language_dlg.asp?id="+(formfld[enumfld["refid"]]?formfld[enumfld["refid"]].toString().encrypt("nicnac"):refid.toString().encrypt("nicnac"))+"')";
*/
	
if (id && p)
{



	
	%>
	<html>
	<body>
	<center>
		<form name="main" method="post">
		<%=box_on()%>
		<table cellspacing="1" cellpadding="5" width="300" height="100" bgcolor="black">
		<tr>
			<td align="center" bgcolor="#DCDCDC">
					
				TODO: show list of specific permissions related to <%=p%>
					
			</td>
		</tr>
		</table>
		<%=box_off()%>

		</form>
	</center>
	</body>
	</html>
	<%
}
else if (id & v)
{
	var perm_languages = oDB.getSetting("LNG",zerofill(rev_type,2)+"_");

	var languages = oDB.getrows("SELECT distinct ws_lngcode,ws_lngname from "+_db_prefix+"website " + ( perm_languages.length>0 ? ( "where ws_lngcode IN ("+perm_languages+")" ) :( "where ws_lngcode IN ('"+_language.substring(0,2)+"')" )  )   );		
	var enumcatfld = new Array();
	var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_"+_language.substring(0,2)).split(",");
	var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_typ = "+rev_type);
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;

	//////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S	//
	//////////////////////////////////////////

	//  CATEGORIES

	var oTREE		= new oGUI.TREE();
	
	oTREE.init();
	var tree		= oTREE.load(categories);
	var rev_categories = oTREE.combobox("name=category size=1",formarr[enumfld["category"]]);

}
else if (id)
{
%>

<html>
<body>
<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

	var tablefld = new Array("s_id","s_acc_id","s_name","s_value","s_pub");
	var checkarr =    ["on","sum","lck","hid"];
	var checktitles = ["Online","Apprear in summary","Locked","Hidden/Trashed"];
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;

	var act = Request.Form("act").Item;
	
	var data = new Array();
	if (act == 'new')
	{
		data[0] = oDB.takeanumber(_db_prefix+"settings");
		data[1] = id
		data[2] = "\""+cat+"\"";
		data[3] = "\"\"";
		data[4] = 0
		SQL = "insert into "+_db_prefix+"settings ("+tablefld.join(",")+") values (" + data.join(",") + ")"
		oDB.exec(SQL)
	}

	var checkformarr = new Array();
	for (var i=0;i<checkarr.length;i++)
	{
		checkformarr[new String(checkarr[i])] = Request.Form("chk_"+checkarr[i]).Item;
		if(bDebug)
			Response.Write("Form['"+"chk_"+checkarr[i]+"'] = '"+Request.Form("chk_"+checkarr[i]).Item+"'<br>");
	}

	var bSubmitted	  = Request.TotalBytes==0?false:true;
		
	// GENERATE CHECKBOX ARRAY PARAMETERS

	var pubarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		if (checkformarr[checkarr[i]])
		{
			var tmp = checkformarr[new String(checkarr[i])].split(",");
			for (var j=0 ; j<tmp.length ; j++)
				pubarr[new Number(tmp[j])] = pubarr[new Number(tmp[j])]?(pubarr[new Number(tmp[j])] + (1<<i)):(1<<i);
		}
	
	// Q U E R Y
	
	var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"settings where s_acc_id = "+id+" and s_name = '"+cat+"'";
	if(bDebug)
		Response.Write(SQL);
	var overview = oDB.getrows(SQL);

	// E M A I L   C O L L E C T I O N
	
	var emailref = new Array();
	var nameref = new Array();
	var users = oDB.getrows("select ds_id,ds_data03,ds_title,ds_desc from "+_db_prefix+"blackbabyset where ds_rev_id = 661");

	for (var i=0; i<users.length ; i+=4)
	{
		emailref[users[i]] = users[i+1];
		nameref[users[i]] = users[i+2] + " "+ users[i+3];
	}
	
	// C A T E G O R Y   C O L L E C T I O N
	
	var catref = new Array();
	var cats = oDB.getrows("select rt_id,rt_name from "+_db_prefix+"reviewtype where rt_typ = "+rev_type);
	for (var i=0; i<cats.length ; i+=2)
		catref[cats[i]] = cats[i+1];

	
	// U P D A T E


	if (act == 'save')
	{
		for( var i=0 ; i < overview.length ; i+= tablefld.length )
		{
			var pub = bSubmitted==true?(pubarr[overview[i+enumfld["s_id"]]]?pubarr[overview[i+enumfld["s_id"]]]:0):overview[i+enumfld["s_pub"]];
			if (pubarr[overview[i+enumfld["s_id"]]] != overview[i+enumfld["s_pub"]])
			{
					var uSQL = "update "+_db_prefix+"settings  set s_pub = "+pub+" where s_id = "+overview[i+enumfld["s_id"]];
					if(bDebug)
						Response.Write(uSQL+"<br>");					
					oDB.exec(uSQL);
			}
		}

		var overview = oDB.getrows(SQL);
	}



var commands = "&nbsp;<input type=\"submit\" name=\"act\" value=\"refresh\" style=height:17px;font-size:9px>";
commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\"new\" style=height:17px;font-size:9px>";
commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\"save\" style=height:17px;font-size:9px>";

%>

<STYLE>
	.qtable { background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.qtable td{ background-color:white;padding-left: 1px;padding-right: 1px;padding-top: 1px;padding-bottom: 1px;white-space: nowrap;}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
</STYLE>



<form method=post name=main>
<%=commands%>
<br><br>
<center>
<table cellspacing=1 class=qtable width=500>
<tr>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold  title='Edit' width=40></td>
<%
	for (var i=0;i<checkarr.length;i++)
		Response.Write("<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold; title='"+checktitles[i]+"'>"+checkarr[i]+"</td>");
%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Title'>N A M E</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Description'>V A L U E</td>
</tr>
<%

	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["s_id"]]]?pubarr[overview[i+enumfld["s_id"]]]:0):overview[i+enumfld["s_pub"]];

		Response.Write("<tr>");

		if ((overview[i+enumfld["s_pub"]] & 4) == 0)
			Response.Write("<td><a target=_blank href="+zerofill(rev_type,2)+"_edit_dlg.asp?id="+overview[i+enumfld["s_id"]].toString().encrypt("nicnac")+" title='edit'><img src=../images/i_edit.gif border=0></a></td>");	
		else
			Response.Write("<td></td>");		
		
		for (var j=0;j<checkarr.length;j++)
			Response.Write("<td style=text-align:center;background-color:#e0e0e0><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["s_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></td>");
				
		Response.Write("<td>"+overview[i+enumfld["s_name"]]+"</td>"); // title
		Response.Write("<td>"+overview[i+enumfld["s_value"]]+"</td>"); // desc
		Response.Write("</tr>");
	}
%>
</table>
</center>
<br>
<%=commands%>
</form>

</body>
</html>
	<%
}
else
{
}

%>