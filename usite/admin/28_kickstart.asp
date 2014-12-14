<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<%
    var bDebug = false;

	var rev_type = 28;
	var cat_type = 2;
	
	
	var oCO		= new CO();	
    var oDB		= new DB();		// database object from DB.asp

    var _ws = "snoeckpub";
	var _uid = 1
	var _dir = _ws+"_nlbe";
	
    var _templdat = new Array();
	var i = 0;
	
	Session("uid") = _uid;
	
	
	oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	//oDB.ConnectString = oCO.get("THEARTSERVER_MYSQL_DSNLESS")
	
	//Response.Write(oCO.ConnectString)
	
	oDB.getSettings(1);
	


	if(bDebug)
	    Response.Write("STEP1<br>")
	
	if(typeof(bExec)!="boolean")
		var bExec = oDB.permissions([zerofill(rev_type,2)+"_run"]);

	if(bDebug)
	    Response.Write("STEP2 (s="+s+",id="+id+",bExec="+bExec+")<br>")

		
	if(typeof(_oDB)=="undefined")
		var _oDB = oDB;		
	
	var id = id.decrypt("nicnac");
	var sSQL = "select rev_title,rev_desc,rev_rev from usite_review where rev_id = "+id+" and rev_pub & 1 = 1"
	
	if(bDebug)
	    Response.Write(sSQL+"<br>")
		

	if(!s)
	{
	   var script = oDB.getrows(sSQL);
	   Response.Write("<table height=100% width=100% ></tr><td valign=middle align=center>"
	   +"<table width=300 height=200 border=0><tr><td valign=middle align=center bgcolor=#E0E0F9><a href=?id="+Request.QueryString("id").Item+"&s="+id.toString().encrypt("nicnac")+" style=font-size:30px;font-family:Arial;text-decoration:none>RUN</a></td></tr></table>"
	   +"<span style=font-size:12px;font-family:Verdana>"
	   + (script[0]?script[0]:"") + " " + (script[1]?script[1]:"")
	   +"</span>"
	   +"<br><br>"
	   +(script[2]?sbox("<table cellspacing=0 cellpadding=0><tr><td bgcolor=white width=800 height=400 valign=top><span style=font-size:9px;font-family:Verdana>"+stripHtml(script[2]).replace(/\r/g,"<br>")+"</span></td></tr></table>"):"")
	   +"</td></tr></table>");
	}
	else if(bExec)
	{	
	    _templdat[i] = "";
	    var script = oDB.getrows(sSQL);
		eval(script[2])
		//Response.Write(script[2]);
	}
	
	_templtext = _templdat.join("\r\n");


function stripHtml(strHTML) 
{
	// Replace all newLinet with .$!$. string
	strOutput = strHTML.replace(/\n/g, ".$!$.")
	// Replace all <script>s with an empty string
	aScript=strOutput.split(/\/script>/i);
	for(i=0;i<aScript.length;i++)
		aScript[i]=aScript[i].replace(/\<script.+/i,"");
	strOutput=aScript.join('');
	// Replace all HTML tag matches with the empty string
	strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
	// Remove empty lines
	strOutput = strOutput.replace(/\.\$\!\$\.\r\s*/g,"")
	// Replace all .$!$. with the empty string
	strOutput = strOutput.replace(/\.\$\!\$\./g,"")
	// Remove empty lines
	strOutput = strOutput.replace(/\r\ \r/g,"")
	//alert(strOutput)
	return strOutput;
}
	
%>

<%=_templtext%>
<% Response.End() %>

