<!--#INCLUDE FILE = "../includes/URL.asp" -->
<!--#INCLUDE FILE = "../languages/admin.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<!--#INCLUDE FILE = "../includes/USITE_GUI.asp" -->

<%
var mode = "admin";

var _host		= Request.ServerVariables("HTTP_HOST").Item;
var _url		= Request.ServerVariables("URL").Item;

var npos = _url.lastIndexOf("/");
var _page = _url.substring(npos+1,_url.length)

var  npos = _page.lastIndexOf(".");
var _pagename = npos>0?_page.substring(0,npos):_page;
var _pageext  = npos>0?_page.substring(npos,_page.length):"";

var oGUI	= new GUI();
var oSESSION = new oGUI.SESSION();

var menu		= "";
var menus		= new Array();
var menulink	= new Array();
var news		= new Array();
var alt			= new Array();

var skin_mode = 2;
var skin_session = Session("skin")?Session("skin"):0;
var skinnr = Request.QueryString("skin").Item?Number(Request.QueryString("skin").Item):skin_session; 

//next_skin="";

if (skinnr==100)
	skin_mode = 0;
	
skin_cat = skinnr;
Session("skin") = skinnr;

if(typeof(_basedir)!="string")
	var _basedir = "../";

if(typeof(_title)!="string")
	var _title = "µSuite CMS";
	
if(typeof(_title)!="string")
	var _description = "";	

if(typeof(_encoding)!="string")
	var _encoding = "ISO-8859-1";
	
if(typeof(_header)!="string")
	var _header = "";
	
if(typeof(_top_menu)!="string")
	var _top_menu = "";

var _app_db_prefix = "usite_";
var bSplitLanguages  = false;
if(typeof(_db_prefix)!="string")
	var _db_prefix = _app_db_prefix+(bSplitLanguages?(_language+"_"):"");
	
if(typeof(_body_width)=="undefined")
	var _body_width = 545+220;

if(typeof(_rightbanner_width)!="string")
	var _rightbanner_width = 220;

if ( ("<"+Session("uid")+">") == Session("uidcrc") )
{
	menulink[new Number(menulink.length)] = "../admin/menu.asp";
	menus[new Number(menus.length)] = "../images/batch/menu_admin.png";
}

if(typeof(_dir)!="string")
{
	var _session = oSESSION.get("THEARTSERVER_MYSQL_DSNLESS",Request.QueryString("v").Item);
	var _dir = _session["dir"];
}

if(typeof(_dir)!="string")
	var _dir = Session("dir");

if(typeof(_ws)!="string")
	var _ws	= _dir.substring(0,_dir.lastIndexOf("_"));

menu += "<img src=../images/menuSep.gif width=127 height=2><br>\r\n";

for(var i=0;i<menus.length;i++)
	menu += "<a href=../"+_language+"/"+menulink[i]+"><img src="+menus[i]+" width=127 height=11 vspace=7 border=0></a><br>\r\n";
menu += "<img src=../images/menuSep.gif width=127 height=2><br>\r\n";





try
{
	var _sid = Request.QueryString("id").Item;
	if (_sid)
	{
		_id = _sid.toString().decrypt("nicnac");

		// 24h timeout for parameter ids 
		if(typeof(_encdelay)!="number" || isNaN(_encdelay) || _encdelay > 24)
			Response.Redirect("00_index.asp");
	}

	if(!_sid)
		_sid = Sesssion("uid");
	if (_sid)
		_id = _sid.toString().decrypt("nicnac");

}
catch(e)
{}

var pages 		= ["01_01_edit_dlg","01_02_edit_dlg","01_03_edit_dlg","01_04_edit_dlg"];
var _menu_title = ["cotisations"   ,"conférences"   ,"concerts"      ,"annuaire"];
var _menu_tip 	= ["cotisations"   ,"conférences"   ,"concerts"      ,"annuaire"];


// INDEX PAGES
var _page_index = new Array();
for(var _i=0;_i<pages.length;_i++)
	_page_index[pages[_i]+".asp"] = _i;

var _page_i = _page_index[_page];


var _menu_action = new Array();
for(_i=0;_i<pages.length;_i++)
	_menu_action[_i] = " onmouseover=this.href=\"JavaScript:try{document.main.action='"+pages[_i]+"_Q_id_E_"+_sid+".asp';document.main.submit()}catch(e){}\"";







%>

<%
function Zoom(img,zoomimg)
{
	return "<a href=../skins/zoom.asp?img="+Server.URLEncode(zoomimg)+" target=_blank>"+img+"</a>";
}
%>

<html>
<head>
<title><%=_title%></title>
  <meta NAME="author" CONTENT="Freddy Vandriessche">
  <meta HTTP-EQUIV="Content-Language" CONTENT="French">
  <style type="text/css" media="screen">@import "../includes/style.css";</style>
  <style type="text/css" media="screen">@import "../includes/topnav.css";</style>
  <style type="text/css" media="screen">@import "../includes/sidenav.css";</style>
  <style>
  BODY
  {
	MARGIN-TOP: 0px;
	MARGIN-LEFT: 0px;
    BACKGROUND-COLOR: black;
  }
  
#tabheader {
  float:left;
  width:100%;
  background:#E6E2DE url("../images/tab_brown_bg.gif") repeat-x bottom;
  font-size:93%;
  line-height:normal;
  padding-left:180px
  }
  </style>
  
  
  
</head>
<body id="home">
<a name="top"></a>
<%
if (skin_mode != 0)
{
%>

<table bgcolor="white" cellspacing="0" cellpadding="0" width="100%">
<tr>
	<td valign="top" width="<%=_body_width%>" style="background:#FFFFFF url(../images/ads/bb_partnerlogo_bg.gif) repeat-x top">
		<!-- M E N U   B A R -->
		<table cellspacing="0" cellpadding="0" border="0" >
		<tr height="<%=6%>">
			<td WIDTH="<%=_body_width-162%>"><img SRC="../images/nbox1.gif" WIDTH="<%=_body_width-162%>" HEIGHT="6" border="0"></td>
			<td rowspan="2" bgcolor="#F7F3EF" valign="top"><a href="http://www.thecandidates.com" target="_blank"><img SRC="../images/ads/bb_partnerlogo.gif" border="0" WIDTH="162" HEIGHT="24"></a></td>
		</tr>
		<tr height="<%=40-6-1%>">
			<td bgcolor="#F7F3EF" align="left">
				&nbsp;&nbsp;&nbsp;<a href="menu.asp" class="small">A D M I N - M E N U</a>
				&nbsp;&nbsp;&nbsp;<a href="../<%=_dir.split("_")[0]%>/index.asp" class="small">W E B S I T E</a>
				&nbsp;&nbsp;&nbsp;<a href="link_activate.asp?v=<%=(Session("uid")+","+Session("dir")+",").toString().encrypt("nicnac")%>" class="small">R E A C T I V A T E</a>
				&nbsp;&nbsp;&nbsp;<a href="logoff.asp?adminurl=index.asp" class="small">L O G O F F</a>
			</td>
		</tr>
		<tr height="<%=1%>"><td bgcolor="#BDBABD"></td><td bgcolor="#BDBABD"></td></tr>
		</table><!-- B O D Y --><%
}
%>