<%
	////////////////////////////////////
	// F R E N C H   L A N G U A G E  //
	////////////////////////////////////
	
	var _T = new Array();

	_T["menu_trees"]			= new Array("menu","contactmenu");
	_T["menu_split"]			= 3;
	_T["menu_titles"]			= new Array("accueil","contact","activités","membres","collections","sommaire","liens");
	_T["contactmenu_titles"]	= new Array("adresse","la maison","plan d´accès");

	//_T["menu_titles"]			= new Array("accueil","contact","activités","membres","collections","expositions","événements","presse","boutique","sommaire","liens");


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
			var titlename = String(_T[itemname + "_titles"][i]).replace(/[\x21-\x2F\x3A-\x40\x5B-\x5E´]/g,"").replace(/\x20/g,"_").replace(/[éèë]/g,"e");
			_T[itemname][i]			 = itemname+"_" + titlename + ".gif";
			_T[itemname+"_alt"][i]   = itemname + "_" + titlename + "_alt.gif";
			_T[itemname+"_link"][i]  = titlename + ".asp";
		}
	}

	/////////// MENU HANDLER ENDS HERE ///

	_T["menu_link"][0] = "../";

	_T["nav_all"]				= "tout";
	_T["nav_begin"]				= "début";
	_T["nav_end"]				= "fin";
	_T["nav_prevpage"]			= "page précédente";
	_T["nav_nextpage"]			= "page prochaine";
	_T["nav_max"]				= "max."
	_T["nav_items"]				= "élements";

	_T["login"]					= "login";
	_T["password"]				= "mot de passe";
	_T["free_newsletter"]			= "newsletter";
	_T["email_address"]				= "adresse e-mail";
	_T["free_subscribe"]			= "souscrire gratuitement";
	_T["newsletter_activated"]		= "newsletter activé";
	_T["newsletter_url_submit"]		= "newsletter.asp";
	_T["email_fillin"]				= "Votre adresse e-mail:";
	_T["newsletter_free"]			= "Le newsletter est gratuit";
	_T["newsletter_link"]			= "Derniers newsletters";
	_T["OK"]						= "OK";
	_T["search"]					= "cherche";
	_T["advanced_search"]			= "recherche avancée";
	_T["news"]						= "nouvelles";
	_T["press"]						= "communiques";
	_T["articles"]					= "articles";
	_T["agenda"]					= "agenda";	
	_T["structuralsponsors_img"]= "<img src=../images/ads/menu_sponsors_structurels.gif vspace=1>";
	_T["mandatory"]					= "obligatoire";
	_T["inuse"]						= "déjà utilisé";
	_T["alphanumericexpected"]		= "uniquement alphanumérique";
	_T["numericexpected"]			= "uniquement numérique";	
	_T["readmore"]					= "détails";
	_T["delete"]					= "effacer";

	_T["edition"]				= "édition";
	_T["date"]					= "date";
	_T["heading"]				= "rubrique";
	_T["title"]					= "titre";
	_T["fragment"]				= "passage";

	_T["gallery"]				= "galerie";
	_T["agenda"]				= "agenda";   
	_T["magazines"]				= "magazines";
	_T["index"]					= "page";
	_T["pdf"]					= "pdf";
	_T["by"]					= "par";
	_T["more information"]		= "en savoir plus";
	
	_T["maximumresults"]		= "maximum nobre de résultats";
	_T["noresults"]				= "Aucun résultat";
	_T["invalid"]			    = "invalide";
	_T["_checktitles"]			= ["Online","Apprear in summary","Locked","Delete"];
	_T["full list"]			   	= "liste complète";
	_T["limited list"]	    	= "liste limité";
	
%>