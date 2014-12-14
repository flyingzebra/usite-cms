<%
	//////////////////////////////////////
	// E N G L I S H   L A N G U A G E  //
	//////////////////////////////////////

	var _T = new Array();

	_T["menu_split"]			= 4;
	_T["menu_trees"]			= new Array("menu");
	_T["menu_titles"]			= new Array("home","contact","members","activities","collections","exhibitions","events","press","shop","sitemap","links");


	///////////////////////////////////////
	//	MENU HANDLER (DON´T TOUCH THIS)  //
	///////////////////////////////////////

	for ( var j=0 ; j < _T["menu_trees"].length ; j++ )
	{
		var itemname = _T["menu_trees"][j];
	
		_T[itemname+"_link"]			= new Array();	
		_T[itemname]					= new Array();
		_T[itemname+"_alt"]				= new Array();

		for( var i=0 ; i < _T[itemname+"_titles"].length ; i++ )
		{
			var titlename = String(_T[itemname + "_titles"][i]).replace(/[\x21-\x2F\x3A-\x40\x5B-\x5E´]/g,"").replace(/\x20/g,"_").replace(/[éèë]/g,"e");			_T[itemname][i]			 = itemname+"_" + titlename + ".gif";
			_T[itemname][i]			 = itemname+"_" + titlename + ".gif";
			_T[itemname+"_alt"][i]   = itemname + "_" + titlename + "_alt.gif";
			_T[itemname+"_link"][i]  = titlename + ".asp";
		}
	}

	/////////// MENU HANDLER ENDS HERE ///

	_T["menu_link"][0] = "../";
	
	_T["nav_all"]				= "all";
	_T["nav_begin"]				= "begin";
	_T["nav_end"]				= "end";
	_T["nav_prevpage"]			= "previous page";
	_T["nav_nextpage"]			= "next page";
	_T["nav_max"]				= "max."
	_T["nav_items"]				= "items";
	
	_T["login"]					= "login";
	_T["password"]				= "password";

	_T["free_newsletter"]			= "newsletter";
	_T["email_address"]				= "E-mail addres";
	_T["free_subscribe"]			= "free subscription";
	_T["newsletter_activated"]		= "newsletter activated";
	_T["newsletter_url_submit"]		= "newsletter.asp";
	_T["email_fillin"]				= "Fill here your E-mail address:";
	_T["newsletter_free"]			= "De nieuwsbrief is gratis";
	_T["newsletter_link"]			= "Latest newsletters";
	_T["OK"]						= "OK";
	_T["search"]					= "search";
	_T["advanced_search"]			= "advanced search";
	_T["news"]						= "news";
	_T["press"]						= "press";
	_T["articles"]					= "articles";
	_T["agenda"]					= "agenda";
	_T["structuralsponsors_img"]    = "<img src=../images/ads/sponsors.gif vspace=1>";
	_T["delete"]					= "delete";

	_T["mandatory"]					= "mandatory";
	_T["inuse"]						= "in use";	
	_T["readmore"]					= "read more";
	_T["permalink"]					= "permanent link";
	_T["comment"]					= "comment";
	_T["comments"]					= "comments";
	_T["commentlink"]				= "link to comments";
	
	// D O C T Y P E S
	_T["gallery"]					= "gallery";
	_T["agenda"]					= "agenda";
	_T["magazines"]					= "magazines"; 
	_T["index"]						= "page";
	_T["pdf"]						= "pdf";
	_T["by"	]						= "by";
	_T["more information"]			= "more information";
	
	_T["maximumresults"]			= "Maximum results";
	_T["noresults"]					= "No results";
	_T["invalid"]			    	= "invalid";
	_T["_checktitles"]				= ["Online","Apprear in summary","Locked","Delete"];
	_T["full list"]			   		= "full list";
	_T["limited list"]	    		= "limited list";
%>
	
	