<%@ Language=JavaScript %>

<%

Request.QueryString()

%>

<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var bDebug = false;
	
	var rev_type = 2;
	var cat_type = 2;
	
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var _uid = Session("uid");
	var _dir = Session("dir");

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	
	var _templdat = new Array();
	var i = 0;
	
	if(typeof(bExec)!="boolean")
		var bExec = oDB.permissions([zerofill(rev_type,2)+"_admin"]);

	if(typeof(_oDB)=="undefined")
		var _oDB = oDB;


    var seq = Request.QueryString("seq").Item;
	if(seq)
		seq = seq.split("-");
	else
		seq = new Array(0,0);

	var id = Request.QueryString("id").Item.toString().decrypt("nicnac");

    var sSQL = "select rev_title,rev_desc from "+_db_prefix+"review where rev_id = "+id;
    var enumqarr = {"rev_title":0,"rev_desc":1}
	var qarr = _oDB.getrows(sSQL);
	if(bDebug)
		Response.Write(sSQL+"<br>")
		
	
	var flds = ("ds_id,ds_title,ds_desc,ds_header,ds_data01,ds_data02,ds_data03,ds_data04,ds_pub").split(",");
	var nflds = ("id,field,link,criteria,orderby,format,destination,navigation,pub").split(",");

	// ALL NEEDED FIELDS
	//var sSQL = "select "+flds.join(",")+" from usite_dataset where ds_rev_id = "+id+" and ds_pub in (1,2,3) order by convert(ds_title,unsigned)"
	var sSQL = "select "+flds.join(",")+" from usite_dataset where ds_rev_id = "+id+" and ds_pub in (1,2,3) order by ds_id"

	var arr = _oDB.getrows(sSQL);
	var ifld = new Array();
	for(var i=0;i<nflds.length;i++)
		ifld[nflds[i]] = i;

	// ALL NEEDED VIRTUAL DATABASES
	var sSQL = "select convert(ds_title,unsigned) from usite_dataset where ds_rev_id = "+id+" and ds_pub in (1,2,3) group by convert(ds_title,unsigned)"	
	var dbs = _oDB.getrows(sSQL);
	
	var dbs_masterdb = new Array();
	var dbs_detaildb = new Array();
	var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub");
	var enumfld = new Array();	
	for (var i=0; i<tablefld.length ; i++)
		enumfld[tablefld[i]] = i;
	
	var enumfield = new Array();
	for(var i=0;i<dbs.length;i++)
	{
		var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+dbs[i];
		var overview = _oDB.getrows(sSQL);
		
		dbs_masterdb[i] = "dataset";
		dbs_detaildb[i] = "datadetail";
		
		if(overview[enumfld["rev_publisher"]] && overview[enumfld["rev_publisher"]]!=null)
		{
			var marr = overview[enumfld["rev_publisher"]].split(",");
			dbs_masterdb[dbs[i]] = marr[0];
			dbs_detaildb[dbs[i]] = marr[1];
			
			var XMLheader = overview[enumfld["rev_rev"]]
			var XMLObj = loadXML(XMLheader);
			var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
			
			enumfield[dbs[i]+".0"] = (i+1)+"_"+overview[enumfld["rev_title"]]+"_ID";
			for(var j=0;j<hfields.length;j++)
			{
				var cur = hfields.item(j).text;
				var hID = cur ? Number(cur.replace(/\[([0-9]+)\]/,"$1")) : "";
				var hstr = hfields.item(j).getAttribute("name");
				enumfield[dbs[i]+"."+hID] = (i+1)+"_"+hstr;
				
				//Response.Write("enumfield["+(dbs[i]+"."+hID)+"] = "+enumfield[dbs[i]+"."+hID]+"<br>")
			}
			
			
		}
		

	}

	//Response.Write(dbs_masterdb+" "+dbs_detaildb)
	
	
	if(seq[0]==0)
		nseq = 0
	else if(seq[0]==seq[1])
		nseq = 3;
	else if(seq[0]==(seq[1]-1))
	    nseq = 2;
	else
	    nseq = 1;
	
	
	switch(nseq)
	{
		case 0:
			// CRITERIA COUNT
			for(var i=0;i<arr.length;i+=flds.length)
			{
			   if(arr[i+ifld["criteria"]])
					seq[1]++;
			}
			seq[1]+=2;
			
			// PREPARE KEY LINK TABLE
			var dSQL = "DROP TABLE candi_key_db";
			try{ _oDB.exec(dSQL) }
			catch(e){}
			
			var selectclause = new Array();
			for(var i=0;i<dbs.length;i++)
			{
				selectclause[selectclause.length] = "d"+dbs[i]+".ds_id as f"+dbs[i]
			}
			selectclause[selectclause.length] = "0 as pub"
			selectclause[selectclause.length] = "0 as dsid"
			
			var fromclause = new Array();
			
			
			var sSQL = "select "+selectclause.join(",")+" from "+_db_prefix+dbs_masterdb[dbs[0]]+" as d"+dbs[0]+","+_db_prefix+dbs_masterdb[dbs[1]]+" as d"+dbs[1]+" where d"+dbs[0]+".ds_rev_id = "+dbs[0]+" and d"+dbs[1]+".ds_rev_id = "+dbs[1]+" and d"+dbs[0]+".ds_id = d"+dbs[1]+".ds_num01 and d"+dbs[0]+".ds_pub = 1 and d"+dbs[1]+".ds_pub = 1"
			var cSQL = "CREATE TABLE candi_key_db ENGINE=MEMORY ("+sSQL+")";
			_oDB.exec(cSQL);
			
			Response.Write(sSQL+"<br>")
			
			var aSQL = "ALTER TABLE candi_key_db ADD INDEX Index_0(f"+dbs[0]+")";
			_oDB.exec(aSQL);
			var aSQL = "ALTER TABLE candi_key_db ADD INDEX Index_1(f"+dbs[1]+")";
			_oDB.exec(aSQL);
			var aSQL = "ALTER TABLE candi_key_db ADD INDEX Index_ds(ds_id)";
			_oDB.exec(aSQL);
			var aSQL = "ALTER TABLE candi_key_db MODIFY COLUMN ds_id INT(1) NOT NULL DEFAULT NULL AUTO_INCREMENT";
			_oDB.exec(aSQL);
			
			eval(DYN_INCLUDE("VIRTUALDB.asp","v2"));
			var oVIRTUALDB = new VIRTUALDB();
			oVIRTUALDB.oDB = _oDB;
			oVIRTUALDB.create_init["mode"]="replace";
			oVIRTUALDB.create_init["databasename"] = "query_"+qarr[enumqarr["rev_title"]]
			oVIRTUALDB.create_init["physicaldbname"] = "dumpset,dumpdetail";
			
			var _cr = 0;
			for(var i=0;i<arr.length;i+=nflds.length)
			{
				//_cr = arr[i+ifld["id"]];
				
				if((Number(arr[i+ifld["pub"]])&1)==1)
				{
				
					oVIRTUALDB.create_init["detailfield_ids"][_cr] = arr[i+ifld["id"]];
					oVIRTUALDB.create_init["detailfields"][_cr] = enumfield[ arr[i+ifld["field"]] ].replace(/(<([^>]+)>)/ig,"");
					oVIRTUALDB.create_init["detailtypes"][_cr] = "";
					
					
					if(arr[i+ifld["navigation"]])
					{
						oVIRTUALDB.create_init["masterfields"][_cr] = arr[i+ifld["navigation"]];
						//Response.Write("["+(arr[i+ifld["id"]])+"] "+(enumfield[ arr[i+ifld["field"]] ])+" "+arr[i+ifld["navigation"]]+"<br>");
					}
					
					//Response.Write("["+_cr+"] "+(enumfield[ arr[i+ifld["field"]] ])+" "+arr[i+ifld["pub"]]+"<br>");
					_cr++;
				}
			}
			
			oVIRTUALDB.maptypes("MYSQL");
			//oVIRTUALDB.create();

			// CREATE RAW STRUCTURE
			var _sqlarr = oVIRTUALDB.create_sql();
		   for(var _j=0;_j<_sqlarr.length;_j++)
		   {
			  Response.Write("<!--\r\n\r\n"+_sqlarr[_j]+";\r\n\r\n-->");
			  this.oDB.exec(_sqlarr[_j]);
		   }
		   
		    // DROP TABLE CONTENT
		   	var _dsqlarr = oVIRTUALDB.drop();
			for(var _j=0;_j<_dsqlarr.length;_j++)
		   {
			  Response.Write("<!--\r\n\r\n"+_dsqlarr[_j]+";\r\n\r\n-->");
			  this.oDB.exec(_dsqlarr[_j]);
		   }
		   
		break;
		case 1:
			
			// PROCESS CRITERIA
			var b = 0;
			// QUERY FOR KEY BOUNDS
			if(seq[0]<seq[1])
			{
				for(var i=0;i<arr.length;i+=flds.length)
				{
					//Response.Write(arr[i]+" "+arr[i+ifld["field"]]+"<br>")
				   if(arr[i+ifld["criteria"]])
				   {
						if(Number(seq[0])==(b+1))
						{
							var dbnr = arr[i+ifld["field"]].split(".")[0]; 
							var fieldnr = arr[i+ifld["field"]].split(".")[1];
							
							var cSQL = "select count(*) from "+_db_prefix+dbs_detaildb[dbnr]+" where rd_ds_id = "+dbnr+" and rd_dt_id = "+fieldnr
							Response.Write(cSQL+"<br>");
							var count_total = _oDB.get(cSQL);
							
							var cSQL = "select count(*) from "+_db_prefix+dbs_detaildb[dbnr]+" where rd_ds_id = "+dbnr+" and rd_dt_id = "+fieldnr+" and rd_text "+unescape(arr[i+ifld["criteria"]]);
							Response.Write(cSQL+"<br>");
							var count = _oDB.get(cSQL);
							Response.Write("count="+count+"/"+count_total+" ("+(Math.round(10000*count/count_total)/100)+"%)<br>");
							
							var uSQL = "update candi_key_db,"+_db_prefix+dbs_detaildb[dbnr]+" set pub = pub | "+(1<<b)+" where rd_ds_id = "+dbnr+" and rd_recno =  f"+dbnr+" and rd_dt_id = "+fieldnr+" and rd_text "+unescape(arr[i+ifld["criteria"]]);
							Response.Write(uSQL+";<br>");
							var count = _oDB.exec(uSQL);
						}
						b++;
				   }
				}
			}
			
		break;
		case 2:
			// INSERT MASTER DATA
		
			eval(DYN_INCLUDE("VIRTUALDB.asp","v2"));
			
			var oVIRTUALDB = new VIRTUALDB();
			oVIRTUALDB.oDB = _oDB;
			oVIRTUALDB.create_init["mode"]="replace";
			oVIRTUALDB.create_init["databasename"] = "query_"+qarr[enumqarr["rev_title"]]
			oVIRTUALDB.create_init["physicaldbname"] = "dumpset,dumpdetail";
			
			oVIRTUALDB.ds = oVIRTUALDB.exists(oVIRTUALDB.create_init["databasename"],"");
			
			// COPY DATA
			var b = 0;
			var bitcriterium = 0;
			for(var i=0;i<arr.length;i+=flds.length)
			{
				if(arr[i+ifld["criteria"]])
				{
					bitcriterium += (1<<b)
					b++;
				}
			}
			
			var phys = oVIRTUALDB.create_init["physicaldbname"].split(",");
			
			// INSERT MASTER DATA RECORDS
			var iSQL = "insert into "+oVIRTUALDB.create_init["proj"]+phys[0]+" (ds_rev_id,ds_id,ds_pub) select "+oVIRTUALDB.ds+",ds_id,1 from candi_key_db where pub = "+bitcriterium
			_oDB.exec(iSQL);
			Response.Write(iSQL+";<br><br>");
			
			// FILL MASTER DATA COLUMNS
			
			var masterfields = new Array();
			for(var i=0;i<arr.length;i+=flds.length)
			{
				if((Number(arr[i+ifld["pub"]])&1)==1 && arr[i+ifld["navigation"]])
				{
					var dbnr = arr[i+ifld["field"]].split(".")[0]; 
					var fieldnr = arr[i+ifld["field"]].split(".")[1];
							
					//var fieldnr = arr[i+ifld["field"]].split(".");
					//var detaildb = dbs_detaildb[fieldnr[0]];
					//masterfields[masterfields.length] = arr[i+ifld["navigation"]]
					//Response.Write("["+(arr[i+ifld["id"]])+"] "+(enumfield[ arr[i+ifld["field"]] ])+" "+arr[i+ifld["navigation"]]+"<br>");
					// set "+arr[i+ifld["navigation"]]+" = rd_text
					//var sSQL = "select rd_text from "+oVIRTUALDB.create_init["proj"]+dbs_detaildb[dbnr]+",candi_key_db where pub = "+bitcriterium+" and rd_ds_id = "+dbnr+" and rd_dt_id = "+fieldnr+" and rd_recno = f"+dbnr
					//Response.Write(sSQL+"<br>")
					
					var uSQL = "update "+oVIRTUALDB.create_init["proj"]+phys[0]+" as u,"+oVIRTUALDB.create_init["proj"]+dbs_detaildb[dbnr]+" as d,candi_key_db as t set u."+arr[i+ifld["navigation"]]+" = rd_text  where pub = "+bitcriterium+" and rd_ds_id = "+dbnr+" and rd_dt_id = "+fieldnr+" and f"+dbnr+" = rd_recno and t.ds_id = u.ds_id"
					_oDB.exec(uSQL);
					//Response.Write(uSQL+";<br><br>");					
				}
			}
			

			
			 
			
		break;
		case 3:
			
			// INSERT DETAIL DATA
			
			var b = 0;
			eval(DYN_INCLUDE("VIRTUALDB.asp","v2"));
			var oVIRTUALDB = new VIRTUALDB();
			oVIRTUALDB.oDB = _oDB;
			oVIRTUALDB.create_init["mode"]="replace";
			oVIRTUALDB.create_init["databasename"] = "query_"+qarr[enumqarr["rev_title"]]
			oVIRTUALDB.create_init["physicaldbname"] = "dumpset,dumpdetail";
			oVIRTUALDB.ds = oVIRTUALDB.exists(oVIRTUALDB.create_init["databasename"],"");
			
			//Response.Write(oVIRTUALDB.ds+" "+overview[enumfld["rev_title"]]+" "+id+"<br>");
			
			// COPY DATA
			var b = 0;
			var bitcriterium = 0;
			for(var i=0;i<arr.length;i+=flds.length)
			{
				if(arr[i+ifld["criteria"]])
				{
					bitcriterium += (1<<b)
					b++;
				}
			}
			
			var phys = oVIRTUALDB.create_init["physicaldbname"].split(",");
			
			
			// INSERT DETAIL DATA
			
			for(var i=0;i<arr.length;i+=flds.length)
			{
				//SELECT 3014 as rd_ds_id,3 as rd_dt_id,ds_id as rd_recno,rd_text FROM candi_key_db,usite_datadetail where pub = 7 and rd_dt_id = 4 and rd_ds_id = 2867 and rd_recno = f2867
				if((Number(arr[i+ifld["pub"]])&1)==1)
				{
					var fieldnr = arr[i+ifld["field"]].split(".");
					var detaildb = dbs_detaildb[fieldnr[0]];
					var cSQL = "INSERT INTO "+oVIRTUALDB.create_init["proj"]+phys[1]+" (rd_ds_id,rd_dt_id,rd_recno,rd_text) SELECT "+oVIRTUALDB.ds+" as rd_ds_id,"+arr[i+ifld["id"]]+" as rd_dt_id,ds_id as rd_recno,rd_text FROM candi_key_db,"+_db_prefix+detaildb+" where pub = "+bitcriterium+" and rd_dt_id = "+fieldnr[1]+" and rd_ds_id = "+fieldnr[0]+" and rd_recno = f"+fieldnr[0]
					//Response.Write(cSQL+";<br><br>");
					_oDB.exec(cSQL);
				}
			}
			
		break;
	}
	
	seq[0]++;
	var nexturl = "http://"+_host+_url+"?id="+id.toString().encrypt("nicnac")+"&seq="+seq.join("-")
	Response.Write("<a href="+nexturl+">"+nexturl+"</a>");

	if(seq[0]<=seq[1])
		Response.Write("<script language=\"javascript\" type=\"text/javascript\">setTimeout(\"location = '"+nexturl+"';\",2000);</script>")

	// select d2867.ds_id as f2867,d2901.ds_id as f2901 from usite_dataset as d2867,usite_dataset as d2901 where d2867.ds_rev_id = 2867 and d2901.ds_rev_id = 2901 and d2867.ds_id = d2901.ds_num01 and d2867.ds_pub = 1 and d2901.ds_pub = 1

	
    var _templtext = "";


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
	return xmlDoc;
}

			
function DYN_INCLUDE(title,version)
{
   var sSQL = "select rev_rev from usite_review where rev_title = \""+title+"\" and rev_desc = \""+version+"\" and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 LIMIT 0,1"
   var exe = _oDB.get(sSQL);
   
   exe = "try {\r\n"
		   +exe
		   +"\r\n}"
		   +"\r\n"
		   +"catch(e)\r\n"
		   +"{\r\n"
		   +"  Response.Write(\"ERROR IN DYNAMIC INCLUDE \\\""+title+"\\\" "+version+"&lt;br&gt;\"+e.description)\r\n"
		   +"}"
		   +"\r\n"
		   
	return exe
}
	
%>

<%=_templtext%>
