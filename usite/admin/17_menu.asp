<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));

	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");

	var topics		= ["i_availabilities.gif"   ,"i_stat.gif"		];
	var topicnames	= ["17_admin"               ,"06_reports"			];
	var topictitles = ["availabilities<br>admin","review-size<br>statistics"	];
	var menulinks	= ["17_01_admin.asp"        ,"06_01_reports.asp"		];
	var topic		= new Array();
	var topicname	= new Array();
	var menulink	= new Array();

	/////////////////////////////////////////
	//  C H E C K   P E R M I S S I O N S  //
	/////////////////////////////////////////	

	var perm = ","+oDB.getrows("select s_value from "+_db_prefix+"settings where s_name='PERM' and s_acc_id="+Session("uid")).join(",")+","
	//Response.Write("select s_value from "+_db_prefix+"settings where s_name='PERM' and s_acc_id="+Session("uid")+"<br>")
	//Response.Write(perm)
	var j=0;
	for(i=0;i<topics.length;i++)
		if (perm.indexOf(topicnames[i])>=0)
		{
			topic[j] = new String(topics[i]);	
			topicname[j] = new String(topictitles[i]);
			menulink[j] = new String(menulinks[i]);
			j++;
		}


	/////////////////////////////////////
	//  M E N U   G E N E R A T I O N  //
	/////////////////////////////////////	
	
	var s = "\r\n<table cellspacing=4 cellpadding=0 border=0><tr>";

	for (j = 0; j<topic.length; j+=5 )
	{
		for(i=j;i<(j+5);i++)
			if (i<topic.length)
				if (topic[i].substring(0,1)!="*")
					s += "<td align=center width=110 height=110 valign=top>"+sbox("<a href="+menulink[i]+"><img src=../images/"+topic[i]+" height=100 width=100 border=0></a>")+"<font face=verdana size=2>"+topicname[i]+"</font></td>";
				else
					s += "<td align=center width=110 height=110 valign=top>"+sbox(topic[i].substring(1,topic[i].length))+"<font face=verdana size=2>"+topicname[i]+"</font></td>";
			else
				s += "<td width=110></td>";

			s+= "</tr><tr>";
	}	
	s += "</tr></table>\r\n";

	if (j==0)
		s = ("No permissions defined yet,<br><br>please contact administrator : <a href=mailto:support@theartserver.be>support@theartserver.be</a><br><br>click <a href=index.asp>here</a> to go back")

%>

<br>
<center>
<table cellspacing=1 cellpadding=10 bgcolor=black><tr><td bgcolor=white>
<%=s%>
</td></tr></table>
</center>

<br><br><br><br><br>
<br><br><br><br><br>
<br><br><br><br><br>
<br><br><br><br><br>

<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
