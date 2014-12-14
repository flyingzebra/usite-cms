var header_html = "<!DOCTYPE html>"
+"<html lang=\"en\">\r\n"
+"  <head>\r\n"
+"    <meta charset=\"utf-8\">\r\n"
+"    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\r\n"
+"    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\r\n"
+"  </head>\r\n";
+"<body style='padding-left:20px'>\r\n";


var footer_html = "    <!--[if lt IE 9]>\r\n"
+"    <script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script>\r\n"
+"    <script src=\"https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js\"></script>\r\n"
+"    <![endif]-->\r\n"
+"</body>\r\n"

var bootstrap_css = "<link rel=\"stylesheet\" href=\"../"+_ws+"/lib/bootstrap.min.css\">\r\n"
+"<!-- Optional theme -->\r\n"
+"<link rel=\"stylesheet\" href=\"http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css\">\r\n"
+"<!-- Latest compiled and minified JavaScript -->\r\n"
+"<"+"script src=\"../"+_ws+"/lib/bootstrap.min.js\"></script>\r\n"


var extra_css = "<style>\r\n"
+"#container {\r\n"
+"    margin-top: 5px;\r\n"
+"    box-shadow: 0px 0px 20px gray;\r\n"
+"    padding: 0px 0px 0px 0px;\r\n"
+"    background-color:#CCCCCC;\r\n"
+"}\r\n"

+"html {\r\n"
+"	padding: 30px 10px;\r\n"
+"	font-size: 20px;\r\n"
+"	line-height: 1.4;\r\n"
+"	color: #737373;\r\n"
+"	background: #f0f0f0;\r\n"
+"	-webkit-text-size-adjust: 100%;\r\n"
+"	-ms-text-size-adjust: 100%;\r\n"
+"}\r\n"

+"body {\r\n"
+"	max-width: 800px;\r\n"
+"	_width: 780px;\r\n"
+"	padding: 0px 20px 20px;\r\n"
+"	border: 1px solid #b3b3b3;\r\n"
+"	border-radius: 4px;\r\n"
+"	margin: 0 auto;\r\n"
+"	box-shadow: 0 1px 10px #a7a7a7, inset 0 1px 0 #fff;\r\n"
+"	background: #fcfcfc;\r\n"
+"	}\r\n"

+".boxcontainer {\r\n"
+"	max-width: 920px;\r\n"
+"	_width: 720px;\r\n"
+"	margin: 0 auto;\r\n"
+"}"




+"</style>\r\n";

var wrap_top = "<center>"
+"<a href=link_activate.asp?v="+(Session("uid")+","+Session("dir")+",").toString().encrypt("nicnac")+"><img src=../images/icon_menu.png></a>"
+"<a href=../"+_dir.split("_")[0]+"/index.asp><img src=../images/icon_web.png></a>"
+"<a href=logoff.asp?adminurl=index.asp><img src=../images/icon_logoff.png></a>"
+"</center>"
+"<div class=\"boxcontainer\">";
var wrap_bottom = "</div>";











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
		topic[j] 	= permDATA[i+2];
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
        var mode = "bootstrap";
	var el = new Array();

        switch(mode)
        {
           case "table":
              el[0] = "<table cellspacing=4 cellpadding=0 border=0><tr>";
              el[1] = "\r\n<td align=center width=110 height=110 valign=top>";
              el[2] = "";
              el[3] = "<br>";
              el[4] = "</td>\r\n";
              el[5] = "<td width=110></td>";
              el[6] = "</tr><tr>";
              el[7] = "</tr></table>\r\n";
           break;

           case "bootstrap":
              cols = 999;  // override
              el[0] = "<div class=\"row\">";
              el[1] = "\r\n<div class=\"col-xs-2 col-sm-2 col-md-2\" style=\"width:130px;height:150px;background-color:white\">";   // col-xs-2 col-sm-2 col-md-2
              el[2] = "<div id=container style=\"width:100px\">";
              el[3] = "</div>";
              el[4] = "</div>\r\n";
              el[5] = "";
              el[6] = "</div><div class=\"row\">";
              el[7] = "</div>\r\n";
           break;

           case "clean":
              el[0] = "\r\n";
              el[1] = "";
              el[2] = "<div id=container style=\"width:100px\">";
              el[3] = "</div>\r\n";
              el[4] = "\r\n";
              el[5] = "";
              el[6] = "";
              el[7] = "";
           break;

        }

	var s = el[0]

	for (j = 0; j<(permDATA.length/4); j+=cols )
	{
		for(i=j;i<(j+cols);i++)
			if (i<(permDATA.length/4))
				//if (permDATA[i*4+2].substring(0,1)!="*")
					s += el[1]

+el[2]
+"<a href="+permDATA[i*4+3]+">"

/*
+"<div style=\"border: 2px solid black;"
+"            border-radius: 30px;"
+"            -moz-border-radius: 30px;"
+"            -khtml-border-radius: 30px;"
+"            -webkit-border-radius: 30px;"
+"            width: 100px;"
+"            height: 100px;"
+"            background: url('../blackbaby/images/img0000001313_"+zerofill(permDATA[i*4],6)+"_004_0.jpg');\" /></div>"
*/


+"<img src=\"../blackbaby/images/img0000001313_"+zerofill(permDATA[i*4],6)+"_004_0.jpg\"  class=\"img-rounded\">"

+"</a>"



+el[3]

+"<font face=Arial size=2>"+permDATA[i*4+1]+"</font>"
+el[4];

			else
				s += el[5]

			s+= el[6]
	}	
	s += el[7];

	if (j==0)
		s = ("No permissions defined yet,<br><br>please contact administrator : <a href=mailto:info@thecandidates.com>info@thecandidates.com</a><br><br>click <a href=index.asp>here</a> to go back")


Response.Write(header_html + bootstrap_css + extra_css + wrap_top +s + wrap_bottom + footer_html);

