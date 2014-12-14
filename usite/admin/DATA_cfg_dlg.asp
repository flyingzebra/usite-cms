<%
	var bDebug = false;
	var bMultiPart = true;
	var bUpload = false;
	var bSaved  = false;
	
	var bIncludeRichtextLib = true;
	var DefaultRichtextLib = "rte";

	
	try 
	{
		var Upload = Server.CreateObject("Persits.Upload.1");
		var FormCollection = Upload.Form;
		bUpload = true;
	}
    catch(e)
	{
		function Upload()
		{
			this.Form = UploadForm;
		}
		
		function UploadForm() {}
	}
	try {var Count = Upload.Save(Server.Mappath ("../images/upload")); bSaved = true; } catch(e) {}
	var bSubmitted = bMultiPart==true && bUpload==true?!new Enumerator(FormCollection).atEnd():(Request.TotalBytes==0?false:true);
	
	



	var _uid = Session("uid");
	var _dir = Session("dir");

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
		if(str && str!=null && typeof(str)=="string")
			str = str.replace(/\x22/g,"\\\"");
		else
			str = str || typeof(str)=="number"?str:"";
		return "\""+str+"\"";
	}
	
	/*
	var dt = Request.QueryString("dt").Item?Number(Request.QueryString("dt").Item.toString().decrypt("nicnac")):-1;
	var id = Request.QueryString("id").Item?Number(Request.QueryString("id").Item.toString().decrypt("nicnac")):-1;
	var s = Request.QueryString("s").Item;
    var fid = Request.QueryString("fid").Item;	
	var ds = oDB.get("select rev_id from usite_review where rev_rt_typ = 22 and rev_title=\""+s+"\" and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 LIMIT 0,1")
    */

Response.Write("*")

	var s = Request.QueryString("s").Item;
	var dt = oDB.get("select rev_id from usite_review where rev_rt_typ = 22 and rev_title=\""+s+"\" and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 LIMIT 0,1")
	var ds = Request.QueryString("dt").Item?Number(Request.QueryString("dt").Item.toString().decrypt("nicnac")):-1;
    var fid = Request.QueryString("fid").Item;
	

	
	var sSQL = "select ds_id from usite_paramset where ds_rev_id="+(dt?dt:-1)+" and ds_title="+ds+" and ds_desc = \"["+fid+"]\""
	var id = oDB.get(sSQL);
	
	//Response.Write("s="+s+" dt="+dt+" ds="+ds+" fid="+fid+" id="+id)
	

	if(!ds)
		Response.Write("NO RECORDS. TODO: CREATE A NEW ONE")

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
		
		//Response.Write("<p style='font-size:70%'>");
		
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
		oSETTINGS.id = dt;
		oSETTINGS.load();
		
		var enumsettings = new Array();
		if(oSETTINGS.settingdata["FIELD_PROPERTIES"].length>0)
			for(var i=0;i<oSETTINGS.settingdata["FIELD_PROPERTIES"].length;i+=oSETTINGS.paramtablefld.length)
				enumsettings[oSETTINGS.settingdata["FIELD_PROPERTIES"][i+1]] = i+1;
				
		var enumlistsettings = new Array();
		if(oSETTINGS.settingdata["LIST_PROPERTIES"].length>0)
			for(var i=0;i<oSETTINGS.settingdata["LIST_PROPERTIES"].length;i+=oSETTINGS.paramtablefld.length)
				enumlistsettings[oSETTINGS.settingdata["LIST_PROPERTIES"][i+1]] = i+1;
		
		var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
		var enumfld = new Array();
		for (var i=0; i<tablefld.length ; i++)
			enumfld[tablefld[i]] = i;		
		

	var sub_topicnames =  oSETTINGS.settingnames;
	var sub_topictitles = oSETTINGS.settingnames;
	var ext = zerofill(ds_type,2)+"_cfg_dlg.asp?dt="+Request.QueryString("dt").Item+"&id="+Request.QueryString("id").Item+"&fid="+Request.QueryString("fid").Item+"&s=";
	var sub_menulinks =   [ext+oSETTINGS.settingnames[0]
	                       ,ext+oSETTINGS.settingnames[1]
						   ,ext+oSETTINGS.settingnames[2]]


	
%>



<div id="topheader">
	<div id="tabheader">
		<ul>
		<%
			for(i=0;i<sub_topicnames.length;i++)
				//if (oDB.permissions([sub_topicnames[i]]))
					Response.Write("<li"+(oSETTINGS.settingnames[i]==s?" id=current":"")+"><a href="+sub_menulinks[i]+" title=\""+sub_topicnames[i]+"\" style=font-size:x-small>"+sub_topictitles[i].split("<br>").join(" ")+"</a></li>")
		%>
		</ul>
	</div>
</div>




<%

	if(Request.QueryString("id").Item)
		var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
		
	if(Request.QueryString("ds").Item)
		var ds = Number(Request.QueryString("ds").Item.toString().decrypt("nicnac"));		

	var overview = oDB.getrows(sSQL);
	if(bDebug)
		Response.Write("<br><br>" + sSQL);


	//////////////////////////////////////////////////////////////
	//  P A G E   N A V I G A T I O N  I N I T I A L I S E R S  //
	//////////////////////////////////////////////////////////////
	
	var orderby	= Number(Request.QueryString("orderby").Item);
	var _extraurl = (dt?("&id="+dt):"")+(orderby?("&orderby="+orderby):"")
	
	var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):1;
	var spp = 10;  // MAX NAVIGATIONBAR WIDTH
	var ipp = 25; // ITEMS PER PAGE
	var maxrec = 10000;
	
	// Q U E R Y   D A T A S E T
 	
	var whereclause = "where rev_id = ds_rev_id and rev_rt_typ = 22 and rev_dir_lng = \""+_ws+"\" and ds_title = "+ds+" and rev_title = \""+s+"\" and rev_pub & 9 = 1";
	
	var lSQL = "select count(*) from "+_db_prefix+masterdb+","+_db_prefix+"review "+whereclause;
	var overviewlength = oDB.get(lSQL)*tablefld.length;
	//Response.Write(lSQL+"<br><br>")	
	
	var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(pag-1)*ipp+","+ipp);	
	if (orderby && orderby==Math.floor(orderby))	
		var orderclause = isNaN(orderby)?"":("order by (ds_pub=0 && LENGTH(ds_title)=0) desc,"+oSETTINGS.paramtablefld[Math.abs(orderby)-1]+" "+(orderby<0?"desc":"asc"));
	else
		var orderclause = isNaN(orderby)?"":("order by (ds_pub=0 && LENGTH(ds_title)=0) desc,("+oSETTINGS.paramtablefld[Math.floor(Math.abs(orderby))-1]+" & "+(1<<Math.round(-1+10*(Math.abs(orderby)-Math.floor(Math.abs(orderby)))))+") "+(orderby<0?"desc":"asc"));
	
	var sSQL = "select "+oSETTINGS.paramtablefld.join(",")+" from "+_db_prefix+masterdb+","+_db_prefix+"review "+whereclause
	var overview = oDB.getrows(sSQL);
	if(bDebug)
		Response.Write("<br><br>" + sSQL);




	/////////////////////////////////////
	//  P A G E   N A V I G A T I O N  //
	/////////////////////////////////////

	bSpiderSafeURL = typeof(SiderSafeURL)=="string"; 

	var n = Math.round(overviewlength/(ipp*tablefld.length)+0.499);
	var begin = 0;

	var pgnav = "";	
	if (pag == 0)
		pgnav += "<font color=#800000 title='"+(_T["max_items"]?_T["max_items"].replace(/_#_/g,maxrec):"")+"'><b>["+_T["nav_all"]+"]</b></font>&nbsp;";
	else
	{
		pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+"_Q_pag_E_0"+SpiderSafeExt+_extraurl+""):"?pag=0"+_extraurl+"")+" title='"+(_T["nav_max_items"]?_T["nav_max_items"].replace(/_#_/g,maxrec):"*nav_max_items*")+"' class=small>["+_T["nav_all"]+"]</a>&nbsp; ";
				
		//if (pag>1)
			pgnav += "<a href=?pag=1"+_extraurl+" class=small>["+_T["nav_start"]+"]</a>&nbsp; "
			      +  "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag-(pag>1?1:0))+_extraurl+"><img src=../images/lnav.gif border=0 title='"+_T["nav_prev"]+"' style=vertical-align:text-top></A>&nbsp;&nbsp;";
		begin = pag-Math.round(spp/2)<0 ? 0 : (pag-Math.round(spp/2));
		begin = spp/2>(n-pag-1) ? (n-spp) : begin;
		begin = begin<=0 ? 0 : begin;
	}

	for( var i=begin+1 ; i <= begin+spp && i <= n ; i++ )
			if (i == pag)
				pgnav += "<font color=#800000><b>["+i+"]</b></font>&nbsp;";
			else
				pgnav += "<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+i+_extraurl+" class=small>["+i+"]</a>&nbsp;";

	//if (pag<n)
		pgnav += "&nbsp;<a href="+(bSpiderSafeURL?(SiderSafeURL+SpiderSafeExt):"")+"?pag="+(pag+(pag<n?1:0))+_extraurl+"><img src=../images/rnav.gif border=0 title='"+_T["nav_next"]+"' style=vertical-align:text-top></a>&nbsp;"
				+ "&nbsp;<a href=?pag="+n+_extraurl+" class=small title='"+n+"'>["+_T["nav_end"]+"]</a>";
	
	if(oDB.permissions([zerofill(settingspage,2)+"_edit"]) || oDB.permissions([zerofill(settingspage,2)+"_admin"]))
		pgnav += "&nbsp;&nbsp;<a href="+zerofill(settingspage,2)+"_admin.asp class=small target=_blank>["+_T["nav_settings"]+"]</a>"

	var ippl = ipp*tablefld.length;
	if (pag==0)
		ippl = overviewlength>(maxrec*tablefld.length)?(maxrec*tablefld.length):overviewlength;
	var ipps = pag==0?0:ippl*(pag-1);


	var fieldparam = new Array();
	var enumparam  = new Array();
	var paramfld   = new Array("colnum","colname","hidden","title","type","format","attr","attr1","attr2");
	for(var i=paramfld.length;i>=0;i--)
		enumparam[paramfld[i]] = i;

	// M A P P I N G   T A B L E   S E T T I N G S   F R O M   D A T A B A S E
	
	for(var i=0;i<hfields.length;i++)
	{
		var idx 		= i*oSETTINGS.paramtablefld.length;
		var colnum 	= enumsettings[hfields.item(i).text];
		var colname   = hfields.item(i).getAttribute("name");
		var bReplace 	= typeof(colnum)=="number" && oSETTINGS.settingdata["LIST_PROPERTIES"].length>0;
		var bHidden  	= (oSETTINGS.settingdata["LIST_PROPERTIES"].length==0 || bReplace) == false
		
		fieldparam[idx+enumparam["colnum"]]  = colnum;
		fieldparam[idx+enumparam["colname"]] = colname;
		fieldparam[idx+enumparam["hidden"]]  = bHidden;
		
		if(bHidden==false)
		{
		// TODO !!!!!!!!!!!!!!!!!!
		
		
			//fieldparam[idx+enumparam["title"]]	= bReplace ? oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+1] : enumdataset[ hfields.item(i).text ].replace(/(\w)/g," $1").toUpperCase();
			//fieldparam[idx+enumparam["type"]]	= colname=="dt_date" && bReplace==false?"date":oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+2];
			//fieldparam[idx+enumparam["format"]]	= oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+3];
			//fieldparam[idx+enumparam["attr"]]	= oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+4];	
		}		
	}




%>

TODO !!!!!!!!!!!!!!!!!!!!

<!--table cellpadding=10 cellspacing=0>
<tr>
	<td>
		<table cellspacing=0 cellpadding=10 style=border-width:1px;border-color:#C0C0C0;border-style:solid>
		<tr>
			<td class=body width=675>
				<table cellspacing=1 cellpadding=0 class=qtable width=100%>
				
					<tr>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="modification">M O D I F I E R</td>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="qualité">Q</td>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="dénomination du diplôme">DENOMINATION</td>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="dénomination du diplôme">DENOMINATION LIBRE</td>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="institut">INSTITUT</td>
						<td style=background-color:black;text-align:center;font-size:xx-small;color:gold;font-weight:bold  title="année d'obtention">ANNEE</td>
					</tr>
					<tr>
<td width=170><input type=submit name=act value='modifier diplôme n° 1' style=width:170px></a></td>	<td>5</td>
	<td>&nbsp; Ingénieur Commercial</td>
	<td>Solvay</td>
	<td>ULB</td>
	<td>1984</td>
</tr>
<tr style=background-color:#e0e0e0>
<td style=background-color:#e0e0e0 width=170><input type=submit name=act value='modifier diplôme n° 2' style=width:170px></a></td>	<td style=background-color:#e0e0e0>5</td>
	<td style=background-color:#e0e0e0>&nbsp; Licencié en Droit</td>
	<td style=background-color:#e0e0e0></td>
	<td style=background-color:#e0e0e0>ULB</td>
	<td style=background-color:#e0e0e0>1984</td>
</tr>
<tr>
<td width=170><input type=submit name=act value='modifier diplôme n° 3' style=width:170px></a></td>	<td>5</td>
	<td>[0] Autres diplômes</td>
	<td>Candidat en Philosophie</td>
	<td>ULB</td>
	<td>1980</td>
</tr>

				</table>
			</td>
		</tr>
		</table>
	</td>
</tr>
</table-->





<%

	
		
		
	if(!isNaN(id))
	{
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
				//Response.Write(sSQL+"<br>");
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
			var rawdata = new Array();
			var pathdata = new Array();
			
			var formarr = new Array();
			if(bMultiPart==true)
			{
				var enumforms = new Array();
				for(var i=0;i<fieldID.length;i++)
					enumforms[fields.item(i).getAttribute("name")] = i;
					
				for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
				{
					var obj = objEnum.item();
					var idx = enumforms[obj.name];
					
					var en = enumsettings[fields.item(idx).text];
					var enl = enumlistsettings[fields.item(idx).text];			
					var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
					var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];					
					
					// FORM INPUT - DATA CONDITIONING
					
					if(idx || idx==0)
					{
						//if(type=="number" && format=="csv")
						//	rawdata[idx] = obj.value?Number(obj.value.replace(/,/,"."))*100:""
						//else
							rawdata[idx] = obj.value;
					}
					else if(obj.name.substring(0,3)=="ESC")
					{
						var fid = Number(obj.name.substring(3,6))
						idx = enumforms[ enumdataset[fid] ];
						
						var en = enumsettings[fields.item(idx).text];
						var enl = enumlistsettings[fields.item(idx).text];
						var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
						var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];						
						
						rawdata[idx] = ((rawdata[idx]?(rawdata[idx]+","):"")+escape(obj.value)).replace(/,*$/,"");
					}
					else if(obj.name.substring(0,3)=="CSV")
					{
						var fid = Number(obj.name.substring(3,6))
						idx = enumforms[ enumdataset[fid] ];
						
						var en = enumsettings[fields.item(idx).text];
						var enl = enumlistsettings[fields.item(idx).text];
						var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
						var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];						
						
						if      (type=="multistring" && format.substring(0,3)=="csv")
							rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+"\""+(obj.value?obj.value.replace(/"/g,"&quot;"):"")+"\"";
						else if(type=="multinumber" && format.substring(0,3)=="EUR")
							rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+(obj.value?Number(obj.value.replace(/,/,"."))*100:"");					
						else
							rawdata[idx] = (rawdata[idx]?(rawdata[idx]+","):"")+"\""+obj.value+"\"";
						
						// EXCLUDE BLANK FIELDS FROM DATABASE
						rawdata[idx]=rawdata[idx].replace(/,""/g,"").replace(/,*$/,"");
					}
					else if(obj.name.substring(0,3)=="CHK")
					{
						var fid = Number(obj.name.substring(3,6));
						var did = Number(obj.name.substring(7,10));
						var idx = enumforms[ enumdataset[fid] ];					
						var en = enumsettings[fields.item(idx).text];
						var enl = enumlistsettings[fields.item(idx).text];
						var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
						var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
						
						if (type=="number" && format.substring(0,5)=="check")
						{
							rawdata[idx] = (typeof(rawdata[idx])=="number"?rawdata[idx]:0)+(Number(obj.value)<<did);
							//Response.Write(rawdata[idx].toString(2)+" "+did+"<br>")
						}
					}
					//Response.Write("MultiPartRequest rawdata["+idx+"] ("+format+") ("+obj.name+") = "+rawdata[idx]+"<br>");
				}
			}
			else
			{
				for(var i=0;i<fieldID.length;i++)
				{
					var name = fields.item(i).getAttribute("name");
					rawdata[i] = Request.Form(name).Item?Request.Form(name).Item:"";
					
					// TODO INTREPRET ESC FIELDS !!!!!!!!!!!!!!
					
					//Response.Write("enumraw["+fieldID[i]+"] = "+Request.Form(name).Item+" ["+name+"]<br>");
					//if(bDebug)
					//	Response.Write("NormalRequest rawdata["+i+"] = "+rawdata[i]+"<br>");
				}
			}
			
			if(bDebug)
			{
				Response.Write("<br>L O A D I N G &nbsp; F O R M &nbsp; D A T A<br><br>");
				
				for(var i=0;i<DBfieldID.length;i++)
					Response.Write("fieldID["+DBfieldID[i]+"] = "+rawdata[i]+"<br>");
				Response.Write("<br>");
			}			
		}
		

		
		// R I C H T E X T   I N C L U D E S
		if(bIncludeRichtextLib)
		{
			var beenhere = new Array();
			for(var i=0;i<fieldID.length;i++)
			{
				var en = enumsettings[fields.item(i).text];
				var enl = enumlistsettings[fields.item(i).text];
				var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
				var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
				format=(format=="richtext"?DefaultRichtextLib:format);
				
				if(type=="string" && beenhere[format]!=true)
				{
					if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
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
		
		if(bSubmitted==true)
		{

		
			
			if(detaildb)
			{
				// U P D A T E   D E T A I L   D A T A B A S E
				var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
				for(var i=0;i<fieldID.length;i++)
				{
					var en = enumsettings[fields.item(i).text];
					var enl = enumlistsettings[fields.item(i).text];
					var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
					var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
					
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
						qset[j++] = name+" = "+(rawdata[i] && !isNaN(rawdata[i])?rawdata[i]:"null");
						
						if(isNaN(Number(rawdata[i])) && name.indexOf("ds_num")==0)
							rawdata[i] = "*ERR NUMBER* "+rawdata[i]+" "+qset[j-1];
					}
					else if (name.indexOf("ds_datetime")==0)
					{	
						var en = enumsettings["["+DBfieldID[i]+"]"];
						var enl = enumlistsettings["["+DBfieldID[i]+"]"];
						//var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
						var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
						
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
	
		for(var i=0;i<fieldID.length;i++)
		{
			var name = fields.item(i).getAttribute("name");
			var value = rawdata[i]==null?"":rawdata[i];
			
			if(bDebug)
				Response.Write("rawdata["+i+"] = "+rawdata[i]+"<br>")
			
			var en = enumsettings[fields.item(i).text];
			var enl = enumlistsettings[fields.item(i).text];
			
			var fldesc = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+1];
			fldesc = fldesc?(" "+fldesc):"";
			var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
			var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
			format=(format=="richtext"?DefaultRichtextLib:format);
			var attr = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+4];
			
			if(bDebug)
				Response.Write("testing enumheader["+DBfieldID[i]+"]<br>");
			
			//var bMandatory = name.substring(0,3)=="mn_";
			//var bQuickField = enumheader[DBfieldID[i]]?true:false;
			//var color = bQuickField?(bMandatory?"#EFD0D0":"#FFE0E0"):(bMandatory?"#E0E0E0":"#F0F0F0");
			
			var curfieldID = fieldID[i]+1;
			
			//var en2 = enumproperties[fields.item(i).text]
			//if(fields.item(i).text == oSETTINGS.settingdata["FIELD_PROPERTIES"][en+1])
			//	Response.Write(fields.item(i).text+" "+oSETTINGS.settingdata["FIELD_PROPERTIES"][en2+3]+"<br>")
			
			switch(type)
			{
				case "img":
					///////////////////////////////////
					//    RESIZE UPLOADED IMAGERY    //
					///////////////////////////////////
					
					var FileCollection = Upload.Files;
					var filepath = "../"+_ws+"/images";
					var arrformats = format.split(",");
					
					var filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3);
					var fs				= Server.CreateObject("Scripting.FileSystemObject");
					var source_path	= Server.Mappath("../images/upload")+"\\";
					var dest			= Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
					
					if (bUpload)
					{
						var bValidImage = false;
						for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
						{
							var obj = objEnum.item();
							var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
							var imgnr = Number(obj.name.substring(4,7));
							if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
							{
								var jpeg = Server.CreateObject("Persits.Jpeg");
								
								for(var j=0;j<arrformats.length;j++)
								{
									jpeg.open( obj.path );
									jpeg.Quality = 85;
									jpeg.Interpolation = 2;
									resizetoRect(jpeg,arrformats[j]);
									jpeg.Sharpen(1,105);
									var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+j+".jpg";
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
							if(Upload.Files.Count == 1)
								for (var objEnum=new Enumerator(Upload.Files); !objEnum.atEnd() ; objEnum.moveNext())
									source_name = objEnum.item().ExtractFileName();
							var source = source_path+source_name;
							
							// DELETE PREVIOUS FILE (SINCE OVERWRITING ISN'T PERMITTED)
							try {fs.DeleteFile(dest)}catch(e){if (bDebug) Response.Write("*delete* "+dest+": "+e)};	
							
							for(var j=0;i<1000 && fs.FileExists(dest)==false;j++)
								if(fs.FileExists(source))
								{
									try {fs.MoveFile(source,dest)}catch(e){if (bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
								}
						}
					}
					
					//Response.Write(source+"<br><br>"+dest+"<br><br>")
					
					var actimg = isNaN(value)?0:Number(value);
					var bFileExists = fs.FileExists(dest);
					var imgpanel = "<table height=100 width=100 bgcolor=black cellspacing=1 align=left><tr><td style=font-size:12px;background-color:white align=center "+((actimg&1)==1?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
								  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^((1<<("+(arrformats.length)+"))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
								  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
								  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
								  +(bFileExists?"</a>":"")
								  +"<br><br>JPG<br>Image<br><br><input SIZE=1 name=\"FILE"+zerofill(curfieldID,3)+"\" type=FILE value=\""+Server.HTMLEncode(value)+"\"  onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
								  +"</td></tr></table>";
					
					var bitlength = actimg.toString(2).length;
					if(actimg>0)
						for(var j=0;j<bitlength;j++)
							imgpanel += 
									(bFileExists?(
									//"<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><br><img src="+filepath+"/img"+filebase+"_"+j+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"+arrformats[j]+"</a>"
									 "<a href=imgframer.asp?img=img"+filebase+"_"+j+".jpg&src=src"+filebase+".jpg&dim="+arrformats[j]+" target=_blank>"+arrformats[j]+"</a><br>"):"")
					
					
					Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>"+imgpanel+"<input name="+name+" type=hidden value=\""+Server.HTMLEncode(value)+"\"><br></td></tr>");				
				break;
				case "gallery":
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
					
					if (bUpload)
					{
						var bValidImage = false;
						for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
						{
							var obj = objEnum.item();
							var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
							var imgnr = Number(obj.name.substring(4,7));
							imgsubnr =  Number(obj.name.substring(8,10));
							
							filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(imgsubnr,2)
							dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
							
							if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
							{
								var jpeg = Server.CreateObject("Persits.Jpeg");
								
								for(var j=0;j<arrformats.length;j++)
								{
									jpeg.open( obj.path );
									jpeg.Quality = 85;
									jpeg.Interpolation = 2;
									resizetoRect(jpeg,arrformats[j]);
									jpeg.Sharpen(1,105);
									var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+j+".jpg";
									jpeg.Save(savefile);
									
									bValidImage = true;
									if(bDebug)
										Response.Write("IMAGE SAVED: "+savefile+"<br><br>")
								}
								value = (isNaN(value)?0:Number(value)) | (1<<imgsubnr);  // alter bitmap !
								if(bDebug)
									Response.Write("BITMAP: ["+zerofill(value.toString(2),16)+"]<br><br>")
							}
						}
						
						if(bValidImage)
						{
							var source_name = "";
							if(Upload.Files.Count == 1)
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
					
					var actimg = isNaN(value)?0:Number(value);
					
					var bitlength = actimg==0?1:(actimg.toString(2).length+(actimg.toString(2).length<24?1:0));
					var imgpanel = new Array(bitlength);
					
					for(var b=0;b<bitlength;b++)
					{
						filebase = zerofill(dt,10)+"_"+zerofill(id,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(b,2)
						dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
						var bFileExists = fs.FileExists(dest);
						
						imgpanel[b] = ((b%5)==0 && b>0?"</td></tr><tr><td>":"")
									  +"<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&(1<<b))?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
									  +"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^(1<<"+b+");main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
									  +(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
									  +"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
									  +(bFileExists?"</a>":"")
									  +"<br><br>JPG<br>Image<br><br><input SIZE=1 name=\"FILE"+zerofill(curfieldID,3)+"_"+zerofill(b,2)+"\" type=FILE value=\""+Server.HTMLEncode(value)+"\"  onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">&nbsp;&nbsp;&nbsp;"
									  +"</td></tr></table>";
						
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
					if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
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
								Response.Write("<textarea name="+name+" style=width:265px;height:100px;>"+value+"</textarea>");
							else
							{
								for(var j=0;j<value.length;j++)
									if(value[j]) Response.Write("<textarea name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" style=width:265px;height:100px;>"+value[j]+"</textarea>");
								Response.Write("<textarea name=ESC"+zerofill(fieldID[i]+1,3)+"_"+zerofill(j,3)+" style=width:265px;height:100px;>"+(value[j]?value[j]:"")+"</textarea>");
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
									var imgnr = Number(obj.name.substring(4,7));
									imgsubnr =  Number(obj.name.substring(8,10));
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
									if(Upload.Files.Count == 1)
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
							
							Response.Write("<tr><td bgcolor="+color+" title=\"["+curfieldID+"]"+fldesc+"\">["+name+"]</td><td bgcolor=#E0E0E0>"
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
								Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><textarea name="+name+" "+(attr?attr:"style=width:265px;height:100px;")+">"+value+"</textarea></td></tr>");				
							
							Response.Write("</td></tr>");
							richtext_names[format] = richtext_names[format]?(","+name):name;
						break;
						case "tinymce_img":
						case "tinymce":
							Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0 "+(attr?attr:"style=width:500px;height:200px;")+"><textarea name="+name+" "+(attr?attr:"style=width:500px;height:200px;")+">"+value+"</textarea></td></tr>");				
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
					value = value?csv2array(value):new Array();
				case "number":

					if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
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
								Response.Write("<input name=\""+name+"\" type=text value=\""+(typeof(value)=="number" || (!bSubmitted && value.length>0)?(Number(value)/100).toFixed(2).replace(/\./,","):value)+"\" "+(attr?attr:"size=18")+">");
							}
							Response.Write(" [...####,##]</td></tr>");						
						break;
						case "check":
							var options = arg["opt"]?csv2array(unescape(arg["opt"])):new Array();
							var len = arg["len"]?Number(arg["len"])-1:( options.length>0?options.length-1:value.toString(2).length )
							
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
								var arr = oDB.getrows(sSQL);
								
								
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
					Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0><input name="+name+" type=text value=\""+Server.HTMLEncode(value)+"\" "+(attr?attr:"size=40")+"></td></tr>");
			}
			Response.Write("\r\n");
		}
		Response.Write("</table>\r\n<br>\r\n");
		
		Response.Write(commands);
		Response.Write("</center>\r\n</form>\r\n");
	}	

	Response.Write("<!-- R I C H T E X T   I N I T I A L I S E R S -->\r\n\r\n");
	
	if(bIncludeRichtextLib)
	{
		var beenhere = new Array();
		for(var i=0;fieldID && i<fieldID.length;i++)
		{
			var name = fields.item(i).getAttribute("name");
			var en = enumsettings[fields.item(i).text];
			var enl = enumlistsettings[fields.item(i).text];
			var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
			var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
			format=(format=="richtext"?DefaultRichtextLib:format);
			
			if(type=="string" && beenhere[format]!=true)
			{
				if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
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

	if (bSubmitted)
	{
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");
	}




// FUNCTIONS

	function fieldheader(curfieldID,fldesc,name,en,enl)
	{
		var bMandatory = name.substring(0,3)=="mn_";
		var bQuickField = enumheader[DBfieldID[i]]?true:false;
		var color = bQuickField?(bMandatory?"#EFD0D0":"#FFE0E0"):(bMandatory?"#E0E0E0":"#F0F0F0");
		
		var _fimglink = "";
		if(settingspage)
		{
			// var _fdt = oSETTINGS.settingsref["LIST_PROPERTIES"];            //var _fdt = oSETTINGS.settingdata["LIST_PROPERTIES"][en+8];  (equivalent code)
			// var _fid = oSETTINGS.settingdata["LIST_PROPERTIES"][enl+9];
			
			// var _fimg    = enl?"ii_longbuttonred.gif":"ii_longbuttonredstripe.gif";
			// var _faltimg = enl?"ii_longbuttonred_alt.gif":"ii_longbuttonredstripe_alt.gif";
			
			// if(bQuickField)
			// {
			// 	_fimglink += "<a href="+zerofill(settingspage,2)+"_rec_dlg.asp?dt="+(_fdt?_fdt.toString().encrypt("nicnac"):"")+"&id="+(_fid?_fid.toString().encrypt("nicnac"):"")+(enl?"":"&i="+curfieldID+"&s=LIST_PROPERTIES")+" target=_blank>"
			// 	_fimglink += "<img src=../images/"+_fimg+" onmouseover=this.src='../images/"+_faltimg+"' onmouseout=this.src='../images/"+_fimg+"' border=0>"
			// 	_fimglink += "</a>&nbsp;";
			// }
			// else
			// 	_fimglink += "<img src=../images/spc.gif width=6>&nbsp;"
			
			// var _fimg    = en?"ii_longbuttonblue.gif":"ii_longbuttonbluestripe.gif";
			// var _faltimg = en?"ii_longbuttonblue_alt.gif":"ii_longbuttonbluestripe_alt.gif";
			
			// var _fdt = oSETTINGS.settingsref["FIELD_PROPERTIES"];            //var _fdt = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+8];  (equivalent code)
			// var _fid = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+9];
			
			// _fimglink += "<a href="+zerofill(settingspage,2)+"_rec_dlg.asp?dt="+(_fdt?_fdt.toString().encrypt("nicnac"):"")+"&id="+(_fid?_fid.toString().encrypt("nicnac"):"")+(enl?"":"&i="+curfieldID+"&s=FIELD_PROPERTIES")+" target=_blank>"
			// _fimglink += "<img src=../images/"+_fimg+" onmouseover=this.src='../images/"+_faltimg+"' onmouseout=this.src='../images/"+_fimg+"' border=0>"
			// _fimglink += "</a>";
			
			var _fimg    = en || enl?"ii_longbuttonblue.gif":"ii_longbuttonbluestripe.gif";
			var _faltimg = en || enl?"ii_longbuttonblue_alt.gif":"ii_longbuttonbluestripe_alt.gif";
			
			var _fdt = oSETTINGS.settingsref["FIELD_PROPERTIES"];            //var _fdt = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+8];  (equivalent code)
			var _fid = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+9];
			
			_fimglink += "<a href="+zerofill(settingspage,2)+"_"+(en || enl?"rec":"cfg")+"_dlg.asp?dt="+(_fdt?_fdt.toString().encrypt("nicnac"):"")+"&id="+(_fid?_fid.toString().encrypt("nicnac"):"")+(enl?"":"&i="+curfieldID+"&s=FIELD_PROPERTIES")+" target=_blank>"
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
			for(var _i=0;_i<_parr.length;_i+=2)
			   _enum[_parr[_i]] = _enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1];
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
		
		if(!isNaN(splitarr[1]))
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
%>




