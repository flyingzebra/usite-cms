<%	
	///////////////////////////////////////////
	// A D M I N   L A N G U A G E   F I L E //
	///////////////////////////////////////////
	
	if(!Session("dir"))
		Session("dir") = " ";
	
	var dir = Request.QueryString("dir").Item;
	if(dir) Session("dir") = dir;
	var _language = Session("dir").substring(Session("dir").indexOf("_")+1,Session("dir").length);
	
	var _app_db_prefix = "usite_";
	if(typeof(_db_prefix)!="string")
		var _db_prefix = _app_db_prefix;
		//var _db_prefix = _app_db_prefix+_language+"_";

	var _T = new Array();
	switch(_language.substring(0,2))
	{
		case "nl":
			_T["menu_trees"]			= new Array("menu");
			_T["menu_split"]			= 2;
			_T["menu_titles"]			= new Array("galerie","leden");
			_T["no_permissions"]		= "Er zijn nog geen toegangsmogelijkheden definieerd,<br><br>gelieve contact op te nemen met de administrator : <a href=mailto:support@artesoris.com?subject=["+_language+"]%20[no_permissions]>support@artesoris.com</a><br><br>klik <a href=../"+_language+"/>hier</a> om terug te keren"
			_T["admin_topictitles"]		= ["galerie<br>admin","site<br>admin","batch<br>admin","winkel<br>admin","links<br>admin","agenda<br>admin","abonnees<br>admin","nieuwsbrief<br>admin","gebruikers<br>admin","recyclage<br>admin"];
			_T["admin_logoff"]			= "afmelden";
			_T["admin_starterhelp"]		= "<br><dir>Hoe starten ?<br><br><ol>";
			_T["admin_starterhelp"]		+="<li>Klik eerst op 'new' om een nieuw artikel aan te maken.";
			_T["admin_starterhelp"]		+="<li>Klik vervolgens op 'edit' om het invulformulier te openen.";
			_T["admin_starterhelp"]		+="</ol></dir>";
			_T["admin_attach_title"]	= "ATT";
			_T["admin_attach_tip"]		= "Andere talen aankoppelen";
			_T["admin_bit_titles"]		= ["on","sum","lck","del"];
			_T["admin_bit_tips"]		= ["Online","Verschijn in overzicht","Vergrendeld","Verborgen/Te verwijderen"];
			_T["admin_treebit_titles"]	= ["on","sum","lck","del","met"];
			_T["admin_treebit_tips"]	= ["Online","Overzicht","Vergrendeld","Verborgen/Te verwijderen","Meta"];
			_T["admin_createdby_title"] = "C";
			_T["admin_createdby_tip"]	= "Gecreëerd door";
			_T["admin_modifiedby_title"]= "M";
			_T["admin_modifiedby_tip"]	= "Gemodificeerd door";
			_T["admin_cat_title"]		= "CAT";
			_T["admin_cat_tip"]			= "Categorie";			
			_T["admin_title_title"]		= "T I T E L";			
			_T["admin_desc_title"]		= "B E S C H R I J V I N G";
			_T["admin_wrongpassword"]	= "Toegang geweigerd, gelieve uw login en paswoord gegevens opnieuw te proberen.";
			_T["admin_clickhere"]		= "Klik hier";
			_T["admin_jpg_image"]		= "JPG<br>Foto";
			_T["admin_url"]				= "url";
			_T["admin_title"]			= "title";
			_T["admin_description"]		= "description";
			_T["admin_header"]			= "header";
			_T["admin_language"]		= "language";
			_T["admin_category"]		= "category";
			_T["admin_publisher"]		= "publisher";
			_T["admin_image"]			= "image";
			_T["admin_shutterspeed"]	= "shutter speed (s)";
			_T["admin_email"]			= "e-mail";
			_T["admin_pub_date"]		= "pub date<br>yyyy-mm-dd";
			_T["admin_phone"]			= "phone";
			_T["admin_fax"]				= "fax";
			_T["admin_address"]			= "address";
			_T["admin_save"]			= "save";
			_T["admin_save_as_text"]	= "save as text";
			_T["admin_options"]			= "options";
			_T["admin_cancel"]			= "cancel";
			_T["admin_no_data"]			= "geen gegevens";
			_T["admin_edit"]			= "edit";
			_T["admin_depth"]			= "depth";
			_T["admin_height"]			= "height";
			_T["admin_width"]			= "width";
			_T["admin_diameter"]		= "diameter";
			_T["admin_year"]			= "year";
			_T["admin_type_area"]		= "genre";
			_T["admin_type_tech"]		= "tech - medium";
			_T["admin_type_frame"]		= "frame";
			_T["admin_price_est"]		= "price estimation";
			_T["admin_date_est"]		= "estimation date";
			_T["admin_sourcecode"]		= "source code";
			_T["admin_skin"]		    = "skin";
			_T["admin_assignto"]		= "assign to";
			_T["admin_obsolete_ref"]	= "referentie buiten gebruik";
			_T["admin_moveup"]		= "opwaarts";
			_T["admin_movedown"]		= "neerwaarts";
			
			_T["nav_all"]				= "alles";
			_T["nav_start"]				= "begin";
			_T["nav_end"]				= "einde";
			_T["nav_prevpage"]			= "vorige pagina";
			_T["nav_nextpage"]			= "volgende pagina";
			_T["nav_prev"]				= "vorige";
			_T["nav_next"]				= "volgende";	
			_T["nav_max"]				= "max."
			_T["nav_items"]				= "items";
			_T["nav_max_items"]			= "max. _#_ items";
			_T["nav_settings"]			= "settings";
			
			_T["refresh"]				= "opfrissen";
			_T["new"]					= "nieuw";
			_T["save"]					= "bewaren";
			_T["savenext"]				= "bewaren en toevoegen";
			_T["search"]				= "zoek";
			_T["clear"]					= "wissen";
			_T["cancel"]				= "verlaten";
			_T["delete"]				= "verwijderen";
			_T["archive"]				= "archiveren";
			_T["_checktitles"]			= ["Online","Verschijnt in hoofdding","Afgesloten","Te verwijderen"];		
			
			_T["close"]					= "sluiten";
			_T["JPGimage"]				= "JPG beeld";
			_T["removeimage"]			= "afbeelding verwijderen";
			_T["addinfo"]				= "bijkomende informatie";
			_T["portrait"]				= "portretfoto";
			
			_T["uploadpadhelp"]			= "<b>GEBRUIKSAANWIJZING</b><br><br>"
										 +"<b>1.</b> afbeelding doorsturen (enkel afbeeldingen in JPG-formaat en de aangegeven minimum pixel-resolutie worden toegestaan).<br><br>"
										 +"<b>2.</b> bijkomende informatie toevoegen (titel, afmetingen...)<br><br>"
										 +"<b>3.</b> afbeelding verwijderen<br><br>"
			
			
			_T["emailstatusdesc"] 		= new Array("Correcte adressen","Foutieve adressen","Uitgeschreven adressen");
			_T["emailstatustitle"]		= new Array("ok","f","u");
			_T["unusableaddresses"]     = "Onbruikbare adressen";
			_T["alladdresses"]			= "Alle adressen";
			
			_T["subscribertype"]		= "Kies hier welke lijsten u wenst te importeren of exporteren.";
			_T["importexport"]			= "importeren / exporteren";	
			_T["import"]				= "importeren";						 
			_T["export"]				= "exporteren";
			_T["operations"]            = "bewerkingen";
			_T["back"]					= "keer terug";
			_T["openhere"]				= "Klik hier om het bestand te openen:";
			
			// D O C T Y P E S
			_T["gallery"]				= "galerie";
			_T["agenda"]				= "agenda";
			_T["magazines"]				= "magazines"; 
			_T["index"]					= "pagina";
			_T["pdf"]					= "pdf";	

			_T["title"]					= "titel";	
			_T["heading"]				= "rubriek";
			_T["edition"]				= "editie";
			_T["date"]					= "datum<br>dd-mm-jjjj";
			_T["dimmetrics"]			= new Array("d","h","b","ø");
			_T["dimensions"]			= "afmetingen";
			_T["close"]					= "sluiten";
			_T["cropping"]				= "afsnijden";
			_T["password"]				= "paswoord";
			_T["version"]				= "versie";
			_T["createDB"]				= "dataset aanmaken";
			_T["tablebuilder"]			= "tabel aanmaken";
			_T["rotate L"]				= "links 90";
			_T["rotate R"]				= "rechts 90";
			_T["obsolete"]				= "buiten gebruik";
			_T["check_all"]             = "alles&nbsp;aanvinken";
			_T["uncheck_all"]           = "alles&nbsp;uitvinken";
			_T["check_selection"]       = "selectie&nbsp;aanvinken";
			_T["uncheck_selection"]     = "selectie&nbsp;uitvinken";
			
		break;
		case "fr":
			_T["menu_trees"]			= new Array("menu");
			_T["menu_split"]			= 2;
			_T["menu_titles"]			= new Array("galerie","membres");
			_T["no_permissions"]		= "Les permissions d'acces n'ont pas encore été définis ,<br><br>veuillez contacter l'administrateur : <a href=mailto:support@artesoris.com?subject=["+_language+"]%20[no_permissions]>support@artesoris.com</a><br><br>cliquez <a href=../"+_language+"/>ici</a> pour retourner"
			_T["admin_topictitles"]		= ["galerie<br>admin","site<br>admin","batch<br>admin","boutique<br>admin","favoris<br>admin","agenda<br>admin","souscriptions<br>admin","newsletter<br>admin","usagers<br>admin","recyclage<br>admin"];
			_T["admin_logoff"]			= "quitter";
			_T["admin_starterhelp"]		= "<br><dir>Comment démarrer ?<br><br><ol>";
			_T["admin_starterhelp"]		+="<li>Cliquez d'abord sur 'new' pour créer un nouvel article.";
			_T["admin_starterhelp"]		+="<li>Cliquez en suite sur 'edit' pour ouvrir le formulaire d'encodage.";
			_T["admin_starterhelp"]		+="</ol></dir>";
			_T["admin_attach_title"]	= "ATT";
			_T["admin_attach_tip"]		= "Attacher d'audres langues";
			_T["admin_bit_titles"]		= ["on","sum","lck","del"];
			_T["admin_bit_tips"]		= ["Online","Sommaire","Cloturé","A enlever"];
			_T["admin_treebit_titles"]	= ["on","sum","lck","del","met"];
			_T["admin_treebit_tips"]	= ["Online","Apparaît en sommaire","Cloturé","Caché/A enlever","Meta"];
			_T["admin_createdby_title"] = "C";
			_T["admin_createdby_tip"]	= "Crée par";
			_T["admin_modifiedby_title"]= "M";
			_T["admin_modifiedby_tip"]	= "Modifé par";
			_T["admin_cat_title"]		= "CAT";
			_T["admin_cat_tip"]			= "Catégorie";			
			_T["admin_title_title"]		= "T I T R E";			
			_T["admin_desc_title"]		= "D E S C R I P T I O N";
			_T["admin_wrongpassword"]	= "Acces refusé, veuillez re-essayer votre login et mot de passe.";
			_T["admin_clickhere"]		= "Cliquez ici";
			_T["admin_jpg_image"]		= "Image<br>JPG";
			_T["admin_url"]				= "url";
			_T["admin_title"]			= "title";
			_T["admin_description"]		= "description";
			_T["admin_header"]			= "header";
			_T["admin_language"]		= "language";
			_T["admin_category"]		= "category";
			_T["admin_publisher"]		= "publisher";
			_T["admin_image"]			= "image";
			_T["admin_shutterspeed"]	= "shutter speed (s)";
			_T["admin_email"]			= "e-mail";
			_T["admin_pub_date"]		= "pub date<br>yyyy-mm-dd";
			_T["admin_phone"]			= "phone";
			_T["admin_fax"]				= "fax";
			_T["admin_address"]			= "address";
			_T["admin_save"]			= "save";
			_T["admin_save_as_text"]	= "save as text";
			_T["admin_options"]			= "options";
			_T["admin_cancel"]			= "cancel";
			_T["admin_no_data"]			= "manque de données";
			_T["admin_edit"]			= "edit";
			_T["admin_depth"]			= "depth";
			_T["admin_height"]			= "height";
			_T["admin_width"]			= "width";
			_T["admin_diameter"]		= "diameter";
			_T["admin_year"]			= "year";
			_T["admin_type_area"]		= "genre";
			_T["admin_type_tech"]		= "tech - medium";
			_T["admin_type_frame"]		= "frame";
			_T["admin_price_est"]		= "price estimation";
			_T["admin_date_est"]		= "estimation date";
			_T["admin_sourcecode"]		= "code source";
			_T["admin_skin"]		    = "habillage";
			_T["admin_assignto"]		= "assigner à";
			_T["admin_obsolete_ref"]	= "référence obsolete";
			_T["admin_moveup"]		= "monter";
			_T["admin_movedown"]		= "déscendre";
			
			_T["readmore"]				= "détails";
			_T["press"]					= "communiques";
			
			
			_T["nav_all"]				= "tout";
			_T["nav_start"]				= "début";
			_T["nav_end"]				= "fin";
			_T["nav_prevpage"]			= "page précédente";
			_T["nav_nextpage"]			= "page prochaine";
			_T["nav_prev"]				= "arrière";
			_T["nav_next"]				= "avant";	
			_T["nav_max"]				= "max."
			_T["nav_items"]				= "objets";
			_T["nav_max_items"]			= "max. _#_ objects";
			_T["nav_settings"]			= "config";
			
			_T["refresh"]				= "rafraîchir";
			_T["new"]					= "nouveau";
			_T["save"]					= "sauver";
			_T["savenext"]				= "sauver et ajouter";
			_T["search"]				= "cherche";
			_T["clear"]					= "effacer";
			_T["cancel"]				= "quitter";
			_T["delete"]				= "effacer";
			_T["archive"]				= "archiver";
			_T["_checktitles"]			= ["En ligne","Apparaître en sommaire","Verouillé","Eliminer"];			

			_T["JPGimage"]				= "Image JPG";
			_T["removeimage"]			= "effacer cette image";
			_T["addinfo"]				= "informations supplémentaires";
			_T["portrait"]				= "Portrait";

			_T["uploadpadhelp"]			= "<b>MANUEL D'UTILISATEUR</b><br><br>"
										 +"<b>1.</b> télécharger une images: seule les images en format JPG et la minimum résolution indiquée sont acceptées.<br><br>"
										 +"<b>2.</b> information supplémentaire<br><br>"
										 +"<b>3.</b> effacer l'image<br><br>"

			_T["emailstatusdesc"] 		= new Array("Adresses valides","Adresses invalides","Adresses arrêtées");
			_T["emailstatustitle"]		= new Array("va","in","ar");
			_T["unusableaddresses"]     = "Adresses inutilisables";
			_T["alladdresses"]			= "Toute les adresses";
			
			_T["subscribertype"]		= "Choisisez ici quel listes vous souhaitez importer ou exporter.";
			_T["importexport"]			= "importer / exporter";
			_T["import"]				= "importer";			 
			_T["export"]				= "exporter";
			_T["operations"]            = "operations";
			_T["back"]					= "retournez";
			_T["openhere"]				= "Pour ouvrir le fichier, cliquez ci-joint:";

			// D O C T Y P E S
			_T["index"]					= "page";
			_T["gallery"]				= "galerie";
			_T["agenda"]				= "agenda";   
			_T["magazines"]				= "magazines";
			_T["pdf"]					= "pdf";

			_T["title"]					= "titre";	
			_T["heading"]				= "rubrique";
			_T["edition"]				= "édition";
			_T["date"]					= "date<br>jj-mm-aaaa";
			
			_T["dimmetrics"]			= new Array("p","h","l","ø");
			_T["dimensions"]			= "dimensions";
			_T["close"]					= "fermer";
			_T["cropping"]				= "découper";
			_T["password"]				= "mot de passe";
			_T["version"]				= "version";
			_T["createDB"]				= "création dataset";
			_T["tablebuilder"]			= "création table";
			_T["rotate L"]				= "gauche 90";
			_T["rotate R"]				= "droite 90";


		break;
		default:			
			_T["menu_trees"]			= new Array("menu");
			_T["menu_split"]			= 2;
			_T["menu_titles"]			= new Array("gallery","members");
			_T["no_permissions"]		= "No permissions defined yet,<br><br>please contact administrator : <a href=mailto:support@artesoris.com>support@artesoris.com</a><br><br>click <a href=../"+_language+"/>here</a> to go back"
			_T["admin_topictitles"]		= ["gallery<br>admin","site<br>admin","batch<br>admin","shop<br>admin","favorites<br>admin","agenda<br>admin","subscribers<br>admin","newsletter<br>admin","user<br>admin","recycle<br>admin"];
			_T["admin_logoff"]			= "logoff";
			_T["admin_starterhelp"]		= "<br><dir>How can one start ?<br><br><ol>";
			_T["admin_starterhelp"]		+="<li>First click 'new' to create a new article.";
			_T["admin_starterhelp"]		+="<li>Then click 'edit' to open the input form.";
			_T["admin_starterhelp"]		+="</ol></dir>";
			_T["admin_attach_title"]	= "ATT";
			_T["admin_attach_tip"]		= "Attach other languages";
			_T["admin_bit_titles"]		= ["on","sum","lck","del"];
			_T["admin_bit_tips"]		= ["Online","Summary","Locked","To delete"];
			_T["admin_treebit_titles"]	= ["on","sum","lck","del","met"];
			_T["admin_treebit_tips"]	= ["Online","Appear in summary","Locked","Hidden/To delete","Meta"];
			_T["admin_createdby_title"] = "C";
			_T["admin_createdby_tip"]	= "Created by";
			_T["admin_modifiedby_title"]= "M";
			_T["admin_modifiedby_tip"]	= "Modified by";
			_T["admin_cat_title"]		= "CAT";
			_T["admin_cat_tip"]			= "Category";			
			_T["admin_title_title"]		= "T I T L E";			
			_T["admin_desc_title"]		= "D E S C R I P T I O N";
			_T["admin_wrongpassword"]	= "Access refused, please try again your login and password.";
			_T["admin_clickhere"]		= "Click here";
			_T["admin_jpg_image"]		= "JPG<br>Image";
			_T["admin_url"]				= "url";
			_T["admin_title"]			= "title";
			_T["admin_description"]		= "description";
			_T["admin_header"]			= "header";
			_T["admin_language"]		= "language";
			_T["admin_category"]		= "category";
			_T["admin_publisher"]		= "publisher";
			_T["admin_image"]			= "image";
			_T["admin_shutterspeed"]	= "shutter speed (s)";
			_T["admin_email"]			= "e-mail";
			_T["admin_pub_date"]		= "pub date<br>yyyy-mm-dd";
			_T["admin_phone"]			= "phone";
			_T["admin_fax"]				= "fax";
			_T["admin_address"]			= "address";
			_T["admin_save"]			= "save";
			_T["admin_save_as_text"]	= "save as text";
			_T["admin_options"]			= "options";
			_T["admin_cancel"]			= "cancel";
			_T["admin_no_data"]			= "no data";
			_T["admin_edit"]			= "edit";
			_T["admin_depth"]			= "depth";
			_T["admin_height"]			= "height";
			_T["admin_width"]			= "width";
			_T["admin_diameter"]		= "diameter";
			_T["admin_year"]			= "year";
			_T["admin_type_area"]		= "genre";
			_T["admin_type_tech"]		= "tech - medium";
			_T["admin_type_frame"]		= "frame";
			_T["admin_price_est"]		= "price estimation";
			_T["admin_date_est"]		= "estimation date";
			_T["admin_sourcecode"]		= "source code";
			_T["admin_skin"]		    = "skin";
			_T["admin_assignto"]		= "assign to";
			_T["admin_obsolete_ref"]	= "obsolete reference";
			_T["admin_moveup"]		= "upwards";
			_T["admin_movedown"]		= "downwards";			
			
			
			_T["nav_all"]				= "all";
			_T["nav_start"]				= "start";
			_T["nav_end"]				= "end";
			_T["nav_prevpage"]			= "prev page";
			_T["nav_nextpage"]			= "next page";
			_T["nav_prev"]				= "previous";
			_T["nav_next"]				= "next";	
			_T["nav_max"]				= "max."
			_T["nav_items"]				= "items";
			_T["nav_max_items"]			= "max. _#_ items";
			_T["nav_settings"]			= "settings";
			
			_T["refresh"]				= "refresh";
			_T["new"]					= "new";
			_T["save"]					= "save";
			_T["savenext"]				= "save and add";
			_T["search"]				= "search";
			_T["clear"]					= "clear";
			_T["cancel"]				= "cancel";
			_T["delete"]				= "delete";
			_T["archive"]				= "archive";
			_T["_checktitles"]			= ["Online","Apprear in summary","Locked","Delete"];		
			
			_T["close"]					= "close";
			_T["JPGimage"]				= "JPG image";
			_T["removeimage"]			= "delete image";
			_T["addinfo"]				= "additional information";
			_T["portrait"]				= "portret photograph";
			
			_T["uploadpadhelp"]			= "<b>USER INSTRUCTIONS</b><br><br>"
										 +"<b>1.</b> send images (only JPG-images, with the specified minimum pixel-resolution are beeing accepted).<br><br>"
										 +"<b>2.</b> put addtitional information (title, dimensions...)<br><br>"
										 +"<b>3.</b> remove image<br><br>"
			
			_T["emailstatusdesc"] 		= new Array("Valid addresses","Faulty addresses","Unsubscribed addresses");
			_T["emailstatustitle"]		= new Array("ok","f","u");
			_T["unusableaddresses"]     = "Unusable addresses";
			_T["alladdresses"]			= "All adresses";
			
			_T["subscribertype"]		= "Please select here the list you want to import or export.";
			_T["importexport"]			= "import / export";	
			_T["import"]				= "import";						 
			_T["export"]				= "export";
			_T["operations"]            = "operations";
			_T["back"]					= "go back";
			_T["openhere"]				= "Click here to open the file:";
			
			// D O C T Y P E S
			_T["gallery"]				= "gallery";
			_T["agenda"]				= "agenda";
			_T["magazines"]				= "magazines"; 
			_T["index"]					= "page";
			_T["pdf"]					= "pdf";	

			_T["title"]					= "title";	
			_T["heading"]				= "article";
			_T["edition"]				= "edition";
			_T["date"]					= "date<br>dd-mm-yyyy";

			_T["dimensions"]			= "dimensions";
			_T["dimmetrics"]			= new Array("d","h","w","ø");
			_T["close"]					= "close";
			_T["cropping"]				= "cropping";
			_T["password"]				= "password";
			_T["version"]				= "version";
			_T["createDB"]				= "create dataset";
			_T["tablebuilder"]			= "create table";
			_T["rotate L"]				= "left 90";
			_T["rotate R"]				= "right 90";			
			
		break;
	}


	/*	
	_T["admin_topics"]	= ["i_gallery.gif","i_hamster.gif","i_batch.gif","i_shop.gif","i_concept.gif","i_news.gif","i_news.gif","i_users.gif","i_recycle.gif"];
	_T["admin_topicnames"]	= ["01_admin","02_admin","03_admin","13_admin","09_admin","11_subscribers","11_admin","12_admin","14_admin"];
	_T["admin_topiclinks"]	= ["01_admin.asp","02_admin.asp","03_admin.asp","13_admin.asp","09_admin.asp","11_subscribers.asp","11_admin.asp","12_admin.asp","14_admin.gif"]
	
	_T["admin_bit1"] =	"on";
	_T["admin_bit2"] =	"sum";
	
	

	
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
			_T[itemname+"_alt"][i]   = itemname + "_" + titlename + "_alt.gif";
			_T[itemname+"_link"][i]  = "../"+_language+"/"+titlename + ".asp";
		}
	}

	///////////////////////////////////////

	//_T["menu_link"][0] = "../";
	//_T["menu_link"][1] = "../"+_language+"/index.asp";
	*/		

	////////////////////////////
	// LANGUAGE-COUNTRY CODES //
	////////////////////////////
	
	/*
	Afrikaans: af
	Albanian: sq 
	Basque: eu
	Belarusian: be
	Bulgarian: bg
	Catalan: ca
	Chinese (Simplified): zh-cn
	Chinese (Traditional): zh-tw
	Croatian: hr
	Czech: cs
	Danish: da
	Dutch: nl
	Dutch (Belgium): nl-be
	Dutch (Netherlands): nl-nl
	English: en
	English (Australia): en-au
	English (Belize): en-bz
	English (Canada): en-ca
	English (Ireland): en-ie
	English (Jamaica): en-jm
	English (New Zealand): en-nz
	English (Phillipines): en-ph
	English (South Africa): en-za
	English (Trinidad): en-tt
	English (United Kingdom): en-gb
	English (United States): en-us
	English (Zimbabwe): en-zw
	Estonian:  et
	Faeroese: fo
	Finnish: fi
	French: fr
	French (Belgium): fr-be
	French (Canada): fr-ca
	French (France): fr-fr
	French (Luxembourg): fr-lu
	French (Monaco): fr-mc
	French (Switzerland): fr-ch
	Galician: gl
	Gaelic: gd
	German: de
	German (Austria): de-at
	German (Germany): de-de
	German (Liechtenstein): de-li
	German (Luxembourg): de-lu
	German (Switzerland): de-ch
	Greek: el
	Hawaiian: haw
	Hungarian: hu
	Icelandic: is
	Indonesian: in
	Irish: ga
	Italian: it
	Italian (Italy): it-it
	Italian (Switzerland): it-ch
	Japanese: ja
	Korean: ko
	Macedonian: mk
	Norwegian: no
	Polish: pl
	Portuguese: pt
	Portuguese (Brazil): pt-br
	Portuguese (Portugal): pt-pt
	Romanian: ro
	Romanian (Moldova): ro-mo
	Romanian (Romania): ro-ro
	Russian: ru
	Russian (Moldova): ru-mo
	Russian (Russia): ru-ru
	Serbian: sr
	Slovak: sk
	Slovenian: sl
	Spanish: es
	Spanish (Argentina): es-ar
	Spanish (Bolivia): es-bo
	Spanish (Chile): es-cl
	Spanish (Colombia): es-co
	Spanish (Costa Rica): es-cr
	Spanish (Dominican Republic): es-do
	Spanish (Ecuador): es-ec
	Spanish (El Salvador): es-sv
	Spanish (Guatemala): es-gt
	Spanish (Honduras): es-hn
	Spanish (Mexico): es-mx
	Spanish (Nicaragua): es-ni
	Spanish (Panama): es-pa
	Spanish (Paraguay): es-py
	Spanish (Peru): es-pe
	Spanish (Puerto Rico): es-pr
	Spanish (Spain): es-es
	Spanish (Uruguay): es-uy
	Spanish (Venezuela)es-ve
	Swedish: sv
	Swedish (Finland): sv-fi
	Swedish (Sweden): sv-se
	Turkish: tr
	Ukranian: uk
	*/

%>
	
	