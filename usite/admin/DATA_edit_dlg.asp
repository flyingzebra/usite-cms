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

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));

	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	var bDelete = oDB.permissions([zerofill(ds_type,2)+"_delete"]);
	var detailtarget = "_blank";
	
	if (oDB.loginValid()==false || (bAdmin==false && bEdit==false))
		Response.Redirect("index.asp");

	function quote( str )
	{
		return "\""+(!str || str==null?"":str.replace(/\x22/g,"\\\""))+"\"";
	}
	
	String.prototype.ltrim = function () { return this.replace(/^ */,""); }
	String.prototype.rtrim = function () { return this.replace(/ *$/,""); }
	String.prototype.trim  = function () { return this.ltrim().rtrim(); }


	var languages = oDB.getSetting(zerofill(ds_type,2)+"_L");
	var dbinfo = new Array();

	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
	
	var deftablefld = new Array("rev_id","rev_title","rev_url","rev_ref","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;
	
	
	var sSQL = "select "+deftablefld.join(",")+" from usite_review where rev_rt_typ in (1,3,22,23) and rev_dir_lng = \""+_ws+"\""
	var enum_tabledefs = new Array();
	var tabledefs = oDB.getrows(sSQL);
	for(var j=0;j<tabledefs.length;j+=deftablefld.length)
	{
		enum_tabledefs[tabledefs[j]] = tabledefs.slice(j,j+deftablefld.length);
		//Response.Write("enum_tabledefs["+tabledefs[j]+"] = "+tabledefs[j+1]+" "+tabledefs[j+deftablefld.length-1]+"<br>")
	}
	
	if(!enum_tabledefs[id])
	{
		Response.Write("CURRENT TABLE DEFINITION DOES NOT EXIST");
		Response.End();
	}
	
	var true_id = enum_tabledefs[id][defenumfld["rev_ref"]]?enum_tabledefs[id][defenumfld["rev_ref"]]:id;
	
	dbinfo[dbinfo.length] = "name="+enum_tabledefs[id][defenumfld["rev_title"]];
	dbinfo[dbinfo.length] = "ds="+id
	dbinfo[dbinfo.length] = "ds_ref="+enum_tabledefs[id][defenumfld["rev_ref"]];
    
	
	// E X T E R N A L  D A T A B A S E   S E L E C T I O N

	//Response.Write(enum_tabledefs[id][defenumfld["rev_publisher"]]);
	var deepsearch_dbfilter = "";
	
	function physdb(tid)
	{
	    var oarr = enum_tabledefs[tid];
		if(oarr && oarr!=null && oarr[defenumfld["rev_publisher"]])
		{
			var oarrs = oarr[defenumfld["rev_publisher"]].split(",");
			return {"masterdb":(oarrs[0]?oarrs[0]:"dataset"),"detaildb":(oarrs[1]?oarrs[1]:"datadetail"),"filter":(oarrs[2]?oarrs[2]:"")}
		}
		else
			return {"masterdb":"dataset","detaildb":"datadetail"}
	}

	
	var phys = physdb(true_id);
	masterdb = phys["masterdb"];
	detaildb = phys["detaildb"];
	
	

	//deepsearch_dbfilter = arr[2] && arr[2].indexOf("sp=")==0?arr[2].substring(3,arr[2].length):"";
	

	// R E A D   T A B L E   S E T T I N G S   F R O M   D A T A B A S E

	// R E A D   X M L   D A T A S E T
	
	//Response.Write("READING SETTINGS FROM "+enum_tabledefs[id][defenumfld["rev_id"]]+"<br>")
	
	var XMLObj = loadXML(enum_tabledefs[id][defenumfld["rev_rev"]]);
	var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumdataset = new Array();
	for(var i=0;i<fields.length;i++)
		enumdataset[ fields.item(i).text ] = fields.item(i).getAttribute("name");
	
	// R E A D   X M L   H E A D E R S E T
	var XMLObj   = loadXML(enum_tabledefs[id][defenumfld["rev_header"]]);
	var hfields   = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumheader = new Array();
	var enumheaderfld = new Array();
	
	for(var i=0;i<hfields.length;i++)
	{
		enumheader[hfields.item(i).text] = hfields.item(i).getAttribute("name");
		enumheaderfld[hfields.item(i).getAttribute("name")] = i;
	}
	
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

	var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_datetime03","ds_datetime04","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
	var enumfld = new Array();
 	var headerfld = new Array();
	for (var i=0; i<tablefld.length ; i++)
	{
		enumfld[tablefld[i]] = i;
		headerfld[i] = typeof(enumheaderfld[ tablefld[i] ])=="number" || tablefld[i]=="ds_id" || tablefld[i]=="ds_pub" ? tablefld[i] : "null";
		
		//Response.Write(i+" "+enumheaderfld[ tablefld[i] ]+" "+tablefld[i]+"<br>")
		
	}

	var _extraurl = (dt?("&id="+dt):"")+(orderby?("&orderby="+orderby):"")

	// SEARCH ENGINE
	
	var searchengine = "";
	var searchclause = " ";
	var deepsearchclause = new Array();
	var linkclause   = "";
	
	
	// I N T E L L I G E N T   F I L T E R   S C R I P T
	
	if(enum_tabledefs[id][defenumfld["rev_url"]])
	{
		var iarg = argparser("\""+enum_tabledefs[id][defenumfld["rev_url"]]+"\"");
		
		if(iarg["filter"])
		{
			var rid = iarg["filter"].toString().decrypt("nicnac");
			var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_ws+"\" and (rev_pub & 9) = 1 and rev_id = "+rid+" limit 0,1";
			var script = oDB.get(sSQL);
			eval(script);
			
			//Response.Write(deepsearch_dbfilter)
		}
    }	
	
	
	
	// SEARCH ENGINE
	
	
	var siSQL = 0;
	var search_insertSQL = new Array();
	
	var bHiddenSearch = false;
	var bop = Request.QueryString("bop").Item  // BOP bitmap field (0_1 minimal layout,0_2 searcharea inserts)
	var isearch = Request.QueryString("isearch").Item
	
	if(isearch || (bop&1)==1)
		bHiddenSearch = true;
	
	// A D - H O C   S E A R C H
	var sparr = new Array();
	if(Request.QueryString("sp").Item || deepsearch_dbfilter)
	{
		//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"].join("<br>"))
		//Response.Write(Request.QueryString("sp").Item.split("$").join("<br>"));
		
		var spstr  = Request.QueryString("sp").Item?Request.QueryString("sp").Item:"";
		spstr = (spstr?(spstr+"$"):"")+(deepsearch_dbfilter?deepsearch_dbfilter:"");
		
		var sparr = spstr.split("$");
		
		//Response.Write(sparr)
		
		var len = oSETTINGS.settingdata["SEARCH_PROPERTIES"].length;
		var recno = 1000;
		for(var i=0;i<sparr.length;i+=4)
		{
		    if(sparr[i])
			{		
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len] = "SEARCH_PROPERTIES";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+oSETTINGS.p_idx["columnID"]] = "["+sparr[i]+"]";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+2] = "field ["+sparr[i]+"]";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+3] = sparr[i+1]; // type
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+4] = sparr[i+2]; // format
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+5] = "" // attr
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+6] = "";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+7] = "";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+8] = "";
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+9] = id;
				oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+10] = recno++;
				
				//enumheader[oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+oSETTINGS.p_idx["columnID"]]] = enumheader[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+oSETTINGS.p_idx["columnID"]] ];
				
				//Response.Write("enumheader["+oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+oSETTINGS.p_idx["columnID"]]+"] = "+enumheader[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][len+oSETTINGS.p_idx["columnID"]] ]+"<br>")
				
				//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"]+"<br><br>")
				
				len += oSETTINGS.p_dbcol.length;
			}
		}
		
		//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"].join("<br>"))
	}
	
	// CHECK IF THERES THE SAME AMOUNT OF VIRTUAL SETTINGS AS THERE ARE SETTINGS
	
	//var bDisplaySearchBox = oSETTINGS.settingdata["SEARCH_PROPERTIES"].length>0
	bDisplaySearchBox = true;
	var sparamcount = Math.ceil(sparr.length/4);
	var scount = oSETTINGS.settingdata["SEARCH_PROPERTIES"].length/oSETTINGS.p_dbcol.length;

	//Response.Write(sparamcount+" "+scount+"<br>")
	
	if(sparamcount == scount && sparamcount>0)
		bDisplaySearchBox = false;

	//Response.Write(bDisplaySearchBox+" "+(1+(sparr.length-(sparr.length%4))/4)+" "+(oSETTINGS.settingdata["SEARCH_PROPERTIES"].length/oSETTINGS.p_dbcol.length)+"<br>")	
	//Response.Write(Number(sparr.length/4)+" "+Number(oSETTINGS.settingdata["SEARCH_PROPERTIES"].length/oSETTINGS.p_dbcol.length)+"<br>")
	//Response.Write(Number(sparr.length/4)==Number(oSETTINGS.settingdata["SEARCH_PROPERTIES"].length/oSETTINGS.p_dbcol.length)+"<br>")
	
	if(oSETTINGS.settingdata["SEARCH_PROPERTIES"].length>0)
	{
		//Response.Write(bDisplaySearchBox+"<br>")
		
		searchengine = "<table cellspacing=1 cellpadding=10 bgcolor=#000000 align=center><tr><td bgcolor=#DADADA>\r\n";
		searchengine += "<table>\r\n";
		//Response.Flush()
		for(var i=0;i<oSETTINGS.settingdata["SEARCH_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
		{
			
			var bVisiblesearch = true;
			var curfieldTAG = oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]];
			curfieldID      = curfieldTAG?curfieldTAG.substring(1,curfieldTAG.length-1):"";
			var fldname     = enumdataset[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var dbfldname   = enumheader[ oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var idx         = Math.round(i/oSETTINGS.p_dbcol.length);
			
			if(bDebug)
			{
				Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i]+"<br>")
				Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]+"<br>")
				Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2]+"<br>")
				Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+3]+"<br>")
				Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+4]+"<br>")
				Response.Write("<br>")
			}
			
			
			if(!fldname && curfieldTAG!="[0]")
			{
				searchengine += "<tr><td><span class=small>"+oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2]+"</span></td><td><img src=../images/exclame.gif> "+_T["obsolete"]+"</td></tr>\r\n";
				continue;
			}
			
			//var name   = fldname;
			//var value  = name?Request.Form(name).Item:oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2]
			
			// F E T C H   S E A R C H   F O R M S
			var  name = fldname?fldname:oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2];
			var value = bSubmitted==false && Request.QueryString("s"+idx).Item?Request.QueryString("s"+idx).Item:Request.Form(name).Item;
			
			//Response.Write(name+" "+value+"<br>")
			
			
			var format = oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+4];
			var attr   = oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+5];
			var args   = argsplitter(format);			
			 
			if(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]=="[0]")
			{
			    fldname = "id";
				dbfldname = "ds_id";
			}
			
			
			var formfld = bSubmitted==true?Request.Form(fldname).Item:(Request.QueryString("s"+idx).Item?Request.QueryString("s"+idx).Item:"");
			//var formfld = bSubmitted==true?Request.Form(name).Item:(Request.QueryString("s"+idx).Item?Request.QueryString("s"+idx).Item:"");
			//Response.Write(fldname+(" s"+idx)+" *"+formfld+"* "+bSubmitted+" "+oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+4]+"<br>");
			
			if(type=="query")
			{
				bVisiblesearch = false;
				//formfld = Request.QueryString(fldname).Item;
			}			
			
			// S E A R C H   B O X
			
			//linkclause += name?("&s"+idx+"="+escape(name)):"";
			
			
			if(value)
				linkclause += name?("&s"+idx+"="+escape(value)):"";
			
			// OVERRIDE BY AD-HOC VALUE
			if(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
			{
				formfld = sparr[i+3];
				if(Request.QueryString("sp").Item)
					linkclause += formfld?("&sp="+escape(Request.QueryString("sp").Item)):"";
			}
		
			
			var searchform = "<input type=text name=\""+fldname+"\" value=\""+Server.HTMLEncode(formfld)+"\">";
			
			searchclause += (searchclause.length>0?" AND ":"");
			
			bRefmatters = false;
			
			//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+3]+" "+formfld+"<br>");
			//Response.Write(dbfldname+"<br>");
			
			function deepsearcher(id,curfieldID,collation,deepsearchclause,condition_sql)
			{
				var narrower = "";
				if(collation=="AND")
					var narrower = deepsearchclause.length>0?(" and rd_recno in ("+deepsearchclause.join(",")+")"):"";
				
				
				var sSQL = "select rd_recno from usite_datadetail where rd_ds_id = "+true_id+" and rd_dt_id = "+curfieldID+" and "+condition_sql+narrower
				var dsarr = oDB.getrows(sSQL);
				
				Response.Write("<!--DEEPSEARCH\r\n\r\n\r\n"+sSQL+"\r\n\r\n\r\n-->");
				
				if(collation=="AND")
					return dsarr;
				else
					return deepsearchclause.concat(dsarr);
			}
			
			//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"].join("<br>")+"<br>")
			
			if(typeof(bImpliedSearch)=="undefined")
			{
				switch(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+3])
				{
					case "exact":
						if(dbfldname)
							searchclause += formfld?(dbfldname + " = \"" + formfld.replace(/"/g,"\\\"") + "\" "):"1 ";
						else
						{
							if(formfld)
							{
								var condition_sql = "rd_text = \""+formfld.replace(/"/g,"\\\"")+"\""
								deepsearchclause = deepsearcher(id,curfieldID,"AND",deepsearchclause,condition_sql);
							}
							searchclause += "1 ";
						}
					break;
					case "exact|zero": searchclause +=  formfld?("("+ dbfldname + " = \""+formfld.replace(/"/g,"\\\"")+"\" or "+dbfldname+" = 0)"):" 1 ";break;
					case "number":
					
						if(dbfldname)
							searchclause += formfld?(dbfldname + " = \"" + formfld.replace(/"/g,"\\\"") + "\" "):"1 ";
						else
						{
							if(formfld)
							{
								var condition_sql = "rd_text = \""+formfld.replace(/"/g,"\\\"")+"\""
								deepsearchclause = deepsearcher(id,curfieldID,"AND",deepsearchclause,condition_sql);
							}
							
							searchclause += "1 ";
						}
					break;
					case "ref":
					    if(dbfldname)
						{
							if(dbfldname.indexOf("ds_num")==0 || dbfldname.indexOf("ds_datetime")==0)
								var exclause =  " or "+dbfldname+" = 0";
							else
								var exclause =  " or "+dbfldname+" = \"\"";
							searchclause += formfld?(dbfldname + " = \"" + formfld.replace(/"/g,"\\\"") + "\" "):"1 ";
						}
						else
						{
							if(formfld)
							{
								var condition_sql = "rd_text = \""+formfld.replace(/"/g,"\\\"")+"\""
								deepsearchclause = deepsearcher(id,curfieldID,"AND",deepsearchclause,condition_sql);
							}
							searchclause += "1 ";
							
							
						    //Response.Write("REF PROBLEM AT "+oSETTINGS.settingdata["SEARCH_PROPERTIES"].slice(i,i+5)+"<br>")
						}
						bRefmatters = true;
					break;
					case "ref|zero":
						var exclause =  " or "+dbfldname+" = 0";
					case "ref|exact":
						if(formfld)
							searchclause += "("+ dbfldname + " = \""+formfld.replace(/"/g,"\\\"")+"\""+(exclause?exclause:"")+")";
						else
							searchclause += "1 ";
						bRefmatters = true;
					break;				
					case "ref|oneof":
						if(formfld)
							searchclause += "("+ dbfldname + " like \"%"+formfld.replace(/"/g,"\\\"")+"%\""+(exclause?exclause:"")+")";
						else
							searchclause += "1 ";
						bRefmatters = true;
					break;
					case "multiref":
						if(dbfldname.indexOf("ds_num")==0 || dbfldname.indexOf("ds_datetime")==0)
							var exclause =  " or "+dbfldname+" = 0";
						else
							var exclause =  " or "+dbfldname+" = \"\"";
						
						if(formfld)
							searchclause += "(CONCAT(',',"+ dbfldname + ",',') like \"%,"+formfld.replace(/"/g,"\\\"")+",%\""+(exclause?exclause:"")+")";
						else
							searchclause += "1 ";
						bRefmatters = true;
					break;
					case "date":
						// SEE LOWER
						
						
						
						if(formfld)
						{
						
						
							var arg  = argparser(args[1]);
							arg["fmt"] = arg["fmt"]?arg["fmt"]:"%Y-%m-%d %H:%M:%S";
							var formfldarr = formfld?formfld.split(","):new Array();
							
							
							//Response.Write("*****"+formfldarr[0]+"*"+formfldarr[1])
							
							if(formfldarr[0] && formfldarr[1])
							{
								formfldarr[1] = formfldarr[1].substring(1,formfldarr[1].length)
								formfld = formfldarr.join(",");
								
								var condition1 = formfldarr[0].toString().toDate(arg["fmt"]).format("%Y-%m-%d %H:%M:%S");
								var condition2 = formfldarr[1].toString()?formfldarr[1].toString().toDate(arg["fmt"]).format("%Y-%m-%d %H:%M:%S"):condition1;
								
								//Response.Write( (!!formfldarr[1].toString())+"$$$")
								
								searchclause += dbfldname+" BETWEEN '"+condition1+"' AND '"+condition2+"' "
							
							//Response.Write("*****"+searchclause)
							
							}
							else
								searchclause += "1 ";
							
							
							
							
							// TODO U S E   M Y S Q L   C L A U S E   ' B E T W E E N'
							
							
							
							
							
							
							
							//searchclause += "(CONCAT(',',"+ dbfldname + ",',') like \"%,"+formfld.replace(/"/g,"\\\"")+",%\""+(exclause?exclause:"")+")";

						}
						else
							searchclause += "1 ";
					break;
					default:
						if(dbfldname)
						{
							if(formfld)
								searchclause += dbfldname + " LIKE \"%" + formfld.replace(/"/g,"\\\"")+"%\" ";
							else
								searchclause += "1 ";					
						}
						else
						{
							if(formfld)
							{
								var condition_sql = "rd_text like \"%"+formfld.replace(/"/g,"\\\"")+"%\""
								deepsearchclause = deepsearcher(id,curfieldID,"AND",deepsearchclause,condition_sql);
							}
							searchclause += "1 ";
						}
				}
			}
			else
				searchclause += "1 ";
			
			//Response.Write(searchclause+"<br>")
			
			switch(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+3])
			{
				case "number":
					if(args[0]=="check")
					{
						searchform += "<input name="+name+" type=check "+attr+">\r\n";
					}
				case "date":
					if(args[0]=="date")
					{
						var arg  = argparser(args[1]);
						arg["fmt"] = arg["fmt"]?arg["fmt"]:"%Y-%m-%d %H:%M:%S";

						if(formfld && (formfld.indexOf("=")==0 || formfld.indexOf(">")==0 || formfld.indexOf("<")==0))
						{
							var operator = formfld.charAt(0);
							var condition = formfld?formfld.substring(1,formfld.length).trim().toString().toDate(arg["fmt"]).format("%Y-%m-%d %H:%M:%S"):"";
						}
						else
						{
							var operator = "=";
							var condition = formfld?formfld.toString().toDate(arg["fmt"]).format("%Y-%m-%d %H:%M:%S"):"";						
						}
						
						var df = arg["fmt"];
						df = df.replace(/%d/g,"dd");
						df = df.replace(/%m/g,"mm");
						df = df.replace(/%Y/g,"yyyy");
						df = df.replace(/%H/g,"hh");
						df = df.replace(/%M/g,"mm");
						df = df.replace(/%S/g,"ss");
						df = df.replace(/%/g,"");

						
						//if(dbfldname)
						//	searchclause += formfld?(dbfldname + " "+operator+" \""+ condition+"\""):"1 ";
						//else
						{
							if(formfld)
							{
								var condition_sql = "STR_TO_DATE(rd_text,\"%Y-%m-%d %H:%i:%s\") "+operator+" \""+condition+"\""
								deepsearchclause = deepsearcher(id,curfieldID,"AND",deepsearchclause,condition_sql);
							}
							
							//searchclause += "1 ";
						}
						
						var formfldarr = formfld?formfld.split(","):new Array()
						var searchform = 
						"<input type=text name=\""+fldname+"\" value=\""+Server.HTMLEncode(formfldarr[0])+"\">"
						+"<input type=text name=\""+fldname+"\" value=\""+Server.HTMLEncode(formfldarr[1])+"\">"
						+"<span class=small> ["+df+"]</span>";
					}
				case "ref":
				case "ref|zero":
				case "ref|oneof":
				case "multiref":
					
					//Response.Flush()
					
					if(args[0]=="combo")
					{
						var arg  = argparser(args[1]);
						
						//Response.Write(args+"<br>")
						
						
						var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
						
						//Response.Write(arg[pubcond]+"***")
						
						arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(arg["sep"]).join(",' ',")+")"):"ds_title";
						if(arg["xcol"])
							arg["col"] = "CAST(CONCAT("+unescape(arg["xcol"].replace(/;/g,"%2C").replace(/\[/g,"%28").replace(/\]/g,"%29"))+") as CHAR) as yy";


						var mds = arg["ds"]?arg["ds"].split(";"):new Array();
						
						var phys = physdb(arg["ds"]);
						
						var sSQL = "select IF(ds_title=\"[null]\",\"[null]\",CAST(ds_id as CHAR)),"+arg["col"]+",ds_pub from "+_db_prefix+phys["masterdb"]+" where ds_rev_id in ("+mds.join(",")+") and (ds_pub & "+pubcond[0]+") = "+pubcond[1]
								   +" "+(arg["where"]?("and "+unescape(arg["where"])):"")
								   +" "+(arg["groupby"]?("group by "+arg["groupby"].replace(/;/g,",")):"")
						           +" "+(arg["orderby"]?("order by "+arg["orderby"].replace(/;/g,",")):"order by ds_title")
								   +" "+(arg["limit"]?("limit "+arg["limit"].replace(/;/g,",")):"limit 0,255")
						//Response.Write(sSQL)
						//Response.End();
						
						function array2to3(_arr)
						{
						   for(var j=(_arr.length*1.5-3); j>=0; j-=3)
						   {
								var k = j/1.5;
								_arr[j+2] = 0; 
								_arr[j+1] = _arr[k+1];
								_arr[j]   = _arr[k];
						   }
						   return _arr;
						}
						
						if(arg["opt"])
						{
							var arr = array2to3(arg["sep"]?arg["opt"].split(arg["sep"]):csv2array(unescape(arg["opt"])));
						}
						else if(arg["op2"])
						{
							var arr = arg["sep"]?arg["op2"].split(arg["sep"]):csv2array(unescape(arg["op2"]));
							for(var j=arr.length-1;j>=0;j--)
							{
							   arr[j*2] = arr[j];
							   arr[j*2+1] = arr[j];
							}
						}
						else if(arg["xopt"])
						{
							var arr = arg["sep"]?arg["xopt"].split(arg["sep"]):arg["xopt"].split(";");
							for(var k=arr.length*2-2;k>0;k-=2)
							{
								arr[k+1] = arr[k/2];
								arr[k] = (k/2)+1;
							}
							arr[1] = arr[0];
							arr[0] = 1;
						}
						else
							var arr = oDB.getrows(sSQL);
						
						var lngsel = arg["lng"] && arg["lng"].indexOf(_language)>0 ? (arg["lng"].indexOf(_language)/5) : 0;  // LANGUAGE SENSITIVENESS
						
						var sessionchoice = -1;
						
						
						//Response.Write("rawdata["+curfieldID+"] = "+rawdata[curfieldID-1]);
						
						
						if(bSubmitted)
							Session(dt+"_"+curfieldID+"_"+type) = value;
						var sessionchoice = Session(dt+"_"+curfieldID+"_"+type);
							
						//Response.Write(dt+"_"+curfieldID+"_"+type)
						
						
						
							
						searchform = "\r\n<select name=\""+name+"\" "+attr+">\r\n"
									 +"\t<option value=\"\">\r\n";
						
						//Response.Write(name+" "+formfld+"<br>")
						
						
						for(var j=0;j<arr.length;j+=3)
						{
						    //Response.Write(typeof(formfld)+" - "+typeof(arr[j])+" - "+typeof(sessionchoice)+"<br>")
							
							if(arg["lng"]) arr[j+1] = csv2array(arr[j+1])[lngsel];    // LANGUAGE SENSITIVE COMBO
							//Response.Write(formfld+" - "+arr[j]+" - "+sessionchoice+" - "+value+"<br>")
								searchform += "\t<option value=\""+arr[j]+"\""
											+((formfld?arr[j]==formfld || Number(arg["xdef"])==(j/2):arr[j]==sessionchoice)?" SELECTED":"")
											+">"
											+utf8to16(arr[j+1]?arr[j+1]:(arr[j]?("["+arr[j]+"]"):""))
											+"\r\n";
						}
						
						
						//for(var j=0;j<arr.length;j+=2)
						//	searchform += "\t<option value=\""+arr[j]+"\""+((value?arr[j]==value:arr[j]==sessionchoice)?" SELECTED":"")+">"+(arr[j+1]?arr[j+1]:("["+arr[j]+"]"))+"\r\n";
						
						searchform += "</select>\r\n"
						
						//+"</td></tr>";
						
						
						
					}
					else if(args[0]=="tree")
					{
						var arg  = argparser(args[1]);
						
						var enumcatfld = new Array();
						var catfld  = ("rt_id,rt_parent_id,rt_index,1 as rt_level,rt_name").split(",");
						var categories = oDB.getrows("select "+catfld.join(",")+" from "+_db_prefix+"reviewtype where rt_dir_lng = \""+_dir+"\"")// and rt_typ = "+rev_type);
						for (var j=0; j<catfld.length ; j++)
							enumcatfld[catfld[j]] = j;
						
						var oTREE		= new oGUI.TREE();
						oTREE.init();
						var tree		= oTREE.load(categories);
						
						var bArray = typeof(value)=="array" || typeof(value)=="object";
						if(!bArray)
							value = new Array(new String(value));
						
						//Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
						
						//Response.Write("<tr><td bgcolor=#E0E0E0>*");
						var k=0;
						searchform = oTREE.combobox("name="+name+" size=1",value).replace(/ value=0/,"") + "\r\n\r\n";
						//searchform += "</td></tr>";				
					}
					
				break;
			}

			
			if(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
				bVisiblesearch = false;
			
			if(bVisiblesearch)
				searchengine += "<tr><td><span class=small>"+oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2]+"</span></td><td>"+searchform+"</td></tr>\r\n";
		}
		
		searchclause = searchclause.replace(/= "\\]/g," is null ");
		searchclause = searchclause.replace(/LIKE "%\[null\]%"/g," is null ");
		searchclause = searchclause.replace(/= "\[not null\]/g," is not null ");
		searchclause = searchclause.replace(/LIKE "%\[not null\]%"/g," is not null ");
		
		
		searchclause = searchclause.replace(/LIKE "%\[empty\]%"/g," = \"\" ");		
		searchclause = searchclause.replace(/LIKE "%\[not empty\]%"/g," <> \"\" ");
		searchclause = searchclause.replace(/= "%\[empty\]%"/g," = \"\" ");		
		searchclause = searchclause.replace(/= "%\[not empty\]%"/g," <> \"\" ");		
		
		searchclause = searchclause.replace(/  AND 1/g,"");
		
		
		bSpiderSafeURL = typeof(SiderSafeURL)=="string"; 
		searchengine += "<tr><td></td><td><input type=submit value="+_T["search"]+" onmousedown=\"return OnSubmitForm()\"> "
						+"&nbsp; <a href="+(bSpiderSafeURL?(SiderSafeURL+"_Q_pag_E_0"+SpiderSafeExt+_extraurl+""):"?pag=1"+_extraurl+"")+" class=small>["+_T["clear"]+"]</a>"
						+"</td></tr>";		
		searchengine += "</table><br>\r\n";
		searchengine += "</td></tr></table><br>\r\n";
		
		
		if(bHiddenSearch)
		{
			searchengine = "";
			for(var i=0;i<oSETTINGS.settingdata["SEARCH_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
			{
				var fldname = enumdataset[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
				var formfld = bSubmitted==true?Request.Form(fldname).Item:(Request.QueryString("s"+idx).Item?Request.QueryString("s"+idx).Item:"");
				searchengine +=  "<input type=hidden name="+fldname+" value=\""+Server.HTMLEncode(formfld)+"\">\r\n";
			}
		}
		
		// D O   N O T   D I S P L A Y   S E A R C H   B O X   W H E N  N U M B E R   O F   A D - H O C   S E A R C H E S   =   S E A R C H E S 
		if(!bDisplaySearchBox)
			searchengine = "";
		
	}
	

    // CHECK-UNCHECK FUNCTION
	var checkact = Request.QueryString("check").Item;
	switch(checkact)
	{
	   case "ca":
	       var uSQL = "update "+_db_prefix+masterdb+" set ds_pub = IF(ds_pub is NULL,1,ds_pub | 1) where ds_rev_id = "+true_id;
		   oDB.exec(uSQL);
	   break;
	   case "ua":
	   	   var uSQL = "update "+_db_prefix+masterdb+" set ds_pub = IF(ds_pub is NULL,0,~(~ds_pub | 1)) where ds_rev_id = "+true_id;
		   oDB.exec(uSQL);
	   break;
	   case "cs":
	       var uSQL = "update "+_db_prefix+masterdb+" set ds_pub = ds_pub | 1 where ds_rev_id = "+true_id+" "+searchclause;
		   oDB.exec(uSQL);
	   break;
	   case "us":
	   	   var uSQL = "update "+_db_prefix+masterdb+" set ds_pub = ~(~ds_pub | 1) where ds_rev_id = "+true_id+" "+searchclause;
		   oDB.exec(uSQL);
	   break;
	   
	}
	
	Response.Write("\r\n<!--\r\n"+uSQL+"\r\n-->\r\n")
	

	// SCRIPT CACHE
	var scriptcache = new Array();

	for(var i=0;i<oSETTINGS.settingdata["LIST_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
	{
		var type = oSETTINGS.settingdata["LIST_PROPERTIES"][i+3];
		var format = oSETTINGS.settingdata["LIST_PROPERTIES"][i+4];
		var attr   = oSETTINGS.settingdata["LIST_PROPERTIES"][i+5];
		
		var args = argsplitter(format);
		var curfieldID = oSETTINGS.settingdata["LIST_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]];
		curfieldID = curfieldID?Number(curfieldID.substring(1,curfieldID.length-1)):0;
		
		switch(type)
		{
			case "ref":
			break;
			case "setting":
			if(format=="json" && attr)
			{
			    //Response.Write("eval("+attr+")<br>")
			    eval(attr)
			}
			break;
		}
		
		if(args[0]=="refexe")
		{
			var arg  = argparser(args[1]);
			if(arg["script"])
			{
				scriptcache[curfieldID] = unescape(arg["script"]);
			}
			else if(arg["scriptid"])
			{
				var rid = arg["scriptid"].toString().decrypt("nicnac");
				var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_ws+"\" and (rev_pub & 9) = 1 and rev_id = "+rid+" limit 0,1";
				var script = oDB.get(sSQL);
				scriptcache[curfieldID] = script;
			}
		}
	}	
	
	
	
	_extraurl += (linkclause?linkclause:"");

	var whereclause = searchclause+(deepsearchclause.length>0?(" AND ds_id in ("+deepsearchclause.join(",")+") "):"");	

	// U S E R   P R E S E L E C T I O N
	// USED FOR PRIVATISING ON RECORD LEVEL WHERE ONE COLUMN IS MATCHING THE USER ID (READ-ONLY FILTER)
	var idx_userselect = -1;

	if(bAdmin==false && bEdit==true)
	{
		for(var i=0;i<hfields.length;i++)
		{
			var idx = i*oSETTINGS.p_dbcol.length;
			
			//Response.Write(oSETTINGS.settingdata["LIST_PROPERTIES"][ enumsettings[hfields.item(i).text]+2]+"<br>")
			
			if( oSETTINGS.settingdata["LIST_PROPERTIES"][ enumsettings[hfields.item(i).text]+2] == "userID")
			{
				whereclause += (whereclause.length>0?" AND ":"")+hfields.item(i).getAttribute("name")+" = "+_uid;
				//Response.Write((whereclause.length>0?" AND ":"")+hfields.item(i).getAttribute("name")+" = "+_uid+"<br>")
			}
		}
	}

	


	var displayfld = new Array();
	
	var checkarr =    ["on","sum","lck","hid"];
	var checktitles = ["Online","Apprear in summary","Locked","Hidden/Trashed"];


	var act = Request.Form("act").Item;
	if(act)
	{
		if(act.indexOf(",")>0)
			act = act.substring(0,act.indexOf(","))
	}
		
	var data = new Array();
	
	var disp_history = "";
	var dsid = 0;
	if (act == _T["new"])
	{
		for(var i=0;i<oSETTINGS.settingdata["SEARCH_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
		{
			var bVisiblesearch = true;
			
			//var fldname = enumdataset[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var dbfldname = enumheader[ oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var idx = Math.round(i/oSETTINGS.p_dbcol.length);
			if(!fldname)
			{
				// SEARCH PARAM ENRICHMENT
				if(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
				{
					formfld = sparr[i+3];
					data[dbfldname] = formfld;
				}
			}
			else
			{
				var formfld = bSubmitted==true?Request.Form(fldname).Item:(Request.QueryString("s"+idx).Item?Request.QueryString("s"+idx).Item:"");
				data[dbfldname] = formfld;
			}
			
			//Response.Write(dbfldname+" = "+formfld+"<br>");
	    }
		
		var dsfields_idx = new Array();
		var idata = new Array();
			
		var dsfields = new Array("ds_id","ds_rev_id","ds_title","ds_desc","ds_header","ds_num01","ds_num02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_datetime01","ds_datetime02","ds_datetime03","ds_datetime04","ds_pub")
		var dslengths         = {"ds_title":256
                            ,"ds_desc":512
                            ,"ds_num01":9
                            ,"ds_num02":9
                            ,"ds_data01":100
                            ,"ds_data02":100
                            ,"ds_data03":100
                            ,"ds_data04":100
                            ,"ds_data05":100
                            ,"ds_data06":100                           
                            }
		var dstypes         = {"ds_id":"number"
                            ,"ds_rev_id":"number"
							,"ds_title":"string"
							,"ds_desc":"string"
							,"ds_header":"string"
                            ,"ds_num01":"number"
                            ,"ds_num02":"number"							
                            ,"ds_data01":"string"
                            ,"ds_data02":"string"
                            ,"ds_data03":"string"
                            ,"ds_data04":"string"
                            ,"ds_data05":"string"
                            ,"ds_data06":"string"
							,"ds_datetime01":"date"
							,"ds_datetime02":"date"
							,"ds_datetime03":"date"
							,"ds_datetime04":"date"							
							,"ds_pub":"number"
                            }
							
						
        if(dsdefaults && dsdefaults["dbfriends"])
		   dsid = oDB.get("select MAX(ds_id) from "+_db_prefix+masterdb+" where ds_rev_id in ("+true_id+","+dsdefaults["dbfriends"].join(",")+")");
		else
		    dsid = oDB.get("select MAX(ds_id) from "+_db_prefix+masterdb+" where ds_rev_id = "+true_id);
		    

				
		var dsdefaults      = {"ds_id":(dsid = dsid ? Number(dsid+1) : 1)
                            ,"ds_rev_id":true_id
							//,"ds_title":"\"\""
							//,"ds_desc":"\"\""
							//,"ds_header":"\"\""
							,"ds_datetime01":"SYSDATE()"
							,"ds_pub":(typeof(dsdefaults)=="undefined"?0:dsdefaults["ds_pub"])
                            }				


							
		// E N R I C H   W I T H   D E F A U L T   V A L U E S
		var j = 0;
		for(var i=0;i<dsfields.length;i++)
		{
			var curfld = dsfields[i];
			dsfields_idx[dsfields[i]] = i;
			
			var bDefault = typeof(dsdefaults[curfld])!="undefined";
			
			//Response.Write("data["+curfld+"]="+data[curfld]+" ")
			//Response.Write("dsdefaults["+curfld+"]="+dsdefaults[curfld]+"<br>")
			
			if(!data[curfld] && !dsdefaults[curfld])
			{
				dsdefaults[curfld] = "null";
				bDefault = true;
			}
			
			//Response.Write(curfld+" "+data[curfld]+" "+dsfields[i]+"<br>")
			
			switch(dstypes[curfld])
			{
			   case "number":
				idata[i] = bDefault?dsdefaults[curfld]:data[curfld];
			   break;
			   case "string":
				idata[i] = bDefault?dsdefaults[curfld]:("\""+data[curfld].substring(0,dslengths[curfld])+"\"");
			   break;
			   case "date":
			    idata[i] = bDefault?dsdefaults[curfld]:("\""+data[curfld]+"\"");
			}

          //Response.Write(curfld + " "+typeof(dsdefaults[curfld])+" "+typeof(idata[i])+"<br>")

			// PURGE OUT NULL INSERTION FIELDS
			if(typeof(dsdefaults[curfld])!="undefined" 
			   && dsdefaults[curfld]!="null")
			{
			    dsfields[j] =  dsfields[i];
				idata[j]    =  idata[i]
				j++;
			}

		}
		// PURGE INSERTION FIELDS LENGTH
		dsfields.length = j;
		idata.length = j;

		
		iSQL = "insert into "+_db_prefix+masterdb+" ("+dsfields.join(",")+") values (" + idata.join(",") + ")";
		
		if(bDebug)
			Response.Write(iSQL+"<br>")

		oDB.err = function() {};
		oDB.exec(iSQL);
		oDB.err = function(_err) { Response.Write(_err) };

		if(oDB.errmsg)
		{
			var iSQL = "insert into "+_db_prefix+masterdb+" ("+dsfields.join(",")+") values ("+
			+idata[dsfields_idx["ds_id"]]+","
			+idata[dsfields_idx["ds_rev_id"]]+","
			+idata[dsfields_idx["ds_title"]]+","
			+idata[dsfields_idx["ds_pub"]]
			+")"
			//Response.Write(iSQL)
			oDB.exec(iSQL)
		}
		
		////////////////////////////////////
		//  D E F A U L T   I N S E R T S //
		////////////////////////////////////
		
		for(var i=0;i<oSETTINGS.settingdata["FIELD_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
		{
			var fldname = enumdataset[  oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var dbfldname = enumheader[ oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][i+3];
			var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][i+4];
			
			var args = argsplitter(format);
			var arg  = argparser(args[1]);
			var format = args[0];
			
			//Response.Write("enumheader[ "+oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]+" ];<br>")
			
			var idx = Math.round(i/oSETTINGS.p_dbcol.length);
			var formfld = "";
			
			var fidx = oSETTINGS.settingdata["FIELD_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]];
			fidx = fidx.substring(1,fidx.length-1);
			
			//Response.Write("formfld="+formfld+" "+dbfldname+" "+fidx+"<br>");
			//Response.Write(type+"<br>");
			
			var cfg = new Array(_db_prefix,masterdb,detaildb,dbfldname);
			var data = new Array(id,fidx,dsid,quote(arg["def"]));
			switch(type)
			{
				case "string":
					if(args[0]=="password")
					{
					
						var data_arg = arg["data"]?arg["data"].split(";"):new Array();
						var data_val = new Array();
						var range = "";
						
						for(var k=0;k<data_arg.length;k++)
						{						
							switch(data_arg[k])
							{
								case "alnum.cap":
									range = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
									var passarr = new Array();
									var passidx = new Array();
									var guesslen = 20;
									var guessalert = 10;
									for(var m=0;m<guesslen;m++)
										passarr[m] = passmaker(range,Number(arg["len"]));
									
									//passarr[0] = "E46P293";
									//passarr[1] = "O46Z292";
									//passarr[2] = "O46Z292";
									//passarr[3] = "O46Z292";
									//passarr[4] = "O46Z292";
									
									var sSQL = "select rd_text from usite_datadetail where rd_ds_id = "+true_id+" and rd_dt_id = "+fidx+" and  rd_text in (\""+passarr.join("\",\"")+"\")"
									var usedpass = oDB.getrows(sSQL);
									for(var m=0;m<usedpass.length;m++)
										passidx[usedpass[m]] = true;
									
									//Response.Write(sSQL)
									
									var guesscount = 0;
									for(var m=0;m<guesslen && passidx[passarr[m]];m++)
									{
										if(passidx[passarr[m]])
											guesscount++ 
									}
									
									if(m<guesslen)
									{
										if(guesscount>=guessalert)
										{
											Response.Write("PASSWORD FOUND = "+passarr[m]+" LENGTH DANGER !! GUESSALERT "+guesscount+"/"+guessalert);
											data[3] = quote(passarr[m]);
											vdb(data,cfg);
										}
										else
										{
											//Response.Write("PASSWORD FOUND = "+passarr[m]);
											data[3] = quote(passarr[m]);
											updatevdb(data,cfg);
										}
									}
									else
										Response.Write("PASSWORD COULD NOT BE MADE !!");
									
										
									//Response.Write(passarr.join("<br>"))
								break;
							}
						}
						
						function passmaker(range,len)
						{
							var str = "";
							for(var l=0;l<len;l++)
								str += range.charAt(Math.round(Math.random()*range.length))
							return str;
						}
						

										
						//Response.Write(data_val+"<br>");
					
					}
				case "number":
					if(args[0]=="check")
					{
						if(arg["def"])
							updatevdb(data,cfg);
					}
				break;
				case "date":
					if(args[0]=="date")
					{
						if(arg["def"])
						{
						
							if(arg["def"]=="today" || arg["def"]=="modified" || arg["def"]=="created")
								data[3] = quote((new Date()).format("%Y-%m-%d %H:%M:%S"));
							else
								data[3] = quote(arg["def"].toDate(arg["fmt"]).format("%Y-%m-%d %H:%M:%S"));
							//Response.Write(data[3]+"<br>")
							updatevdb(data,cfg);
						}
					}
				case "ref":
					if(args[0]=="combo")
					{
						if(arg["def"])
							updatevdb(data,cfg);
					}
					
				break;
			}
			
			function updatevdb(data,cfg)
			{
			    
			
				if(dbfldname && cfg[3])
				{
					var uSQL = "update "+cfg[0]+cfg[1]+" set "+cfg[3]+" = "+data[3]+" where ds_id = "+data[2]+" and ds_rev_id = "+data[0];
					oDB.exec(uSQL);
					if(bDebug)
						Response.Write(uSQL+"<br>");
				}
				
				if(detaildb)
				{
					var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
					var iSQL = "insert into "+cfg[0]+cfg[2]+" ("+rawfld.join(",")+") values ("+data.join(",")+")";
					oDB.exec(iSQL);
					if(bDebug)
						Response.Write(iSQL+"<br>");
				}				
			}
		}
		
		
		////////////////////////////////////////////////
		//  S E A R C H - D O M A I N   I N S E R T S //
		////////////////////////////////////////////////
		
		for(var i=0;i<oSETTINGS.settingdata["SEARCH_PROPERTIES"].length;i+=oSETTINGS.p_dbcol.length)
		{
			var fldname = enumdataset[  oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			var dbfldname = enumheader[ oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]] ];
			
			//Response.Write("enumheader[ "+oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]]+" ];<br>")
			
			var idx = Math.round(i/oSETTINGS.p_dbcol.length);
			var formfld = Request.QueryString("s"+idx).Item;
			if(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
				formfld = sparr[i+3];
			
			//Response.Write(oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
			
			if(typeof(Request.QueryString("s"+idx).Item)!="undefined" || oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+2].indexOf("field [")==0)
			{
				
				var fidx = oSETTINGS.settingdata["SEARCH_PROPERTIES"][i+oSETTINGS.p_idx["columnID"]];
				fidx = fidx.substring(1,fidx.length-1);
				//Response.Write("formfld="+formfld+" "+dbfldname+" "+fidx+"<br>");
				
				if(dbfldname)
				{
					var uSQL = "update "+_db_prefix+masterdb+" set "+dbfldname+" = \""+formfld+"\" where ds_id = "+dsid+" and ds_rev_id = "+true_id;
					oDB.exec(uSQL);
					if(bDebug)
						Response.Write(uSQL+"<br>");
				}
				
				if(detaildb)
				{
					var rawfld = new Array("rd_ds_id","rd_dt_id","rd_recno","rd_text");
					var data = new Array();
					data[0] = true_id;
					data[1] = fidx;
					data[2] = dsid;
					data[3] = quote(formfld);
					
					if(data[0] && data[1])
					{
						var dSQL = "delete from "+_db_prefix+detaildb+" where rd_ds_id = "+data[0]+" and rd_dt_id = "+data[1]+" and rd_recno = "+data[2];
						oDB.exec(dSQL);
						if(bDebug)
							Response.Write(dSQL+"<br>");
						
						var iSQL = "insert into "+_db_prefix+detaildb+" ("+rawfld.join(",")+") values ("+data.join(",")+")";
						oDB.exec(iSQL);
						if(bDebug)
							Response.Write(iSQL+"<br>");
					}
				}
			}
		}
		
		
		
		
	}

	var checkformarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		checkformarr[new String(checkarr[i])] = Request.Form("chk_"+checkarr[i]).Item;

	var bSubmitted	  = Request.TotalBytes==0?false:true;
	if (act == _T["refresh"] || act== '')
		bSubmitted = false;	
		
	// GENERATE CHECKBOX ARRAY PARAMETERS

	var pubarr = new Array();

	for (var i=0;i<checkarr.length;i++)
		if (checkformarr[checkarr[i]])
		{
			var tmp = checkformarr[new String(checkarr[i])].split(",");
			for (var j=0 ; j<tmp.length ; j++)
				pubarr[new Number(tmp[j])] = pubarr[new Number(tmp[j])]?(pubarr[new Number(tmp[j])] + (1<<i) ):(1<<i);
		}
	
	function loadXML(_xmlstr)
	{
		var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async="false";

		if(_xmlstr)
		{
			xmlDoc.loadXML(_xmlstr);
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
	

	
	//////////////////////////////////////////////////////////////
	//  P A G E   N A V I G A T I O N  I N I T I A L I S E R S  //
	//////////////////////////////////////////////////////////////
	
	var pag = Request.QueryString("pag").Item?Number(Request.QueryString("pag").Item):1;
	var spp = 10;  // MAX NAVIGATIONBAR WIDTH
	var ipp = 25; // ITEMS PER PAGE
	var maxrec = 10000;
	
	// Q U E R Y   D A T A S E T


	var lSQL = "select count(*) from "+_db_prefix+masterdb+" where ds_rev_id = "+true_id+" "+whereclause;
	Response.Write("\r\n<!--\r\n"+lSQL+"\r\n-->\r\n")
	
	
	var overviewcount = oDB.get(lSQL);
	
	
	dbinfo[dbinfo.length] = "count="+overviewcount
	overviewlength=overviewcount*tablefld.length;
	
	//Response.Write(_db_prefix+"/ /"+masterdb+"<br>")

	//Response.Write(lSQL)
	
	var limit = pag==0 ? ("LIMIT 0,"+maxrec) : ("LIMIT "+(pag-1)*ipp+","+ipp);	
	//if (orderby && orderby==Math.floor(orderby))	
	//	var orderclause = isNaN(orderby)?"":("order by (ds_pub=0 && LENGTH(ds_title)=0) desc,"+tablefld[Math.abs(orderby)-1]+" "+(orderby<0?"desc":"asc"));
	//else
	//	var orderclause = isNaN(orderby)?"":("order by (ds_pub=0 && LENGTH(ds_title)=0) desc,("+tablefld[Math.floor(Math.abs(orderby))-1]+" & "+(1<<Math.round(-1+10*(Math.abs(orderby)-Math.floor(Math.abs(orderby)))))+") "+(orderby<0?"desc":"asc"));
	
	if (orderby && orderby==Math.floor(orderby))
	{
		var fld = tablefld[Math.abs(orderby)-1]
		var curfieldID = hfields.item(enumheaderfld[fld]).text
		var i 	= Number(enumsettings[curfieldID])-1;
		var type = oSETTINGS.settingdata["LIST_PROPERTIES"][i+3];
		var format = oSETTINGS.settingdata["LIST_PROPERTIES"][i+4];
		
		if(type=="number")
			fld = "cast("+fld+" as SIGNED)"
		
		var orderclause = isNaN(orderby)?"":("order by "+fld+" "+(orderby<0?"desc":"asc"));
	}
	else
		var orderclause = isNaN(orderby)?"":("order by "+tablefld[Math.floor(Math.abs(orderby))-1]+" & "+(1<<Math.round(-1+10*(Math.abs(orderby)-Math.floor(Math.abs(orderby)))))+" "+(orderby<0?"desc":"asc"));
	
	if(orderclause.length==0)
		orderclause = "order by ds_id desc";
	
	var sSQL = "select "+headerfld.join(",")+" from "+_db_prefix+masterdb+" where ds_rev_id = "+true_id+" "+whereclause+" "+orderclause+" "+limit;
	var overview = oDB.getrows(sSQL);
	//if(bDebug)
		Response.Write("\r\n\r\n\r\n\r\n\r\n\r\n<!--\r\n\r\n" + sSQL+"\r\n\r\n-->\r\n\r\n\r\n\r\n\r\n");



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
	
	if(settingspage >0 && (bEdit || bAdmin))
		pgnav += "&nbsp;&nbsp;<a href="+zerofill(settingspage,2)+"_admin.asp?sp=1$number$exact$"+id+" class=small target=_blank>["+_T["nav_settings"]+"]</a>"

	var ippl = ipp*tablefld.length;
	if (pag==0)
		ippl = overviewlength>(maxrec*tablefld.length)?(maxrec*tablefld.length):overviewlength;
	var ipps = pag==0?0:ippl*(pag-1);

	// U P D A T E

	if (act == _T["save"])
	{
	
		for( var i=0 ; i < overview.length ; i+= tablefld.length )
		{
			var check_mask = (1<<(checkarr.length))-1
			var pub = bSubmitted==true?(pubarr[overview[i+enumfld["ds_id"]]]?pubarr[overview[i+enumfld["ds_id"]]]:0):overview[i+enumfld["ds_pub"]];
			
			if ((pub & check_mask) != (overview[i+enumfld["ds_pub"]] & check_mask))
			{
					//Response.Write(SQL+"<br>");
					//var history =  overview[i+enumfld["ds_id"]] + ",\"" + fr + "\",\"" +  Session("uid") + "\",\"" +((pub&1)==1?"+":"-") + "\",\"" + ( typeof(overview[i+enumfld["ds_date_published"]])=="date"?new Date(overview[i+enumfld["ds_date_published"]]).format("%d-%m-%Y %H:%M"):""  ) + "\",\"" + (overview[i+enumfld["ds_title"]]?overview[i+enumfld["ds_title"]].substring(0,100):"") + "\"<br>";
					//disp_history += history;
					
					//var batch_idx = oDB.takeanumber(_app_db_prefix+"batch");
					//iSQL = "insert into batch (b_id,b_text) values (" + batch_idx + "," + quote(history) + ")";
					//oDB.exec(iSQL);
					
					//Response.Write( (1<<(checkarr.length))-1 );
					
					var uSQL = "update "+_db_prefix+masterdb+" set ds_pub = (IFNULL(0,ds_pub) & ~"+check_mask+") | "+pub+" where ds_id = "+overview[i+enumfld["ds_id"]]+" and ds_rev_id = "+true_id;
					if(bDebug)
						Response.Write(uSQL);
					oDB.exec(uSQL);
			}
		}
		//Response.Write(SQL+"<br>");
		var overview = oDB.getrows(sSQL);
	}

	//Response.Write(overview+"<br>");

	var url = enum_tabledefs[id][defenumfld["rev_url"]];	



	// M A P P I N G   T A B L E   S E T T I N G S   F R O M   D A T A B A S E
	
	for(var i=0;i<hfields.length;i++)
	{
		var idx 		= i*oSETTINGS.p_dbcol.length;
		var colnum 	= enumsettings[hfields.item(i).text];
		var colname   = hfields.item(i).getAttribute("name");
		var bReplace 	= typeof(colnum)=="number" && oSETTINGS.settingdata["LIST_PROPERTIES"].length>0;
		var bHidden  	= (oSETTINGS.settingdata["LIST_PROPERTIES"].length==0 || bReplace) == false
		
		fieldparam[idx+enumparam["colnum"]]  = colnum;
		fieldparam[idx+enumparam["colname"]] = colname;
		fieldparam[idx+enumparam["hidden"]]  = bHidden;
		
		if(!enumdataset[ hfields.item(i).text ])
		{
			Response.Write("<img src=../images/exclame.gif> header field name "+hfields.item(i).text+" undefined");
			continue;
		}
		if(bHidden==false)
		{
			fieldparam[idx+enumparam["title"]]	= bReplace ? oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+oSETTINGS.p_idx["columnID"]] : enumdataset[ hfields.item(i).text ].replace(/(\w)/g," $1").toUpperCase();
			fieldparam[idx+enumparam["type"]]	= colname=="dt_date" && bReplace==false?"date":oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+2];
			fieldparam[idx+enumparam["format"]]	= oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+3];
			fieldparam[idx+enumparam["attr"]]	= oSETTINGS.settingdata["LIST_PROPERTIES"][colnum+4];	
		}		
	}

    

// FUNCTIONS
	
	function argsplitter(_str)
	{
		var _spl = new Array();
		if(_str)
		{
			var _parr = new String(_str).split("(");
			_spl[0] = _parr[0];
			_spl[1] = _parr[1]?_parr[1].substring(0,_parr[1].indexOf(")")):"";
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
	
	function order(itemID)
	{
		itemID++;
		if((itemID==orderby || itemID==-orderby) && orderby)
			return -orderby;
		else
			return itemID;
	}
	
	var commands = "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["refresh"]+"\" style=height:17px;font-size:9px>";
	commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["new"]+"\" style=height:17px;font-size:9px>";
	commands += "&nbsp;<input type=\"submit\" name=\"act\" value=\""+_T["save"]+"\" style=height:17px;font-size:9px>";
	
	if(isearch)
	{
		searchengine += "<script>";

		searchengine +="String.prototype.ltrim = function () { return this.replace(/^ */,\"\"); }\r\n"
		+"String.prototype.rtrim = function () { return this.replace(/ *$/,\"\"); }\r\n"
		+"String.prototype.trim  = function () { return this.ltrim().rtrim(); }\r\n"
		+"\r\n"
		+"var forcerefresh = 120; // FORCE REFRESH EVERY N SECONDS TO MAINTAIN SESSION\r\n"
		+"function gorefresh()\r\n"
		+"{\r\n"
		//+" document.write('hey');"
		+"	setTimeout(\"gorefresh()\",3000);	\r\n"
		+"	try\r\n"
		+"	{\r\n"
		+"		var bC0 = parent.main."+isearch+".value != main."+isearch+".value;\r\n"
		//+"		var bC1 = parent.main."+isearch+".value?true:false;\r\n"
		//+"		var bC2 = parent.main."+isearch+".value.toString().trim() != \",\";\r\n"
		//+"		var bC3 = parent.main."+isearch+".value.toString().trim() != \"\";\r\n"
		+"		var bC4 = forcerefresh==0;\r\n"
		+"		\r\n"
		+"		if(bC0 || bC4)\r\n"
		+"		{\r\n"
		//+"alert(main."+isearch+".value);\r\n"
		+"			forcerefresh = 10;\r\n"
		+"			main."+isearch+".value = parent.main."+isearch+".value;\r\n"
		+"			main.submit();\r\n"
		+"		}\r\n"
		+"		forcerefresh--;\r\n"
		+"	}\r\n"
		+"	catch(e)\r\n"
		+"	{}\r\n"
		+"}\r\n"
		+"if(forcerefresh==120)\r\n"
		+"window.onload = gorefresh;\r\n"
		+"</script>\r\n"
	}
	
%>


<STYLE>
	.qtable { background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.qtable td{ background-color:white;padding-left: 1px;padding-right: 1px;padding-top: 1px;padding-bottom: 1px;}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 10px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
	.gold { background-color:black;text-align:center;font-size:8px;color:gold;font-weight:bold; }
</STYLE>

<%
if(searchengine)
{
%>
<script>
function OnSubmitForm()
{
	try
	{
	  var href = window.location.href
	  document.main.action = href.replace(new RegExp("pag=<%=Request.QueryString("pag").Item%>&","i"),"")
	}
	catch(e)
	{
	}
}
</script>
<%}%>


<form name=main id=main method=post>
<%=bHiddenSearch?"":"<center>"%>

<%=searchengine%>

<%=bHiddenSearch?"":(commands+"&nbsp;&nbsp;"+pgnav+"<br><br>")%>
<table cellspacing=1 class=qtable>
<!--COLGROUP span="1">
<COL>
<COL>
<%
	for (var i=0;i<checkarr.length;i++)
		Response.Write("<COL>\r\n");

	for(var i=0;i<hfields.length;i++)
	{
		var idx = i*oSETTINGS.p_dbcol.length;
		if(!fieldparam[idx+enumparam["hidden"]])
			Response.Write("<COL>\r\n")
	}	
%>-->
<COLGROUP>
<COL>
<COL>
<%
	for (var i=0;i<checkarr.length;i++)
		Response.Write("<COL>\r\n");

	for(var i=0;i<hfields.length;i++)
	{
		var idx = i*oSETTINGS.p_dbcol.length;
		var attr    = fieldparam[idx+enumparam["attr"]];
		if(!fieldparam[idx+enumparam["hidden"]])
			Response.Write("<COL"+(attr?(" "+attr):"")+">\r\n")
	}
	
		// GATHER PERSISTENT URL PARAMETERS
		var persistflds = new Array();
		var pf = 0;
		if(bHiddenSearch)
			persistflds[pf++] = "pag=0";
		if(typeof(Request.QueryString("isearch").Item)!="undefined")
			persistflds[pf++] = "isearch="+Request.QueryString("isearch").Item;
		if(typeof(Request.QueryString("skin").Item)!="undefined")
			persistflds[pf++] = "skin="+Request.QueryString("skin").Item;
		if(typeof(Request.QueryString("bop").Item)!="undefined")
			persistflds[pf++] = "bop="+Request.QueryString("bop").Item;			
		if(persistflds.length>0)
			persistflds[0] = "&"+persistflds[0];	
%>
<tr>
	<td style=background-color:black; class=gold><a style=font-size:8px;color:gold;font-weight:bold href=<%=_page+"?id="+Request.QueryString("id").Item+"&orderby="+order(enumfld["ds_id"])+(linkclause?linkclause:"")+persistflds.join("&")%> title='ID'>ID</a> <span><img src="../images/ii_info.gif" border=0 title="<%=dbinfo.join("\r\n")%>"></span></td>
	<%
		if(url)
		{
	%>
	<td style=background-color:black; title='View'></td>
	<%
		}
	%>
	<td style=background-color:black; title='Edit'></td>
	<%

	
		for (var i=0;i<checkarr.length;i++)
			Response.Write("<td style=background-color:black; class=gold title='"+checktitles[i]+"'><a style=font-size:8px;color:gold;font-weight:bold href="+_page+"?id="+Request.QueryString("id").Item+"&orderby="+order((1+(10*enumfld["ds_pub"])+i)/10)+(linkclause?linkclause:"")+persistflds.join("&")+">"+checkarr[i]+"</a></td>\r\n");
			
		for(var i=0;i<hfields.length;i++)
		{
			var idx = i*oSETTINGS.p_dbcol.length;
			var colname = fieldparam[idx+enumparam["colname"]];
			var attr    = fieldparam[idx+enumparam["attr"]];
			if(!fieldparam[idx+enumparam["hidden"]])
				Response.Write("<td style=background-color:black; "+(attr?attr:"")+" class=gold><a style=color:gold class=gold href="+_page+"?id="+Request.QueryString("id").Item+"&orderby="+order(enumfld[colname])+(linkclause?linkclause:"")+persistflds.join("&")+">"+fieldparam[idx+enumparam["title"]]+"</a></td>\r\n")
		}
	%>
</tr>

<%
Response.Write("\r\n<!-- overview.length = "+overview.length+" -->\r\n")

	for( var i=0 ; i < overview.length ; i+= tablefld.length )
	{
		
		var pub = bSubmitted==true?(pubarr[overview[i+enumfld["ds_id"]]]?pubarr[overview[i+enumfld["ds_id"]]]:0):overview[i+enumfld["ds_pub"]];
		
		var rowcolor = "";
		var pub = Number(overview[i+(tablefld.length-1)]);
		
		switch(pub & 3)
		{
			case 1: rowcolor = "background-color:#EAEAFF"; break;
			case 2: rowcolor = "background-color:#EAFFEA"; break;
			case 3: rowcolor = "background-color:#CADFDF"; break;
		}		
		
		if (overview[i+enumfld["ds_title"]])
			overview[i+enumfld["ds_title"]] = overview[i+enumfld["ds_title"]].substring(0,100);
		else
			overview[i+enumfld["ds_title"]] = "";
				
		Response.Write("<tr>");
		Response.Write("<td>"+overview[i+enumfld["ds_id"]]+"</td>");
		//Response.Write("<td><a target="+detailtarget+" href="+zerofill(ds_type,2)+"_detail.asp?id="+overview[i+enumfld["ds_id"]].toString().encrypt("nicnac")+"><img src=../images/i_view.gif border=0></a></td>");
		
		if(url)
			Response.Write("<td><a target="+detailtarget+" href=../"+_ws+"_"+_language+"/"+url+"?ds="+dt+"&dsid="+overview[i+enumfld["ds_id"]].toString().encrypt("nicnac")+"><img src=../images/i_view.gif border=0></a></td>");
		
		var EditLink = "";
		
		if ((overview[i+enumfld["ds_pub"]] & 4) == 0 && (overview[i+enumfld["ds_pub"]] & 8) == 0)
		{
			EditLink = zerofill(ds_type,2)+"_rec_dlg.asp?dt="+dt+"&id="+overview[i+enumfld["ds_id"]].toString().encrypt("nicnac");
			Response.Write("<td><a target="+detailtarget+" href="+EditLink+"><img src=../images/i_edit.gif border=0></a></td>");
		}
		else if ((overview[i+enumfld["ds_pub"]] & 8) == 8 && (overview[i+enumfld["ds_pub"]] & 1) == 0 && (bAdmin || bDelete))
			Response.Write("<td><a target="+detailtarget+" href="+zerofill(ds_type,2)+"_id_dlg.asp?dt="+dt+"&id="+overview[i+enumfld["ds_id"]].toString().encrypt("nicnac")+"><img src=../images/i_delete.gif border=0></a></td>");
		else
			Response.Write("<td></td>");			
			
		for (var j=0;j<checkarr.length;j++)
			Response.Write("<td style=text-align:center;background-color:#e0e0e0><input type=checkbox name=chk_"+checkarr[j]+" value="+overview[i+enumfld["ds_id"]]+" "+( ( pub & (1<<j) )==(1<<j)?"checked":"" )+"></td>");
		
		var email = overview[i+enumfld["ds_email"]];
		
		////////////////////////////////////////////////////
		// D I S P L A Y   M A I N   D A T A   T A B L E  //
		////////////////////////////////////////////////////
		
		try
		{
			var jpeg = Server.CreateObject("Persits.Jpeg");
		}
		catch(e)
		{
			function jpeg()
			{}
		}
		var fso = Server.CreateObject("Scripting.FileSystemObject");
		
		for(var j=0;j<hfields.length;j++)
		{
			var idx = j*oSETTINGS.p_dbcol.length;
			var dbindex = hfields.item(j).getAttribute("name");
			
			var curfieldID = hfields.item(j).text;
			var index = enumsettings[curfieldID];
			curfieldID = curfieldID?Number(curfieldID.substring(1,curfieldID.length-1)):0;

			var val = overview[i+enumfld[dbindex]];
			val = val==null?"":val;
			var value = val;
			
			var format = fieldparam[idx+enumparam["format"]];
			var formatargs = new Array()
			if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
			{
				var args = argsplitter(format);
				format     = args[0];
				formatargs  = argparser(args[1]);
			}
			else
				args = new Array();
			
			if(fieldparam[idx+enumparam["hidden"]]==false)
			{
				//Response.Write( fieldparam[idx+enumparam["type"]] +"*"  )
				
				var type = fieldparam[idx+enumparam["type"]];
				var value = val;
				
				switch( type )
				{
					case "multistring":
						val = unescape(val);
					case "string":
						switch( format )
						{
							case "url":
								var urltxt = formatargs["img"]?"<img src=\""+formatargs["img"]+"\" border=\"0\" title=\""+val+"\">":val
								if(!val) urltxt = "";
								Response.Write("<td style='"+rowcolor+"'><a href="+val+" target=_blank>"+urltxt+"</a></td>");
							break;
							case "urltext":
								var urltxt = formatargs["img"]?"<img src=\""+formatargs["img"]+"\" border=\"0\">":val
								Response.Write("<td style='"+rowcolor+"'><a href="+val+" target=_blank>"+urltxt+"</a></td>");
							break;
							case "email":
								var urltxt = formatargs["img"]?"<img src=\""+formatargs["img"]+"\" border=\"0\" title=\""+val+"\">":val
								Response.Write("<td style='"+rowcolor+"'>"+(val?("<a href=mailto:"+val+" target=_blank>"+urltxt+"</a>"):"")+"</td>");
							break;
							case "textarea":
								Response.Write("<td style='"+rowcolor+";padding:10 10 10 10'>"+(val?val.replace(/\r\n/g,"<br>"):"")+"</td>");							
							break;
							case "format":
							    var arg  = argparser(args[1]);
								val = arg["len"] && typeof(val)=="string"?val.substring(0,arg["len"]):val
								
								Response.Write("<td style='"+rowcolor+";padding:10 10 10 10'>"+(val?val.replace(/\r\n/g,"<br>"):"")+"</td>");							
							break;								
							default:
								Response.Write("<td style='"+rowcolor+"'>"+val+"</td>");
						}
					break;
case "imgsiz":
					case "img":
					case "img.jpg":
					case "img.png":
						if(val & 1)
						{
							var img_ext     = type.split(".").length==2?("."+type.split(".")[1]):".jpg";
							var farr = format.split(",");
							
							var filebase = zerofill(id,10)+"_"+zerofill(overview[i+enumfld["ds_id"]],6)+"_"+ zerofill( hfields.item(j).text.substring(1,hfields.item(j).text.length-1),3 )  ;
							var filepath = "../"+_ws+"/images";
							var imgpub = val;
							
							Response.Write("<td style='"+rowcolor+"'>");
							
							for(var k=0;k<farr.length;k++)
							{
								if(farr[k])
								{
									var farr1 = farr[k].split("x");
									var title = ""
									
									try
									{
										var fullfilepath = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
										var file = fso.GetFile(fullfilepath)
										title += Math.round(file.Size/1024)+"Kb "+new Date(file.DateLastModified).format("%d %b %Y")
									}
									catch(e){}
									
									Response.Write("<a target=_blank href="+EditLink+">");
									Response.Write("<img src=../"+_ws+"/images/img"+filebase+"_"+k+img_ext+"?"+(Math.floor(Math.random()*10000))+" width="+farr1[0]+" height="+farr1[1]+" border=0 title=\""+title+"\">");
									Response.Write("</a>");
									
									if(type=="imgsiz")
									{
										jpeg.open( fullfilepath );
										Response.Write("<br><small>"+jpeg.Width+"x"+jpeg.Height+"</small>");
									}
								}
							}
							Response.Write("</td>")
							 
							  
						}
						else
							Response.Write("<td style='"+rowcolor+"'><a target=_blank href="+EditLink+">upload</a></td>");
					break;
					case "gallery":
					case "gallery.jpg":
					case "gallery.png":
					var ext = type.split(".")[1]?type.split(".")[1]:"jpg";
				
						if(val & 1)
						{
							var farr = format.split(",");
							var fpos = farr.length-1;
							var farr1 = farr[fpos].split("x");
							var filebase = zerofill(id,10)+"_"+zerofill(overview[i+enumfld["ds_id"]],6)+"_"+ zerofill( hfields.item(j).text.substring(1,hfields.item(j).text.length-1),3 )  ;
							var imgpub = val;
							//http://www.blackbaby.be/usite/sparklingideas/images/img0000000990_000001_010_00_0.jpg?6466
							
							Response.Write("<td style='"+rowcolor+"'><a target=_blank href="+EditLink+"><img src=../"+_ws+"/images/img"+filebase+"_00_"+fpos+"."+ext+"?"+(Math.floor(Math.random()*10000))+" width="+farr1[0]+" height="+farr1[1]+" border=0></a></td>")
						}
						else
							Response.Write("<td style='"+rowcolor+"'><a target=_blank href="+EditLink+">upload</a></td>");
					
					break;
					case "file":
					
					   if(format=="guid")
					   {
					      if(val)
						  {
						    var filebase = val;
						    var filepath = "../"+_ws+"/res";
							var fullfilepath = Server.MapPath(filepath)+ "\\" + filebase;
							var bFileExists = true;
							var furl = filepath + "/" + filebase + "?"+(Math.floor(Math.random()*10000));
							Response.Write("<td style='"+rowcolor+"' valign=top>"+(bFileExists?"<a href=\""+furl+"\" target=_blank>":"")+"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 "+(bFileExists?("title='download "+val+" file'"):"")+"></a></td>\r\n");					  
						  }
						  else
						    Response.Write("<td style='"+rowcolor+"'><a target=_blank href="+EditLink+">upload</a></td>");
					   }
					break;
					case "date":
					
						if(args[0]=="date")
						{
							var arg  = argparser(args[1]);
							arg["fmt"] = arg["fmt"]?arg["fmt"]:"%Y-%m-%d %H:%M:%S";
							
							if(typeof(val)=="date" && arg["attr"])
							{
								try
								{
									var date1 = new Date();
									var date2 = new Date(val);
									
	
									var diff_date = date1 - date2;
									var num_years = (diff_date/31536000000);
									var num_months = ((diff_date % 31536000000)/2628000000);
									var num_days = (((diff_date % 31536000000) % 2628000000)/86400000);
					
									var vdate = zerofill(Math.abs(Math.floor(num_years+1)).toString(),4)+"-"+zerofill(Math.abs(Math.floor(num_months+1)).toString(),2)+"-"+zerofill(Math.abs(Math.floor(num_days+1)).toString(),2)+" 00:00:00"
									
									vdate = vdate.toDateString(arg["fmt"]);
									if(num_years<0 || num_months<0 || num_days<0)
										vdate = "-"+vdate;
 
									
								}
								catch(e)
								{
									var vdate = e.description;
								}
							}
							else
								var vdate = typeof(val)=="date"?new Date(val).format(arg["fmt"]):val;
							
							
							Response.Write("<td style='"+rowcolor+"'>"+vdate+"</td>");
						}
						else
							Response.Write("<td style='"+rowcolor+"'>"+( typeof(val)=="date"?new Date(val).format(format):val  )+"</td>");
					break;
					case "cdate":
						var bPast = (new Date(val) - new Date())<0;
						Response.Write("<td style='"+rowcolor+"'>"+(bPast?"":"<span style=color:#800000>")+( typeof(val)=="date"?new Date(val).format(format):val  )+(bPast?"":"</span>")+"</td>");
					break;					
					case "number":
						Response.Write("<td style='"+rowcolor+"'>");
						if(format=="EUR")
						{
							val = (val/100).toFixed(2).replace(/\./,",");
							Response.Write(val);
						}
						else if(format=="bitmap")
						{
							if(formatargs["opt"])
							{
								formatargs["opt"] = formatargs["opt"].split(",");
								var len = formatargs["len"]?Number(formatargs["len"]):( formatargs["opt"].length>0?formatargs["opt"].length:value.toString(2).length );								
								for(k=0;k<len;k++)
								{
									if((Number(val)>>k)&1)
										Response.Write(formatargs["opt"][k]);
								}
							}
							else
								Response.Write(zerofill(Number(val).toString(2),formatargs["len"]?formatargs["len"]:8));
						}
						else if(format=="refexe")
						{
							var script = scriptcache[curfieldID];
							eval(script);
						}
						else if(format=="check")
						{

							var arg  = argparser(args[1]);

							if(arg["opt"] && arg["opt"].indexOf("%2C")>=0)
							{
								var options = arg["opt"]?csv2array(unescape(arg["opt"])):new Array();
							}
							else if(arg["opt"])
							{
							   var options = arg["sep"]?arg["opt"].split(arg["sep"]):arg["opt"].split("|");
							   //Response.Write(options)
							}
							else if(arg["iopt"])
								var options = arg["iopt"]?csv2array(unescape(arg["iopt"])):new Array();
								
							
							var len = val?Number(val).toString(2).length:0;
							var enumarr = new Array();
							var m = 0;
							for(k=0;k<len;k++)
							{
								//Response.Write(!!((Number(val)>>k)&1)+"_"+options[k]+" p ["+isNaN(val)+"]<br>");
								//Response.Write(options.join(",")+"<br>")
								
								if((Number(val)>>k)&1)
									enumarr[m++] = options[k];
							}
							
							if(arg["iopt"] && m>0)
								Response.Write("<img src=../images/"+enumarr.join("><img src=../images/")+">")
							else
								Response.Write(enumarr.join(arg["sep"]?arg["sep"]:" "));
						}
						else
							Response.Write(val);
							
						Response.Write("</td>");
					break;
					case "multinumber":
						if(format=="EUR")
						{
							var farr = val?val.split(","):new Array();
							Response.Write("<td style='"+rowcolor+"'>");
							for(var k=0;k<farr.length;k++)
							{
								Response.Write((k==0?"":" - ")+(Number(farr[k])/100).toFixed(2).replace(/\./,","));
							}
							Response.Write("</td>");
						}
						else
							Response.Write("<td style='"+rowcolor+"'>"+val+"</td>");
					break;					
					case "url":
						Response.Write("<td style='"+rowcolor+"'><a href="+(val.indexOf("http://")<0?("http://"+val):val)+" target=_blank>"+val+"</a>*</td>");
					break;
					case "multiref":
						var args = argsplitter(format);
						var arg  = argparser(args[1]);
						if(!arg["dbsep"]) arg["dbsep"] = ","
						var value = val?val.toString().split(arg["dbsep"]):new Array();
					case "ref":
					
													
						Response.Write("<td style='"+rowcolor+"'>");
						
						//Response.Write("$"+enumsettings[hfields.item(j).text]+"$ "+enumsettings[hfields.item(j).text]+" "+oSETTINGS.settingdata["LIST_PROPERTIES"]+"<br><br>")
						
						var offset = enumsettings[hfields.item(j).text]-1;
						var format = oSETTINGS.settingdata["LIST_PROPERTIES"][offset+4];
						var attr = oSETTINGS.settingdata["LIST_PROPERTIES"][offset+5];
						
						var args = argsplitter(format);
						//Response.Write(curfieldID + " "+format+" "+attr);
						if(args[0]=="reftxt" || args[0]=="combo")
						{
							var arg  = argparser(args[1]);
							var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
							var key = curfieldID+arg["ds"];
							//Response.Write(args[1]+"<br>")

							
							if(typeof(oDATA.namecache_data[key])=="undefined") // THIS QUERY WILL RUN ONLY ONCE !
							{
								if(arg["sep"])
									arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(arg["sep"]).join(",' ',")+")"):"ds_title";
								else
									arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(",").join(",' ',")+")"):"ds_title";
								
								if(arg["xcol"])
									arg["col"] = "CAST(CONCAT("+unescape(arg["xcol"].replace(/;/g,"%2C").replace(/\[/g,"%28").replace(/\]/g,"%29"))+") as CHAR) as yy";

								var phys = physdb(arg["ds"]);
								//var cur_masterdb = phys["masterdb"];
								//var cur_detaildb = phys["detaildb"];
								//var cur_deepsearch_dbfilter = phys["filter"];
								
								//var cur_arr = oDB.get("select rev_publisher from usite_review where rev_id = 2867 and (rev_pub & 9) = 1")
								//var cur_arr = cur_arr?cur_arr.split(","):new Array();
								//var cur_masterdb = cur_arr[0]?cur_arr[0]:_masterdb;
								//var cur_detaildb = cur_arr[1]?cur_arr[1]:_detaildb;
								//var cur_deepsearch_dbfilter = cur_arr[2]?cur_arr[2]:"";
								
								var mds = arg["ds"]?arg["ds"].split(";"):new Array();
								var sSQL = "select ds_id,"+arg["col"]+" from "+_db_prefix+physdb(arg["ds"])["masterdb"]+" where ds_rev_id in ("+mds.join(",")+") and (ds_pub & "+pubcond[0]+") = "+pubcond[1];
								
								//Response.Write(sSQL)
								
								if(arg["opt"])
									var arr = arg["sep"]?arg["opt"].split(arg["sep"]):csv2array(unescape(arg["opt"]));
								else if(arg["op2"])
								{
									var arr = arg["sep"]?arg["op2"].split(arg["sep"]):csv2array(unescape(arg["op2"]));
									for(var k=arr.length-1;k>=0;k--)
									{
									   arr[k*2] = arr[k];
									   arr[k*2+1] = arr[k];
									}
								}
								else if(arg["xopt"])
								{
									var arr = arg["sep"]?arg["xopt"].split(arg["sep"]):arg["xopt"].split(";");
									for(var k=arr.length*2-2;k>0;k-=2)
									{
										arr[k+1] = arr[k/2];
										arr[k] = (k/2)+1;
									}
									arr[1] = arr[0];
									arr[0] = 1;
								}
								else
								{
									var arr = oDB.getrows(sSQL);
								}
								
								//Response.Write(arr+"*<br>")
								
								

								var lngsel = arg["lng"] && arg["lng"].indexOf(_language)>0 ? (arg["lng"].indexOf(_language)/5) : 0;  // LANGUAGE SENSITIVENESS
								
								var enumarr = new Array();
								for(var k=arr.length-2;k>=0;k-=2)
									enumarr[arr[k]] = arg["lng"]?csv2array(arr[k+1])[lngsel]:arr[k+1];
									
								//for(var k=arr.length-2;k>=0;k-=2)
								//	Response.Write("enumarr["+arr[k]+"] = "+enumarr[arr[k]]+"<br>");
								
								oDATA.namecache_data[key] = enumarr;
							}
							
							//Response.Write("**"+typeof(val)+"**")
							
							if(typeof(val)=="string" && val.indexOf(",")>=0) // TAKE CARE OF MULTIREF ENUM VALUES
							{
								var arrval = val.split(",");
								for(k=0;k<arrval.length;k++)
								{
									var cval = oDATA.namecache_data[key][arrval[k]]
									Response.Write((k>0?",":"")+(!cval && val!="0" && val?"<img src=../images/exclame.gif alt=\""+_T["admin_obsolete_ref"]+" ("+arrval[k]+")\">":utf8to16(cval)));
								}
							}
							else
							{
								var cval = oDATA.namecache_data[key][val];
								
								//Response.Write("**"+oDATA.namecache_data[key][val]+"**")
								//Response.End()
								
								//Response.Write("*"+utf8to16(cval)+"*")
								Response.Write(!cval && val!="0" && val?"<img src=../images/exclame.gif alt=\""+_T["admin_obsolete_ref"]+" ("+val+")\">":utf8to16(cval));
								//Response.End()
							}
						}
						else if(args[0]=="refurl")
						{
							var arg  = argparser(args[1]);
							var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
							
							var key = curfieldID+arg["ds"];
							if(typeof(oDATA.namecache_data[key])=="undefined")
							{
								arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(",").join(",\" \",")+")"):"ds_title";
								var sSQL = "select ds_id,"+arg["col"]+" from "+_db_prefix+masterdb+" where ds_rev_id = "+arg["ds"]+" and (ds_pub & "+pubcond[0]+") = "+pubcond[1];
								var arr = oDB.getrows(sSQL);
								//Response.Write(sSQL);
								var enumarr = new Array();
								for(var k=arr.length-2;k>=0;k-=2)
								{
									//Response.Write("enumarr["+arr[k]+"] = "+arr[k+1]+"<br>");
									enumarr[arr[k]] = "<a href=\""+arr[k+1]+"\" target=_blank>"+arr[k+1]+"</a>";
								}
								oDATA.namecache_data[key] = enumarr;
							}
							Response.Write(oDATA.namecache_data[key][val]);
						}
						else if(args[0]=="refexe")
						{
							var script = scriptcache[curfieldID];
							eval(script);
						}
						else if(args[0]=="management")
						{
							var arg  = argparser(args[1]);
							var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
							var key = curfieldID+arg["id"];
							
							
							if(typeof(oDATA.namecache_data[key])=="undefined")
							{
								arg["col"] = arg["col"]?("CONCAT("+arg["col"].split(",").join(",\" \",")+")"):"rev_title";
								var sSQL = "select rev_id,"+arg["col"]+" from "+_db_prefix+"review where rev_rt_typ = "+arg["id"]+" and (rev_pub & "+pubcond[0]+") = "+pubcond[1];
								var arr = oDB.getrows(sSQL);
								//Response.Write(sSQL);
								var enumarr = new Array();
								for(var k=arr.length-2;k>=0;k-=2)
								{
									//Response.Write("enumarr["+arr[k]+"] = "+arr[k+1]+"<br>");
									enumarr[arr[k]] = "<span title=\""+arr[k]+"\">"+arr[k+1]+"</span>";
								}
								oDATA.namecache_data[key] = enumarr;
							}
							
							var val_decrypted = val?Number(val.toString().decrypt("nicnac")):0;
							Response.Write(oDATA.namecache_data[key][val_decrypted]);
						}
						else if(args[0]=="field")
						{
							var arg  = argparser(args[1]);
							var pubcond = arg["pubcond"]?arg["pubcond"].split("-"):new Array(9,1);
							if(arg["id"])
							{
								var bArray = typeof(value)=="array" || typeof(value)=="object";
								var key = curfieldID;
							
								if(typeof(oDATA.namecache_data[key])=="undefined") // THIS QUERY WILL RUN ONLY ONCE !
								{
									var fwclause = "where rev_dir_lng=\""+_ws+"\" and rev_rt_typ = "+arg["id"]+" and (rev_pub & "+pubcond[0]+") = "+pubcond[1]
													+(arg["like"]?(" and rev_title like \""+arg["like"]+"\""):"");
									var sSQL = "select rev_id,rev_title,rev_rev from "+_db_prefix+"review "+fwclause					
									//Response.Write(sSQL+"<br><br>");
									
									var farr = oDB.getrows(sSQL);
									var enumarr = new Array();
									for(var k=farr.length-3;k>=0;k-=3)
									{
										enumarr[farr[k]+".0"] = "<span title=["+(farr[k]+".0")+"]><i>"+farr[k+1]+"</i>.<b>[ID]</b></span>"
										//" <font color=#B0B0C0>["+(farr[k]+".0")+"]</span>";
										
										var fXMLheader = farr[k+2];
										var fXMLObj = loadXML(fXMLheader);
										var fhfields = fXMLObj.getElementsByTagName("ROOT/row/field");
										for(var l=0;l<fhfields.length;l++)
										{
											var cur = fhfields.item(l).text;
											var hID = cur ? Number(cur.replace(/\[([0-9]+)\]/,"$1")) : "";
											var hstr = fhfields.item(l).getAttribute("name");
											enumarr[farr[k]+"."+hID] = "<span title=["+(farr[k]+"."+hID)+"]><i>"+farr[k+1]+"</i>.<b>"+hstr+"</b></span>"
											//" <font color=#B0B0C0>["+(farr[k]+"."+hID)+"]</font>";
											//Response.Write("enumarr["+(farr[k]+"."+hID)+"] = "+(enumarr[farr[k]+"."+hID])+"<br>");
										}
									}
									oDATA.namecache_data[key] = enumarr;
								}
								
								if(bArray)
								{	
									if(arg && arg["max"] && value.length >= Number(arg["max"]))
										var ilen = Number(arg["max"]);
									else
										var ilen = value.length;
								}
								else
									var ilen = 1;
								if(oDATA.namecache_data[key])
									for(var k=0;k<ilen;k++)
									{
										var val = bArray?value[k]:value;
										var cval = oDATA.namecache_data[key][val];

										Response.Write(!cval && val?("<img src=../images/exclame.gif alt=\""+_T["admin_obsolete_ref"]+"\">"):"")
										Response.Write((cval?cval:value)+"<br>");
									}
							}
						}
						else if(args[0]=="img")
						{
						    //Response.Write("<tr>"+fieldheader(curfieldID,fldesc,name,en,enl)+"<td bgcolor=#E0E0E0>");
						    var arg  = argparser(args[1]);
						   	if(arg["path"])
							{
								Response.Write("<img src="+arg["path"].replace(/___img___/,value)+">");
							}
							//Response.Write("</td></tr>");
						}						
						
						
						Response.Write("</td>");
						
					break;
					default:
						if(format=="email")
							Response.Write("<td style='"+rowcolor+"'><a href=mailto:"+val+">"+val+"</a></td>");
						else
							Response.Write("<td style='"+rowcolor+"'>"+val+"</td>");
				}
			}
		}
		
		/*
		Response.Write("<td style='"+rowcolor+"'>"+( typeof(overview[i+enumfld["ds_datetime01"]])=="date"?new Date(overview[i+enumfld["ds_datetime01"]]).format("%d-%m-%Y %H:%M"):""  )+"</td>");
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ds_title"]]+"</td>"); // title
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ds_desc"]]+"</td>");  // desc
		Response.Write("<td style='"+rowcolor+"'>"+overview[i+enumfld["ds_header"]]+"</td>");  // desc
		Response.Write("<td style='"+rowcolor+"'>"+(email?("<a href=mailto:"+email+" title="+email+"><img src=../images/ii_email.gif border=0></a>"):"")+"</td>");  // desc
		*/
		
		Response.Write("</tr>");
	}	
	
%>
</table><br>
<%=commands%><%=bHiddenSearch?"":("&nbsp;&nbsp;"+pgnav+"<br><br>")%>

<% if (bHiddenSearch==false) {%>

<a href="<%=zerofill(ds_type,2)%>_ops_dlg.asp?id=<%=Request.QueryString("id").item%>" class=small target=_blank>[<%=_T["operations"]%>]</a>
<!--&nbsp;&nbsp;&nbsp;<a href="<%=zerofill(ds_type,2)%>_export.asp?id=<%=Request.QueryString("id").item%>" class=small>[<%=_T["export"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="<%=zerofill(ds_type,2)%>_json.asp?id=<%=Request.QueryString("id").item%>" class=small>[<%=_T["json"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="<%=zerofill(ds_type,2)%>_tbl_dlg.asp?id=<%=Request.QueryString("id").item%>" class=small>[<%=_T["tablebuilder"]%>]</a>
-->
&nbsp;&nbsp;&nbsp;<a href="<%=zerofill(ds_type,2)%>_<%=bAdmin?"admin":"edit"%>.asp" class=small>[<%=_T["back"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="?pag=<%=Request.QueryString("pag").Item%>&id=<%=Request.QueryString("id").item%>&check=ca<%=linkclause%>" class=small>[<%=_T["check_all"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="?pag=<%=Request.QueryString("pag").Item%>&id=<%=Request.QueryString("id").item%>&check=ua<%=linkclause%>" class=small>[<%=_T["uncheck_all"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="?pag=<%=Request.QueryString("pag").Item%>&id=<%=Request.QueryString("id").item%>&check=cs<%=linkclause%>" class=small>[<%=_T["check_selection"]%>]</a>
&nbsp;&nbsp;&nbsp;<a href="?pag=<%=Request.QueryString("pag").Item%>&id=<%=Request.QueryString("id").item%>&check=us<%=linkclause%>" class=small>[<%=_T["uncheck_selection"]%>]</a>
<%}%>

</center>
<br>
<small><%=disp_history%></small>


<input type=hidden name=act>
<input type=hidden name=nextact value="<%=dsid?dsid.toString().encrypt("nicnac"):""%>">
</form>

