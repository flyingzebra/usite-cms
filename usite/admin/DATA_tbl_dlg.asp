<%
	var bDebug = false;
	
	var bSubmitted = Request.TotalBytes==0?false:true;
	var dt = Request.QueryString("id").Item.toString();
	var id = Number(dt.decrypt("nicnac"));
	var orderby	= Number(Request.QueryString("orderby").Item);
	var _uid = Session("uid");
	var _dir = Session("dir");
	
	_masterdb = "dataset";
	_detaildb = "datadetail";

	function DATA()
	{
		this.itemo = new Array();
		//this.parse = DATA_parse;
		this.namecache_data = new Array();
		this.namecache_flds = new Array();
		this.namecache_enum = new Array();
	}
	var oDATA = new DATA();
	
	function loadXML(_xmlstr)
	{
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM")
		xmlDoc.async="false";
		
		if(_xmlstr)
		{
			xmlDoc.loadXML(_xmlstr)
			if(xmlDoc.parseError.errorCode!=0)
			{
				var txt="Error Code: " + xmlDoc.parseError.errorCode + "\n"
				txt=txt+"Error Reason: " + xmlDoc.parseError.reason
				txt=txt+"Error Line: " + xmlDoc.parseError.line
				xmlDoc.loadXML("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
			}
		}
		return xmlDoc
	}	
	

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));

	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	var bDelete = oDB.permissions([zerofill(ds_type,2)+"_delete"]);
	
	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
		Response.Redirect("index.asp")

	function quote( str )
	{
		return "'"+(!str || str==null?"":str.replace(/\x27/g,"\\'"))+"'";
	}

	var languages = oDB.getSetting(zerofill(ds_type,2)+"_L");


	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
	
	var deftablefld = new Array("rev_url","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;
	
	var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+id;
	var tabledefs = oDB.getrows(sSQL);

	
	// E X T E R N A L  D A T A B A S E   S E L E C T I O N

	Response.Write(tabledefs[defenumfld["rev_publisher"]])

	if(tabledefs[defenumfld["rev_publisher"]] && tabledefs[defenumfld["rev_publisher"]]!=null)
	{
		var arr = tabledefs[defenumfld["rev_publisher"]].split(",");
		masterdb = arr[0];
		detaildb = arr[1];
	}





	// R E A D   T A B L E   S E T T I N G S   F R O M   D A T A B A S E

	// R E A D   X M L   D A T A S E T
	
	var XMLObj = loadXML(tabledefs[defenumfld["rev_rev"]]);
	var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumdataset = new Array();
	for(var i=0;i<fields.length;i++)
		enumdataset[ fields.item(i).text ] = fields.item(i).getAttribute("name");
	
	// R E A D   X M L   H E A D E R S E T
	
	var XMLObj   = loadXML(tabledefs[defenumfld["rev_header"]]);
	var hfields   = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumheader = new Array();	
	for(var i=0;i<hfields.length;i++)
		enumheader[hfields.item(i).text] = hfields.item(i).getAttribute("name");	
	
	//SETTINGS//
	
	var fieldparam = new Array();
	var enumparam  = new Array();
	var paramfld   = new Array("colnum","colname","hidden","title","type","format","attr","attr1","attr2");
	for(var i=paramfld.length;i>=0;i--)
		enumparam[paramfld[i]] = i;		
	
	var oSETTINGS = new SETTINGS();
	oSETTINGS.id = id;
	if(settingspage>=0)
		oSETTINGS.load();
	else
		oSETTINGS.clear();

	var enumsettings = new Array();
	if(oSETTINGS.settingdata["LIST_PROPERTIES"].length>0)
		for(var i=0;i<oSETTINGS.settingdata["LIST_PROPERTIES"].length;i++)
			enumsettings[oSETTINGS.settingdata["LIST_PROPERTIES"][i]] = i

	var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
	var enumfld = new Array();
 	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;

	var _extraurl = (dt?("&id="+dt):"")+(orderby?("&orderby="+orderby):"")

	// SEARCH ENGINE
	
	var searchengine = "";
	var searchclause = " ";
	var linkclause   = "";

	
%>



