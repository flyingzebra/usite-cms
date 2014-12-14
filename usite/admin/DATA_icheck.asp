<%


	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	
	var bDebug = false;
	var eid = Request.QueryString("id").Item.toString()
	var id = Number(eid.decrypt("nicnac"));
	var sq = Request.QueryString("sq").Item?Number(Request.QueryString("sq").Item.toString()):0
	
	var orderby	= Number(Request.QueryString("orderby").Item);
	var _uid = Session("uid");
	var _dir = Session("dir");


	var _extraurl = (eid?("&id="+eid):"")+(orderby?("&orderby="+orderby):"");

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

	function loadXML(_xmlstr)
	{
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM")
		xmlDoc.async="false"

		xmlDoc.loadXML(_xmlstr)
		if(xmlDoc.parseError.errorCode!=0)
		{
			var txt="Error Code: " + xmlDoc.parseError.errorCode + "\n"
			txt=txt+"Error Reason: " + xmlDoc.parseError.reason
			txt=txt+"Error Line: " + xmlDoc.parseError.line
			xmlDoc.loadXML("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
		}
		return xmlDoc
	 }


	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
	
	

	
	
	
	var deftablefld = new Array("rev_title","rev_url","rev_ref","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
	{
		defenumfld[deftablefld[i]] = i;
		if(bDebug) Response.Write("defenumfld["+deftablefld[i]+"] = "+i+"<br>")
	}
	
	var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+id;
	var tabledefs = oDB.getrows(sSQL);
	
	var true_id = tabledefs[defenumfld["rev_ref"]]?tabledefs[defenumfld["rev_ref"]]:id;


	// E X T E R N A L  D A T A B A S E   S E L E C T I O N

    var masterdb = "dataset";
	var detaildb = "datadetail"
	
	if(tabledefs[defenumfld["rev_publisher"]] && tabledefs[defenumfld["rev_publisher"]]!=null)
	{
		var arr = tabledefs[defenumfld["rev_publisher"]].split(",");
		masterdb = arr[0];
		detaildb = arr[1];
	}

		


	// R E A D   X M L   H E A D E R S E T
	
	var XMLObj = loadXML(tabledefs[defenumfld["rev_header"]]);
	var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
	var header = new Array();
	var headername = new Array();
	var enumheader = new Array();
	
	for(var i=0;i<hfields.length;i++)
	{
		header[i] = hfields.item(i).text;
		var hID = header[i] ? Number(header[i].split(/([\[\]])/)[0]) : "";
		enumheader[hID] = hfields.item(i).getAttribute("name");
		headername[i] = hfields.item(i).getAttribute("name");
		
		if(bDebug)
		{
			Response.Write("header["+i+"] = "+header[i]+"<br>");
			Response.Write("enumheader["+hID+"] = "+enumheader[hID]+"<br>");
			Response.Write("headername["+i+"] = "+headername[i]+"<br>");
		}
	}


    if(!detaildb)
	{
	   Response.Write("no detaildb defined<br>")
	}
	else
	{
	
	// R E A D   X M L   D A T A S E T
	
	var XMLObj = loadXML(tabledefs[defenumfld["rev_rev"]]);
	var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	var fieldname = new Array();
	var fieldID = new Array();
	var indexfld = new Array();
	var DBfieldID = new Array();
	//var fusionfield = new Array();
	
	// FIND MAX AMOUNT OF RECORDS PER FIELD ID
	var cSQL = "select rd_dt_id,count(*) as t from "+_db_prefix+detaildb+" where  rd_ds_id = "+id+" group by rd_dt_id order by t desc,rd_dt_id limit 0,1"
    var top_type = oDB.getrows(cSQL);
	//Response.Write(top_type[0])
	
	// COMPARE DATASET & DETAIL
	var sSQL = "select rd_recno,(select ds_id from "+_db_prefix+masterdb+" where ds_rev_id = "+id+" and ds_id=rd_recno) as dsid from "+_db_prefix+detaildb+" where rd_ds_id = "+id+" and rd_dt_id = "+top_type[0]+" order by dsid"
    var missing = oDB.getrows(sSQL)
	Response.Write("<!--"+sSQL+"-->\r\n");
	
	var cre_arr = new Array();
	
	for(var i=0;i<missing.length;i+=2)
	{
		if(!missing[i+1]) cre_arr[cre_arr.length] = missing[i];
	}
	var iSQL = "insert into "+_db_prefix+masterdb+" (ds_id,ds_rev_id) values ("+cre_arr.join(","+id+"),(")
	iSQL = iSQL + ","+id+")"
	Response.Write(iSQL+"<br>")
	
	for(var i=0;i<hfields.length;i++)
	{
		var hID = header[i] ? Number(header[i].split(/([\[\]])/)[0]) : "";
		//enumheader[hID] = hfields.item(i).getAttribute("name");
		//headername[i] = hfields.item(i).getAttribute("name");
		//uSQL = "update "+_db_prefix+masterdb+" set "
		
		//Response.Write(hID+" "+enumheader[hID]+"<br>")
		
		uSQL = "UPDATE "+_db_prefix+masterdb+","+_db_prefix+detaildb+" SET "+enumheader[hID]+"=rd_text WHERE ds_rev_id="+id+" and rd_ds_id="+id+" and rd_recno=ds_id and rd_dt_id = "+hID+";<br>"
		Response.Write(uSQL+"<br>")
	}
	
	
	
	
	/*
	var crlf = "";
	for(var i=0;i<fields.length;i++)
	{
		DBfieldID[i] = fields.item(i).text ? Number(fields.item(i).text.replace(/\[([0-9]+)\]/,"$1")) : "";
		fieldname[i] = fields.item(i).getAttribute("name");
		fieldID[i] = "ts_data"+zerofill(DBfieldID[i],3);
		//fusionfield[i] = fields.item(i).text+(enumheader[DBfieldID[i]]?(" "+enumheader[DBfieldID[i]]):"")
		
		var bigtable = fields.item(i).text;
		cSQL+=",ts_data"+zerofill(bigtable.substring(1,bigtable.length-1),3)+" TEXT"+crlf;
	}
	cSQL+=",PRIMARY KEY `ts_id` (`ts_id`)"+crlf
	cSQL+=",INDEX `ts_rev_id` (`ts_rev_id`)"+crlf
	    +") ENGINE=MyISAM DEFAULT CHARSET=utf8;"+crlf;
	*/

		
	//Response.Write(cSQL)
    }
%>