<%

var _doctypes  =    ["index"        ,"index"        ,"managed"              ,""                    	,"agenda"         	   ,""                ,""               ,""                    ,""                ,""                ,""                 ,""                  ,""             ,""              ,""                   ,""                  ,""               ,""               ,""                 ,""              ,""                         ,""               ,""               ,""               ,""                                     ,""                   ,""               ,""             ,""                                ,""                    ,""                ,""                          ,"magazines"         ,""             ,""                  ,""                 ,""              ,""                  ,""                  ,"pdf"         ,""                ,""                 ,""                 ,""                 ,""                      ,""                ,""                                                 ,""                ,""               ,""               ,""                         ,""]
var topics =	    ["i_hamster.gif","i_hamster.gif","i_managed.gif"        ,"i_datacenter.gif"       ,"i_tha.gif"           ,"i_tha.gif"       ,"i_tha.gif"      ,"i_rapport.gif"       ,"i_literatuur.gif","i_literatuur.gif","i_concept.gif"  ,"i_concept.gif"     ,"i_music.gif"  ,"i_batch.gif"   ,"i_news.gif"         ,"i_news.gif"        ,"i_artiesten.gif","i_managed.gif"  ,"i_gallery.gif"    ,"i_promo.gif"   ,"i_news.gif"               ,"i_newspaper.gif","i_newspaper.gif","i_newspaper.gif","i_piron.gif"                          ,"i_piron.gif"        ,"i_piron.gif"    ,"i_piron.gif"  ,"i_piron.gif"                     ,"i_piron.gif"         ,"i_rapport.gif"   ,"i_news.gif"                ,"i_magazines.gif"   ,"i_tree.gif"   ,"i_tree.gif"        ,"i_formview.gif"   ,"i_events.gif"  ,"i_kickstart.gif"   ,"i_languages.gif"   ,"i_pdf.gif"   ,"i_splash.gif"    ,"i_settings.gif"   ,"i_datamanager.gif","i_datamanager.gif","i_datamanager.gif"     ,"i_archive.gif"   ,"i_sitewizard.gif"                                 ,"i_pen.gif"       ,"i_pen.gif"      ,"i_pen.gif"      ,"i_broadcast.gif"          ,""];
var topicnames =	["14_admin"     ,"14_edit"      ,"01_admin"             ,"02_admin"   			,"04_admin"            ,"04_theagenda"    ,"04_daily"       ,"04_reports"          ,"08_edit"         ,"08_admin"        ,"09_edit"          ,"09_admin"          ,"03_edit"      ,"03_admin"      ,"11_admin"           ,"11_edit"           ,"12_admin"       ,"01_edit"        ,"01_thegallery"    ,"13_admin"      ,"11_subscribers"           ,"10_edit"        ,"10_admin"       ,"10_daily"       ,"06_piron"                             ,"06_dict"            ,"06_import"      ,"06_diff"      ,"06_speedsearch"                  ,"06_subscribers"      ,"06_reports"      ,"11_reports"                ,"07_admin"          ,"15_admin"     ,"15_sitemap"        ,"16_admin"         ,"17_admin"      ,"18_admin"          ,"19_admin"		    ,"20_admin"    ,"21_admin"        ,"22_admin"         ,"23_admin"         ,"23_edit"          ,"24_admin"              ,"14_admin"        ,"25_admin"                                         ,"26_admin"        ,"26_edit"        ,"26_view"        ,"27_admin"                 ,""];
var topictitles =	["site<br>admin","site<br>edit" ,"managed site<br>admin","managed tmpl<br>admin"  ,"agenda<br>admin"     ,"theagenda"       ,"agenda<br>daily","agenda<br>reports"   ,"books<br>edit"   ,"books<br>admin"  ,"favorites<br>edit","favorites<br>admin","music<br>edit","batch<br>admin","newsletter<br>admin","newsletter<br>edit","user<br>admin"  ,"managed site<br>edit","thegallery"       ,"promo<br>admin","newsletter<br>subscribers","news<br>edit"   ,"news<br>admin"  ,"news<br>daily"  ,"piron<br>abonnée"                     ,"piron<br>dictionary","piron<br>import","piron<br>diff","piron<br>speedsearch"            ,"piron<br>subscribers","piron<br>reports","newsletter<br>user reports","magazines<br>admin","tree<br>admin","sitemap<br>tester" ,"template<br>admin","event<br>admin","kickstart<br>admin","languages<br>admin","pdf<br>admin","splash<br>admin" ,"settings<br>admin","dataset<br>admin" ,"dataset<br>edit"  ,"dataset<br>macro admin","archive<br>admin","site<br>wizard"                                   ,"webmail<br>admin","webmail<br>edit","webmail<br>view","broadcast<br>admin",""];
var menulinks =	    ["14_admin.asp" ,"14_admin.asp" ,"01_admin.asp"         ,"02_admin.asp"			,"04_admin.asp"        ,"04_theagenda.asp","04_daily.asp"   ,"04_reports.asp"      ,"08_edit.asp"     ,"08_admin.asp"    ,"09_edit.asp"      ,"09_admin.asp"      ,"03_edit.asp"  ,"03_menu.asp"   ,"11_admin.asp"       ,"11_edit.asp"       ,"12_admin.asp"   ,"01_edit.asp"    ,"01_thegallery.asp","13_admin.asp"  ,"11_subscribers.asp"       ,"10_edit.asp"    ,"10_admin.asp"   ,"10_daily.asp"   ,"redirect.asp?adminurl=06_03_index.asp","06_dict.asp"        ,"06_import.asp"  ,"06_diff.asp"  ,"06_speedsearch.asp target=_blank","06_subscribers.asp"  ,"06_menu.asp"     ,"11_reports.asp"            ,"07_admin.asp"      ,"15_admin.asp" ,"15_sitemap.asp"    ,"16_admin.asp"     ,"17_menu.asp"   ,"18_admin.asp"      ,"19_admin.asp"      ,"20_admin.asp","21_admin.asp"    ,"22_admin.asp"     ,"23_admin.asp"     ,"23_admin.asp"     ,"24_admin.asp"          ,"14_archive.asp"  ,"25_edit_dlg.asp?id=d19d2e786d31ac33042cf30148a984","26_admin.asp"    ,"26_edit.asp"    ,"26_view.asp"    ,"27_admin.asp"             ,""];

///////////////////////////////////////
//  U S I T E   G U I    C L A S S   //
///////////////////////////////////////

function USITE_GUI()
{
	this.MENU		= USITE_GUI_MENU;
	this.initPAGES  = USITE_GUIinitPAGES;
	this.initTYPES	= USITE_GUIinitTYPES;
	this.initXML    = USITE_GUIinitXML;
	this.init		= USITE_GUIinit;
	this.init();
	this.initTYPES();
	this.initPAGES();
}

function USITE_GUIinit()
{
	// instantiate subclass objects
	this.Menu			= new this.MENU;
	this.param			= new Array();
	this.paramnames		= new Array();
	this.pagenames		= new Array();
}

function USITE_GUIinitXML(_xml)
{
	var _obj = _xml.item(0).childNodes;
	var _olen = _obj.length
	
	for(var _i=0;_i<_olen;_i++)
	{
		this.param[_obj.item(_i).tagName] = "";
		this.paramnames[_i] = _obj.item(_i).tagName;
	}
	
	for(var _i=0;_i<_olen;_i++)
		this.param[_obj.item(_i).tagName] = this.param[_obj.item(_i).tagName]?(this.param[_obj.item(_i).tagName]+","+_obj.item(_i).text):_obj.item(_i).text
}

function USITE_GUIinitTYPES()
{
	this.typefld = new Array("rt_id","rt_parent_id","rt_index","rt_level","rt_name")
	this.types	= 
	[1,0,2,1,"graphical menus"
	,2,1,1,2,"MENU_GFX_HSQBOX"
	,3,1,2,2,"MENU_GFX_HARIAL75"
	,4,0,1,1,"textual menus"
	,5,4,1,1,"MENU_TXT_LINEAR"];
	this.in_interleave = 5;
	this.enumtypes = new Array();
	for(var _i=0;_i<this.typefld.length;_i++)
		this.enumtypes[this.typefld[_i]] = _i;
}

function USITE_GUIinitPAGES()
{
	this.in_interleave = 2;
	
	this.pages = new Array();
	var doctype_i = 0;
	for(var i=0;i<_doctypes.length;i++)
	{
		if(_doctypes[i])
		{
			this.pages[doctype_i++] = Number(topicnames[i].substring(0,topicnames[i].indexOf("_")));
			this.pages[doctype_i++] = _doctypes[i];
		}
	}
	
	this.enumpages = new Array();
	for(var _i=0;_i<this.pages.length;_i+=this.in_interleave)
	{
		this.enumpages[this.pages[_i]] = _i;
		this.pagenames[this.pages[_i]] = this.pages[_i+1]
	}
}

/////////////////////////////////////////////////////////
//  M E N U   S U B C L A S S   D E F I N I T I O N S  //
/////////////////////////////////////////////////////////

function USITE_GUI_MENU()
{
	this.menutree		= new Object();
	this.rendermethod	= "";
	this.menuID			= -1;
	this.savepath		= "";

	this.param		= new Array();
	this.paramnames	= new Array();
	this.pagenames      = new Array();
		
	this.initTYPES	= USITE_GUIinitTYPES;
	this.initPAGES	= USITE_GUIinitPAGES;
	this.initXML	= USITE_GUIinitXML;

	this.load		= loadUSITE_GUI_MENU;
	this.display	= displayUSITE_GUI_MENU;
	this.render		= renderUSITE_GUI_MENU;
	this.XMLmenu	= XMLmenu_USITE_GUI_MENU;
	this.GENmenu	= GENmenuUSITE_GUI_MENU;
	this.GENlinear  = GENlinearUSITE_GUI_MENU;
	this.GENinfo	= GENinfoUSITE_GUI_MENU;
	this.initTYPES();
	this.initPAGES();
}

function loadUSITE_GUI_MENU(_menutree,_menuID,_rendermethod,_XMLoptions,_ws)
{
	this.menuID			= _menuID;
	this.rendermethod	= _rendermethod;
	this.menutree		= _menutree;
	this.savepath		= "../../"+_ws+"/images/";

	// SELECT TREE BRANCH
	this.menutree.childsof(_menuID,this.menutree.arrdata); // MULTI-DIMENSIONAL MENU

	// LOAD XML OPTIONS
	var XMLObj = Server.CreateObject("Microsoft.XMLDOM");
	XMLObj.async = "false";
	
	if(_XMLoptions)
	{
		XMLObj.loadXML(_XMLoptions);
		//var bXMLValid = XMLObj.parseError.errorCode == 0;
		try
		{ var bXMLValid = XMLObj.getElementsByTagName("ROOT/"+_rendermethod).item(0).childNodes[0].tagName?true:false; }
		catch(e)
		{ var bXMLValid = false }

		if(bDebug && bXMLValid == true)
			Response.Write("VALID XML !!!<br>");

		if(bXMLValid == true)
			this.initXML(XMLObj.getElementsByTagName("ROOT/"+_rendermethod));
		else
			Response.Write("INVALID XML !!!")
	}

	if(bDebug)
	{
		Response.Write("TREE_ID: "+_menuID+"<br>");
		Response.Write("RENDER METHOD: "+_rendermethod+"<br>");
		Response.Write("TREE CHILDS SELECTED: ")
		for(var i=0;i<this.menutree.childs.length;i++)
			Response.Write(this.menutree.arrdata[this.menutree.childs[i]+4]+" ")
		Response.Write("<br>");	
		
				Response.Write("PAGE TYPES SELECTED: ")
		for(var i=0;i<this.menutree.childs.length;i++)
			Response.Write(this.menutree.arrdata[this.menutree.childs[i]+5]+" ")
		Response.Write("<br>");			
			
		Response.Write("OPTION PARAMETERS:<dir>")
		for(var i=0;i<this.paramnames.length;i++)
			Response.Write("param[\""+this.paramnames[i]+"\"] = \""+this.param[this.paramnames[i]]+"\"<br>")
		Response.Write("</dir>");
	}
}

////////////////////////////////////
//  D I S P L A Y   M O D U L E   //
////////////////////////////////////

function GENmenuUSITE_GUI_MENU(selectedpageID,_overridepath)
{
	var _gen_i = 0;
	var _gen = new Array();

	var path = this.savepath;
	if(this.param["path"])
		path = this.param["path"];
	if(_overridepath)
		path = _overridepath;

	var defaultLevel	= 2;
	var backLink		= this.param["backlink"];
	var baseQuery		= "v="+Request.QueryString["v"]+"&id="+Request.QueryString["id"]+"&";
	var selectedLevel   = Number(this.menutree.arrdata[ this.menutree.index[ selectedpageID ] + 3 ]);
	var bIsSelectedParent = this.menutree.bIsParent[ selectedpageID ];
	var filterLevel		= (selectedLevel?selectedLevel:defaultLevel) + (bIsSelectedParent?1:0);

	var bFirst = true;			
	for(var _do=0;_do<this.menutree.treedata.length;_do+=this.menutree.out_interleave)
	{
		var level		= this.menutree.treedata[_do+1];
		if(filterLevel==level)
		{
			var pageID = this.menutree.treedata[_do];
			var title  = this.menutree.treedata[_do+2];
			
			var bIsParent	= this.menutree.bIsParent[ pageID ];
			var filename	= "men"+zerofill(this.menuID)+"_"+zerofill(pageID,3);
					
			var idx			= this.menutree.index[pageID];
			var pub			= Number(this.menutree.arrdata[idx+6]);
			var bHighlited  = selectedpageID == pageID || ((pub & 2) == 2 && (!selectedpageID || selectedLevel!=filterLevel));

			if((title==backLink || title.toLowerCase().indexOf("back")>=0) && filterLevel!=defaultLevel && (pub & (16+1)) == (16+1) )
				pageID = 0;

			//Response.Write(title+" "+backLink+" "+pub+" "+selectedpageID+"<br>");
			//Response.Write((title==backLink)+" "+(title.toLowerCase().indexOf("back")>=0)+"<br>");
					
			if(title!=backLink || filterLevel!=defaultLevel)
				_gen[_gen_i++] = "<a href=?"+(Request.QueryString["v"]?baseQuery:"")+"p="+pageID+"><img src="+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+" onmouseover=this.src='"+path+filename+"_alt.gif?"+Math.round(Math.random()*10000)+"' onmouseout=this.src='"+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+"' border=0></a>";				
		}
	}
	return _gen;
}

function GENlinearUSITE_GUI_MENU(selectedpageID)
{
	var _gen_i = 0;
	var _gen = new Array();

	selectedpageID = selectedpageID?selectedpageID:0;

	var direction = "horizontal";
	if(this.param["direction"])
		direction = this.param["direction"];

	var separator = " ";
	if(this.param["separator"])
		separator = this.param["separator"];

	var style = "";
	if(this.param["style"])
		style = "\t."+this.rendermethod+selectedpageID+" "+this.param["style"]+"\r\n";

	var linkstyle = "";
	if(this.param["linkstyle"])
		linkstyle = this.param["linkstyle"].replace(/(:link|:visited|:hover|:active)/g,"\tA."+this.rendermethod+selectedpageID+"$1").replace(/}/g,"}\r\n")

	// GENERATE STYLESHEET
	_gen[_gen_i++] = "\r\n<style>\r\n"+style+linkstyle+"</style>\r\n";

	var defaultLevel	= 2;
	var backLink		= this.param["backlink"];
	var baseQuery		= "v="+Request.QueryString["v"]+"&id="+Request.QueryString["id"]+"&";
	var selectedLevel   = Number(this.menutree.arrdata[ this.menutree.index[ selectedpageID ] + 3 ]);
	var bIsSelectedParent = this.menutree.bIsParent[ selectedpageID ];
	var filterLevel		= (selectedLevel?selectedLevel:defaultLevel) + (bIsSelectedParent?1:0);

	var bFirst = true;			
	for(var _do=0;_do<this.menutree.treedata.length;_do+=this.menutree.out_interleave)
	{
		var _di = _do/this.menutree.out_interleave*this.menutree.in_interleave;
		var level		= this.menutree.treedata[_do+1];
		if(filterLevel==level)
		{
			var pageID = this.menutree.treedata[_do];
			var title  = this.menutree.treedata[_do+2];
			var type   = this.menutree.arrdata[_di+5];
			var page   = this.pagenames[type];
			
			//Response.Write("page "+page+"<br>")
			
			var bIsParent	= this.menutree.bIsParent[ pageID ];
			var filename	= "men"+zerofill(this.menuID)+"_"+zerofill(pageID,3);

			
			//Response.Write(this.menutree.treedata+"<br>")
					
			var idx			= this.menutree.index[pageID];
			var pub			= Number(this.menutree.arrdata[idx+6]);
			var bHighlited  = selectedpageID == pageID || ((pub & 2) == 2 && (!selectedpageID || selectedLevel!=filterLevel));
			var bLast		= _do==(this.menutree.treedata.length-this.menutree.out_interleave)

			if((title==backLink || title.toLowerCase().indexOf("back")>=0) && filterLevel!=defaultLevel && (pub & (16+1)) == (16+1) )
				pageID = 0;

			if(title!=backLink || filterLevel!=defaultLevel)
			{
				if(this.param["direction"] == "horizontal") 
				//	_gen[_gen_i++] = "<a href=?"+(Request.QueryString["v"]?baseQuery:"")+"p="+pageID+" class="+this.rendermethod+selectedpageID+">"+title+"</a>"
					_gen[_gen_i++] = "<a href="+page+"_Q_P_E_"+pageID+".asp class="+this.rendermethod+selectedpageID+">"+title+"</a>"					
									+(bLast?"":this.param["separator"])
			}
		}
	}
	
	return _gen;
	
}

function GENinfoUSITE_GUI_MENU()
{
	var _gen_i = 0;
	var _gen = new Array();
	
	for(var _do=0;_do<this.menutree.treedata.length;_do+=this.menutree.out_interleave)
	{
		var pageID		= this.menutree.treedata[_do];
		var idx			= this.menutree.index[pageID];
		
		_gen[_gen_i++] = pageID;								// pageID
		_gen[_gen_i++] = this.menutree.arrdata[idx+1];			// parentID
		_gen[_gen_i++] = this.menutree.arrdata[idx+2];			// index
		_gen[_gen_i++] = this.menutree.arrdata[idx+3];			// level
		_gen[_gen_i++] = this.menutree.arrdata[idx+4];			// title	
		_gen[_gen_i++] = this.menutree.arrdata[idx+5];			// pub
	}
	return _gen;
}


function displayUSITE_GUI_MENU(selectedpageID,_overridepath)
{

	switch(this.rendermethod)
	{
		case "MENU_GFX_HSQBOX":
		
			Response.Write("<table width='100%' ><tr>");
			Response.Write("<td>"+this.GENmenu(	Number(selectedpageID),_overridepath).join("</td><td>")+"</td>")
			Response.Write("</tr></table>");

			/*
			for(var _i=0;_i<this.menutree.childs.length;_i++)
			{
				var level			= Number(this.menutree.arrdata[this.menutree.childs[_i] + 3 ]);
				if(filterLevel==level)
				{				
					var pageID		= Number(this.menutree.arrdata[this.menutree.childs[_i]]);
					var title		= this.menutree.arrdata[this.menutree.childs[_i]+4];
					var pub			= Number(this.menutree.arrdata[this.menutree.childs[_i]+6]);
					var bHighlited  = selectedpageID == pageID || (!selectedpageID && (pub & 2) == 2);
				
					if((title==backLink || title.toLowerCase().indexOf("back")>=0) && filterLevel!=defaultLevel && (pub & (16+1)) == (16+1) )
						pageID = 0;

					//Response.Write(selectedpageID+" "+pageID+" " +pub+"<br>");
					//Response.Write((title==backLink)+" "+(title.toLowerCase().indexOf("back")>=0)+"<br>");
					
					if(title!=backLink || filterLevel!=defaultLevel)
						Response.Write((_i!=0?"<td></td>":"")+"<td><a href=?"+(Request.QueryString["v"]?baseQuery:"")+"p="+pageID+"><img src="+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+" onmouseover=this.src='"+path+filename+"_alt.gif?"+Math.round(Math.random()*10000)+"' onmouseout=this.src='"+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+"' border=0></a></td>");
				}
			}
						
			Response.Write("</tr></table>");
			*/
			
		break;
		case "MENU_TXT_LINEAR":
			// THIS IS THE DISPLAY FUNCTION FOR THE ADMINISTRATION MODE
			// THE FUNCTION IS MEANT TO BE CALLED DIRECTLY FROM REF.ASP
			
			//Response.Write(Number(selectedpageID)+" RENDERMETHOD<br>");
			Response.Write(this.GENlinear(Number(selectedpageID)));
		break;
	}
}


////////////////////////////////////
//  R E N D E R   M O D U L E     //
////////////////////////////////////
// CAUTION >> D E C L A R A T I O N   O F   d r a w T e x t ( )   A T   G U I . a s p x  !!!

function renderUSITE_GUI_MENU(_overridepath)
{
	var path = this.savepath;
	if(this.param["path"])
		path = this.param["path"];
	if(_overridepath)
		path = _overridepath;

	for(var _i=0;_i<this.menutree.childs.length;_i++)
	{	
		switch(this.rendermethod)
		{
			case "MENU_GFX_HSQBOX":				
				// IMAGE FINAL DEPLOYEMENT
				var pageID		= Number(this.menutree.arrdata[this.menutree.childs[_i]]);
				var title		= this.menutree.arrdata[this.menutree.childs[_i]+4]
				var filename	= "men"+zerofill(this.menuID)+"_"+zerofill(pageID,3);
				this.param["hover"] = "";
				drawText(title,path+filename+".gif",this.param);
				this.param["hover"] = "true";
				drawText(title,path+filename+"_alt.gif",this.param);
			break;
		}
	}
}

//////////////////////////////
//  XMLmenu   M O D U L E   //
//////////////////////////////

function XMLmenu_USITE_GUI_MENU(_overridepath,_urlencode)
{
	var path = this.savepath;
	if(this.param["path"])
		path = this.param["path"];
	if(_overridepath)
		path = _overridepath;
		
	var backLink = this.param["backlink"];
	var selectedpageID	= Number(Request.QueryString["p"]);

	switch(this.rendermethod)
	{
		case "MENU_GFX_HSQBOX":
		case "MENU_TXT_LINEAR":
		
			var XMLtxt = "";
			var crlf = "\r\n";
			for(var _p=0;_p<this.menutree.treedata.length;_p+=this.menutree.out_interleave)
			{			
				var selectedpageID = zerofill(this.menutree.treedata[_p],10);
				
				// DISPLAY ALL THE POSSIBLE MENU POSITIONS
				//Response.Write("<table width='100%' ><tr>");
				//Response.Write("<td>"+Number(selectedpageID)+" "+this.GENmenu(	Number(selectedpageID),_overridepath).join("</td><td>")+"</td>")
				//Response.Write("</tr></table>");
				

				XMLtxt +="   <p"+selectedpageID+">"+(_urlencode?escape(this.GENmenu(selectedpageID,_overridepath).join("§")):this.GENmenu(selectedpageID,_overridepath).join(","))+"</p"+selectedpageID+">"+crlf
			}	
			
			return XMLtxt;
			//Response.Write("<script>alert(loadXML(\""+XMLtxt.replace(/\r\n/g,"")+"\"))</script>");
				
		break;
	}
}

function TREEmenu_USITE_GUI_MENU(_overridepath)
{
	var path = this.savepath;
	if(this.param["path"])
		path = this.param["path"];
	if(_overridepath)
		path = _overridepath;
		
	var backLink = this.param["backlink"];
	var selectedpageID	= Number(Request.QueryString["p"]);

	var _gen_i = 0;
	var _gen = new Array();

	var path = this.savepath;
	if(this.param["path"])
		path = this.param["path"];
	if(_overridepath)
		path = _overridepath;

	var defaultLevel	= 2;
	var backLink		= this.param["backlink"];
	var baseQuery		= "v="+Request.QueryString["v"]+"&id="+Request.QueryString["id"]+"&";
	var selectedLevel   = Number(this.menutree.arrdata[ this.menutree.index[ selectedpageID ] + 3 ]);
	var bIsSelectedParent = this.menutree.bIsParent[ selectedpageID ];
	var filterLevel		= (selectedLevel?selectedLevel:defaultLevel) + (bIsSelectedParent?1:0);

	var _tree   = new Array();
	var _tree_i = 0;					
	for(var _do=0;_do<this.menutree.treedata.length;_do+=this.menutree.out_interleave)
	{
		var level = this.menutree.treedata[_do+1];
		if(filterLevel==level)
		{
			var pageID = this.menutree.treedata[_do];
			var title  = this.menutree.treedata[_do+2];
			var bIsParent	= this.menutree.bIsParent[ pageID ];
			var filename	= "men"+zerofill(this.menuID)+"_"+zerofill(pageID,3);
					
			var idx			= this.menutree.index[pageID];
			var pub			= Number(this.menutree.arrdata[idx+6]);
			var bHighlited  = selectedpageID == pageID || ((pub & 2) == 2 && (!selectedpageID || selectedLevel!=filterLevel));

			if((title==backLink || title.toLowerCase().indexOf("back")>=0) && filterLevel!=defaultLevel && (pub & (16+1)) == (16+1) )
				pageID = 0;

			//Response.Write(title+" "+backLink+" "+pub+" "+selectedpageID+"<br>");
			//Response.Write((title==backLink)+" "+(title.toLowerCase().indexOf("back")>=0)+"<br>");
					
			if(title!=backLink || filterLevel!=defaultLevel)
				_gen[_gen_i++] = "<a href=?"+(Request.QueryString["v"]?baseQuery:"")+"p="+pageID+"><img src="+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+" onmouseover=this.src='"+path+filename+"_alt.gif?"+Math.round(Math.random()*10000)+"' onmouseout=this.src='"+path+filename+(bHighlited?"_alt":"")+".gif?"+Math.round(Math.random()*10000)+"' border=0></a>";				
		}
	}
}


function SETTINGS()
{
	this.bDebug				= false;

	this.load  				= SETTINGS_load;
	this.clear 				= SETTINGS_clear;
	this.parse_arg			= SETTINGS_parse_arg;
	this.structure  		= SETTINGS_structure;
	this.structure_complete = SETTINGS_structure_complete;
	
	this.settingnames 		= new Array();
	this.settingnames_users = new Array();
	this.settingnames  		= new Array("LIST_PROPERTIES","SEARCH_PROPERTIES","FIELD_PROPERTIES");
	this.p_dbcol 			= new Array("rev_title","ds_desc" ,"ds_header" ,"ds_data01","ds_data02","ds_data03","ds_data04" ,"ds_data05" ,"ds_data06" ,"rev_id"    ,"ds_id");
	this.p_names    		= new Array("prop"     ,"columnID","columnName","type"     ,"format"   ,"attr"     ,"undefined1","undefined2","undefined3","prop_revid","prop_dsid");
	this.p_idx				= new Array();
	this.settingdata        = new Array();

	this.byID   = new Array();   // byID['PROPERTY']
	this.byNAME = new Array();   // byNAME['PROPERTY'] = array

	this.IDs	= new Array();
	this.PROPs  = new Array();

	this.settingsref        = new Array();
	this.id					= 0;
	
	for(var _i=0;_i<this.p_names.length;_i++)
		this.p_idx[ this.p_names[_i] ] = _i;
}

function SETTINGS_parse_arg(_data,_offset,_enum)
{
	var _obj = new Array();
	for(var _i=0;_i<_enum.length;_i++)
	{
		//_obj[_enum[_i]] = _data[_offset+_i]?_data[_offset+_i]:"";
		if(_data[_offset+_i]) _obj[_enum[_i]] = _data[_offset+_i];
		
		//Response.Write("_obj["+_enum[_i]+"] = _data["+(_offset+_i)+"] ("+_data[_offset+_i]+")<br>")
	}
	return _obj;
}

function SETTINGS_clear()
{
	for(var i=0;i<this.settingnames.length;i++)
	{
		this.settingnames_users[i] = this.settingnames[i]+"_USERS";
		this.settingdata[this.settingnames[i]] = new Array();
		this.settingdata[this.settingnames_users[i]] = new Array();
	}
	
	for(prop in this.PROPs)
	{
		this.byID[prop] 	= new Array();
		this.byNAME[prop] 	= new Array();
	}
	
}

function SETTINGS_load()
{
	// TODO

    if(typeof(this.oDB)!="object" && typeof(oDB)=="object")
	   this.oDB = oDB;

	this.clear();
	
    ///////////////////////////////////////////////////////////////////////////////////////////////
	// LOAD GLOBAL SETTINGS

	var globalsettings  = new Array();

	if(bAdmin==false && bEdit==true)  // COLUMNS ONLY VIEWABLE BY EDITORS
	{
		var sSQL = "select "+this.p_dbcol.join(",")+" from "+_db_prefix+"review,"+_db_prefix+"paramset where rev_title IN ('"+this.settingnames_users.join("','")+"') and ds_rev_id = rev_id and ds_title = '0' and (ds_pub & 1) = 1 and (rev_pub & 1 = 1) and rev_dir_lng = '"+_ws+"' order by rev_title,ds_id";
		var globalsettings = this.oDB.getrows(sSQL);
		this.structure(globalsettings);
		
		if(this.bDebug)
		{
			Response.Write(sSQL+"<br><br>")
			Response.Write("GLOBAL SETTINGS: LOAD COLUMNS ONLY VIEWABLE BY EDITORS<br><br>");
			debugSETTINGS(this.p_dbcol,globalsettings);
			
			//if(this.bDebug) collection_dump(this.byID);
			//if(this.bDebug) collection_dump(this.byNAME);
			//if(this.bDebug) collection_dump(this.byPROP);			
		}
	}

	if(bAdmin==true || bEdit==true && globalsettings.length==0)  // COMUMNS VIEWABLE BY ADMINS
	{
		var sSQL = "select "+this.p_dbcol.join(",")+" from "+_db_prefix+"review,"+_db_prefix+"paramset where rev_title IN ('"+this.settingnames.join("','")+"') and ds_rev_id = rev_id and ds_title = '0' and (ds_pub & 1) = 1 and (rev_pub & 1 = 1) and rev_dir_lng = '"+_ws+"' order by rev_title,ds_id";
		globalsettings = this.oDB.getrows(sSQL);
		this.structure(globalsettings);
		
		if(this.bDebug)
		{
			Response.Write(sSQL+"<br><br>")
			Response.Write("GLOBAL SETTINGS: LOAD COMUMNS VIEWABLE BY ADMINS<br><br>");
			debugSETTINGS(this.p_dbcol,globalsettings);
			
			//if(this.bDebug) collection_dump(this.byID);
			//if(this.bDebug) collection_dump(this.byNAME);
			//if(this.bDebug) collection_dump(this.byPROP);			
		}
	}

	var prev_title = globalsettings[0];
	var prev_index = 0;

	for(var i=0;i<(globalsettings.length+this.p_dbcol.length);i+=this.p_dbcol.length)
	{
		if (prev_title != globalsettings[i])
		{
			this.settingdata[prev_title] = globalsettings.slice(prev_index,i);
			//this.data[prev_title] = this.parse_arg(globalsettings.slice(prev_index,i));
			
			if(this.bDebug)
			  Response.Write("(1) settingdata[\""+prev_title+"\"] = "+settingdata[prev_title]+"<br>");
			prev_title = globalsettings[i];
			prev_index = i;
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////
	// OVERWRITE PRIVATE SETTINGS
	
	if(this.id)
	{
		var privatesettings = new Array();
		if(bAdmin==false && bEdit==true)  // COLUMNS ONLY VIEWABLE BY EDITORS
		{
			var sSQL = "select "+this.p_dbcol.join(",")+" from "+_db_prefix+"review,"+_db_prefix+"paramset where rev_title IN ('"+this.settingnames_users.join("','")+"') and ds_rev_id = rev_id and ds_title = '"+this.id+"' and (ds_pub & 1) = 1 and (rev_pub & 1 = 1) and rev_dir_lng = '"+_ws+"' order by rev_title,ds_id"
			privatesettings = this.oDB.getrows(sSQL);
			this.structure(privatesettings);
			
			if(this.bDebug)
			{
				Response.Write(sSQL+"<br><br>")
				Response.Write("PRIVATE SETTINGS: LOAD COLUMNS ONLY VIEWABLE BY EDITORS<br><br>");
				debugSETTINGS(this.p_dbcol,globalsettings);
				
				//if(this.bDebug) collection_dump(this.byID);
				//if(this.bDebug) collection_dump(this.byNAME);
				//if(this.bDebug) collection_dump(this.byPROP);
			}	
		}
		
		if(bAdmin==true || bEdit==true && privatesettings.length==0)  // COMUMNS VIEWABLE BY ADMINS
		{
			var sSQL = "select "+this.p_dbcol.join(",")+" from "+_db_prefix+"review,"+_db_prefix+"paramset where rev_title IN ('"+this.settingnames.join("','")+"') and ds_rev_id = rev_id and ds_title = '"+this.id+"' and (ds_pub & 1) = 1 and (rev_pub & 1 = 1) and rev_dir_lng = '"+_ws+"' order by rev_title,ds_id"
			privatesettings = this.oDB.getrows(sSQL);
			this.structure(privatesettings);
			
			if(this.bDebug)
			{
				Response.Write(sSQL+"<br><br>")
				Response.Write("PRIVATE SETTINGS: LOAD COMUMNS VIEWABLE BY ADMINS<br><br>");
				debugSETTINGS(this.p_dbcol,globalsettings);
				
				//if(this.bDebug) collection_dump(this.byID);
				//if(this.bDebug) collection_dump(this.byNAME);
				//if(this.bDebug) collection_dump(this.byPROP);				
			}
		}
		
		var prev_index = 0;
		var prev_title = privatesettings[ prev_index+this.p_idx["prop"] ];   // FV CHANGED ON 12-08-2006 !!!!!!!!
		
		//this.settingsref[privatesettings[i]] = privatesettings[i+9];
		//Response.Write(privatesettings[i]+" * "+privatesettings[i+9]+"<br>");
		
		for(var i=0;i<(privatesettings.length+this.p_dbcol.length);i+=this.p_dbcol.length)
		{
			if (prev_title != privatesettings[i])
			{
				this.settingsref[prev_title] = privatesettings[prev_index+9];
				this.settingdata[prev_title] = privatesettings.slice(prev_index,i);
				
				if(this.bDebug)
					Response.Write("(3) settingdata[\""+prev_title+"\"] = [\""+this.settingdata[prev_title].join("\",\"")+"\"]<br>");
				prev_title = privatesettings[i];
				prev_index = i;
			}
		}
	}
	
	function debugSETTINGS(fldarr,darr)
	{
		Response.Write("<table>\r\n");
		for(var d=0;d<darr.length;d+=fldarr.length)
		{
			Response.Write("<tr><td>"+darr.slice(d,d+fldarr.length).join("</td><td>")+"</td></tr>\r\n");
		}
		Response.Write("\r\n</table><br>\r\n");
	}
	
	this.structure_complete();
}

function SETTINGS_structure(_settings)
{
	// GO THROUGH ALL THE PROPERTIES AND COLUMNS TO PREPARE ARRAY

	var prev_index = 0;
	for(var i=0;i<_settings.length;i+=this.p_dbcol.length)
	{
			var columnID  			= _settings[ i+this.p_idx["columnID"] ];
			var prop				= _settings[ i+this.p_idx["prop"] ];
			var columnName			= _settings[ i+this.p_idx["columnName"] ];
			var prop_revid			= _settings[ i+this.p_idx["prop_revid"] ]
			
			var arg_obj   			= this.parse_arg(_settings.slice(i,i+this.p_dbcol.length),prev_index,this.p_names);
			
			if(!this.IDs[columnID]) this.IDs[columnID] = columnName;
			if(!this.PROPs[prop])   this.PROPs[prop] = prop_revid;
			
			if(!this.byID[prop]) this.byID[prop] = new Array();
			this.byID[prop][columnID] = arg_obj;
			
			//if(!this.byNAME[prop]) this.byNAME[prop] = new Array();
			//this.byNAME[prop][columnName] = arg_obj;
	}
}

function SETTINGS_structure_complete()
{
/*
	for(var i=0;i<this.settingnames.length;i++)
	{
		var prop = this.settingnames[i];
		if(typeof(this.byID[prop])=="undefined") this.byID[prop] = new Array();
		if(typeof(this.byNAME[prop])=="undefined") this.byNAME[prop] = new Array();
		for(var columnID in this.IDs)
		{
			// COMPLETE THIS.BYID
			if(typeof(this.byID[prop][columnID])=="undefined") this.byID[prop][columnID] = new Array();
			
			// COMPLETE THIS.BYNAME
			if(!this.byNAME[prop]) this.byNAME[prop] = new Array();
			var columnName = this.byID[prop][columnID]["columnName"];
			if(columnName) this.byNAME[prop][columnName] = this.byID[prop][columnID];
			if(typeof(this.byNAME[prop][this.IDs[columnID]])=="undefined") this.byNAME[prop][this.IDs[columnID]] = new Array();
		}
	}

	collection_dump(this.byNAME);
*/	
}


function PATCH()
{
    this.initscript      = PATCH_initscript;
	this.viewbutton    	 = PATCH_viewbutton;
	this.controlbuttons  = PATCH_controlbuttons;
	this.param 			 = new Array();
}

function PATCH_viewbutton()
{
	Response.Write("<td class=wbtn><a href="+this.param["ztype"]+"_view.asp?id="+this.param["id"]+" target=_blank><img src=../images/i_view.gif border=0 title='"+this.param["id"]+"'></a></td>");	
}

function PATCH_initscript()
{
	Response.Write("\r\n<script>\r\n"
	+"function securedclick(thisobj)\r\n"
	+"{\r\n"
	+" if(thisobj.src.indexOf(\"i_run.gif\")>=0)\r\n"
	+" {\r\n"
	+"      thisobj.parentNode.target=\"_self\"\r\n"
	+"      thisobj.parentNode.href=\"   \"\r\n"
	+" }\r\n"
	+"}\r\n"
	+"</script>\r\n");
}

function PATCH_controlbuttons(buttonarr,bNotable)
{
	for(var _i=0;_i<buttonarr.length;_i++)
	{
		this.t1 = bNotable?"":"<td class=wbtn>";
		this.t2 = bNotable?"":"</td>";
			
		switch(buttonarr[_i])
		{
			case "view": this.viewbutton(); break;
			case "iedit":
			case "edit":
				if(this.param["pub"]&4)
					Response.Write(this.t1+this.t2);			
				else
					Response.Write(this.t1+"<a href="+this.param["ztype"]+"_edit_dlg.asp?id="+this.param["cid"]+(this.param["extraurl"]?this.param["extraurl"]:"")+" "+(buttonarr[_i]=="edit"?"target=_blank":"")+"><img src=../images/i_edit.gif border=0></a>"+this.t2); break;
			break;
			case "def":
				if(this.param["pub"]&4)
					Response.Write(this.t1+this.t2);
				else
					Response.Write(this.t1+"<a href="+this.param["ztype"]+"_def_dlg.asp?id="+this.param["cid"]+" target=_blank><img src=../images/i_def.gif border=0 title='"+this.param["id"]+"'></a>"+this.t2); break;
			break;
			case "ldf":
				if(this.param["pub"]&4)
					Response.Write(this.t1+this.t2);
				else
					Response.Write(this.t1+"<a href="+this.param["ztype"]+"_ldf_dlg.asp?id="+this.param["cid"]+" target=_blank><img src=../images/i_def.gif border=0 title='"+this.param["id"]+"'></a>"+this.t2); break;
			break;
			case "run":
				if(this.param["pub"]&8)
					Response.Write(this.t1+this.t2);
				else
					Response.Write(this.t1+"<a href="+this.param["ztype"]+"_run_dlg.asp?id="+this.param["cid"]+" "+(buttonarr[_i]=="run"?"target=_blank":"")+"><img src=../images/i_run.gif border=0 onmouseover='try{securedclick(this)}catch(e){}'></a>"+this.t2); break;
			break;
		}
	}
}


function MAGICK()
{
   this.bDebug   = false;
   this.width    = 0;
   this.height   = 0;
   this.obj      = Server.CreateObject("ImageMagickObject.MagickImage.1");
   this.imgsrc   = "";
   this.imgdst   = "";
   this.imgtmp   = "";
   this.init     = MAGICK_init;
   this.exit     = MAGICK_exit;
   this.Crop     = MAGICK_Crop;
   this.Resize   = MAGICK_Resize;
}

function MAGICK_init(_imgsrc,_imgdst)
{
   this.imgsrc = _imgsrc;
   this.imgdst = _imgdst;
   this.imgtmp = _imgdst.substring(0,_imgdst.lastIndexOf("\\"))+"\\tmp.png";
   
   this.bCropped = false;
   
   this.width  = this.obj.Identify ("-format", "%w", this.imgsrc);
   this.height = this.obj.Identify ("-format", "%h", this.imgsrc);
   if(this.bDebug) Response.Write("detected: "+this.width+"x"+this.height+"<br>")
}

function MAGICK_exit()
{
	if(this.bCropped==false) this.Resize();
}

function MAGICK_Crop(_x1,_y1,_x2,_y2)
{
   this.bCropped = true;
   var _w  = Math.round(this.width)
   var _h  = Math.round(this.height)
   _x1     = Math.round(_x1);
   _x2     = Math.round(_x2);
   _y1     = Math.round(_y1);
   _y2     = Math.round(_y2);
   
   var rs1 = _w+"x"+_h+"!";
   var cp1 = _w+"x"+_h+"+"+_x1+"-"+(_h-_y2);
   var cp2 = _w+"x"+_h+"-"+(_w-_x2)+"+"+_y1;
   
   var conversion = this.obj.Convert(this.imgsrc,"-resize",rs1,"-crop", cp1,"-crop",cp2,this.imgdst);
   if(this.bDebug) Response.Write("Convert('-resize,"+rs1+",-crop','"+cp1+",-crop,"+cp2+"')<br>")
}

function MAGICK_Resize()
{
   if(this.bDebug) Response.Write("Convert('-resize','"+Math.round(this.width)+"x"+Math.round(this.height)+"!')<br>")
   var conversion = this.obj.Convert("-resize", Math.round(this.width)+"x"+Math.round(this.height)+"!", this.imgsrc, this.imgdst);
}

function collection_dump(_coll)
{
	Response.Write("<br>COLLECTION DUMP<br>")
	if(typeof(_coll)=="undefined") return;
	for (var _obj in _coll)
	{
		if(typeof(_coll[_obj])=="object")
		{
			Response.Write("obj['"+_obj+"'] = OBJECT<br>");
			Response.Write("<dir>");
			collection_dump(_coll[_obj])
			Response.Write("</dir>");
		}
		else
			Response.Write("obj['"+_obj+"']="+_coll[_obj]+"<br>");	
	}
	Response.Write("<br>");
}	

%>