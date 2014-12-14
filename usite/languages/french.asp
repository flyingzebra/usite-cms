<%
	////////////////////////////////////
	// F R E N C H   L A N G U A G E  //
	////////////////////////////////////
	
	var _T = new Array();

	_T["menu_trees"]			= new Array("menu","contactmenu");
	_T["menu_split"]			= 3;
	_T["menu_titles"]			= new Array("accueil","contact","activit�s","membres","collections","sommaire","liens");
	_T["contactmenu_titles"]	= new Array("adresse","la maison","plan d�acc�s");

	//_T["menu_titles"]			= new Array("accueil","contact","activit�s","membres","collections","expositions","�v�nements","presse","boutique","sommaire","liens");


	///////////////////////////////////////
	//	MENU HANDLER (DON�T TOUCH THIS)  //
	///////////////////////////////////////

	for ( var j=0 ; j < _T["menu_trees"].length ; j++ )
	{
		var itemname = _T["menu_trees"][j];
	
		_T[itemname+"_link"]			= new Array();	
		_T[itemname]					= new Array();
		_T[itemname+"_alt"]				= new Array();

		for( var i=0 ; i < _T[itemname+"_titles"].length ; i++ )
		{
			var titlename = String(_T[itemname + "_titles"][i]).replace(/[\x21-\x2F\x3A-\x40\x5B-\x5E�]/g,"").replace(/\x20/g,"_").replace(/[���]/g,"e");
			_T[itemname][i]			 = itemname+"_" + titlename + ".gif";
			_T[itemname+"_alt"][i]   = itemname + "_" + titlename + "_alt.gif";
			_T[itemname+"_link"][i]  = titlename + ".asp";
		}
	}

	/////////// MENU HANDLER ENDS HERE ///

	_T["menu_link"][0] = "../";

	_T["nav_all"]				= "tout";
	_T["nav_begin"]				= "d�but";
	_T["nav_end"]				= "fin";
	_T["nav_prevpage"]			= "page pr�c�dente";
	_T["nav_nextpage"]			= "page prochaine";
	_T["nav_max"]				= "max."
	_T["nav_items"]				= "�lements";

	_T["login"]					= "login";
	_T["password"]				= "mot de passe";
	_T["free_newsletter"]			= "newsletter";
	_T["email_address"]				= "adresse e-mail";
	_T["free_subscribe"]			= "souscrire gratuitement";
	_T["newsletter_activated"]		= "newsletter activ�";
	_T["newsletter_url_submit"]		= "newsletter.asp";
	_T["email_fillin"]				= "Votre adresse e-mail:";
	_T["newsletter_free"]			= "Le newsletter est gratuit";
	_T["newsletter_link"]			= "Derniers newsletters";
	_T["OK"]						= "OK";
	_T["search"]					= "cherche";
	_T["advanced_search"]			= "recherche avanc�e";
	_T["news"]						= "nouvelles";
	_T["press"]						= "communiques";
	_T["articles"]					= "articles";
	_T["agenda"]					= "agenda";	
	_T["structuralsponsors_img"]= "<img src=../images/ads/menu_sponsors_structurels.gif vspace=1>";
	_T["mandatory"]					= "obligatoire";
	_T["inuse"]						= "d�j� utilis�";
	_T["alphanumericexpected"]		= "uniquement alphanum�rique";
	_T["numericexpected"]			= "uniquement num�rique";	
	_T["readmore"]					= "d�tails";
	_T["delete"]					= "effacer";

	_T["edition"]				= "�dition";
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
	
	_T["maximumresults"]		= "maximum nobre de r�sultats";
	_T["noresults"]				= "Aucun r�sultat";
	_T["invalid"]			    = "invalide";
	_T["_checktitles"]			= ["Online","Apprear in summary","Locked","Delete"];
	_T["full list"]			   	= "liste compl�te";
	_T["limited list"]	    	= "liste limit�";
	
%>