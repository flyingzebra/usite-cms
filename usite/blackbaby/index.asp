<%@ Language=JavaScript%>
<!--#INCLUDE file = "ref.asp" -->
<%
var oDB		= new DB();		// database object from DB.asp
oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
oDB.getSettings(oDB.oCO.ConnectString);

var sSQL = "select rev_rev from "+_db_prefix+"review where rev_rt_typ=21 and rev_dir_lng = \""+_ws+"\" and (rev_pub & 1)=1 order by rev_id desc"

var txt = oDB.getrows(sSQL);		
%>
<%=txt%>

<%
if(!txt || txt.length==0)
{

	var sSQL = "select concat('<a href=',ds_data01,'/',ds_data02,'/',ds_title,'_',substring(ds_desc,1,4),'/index.asp>',ds_title,' - ',substring(ds_desc,1,4),'</a> &nbsp; <a href=',ds_data01,'/',ds_data02,'/',ds_title,'_',substring(ds_desc,1,4),'/login.asp>login</a>') from "+_db_prefix+"blackbabyset where ds_rev_id = 659 and ds_title=\""+_ws+"\" LIMIT 0,1"
	var txt = oDB.getrows(sSQL);
	Response.Write(txt.join("<br>"));
}
%><%Response.End()%>





























