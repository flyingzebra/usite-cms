<%
	//////////////////////////////////
	// D U T C H   L A N G U A G E  //
	//////////////////////////////////
	
	var _T = new Array();
	
	_T["menu_trees"]			= new Array("menu","contactmenu");
	_T["menu_split"]			= 3;
	_T["menu_titles"]			= new Array("onthaal","contact","activiteiten","leden","collecties","overzicht","links");
	_T["contactmenu_titles"]	= new Array("adres","het huis","routeplan");

	//_T["menu_titles"]			= new Array("onthaal","contact","activiteiten","leden","collecties","tentoonstellingen","evenementen","pers","winkel","overzicht","links");


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
	
	_T["nav_all"]				= "alles";
	_T["nav_begin"]				= "begin";
	_T["nav_end"]				= "einde";
	_T["nav_prevpage"]			= "vorige pagina";
	_T["nav_nextpage"]			= "volgende pagina";
	_T["nav_max"]				= "max."
	_T["nav_items"]				= "items";
	
	_T["login"]					= "login";
	_T["password"]				= "paswoord";

	_T["free_newsletter"]			= "nieuwsbrief";
	_T["email_address"]				= "E-mail adres";
	_T["free_subscribe"]			= "gratis inschrijven";
	_T["newsletter_activated"]		= "nieuwsbrief is geactiveerd";
	_T["newsletter_url_submit"]		= "newsletter.asp";
	_T["email_fillin"]				= "Vul hier uw E-mail adres:";
	_T["newsletter_free"]			= "De nieuwsbrief is gratis";
	_T["newsletter_link"]			= "Laatste nieuwsbrieven";
	_T["OK"]						= "OK";
	_T["search"]					= "zoek";
	_T["advanced_search"]			= "geavanceerd zoeken";
	_T["news"]						= "nieuws";
	_T["press"]						= "persberichten";
	_T["articles"]					= "artikels";
	_T["agenda"]					= "agenda";
	_T["structuralsponsors_img"]    = "<img src=../images/ads/structurele_sponsors.gif vspace=1>";
	_T["mandatory"]					= "verplicht";
	_T["inuse"]						= "reeds gebruikt";
	_T["readmore"]					= "lees meer";
	_T["delete"]					= "wissen";
	
	_T["gallery"]				= "galerie";
	_T["agenda"]				= "agenda";
	_T["magazines"]				= "magazines"; 
	_T["index"]					= "pagina";
	_T["pdf"]					= "pdf";
	_T["by"]					= "door";
	_T["more information"]		= "meer informatie";	
	
	_T["maximumresults"]		= "maximum aantal resultaten";
	_T["noresults"]				= "Geen resultaten";
	_T["invalid"]			    = "ongeldig";
	_T["_checktitles"]			= ["Online","Apprear in summary","Locked","Delete"];
	_T["full list"]			    = "gehele lijst";
	_T["limited list"]	    	= "beperkte lijst";
	
%>
	