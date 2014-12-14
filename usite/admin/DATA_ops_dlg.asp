<%
	var bDebug = false;
	var bChangeHistory = true;
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");


	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var bExists = Number( oDB.get("SELECT rev_id FROM "+_db_prefix+"review where rev_id="+id) )==Number(id);
	var s = Request.QueryString("s").Item;
%>

<table width=587 cellspacing=0 cellpadding=0><tr><td>
<div id="topheader">
	<div id="tabheader">
		<ul>
		<%
			var arr = new Array("IMPORT/EXPORT","INTEGRITY","QUERY")
			var ext = zerofill(ds_type,2)+"_ops_dlg.asp?id="+Request.QueryString("id").Item+"&s=";
			
			if(!s) s = arr[0]
			var sub_menulinks = new Array();
			for(var i=0;i<arr.length;i++)
			{
			   if(_T[arr[i]]) arr[i] = _T[arr[i]];
			   sub_menulinks[i] = ext+arr[i];
			}		
			
			for(i=0;i<arr.length;i++)
				//if (oDB.permissions([arr[i]]))
					Response.Write("<li"+(arr[i]==s?" id=current":"")+"><a href="+sub_menulinks[i]+" title=\""+arr[i]+"\" style=font-size:x-small>"+arr[i]+"</a></li>")

		%>
		</ul>
	</div>
</div>
</td></tr>
</table>

<br><br>


<img src=../images/spc.gif width=600 height=1>

<table cellspacing=1 cellpadding=10 bgcolor=#000000 align=center><tr><td bgcolor=#DADADA>

<table height=200 width=500><tr><td valign=top>
<%
switch(s)
{
	case "IMPORT/EXPORT":
	
	var link_json = zerofill(ds_type,2)+"_json.asp?id="+Request.QueryString("id").Item;
	var link_csv = zerofill(ds_type,2)+"_export.asp?id="+Request.QueryString("id").Item;
	
	Response.Write("<font size=3 font-face=Tahoma>EXPORT</font>")
	
	Response.Write("&nbsp;<a href="+link_json+"><img src=../images/ii_json.gif border=0></a>")
	Response.Write("&nbsp;<a href="+link_csv+"><img src=../images/ii_csv.gif border=0></a>")
	
	break;
	case "INTEGRITY":
	
	// CHECK
	var link_icheck = zerofill(ds_type,2)+"_icheck.asp?id="+Request.QueryString("id").Item;
	Response.Write("<font size=3 font-face=Tahoma>CHECK</font>")
	Response.Write("&nbsp;<a href="+link_icheck+"><img src=../images/ii_integritycheck.png border=0></a>")
	
	break;
	case "QUERY":
	break;
}
%>
</td></tr></table>

</td></tr></table>

<%
var link_back = zerofill(ds_type,2)+"_edit_dlg.asp?id="+Request.QueryString("id").Item;
Response.Write("<center><a href="+link_back+">"+_T["back"]+"</a></center>")
%>



<br><br>