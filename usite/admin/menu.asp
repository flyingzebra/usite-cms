<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%

//Response.Write(_ws);

var FSO = new ActiveXObject("Scripting.FileSystemObject");
var incldir = Server.MapPath("\\")+"\\"+_proj+"\\"+_ws+"\\lib";
var inclfile = incldir+"\\SYSTEM.menu.asp"

if(FSO.FolderExists(incldir) && FSO.FileExists(inclfile))
{
      txtFile = FSO.OpenTextFile(inclfile, 1, false, 0);  
      var fText = txtFile.ReadAll();
	  Response.Clear();
	  eval(fText);
	  Response.End();
}
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var oDB		= new DB();		// database object from DB.asp
	
	oDB.caller = "menu.asp"
	oDB.oCO.get(Session("con"));
	
	oDB.getSettings(Session("uid"));

	//Response.Write(Session("uid"));

	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");


	var topic = new Array();
	var topicname = new Array();
	var menulink  = new Array();

	/////////////////////////////////////////
	//  C H E C K   P E R M I S S I O N S  //
	/////////////////////////////////////////	

	var sSQL = "select rd_text from usite_blackbabydetail where rd_ds_id = 661 and rd_dt_id = 24 and rd_recno = "+Session("uid");
	var permIDS = oDB.get(sSQL);
	
	var sSQL = "select ds_id,ds_title,ds_desc,ds_data01 from usite_blackbabyset where ds_rev_id = 1313 "+(permIDS?(" and ds_id in (\""+permIDS.rtrimc(",").split(",").join("\",\"")+"\")"):"(0)")+" and length(ds_data01)>0 and (ds_pub & 1) = 1";
	var permDATA = oDB.getrows(sSQL);
	//Response.Write(sSQL+"<br>");

	var perm = ","+oDB.getrows("select s_value from "+_db_prefix+"settings where s_name='PERM' and s_acc_id="+Session("uid")).join(",")+","
	//Response.Write("select s_value from "+_db_prefix+"settings where s_name='PERM' and s_acc_id="+Session("uid")+"<br>")
	//Response.Write(perm)
	var j=0;
	
	for(i=0;i<permDATA.length;i+=4)
	{
		topicname[j] 	= permDATA[i+1];
		topic[j] 		= permDATA[i+2];
		menulink[j] 	= permDATA[i+3];
		j++;		
	}
	
	
	/*
	for(i=0;i<topics.length;i++)
		if (perm.indexOf(topicnames[i])>=0)
		{
			topic[j] = new String(topics[i]);	
			topicname[j] = new String(topictitles[i]);
			menulink[j] = new String(menulinks[i]);
			j++;
		}
	*/

	/////////////////////////////////////
	//  M E N U   G E N E R A T I O N  //
	/////////////////////////////////////	

	var cols = 6;
	
	var s = "\r\n<table cellspacing=4 cellpadding=0 border=0><tr>";

	for (j = 0; j<(permDATA.length/4); j+=cols )
	{
		for(i=j;i<(j+cols);i++)
			if (i<(permDATA.length/4))
				//if (permDATA[i*4+2].substring(0,1)!="*")
					s += "<td align=center width=110 height=110 valign=top>"+sbox("<a href="+permDATA[i*4+3]+"><img src=../blackbaby/images/img0000001313_"+zerofill(permDATA[i*4],6)+"_004_0.jpg height=100 width=100 border=0></a>",100)+"<font face=verdana size=2>"+permDATA[i*4+1]+"</font></td>";
				//else
				//	s += "<td align=center width=110 height=110 valign=top>"+sbox(permDATA[i*4+2].substring(1,permDATA[i*4+2].length),100)+"<font face=verdana size=2>"+permDATA[i*4+1]+"</font></td>";
			else
				s += "<td width=110></td>";

			s+= "</tr><tr>";
	}	
	s += "</tr></table>\r\n";

	if (j==0)
		s = ("No permissions defined yet,<br><br>please contact administrator : <a href=mailto:info@thecandidates.com>info@thecandidates.com</a><br><br>click <a href=index.asp>here</a> to go back")

%>

<br>
<center>
<table cellspacing=1 cellpadding=10 bgcolor=black><tr><td bgcolor=white>
<%=s%>
</td></tr></table>
</center>

<br><br><br><br><br>
<br><br><br><br><br>

<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
