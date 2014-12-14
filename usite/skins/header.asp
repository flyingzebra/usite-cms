<!--#INCLUDE FILE = "../includes/URL2.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<!--#INCLUDE file = "../includes/DB.asp" -->
<%

/////////////////////////
//   L A N G U A G E   //
/////////////////////////

if(typeof(_language)!="string")
{
	var _language = _url.substring(0,5);
	var npos = _url.indexOf("/");
	_language = _language.substring(0,npos>=0?npos:4);
}

var npos = _url.indexOf("/");
var _isolanguage = _url.substring(0,2)+(_url.substring(2,npos)?("-"+_url.substring(2,4)):"");
var _page = _url.substring(npos+1,_url.length);
var oRE = new RegExp("[0-9][0-9]_[a-z]");
var m = oRE.exec(_page);
if(m != null)
	var _pagenum	= _page.substring(0,m+2).split("_");

var npos = _page.lastIndexOf(".");
var _pagename = npos>0?_page.substring(0,npos):_page;
var _pageext  = npos>0?_page.substring(npos,_page.length):"";
var _urlpart = _page.substring(0,_page.lastIndexOf("_"));

///////////////////
//  DOMAIN CHECK //
///////////////////

Response.Write("<!-- FORMS "+Request.Form().Item+" -->")

//Response.Write(_host)
if(_language=="frbe" && _host!="chaplin" && _host!="localhost")
		_host = "www.nobel.be";



/////////////////////////////////
//  G E T   F O R M   D A T A  //
/////////////////////////////////


var mode = Request.Form("mode").Item;
if (!mode)
	mode = Request.QueryString("mode").Item;


/////////////////////////////////////
//   S K I N  S E L E C T I O N    //
/////////////////////////////////////

if (typeof(skin_cat)=="undefined")
	var skin_cat = 0;

if (typeof(skin_mode)=="undefined")
	var skin_mode = 1;

//  S K I N   M O D E   0   :  F U L L S C R E E N
//  S K I N   M O D E   1   :  E M P T Y
//  S K I N   M O D E   2   :  N E W S L E T T E R S

var skin_data = new Array();
skin_data[0] = []
//skin_data[1] = [ "news_1.png","news_2.png","news_3.png","bg_newswall.gif","#CEDFEF","#CEDFEF","","ArtCornerLogo.gif","treebar_corner.gif"];
skin_data[1] = [ "gnyph_1.png","gnyph_2.png","gnyph_3.png","bg_newswall.gif","#F4F0ED","#F4F0ED","","gnyph_5.png","treebar_corner.gif"];
skin_data[2] = [ "pray_1.png","pray_2.png","pray_3.png","bg_praywall.gif","#FEFEF8","#CEDFEF","","ArtCornerLogo.gif","treebar_corner.gif"];
skin_data[3] = [ "marj_1.gif","marj_2.gif","marj_3.gif","bg_marjwall.gif","#A3CEE1","#A3CEE1","","marj_5.gif","bg_treebar.gif"];
skin_data[4] = [ "wright_1.png","wright_2.png","wright_3.png","bg_wrightwall.gif","#A3CEE1","#A3CEE1","bg_wrightvertwall.gif","wright_5.png","bg_treebar.gif"];

var modus			= 10;
var skin_session	= Session("skin");
var skin_query		= Request.QueryString("skin").Item;

var skin_session	= skin_session?Number(skin_session):0;
var skin_query		= skin_query?Number(skin_query):0;
var skin_joined		= skin_query?skin_query:skin_session;

var skin_mode		= Math.round(skin_joined/modus);
var skin_basecount	= skin_mode*modus+1;

var skin_joined		= (skin_joined%modus)==0?skin_basecount:skin_joined;
var skinnr			= skin_joined%modus; 

var next_skin		= "href=?skin="+(skinnr<(skin_data.length-1)?(skin_basecount+skinnr):skin_basecount);
Session("skin")		= skinnr;

if(typeof(_basedir)!="string")
	var _basedir = "../";

if(typeof(_title)!="string")
	var _title = "The Art Server";
	
if(typeof(_description)!="string")
	var _description = "Art E-Zine";
	
if(typeof(_description)!="string")
	var _keywords = "kunst,galerie,agenda,kalender,boeken,magazines,interview,muziek,favorieten,oude muziek,klassiek,hedendaags,jazz,wereldmuziek,opera,filmmuziek,lounge,song,cross-over,literatuur,fictie,non-fictie,poëzie,strips,Piron";

if(typeof(_encoding)!="string")
	var _encoding = "ISO-8859-1";
	
if(typeof(_header)!="string")
	var _header = "";
	
if(typeof(_top_menu)!="string")
	var _top_menu = "";
	
if(typeof(_body_width)!="string")
	var _body_width = 545;

if(typeof(_rightbanner_width)!="string")
	var _rightbanner_width = 220;
	
if(typeof(_rsspath)!="string")
	var _rsspath = "http://www.theartserver.be/theartserver/"+_language+"/";

///////////////////////////
//  N E W S L E T T E R  //
///////////////////////////



var news = [_basedir+"scripts/subscribe.asp?page=../blogger/"+_language+"/"
			,_T["free_newsletter"]
			,_T["email_address"]
			,_T["newsletter_activated"]
			,_T["subscribe"]
			,_T["email_fill_in"]
			,_T["done"]];




//////////////////////////////////////////////////////////////
//                                                          //
//   G E N E R A T E   B A N N E R S						//
//                                                         //
/////////////////////////////////////////////////////////////


function _bigbanner()
{
var rnd = Math.round(Math.random()*1);

	switch(rnd)
	{
		/*
		case 0:
		%>
			<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://active.macromedia.com/flash4/cabs/swflash.cab#version=4,0,0,0" id="Delmotte" width="550" height="86" VIEWASTEXT>
			  <param name="movie" value="<%=_basedir%>images/ads/Delmotte_550.swf">
			  <param name="quality" value="high">
			  <param name="bgcolor" value="#000000">
			  <embed name="Delmotte" src="<%=_basedir%>images/ads/Delmotte_550.swf" quality="high" bgcolor="#000000" width="550" height="86" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
			</object>
		<%
		break;
		*/
		case 0:
		%><a href="http://www.lebercail.com/" target="_blank"><img SRC="<%=_basedir%>images/ads/lebercail_550.gif" WIDTH="550" HEIGHT="86" border="0"></a><%
		break;
		case 1:
			switch(_language)
			{
				case "enuk":
				case "en":
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=eng" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
				case "nlbe":
				case "nl":
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=nl" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
				case "frbe":
				case "fr":
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=fr" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
				case "de":
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=dui" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
				case "es":
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=spa" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
				default:
				%><a href="http://www.classic-art-house.be/setcookie.php?lang=eng" target="_blank"><img SRC="<%=_basedir%>images/ads/classic-art-house_550.gif" border="0" WIDTH="550" HEIGHT="86"></a><%
				break;
			}
	}


}

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
	<title><%=_title%></title>
	<meta NAME="description" content="<%=_description%>">
	<meta NAME="keywords" content="<%=_keywords%>">
	<meta NAME="author" content="Freddy Vandriessche">
	<meta HTTP-EQUIV="Content-Language" content="<%=_language%>">
	<meta HTTP-EQUIV="Content-Type" content="text/html; charset=<%=_encoding%>">
	<meta name="ICBM" content="51.22166, 4.40861">
	<meta name="DC.title" content="<%=_title%>">
	<meta name="geo.position" content="51.22166;4.40861">
	<meta name="geo.country" content="BE"> 
	<meta name="geo.region" content="BE-VAN">
	<meta name="geo.placename" content="Antwerpen">
    <link rel="stylesheet" href="../includes/style.css" type="text/css">
    <BASE HREF="http://<%=_host%>/theartserver/<%=_language%>/<%=_page%>">

	<%=_header%>
</head>
<body bgcolor="black" leftmargin="0" topmargin="0" bottommargin="0">
<a name="top"></a>

<!--object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://active.macromedia.com/flash4/cabs/swflash.cab#version=4,0,0,0" id="TheArtServer_topbar" width="1060" height="250" VIEWASTEXT>  <param name="movie" value="<%=_basedir%>images/ads/TheArtServer_topbar_train.swf">  <param name="quality" value="high">  <param name="bgcolor" value="#000000">  <embed name="TheArtServer_topbar" src="<%=_basedir%>images/ads/TheArtServer_topbar_train.swf" quality="high" bgcolor="#000000" width="1060" height="250" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></object-->
<%
if(_urlpart.substring(0,2) == "02")
{
%>
<IMG SRC="../images/skins/nobel_coolw_1060_200.jpg" width=1060 height=200><br>
<IMG SRC="../images/skins/nobel_coolw_1060_50.gif" width=1060 height=50><br>
<%
}
else
{
%>
<!--table cellspacing=0 cellpadding=0>
<tr><td colspan=3><IMG SRC="../images/skins/nobel_f_uppererpartlogo_1060_152.jpg"></td></tr>
<tr>
	<td><IMG SRC="../images/skins/nobel_f_lowerpart_235_98.jpg"></td>
	<td><img SRC="../images/skins/nobel_f_lowerpart_338_98.jpg" WIDTH="338" HEIGHT="98"></td>
	<td><img SRC="../images/skins/nobel_f_lowerpart_487_98.jpg" WIDTH="487" HEIGHT="98"></td>
</tr>
</table-->

<IMG SRC="../images/skins/nobel_birds_1060_200.jpg" width=1060 height=200><br>
<IMG SRC="../images/skins/nobel_birds_1060_50.gif" width=1060 height=50><br>

<!--IMG SRC="../images/skins/nobel_etincelles_1060_250.jpg" width=1060 height=250><br-->
<%
}
%>





<!--object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
   codebase="http://active.macromedia.com/flash4/cabs/swflash.cab#version=4,0,0,0"
  id="kunstenaars_n_galerijen" width="338" height="98">
  <param name="movie" value="../images/ads/kunstenaars_f_galerijen.swf">
  <param name="quality" value="high">
  <param name="bgcolor" value="#000000">
  <embed name="kunstenaars_n_galerijen" src="../images/ads/kunstenaars_f_galerijen.swf" quality="high" bgcolor="#000000"
    width="338" height="98"
    type="application/x-shockwave-flash"
    pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash">
  </embed>
</object-->


<%
	var _oGUI	= new GUI();	
	var _oDB		= new DB();		// database object from DB.asp
	_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	_oDB.getSettings(_oDB.oCO.ConnectString);
%>

<table bgcolor="white" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top"> 
	
	<%
		var panewidth = 220;
		var paneheight = 600;
		var batchpath = "../images/batch/";
		var iiconspath = "../images/";
								
		_oGUI.NBOX.lm = 48;
		_oGUI.NBOX.rm = 186;
		_oGUI.NBOX.tw = _oGUI.NBOX.lm + _oGUI.NBOX.rm + 1;
		_oGUI.NBOX.titlewidth = 240;
		_oGUI.NBOX.bTail = false;
		_oGUI.NBOX.leftcaddy = true;
		_oGUI.NBOX.rightcaddy = false;
	%>

	<%
		_oGUI.NBOX.dottedline = false;
		_oGUI.NBOX.openbody   = true;
		_oGUI.NBOX.lineheight = 33;
	%>
	
	<%		// S E A R C H	
		var checkit = "";
		var search =
		"<form method=get action=06_00_index.asp name=search>"
		+"<input class=border name=s style=width:140px;height:20px>"
		+"<input type=submit style=font-size:10px;height:20px value='"+_T["OK"]+"' onclick=\""+checkit+"\"><table><tr><td></form></td></tr></table>";

		_oGUI.NBOX.add(_T["search"],search);
		_oGUI.NBOX.add("","");
	%>
	
	<%=_oGUI.NBOX.get("","","")%>

	<%
		_oGUI.NBOX.dottedline = true;
		_oGUI.NBOX.openbody   = false;
		_oGUI.NBOX.lineheight = 12;
	%>

	<%	
if(_urlpart.substring(0,2) == "02")
{
%>
				    
	<%// COUP DE COEUR, COUP DE GUEULE%>
	
	<%_oGUI.NBOX.bTitleShadow = false;%>
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["heartbreaker"]+".png","02_05_index.asp",_T["heartbreaker_tip"])%>

	<%
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 17 and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  //var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "02_05_index.asp#"+base64encode(overview[j].toString());
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=02_05_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = ""; //"<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=02_05_index.asp>cliquez ici</a>");
  	  //_oGUI.NBOX.add("",more)
	%>
	<%_oGUI.NBOX.bTitleShadow = true;%>
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["tonguepuller"]+".png","02_05_index.asp",_T["tonguepuller_tip"])%>
	



				    
	<%		// COURRIER		 
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 18 and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  //var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "02_06_index.asp#"+base64encode(overview[j].toString()); //"02_06_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=02_06_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = ""; //"<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=02_06_index.asp>cliquez ici</a>");
  	  //_oGUI.NBOX.add("",more)
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["posts"]+".png","02_06_index.asp",_T["posts_tip"])%>	


	<%		// CARTE BLANCHE	 
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 19 and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  //var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "02_07_index.asp#"+base64encode(overview[j].toString()); //"02_07_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=02_07_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = ""; //"<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=02_07_index.asp>cliquez ici</a>");
  	  //_oGUI.NBOX.add("",more)
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["wildcard"]+".png","02_07_index.asp",_T["wildcard_tip"])%>	


	<%		// ART MARKET & COLLECTIONS  %>
	<%_oGUI.NBOX.bTitleShadow = false;%>
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["artmarket"]+".png","02_08_index.asp",_T["artmarket_tip"])%>
	
	<%	 
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 19 and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  //var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "02_08_index.asp#"+base64encode(overview[j].toString()); //"02_08_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=02_08_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = ""; //"<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=02_08_index.asp>cliquez ici</a>");
  	  //_oGUI.NBOX.add("",more)
	%>
	

	<%_oGUI.NBOX.bTitleShadow = true;%>
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["collections"]+".png","02_08_index.asp",_T["collections_tip"])%>	


	<%		// FAVORIS	 
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 9 and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  //var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "02_09_index.asp#"+base64encode(overview[j].toString()); //"09_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=02_09_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],09)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = ""; //"<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=02_09_index.asp>cliquez ici</a>");
  	  //_oGUI.NBOX.add("",more)
	%>
	
	<%_oGUI.NBOX.bTail = true;%>
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["favorites"]+".png","02_09_index.asp",_T["favorites_tip"])%>	


	
<%
}
else
{
	%>

	<%		// N I E U W S B R I E F
	  var checkit = "if (document.subscribe('e-mail').value && document.subscribe('e-mail').value.indexOf('@')>0 && document.subscribe('e-mail').value.indexOf('.')>0) document.subscribe.submit(); else alert('"+_T["email_fillin"]+"')";
	  
	  var newsletter =
	  "<form method=post action="+_T["newsletter_url_submit"]+" name=subscribe>"
      +_T["email_fillin"]
      +"<input type=hidden name=language value="+_language+">"
      +(Request.QueryString("p").Item=="1"?("<br><b>"+_T["newsletter_activated"]+"</b>&nbsp;&nbsp;"):"")
      +"<input class=border name=e-mail style=width:140px;height:20px>"
	  +"<input type=button style=font-size:10px;height:20px value='"+_T["OK"]+"' onclick=\""+checkit+"\"><table><tr><td></form></td></tr></table>"+_T["newsletter_free"];
		
	  _oGUI.NBOX.add("",newsletter);
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["free_newsletter"]+".png","11_index.asp",_T["free_newsletter_tip"])%>
	    						    
	<%		// P E R S B E R I C H T E N		 
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_actimg","rev_pub","rev_date_published","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,6";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"press where (rev_pub & 1) = 1 "+/*"and rev_rt_typ = 10 "+*/ "and rev_rt_cat < 1 and rev_date_published < SYSDATE() "+extraSQL;
	  var overview = _oDB.getrows( SQL );
	  var _news = overview;
	  var _news_tablefld = tablefld;
	  
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "10_index.asp#"+base64encode(overview[j].toString());//"10_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;	
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";
		var fromto = "<p class=footnote align=right>";
		if (typeof(overview[j+7])=="date")				
			fromto +=   new Date(overview[j+7]).format("%H:%M",_isolanguage)+ "<br><span style=color:#A0B5BF>"+new Date(overview[j+7]).format("%d&nbsp;%b",_isolanguage)+"</span>";	
		fromto += "</p>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""			
		var txt =  "<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>";
						
		_oGUI.NBOX.add(fromto,imgurl+link+txt)	
	  }
	  var morexml = "<a href=\""+_rsspath+"xml/00_03_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\"RSS 2.0\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	  var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_pressreport"]+"\">"+_T["send_pressreport"]+"</a></td><td>"+morexml+"</td></tr></table>";
  	  
  	  _oGUI.NBOX.add("","pour la liste complète:<br>&nbsp;<a href=10_index.asp>cliquez ici</a>");
  	  _oGUI.NBOX.add("",more)
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["press"]+".png","10_index.asp",_T["press_tip"])%>
			
	<%		// A G E N D A
	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_from","rev_to","rev_from > now() as future","rev_header","rev_actimg","rev_pub");		
	var extraSQL = "order by rev_id desc LIMIT 0,6";
		
	/*
	if ((cm & 2) == 2)
	{
		var dayfr = new Date();
		var dayto = new Date(dayfr);
		dayto.setDate(dayto.getDate()+1);
		var fr = dayfr.format("%Y-%m-%d");
		var to =dayto.format("%Y-%m-%d");
		extraSQL =" or ('"+fr+"' between rev_from and rev_to) or ('"+to+"' between rev_from and rev_to) or (rev_from between '"+fr+"' and '"+to+"') or (rev_to between '"+fr+"' and '"+to+"') order by rev_from" 
	}
	*/
		
	var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 4 and rev_to > DATE_SUB(SYSDATE(), INTERVAL 1 DAY) "+extraSQL+" ";
	var overview = _oDB.getrows( SQL );		
	var r = 0;
	
	var _agenda = overview;
	var _agenda_tablefld = tablefld;
		
	for (var j=0; j<overview.length;j+=tablefld.length)
	{
		//var relurl = "04_detail.asp?id="+overview[j].toString().encrypt("nicnac");
		var relurl = "04_detail_Q_id_E_"+overview[j].toString().encrypt("nicnac")+".asp";
	
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;
		var link = "";//<a href="+relurl+"><img src=\"../images/rnav3.gif\" align=\"right\" border=\"0\" onmouseover=\"this.src='../images/rnav3_over.gif';\" onmouseout=\"this.src='../images/rnav3.gif'\" title=\""+overview[j+2]+"\"></a>";
		var imgurl = "";//<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src='../images/agenda/img"+zerofill(overview[j],10)+"_1.jpg' border=0 width=12 height=12 align=\"right\" onmouseover=this.width=50;this.height=50;return; onmouseout=this.width=10;this.height=10;return;></a>";

		var fromto = "<table cellspacing=0 cellpadding=0 align=right><tr><td align=left class=small>";
		var bFuture = overview[j+5]=="1";
		if (typeof(overview[j+3])=="date")
		{
			fromto += new Date(overview[j+3]).format("%d&nbsp;%b",_isolanguage);
			var yfrom = new Date(overview[j+3]).format("%Y");
			var yto = "";
			var ynow = new Date().format("%Y");
			if (typeof(overview[j+4])=="date")
				if (new Date(overview[j+3]).format("%d%m%Y") != new Date(overview[j+4]).format("%d%m%Y"))
				{
					fromto += "<br><span style=color:#A0B5BF>"+new Date(overview[j+4]).format("%d&nbsp;%b",_isolanguage)+"</span>";
					yto = new Date(overview[j+4]).format("%Y");
				}
				//if (  ynow != yfrom || yto && ynow != yto)
				//	fromto += " <br>" + yfrom +"<span style=color:#A0B5BF>"+( (yto && yfrom!=yto)?("<br>"+yto):"" ) + "</span>";
		}
		fromto += "</td></tr></table>";
			
		//_oGUI.NBOX.add(fromto,(overview[j+3]+" &nbsp; <span style=color:#800000>"+overview[j+4]).substring(0,175)+"</span>");
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""
		var txt =  bFuture?("<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>"):("<a class=smallgreen href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>");
		_oGUI.NBOX.add(fromto,imgurl+link+txt)
	}
		
	//var imgnr = (cm & 2) == 2 ? 5 : 4;
	//var title = (cm & 2) == 2 ? "minder ..." : "meer ...";
	//var legend = "<img src=\"../images/ii_legende.gif\" border=\"0\" align=\"left\" hspace=10>";
	//var link = "<a href=\""+( (cm ^ 2)==0?"00_index.asp":("?cm="+(cm ^ 2) ) ) +"\"><img src=\"../images/rnav"+imgnr+"_over.gif\" align=\"left\" border=\"0\" onmouseover=\"this.src='../images/rnav"+imgnr+".gif';\" onmouseout=\"this.src='../images/rnav"+imgnr+"_over.gif'\" title=\""+title+"\"></a>";
	//link += "<a href=04_detail.asp?id="+overview[j].toString().encrypt("nicnac")+"><img src=\"../images/rnav4.gif\" align=\"left\" border=\"0\" onmouseover=\"this.src='../images/rnav4_over.gif';\" onmouseout=\"this.src='../images/rnav4.gif'\" title=\"meer ...\"></a>";
		
	//var mainlink = "<a href=\"04_index.asp\"><img src=\"../images/rnav4_tag.gif\" border=\"0\" title=\"agenda actueel\"></a>";
	
	var morexml = "<a href=\""+_rsspath+"xml/00_01_rss20.xml\" target=_blank><img src=\"../images/ii_xml.gif\" border=\"0\" title=\""+_T["mainRSS"]+"\" hspace=5></a><a href=\"00_RSS.asp\"><img src=\"../images/ii_xml_feeds.gif\" border=\"0\" title=\""+_T["otherRSS"]+"\"></a>";
	var more = "<table align=right><tr><td class=footnote><a href=\"mailto:"+_T["email_agendareport"]+"\">"+_T["send_agendareport"]+"</a></td><td>"+morexml+"</td></tr></table>";	
	
	_oGUI.NBOX.add("","pour l'agenda complet:<br>&nbsp;<a href=04_index.asp>cliquez ici</a>");
	_oGUI.NBOX.add("",more)
	%>

	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["agenda"]+".png","04_index.asp",_T["agenda_tip"])%>		


	<%		// A R T I C L E S	
	   
	   
	  var iimagecats = [133,"ii_artist.gif","artistes",114,"ii_articles.gif","articles"];
	  var iimages    = new Array();
	  for(var i=0;i<iimagecats.length;i+=3)
		iimages[iimagecats[i]] = i;
	      
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_date_published","rev_rt_cat","rev_header");
	  var extraSQL = "order by RAND() LIMIT 0,5";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and rev_rt_typ = 2 "+extraSQL;
	  //Response.Write(SQL);
	  //Response.Flush();
	  var overview = _oDB.getrows( SQL );
	      
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var relurl = "06_02_detail_Q_id_E_"+overview[j].toString().encrypt("nicnac")+".asp";
	
		var linkurl = "http://www.nobel.be/theartserver/"+_language+"/"+relurl;
		var link = "";
		var imgurl = "";


		margintxt = "<img src=../images/"+iimagecats[ iimages[Number(overview[j+4])] + 1 ]+" title=\""+ iimagecats[ iimages[Number(overview[j+4])] + 2 ] +"\" border=0>";
		
		var txt =  overview[j+1]?overview[j+1].substring(0,85):""
		var txt =  bFuture?("<a class=small href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>"):("<a class=smallgreen href=\""+relurl+"\" title=\""+overview[j+2]+"\">"+txt+"</a>");
		
		//var txt =  overview[j+5]?("<table cellspacing=0 cellpadding=0><tr><td class=footnote><b>\""+overview[j+5]+"\"</b></td></tr><tr><td class=footnote align=right>"+overview[j+4]+"</td></tr></table>"):"";			
		_oGUI.NBOX.add(margintxt,txt);
	  }
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["articles"]+".png","02_index.asp",_T["articles_tip"])%>

	<%		// C I T A T I O N
	      
	  var tablefld = new Array("rev_id","rev_title","rev_desc","rev_date_published","rev_author","rev_header");
	  var extraSQL = "order by rev_date_published desc LIMIT 0,1";
	  var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"press where (rev_pub & 1) = 1 "+/*"and rev_rt_typ = 10 "+*/ "and rev_rt_cat = 132 and rev_date_published < SYSDATE() "+extraSQL;
	  //Response.Write(SQL);
	  //Response.Flush();
	  var overview = _oDB.getrows( SQL );
	      
	  var r = 0;
	  for (var j=0; j<overview.length;j+=tablefld.length)
	  {
		var fromto = "";
		if (typeof(overview[j+3])=="date")				
			fromto += "<span class=footnote><b>" + new Date(overview[j+3]).format("%d %b",_isolanguage)+ "</b> " +  new Date(overview[j+3]).format("%H:%M",_isolanguage)+ "</span>";	
		var txt =  overview[j+5]?("<table cellspacing=0 cellpadding=0><tr><td class=footnote><b>\""+overview[j+5]+"\"</b></td></tr><tr><td class=footnote align=right>"+overview[j+4]+"</td></tr></table>"):"";			
		_oGUI.NBOX.add(fromto,txt);
	  }
	  
	  if(mode=="login")
		_oGUI.NBOX.bTail = false;
	  else
		_oGUI.NBOX.bTail = true;
	  //_oGUI.NBOX.leftcaddy = true;	
	%>
	
	<%=_oGUI.NBOX.get(batchpath+"t24_"+_T["quote"]+".png","10_quotes.asp",_T["quote_tip"])%>

<%
}
%>



	<a name="login"></a>
		
	<%		// L O G I N

		_oGUI.NBOX.bTail = true;

	var login = "<form name=login method=post action=../admin/validate.asp><table height=100 width=100 cellspacing=2 cellpadding=3>"
		+"<tr><td width=100 style=font-family:verdana;font-size:13px>log</td><td><input size=6 type=text name=log maxlength=12></td></tr>"
		+"<tr><td width=100 style=font-family:verdana;font-size:13px>psw</td><td><input size=6 type=password name=pwd maxlength=12></td></tr>"
		+"<tr><td></td><td><input type=hidden name=lng value="+_language+"><input type=submit value=login></td></tr>"
	+"</table></form>"

		_oGUI.NBOX.add("",login);
			
		if(mode=="login")
			Response.Write(_oGUI.NBOX.get(batchpath+"t24_"+_T["login"]+".png","",_T["login_tip"]) );
		else
			Response.Write("<a href=\"?mode=login#login\"><img src=\"../images/spc.gif\" width=\""+panewidth+"\" height=\"20\" border=\"0\"></a>");
	%>
	
	</td>
	<td valign="top">
		<!-- M E N U   B A R -->
		<!--table cellspacing="0" cellpadding="0" border="0">		<tr height=<%=6%>><td WIDTH="545"><img SRC="../images/nbox1.gif" WIDTH="545" HEIGHT="6" border=0></td></tr>		<tr height=<%=40-6-1%>><td bgcolor=#F7F3EF></td></tr>		<tr height=<%=1%>><td bgcolor=#BDBABD></td></tr>		</table-->
		
		
		<%
					var _tabmenu  = ["home","agenda","artistes","Art E-Zine","contact"];
					var _tablink  = ["00_index","04_index","06_index","02_index","12_index"];
					var _tabalias = ["00_index"
									,"04_detail,04_01_index,04_02_index,04_03_index,04_04_index,04_05_index"
									,"06_00_index,06_01_index,06_01_detail"
									,"02_index,02_detail,02_01_index,02_02_index,02_03_index,02_04_index"
									,"12_index"
								  ]
						
					// indexing page names
					var _tab_index = new Array();
					for(var i=(_tabmenu.length-1);i>=0;i--)
					{
						_tab_index[_tablink[i]] = i;
						
						// ALSO INDEX EQUIVALENTS
						var equivalent = _tabalias[i].split(",");
						for(var j=0; j<equivalent.length;j++)
							_tab_index[equivalent[j]] = i;
					}
					var _tab_selected = _tab_index[_pagename];
					
					for(var i=(_tablink.length-1);i>=0;i--)
						_tablink[i] += ".asp";
		%>
	
		
		<table cellspacing="0" cellpadding="0" border="0" width="545" bgcolor="#F4F0ED">
		<tr height="<%=6%>"><td WIDTH="545" colspan="2"><img SRC="../images/nbox1.gif" WIDTH="545" HEIGHT="6" border="0"></td></tr>
		<tr height="<%=16%>"><td style="font-size:60%;font-family:Verdana" colspan="2" valign="top"><img src="../images/spc.gif" width="1" height="1">
		 
		 <!--
		 [<a href="00_index.asp" style="text-decoration:none">home</a>
		 <% if(_tab_selected>0)
		 {
		 %>
			&gt;&gt; <a href="<%=_tablink[_tab_selected]%>" style="text-decoration:none"><%=_tabmenu[_tab_selected]%></a>
		 <%
		 }
		 %>]
		 -->
		 </td></tr>
		<tr height="<%=18%>">
			<td>
				<table cellspacing="0" cellpadding="0" height="<%=18%>" class="tab"><tr>
				<%					
					for(var i=0;i<_tabmenu.length;i++)
					{
						var bon      = i==_tab_selected;
						var bprevon  = (i-1)==_tab_selected;
						var bfirst   = i==0;
						var blast    = i==(_tabmenu.length-1);
							
						var link1 = "";
						var link2 = "</a>";
						if(_tablink[i])
							link1 = "<a href="+_tablink[i]+" style=text-decoration:none>";
						else
							link2 = "";
							
						if(bfirst)
							Response.Write("<td><img src=../images/"+(bon?"tab_first_on.gif":"tab_first_off.gif")+" width=19 height=18></td>");
						else if(bprevon)
							Response.Write("<td><img src=../images/tab_prev_on.gif width=19 height=18></td>");
						else
							Response.Write("<td><img src=../images/"+(bon?"tab_next_on.gif":"tab_both_off.gif")+" width=19 height=18></td>");
		
						Response.Write("<td background=../images/"+(bon?"tab_body_on.gif":"tab_body_off.gif")+">"+link1+_tabmenu[i]+link2+"&nbsp;</td>");
							
						if(blast)
							Response.Write("<td><img src=../images/"+(bon?"tab_last_on.gif":"tab_last_off.gif")+" width=4 height=18></td>");
							
					}
				%>
				</tr>
				</table>
			</td>
			<td>
				<table cellspacing="0" cellpadding="0" width="1">
				<tr height="17">
					<td></td>
				</tr>
				<tr height="1">
					<td bgcolor="#BDBABD"><img src="../images/spc.gif" WIDTH="1" HEIGHT="1"></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	
		
		<!-- B O D Y -->
		
		<table cellspacing="0" cellpadding="0" border="0" width="545">
		<tr><td><img src="../images/spacer.gif" width="1" height="2"></td></tr>
		<tr>
			<td>
				<!-- I C O N S -->
				<table cellspacing="0" cellpadding="0" border="0" width="100">
				<tr>
					<td>
					<%
						_oGUI.ICON.url = _page;			
						switch(_urlpart.substring(0,2))
						{
							case "02":
								_oGUI.ICON.add("../images/i_march2005.gif","02_index.asp",_T["artezine"],_T["artezine"]);
								_oGUI.ICON.add("../images/i_gardenwindow.gif","02_01_index.asp",_T["report"],_T["report"]);
								_oGUI.ICON.add("../images/i_discoveries.gif","02_02_index.asp",_T["discoveries"],_T["discoveries"]);
								_oGUI.ICON.add("../images/i_interviewchair.gif","02_03_index.asp",_T["interview"],_T["interview"]);
								_oGUI.ICON.add("../images/i_toaster.gif","02_04_index.asp",_T["file"],_T["file"]);
								break;
							case "12":
							case "00":
							case "01":
							case "03":
								_oGUI.ICON.add("../images/i_home.gif","00_index.asp",_T["home"],_T["home"]);
								_oGUI.ICON.add("../images/i_tha.gif","04_index.asp",_T["agenda"],_T["agenda"]);
								_oGUI.ICON.add("../images/i_artistpiron.gif","06_index.asp",_T["artists"],_T["artists"]);
								_oGUI.ICON.add("../images/i_march2005.gif","02_index.asp",_T["artezine"],_T["artezine"]);
								_oGUI.ICON.add("../images/i_world.gif","12_index.asp",_T["contact"],_T["contact"]);
								//_oGUI.ICON.add("../images/i_addressbook.gif","04_index.asp",_T["addressbook"],_T["addressbook"]);
								//_oGUI.ICON.add("../images/i_shopping.gif","05_index.asp",_T["shop"],_T["shop"]);
							break;
							case "06":
								//_oGUI.ICON.add("../images/i_piron.gif","06_index.asp",_T["piron"],_T["piron"]);
								//_oGUI.ICON.add("../images/i_gallery.gif","06_01_index.asp",_T["gallery"],_T["gallery"]);
								//_oGUI.ICON.add("../images/i_artists.gif","06_02_index.asp",_T["articles"],_T["articles"]);
							break;
							case "04":
								_oGUI.ICON.add("../images/i_agenda.gif","04_index.asp",_T["agenda_actual"],_T["agenda_actual"]);
								_oGUI.ICON.add("../images/i_tha.gif","04_01_index.asp",_T["agenda_coming"],_T["agenda_coming"]);
								_oGUI.ICON.add("../images/i_cultuurplanner.gif","04_02_index.asp",_T["agenda_date"],_T["agenda_cultureplanner"]);
								_oGUI.ICON.add("../images/i_appointment.gif","04_03_index.asp",_T["agenda_calendar"],_T["agenda_calendar"]);
								_oGUI.ICON.add("../images/i_firework.gif","04_04_index.asp",_T["agenda_overview"],_T["agenda_overview"]);
							break;
						}
					%>
					<%=_oGUI.ICON.get()%>
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>


