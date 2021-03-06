<%
	var bDebug = false;
	var bUpload = false;
	var bSaved  = false;
	
	var bIncludeRichtextLib = true;
	var DefaultRichtextLib = "rte";

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	var bDelete = oDB.permissions([zerofill(ds_type,2)+"_delete"]);
	oDB.permissions(["PERSITS_upload","PURE_upload"]);
	var file_uploader = oDB.permissions_match.length>0?oDB.permissions_match[0]:"";
	oDB.permissions(["PERSITS_jpeg","IMAGEMAGICK"]);
	var image_processor = oDB.permissions_match.length>0?oDB.permissions_match[0]:"";
	var bMultiPart = file_uploader.indexOf("PERSITS_upload")>=0?true:false;
    if(bDebug) Response.Write("file_uploader="+file_uploader+"<br>");
    //Array.prototype.Count = function () { return this.length;}
	
	if(!file_uploader) file_uploader = "PURE_upload";

	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
		Response.Redirect("index.asp")

	var arg_structure = 
	{
	"size":{"sep":"|"}
	}

	try 
	{
	    if(bMultiPart==true)
		{
			var Upload = Server.CreateObject("Persits.Upload.1");
			var FormCollection = Upload.Form;
			bUpload = true;
		}
		else
		{
			function Upload() { this.Form = UploadForm }
			function UploadForm() {}
		}
	}
	catch(e)
	{ 
		//Response.Write(e.description+"<br>");
		var bMultiPart = false;
		function Upload() { this.Form = UploadForm }
		function UploadForm() {}
	}
	
	try 
	{
		if(bMultiPart == true)
		{
			if(bDebug) Response.Write("Upload dir:"+Server.Mappath("../images/upload")+"<br>");
			var Count = Upload.Save(Server.Mappath("../images/upload")); bSaved = true;
			if(bDebug) Response.Write("File written ("+Count+")<br>");
		}

	}
    catch(e)
	{

	}
	
	
	
	var bSubmitted = bMultiPart==true && bUpload==true?!new Enumerator(FormCollection).atEnd():(Request.TotalBytes==0?false:true);
    
	if(bDebug)
	{
		Response.Write("bSubmitted = "+bSubmitted+"<br>");
		Response.Write("bMultipart = "+bMultiPart+"<br>");
	}
	
	//Response.Write(bUpload+" "+(!new Enumerator(FormCollection).atEnd()))
	
	var dt = Number(Request.QueryString("dt").Item.toString().decrypt("nicnac"));
	
	
	if(Request.QueryString("id").Item)
		var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	else
	{
		Response.Write("create")
		Response.End()
	}
		
	var _uid = Session("uid");
	var _dir = Session("dir");
	
	function quote( str )
	{
		if(str && str!=null && typeof(str)=="string")
			str = str.replace(/\x22/g,"\\\"");
		else
			str = str || typeof(str)=="number"?str:"";
		return "\""+str+"\"";
	}
	
	if(!isNaN(id))
	{
		var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub");
		var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+dt
		var overview = oDB.getrows(sSQL);
		var enumfld = new Array();
		for (var i=0; i<tablefld.length ; i++)
			enumfld[tablefld[i]] = i;
		
		if(overview[enumfld["rev_publisher"]] && overview[enumfld["rev_publisher"]]!=null)
		{
			var arr = overview[enumfld["rev_publisher"]].split(",");
			masterdb = arr[0];
			detaildb = arr[1];
		}		
		
		Response.Write("<p style='font-size:70%'>");
		
	    //Response.Write(sSQL)			
		//Response.Write(Server.HTMLEncode(overview[enumfld["rev_rev"]]));
		
		// R E A D   X M L   D A T A S E T
		
		var XMLObj = loadXML(overview[enumfld["rev_rev"]]);
		var fields = XMLObj.getElementsByTagName("ROOT/row/field");
		var fieldID = new Array();
		var indexfld = new Array();
		var DBfieldID = new Array();
		var enumdataset  = new Array();
		
		for(var i=0;i<fields.length;i++)
		{
			DBfieldID[i] = fields.item(i).text ? Number(fields.item(i).text.replace(/\[([0-9]+)\]/,"$1")) : "";
			fieldID[i] = DBfieldID[i]-1;
			indexfld[DBfieldID[i]] = i;
			enumdataset[DBfieldID[i]] = fields.item(i).getAttribute("name");
			
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
			var hID = header[i] ? Number(header[i].replace(/\[([0-9]+)\]/,"$1")) : "";
			enumheader[hID] = hfields.item(i).getAttribute("name");
			headername[i] = hfields.item(i).getAttribute("name");
			
			if(bDebug)
			{
				Response.Write("header["+i+"] = "+header[i]+"<br>");
				Response.Write("enumheader["+hID+"] = "+enumheader[hID]+"<br>");
			}
		}
		
		
		/////////////////////////////////////
		//    L O A D   S E T T I N G S    //
		/////////////////////////////////////
		
		var oSETTINGS = new SETTINGS();
		//oSETTINGS.bDebug = true;
		oSETTINGS.id = dt;
		oSETTINGS.load();
		//collection_dump(oSETTINGS.byID);

		var enumsettings = new Array();
		if(oSETTINGS.settingdata["FIELD_PROPERTIES"].length>0)
			for(var i=0;i<oSETTINGS.settingdata["FIELD_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
			{
				enumsettings[oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]] = i+1;
				//Response.Write("enumsettings["+oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]+"] = "+(i+1)+"<br>")
			}	
			
		var enumlistsettings = new Array();
		if(oSETTINGS.settingdata["LIST_PROPERTIES"].length>0)
			for(var i=0;i<oSETTINGS.settingdata["LIST_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
				enumlistsettings[oSETTINGS.settingdata["LIST_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]] = i+1;
		
		var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
		var enumfld = new Array();
		for (var i=0; i<tablefld.length ; i++)
			enumfld[tablefld[i]] = i;		
		
		
		///////////////////////////////////////
		//    L O A D   F O R M   D A T A    //
		///////////////////////////////////////		
		
		var rfld = new Array("rd_dt_id","rd_text");
		
		if(bSubmitted==false)
		{
			if(detaildb)
			{
				// L O A D   F R O M   R A W D A T A	
				var sSQL = "select "+rfld.join(",")+" from "+_db_prefix+detaildb+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id in ("+DBfieldID.join(",")+")";

				if(bDebug)
					Response.Write(sSQL+"<br>");
				var rdata = oDB.getrows(sSQL);
				var rawdata = new Array(rfld.length+1);
				
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
			// SUBMITTED = TRUE
			
			var rawdata = new Array();
			var pathdata = new Array();	
			var formarr = new Array();
			
			var enumforms = new Array();
			for(var i=0;i<fieldID.length;i++)
				enumforms[fields.item(i).getAttribute("name")] = i;
			
			function ENUMSET() { this.dump = ENUMSET_dump }
			var oEnumset = new ENUMSET();
			oEnumset.enumforms			= enumforms;
			oEnumset.enumsettings 		= enumsettings;
			oEnumset.enumlistsettings 	= enumlistsettings;
			oEnumset.settingdata 		= oSETTINGS.settingdata;
			oEnumset.enumdataset		= enumdataset;
			oEnumset.fields             = fields;
			oEnumset.byID				= oSETTINGS.byID;
			
			rawdata_obj = rawdata;
			
			//oEnumset.dump();
			
			function ENUMSET_dump()
			{
				for(var _o in this.enumforms)
					Response.Write("enumforms['"+_o+"'] = "+this.enumforms[_o]+"<br>");
				for(var _o in this.enumsettings)
					Response.Write("enumsettings['"+_o+"'] = "+this.enumsettings[_o]+"<br>");
				for(var _o in this.enumslistettings)
					Response.Write("enumlistsettings['"+_o+"'] = "+this.enumlistsettings[_o]+"<br>");
				for(var _o in this.settingdata)
					Response.Write("settingdata['"+_o+"'] = "+this.settingdata[_o]+"<br>");	
				for(var _o in this.enumdataset)
					Response.Write("enumdataset['"+_o+"'] = "+this.enumdataset[_o]+"<br>");	
				for(var _o=0; _o<this.fields.length;_o++)
					Response.Write("fields['"+_o+"'] = "+this.fields[_o]+"<br>");				
			}
			
			if(bMultiPart==true)
			{
				for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
				{
					var obj = objEnum.item();
					rawdata = form_conditioning(obj.name,obj.value,oEnumset,rawdata);
				}
			}
			else
			{
				var rawform = Request.Form().Item;
				var rawform_arr = formparser(rawform);
				
				function formparser(_str)
				{
					var _arr = new Array();
					
					var rawform_arr = rawform?rawform.split("&"):"";
					for(var i=0;i<rawform_arr.length;i++)
					{
						var form_pair = rawform_arr[i]?rawform_arr[i].split("="):new Array();
						form_pair[0] = form_pair?unescape(form_pair[0]).replace(/\+/g," "):"";
						form_pair[1] = form_pair?unescape(form_pair[1]).replace(/\+/g," "):"";
						//_arr[i] = new Array(form_pair[0],form_pair[1]);
						_arr[form_pair[0]] = form_pair[1];
					}
					return _arr;
				}
				
				if(bDebug)
						Response.Write("<br>R A W&nbsp; F O R M&nbsp; C O L L E C T O R<br><br>");
						
				for(i in rawform_arr)
				{
					if(bDebug)
						Response.Write("rawform_arr['"+i+"'] = "+rawform_arr[i]+"<br>");
						
					rawdata = form_conditioning(i,rawform_arr[i],oEnumset,rawdata);
				}
				if(bDebug) Response.Write("<br>");
				
				/*
				for(var i=0;i<rawform_arr.length;i++)
				{
					var form_pair = rawform_arr[i];
					rawdata = form_conditioning(rawform_arr[i][0],rawform_arr[i][1],oEnumset,rawdata);
				}
				*/
			}
			
			if(bDebug)
			{
				Response.Write("<br>L O A D I N G &nbsp; F O R M &nbsp; D A T A<br><br>");
				
				for(var i=0;i<DBfieldID.length;i++)
					Response.Write("fieldID["+DBfieldID[i]+"] = "+rawdata[i]+"<br>");
				Response.Write("<br>");
			}						
			
			function form_conditioning(_name,_value,_oSettings,rawdata_obj)
			{
				bDebug = true;
				
				// ASSIGN FORM VALUES TO RAWDATA FOR FORM RENDERING
			
				if(typeof(_value)!="string")
					return rawdata_obj;
				
				var rawdata = rawdata_obj;
				var idx = _oSettings.enumforms[_name];
				
				
				if(!_oSettings.byID["FIELD_PROPERTIES"] || !_oSettings.byID["FIELD_PROPERTIES"][columnID] || idx || idx==0)
				{
					if(type="number" && format=="EUR")
						rawdata[idx] = _value?Number(_value.replace(/,/,"."))*100:""
					else
						rawdata[idx] = _value;
						
					return rawdata;
				}
				
				var columnID = _oSettings.fields.item(idx).text;
				var type  = _oSettings.byID["FIELD_PROPERTIES"][columnID]["type"];
				var format = _oSettings.byID["FIELD_PROPERTIES"][columnID]["format"];					
				
				// FORM INPUT - DATA CONDITIONING
				
				if(_name.substring(0,3)=="ESC")
				{
					var fid = Number(_name.substring(3,6))
					idx = _oSettings.enumforms[ _oSettings.enumdataset[fid] ];
					var columnID = _oSettings.fields.item(idx).text;
					var type  = _oSettings.byID["FIELD_PROPERTIES"][columnID]["type"];
					var format = _oSettings.byID["FIELD_PROPERTIES"][columnID]["format"];
					
					rawdata[idx] = ((rawdata[idx]?(rawdata[idx]+","):"")+escape(_value)).replace(/,*$/,"");
				}
				else if(_name.substring(0,3)=="CSV")
				{
					var fid = Number(_name.substring(3,6))
					idx = _oSettings.enumforms[ enumdataset[fid] ];
					var columnID = _oSettings.fields.item(idx).text;
					var type  = _oSettings.byID["FIELD_PROPERTIES"][columnID]["type"];
					var format = _oSettings.byID["FIELD_PROPERTIES"][columnID]["format"];					
					
					if(type=="multistring" && format.substring(0,3)=="csv")
						rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+"\""+(_value?_value.replace(/"/g,"&quot;"):"")+"\"";
					else if(type=="multinumber")
						rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+(_value?Number(_value.replace(/,/,"."))*(format.substring(0,3)=="EUR"?100:1):"");					
					else
						rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+"\""+_value+"\"";
					
					// EXCLUDE BLANK FIELDS FROM DATABASE
					rawdata[idx]=rawdata[idx].replace(/,""/g,"").replace(/,*$/,"");
				}
				else if(_name.substring(0,3)=="CHK")
				{
					var fid = Number(_name.substring(3,6));
					var did = Number(_name.substring(7,10));
					var idx = enumforms[ enumdataset[fid] ];
					var columnID = _oSettings.fields.item(idx).text;
					var type  = _oSettings.byID["FIELD_PROPERTIES"][columnID]["type"];
					var format = _oSettings.byID["FIELD_PROPERTIES"][columnID]["format"];
					
					if (type=="number" && format.substring(0,5)=="check")
					{
						rawdata[idx] = (typeof(rawdata[idx])=="number"?rawdata[idx]:0)+(Number(_value)<<did);
						//Response.Write(rawdata[idx].toString(2)+" "+did+"<br>")
					}
				}				
				
				if(bDebug)
					Response.Write("rawdata["+idx+"] (fmt:"+format+") (name:"+_name+") = "+rawdata[idx]+"<br>");
				
				bDebug = false;
				return rawdata;
			}
		}
		
		// R I C H T E X T   I N C L U D E S
		var bFIELD_PROPERTIES = (oSETTINGS.byID["FIELD_PROPERTIES"] && oSETTINGS.byID["FIELD_PROPERTIES"][fields.item(0).text])?true:false;
		
		if(bIncludeRichtextLib && bFIELD_PROPERTIES)
		{
			var beenhere = new Array();
			for(var i=0;i<fieldID.length;i++)
			{
				var columnID = fields.item(i).text;
				
				//Response.Write(oSETTINGS.byID["FIELD_PROPERTIES"][columnID]+"*<br>")
				if(oSETTINGS.byID["FIELD_PROPERTIES"][columnID])
				{
					var type  = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["type"];
					var format = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["format"];
					
					format=(format=="richtext"?DefaultRichtextLib:format);
					
					if(type=="string" && beenhere[format]!=true)
					{
						if(has_hooks(format))
							format = format.substring(0,format.indexOf("("));
						
						switch(format)
						{
							case "rte_img":
							case "rte":
								Response.Write("<script language=\"JavaScript\" type=\"text/javascript\" src=\"../includes/richtext.js\"></script>\r\n");
								//Usage: initRTE(imagesPath, includesPath, cssFile)
								Response.Write("<script language=\"JavaScript\">initRTE(\"../includes/images/\",\"../includes/\",\"\")</script>\r\n");
							break;
							case "tinymce_img":
							case "tinymce":
						
								Response.Write("<script language=\"Javascript\" type=\"text/javascript\" src=\"../includes/tinymce/jscripts/tiny_mce/tiny_mce_src.js\"></script>\r\n")
								%>
									<script language="javascript" type="text/javascript">
										function fileBrowserCallBack(field_name, url, type, win) {
											// This is where you insert your custom filebrowser logic
											alert("Example of filebrowser callback: field_name: " + field_name + ", url: " + url + ", type: " + type);
											// Insert new URL, this would normaly be done in a popup
											win.document.forms[0].elements[field_name].value = "someurl.htm";
										}
									</script>
								<%
							break;
						}
					}
					else
						beenhere[format]==true;				
				}
			}
		}
		
		if(bSubmitted==true)
		{
			if(detaildb && bFIELD_PROPERTIES)
			{
				// U P D A T E   D E T A I L   D A T A B A S E
				var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
				for(var i=0;i<fieldID.length;i++)
				{
					var columnID = fields.item(i).text;
					var type  = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["type"];
					var format = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["format"];
					
					var sSQL = "select rd_text from "+_db_prefix+detaildb+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id = "+DBfieldID[i];
					if(bDebug)
						Response.Write(sSQL+"<br>");
						
					var arr = oDB.getrows(sSQL);
					
					if(bDebug)
						Response.Write("RECORD FOUND :"+(arr.length>0)+"<br>");
					
					if(arr.length>0)
					{
						//Response.Write(rawdata+" this="+rawdata[i]+"<br>")
						//Response.Write("*["+(fieldID[i]+1)+"] "+rawdata[fieldID[i]+1]+" "+typeof(rawdata[i])+" "+(rawdata[i] || typeof(rawdata[i])=="number")+" "+(!!rawdata[i])+"<br>")
						
						if(rawdata[i] || typeof(rawdata[i])=="number")
						{
							var uSQL = "update "+_db_prefix+detaildb+" set rd_text = "+qformat(rawdata[i],type,format)+" where rd_ds_id = "+dt+" and rd_recno = "+id+" and rd_dt_id = "+DBfieldID[i];
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
						//Response.Write("*["+(curfieldID)+"] "+rawdata[curfieldID]+"<br>")
						
						if(rawdata[i] || typeof(rawdata[i])=="number")
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
				var name = enumheader[DBfieldID[i]];
				if(name)
				{
					if (name.indexOf("ds_num")==0)
					{						
						qset[j++] = name+" = "+(rawdata[i] && !isNaN(rawdata[i].toString().replace(/,/,"."))?rawdata[i]:"null");
						
						if(rawdata[i] && isNaN(Number(rawdata[i].toString().replace(/,/,"."))) && name.indexOf("ds_num")==0)
							rawdata[i] = "*ERR NUMBER* "+rawdata[i]+" "+qset[j-1];
					}
					else if (name.indexOf("ds_datetime")==0)
					{	
						var format = oSETTINGS.byID["FIELD_PROPERTIES"]["["+DBfieldID[i]+"]"]["format"];
						qset[j++] = name+" = "+(rawdata[i]?qformat(rawdata[i],"date",format):"null");
					}
					else
						qset[j++] = name+" = "+quote(rawdata[i]);
				}
			}
			
			var uSQL ="update "+_db_prefix+masterdb+" set "+qset.join(",")+" where ds_id = "+id+" and ds_rev_id = "+dt;
			
			if(bDebug)
				Response.Write(uSQL+"<br>");
			oDB.exec(uSQL);
		}
		
		Response.Write("<form method=\"post\" name=\"main\""
					+(bMultiPart==true?" ENCTYPE=\"multipart/form-data\"":"")
					+(bIncludeRichtextLib?" onsubmit=\"try{return submitForm()}catch(e){}\"":"")+">\r\n")		
					
		Response.Write("<center>\r\n");
		var commands = "&nbsp;<input type=\"button\" src=\"../images/i_cancel.gif\" name=\"act\" value=\""+_T["cancel"]+"\" onclick=\"top.close()\">"
			+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=\"submit\" src=\"../images/i_save.gif\" name=\"act\" value=\""+_T["save"]+"\">"
			+"<br><br>\r\n"
		
		Response.Write(commands);
		
		Response.Write("<table cellspacing=\"2\" cellpadding=\"2\" border=\"0\" style=\"font-size:11px\">\r\n");
	    Response.Write("<tr><td bgcolor=#EFD0D0>ID</td><td bgcolor=#E0E0E0>["+id+"]"+(bAdmin?" <a href="+zerofill(ds_type,2)+"_id_dlg.asp?"+Request.QueryString().Item+">change/delete</a>":"")+"</td></tr>");
		
		var richtext_names = new Array();
		 
		var oFIELD = new FIELD();
		oFIELD.param = {"_ws":_ws
					,"dt":dt
					,"id":id
					}
		oFIELD.SETTINGS = oSETTINGS;
		
		function FIELD()
		{
			this.handler	= FIELD_HANDLER;
			this.param		= new Array();    // PARAMETERS
		}

		function FIELD_HANDLER(columnID,name,value)
		{
			var curfieldID 	= columnID.substring(1,columnID.length-1);
			
			if(!this.SETTINGS.byID["FIELD_PROPERTIES"] || !this.SETTINGS.byID["FIELD_PROPERTIES"][columnID]) 
				return "<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" "+(attr?attr:"size=40")+"></td></tr>";
			var fldesc	= this.SETTINGS.byID["FIELD_PROPERTIES"][columnID]["name"];
			var type	= this.SETTINGS.byID["FIELD_PROPERTIES"][columnID]["type"];
			var format	= this.SETTINGS.byID["FIELD_PROPERTIES"][columnID]["format"];
			var attr	= this.SETTINGS.byID["FIELD_PROPERTIES"][columnID]["attr"];
			
			switch(type)
			{
				case "img":
				var ArgFormat = (has_hooks(format)?1:0) + (has_json(format)?2:0);  
				
				//Response.Write((format.indexOf("{")==0)+"<br>");
				
				switch(ArgFormat)
				{
					case 0:
						format = "{size:\""+format.split(",")+"\"}" 
					break;
					case 1:
						var args = argsplitter(format);
						var arg  = argparser(args[1]);
						
						collection_dump(arg)
						//Response.Write("args['1'] = "+args[1]+"<br>")
						
						var format = arg["size"]?("{"+args[0]+":["+(arg["size"].split(arg["sep"]?arg["sep"]:"|"))+"]}"):"";
					break;
				}
				Response.Write(ArgFormat+" eval(\"var arg="+format+"\");<br>");
				Response.Flush()
				if(format) eval("var arg="+format);
				//collection_dump(arg);
				
				break;
				default:
					//Response.Write("param="+this.param["_ws"]+"<br>");
			}
			
		}

		// FORM GENERATOR
		for(var i=0;i<fieldID.length;i++)
		{	
			var columnID 	= fields.item(i).text;
			var name 		= fields.item(i).getAttribute("name");
			var value 		= rawdata[i]==null?"":rawdata[i];
			
			Response.Write( oFIELD.handler( columnID,name,value ) );
		}
		
	
		for(var i=0;i<fieldID.length;i++)
		{	
			if(bDebug) Response.Write("rawdata["+i+"] = "+rawdata[i]+"<br>")
			
			var name 		= fields.item(i).getAttribute("name");
			var value 		= rawdata[i]==null?"":rawdata[i];
			var columnID 	= fields.item(i).text;
			var curfieldID 	= columnID.substring(1,columnID.length-1);
		
			if(oSETTINGS.byID["FIELD_PROPERTIES"] && oSETTINGS.byID["FIELD_PROPERTIES"][columnID])
			{	
				var fldesc	= oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["name"];
				var type	= oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["type"];
				var format	= oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["format"];
				var attr	= oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["attr"];
				format		= format=="richtext" ? DefaultRichtextLib : format;
				
				switch(type)
				{
					case "img":
						///////////////////////////////////
						//    RESIZE UPLOADED IMAGERY    //
						///////////////////////////////////
						
						
						var filepath = "../"+_ws+"/images";
						var arrformats = format.split(",");
						
						var filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3);
						var fs				= Server.CreateObject("Scripting.FileSystemObject");
						var source_path		= Server.Mappath("../images/upload")+"\\";
						var ext             = ".jpg";
						
						// COLLECT IMAGE FILES
						if(rawform_arr && rawform_arr["nextact"] && rawform_arr["nextact"].indexOf("pure-upload")==0)
						{
							bUpload = true;
							
							var _str = rawform_arr["nextact"].split(":");
							var _name = _str[1];
							var _path = source_path+unescape(_str[2]);

							var FileCollection = new Array({"path":_path,"name":_name,ExtractFileName:ENUM_EXTRACT});
							if(bDebug) FILECOLLECTION_DUMP(FileCollection);
						}
						else
						{
							var FileCollection = Upload.Files;
							if(bDebug) FILECOLLECTION_DUMP(FileCollection);
						}
						
						// PROCESS IMAGE FILES
						if (bUpload)
						{	
							var bValidImage = false;
							for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
							{
								var obj 	= objEnum.item();
								var ext 	= obj.path?obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase():".jpg";
								var imgnr 	= obj.name?Number(obj.name.substring(22,25)):0;
								
								if(bDebug)
									Response.Write("path="+obj.path+"<br>name="+obj.name+"<br>ext="+ext+"<br>imgnr="+imgnr+"curfieldID="+curfieldID+"***<br>");
								
								if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
								{
									var ext = ".jpg";
									
									switch(image_processor)
									{
										case "IMAGEMAGICK":  var jpeg = new MAGICK(); break;
										case "PERSITS_jpeg": var jpeg = Server.CreateObject("Persits.Jpeg"); break;
									}
									
									for(var j=0;j<arrformats.length;j++)
									{
										jpeg.open( obj.path );
										jpeg.Quality = 85;
										jpeg.Interpolation = 2;
										
										resizetoRect(jpeg,arrformats[j]);
										jpeg.Sharpen(1,105);
										var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+j+ext;
										jpeg.Save(savefile);
										
										value = (isNaN(value)?0:Number(value)) | (1<<j);  // alter bitmap !
										
										bValidImage = true;
										if(bDebug)
											Response.Write("IMAGE SAVED: "+savefile+"<br><br>")
									}
								}
							}
							
							if(bValidImage)
							{
								var source_name = "";
								for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
									source_name = objEnum.item().ExtractFileName();
									
								var source 	= source_path + source_name;
								var dest	= Server.Mappath(filepath)+ "\\src" + filebase +ext;
								
								// DELETE PREVIOUS FILE (SINCE OVERWRITING ISN'T PERMITTED)
								try {fs.DeleteFile(dest)}catch(e){if (bDebug) Response.Write("*delete* "+dest+": "+e)};	
								
								//for(var j=0;i<1000 && fs.FileExists(dest)==false;j++)
									if(fs.FileExists(source))
									{
										try {fs.MoveFile(source,dest)}catch(e){if (bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
									}
									else
										Response.Write("*MoveFile('"+source+"','"+dest+"')* source does not exist<br>")
								
							}
						}
						
						var dest	= Server.Mappath(filepath)+ "\\src" + filebase + ext;
						var actimg = isNaN(value)?0:Number(value);
						var bFileExists = fs.FileExists(dest);
						
						// GENERATE THUMBNAIL HOLDERS
						switch(file_uploader)
						{
							case "PERSITS_upload":
							var imgpanel = "<table height=100 width=100 bgcolor=black cellspacing=1 align=left><tr><td style=font-size:12px;background-color:white align=center "+((actimg&1)==1?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
									  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^((1<<("+(arrformats.length)+"))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
									  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
									  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
									  +(bFileExists?"</a>":"")
									  +"<br><br>"+ext.toUpperCase()+"<br>Image<br>"
									  +"<br><input SIZE=1 type=FILE name=\"FILE"+filebase+"\" value=\""+Server.HTMLEncode(value)+"\"  onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
									  +"</td></tr></table>";
							break;
							case "PURE_upload":
							var imgpanel = "<table height=100 width=100 bgcolor=black cellspacing=1 align=left><tr><td style=font-size:12px;background-color:white align=center "+((actimg&1)==1?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
									  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^((1<<("+(arrformats.length)+"))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
									  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
									  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
									  +(bFileExists?"</a>":"")
									  +"<br><br>"+ext.toUpperCase()+"<br>Image<br><br>\r\n"
									  +"<input SIZE=1 type=button name=\"FILE"+filebase+"\" value=\""+Server.HTMLEncode(value)+"\"  onclick=main."+name+".value=(main."+name+".value|1);w=window.open(\"../includes/pure-upload/Upload-Base.ASP?imgID=FILE"+filebase+"\",\"_blank\"); onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">\r\n"
									  +"&nbsp;&nbsp;&nbsp;"
									  +"</td></tr></table>\r\n";
							break;
							default:
							var imgpanel = "";
						}
						
						var bitlength = actimg.toString(2).length;
						if(actimg>0)
							for(var j=0;j<bitlength;j++)
							{						
								imgpanel += 
										(bFileExists?(
										//"<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><br><img src="+filepath+"/img"+filebase+"_"+j+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"+arrformats[j]+"</a>"
										 "<a href=imgframer.asp?img=img"+filebase+"_"+j+".jpg&src=src"+filebase+".jpg&dim="+arrformats[j]+" target=_blank>"+arrformats[j]+"</a><br>"):"")
							}
						
						Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>"+imgpanel+"<input name="+name+" type=hidden value=\""+Server.HTMLEncode(value)+"\"><br></td></tr>");				
					break;
					case "gallery":
						///////////////////////////////////
						//    RESIZE UPLOADED IMAGERY    //
						///////////////////////////////////

						
						var filepath = "../"+_ws+"/images";
						var arrformats = format.split(",");
						
						var filebase 		= "";
						var fs				= Server.CreateObject("Scripting.FileSystemObject");
						var source_path		= Server.Mappath("../images/upload")+"\\";
						var ext             = ".jpg";


						function ARG()
						{
							this.argdata = new Array();
							this.type    = "";
							this.format  = "";
							this.attr    = "";
						}

						function parse_function_arg(_str)
						{
							var args = argsplitter(format);
							var arg  = argparser(args[1]);
							
							var format = args[0];
						}

						if(has_hooks(format))
						{
							var args = argsplitter(format);
							format = args[0];
							var arg  = argparser(args[1]);
							arg["size"] = arg["size"].split(arg_structure["size"]["sep"]);
						}
						else
						{
							var arg = new Array();
							arg["size"] = format.split(",");
							format = "param";
						}
						
						var arrformats = arg["size"];
						
						var dest	 	= ""
						var imgsubnr 	= 0;
						
						// IDEM CODE FOR IMG HANDLING
						if(rawform_arr && rawform_arr["nextact"] && rawform_arr["nextact"].indexOf("pure-upload")==0)
						{
							bUpload = true;
							
							var _str = rawform_arr["nextact"].split(":");
							var _name = _str[1];
							var _path = source_path+unescape(_str[2]);
							var FileCollection = new Array({"path":_path,"name":_name,ExtractFileName:ENUM_EXTRACT});
							if(bDebug) FILECOLLECTION_DUMP(FileCollection);
						}
						else
						{
							var FileCollection = Upload.Files;
							if(bDebug) FILECOLLECTION_DUMP(FileCollection);
						}
						
						if (bUpload)
						{					
							var bValidImage = false;
							for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
							{	
								var obj 		= objEnum.item();
								var ext 		= obj.path?obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase():".jpg";
								var imgnr 		= obj.name?Number(obj.name.substring(22,25)):0;
								var imgsubnr 	= obj.name?Number(obj.name.substring(26,28)):0;
								
								filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(imgsubnr,2);
								dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
								
								if(bDebug) Response.Write("filebase="+filebase+"<br>dest="+dest+"<br>"+obj.name.substring(26,28))
								
								if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
								{
									var jpeg = Server.CreateObject("Persits.Jpeg");
									
									for(var j=0;j<arrformats.length;j++)
									{
										jpeg.open( obj.path );
										jpeg.Quality = 85;
										jpeg.Interpolation = 2;
										
										if(bDebug) Response.Write("resizetoRect(jpeg,"+arrformats[j]+")<br>");
										
										resizetoRect(jpeg,arrformats[j]);
										jpeg.Sharpen(1,105);
										var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+j+".jpg";
										jpeg.Save(savefile);
										
										bValidImage = true;
										if(bDebug) Response.Write("IMAGE SAVED: "+savefile+"<br><br>")
									}
									
									value = (isNaN(value)?0:Number(value)) | (1<<imgsubnr);  // alter bitmap !
									if(bDebug)
										Response.Write("BITMAP: ["+zerofill(value.toString(2),16)+"]<br><br>")
								}
							}
							
							if(bValidImage)
							{
								var source_name = "";
								//if(Upload.Files.Count == 1)
									for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
										source_name = objEnum.item().ExtractFileName();
								var source = source_path+source_name;
								
								// DELETE PREVIOUS FILE (SINCE OVERWRITING ISN'T PERMITTED)
								try {fs.DeleteFile(dest)}catch(e){if (bDebug) Response.Write("*delete* "+dest+": "+e)};
								
								for(var j=0;i<1000 && fs.FileExists(dest)==false;j++)
									if(fs.FileExists(source))
									{
										try {fs.MoveFile(source,dest)}catch(e){if (bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
										if(bDebug)
											Response.Write("IMAGE MOVED: source:"+source+" TO dest:"+dest+"<br><br>");
									}
							}
						}
						
						//Response.Write(source+"<br><br>"+dest+"<br><br>")
						
						var actimg = isNaN(value)?0:Number(value);
						
						var bitlength = actimg==0?1:(actimg.toString(2).length+(actimg.toString(2).length<(    arg["len"]?Number(arg["len"]):24     )?1:0));
						var imgpanel = new Array(bitlength);
						
						for(var b=0;b<bitlength;b++)
						{
							filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(b,2)
							dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
							var bFileExists = fs.FileExists(dest);
							
							switch(file_uploader)
							{
								case "PERSITS_upload":
								imgpanel[b] = ((b%5)==0 && b>0?"</td></tr><tr><td>":"")
											  +"<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&(1<<b))?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
											  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^(1<<"+b+");main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
											  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
											  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
											  +(bFileExists?"</a>":"")
											  +"<br><br>"+ext.toUpperCase()+"<br>Image<br><br>"
											  +"<input SIZE=1 name=\"FILE"+filebase+"\" value=\""+Server.HTMLEncode(value)+"\"  onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
											  +"</td></tr></table>";
								break;
								case "PURE_upload": 
								imgpanel[b] = ((b%5)==0 && b>0?"</td></tr><tr><td>":"")
											  +"<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&(1<<b))?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
											  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^(1<<"+b+");main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
											  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
											  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
											  +(bFileExists?"</a>":"")
											  +"<br><br>"+ext.toUpperCase()+"<br>Image<br><br>\r\n"
											  +"<input SIZE=1 type=button name=\"FILE"+filebase+"\" value=\""+Server.HTMLEncode(value)+"\"  onclick=main."+name+".value=(main."+name+".value|1);w=window.open(\"../includes/pure-upload/Upload-Base.ASP?imgID=FILE"+filebase+"\",\"_blank\"); onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
											  +"</td></tr></table>";
								break;
								default:
								imgpanel[b] = "";
							}
							
							
							for(var j=0;j<arrformats.length;j++)
							{
								//imgpanel[b] += (bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/img"+filebase+"_"+j+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank><small>"+arrformats[j]+"</small></a><br>"):"")
								
								imgpanel[b] += (bFileExists?("<a href=imgframer.asp?img=img"+filebase+"_"+j+".jpg&src=src"+filebase+".jpg&dim="+arrformats[j]+" target=_blank><small>"+arrformats[j]+"</small></a><br>"):"")
							}
						}
						
						Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>"
						+"<table cellspacing=0 cellpadding=0><tr><td valign=top>"+imgpanel.join("</td><td width=10>&nbsp;</td><td valign=top>")+"</td></tr></table>"
						+"<input name="+name+" type=hidden value=\""+Server.HTMLEncode(value)+"\"><br></td></tr>");				
					break;			
					case "date":
						var df = format
						if(df)
						{
							df = df.replace(/%d/g,"dd");
							df = df.replace(/%m/g,"mm");
							df = df.replace(/%Y/g,"yyyy");
							df = df.replace(/%H/g,"hh");
							df = df.replace(/%M/g,"mm");
							df = df.replace(/%S/g,"dd");
							df = df.replace(/%/g,"");
						}
						var vdate = bSubmitted==true?value:(typeof(value)=="date"?new Date(value).format(format):(value?value.toString().toDate("%Y-%m-%d %H:%M:%S").format(format):""));
						
						Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(vdate)+"\" size=18> "+(df?("["+df+"]"):"")+"</td></tr>");
					break;
					case "multistring":
						value = value?value.split(","):"";
						for(var j=0;j<value.length;j++)
							value[j] = unescape(value[j]);
					case "string":
						if(has_hooks(format))
						{
							var args = argsplitter(format);
							format = args[0];
							var arg  = argparser(args[1]);
						}
					
						switch(format)
						{
							case "texturl":
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
								var j = 0;
								Response.Write("<input name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode(value[j])+"\" "+(attr?attr:"size=18")+">")
								var j = 1;
								Response.Write("<input name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode(value[j])+"\" "+(attr?attr:"size=18")+">")
								Response.Write("</td></tr>");						
							break;
							case "textarea":
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>")
								if(typeof(value)=="string")
									Response.Write("<"+"textarea name="+name+" style=width:265px;height:100px;>"+value+"</"+"textarea>");
								else
								{
									for(var j=0;j<value.length;j++)
										if(value[j]) Response.Write("<"+"textarea name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" style=width:265px;height:100px;>"+value[j]+"</"+"textarea>");
									Response.Write("<"+"textarea name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" style=width:265px;height:100px;>"+(value[j]?value[j]:"")+"</"+"textarea>");
								}
								Response.Write("</td></tr>");
							break;
							case "rte_img":
								// IMAGE UPLOAD PANE
								
								///////////////////////////////////
								//    RESIZE UPLOADED IMAGERY    //
								///////////////////////////////////
								
								var FileCollection = Upload.Files;
								var filepath = "../"+_ws+"/images";
								var arrformats = format.split(",");
								
								var fs			= Server.CreateObject("Scripting.FileSystemObject");
								var source_path	= Server.Mappath("../images/upload")+"\\";
								var filebase 	= "";
								var dest	 	= ""
								var imgsubnr 	= 0;
								
								var resarr = arg["res"].split(",")
								
								if (bUpload)
								{
									var bValidImage = false;
									for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
									{
										var obj = objEnum.item();
										var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
										//var imgnr = Number(obj.name.substring(4,7));
										//imgsubnr =  Number(obj.name.substring(8,10));
										var imgnr 		= Number(obj.name.substring(22,25));
										var imgsubnr 	= Number(obj.name.substring(26,27));
										
										var filename = obj.path.substring(obj.path.lastIndexOf("\\")+1,obj.path.lastIndexOf("."))
										
										filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(imgsubnr,2)
										dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
										
										if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
										{
											var jpeg = Server.CreateObject("Persits.Jpeg");
											
											jpeg.open( obj.path );
											jpeg.Quality = 85;
											jpeg.Interpolation = 2;
											resizetoRect(jpeg,resarr[imgsubnr]);
											jpeg.Sharpen(1,105);
											var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+j+"_"+filename+".jpg";
											jpeg.Save(savefile);
											
											bValidImage = true;
											if(bDebug)
												Response.Write("IMAGE SAVED: "+savefile+"<br><br>")
										}
									}
									
									if(bValidImage)
									{
										var source_name = "";
										//if(Upload.Files.Count == 1)
											for (var objEnum=new Enumerator(Upload.Files); !objEnum.atEnd() ; objEnum.moveNext())
												source_name = objEnum.item().ExtractFileName();
										var source = source_path+source_name;
										
										// DELETE PREVIOUS FILE (SINCE OVERWRITING ISN'T PERMITTED)
										try {fs.DeleteFile(dest)}catch(e){if (bDebug) Response.Write("*delete* "+dest+": "+e)};
										
										for(var j=0;i<1000 && fs.FileExists(dest)==false;j++)
											if(fs.FileExists(source))
											{
												try {fs.MoveFile(source,dest)}catch(e){if (bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
												if(bDebug)
													Response.Write("IMAGE MOVED: source:"+source+" TO dest:"+dest+"<br><br>");
											}
									}
								}
								
								//Response.Write(source+"<br><br>"+dest+"<br><br>")
								
								var imgpanel = new Array(resarr.length);
								
								for(var b=0;b<resarr.length;b++)
								{
									filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(b,2)
									dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
									var bFileExists = fs.FileExists(dest);
									
									imgpanel[b] = //((b%5)==0 && b>0?"</td></tr><tr><td>":"")
												  //+"<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&(1<<b))?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
												  //+"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^(1<<"+b+");main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
												  //+(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
												  //+"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
												  //+(bFileExists?"</a>":"")
												  
												   "<small>"+resarr[b]+" JPG</small><br><input SIZE=1 name=\"FILE"+zerofill(curfieldID,3)+"_"+zerofill(b,2)+"\" type=FILE value=\""+Server.HTMLEncode(value)+"\"  onchange=submitForm();main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
												  +"<br>"
												  //+"</td></tr></table>";
									
								}
								
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>"
								+"<table cellspacing=0 cellpadding=0><tr>"
								+"<td><iframe src=\"DATA_ImagePick.asp?dt="+Request.QueryString("dt")+"&id="+Request.QueryString("id")+"&idir="+_ws+"&i="+curfieldID+"&iwidth=500\" width=\"570\" height=\"150\"></iframe></td>"
								+"<td valign=top>"+imgpanel.join("<br>")+"</td>"
								+"</tr></table>"
								+"</td></tr>");	




							case "rte":
								// M U L T I B R O W S E R   C M S
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
								
								if(bIncludeRichtextLib)
								{
									var crlf = "";
									Response.Write("<script language=\"JavaScript\" type=\"text/javascript\">"+crlf);
									//Usage: writeRichText(fieldname, html, width, height, buttons, readOnly)
									Response.Write("writeRichText('"+name+"', '"+(value && typeof(value)=="string"?value.replace(/\r\n/g,"\\r\\n").replace(/'/g,"\\'"):"")+"', 400, 200, true, false);"+crlf);
									Response.Write("</script>"+crlf);
								}
								else
									Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><"+"textarea name="+name+" "+(attr?attr:"style=width:265px;height:100px;")+">"+value+"</"+"textarea></td></tr>");				
								
								Response.Write("</td></tr>");
								richtext_names[format] = richtext_names[format]?(","+name):name;
							break;
							case "tinymce_img":
							case "tinymce":
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0 "+(attr?attr:"style=width:500px;height:200px;")+"><"+"textarea name="+name+" "+(attr?attr:"style=width:500px;height:200px;")+">"+value+"</"+"textarea></td></tr>");				
								richtext_names[format] = richtext_names[format]?(","+name):name;
							break;
							default:
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
								
								if(typeof(value)=="string")
									Response.Write("<input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" "+(attr?attr:"size=40")+">");
								else
								{
									for(var j=0;j<value.length;j++)
										if(value[j]) Response.Write("<input name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode(value[j])+"\" "+(attr?attr:"size=40")+">")
									Response.Write("<input name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode(value[j])+"\" "+(attr?attr:"size=40")+">")
								}
								Response.Write("</td></tr>");
						}
					break;
					
					case "csv":
					
						// TODO
					
					break;
					
					case "multinumber":
						value = value?value.split(","):new Array();
					case "number":

						if(has_hooks(format))
						{
							var args = argsplitter(format);
							format = args[0];
							var arg  = argparser(args[1]);
						}
						
						Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>")
						
						
						switch(format.toLowerCase())
						{
							case "eur":
								if(typeof(value)=="object")
								{
									for(var j=0;j<value.length;j++)
										if(value[j]) Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+(typeof(value[j])=="string" || (!bSubmitted && value[j].length>0)?(Number(value[j])/100).toFixed(2).replace(/\./,","):value[j])+"\" "+(attr?attr:"size=18")+">");
									Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\"\" "+(attr?attr:"size=18")+">");
								}
								else
								{
									Response.Write("<input name=\""+name+"\" type=text value=\""+(typeof(value)=="number" || (!bSubmitted && value.length>0)?(Number(value.replace(/,/,"."))/100).toFixed(2).replace(/\./,","):value)+"\" "+(attr?attr:"size=18")+">");
								}
								Response.Write(" [...####,##]</td></tr>");						
							break;
							case "check":
								
								var options = arg && arg["opt"]?csv2array(unescape(arg["opt"]),(arg["sep"]?arg["sep"]:"|")):new Array();
								var len = arg && arg["len"]?Number(arg["len"])-1:( options.length>0?options.length-1:value.toString(2).length )
								
								for(var j=0;j<=len;j++)
									Response.Write("<input name=CHK"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" value=1 type=checkbox "+(((Number(value)>>j)&1)?"checked":"")+" "+(attr?attr:"")+">"+(options[j]?options[j]:"")+" &nbsp;");						
							break;
							case "input":
								var options = arg["opt"]?csv2array(unescape(arg["opt"])):new Array();
								var len = arg["len"]?Number(arg["len"])-1:( options.length>0?options.length-1:value.toString(2).length )
								
								for(var j=0;j<=len;j++)
									if(value[j] || arg["len"] || options.length>0) Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode( value[j] )+"\" "+(attr?attr:"size=40")+">"+(options[j]?options[j]:"")+" &nbsp;");
								
								if(arg["search"])
									Response.Write("<a href=dbsearch.asp target=_blank><img src=../images/ii_zoom.gif border=0></a>")
								
								//Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode( value[j] )+"\" "+(attr?attr:"size=40")+">"+(options[j]?options[j]:"")+" &nbsp;");
							break;
							default:
								for(var j=0;j<value.length;j++)
									if(value[j]) Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode( value[j] )+"\" "+(attr?attr:"size=40")+">");
								Response.Write("<input name=CSV"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" type=text value=\""+Server.HTMLEncode( value[j] )+"\" "+(attr?attr:"size=40")+">");
							break;
						}
						
						
					break;	
				
					case "multiref":
						value = rawdata[i]?rawdata[i].split(","):new Array(new Number(rawdata[i]));
						for(var j=value.length;j>=0 && !value[j-1];j--)
							if(!value[j])
								value.length = j>0?(j-1):0;
					case "ref":
						if(format)
						{
							var args = argsplitter(format);
							if(args[0]=="combo")
							{
								var arg  = argparser(args[1]);
								var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
								
								arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(",").join(",\" \",")+")"):"ds_title";
								var sSQL = "select ds_id,"+arg["col"]+" from "+_db_prefix+masterdb+" where ds_rev_id = "+(arg["ds"]?arg["ds"]:"ds_id")+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1]+" order by ds_title";
								
								
								if(arg["opt"])
									var arr = csv2array(unescape(arg["opt"]));
								else
								{
									if(bDebug) Response.Write(sSQL+"<br>");
									var arr = oDB.getrows(sSQL);
								}	
									
								var bArray = typeof(value)=="array" || typeof(value)=="object";
								
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
								
								if(!bArray)
									value = new Array(new String(value));
								
								var k=0;
								if(bArray)
									for(var k=0;k<value.length;k++)
									{
										//Response.Write("*k="+k+" "+value[k]+"*<br>");
										
										if(bSubmitted)
											Session(dt+"_"+curfieldID+"_"+(bArray?k:"")+type) = value[k];
										var sessionchoice = Session(dt+"_"+curfieldID+"_"+(bArray?k:"")+type);
										
										Response.Write("<select name="+(bArray?("ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(k,3)):name)+" "+attr+">\r\n");
										Response.Write("\t<option value=\"\">\r\n");
										
										for(var j=0;j<arr.length;j+=2)
											Response.Write("\t<option value=\""+arr[j]+"\""+((value[k]?arr[j]==value[k]:arr[j]==sessionchoice)?" SELECTED":"")+">"+(arr[j+1]?arr[j+1]:("["+arr[j]+"]"))+"\r\n");
										Response.Write("</select>\r\n");

									}
								
								//Response.Write("*k="+k+" "+value[k]+"*<br>");
								
								if(bSubmitted)
									Session(dt+"_"+curfieldID+"_"+(bArray?k:"")+type) = value[k];
								var sessionchoice = Session(dt+"_"+curfieldID+"_"+(bArray?k:"")+type);
								
								Response.Write("<select name="+(bArray!="string"?("ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(k,3)):name)+" "+attr+">\r\n");
								Response.Write("\t<option value=\"\">\r\n");
								
								for(var j=0;j<arr.length;j+=2)
									Response.Write("\t<option value=\""+arr[j]+"\""+((value[k]?arr[j]==(bArray?value[0]:value):arr[j]==sessionchoice)?" SELECTED":"")+">"+(arr[j+1]?arr[j+1]:("["+arr[j]+"]"))+"\r\n");

								Response.Write("</select>\r\n");
								
								if(arg["dblink"])
									Response.Write(" <a href=01_edit_dlg.asp?id="+arg["dblink"].encrypt("nicnac")+" target=_blank>link</a>")
								
								Response.Write("</td></tr>");
							}
							else
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>unknown function</td></tr>");
						}
						else
							Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>no display condition</td></tr>");
					break;
					default:
						Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" "+(attr?attr:"size=40")+"> error</td></tr>");
				}
			}
			//else
			//	Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" "+(attr?attr:"size=40")+"></td></tr>");
			Response.Write("\r\n");
		}
		Response.Write("</table>\r\n<br>\r\n");
		
		Response.Write(commands);
		
		Response.Write("<input type=hidden name=nextact>\r\n");
		
		Response.Write("</center>\r\n</form>\r\n");
	}	

	Response.Write("<!-- R I C H T E X T   I N I T I A L I S E R S -->\r\n\r\n");
	
	if(bIncludeRichtextLib)
	{
		var beenhere = new Array();
		for(var i=0;i<fieldID.length;i++)
		{
			var name 	 = fields.item(i).getAttribute("name");
			var columnID = fields.item(i).text
			
			if(oSETTINGS.byID["FIELD_PROPERTIES"] && oSETTINGS.byID["FIELD_PROPERTIES"][columnID])
			{
				var type  = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["type"];
				var format = oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["format"];
				format=(format=="richtext"?DefaultRichtextLib:format);
				
				// TODO keep for fieldheader !!!!!!!!!!
				var en = enumsettings[fields.item(i).text];
				var enl = enumlistsettings[fields.item(i).text];
				
				if(type=="string" && beenhere[format]!=true)
				{
					if(has_hooks(format))
						format = format.substring(0,format.indexOf("("));
					
					switch(format)
					{
						case "rte_img":
						case "rte":
							Response.Write("<!-- R T E -->\r\n");
							Response.Write("<script language=\"JavaScript\" type=\"text/javascript\">\r\n")
							Response.Write("<!--\r\n")
							Response.Write("function submitForm() {\r\n")
							//make sure hidden and iframe values are in sync before submitting form
							
							var arr = richtext_names[format].split(",");
							for(var j=0;j<arr.length;j++)
								Response.Write("updateRTE('"+arr[j]+"');\r\n"); //use this when syncing only 1 rich text editor ("rtel" is name of editor)
							
							//updateRTEs(); //uncomment and call this line instead if there are multiple rich text editors inside the form
							//Response.Write("alert(\"Submitted value: \"+document.myform.rte1.value)\r\n") //alert submitted value
							Response.Write("return true;\r\n"); //Set to false to disable form submission, for easy debugging.
							Response.Write("}\r\n");
							
							//Usage: initRTE(imagesPath, includesPath, cssFile)
							//Response.Write("initRTE(\"../includes/images/\",\"../includes/\",\"\");\r\n");
							//Response.Write("alert('init done');\r\n")
							Response.Write("//-->\r\n")
							Response.Write("</script>\r\n");
						break;
						case "tinymce_img":
						case "tinymce":
							Response.Write("<!-- R T E -->\r\n");
							%>
							<script>
									tinyMCE.init({
										mode : "exact",
										elements : "<%=richtext_names[format]%>",
										theme : "advanced",
										language : "<%=_language.substring(0,2)%>",
										height : 500,
										width : 540,
										plugins : "table,advhr,advimage,advlink,insertdatetime,preview,zoom,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,-emotions,fullpage",
										theme_advanced_buttons1_add_before : "save,newdocument,separator",
										theme_advanced_buttons1_add : "fontselect,fontsizeselect",
										theme_advanced_buttons2_add : "separator,insertdate,inserttime,preview,separator,forecolor,backcolor",
										theme_advanced_buttons2_add_before: "cut,copy,paste,pastetext,pasteword,separator,replace,separator",
										theme_advanced_buttons3_add_before : "tablecontrols,separator",
										theme_advanced_buttons3_add : "emotions,iespell,flash,separator,print,separator,ltr,rtl,separator,fullscreen,fullpage",
										theme_advanced_toolbar_location : "top",
										theme_advanced_toolbar_align : "left",
										theme_advanced_path_location : "bottom",
										content_css : "example_full.css",
										plugin_insertdate_dateFormat : "%d-%m-%Y",
										plugin_insertdate_timeFormat : "%H:%M:%S",
										extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
										external_link_list_url : "example_link_list.js",
										external_image_list_url : "example_image_list.js",
										flash_external_list_url : "example_flash_list.js",
										file_browser_callback : "fileBrowserCallBack",
										theme_advanced_resize_horizontal : false,
										theme_advanced_resizing : true,
										apply_source_formatting : true
									});
							</script>
							<!-- /TinyMCE -->
							<!-- Self registrering external plugin, load the plugin and tell TinyMCE where it's base URL are -->
							<script language="javascript" type="text/javascript" src="../includes/tinymce/jscripts/tiny_mce/plugins/emotions/editor_plugin.js"></script>
							<!--script language="javascript" type="text/javascript">tinyMCE.setPluginBaseURL('emotions', '../includes/tinymce/jscripts/tiny_mce/plugins/emotions');</script-->
							<script language="javascript" type="text/javascript">tinyMCE.setPluginBaseURL('emotions', '../includes/tinymce/jscripts/tiny_mce/plugins/emotions');</script>
							<%
						break;
					}
				}
				else
					beenhere[format]==true;	
			}
		}
	}

	if (bSubmitted)
	{
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");
	}
	


	Response.End()

// FUNCTIONS

	function fieldheader(curfieldID,fldesc,name,en,enl)
	{
		
		var columnID = "["+curfieldID+"]";
		var bMandatory = name.substring(0,3)=="mn_";
		var bQuickField = enumheader[DBfieldID[i]]?true:false;
		var color = bQuickField?(bMandatory?"#EFD0D0":"#FFE0E0"):(bMandatory?"#E0E0E0":"#F0F0F0");
		
		var _fimglink = "";
		if(settingspage)
		{	
			var bProp = (oSETTINGS.byID["FIELD_PROPERTIES"][columnID] && oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["columnID"]?1:0)
			          + (oSETTINGS.byID["LIST_PROPERTIES"][columnID]  && oSETTINGS.byID["LIST_PROPERTIES"][columnID]["columnID"]?2:0)
			var _fimg    = (bProp & 1)?"ii_longbuttonblue.gif":"ii_longbuttonbluestripe.gif";
			var _faltimg = (bProp & 1)?"ii_longbuttonblue_alt.gif":"ii_longbuttonbluestripe_alt.gif";

			var _fdt = oSETTINGS.PROPs["FIELD_PROPERTIES"]		
			_fid = (bProp & 1)?oSETTINGS.byID["FIELD_PROPERTIES"][columnID]["prop_dsid"]:0;


			_fimglink += "<a href="+zerofill(settingspage,2)+"_"+(bProp?"rec":"cfg")+"_dlg.asp?dt="+(_fdt?_fdt.toString().encrypt("nicnac"):"")+"&ds="+Request.QueryString("dt").Item+"&id="+(_fid?_fid.toString().encrypt("nicnac"):"")+((bProp & 2)?"":"&i="+curfieldID+"&s=FIELD_PROPERTIES")+" target=_blank>"
			_fimglink += "<img src=../images/"+_fimg+" onmouseover=this.src='../images/"+_faltimg+"' onmouseout=this.src='../images/"+_fimg+"' border=0>"
			_fimglink += "</a>";
		}
		return "<td bgcolor="+color+" title=\"["+curfieldID+"]"+fldesc+"\" align=right>"+name+"&nbsp;"+_fimglink+"</td>";
	}

	function argsplitter(_str)
	{
		var _spl = new Array();
		if(_str)
		{
			var _parr = new String(_str).split("(");
			_spl[0] = _parr[0];
			_spl[1] = _parr[1].substring(0,_parr[1].indexOf(")"));
			var argset = argparser(_spl[1]);
		}
		return _spl;
	}

	function argparser(_str)
	{
		var _enum = new Array();
		if(_str)
		{
			_str = _str.charAt(0)=="\"" ? _str.split("\"")[1] : "id="+_str;
			var _parr = new String(_str).split(/,|=/);
			
			// HANDLE FIRST ARGUMENT
			for(var _i=0;_i<_parr.length;_i+=2)
			{
			   _enum[_parr[_i]] = _enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1];
			   Response.Write("_enum["+_parr[_i]+"] = "+_enum[_parr[_i]]+"<br>");
			}
			
			// HANDLE SECOND ARGUMENT
			var sep = _enum["sep"] ? _enum["sep"] : "|";
			for(var _i=0;_i<_parr.length;_i+=2)
			{
				if(_parr[_i+1].length>1 && _parr[_i+1].indexOf(sep)>=0) _parr[_i+1] = _parr[_i+1].split(sep);
			}
			//collection_dump(_parr)
		}
		return _enum;
	}

	function formatInteger( integer, pattern )
	{
		var result = '';
		
		integerIndex = integer.length - 1;
		patternIndex = pattern.length - 1;
		
		while ( (integerIndex >= 0) && (patternIndex >= 0) )
		{
			var digit = integer.charAt( integerIndex );
			integerIndex--;
			
			// Skip non-digits from the source integer (eradicate current formatting).
			if ( (digit < '0') || (digit > '9') )  continue;
			
			// Got a digit from the integer, now plug it into the pattern.
			while ( patternIndex >= 0 )
			{
				var patternChar = pattern.charAt( patternIndex );
				patternIndex--;
				
				// Substitute digits for '#' chars, treat other chars literally.
				if ( patternChar == '#' )
				{
					result = digit + result;
					break;
				}
				else
				{
					result = patternChar + result;
				}
			}
		}
		
		return result;
	}

	function qformat(value,type,format)
	{
		switch(type)
		{
			case "date": 
				return rawdata[i]?quote(rawdata[i].toString().toDate(format).format("%Y-%m-%d %H:%M:%S")):"null";
			default: return quote(value);
		}
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
			xmlDoc.loadXML("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?><ROOT><row><field name=\"error\">"+txt+"</field></row></ROOT>")
		}
		return xmlDoc
	 }

	function resizetoRect(picobj,size)
	{
		var splitarr = size.split(":");
		var sizes = splitarr[0].split("x");
		var sizex = Number(sizes[0]);
		var sizey = Number(sizes[1]);
		
		if(!isNaN( splitarr[1]) )
			picobj.Quality = Number(splitarr[1]);
		
		if(isNaN(sizey) || sizey==0)
		{
			resizetoWidth(picobj,sizex);
			return;
		}
		
		if(isNaN(sizex) || sizex==0)
		{
			resizetoHeight(picobj,sizey);
			return;
		}		
		
		if (picobj.height==sizey && picobj.width==sizex)
			return;
			
		maxheight = sizey;
		maxwidth = sizex;		
		
		if (  (picobj.height*sizex/picobj.width) < maxheight )
			resizetoHeight(picobj,sizey,maxwidth);
		else
			resizetoWidth(picobj,sizex,maxheight)
	}	
	
	function resizetoSquare(picobj,size)
	{
		if (picobj.height==size && picobj.width==size)
			return;
			
		maxheight = size;
		maxwidth = size;
		
		if (  (picobj.height*size/picobj.width) < maxheight )
			resizetoHeight(picobj,size,maxwidth);
		else
			resizetoWidth(picobj,size,maxheight)
	}
	
	function resizetoHeight(picobj,height,maxwidth)
	{
		if(picobj.height<=1 || picobj.width<=1 || height<=1) return;
		
	    picobj.width  *= height/picobj.height;
		picobj.height = height;
		
		if (maxwidth && picobj.width>maxwidth)
		{
			xoffset = (picobj.width-maxwidth)/2
			picobj.Crop(xoffset, 0, maxwidth+xoffset, height );
		}
	}
	
	function resizetoWidth(picobj,width,maxheight)
	{
		picobj.height *= width/picobj.width;
		picobj.width  = width;
		
		if (maxheight && picobj.height>maxheight)
		{
			yoffset = (picobj.height-maxheight)/2
			picobj.Crop(0, yoffset, width, maxheight+yoffset);
		}
	}
	
	function ENUM_EXTRACT()
	{
		return this.path.substring(this.path.lastIndexOf("\\")+1,this.path.length);
	}
	
	function FILECOLLECTION_DUMP(_coll)
	{
		if(typeof(_coll)=="undefined") return;
		for (var objEnum=new Enumerator(_coll); !objEnum.atEnd() ; objEnum.moveNext())
		{	
			var obj = objEnum.item();
			if(typeof(obj)=="object")
			{
				var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
				var imgnr 		= Number(obj.name.substring(22,25));
				var imgsubnr 	= Number(obj.name.substring(26,27));
		
				//Response.Write("path="+obj.path+"<br>name="+obj.name+"<br>ext="+ext+"<br>imgnr="+imgnr+"<br>ExtractFileName()="+obj.ExtractFileName()+"***<br>");
			}							
		}
	}
	
	function has_hooks(_str) { return _str && _str.indexOf("(")>0 && _str.indexOf(")")>0 }
	
	function has_json(_str) { return _str && (_str.indexOf("{")==0) && (_str.indexOf("}")==(_str.length-1)) }
	
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
%>