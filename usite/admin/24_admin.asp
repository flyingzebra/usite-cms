<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 24;
	var bDebug = false;
	
	var bDebug = false;
	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var bAdmin = oDB.permissions([zerofill(rev_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(rev_type,2)+"_edit"]);
	
	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
		Response.Redirect("index.asp")

	function quote( str )
	{
		return "'"+(!str || str==null?"":str.replace(/\x27/g,"\\'"))+"'";
	}

	var languages = oDB.getSetting(zerofill(rev_type,2)+"_L");

	var dayfr = new Date();
	var dayto = new Date(dayfr);
	
	var fr = dayfr.format("%Y-%m-%d %H:%M:%S");
	var to = dayto.format("%Y-%m-%d %H:%M:%S");

	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_rev","rev_rt_typ","rev_rt_cat","rev_url","rev_crea_acc_id","rev_mod_acc_id","rev_pub","rev_date_published","rev_date_published = '0000-00-00 00:00:00' AS isDatePublised"
	," '"+fr+"' >= rev_date_published and rev_date_published <> '0000-00-00 00:00:00' as highlite"
	," '"+to+"' < rev_date_published as todo");
	
	var checkarr =    ["on","sum","lck","del"];
	var checktitles = ["Online","Apprear in summary","Locked","Delete"];
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;

	var act = Request.Form("act").Item;
	if(act)
	{
		if(act.indexOf(",")>0)
			act = act.substring(0,act.indexOf(","))
	}
		
	var data = new Array();
	
	var disp_history = "";
	
	if (act == 'new')
	{
		data[0] = oDB.takeanumber(_app_db_prefix+"review");
		data[1] = "'"+_ws+"'";
		data[2] = rev_type;
		data[3] = Session("uid");
		data[4] = "SYSDATE()"
		SQL = "insert into "+_db_prefix+"review (rev_id,rev_dir_lng,rev_rt_typ,rev_crea_acc_id,rev_crea_date) values (" + data.join(",") + ")";
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
	
	var lSQL = "select count(*) from "+_db_prefix+"review where rev_rt_typ = "+rev_type+" and rev_dir_lng = \""+_ws+"\" and rev_pub & 8 = 0";
	var overviewlength = oDB.get(lSQL)*tablefld.length;
	
//Response.Write(lSQL+"<br><br>")	
	
	var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(pag-1)*ipp+","+ipp);
	
	var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_rt_typ = "+rev_type+" and rev_dir_lng = \""+_ws+"\" and rev_pub & 8 = 0 order by rev_title,rev_desc "+limit;
	var overview = oDB.getrows(SQL);

//Response.Write("<br><br>" + SQL)

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
	
	// C A T E G O R Y   C O L L E C T I O N
	
	var catref = new Array();
	var cats = oDB.getrows("select rt_id,rt_name from "+_db_prefix+"reviewtype where rt_id <> rt_parent_id and rt_typ = "+rev_type);
	for (var i=0; i<cats.length ; i+=2)
		catref[cats[i]] = cats[i+1];
	
	// U P D A T E

	if (act == 'save')
	{
		for( var i=0 ; i < overview.length ; i+= tablefld.length )
		{
			var check_mask = (1<<(checkarr.length))-1
			var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
			if ((pub & check_mask) != (overview[i+enumfld["rev_pub"]] & check_mask))
			{
					//Response.Write(SQL+"<br>");
					//Response.Flush();
					var history =  overview[i+enumfld["rev_id"]] + ",\"" + fr + "\",\"" +  Session("uid") + "\",\"" +((pub&1)==1?"+":"-") + "\",\"" + ( typeof(overview[i+enumfld["rev_date_published"]])=="date"?new Date(overview[i+enumfld["rev_date_published"]]).format("%d-%m-%Y %H:%M"):""  ) + "\",\"" + (overview[i+enumfld["rev_title"]]?overview[i+enumfld["rev_title"]].substring(0,35):"") + "\"<br>";
					disp_history += history;
					
					//var batch_idx = oDB.takeanumber(_app_db_prefix+"batch");
					//iSQL = "insert into batch (b_id,b_text) values (" + batch_idx + "," + quote(history) + ")";
					//oDB.exec(iSQL);
					
					//Response.Write( (1<<(checkarr.length))-1 );
					
					var uSQL = "update "+_db_prefix+"review set rev_pub = (rev_pub & ~"+check_mask+") | "+pub+" where rev_id = "+overview[i+enumfld["rev_id"]];
					//Response.Write(uSQL)
					oDB.exec(uSQL);
			}
		}
		//Response.Write(SQL+"<br>");
		//Response.Flush();
		var overview = oDB.getrows(SQL);
	}

//Response.Write(overview+"<br>");


var commands = "&nbsp;<input type=\"submit\" name=\"act\" value=\"refresh\" style=height:17px;font-size:9px>";
if(bAdmin)
{
	commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\"new\" style=height:17px;font-size:9px>";
	commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\"save\" style=height:17px;font-size:9px>";
}

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
<%if(bAdmin){%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:35 title='Define'></td>
<%}%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:35 title='Edit'></td>
<%
	for (var i=0;i<checkarr.length;i++)
		Response.Write("<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='"+checktitles[i]+"'>"+checkarr[i]+"</td>");
%>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='Created by'>C</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold;width:25 title='Modified by'>M</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Title'>T I T L E</td>
<td style=background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold title='Description'>D E S C</td>

</tr>
<%
	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
		
		var rowcolor = "";
		if(overview[i+(tablefld.length-1)]=="1")
			rowcolor = "background-color:#EAEAFF"
	
		if (overview[i+enumfld["rev_title"]])
			overview[i+enumfld["rev_title"]] = overview[i+enumfld["rev_title"]].substring(0,35);
		else
			overview[i+enumfld["rev_title"]] = "";
				
		Response.Write("<tr align=right>");
			
		
		if(bAdmin)
			Response.Write("<td><a href="+zerofill(rev_type,2)+"_def_dlg.asp?id="+overview[i+enumfld["rev_id"]].toString().encrypt("nicnac")+" target=_blank><img src=../images/i_def.gif border=0 title="+overview[i+enumfld["rev_id"]]+"></td>");
		if ((overview[i+enumfld["rev_pub"]] & 4) == 0)
			Response.Write("<td><a href="+zerofill(rev_type,2)+"_edit_dlg.asp?id="+overview[i+enumfld["rev_id"]].toString().encrypt("nicnac")+"><img src=../images/i_edit.gif border=0></td>");
		else
			Response.Write("<td></td>");

		for (var j=0;j<checkarr.length;j++)
			Response.Write("<td style=text-align:center;background-color:#e0e0e0><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["rev_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></td>");
	
		var i_crea = overview[i+enumfld["rev_crea_acc_id"]];
		var i_mod = overview[i+enumfld["rev_mod_acc_id"]];
		
		Response.Write("<td><a href='mailto:"+emailref[i_crea]+"' title='"+nameref[i_crea]+"'>"+(i_crea?i_crea:"")+"</a></td>"); // title
		Response.Write("<td><a href='mailto:"+emailref[i_mod]+"' title='"+nameref[i_mod]+"'>"+(i_mod?i_mod:"")+"</a></td>"); // desc

		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["rev_title"]]+"</td>"); // title
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["rev_desc"]]+"</td>");  // desc
		Response.Write("</tr>");
	}	
	
%>
</table>
<br><%=commands%>&nbsp;&nbsp;<%=pgnav%>
</center>
<br>
<% if(bDebug) {%>
<small><%=disp_history%></small>
<%}%>

<input type=hidden name=act>
</form>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
