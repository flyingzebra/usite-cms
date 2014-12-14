<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 18;
	
	var bDebug = false;
	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false || oDB.permissions([zerofill(rev_type,2)+"_admin"])==false)
		Response.Redirect("index.asp")

	var tablefld = new Array("ws_id","ws_name","ws_baseurl","ws_proj","ws_dir","ws_lng","ws_pub","ws_crea_acc_id","ws_crea_date","ws_mod_acc_id","ws_mod_date");
	
	var checkarr =    ["on","sum","lck","hid"];
	var checktitles = ["Online","Apprear in summary","Locked","Hidden/Trashed"];
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;

	var act = Request.Form("act").Item;
	if(act)
	{
		if(act.indexOf(",")>0)
			act = act.substring(0,act.indexOf(","));
	}
		
	var data = new Array();
	var disp_history = "";
	
	if (act == 'new')
	{
		data[0] = oDB.takeanumber(_app_db_prefix+"website");
		data[1] = "''";
		data[2] = "''";
		data[3] = "'usite'";
		data[4] = "''";
		data[5] = "''";
		data[6] = "0";
		data[7] = _uid;
		data[8] = "SYSDATE()";
		data[9] = "0";
		data[10] = "'0000-00-00 00:00:00:00'";
		
		SQL = "insert into "+_db_prefix+"website ("+tablefld.join(",")+") values (" + data.join(",") + ")";
		oDB.exec(SQL)		
	}

	var checkformarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		checkformarr[new String(checkarr[i])] = Request.Form("chk_"+checkarr[i]).Item;

	var bSubmitted	  = Request.TotalBytes==0?false:true;
	if (act == 'refresh' || act== '')
		bSubmitted = false;	
		
	// GENERATE CHECKBOX ARRAY PARAMETERS

	var pubarr = new Array();

	for (var i=0;i<checkarr.length;i++)
		if (checkformarr[checkarr[i]])
		{
			var tmp = checkformarr[new String(checkarr[i])].split(",");
			for (var j=0 ; j<tmp.length ; j++)
				pubarr[new Number(tmp[j])] = pubarr[new Number(tmp[j])]?(pubarr[new Number(tmp[j])] + (1<<i) ):(1<<i);
		}
	
	//////////////////////////////////////////////////////////////
	//  P A G E   N A V I G A T I O N  I N I T I A L I S E R S  //
	//////////////////////////////////////////////////////////////
	
	var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):1;
	var spp = 10;  // MAX NAVIGATIONBAR WIDTH
	var ipp = 25; // ITEMS PER PAGE
	var maxrec = 1000;		
	
	// Q U E R Y
	
	var lSQL = "select count(*) from "+_db_prefix+"website group by ws_dir order by ws_id";
	var overviewlength = oDB.get(lSQL)*tablefld.length;
	
	var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(pag-1)*ipp+","+ipp);
	var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"website group by ws_dir order by ws_id "+limit;
	var overview = oDB.getrows(SQL);



	/////////////////////////////////////
	//  P A G E   N A V I G A T I O N  //
	/////////////////////////////////////

	bSpiderSafeURL = typeof(SiderSafeURL)=="string"; 

	var n = Math.round(overviewlength/(ipp*tablefld.length)+0.499);
	var begin = 0;

	var pgnav = "";	
	if (pag == 0)
		pgnav += "<font color=#800000 title='max. "+maxrec+" items'><b>[full list]</b></font>&nbsp;&nbsp; ";
	else
	{
		pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+"_Q_pag_E_0"+SpiderSafeExt+"#subtop"):"?pag=0#subtop")+" title='max. "+maxrec+" items' class=small>[full list]</a>&nbsp;&nbsp; ";
				
		//if (pag>1)
			pgnav += "<a href=?pag=1#subtop class=small>[start]</a>&nbsp; "
			      +  "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag-(pag>1?1:0))+"#subtop><img src=../images/lnav.gif border=0 title='vorige pagina' style=vertical-align:text-top></A>&nbsp;&nbsp;";
		begin = pag-Math.round(spp/2)<0 ? 0 : (pag-Math.round(spp/2));
		begin = spp/2>(n-pag-1) ? (n-spp) : begin;
		begin = begin<=0 ? 0 : begin;
	}

	for( var i=begin+1 ; i <= begin+spp && i <= n ; i++ )
			if (i == pag)
				pgnav += "<font color=#800000><b>["+i+"]</b></font>&nbsp;&nbsp;";
			else
				pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+i+"#subtop class=small>["+i+"]</a>&nbsp; ";

	//if (pag<n)
		pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag+(pag<n?1:0))+"#subtop><img src=../images/rnav.gif border=0 title='volgende pagina' style=vertical-align:text-top></a>"
				+ "&nbsp;<a href=?pag="+n+"#subtop class=small title='"+n+"'>[end]</a>";

	var ippl = ipp*tablefld.length;
	if (pag==0)
		ippl = overviewlength>(maxrec*tablefld.length)?(maxrec*tablefld.length):overviewlength;
	var ipps = pag==0?0:ippl*(pag-1);



	// E M A I L   C O L L E C T I O N
	
	var emailref = new Array();
	var nameref = new Array();
	var users = oDB.getrows("select ds_id,ds_data03,ds_title,ds_desc from "+_db_prefix+"blackbabyset where ds_rev_id = 661");

	for (var i=0; i<users.length ; i+=4)
	{
		emailref[users[i]] = users[i+1];
		nameref[users[i]] = users[i+2] + " "+ users[i+3];
	}
	
	// U P D A T E

	if (act == 'save')
	{
		//Response.Write(overview+"<br><br>")
		for( var i=0 ; i < overview.length ; i+= tablefld.length )
		{
			var check_mask = (1<<(checkarr.length))-1
			var pub = bSubmitted==true?(pubarr[overview[i+enumfld["ws_id"]]]?pubarr[overview[i+enumfld["ws_id"]]]:0):overview[i+enumfld["ws_pub"]];
			
			//Response.Write((pub & check_mask)+" ("+overview[i+enumfld["ws_pub"]]+") "+(overview[i+enumfld["ws_pub"]] & check_mask)+"<br>");
			
			if ((pub & check_mask) != (overview[i+enumfld["ws_pub"]] & check_mask))
			{					
					var uSQL = "update "+_db_prefix+"website set ws_pub = (ws_pub & ~"+check_mask+") | "+pub+" where ws_dir = '"+overview[i+enumfld["ws_dir"]]+"'";
					//Response.Write(uSQL);
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
<center>
<%=commands%>&nbsp;&nbsp;<%=pgnav%><br><br>
<table cellspacing=1 class=qtable width=570>
<tr>
<!--td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold  title='View'></td-->
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold  title='Edit'></td>
<%
	for (var i=0;i<checkarr.length;i++)
		Response.Write("<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='"+checktitles[i]+"'>"+checkarr[i]+"</td>");
%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Created by'>C</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Modified by'>M</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Project Name'>N A M E</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Project Name'>C O D E</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Planned'>U R L</td>
</tr>
<%
	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["ws_id"]]]?pubarr[overview[i+enumfld["ws_id"]]]:0):overview[i+enumfld["ws_pub"]];
		
		var rowcolor = "";
		if(overview[i+(tablefld.length-1)]=="1")
			rowcolor = "background-color:#EAEAFF";
		if (overview[i+enumfld["ws_name"]])
			overview[i+enumfld["ws_name"]] = overview[i+enumfld["ws_name"]].substring(0,35);
		else
			overview[i+enumfld["ws_name"]] = "";
				
		Response.Write("<tr>");
		//Response.Write("<td><a target=_blank href="+zerofill(rev_type,2)+"_fulldetail.asp?id="+overview[i+enumfld["ws_id"]].toString().encrypt("nicnac")+"><img src=../images/i_view.gif border=0></a></td>");
		if ((overview[i+enumfld["ws_pub"]] & 4) == 0)
			Response.Write("<td><a target=_blank href="+zerofill(rev_type,2)+"_edit_dlg.asp?id="+overview[i+enumfld["ws_id"]].toString().encrypt("nicnac")+"><img src=../images/i_edit.gif border=0></td>");
		else
			Response.Write("<td></td>");
		for (var j=0;j<checkarr.length;j++)
			Response.Write("<td style=text-align:center;background-color:#e0e0e0><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["ws_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></td>");
		var i_crea = overview[i+enumfld["ws_crea_acc_id"]];
		var i_mod = overview[i+enumfld["ws_mod_acc_id"]];
		Response.Write("<td><a href='mailto:"+emailref[i_crea]+"' title='"+nameref[i_crea]+"'>"+(i_crea?i_crea:"")+"</a></td>"); // title
		Response.Write("<td><a href='mailto:"+emailref[i_mod]+"' title='"+nameref[i_mod]+"'>"+(i_mod?i_mod:"")+"</a></td>"); // desc
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ws_name"]]+"</td>");    // name
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ws_dir"]]+"</td>");     // dir
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ws_baseurl"]]+"</td>"); // url
		Response.Write("</tr>");
	}	
	
%>
</table>
<br><%=commands%>&nbsp;&nbsp;<%=pgnav%>
</center>
<br>
<small><%=disp_history%></small>

<input type=hidden name=act>
</form>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
