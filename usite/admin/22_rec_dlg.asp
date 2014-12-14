<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

	var ds_type   = 22;
	var masterdb  = "paramset";
	var detaildb  = "";
	var settingspage = 0;
	var bDebug    = false;
%>

<!--#INCLUDE FILE = "DATA_rec_dlg.asp" -->


<%
/*

	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

	var ds_type   = 22;
	var masterdb  = "paramset";
	var detaildb  = "";
	var bDebug    = false;

	var bSubmitted = Request.TotalBytes==0?false:true;
	var dt = Number(Request.QueryString("dt").Item.toString().decrypt("nicnac"));
	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	
	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
		Response.Redirect("index.asp")

	function quote( str )
	{
		if(str && str!=null && typeof(str)=="string")
			str = str.replace(/\x22/g,"\\\"");
		else
			str = str?str:"";
		return "\""+str+"\"";
	}
	
	if(!isNaN(id))
	{
		var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub");
		var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+dt
		var overview = oDB.getrows(sSQL);
		var enumfld = new Array();
		for (var i=0; i<tablefld.length ; i++)
			enumfld[tablefld[i]] = i;
		
		Response.Write("<p style='font-size:70%'>");
		
	    //Response.Write(sSQL)			
		//Response.Write(Server.HTMLEncode(overview[enumfld["rev_rev"]]));
		
		// R E A D   X M L   D A T A S E T
		
		var XMLObj = loadXML(overview[enumfld["rev_rev"]]);
		var fields = XMLObj.getElementsByTagName("ROOT/row/field");
		var fieldID = new Array();
		var indexfld = new Array();
		var DBfieldID = new Array();
		for(var i=0;i<fields.length;i++)
		{
			DBfieldID[i] = fields.item(i).text ? Number(fields.item(i).text.replace(/\[([0-9]+)\]/,"$1")) : "";
			fieldID[i] = DBfieldID[i]-1;
			indexfld[DBfieldID[i]] = i;
			//Response.Write(fields.item(i).getAttribute("name")+" - "+fields.item(i).text+"<br>")
		}
		
		// R E A D   X M L   H E A D E R S E T

		var XMLObj = loadXML(overview[enumfld["rev_header"]]);
		var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
		
		var header = new Array();
		var headername = new Array();
		var enumheader = new Array();
		for(var i=0;i<hfields.length;i++)
		{
			header[i] = hfields.item(i).text;
			var hID = header[i] ? Number(header[i].replace(/\[([0-9]+)\]/,"$1")) : ""
			enumheader[hID] = hfields.item(i).getAttribute("name");
			headername[i] = hfields.item(i).getAttribute("name");
			
			if(bDebug)
			{
				Response.Write("header["+i+"] = "+header[i]+"<br>")
				Response.Write("enumheader["+hID+"] = "+enumheader[hID]+"<br>")
			}
		}		
		
		var rfld = new Array("rd_dt_id","rd_text");
		
		if(bSubmitted==false)
		{
			if(detaildb)
			{
				// L O A D   F R O M   R A W D A T A	
				var sSQL = "select "+rfld.join(",")+" from "+_db_prefix+detaildb+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id in ("+DBfieldID.join(",")+")";
				Response.Write(sSQL+"<br>");
				var rdata = oDB.getrows(sSQL);
				
				var rawdata = new Array(rfld.length);
				for(var i=0;i<rdata.length;i+=rfld.length)
				{
					rawdata[indexfld[rdata[i]]] = rdata[i+1];
					if(bDebug)
						Response.Write("assign rawdata["+indexfld[rdata[i]]+"] = "+rdata[i+1]+"<br>");
				}
				
				if(bDebug)
				{
					Response.Write("L O A D I N G &nbsp; R A W &nbsp; D A T A<br><br>");
					Response.Write(sSQL+"<br><br>");
					
					for(var i=0;i<DBfieldID.length;i++)
						Response.Write("fieldID["+DBfieldID[i]+"] = "+rawdata[i]+"<br>");
					Response.Write("<br>");
				}
			}
			else
			{
				// L O A D   F R O M   D A T A S E T
				var sSQL ="select "+headername.join(",")+" from "+_db_prefix+masterdb+" where ds_id = "+id+" and ds_rev_id = "+dt
				if(bDebug)
				{
					Response.Write("L O A D I N G &nbsp; R A W &nbsp; D A T A<br><br>");
					Response.Write(sSQL+"<br><br>");
				}
				
				var rawdata = oDB.getrows(sSQL);
			}
			

				
		}
		else
		{
			var rawdata = new Array();
			//var enumraw = new Array();
			for(var i=0;i<fieldID.length;i++)
			{
				var name = fields.item(i).getAttribute("name");
				rawdata[i] = Request.Form(name).Item?Request.Form(name).Item:"";
				//Response.Write("enumraw["+fieldID[i]+"] = "+Request.Form(name).Item+" ["+name+"]<br>");
				if(bDebug)
					Response.Write("rawdata["+i+"] = "+rawdata[i]+"<br>")
			}
			
			if(bDebug)
			{
				Response.Write("<br>L O A D I N G &nbsp; F O R M &nbsp; D A T A<br><br>");

				for(var i=0;i<DBfieldID.length;i++)
					Response.Write("fieldID["+DBfieldID[i]+"] = "+rawdata[i]+"<br>");
				Response.Write("<br>");
			}			
		}
		
		if(bSubmitted==true)
		{
			
			if(detaildb)
			{
				// U P D A T E   D E T A I L   D A T A B A S E
				var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
				for(var i=0;i<fieldID.length;i++)
				{
					var sSQL = "select rd_text from "+_db_prefix+detaildb+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id = "+DBfieldID[i];
					if(bDebug)
						Response.Write(sSQL+"<br>")
					var arr = oDB.getrows(sSQL)
					
					if(bDebug)
						Response.Write("RECORD FOUND :"+(arr.length>0)+"<br>")
					
					if(arr.length>0)
					{
						//Response.Write(rawdata+" this="+rawdata[i]+"<br>")
						//Response.Write("*["+(fieldID[i]+1)+"] "+rawdata[fieldID[i]+1]+"<br>")
						
						if(rawdata[i])
						{
							var uSQL = "update "+_db_prefix+detaildb+" set rd_text = "+quote(rawdata[i])+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id = "+DBfieldID[i];
							oDB.exec(uSQL);
							if(bDebug)
								Response.Write(uSQL+"<br>");
						}
						else
						{
							var dSQL = "delete from "+_db_prefix+detaildb+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id = "+DBfieldID[i];
							oDB.exec(dSQL);
							if(bDebug)
								Response.Write(dSQL+"<br>");					
						}
					}
					else
					{
						//Response.Write(rawdata+" this="+rawdata[i]+"<br>")
						//Response.Write("*["+(fieldID[i]+1)+"] "+rawdata[fieldID[i]+1]+"<br>")
						
						if(rawdata[i])
						{
							var data = new Array();
							data[0] = dt;
							data[1] = DBfieldID[i];
							data[2] = id;
							data[3] = quote(rawdata[i]);
							
							var iSQL = "insert into "+_db_prefix+detaildb+" ("+rawfld.join(",")+") values ("+data.join(",")+")"
							oDB.exec(iSQL);
							if(bDebug)
								Response.Write(iSQL+"<br>");
						}
					}
					if(bDebug)
						Response.Write("<br>");
				}
			}
			
			// U P D A T E   Q U I C K   D A T A S E T
			
			var j=0;
			var qset = new Array();
			
			//Response.Write("------------------------<br>")
			for(var i=0;i<DBfieldID.length;i++)
			{
				//Response.Write("fieldID["+enumheader[DBfieldID[i]]+"] = "+rawdata[i]+"<br>");
				
				var name = enumheader[DBfieldID[i]]
				if(name)
					if(name=="ds_datetime01")
						qset[j++] = name+" = "+quote(rawdata[i]?new Date(rawdata[i]).format("%Y-%m-%d %H:%M"):"");
					else
						qset[j++] = name+" = "+quote(rawdata[i]);
			}
			
			var uSQL ="update "+_db_prefix+masterdb+" set "+qset.join(",")+" where ds_id = "+id+" and ds_rev_id = "+dt
			if(bDebug)
				Response.Write(uSQL+"<br>")
			oDB.exec(uSQL); 
				
				
		}


		Response.Write("<form method=\"post\" name=\"main\">\r\n")
		Response.Write("<center>\r\n");
		var commands = "&nbsp;<input type=\"button\" src=\"../images/i_cancel.gif\" name=\"act\" value=\"cancel\" onclick=\"top.close()\">"
				+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" src=\"../images/i_save.gif\" name=\"act\" value=\"save\">"
				+"<br><br>\r\n"

		Response.Write(commands);

		Response.Write("<table cellspacing=\"2\" cellpadding=\"2\" border=\"0\" style=\"font-size:11px\">\r\n");
		for(var i=0;i<fieldID.length;i++)
		{
			var name = fields.item(i).getAttribute("name");
			var value = rawdata[i]==null?"":rawdata[i];
			
			if(bDebug)
				Response.Write("rawdata["+fieldID[i]+"] = "+rawdata[fieldID[i]]+"<br>")
			
			if(bDebug)
				Response.Write("testing enumheader["+DBfieldID[i]+"]<br>")
			
			if(enumheader[DBfieldID[i]])
			{
				if(name.substring(0,3)=="mn_")
					Response.Write("<tr><td bgcolor=#EFD0D0>"+name+"</td><td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" size=40></td></tr>");
				else
					Response.Write("<tr><td bgcolor=#FFE0E0>"+name+"</td><td bgcolor=#F0F0F0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" size=40></td></tr>");
			}
			else
			{
				if(name.substring(0,3)=="mn_")
					Response.Write("<tr><td bgcolor=#E0E0E0>"+name+"</td><td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" size=40></td></tr>");
				else
					Response.Write("<tr><td bgcolor=#F0F0F0>"+name+"</td><td bgcolor=#F0F0F0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" size=40></td></tr>");
			}
		}
		Response.Write("</table>\r\n<br>\r\n");
		
		Response.Write(commands);
		Response.Write("</center>\r\n</form>\r\n");

	}	

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
			xmlDoc.loadXML("<?xml version=\"1.0\" encoding=\"UTF-8\"?"+"><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
		}
		return xmlDoc
	 }

	if (bSubmitted)
	{
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");
	}
	*/
%>



<!--#INCLUDE FILE = "../skins/adfooter.asp" -->


