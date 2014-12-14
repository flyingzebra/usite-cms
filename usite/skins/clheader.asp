<!--#INCLUDE FILE = "../includes/URL.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<%

var mode = "admin";

var oGUI	= new GUI();
var oSESSION = new oGUI.SESSION();

if(Request.Form("language").Item)	
	var _language = Request.Form("language").Item

if(typeof(_language)!="string")
{
	var _language = Session("_language")?Session("_language"):(_url.substring(0,5)=="admin"?"nlbe":_url.substring(0,5));
	var npos = _language.indexOf("/");
	_language = _language.substring(0,npos>=0?npos:4);	
}
else
	var npos = _language.indexOf("/");

var _isolanguage = _url.substring(0,2)+(_url.substring(2,npos)?("-"+_url.substring(2,4)):"");

var _page 	= _url.substring(npos+1,_url.length)
var npos 	= _page.lastIndexOf(".");
var _pagename 	= npos>0?_page.substring(0,npos):_page;
var _pageext  	= npos>0?_page.substring(npos,_page.length):"";

var _host		= Request.ServerVariables("HTTP_HOST").Item;
var _url		= Request.ServerVariables("URL").Item;
var _proj       = _url.split("/")[1];


var skin_session = Session("skin")?Session("skin"):0;
var skinnr = Request.QueryString("skin").Item?Number(Request.QueryString("skin").Item):skin_session; 
if (skinnr==100)
	skin_mode = 0;
Session("skin") = skinnr;


if(typeof(_dir)!="string")
{
	var _session = oSESSION.get("THEARTSERVER_MYSQL_DSNLESS",Request.QueryString["v"]);
	var _dir = _session["dir"];
}

if(typeof(_dir)!="string")
	var _dir = Session("dir");

if(typeof(_ws)!="string" && typeof(_dir)=="string")
	var _ws	= _dir.substring(0,_dir.lastIndexOf("_"));

if(typeof(_basedir)!="string")
	var _basedir = "../";	

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

if(typeof(_body_width)!="string")
	var _body_width = 545+220;

if(typeof(_rightbanner_width)!="string")
	var _rightbanner_width = 220;	
%>