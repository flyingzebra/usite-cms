<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<!--#INCLUDE FILE = "../includes/candiform.asp" -->
<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////

Response.Flush()

	var bDebug		 = false; 
	var bMaildisable = false;
	
	function MAILPARAM()
	{
		this.init = MAILPARAM_init;
		this.load = MAILPARAM_load;
		this.gen_dialog = MAILPARAM_gen_dialog;
		this.fld = new Array("from","sender","to","subject","body","attachments","embedded images","ID")
		this.dlg_ctrl = new Array();
		this.param = new Array();
		this.dialog = new Array();
		this.dialog_att = new Array();
		this.simulation = false;
		this.bSend = true;
	}

	function MAILPARAM_init()
	{
		for(var _sdc=0;_sdc<this.fld.length;_sdc++)
			this.dlg_ctrl[this.fld[_sdc]] = true;
	}
	
	function MAILPARAM_load(_arr)
	{
		for(var _mpl=0;_mpl<this.fld.length;_mpl++)
			this.param[this.fld[_mpl]] = _arr[_mpl];	
	}
	
	function MAILPARAM_gen_dialog()
	{
		var _arr = new Array();
		for(var _mgd=0;_mgd<this.dialog.length;_mgd+=2)
		{
			if(typeof(this.dialog[_mgd+1])=="string")
				_arr[_mgd] = "<tr><td"+(this.dialog_att[0]?(" "+this.dialog_att[0]):"")+">"+this.dialog[_mgd]+"</td><td"+(this.dialog_att[1]?(" "+this.dialog_att[1]):"")+">"+this.dialog[_mgd+1]+"</td></tr>\r\n";
			else
			{
				if(this.dlg_ctrl[this.dialog[_mgd]]=="hidden")
					_arr[_mgd] = "<tr><td></td><td"+(this.dialog_att[1]?(" "+this.dialog_att[1]):"")+">"+this.dialog[_mgd+1][this.dlg_ctrl[this.dialog[_mgd]]]+"</td></tr>\r\n";				
				else
					_arr[_mgd] = "<tr><td"+(this.dialog_att[0]?(" "+this.dialog_att[0]):"")+">"+this.dialog[_mgd]+"</td><td"+(this.dialog_att[1]?(" "+this.dialog_att[1]):"")+">"+this.dialog[_mgd+1][this.dlg_ctrl[this.dialog[_mgd]]]+"</td></tr>\r\n";
			}
		}
		return _arr.join("\r\n");
	}
	
	var oMAILPARAM = new MAILPARAM();
	oMAILPARAM.init();
	oMAILPARAM.dialog_att = new Array("class=small","class=small")

	var ds_type      = 23;
	var masterdb     = "dataset";
	var detaildb     = "datadetail";
	var settingspage = 22;
	var defaultstep  = 25;
	var step 		 = Request.QueryString("step").Item && !isNaN(Request.QueryString("step").Item)?Number(Request.QueryString("step").Item):defaultstep;
	
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));

	var dt = Request.QueryString("id").Item.toString();
	var id = Number(dt.decrypt("nicnac"));
	var sq = Request.QueryString("sq").Item?Number(Request.QueryString("sq").Item.toString()):0
	var from = Request.QueryString("from").Item?Request.QueryString("from").Item.decrypt("nicnac"):"";
	var to = Request.Form("to").Item;
	var act = Request.QueryString("act").Item;
	var overridesubj = true;
	var overrideto = Request.QueryString("overrideto").Item;
	var overridesender = true;
	var subject = Request.QueryString("subject").Item;
	var sender = Request.QueryString("sender").Item;
	var ses = Request.QueryString("ses").Item?Request.QueryString("ses").Item:Math.round(Math.random()*999999);

    oMAILPARAM.simulation = act=="simulation"?true:false;

	var overridebody = true;
	var htmlbody = Request.QueryString("htmlbody").Item;
	var body = Request.Form("body").Item;

	var attachments = Request.Form("attachments").Item;
	var embedded_img = Request.Form("embedded_img").Item;
	
	var attach = Request.Form("attach").Item;
	var overrideattach = Request.QueryString("overrideattach").Item;	

	if(Request.Form("act").Item=="Update body text")
	{
		Session(_pagename+ses) = body;
		if(Session(_pagename+ses))
			Session(_pagename+ses) = Session(_pagename+ses).replace(/\r\n<br>/g,"\r\n").replace(/\r\n/g,"\r\n<br>")
			
		act = "";
	}

	if(Request.Form("act").Item=="Update mailing list")
	{
		Session(_pagename+ses+"_1") = to;
		if(Session(_pagename+ses+"_1"))
			Session(_pagename+ses+"_1") = Session(_pagename+ses+"_1").replace(/\r\n/g,"<br>")
			
		act = "";
	}
	
	if(Request.Form("act").Item=="Update attachments")
	{
		Session(_pagename+ses+"_2") = attachments;
		if(Session(_pagename+ses+"_2"))
			Session(_pagename+ses+"_2") = Session(_pagename+ses+"_2").replace(/\r\n/g,"<br>")
			
		act = "";
	}
	
	if(Request.Form("act").Item=="Update embedded images")
	{
		Session(_pagename+ses+"_3") = embedded_img;
		if(Session(_pagename+ses+"_3"))
			Session(_pagename+ses+"_3") = Session(_pagename+ses+"_3").replace(/\r\n/g,"<br>")
			
		act = "";
	}	
	
	/////////////////////
	// LOCAL FUNCTIONS //
	/////////////////////

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
	
	String.prototype.isForbidden = function (forbiddenchars)
	{
		for (var z=0;z<forbiddenchars.length;z++)
			if (this.indexOf(forbiddenchars.substring(z,z+1))>=0)
				return true;
		return false;
	}		
	
	function isValidEmail(str)
	{
		if(str)
		{
			var ve_atpos = str.indexOf('@');
			var ve_dotpos = str.lastIndexOf('.');
			var ve_totlen = str.length;
			var forbidden = " ~\'^\`\"*+=\\|][(){}$&!#%/:,;"
			return (!str.isForbidden(forbidden) && ve_atpos>0 && ve_dotpos>2 && ve_dotpos>ve_atpos && ve_atpos<(ve_totlen-4) && ve_dotpos<(ve_totlen-2) )
		}
		else
			return false;
	}		

	function quote( str )
	{
		return "'"+(!str || str==null?"":str.replace(/\x27/g,"\\'"))+"'";
	}
	
	function stripHtml(strHTML) 
	{
		if(typeof(strHTML)=="string")
		{
			strOutput = strHTML
			aScript=strOutput.split(/\/script>/i);
			for(_stri=0;_stri<aScript.length;_stri++)
				aScript[_stri]=aScript[_stri].replace(/\<script.+/i,"");
			strOutput=aScript.join('');
			strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
			return strOutput;
		}
		else
				return strHTML;
	}	

	function ReadFile(filename)
	{
		var ForReading = 1;
		fileobj = FSO.OpenTextFile(filename, ForReading, false);
		var txt = fileobj.ReadAll();
		fileobj.Close();
		return txt;
	}
	

	function argparser(_str)
	{
		var _enum = new Array();
		if(_str)
		{
			if(_str.substring(0,6)=="&quot;")
				_str = _str.substring(6,_str.length-6);
			else if (_str.substring(0,1)=="\"")
				_str = _str.substring(1,_str.length-1)
			else if (_str.substring(0,2)=="\\\"")
				_str = _str.substring(2,_str.length-2)
			else
				_str = "id="+_str;
			
			var _aparr = new String(_str).split(/,|=/);
			
			//Response.Write(_aparr+"<br>")
			
			for(var _pj=0;_pj<_aparr.length;_pj+=2)
			{
			   _enum[_aparr[_pj]] = _enum[_aparr[_pj]]?(_enum[_aparr[_pj]]+","+_aparr[_pj+1]).replace(/%2C/g,","):_aparr[_pj+1];
			   _enum[_pj/2] = _aparr[_pj];
			   if(bDebug)
					Response.Write("_enum["+_aparr[_pj]+"] = "+(_enum[_aparr[_pj]]?(_enum[_aparr[_pj]]+","+_aparr[_pj+1]).replace(/%2C/g,","):_aparr[_pj+1])+"<br>\r\n")
			}
			if(bDebug)
				Response.Write("<br>("+_str+")<br>");
		}
		return _enum;
	}
	
	
	
	
	
	// G E T   S M T P   S E R V E R   P A R A M E T E R S
	
	var sSQL = "select rev_email,rev_author,rev_header,rev_finish,rev_code from "+_db_prefix+"review where rev_rt_typ = 26 and rev_dir_lng = \""+_ws+"\" and (rev_pub & 1) = 1 and (rev_pub & 8) = 0 order by (rev_pub & 3) desc"
	var param_arr = oDB.getrows(sSQL);
	var param_idx = 0;
	for(var j=0;j<param_arr.length;j+=5)
		if(param_arr[j]==from)
			param_idx = j;

	if(bDebug)
		Response.Write("GET SMTP SERVER PARAMETERS<br>"+sSQL+"<br><br>");

	if(bDebug)
	{
		for(var j=0;j<param_arr.length;j++)
			Response.Write("param_arr["+j+"] = "+param_arr[j]+"<br>");
	}
	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
			
	var deftablefld = new Array("rev_url","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;
	
	var dsid = Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").substring(1,Session(_pagename+ses+"_1").indexOf("]")):"0"


	
	if(!isNaN(dsid))
	{
		var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+dsid;
		var tabledefs = oDB.getrows(sSQL);
	}
	else
		var tabledefs = new Array();

	if(bDebug)
		Response.Write("<br>"+sSQL+"<br><br>");

	// R E A D   X M L   D A T A S E T
	
	if(dsid)
	{
		var XMLObj = loadXML(tabledefs[defenumfld["rev_rev"]]);
		var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	}
	else
		var fields = new Array();

	var enumdataset = new Array();
	if(dsid)
	{
		for(var i=0;i<Number(fields.length);i++)
		{
			enumdataset[ fields.item(i).text ] = fields.item(i).getAttribute("name");
			//if(bDebug)
			//	Response.Write( "enumdataset[ "+fields.item(i).text+" ] = "+fields.item(i).getAttribute("name")+"<br>" );
		}
	}

	// R E A D   X M L   H E A D E R S E T	
	
	if(dsid)
	{
		var XMLObj = loadXML(tabledefs[defenumfld["rev_header"]]);
		var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
	}
	else
		var hfields = new Array();
	
	
	var enumcolnames = new Array();
	for(var i=0;i<hfields.length;i++)
	{
		enumcolnames[ enumdataset[hfields.item(i).text] ] = hfields.item(i).getAttribute("name");
	}
	
	if(bDebug)
	{
		Response.Write("ENUMARATE VALUES FROM SMTP PARAMETERS<br>");
		for(var i=0;i<hfields.length;i++)
			Response.Write("enumcolnames[ "+enumdataset[hfields.item(i).text]+" ] = "+hfields.item(i).getAttribute("name")+"<br>");
		Response.Write("<br>");
	}

	var emailto = "";
	for(var i=0;i<hfields.length;i++)
		if(!emailto && enumdataset[hfields.item(i).text].indexOf("email")>=0)
			emailto = enumdataset[hfields.item(i).text];

	for(var i=0;i<hfields.length;i++)
		if(!emailto && enumdataset[hfields.item(i).text].indexOf("email_privé")>=0)
			emailto = enumdataset[hfields.item(i).text];

	if(bDebug)
		Response.Write("E-mail address column selected: "+emailto);
	

	////////////////////////////////
	// ESTIMATE NUMBER OF RECORDS //
	////////////////////////////////



	if(typeof(whereclause)!="string")
		var whereclause = "";
	
	var bDataRef = Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").charAt(0)=="[":false;
	if(bDataRef==true)
		overrideto = "distinct";
	
	
	
	
	if(overrideto=="manual")
	{
		// ESTIMATE RECORD LENGTH FROM SESSION VARIABLE

		Session(_pagename+ses+"_1")=Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").replace(/<br>/g,","):"";
		var overview = Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").split(","):new Array();
		var overviewlength = overview.length;
		
	}
	else
	{
		// SEARCH FOR PHYSICAL TABLES
		
		var deftablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub");
		
		if(!isNaN(dsid))
		{
			var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+dsid
			var datadef = oDB.getrows(sSQL);
		}
		else datadef = new Array();
			
		var defenumfld = new Array();
		for (var j=0; j<deftablefld.length ; j++)
			defenumfld[deftablefld[j]] = j;
			
		if(datadef[defenumfld["rev_publisher"]] && datadef[defenumfld["rev_publisher"]]!=null)
		{
			var arr = datadef[defenumfld["rev_publisher"]].split(",");
			var masterdb = arr[0];
			var detaildb = arr[1];
		}
		else
		{
			var masterdb = "dataset";
			var detaildb = "datadetail";
		}
	
		// ESTIMATE RECORD LENGTH FROM DATABASE
		
		if(enumcolnames[emailto])
			whereclause += " and "+enumcolnames[emailto]+" LIKE '%@%.%' "
			
		if(overrideto=="distinct")
			var lSQL = "select count(distinct "+enumcolnames[emailto]+") from "+_db_prefix+masterdb+" where ds_rev_id = "+dsid+" and (ds_pub & 1) = 1 "+whereclause;
		else
			var lSQL = "select count(*) from "+_db_prefix+masterdb+" where ds_rev_id = "+dsid+" and (ds_pub & 1) = 1 "+whereclause;
		
		
		//REMOVE
		lSQL = "select count(*) from "+_db_prefix+masterdb+" where ds_rev_id = "+dsid+" and (ds_pub & 1) = 1 "+whereclause
		
		//Response.Write(lSQL+"<br>")	
		
		var overviewlength = oDB.get(lSQL);
		
		if(bDebug)
			Response.Write("<br>"+lSQL+"<br><br>");
	}
	
	if(bDebug)
		Response.Write("MAILING LIST : "+overviewlength+" items");


//////////////////////////////////////////////////////
//       M A I N   M A I L   S E N D E R            //
//////////////////////////////////////////////////////


	var todo = overviewlength-(sq+step);
	

	if(act && (todo>=0 || sq==0))
	{
		
		var url = Request.QueryString().Item;
		url = url.substring(0,url.indexOf("&sq=")>=0?url.indexOf("&sq="):url.length)+"&sq="+Number(sq+step)
		
		// D A T A   P R O C E S S I N G

		var c_from    = enumcolnames["from"] && !from?enumcolnames["from"]:from;
		var c_sender  = enumcolnames["sender"] && (!overridesender || !sender)?enumcolnames["sender"]:sender;
		var c_emailto = enumcolnames[emailto] && (overrideto!="override" || !to)?enumcolnames[emailto]:to;
		var c_subject = enumcolnames["subject"] && (!overridesubj || !subject)?enumcolnames["subject"]:subject;
		enumcolnames["body"] = enumcolnames["body"]?enumcolnames["body"]:"";

		var c_body = enumcolnames["body"] && !overridebody || !Session(_pagename+ses)?enumcolnames["body"].replace(/"/g,"\\\""):(Session(_pagename+ses).replace(/"/g,"\\\""))
		//else
		//	var c_body = "\"[empty]\"";

		var c_attachments  = Session(_pagename+ses+"_2");
		var c_embedded_img = Session(_pagename+ses+"_3");
		
		// D A T A S E T   Q U E R Y
		var colarr = new Array(
			 quote(c_from)
			,overridesender?quote(c_sender):(c_sender?c_sender:"''")
			,(c_emailto?c_emailto:"''")
			,overridesubj?quote(c_subject):(c_subject?c_subject:"''")
			,overridebody?quote(c_body):(c_body?c_body:"''")
			,quote(c_attachments)
			,quote(c_embedded_img)
			,"ds_id"
			)
	
		if(overrideto=="manual")
		{
			var arr = new Array();
			for(var j=sq*oMAILPARAM.fld.length;j<(sq+step)*oMAILPARAM.fld.length;j+=oMAILPARAM.fld.length)
			{
				arr[j]    = c_from;
				arr[j+1]  = c_sender;
				arr[j+2]  = overview[j/colarr.length];
				arr[j+3]  = c_subject;
				arr[j+4]  = c_body;
				arr[j+5]  = c_attachments;
				arr[j+6]  = c_embedded_img;
				
				//Response.Write(arr.slice(j,j+3).join(",")+"<br>")
				
			}
		}
		else
		{
			var lSQL = "select "+colarr.join(",")+" from "+_db_prefix+masterdb+" where ds_rev_id = "+dsid+" and (ds_pub & 1) = 1 "+whereclause+(overrideto=="distinct"?(" group by "+enumcolnames[emailto]):"")+" order by ds_id LIMIT "+sq+","+step;		
			var arr = oDB.getrows(lSQL);
			
			if(bDebug)
				Response.Write(lSQL+" #1\r\n<br>\r\n<br>\r\n")
		}
		
		if(act.indexOf("send to")==0)
			Response.Write("<a href=?"+url+">TODO ("+Math.round(100*(todo+step)/overviewlength)+"%)</a>\r\n<br><br>");
		
		
		for(var _peb=0;_peb<arr.length;_peb+=oMAILPARAM.fld.length)
		{
		
		
			
			/////////////////////////////////////////////////
			//  P A R S E   E V E R Y   E M A I L   B O D Y
			/////////////////////////////////////////////////

//Response.Write(arr.slice(_peb,_peb+oMAILPARAM.fld.length).join("<br>")+"<br>")


			oMAILPARAM.load(arr.slice(_peb,_peb+oMAILPARAM.fld.length));
			//var _str_b = mailparam[4]; // TEMPORARY

			// READ THE AVAILABLE FIELD NAMES
			var _parr = typeof(oMAILPARAM.param["body"])=="string"?oMAILPARAM.param["body"].split("{_"):new Array();	// SEARCH FOR FUNCTION CALLS INSIDE TEMPLATE
			
			var _tmplfield = new Array();
			var _tmplfld = new Array();
			var _templdat = new Array();
			var _enumfld = new Array();
			for(var _pi=1;_pi<_parr.length;_pi++)
				_tmplfld[_pi-1] = _parr[_pi].substring(0,_parr[_pi].indexOf("_}"));
			
			//Response.Write(_parr+"***")
			
			for(var _pi=0;_pi<_tmplfld.length;_pi++)
			{
				_templdat[_pi] = "";
				_enumfld[_tmplfld[_pi]] = _pi;

				var curfield = _tmplfld[_pi];
				var curarg   = "";
				if(curfield && curfield.indexOf("{")>=0 && curfield.indexOf("}")>=0 && curfield.indexOf("}") > curfield.indexOf("{"))
				{
					curarg   = curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"));
					// RESOLVE UNQUOTED ARGUMENTS
					//Response.Write("|"+curarg+"|<br>")	
					
					if(curarg && curarg.substring(0,1)!="\"" && curarg.substring(0,2)!="\\\"")
						curarg = "\""+unescape(curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}")))+"\""
						
					curfield = curfield.substring(0,curfield.indexOf("{"));
					_tmplfield[i] = curfield;
				}

				if(bDebug)
					Response.Write("<!--TAG "+curfield+"\r\n-->\r\n");

				switch(curfield)
				{
					case "MDIR":
						_templdat[_pi] = "http://www."+_host.replace(/www\./,"")+"/"+(_proj?_proj:"usite")+"/"+_ws;
					break;						
					case "DOM":
						_templdat[_pi] = _host.replace(/www\./,"");
					break;
					case "PRJ":
						_templdat[_pi] = _proj?_proj:"usite";
					break;					
					case "WS":
						_templdat[_pi] = _ws;
					break;
					case "NBSP":
						_templdat[_pi] = "&nbsp;";
					break;			
					case "EXEC":
							var arg = argparser(curarg);
							
							if(arg["script"])
							{
								_templdat[_pi] = "<!--EXEC-->";//unescape(arg["script"]);
								eval(unescape(arg["script"]));
							}
							else if(arg["scriptid"])
							{
								var rid = arg["scriptid"].toString().decrypt("nicnac");
								
								var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_ws+"\" and (rev_pub & 9) = 1 and rev_id = "+rid+" limit 0,1"
								var script = oDB.get(sSQL);
								
								_templdat[_pi] = " ";
								eval(script);
							}
					break;
				}
			}
		
		
		
			for(var _pi=0;_pi<_tmplfld.length;_pi++)
				oMAILPARAM.param["body"] = oMAILPARAM.param["body"].replace("{_"+_tmplfld[_pi]+"_}",_templdat[_pi]?_templdat[_pi]:("{_"+_tmplfld[_pi]+"_}"));
			
			//mailparam[4] = _str_b; // TEMPORARY
			
			
			
			for(var _j=_peb;_j<(_peb+oMAILPARAM.fld.length);_j++)
			{
				//Response.Write(_j-_peb+" ")

				//Response.Write("oMAILPARAM.param["+oMAILPARAM.fld[_j-_peb]+"] = "+oMAILPARAM.param[oMAILPARAM.fld[_j-_peb]]+"<br>")
			
			
				if(oMAILPARAM.param[oMAILPARAM.fld[_j-_peb]] != arr[_j])
				{
					
					//Response.Write("<font color=#600000>"+(arr[_j]?stripHtml(arr[_j]).substring(0,200):"[empty]")+" > "+(mailparam[_j]?stripHtml(mailparam[_j]).substring(0,200):"[empty]")+"</font><br><br>")
					arr[_j] = oMAILPARAM.param[oMAILPARAM.fld[_j-_peb]];
					//Response.Write("arr["+_j+"] = (oMAILPARAM.param["+oMAILPARAM.fld[_j]+"])"+(oMAILPARAM.param[oMAILPARAM.fld[_j]]?oMAILPARAM.param[oMAILPARAM.fld[_j]].substring(0,100):"")+"<br>")
				}
				
				
			//Response.Write("$"+arr[_j+2]+"$<br>")	
				
			}
		}
		
		if(act=="simulation" || act=="check body text" || act=="set list" || act=="set attachments" || act=="set embedded images")
		{
			if(act=="simulation")
			{	
			    
				var j=0;
				//for(var j=0;j<arr.length;j+=colarr.length)
				{
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td align=right width=50>from:</td><td>"+(arr[j+1]?(arr[j+1]+" &lt;"+arr[j]+"&gt;"):arr[j])+"</td></tr>");
					Response.Write("<tr><td align=right width=50>to:</td><td>"+arr[j+2]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>subject:</td><td>"+arr[j+3]+"</td></tr>");
					//Response.Write("<tr><td align=right width=50>attachments:</td><td>"+arr[j+5]+"</td></tr>");
					
					var arratt = arr[j+6]?unescape(arr[j+6]).split(","):new Array();
					for(var k=0;k<arratt.length;k++)
					{
							//Response.Write(arratt[k]+"<br>");
							//Response.Write(FSO.FileExists(arratt[k])+"<br>");
							att = arratt[k]?arratt[k].replace(/\\/g,"/"):"";
							var cid = att.substring(att.lastIndexOf("/")+1,att.lastIndexOf("."))+"_"+(new Date().format("%d_%m_%Y"));
							arratt[k] = att+"&lt;"+cid+"&gt;<br>";
					}
					
					Response.Write("<tr><td align=right width=50>images:</td><td>"+arratt.join(",")+"</td></tr>");
					Response.Write("</table><hr>");
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td colspan=2 style=font-weight:bold>"+(arr[j+4]?arr[j+4].replace(/\\"/g,"\""):"")+"</td></tr>");
					Response.Write("</table><hr>");
				}
			}
				
			if(act=="check body text")
			{
				Response.Write("<center><form name=boxpanel method=post><table cellspacing=1 cellpadding=10 bgcolor=#000000><tr><td bgcolor=#D4D0C8><textarea name=body cols=40 rows=5>"+(Session(_pagename+ses)?Session(_pagename+ses).replace(/<br>/g,"\r\n"):"") +"</textarea><br><input type=submit name=act value='Update body text'></td></tr></table></form></center>")
				act = "";
			}
			
			if(act=="set list")
			{
				Response.Write("<center><form name=boxpanel method=post><table cellspacing=1 cellpadding=10 bgcolor=#000000><tr><td bgcolor=#D4D0C8><textarea name=to cols=40 rows=5>"+(Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").replace(/<br>/g,"\r\n"):"") +"</textarea><br><input type=submit name=act value='Update mailing list'></td></tr></table></form></center>")
				act = "";
			}			
			
			if(act=="set attachments")
			{
				Response.Write("<center><form name=boxpanel method=post><table cellspacing=1 cellpadding=10 bgcolor=#000000><tr><td bgcolor=#D4D0C8><textarea name=attachments cols=40 rows=5>"+(Session(_pagename+ses+"_2")?Session(_pagename+ses+"_2").replace(/<br>/g,"\r\n"):"") +"</textarea><br><input type=submit name=act value='Update attachments'></td></tr></table></form></center>")
				act = "";
			}
			
			if(act=="set embedded images")
			{
				Response.Write("<center><form name=boxpanel method=post><table cellspacing=1 cellpadding=10 bgcolor=#000000><tr><td bgcolor=#D4D0C8><textarea name=embedded_img cols=40 rows=5>"+(Session(_pagename+ses+"_3")?Session(_pagename+ses+"_3").replace(/<br>/g,"\r\n"):"") +"</textarea><br><input type=submit name=act value='Update embedded images'></td></tr></table></form></center>")
				act = "";
			}			
		
		}
		else if(act.indexOf("send to")==0)
		{
			for(var _peb=0;_peb<arr.length;_peb+=oMAILPARAM.fld.length)
			{
			
				if(isValidEmail(arr[_peb+2])==true)
				{

					// MAIL SENDER
					
					// REPLACE ALL IMAGES BY CID REFERENCE
					var body = arr[_peb+4];
					var img_arr = body?body.replace(/\\"/g,"\"").split(/<IMG/gi):new Array();
					var cid_pool = new Array();
					for(var k=1;k<img_arr.length;k++)
					{
						var tagc = img_arr[k].substring(0,img_arr[k].indexOf(">"));
						tagc = tagc.substring(tagc.indexOf("src=")+4,tagc.length)
						if(tagc.charAt(0)=="\"")
							tagc = tagc.substring(1,tagc.substring(1,tagc.length).indexOf("\"")+1);
						else
							tagc = tagc.substring(0,tagc.indexOf(" "));
						cid_pool[k-1] = tagc.substring(tagc.lastIndexOf("/")+1,tagc.lastIndexOf("."))+"_"+(new Date().format("%d_%m_%Y"));
						
						body = body.replace(new RegExp(tagc,"gi"),"cid:"+cid_pool[k-1]);
					}					
					
					var Mail = Server.CreateObject("Persits.Mailsender");
					Mail.Host     	= param_arr[param_idx+1]?param_arr[param_idx+1]:"blackbaby.org";
					//Response.Write("*1*<br>");
					Mail.Port 	= param_arr[param_idx+2] && !isNaN(param_arr[param_idx+2])?param_arr[param_idx+2]:"25";
					//Response.Write("*2*<br>");
					//Mail.LogonUser ("blackbaby.org","MXadmin","xxlmxadmin");
					//Response.Write("*3*<br>");

					//Mail.Username = "Administrator"
					//Mail.Password = ""

					Mail.Username	= param_arr[param_idx+3]?param_arr[param_idx+3]:"";
					//Response.Write("*4*<br>");
					Mail.Password	= param_arr[param_idx+4]?param_arr[param_idx+4]:"";
					//Response.Write("*5*<br>");
					Mail.From 	= arr[_peb];
					//Response.Write("*6*<br>");
				 	Mail.FromName   = arr[_peb+1]?arr[_peb+1]:arr[_peb];
					//Response.Write("*7*<br>");
					Mail.Subject 	= arr[_peb+3];
					//Response.Write("*8*<br>");
					Mail.Body 	= body?body.replace(/\\"/g,"\""):"";//.replace(/<br>/gi,"\r\n");
					//Response.Write("*9*<br>");
					Mail.IsHTML	= true;
					//Response.Write("*10*<br>");
					
					
					
					if(bMaildisable)
					{
						Mail.AddAddress("freddy.vandriessche@gmail.com");
					}
					else
					{
						Mail.AddAddress(arr[_peb+2]);
						//Mail.AddBCC("freddy.vandriessche@gmail.com");
						//Mail.AddBCC("Lieve.Vereycken@gmail.com");
					}
						
					
					//Response.Write("*11*<br>");
					
					Mail.Queue 	= true;
					
					if(bDebug)
					{
					  Response.Write("Host = "+Mail.Host+"<br>");
					  Response.Write("Port = "+Mail.Port+"<br>");
					  Response.Write("Username = "+Mail.Username+"<br>");
					  Response.Write("Password = "+Mail.Password+"<br>");
					  Response.Write("From = "+Mail.From+"<br>");
					  Response.Write("FromName = "+Mail.FromName+"<br>");
					  Response.Write("Subject = "+Mail.Subject+"<br>");
					  Response.Write("Address="+arr[_peb+2]+"<br>");
					}
					
					var FSO = Server.CreateObject("Scripting.FileSystemObject");
					
					//Mail.AddAttachment(arr[_peb+5])
					//Mail.AddAttachmentMem("test.jpg",Readfile(arr[_peb+5]))
					

					// EMBEDDED IMAGES
					if(arr[_peb+6])
					{
						var arratt = arr[_peb+6].split(",");
						
						for(var k=0;k<arratt.length;k++)
						{
							//Response.Write(arratt[k]+"<br>");
							var FSO = Server.CreateObject("Scripting.FileSystemObject");
							var att = arratt[k]?unescape(arratt[k].replace(/\\/g,"/")):"";
							var cid = att.substring(att.lastIndexOf("/")+1,att.lastIndexOf("."))+"_"+(new Date().format("%d_%m_%Y"))
							//+"_"+Math.floor(Math.random()*(1<<24)).toString(16)
							//Response.Write("***"+att+" "+cid+"***"+arr[_peb+2]+"<br>");
							
							//Response.Write("*"+(arr[_peb+2]?arr[_peb+2]:"")+"*<br>")
							
							//Response.Flush()
							Mail.AddEmbeddedImage(att,cid);
						}
					}	
			
					
					//Response.End();   ///////////////////// REMOVE THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
					
					//Response.Write(oMAILPARAM.bSend+"***")
					
					if(oMAILPARAM.bSend)
					{
						try { 
							Mail.Send(); 
							
						}
						catch (e)
						{					
							var returnpage = "index.asp";
							Response.Write("<BR><BR><CENTER>Mail sender failed,<BR><BR> " + (e.number & 0xFFFF).toString(16) + " " + e.description + "<BR><BR> please contact <a href=mailto:blackbaby@pandora.be>administrator</a><BR><BR><INPUT type='button' value='Back' onclick=document.location='"+returnpage+"' id='button'1 name='button'1></CENTER>");
						//Response.End();
						}
					}
					else
						Response.Write("MAIL NOT SENT BY MAIL PARAM FLAG (bSend=false)<br>")
					
					
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td align=right width=50>from:</td><td>"+(arr[_peb+1]?(arr[_peb+1]+" &lt;"+arr[_peb]+"&gt;"):arr[_peb])+"</td></tr>");
					Response.Write("<tr><td align=right width=50>to:</td><td>"+arr[_peb+2]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>subject:</td><td>"+arr[_peb+3]+"</td></tr>");
					//Response.Write("<tr><td align=right width=50>attachments:</td><td>"+arr[_peb+5]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>images:</td><td>"+cid_pool.join("<br>")+"</td></tr>");
					Response.Write("</table><hr>");
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td colspan=2 style=font-weight:bold>"+(arr[_peb+4]?arr[_peb+4].replace(/\\"/g,"\""):"")+"</td></tr>");
					Response.Write("</table><hr>");
					
				}
			}
	
			Response.Write("<script>\r\n");
			Response.Write("function reloadme() {setTimeout(\"window.location='?"+url+"'\",3000)}\r\n");
			Response.Write("window.onload=reloadme;\r\n");
			Response.Write("</script>");
		}
	}









///////////////////////////////
//     D I A L O G S         //
///////////////////////////////






	
	



if(!act || act=="simulation" || (act=="simulation" && !to) || todo<=0)
{
%>

<a name=boxtop></a>
<center>
<form name=panel method=get action=#boxtop>

	<form name=panel method=get action=#boxtop>
	<table cellspacing=1 cellpadding=10 bgcolor="#000000">
	<tr>
		<td bgcolor="#D4D0C8">
			<table>
				<tr><td class=small><%=_T["from"]%></td><td><select name=from>		
				<%
				
				var hiddenform = ""//"<input name=step value="+defaultstep+" type=hidden>"
				
				
				for(var j=0;j<param_arr.length;j+=5)
					if(param_arr[j])
						Response.Write("\t\t\t<option value=\""+param_arr[j].toString().encrypt("nicnac")+"\""+(param_arr[j]==from?" SELECTED":"")+">"+param_arr[j]+"\r\n")
		
				%>
				</select>
				<%
						if(bDebug)
							Response.Write("<br>"+sSQL+"<br><br>")
				%>
				</td></tr>
				<%
				
				
				var temp_hiddenform = "<input name=sender value=\""+Server.HTMLEncode(Request.QueryString("sender").Item)+"\" type=hidden>";
				var temp_visibleform = "<input name=sender value=\""+Server.HTMLEncode(Request.QueryString("sender").Item)+"\" style=width:300px>";
				var temp_displayform = Server.HTMLEncode(Request.QueryString("sender").Item);
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = "sender";				
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = {"true":temp_visibleform,"hidden":temp_hiddenform,"view":temp_displayform+temp_hiddenform};
				
				var temp_hiddenform  = "<input type=hidden name=overrideto value=\"manual\">"
				var temp_visibleform = "<input type=submit name=act value=\"set list\" style=width:100px>"
				var temp_displayform = Server.HTMLEncode(Request.QueryString("overrideto").Item);
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = "to";				
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = {"true":temp_visibleform+temp_hiddenform,"hidden":temp_hiddenform,"view":temp_displayform};
				
				var temp_hiddenform  = "<input name=subject value=\""+Server.HTMLEncode(Request.QueryString("subject").Item)+"\" type=hidden>"
				var temp_visibleform = "<input name=subject value=\""+Server.HTMLEncode(Request.QueryString("subject").Item)+"\" style=width:300px>"
				var temp_displayform = Server.HTMLEncode(Request.QueryString("subject").Item);
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = "subject";				
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = {"true":temp_visibleform,"hidden":temp_hiddenform,"view":temp_displayform+temp_hiddenform};	
				
				
				var temp_hiddenform  = ""
				var temp_visibleform = "<input type=submit name=act value=\"check body text\" style=width:100px>&nbsp;&nbsp;<a href=29_edit_pop.asp?id="+Request.QueryString("id").Item+"&ses="+ses+"&pagename="+_pagename+" target=_blank>edit text</a>"
				var temp_displayform = "<a href=29_edit_pop.asp?id="+Request.QueryString("id").Item+"&ses="+ses+"&pagename="+_pagename+" target=_blank>edit text</a>";
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = "body";				
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = {"true":temp_visibleform,"hidden":temp_hiddenform,"view":temp_displayform+temp_hiddenform};				
				%>
				
				<!--tr><td class=small title="E-mail body text">body</td><td class=small>
				<%
					//var checkboxes = "<input type=checkbox name=overridebody "+(Request.QueryString("overridebody").Item?"checked":"")+"> override"
					//			+"<br><input type=checkbox name=htmlbody "+(Request.QueryString("htmlbody").Item?"checked":"")+"> HTML"
					
					//if(Request.QueryString("htmlbody").Item)
					//{
						//Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses)?Session(_pagename+ses):"[empty] &nbsp;")+"</td></tr></table></td><td class=small ></td></tr></table><br>")	
						Response.Write("<input type=submit name=act value=\"check body text\" style=width:100px>&nbsp;&nbsp;<a href=29_edit_pop.asp?id="+Request.QueryString("id").Item+"&ses="+ses+"&pagename="+_pagename+" target=_blank>edit text</a>")
					//}
					//else
					//{
					//	Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses)?Session(_pagename+ses):"[empty] &nbsp;")+"</td></tr></table></td><td class=small >"+checkboxes+"</td></tr></table>")	
					//	Response.Write("<br><input type=submit name=act value=\"set body text\" style=width:100px>")
					//}
				%>
				</td></tr-->
				
				<!--tr><td class=small title="Attachments">attachments</td><td class=small>	
				<%
						Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses+"_2")?Session(_pagename+ses+"_2"):"[empty] &nbsp;")+"</td></tr></table></td><td class=small ></td></tr></table>")	
						Response.Write("<br><input type=submit name=act value=\"set attachments\" style=width:100px>")				
				%>
				</td></tr-->
				<%
				
				
				var temp_hiddenform  = ""
				var temp_visibleform = "<input type=submit name=act value=\"set embedded images\" style=width:100px>"
				var temp_displayform = ""
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = "embedded images";				
				oMAILPARAM.dialog[oMAILPARAM.dialog.length] = {"true":temp_visibleform,"hidden":temp_hiddenform,"view":temp_displayform};	
				

				
				if(oMAILPARAM.dialog.length>0)
					Response.Write(oMAILPARAM.gen_dialog())
%>
				<!--tr><td class=small title="number of sends per step">step</td><td class=small><input name=step value="<%=step%>" maxlength=4 size=4 style="width:100px"></td></tr-->
				
			</table>
			<%=hiddenform%>
		</td>
	</tr>
	</table>
	<br>
	
	<script>
	window.onload = updatecontrols;
	function updatecontrols()
	{
		try{ if(document.panel.overrideto.value)
			document.panel.to.disabled = true;
		}
		catch(e){}
	}
	</script>
	
	<input type=hidden name=id value="<%=Request.QueryString("id").Item%>">
	<input type=hidden name=ses value="<%=ses%>">
	<input type=submit name=act value="simulation">&nbsp;&nbsp;
	<input type=submit name=act value="send to <%=overviewlength%> contacts">
	
	</form>
</center>
<%
}
%>


<!--#INCLUDE FILE = "../skins/adfooter.asp" -->
