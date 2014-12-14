<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%



	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var ds_type      = 23;
	var masterdb     = "dataset";
	var detaildb     = "datadetail";
	var settingspage = 22;
	var bDebug       = false;
	var step         = 20;
	var sep          = ";";
        var bSpiderSafeURL = false;

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
	
	var deftablefld = new Array("rev_url","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;
	
	var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+id;
	var tabledefs = oDB.getrows(sSQL);


	
	// E X T E R N A L  D A T A B A S E   S E L E C T I O N

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
	//var enumheader = new Array();
	
	//Response.Write(hfields.length)
	//Response.End();

	for(var i=0;i<hfields.length;i++)
	{
		header[i] = hfields.item(i).text;
		headername[i] = hfields.item(i).getAttribute("name");

		

		if(bDebug)
		{
		        //var hID = header[i] ? Number(header[i].replace(/\[([0-9]+)\]/,"$1")) : "";
		        //enumheader[hID] = hfields.item(i).getAttribute("name");

			Response.Write("header["+i+"] = "+header[i]+"<br>");
			Response.Write("headername["+i+"] = "+headername[i]+"<br>");

		}



	}




	// R E A D   X M L   D A T A S E T
	
	var XMLObj = loadXML(tabledefs[defenumfld["rev_rev"]]);
	var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	var fieldname = new Array();
	var fieldID = new Array();
	var indexfld = new Array();
	var DBfieldID = new Array();

	var crlf = "";
	var cSQL = "CREATE TABLE "+_db_prefix+"tempset ("+crlf
				+ "ts_id int(11) unsigned NOT NULL default '0'"+crlf
				+",ts_rev_id int(11) unsigned NOT NULL default '0'"+crlf
				+",ts_pub1 int(11) unsigned NOT NULL default '0'"+crlf
				+",ts_pub2 int(11) unsigned NOT NULL default '0'"+crlf
				+",ts_pub3 int(11) unsigned NOT NULL default '0'"+crlf
				+",ts_pub4 int(11) unsigned NOT NULL default '0'"+crlf
	for(var i=0;i<fields.length;i++)
	{
		DBfieldID[i] = fields.item(i).text ? Number(fields.item(i).text.replace(/\[([0-9]+)\]/,"$1")) : "";
		fieldname[i] = fields.item(i).getAttribute("name");
		fieldID[i] = "ts_data"+zerofill(DBfieldID[i],3);
		
		var bigtable = fields.item(i).text;
		cSQL+=",ts_data"+zerofill(bigtable.substring(1,bigtable.length-1),3)+" TEXT"+crlf;
	}
	cSQL+=",PRIMARY KEY `ts_id` (`ts_id`)"+crlf
	cSQL+=",INDEX `ts_rev_id` (`ts_rev_id`)"+crlf
	    +") ENGINE=MyISAM DEFAULT CHARSET=utf8;"+crlf;





	if(sq==0)
	{



		oDB.bCatch = false;
		dSQL = "DROP TABLE "+_db_prefix+"tempset";
		try{oDB.exec(dSQL)}catch(e){};
		if(bDebug)
			Response.Write(dSQL);
		oDB.bCatch = true;	
		



		oDB.exec(cSQL);
		if(bDebug)
			Response.Write(cSQL+"<br>");
		
		if(detaildb)
			var iSQL = "insert into "+_db_prefix+"tempset (ts_id,ts_rev_id) select distinct rd_recno,"+id+" from "+_db_prefix+detaildb+" where rd_ds_id = "+id
		else
			var iSQL = "insert into "+_db_prefix+"tempset (ts_id,ts_rev_id) select distinct ds_id,"+id+" from "+_db_prefix+masterdb+" where ds_rev_id = "+id
		

		oDB.exec(iSQL);
		if(bDebug)
			Response.Write(iSQL+"<br>");


		var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+masterdb+" set ts_pub1 = (ds_pub & 1)=1,ts_pub2 = (ds_pub & 2)=2,ts_pub3 = (ds_pub & 4)=4,ts_pub4 = (ds_pub & 8)=8 where ts_rev_id = "+id+" and ts_rev_id = ds_rev_id and ds_rev_id = "+id+" and ts_id = ds_id"
		if(bDebug)
                      Response.Write(uSQL+"<br>");

                oDB.exec(uSQL);

	


		/*
		var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+masterdb+" set ts_pub2 = (ds_pub & 2) where ts_rev_id = "+id+" and ts_rev_id = ds_rev_id and ds_rev_id = "+id+" and ts_id = ds_id"
		oDB.exec(uSQL);

		var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+masterdb+" set ts_pub3 = (ds_pub & 4) where ts_rev_id = "+id+" and ts_rev_id = ds_rev_id and ds_rev_id = "+id+" and ts_id = ds_id"
		oDB.exec(uSQL);

		var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+masterdb+" set ts_pub4 = (ds_pub & 8) where ts_rev_id = "+id+" and ts_rev_id = ds_rev_id and ds_rev_id = "+id+" and ts_id = ds_id"
		oDB.exec(uSQL);
		*/
		
		/*
		for(var i=0;i<step;i++)
		{
			var bigtable = fields.item(i).text;
			var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+"datadetail set ts_data"+zerofill(bigtable.substring(1,bigtable.length-1),3)+" = rd_text where rd_ds_id = "+id+" and rd_dt_id = "+bigtable.substring(1,bigtable.length-1)+" and rd_recno = ts_id and ts_rev_id = rd_ds_id"
			oDB.exec(uSQL);
			if(bDebug)
				Response.Write(uSQL+"<br>");
		}
		*/
		
		

                if(bSpiderSafeURL)
                {
		   if(bDebug)
			Response.Write("<a href=\""+_pagename+"_Q_id_E_"+eid+"_A_sq_E_"+(sq+step)+".asp\">continue "+(sq+step)+"</a></script>");
		   else
			Response.Write("<script>document.location=\""+_pagename+"_Q_id_E_"+eid+"_A_sq_E_"+step+".asp\"</script>");
                }
                else
                {
		   if(bDebug)
			Response.Write("<a href=\""+_pagename+".asp?id="+eid+"&sq="+(sq+step)+"\">continue "+(sq+step)+"</a></script>");
		   else
			Response.Write("<script>document.location=\""+_pagename+".asp?id="+eid+"&sq="+step+"\"</script>");
                }
	}




	if(sq>0 || fields.length<step)
	{
		if(sq<(fields.length+step))
		{
			if(detaildb)
			{

                           if((sq-step)>=0)
                           {
				for(var i=(sq-step);i<fields.length && i<((sq-step)+step);i++)
				{
					var bigtable = fields.item(i).text;
					var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+detaildb+" set ts_data"+zerofill(bigtable.substring(1,bigtable.length-1),3)+" = IF(rd_text is NULL,'',replace(rd_text,'\\r\\n',' ')) where rd_ds_id = "+id+" and rd_dt_id = "+bigtable.substring(1,bigtable.length-1)+" and rd_recno = ts_id and ts_rev_id = rd_ds_id"
					if(bDebug)
						Response.Write(uSQL+"<br>");

					oDB.exec(uSQL);
				}
                           }
                           else
                           {
                              if(bDebug)
                                   Response.Write("*** NO UPDATES PERFORMED ***<br>")
                           }



			}
			else
				for(var i=(sq-step);i<fields.length && i<((sq-step)+step);i++)
				{
					var botharr = new Array();
					for(var j=0;j<headername.length;j++)
						//botharr[j] = "ts_data"+zerofill(j+1,3)+" = IF("+_db_prefix+masterdb+"."+headername[j]+" is NULL,'',replace("+_db_prefix+masterdb+"."+headername[j]+",'\\r\\n',' '))"
						//botharr[j] = "ts_data"+zerofill(j+1,3)+" = IF("+_db_prefix+masterdb+"."+headername[j]+" is NULL,'',replace(CONVERT("+_db_prefix+masterdb+"."+headername[j]+" using ucs2),'\\r\\n',' '))"
						botharr[j] = "ts_data"+zerofill(j+1,3)+" = IF("+_db_prefix+masterdb+"."+headername[j]+" is NULL,'',replace(CAST("+_db_prefix+masterdb+"."+headername[j]+" AS CHAR CHARACTER SET ucs2) COLLATE ucs2_bin,'\\r\\n',' '))"

						
						//botharr[j] = "ts_data"+zerofill(j+1,3)+" = "+_db_prefix+masterdb+"."+headername[j]

					
					Response.Write(botharr.join("<br>")+"<br>")
					
					var uSQL = "update "+_db_prefix+"tempset,"+_db_prefix+masterdb+" set "+botharr.join(",")+" where ds_rev_id = "+id+" and ds_id = ts_id and ts_rev_id = ds_rev_id"
					if(bDebug)
						Response.Write(uSQL+"<br>");

					oDB.exec(uSQL);

					
				}
				



                        

                        if(bSpiderSafeURL)
                        {
			   if(bDebug)
				Response.Write("<a href=\""+_pagename+"_Q_id_E_"+eid+"_A_sq_E_"+(sq+step)+".asp\">continue "+(sq+step)+"</a></script>");
			   else
				Response.Write("<script>document.location=\""+_pagename+"_Q_id_E_"+eid+"_A_sq_E_"+(sq+step)+".asp\"</script>");
                        }
                        else
                        {
			   if(bDebug)
				Response.Write("<a href=\""+_pagename+".asp?id="+eid+"&sq="+(sq+step)+"\">continue "+(sq+step)+"</a></script>");
			   else
				Response.Write("<script>document.location=\""+_pagename+".asp?id="+eid+"&sq="+(sq+step)+"\"</script>");
                        }
                        
		}
		else
		{



			var FSO 		= Server.CreateObject("Scripting.FileSystemObject");
			var crc24       = Math.floor((oDB.crc32(id.toString())/256)+(1<<23));
			var numberbase 	= anyfill(base64encode(crc24),4,"A") + anyfill(base64encode(id),6,"A");		
			var csvdir		= "../"+_ws+"/xml";
			var csvname		= _page.substring(0,_page.indexOf("."))+"_"+_language+"_"+numberbase+".json";
			var csvfile 	= Server.MapPath(csvdir)+"\\"+csvname;
			
                        if(bDebug)
                             Response.Write(csvfile+"<br>");

			
			try{
			FSO.DeleteFile(csvfile)
			} catch(e) {}






			try{
			var fileObj = FSO.CreateTextFile(csvfile,true,false);
			fileObj.Close();
                        } catch(e)
                        { 
                          Response.Write("ERROR WRITING FILE: "+e.description+"<br>")
                          Response.Write("<!--"+csvfile+"-->")
                          Response.End()
                        }	
			

			
			var sSQL = "select ts_id,ts_pub1,ts_pub2,ts_pub3,ts_pub4,"+fieldID.join(",")+" from "+_db_prefix+"tempset";
			if(bDebug)
                             Response.Write(sSQL)



			//var alldata = oDB.getrows(sSQL);
			
			var csvdumpfile = csvfile.replace(new RegExp(numberbase,""),numberbase+"_dump");

			try{
			FSO.DeleteFile(csvdumpfile)
			} catch(e) {}		


                        // D O   N O T   F O R G E T   G R A N T   S P E C I A L   P E R M I S S I O N S   F O R   M Y S Q L  !!!!!!!!!!!!!!!

                        // GRANT FILE ON *.* TO 'excalibur'@'%'
			

  
			sep = ",";
  			var eSQL = "select CONCAT(ts_id,':'),ts_pub1,ts_pub2,ts_pub3,ts_pub4,"+fieldID.join(",")
				+ " INTO OUTFILE '"+csvdumpfile.replace(/\\/g,"/")+"'"
				+ " FIELDS TERMINATED BY '"+sep+"'"
				+ " OPTIONALLY ENCLOSED BY '\"'"
				+ " LINES TERMINATED BY '}\\r\\n{' from usite_tempset order by ts_id";
			
			
			
			
			
			
                        if(bDebug)
                             Response.Write(eSQL+"<br>")
                    
			oDB.exec(eSQL);




			var fileObj = FSO.OpenTextFile(csvdumpfile);
			var txt = fileObj.ReadAll();




 
var Utf8 = {
 
	// public method for url encoding
	encode : function (string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
 
		for (var n = 0; n < string.length; n++) {
 
			var c = string.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
	},
 
	// public method for url decoding
	decode : function (utftext) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;
 
		while ( i < utftext.length ) {
 
			c = utftext.charCodeAt(i);
 
			if (c < 128) {
				string += String.fromCharCode(c);
				i++;
			}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
 
		}
 
		return string;
	}
 
}




			var ForAppending = 8;
			var fileObj = FSO.OpenTextFile(csvfile,ForAppending,false);
			fileObj.Write(
			"[{\"table\": \"tblConfig\",\r\n"
			+"\"def\":\r\n"
			+"[{\"column\": \"Property\", \"type\": \"TEXT NOT NULL\"},\r\n"
			+"{\"column\": \"Property\", \"type\": \"TEXT NOT NULL\"}],\r\n"
			+"\"data\":\r\n"
			+"[")
			
			//fileObj.Write("\"ID\""+sep+"\"ON\""+sep+"\"SUM\""+sep+"\"LCK\""+sep+"\"HID\""+sep+"\""+fieldname.join("\""+sep+"\"").replace(/\r\n/g," ")+"\"\r\n");

            fileObj.Write( Utf8.decode(txt.replace(/\\\"\r\n/g," ").replace(/\\N/g,"null").replace(/:",/g,":") ));
			fileObj.Write("]\r\n}]");
			
			fileObj.Close();

/*
			var arrTable = 
  [{"table": "tblConfig",
  "def":
    [{"column": "Property", "type": "TEXT NOT NULL"},
     {"column": "Value",    "type": "TEXT NOT NULL"}],
  "data":
    [{"Property": "VersionNumber", "Value": "1.0"},
     {"Property": "ReleaseDate",   "Value": "2010-01-01"}]
  }]
  */


			//Response.Write("<table align=center width=500 class=small><tr><td>");
			/*
			for( var i=0 ; i < alldata.length ; i += (DBfieldID.length+5) )
			{
				//Response.Write(i+" "+alldata.slice(i,i+DBfieldID.length+5).join("\";\"")+"<br>")
				fileObj.Write("\""+alldata.slice(i,i+DBfieldID.length+5).join("\";\"").replace(/\r\n/g," ")+"\"\r\n");
			}
			*/

			
			//Response.Write(overview.length)
			
		
			//Response.Write("</td></tr></table>");
			Response.Write(box_on());
			
			Response.Write("<table cellspacing=1 cellpadding=0 class=gtable style=\"border-color:black;border-width:1px;border-style:solid;width:250px\"><tr><td align=center>");
			Response.Write("<br>");
			Response.Write(_T["openhere"]);
			Response.Write("<br>");		
			Response.Write("<a href=\""+csvdir+"/"+csvname+"\" class=small target=_blank>"+csvname+"</a>");
			Response.Write("<br><br>");
			Response.Write("</td></tr></table>");
			
			Response.Write(box_off());	
			
			dSQL = "DELETE FROM "+_db_prefix+"tempset";
			//oDB.exec(dSQL);
			if(bDebug)
				Response.Write(dSQL);
			
			dSQL = "DROP TABLE "+_db_prefix+"tempset";
			//oDB.exec(dSQL);
			if(bDebug)
				Response.Write(dSQL);
		}
		
		
	}
	

%>

<br><br><a href="<%=zerofill(ds_type,2)%>_admin.asp" class=small>[back]</a>


</center>
<br>
<input type=hidden name=act>
</form>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
