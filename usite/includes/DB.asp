<!--#INCLUDE FILE = "../includes/CO.asp" -->
<%
	/////////////////////////////////
	// D A T A B A S E   C L A S S //
	/////////////////////////////////
	
	if(typeof(_db_prefix)!="string")
		var _db_prefix = "";

	if(typeof(_app_db_prefix)!="string")
		var _app_db_prefix = "";	
	
	function DB()
	{	
		// data members
		this.XMLObj = Server.CreateObject("Microsoft.XMLDOM");
		this.XMLObj.async = false;
		
		this.getMainNodeObj = XMLgetMainNodeObj;
		this.getByAttr		= XMLgetByAttr;
		this.findAttr			= XMLfindAttr;
		this.getRec			= XMLgetRec;
				
		this.con = Server.CreateObject("ADODB.Connection");
		this.rec    = Server.CreateObject("ADODB.Recordset");
		this.ConnectString = "";
		this.rows	= 0;
		this.orderby = 0;
		this.orderdir = "+"
		this.crlf	= "\r\n";
		
		// native methods
		this.getArray			= DBgetArray;
		this.row_map			= DBrow_map;	// virtual
		this.getTable			= DBgetTable;
		this.TH_map			= DBTH_map;		// virtual
		this.TD_map			= DBTD_map;		// virtual

		this.open				= DBopen;
		this.close				= DBclose;
		this.get					= DBget;
		this.getrows			= DBgetrows;
		this.exec				= DBexec;
		this.repl				= DBrepl;
		this.takeanumber	= DBtakeanumber;
		this.getanumber		=  DBgetanumber;
		
		this.getcombo		= DBgetcombo;
		
		this.login				= DBlogin;
		this.loginsec			= DBloginsec;
		this.loginValid			= DBloginValid;
		
		this.getSettings		= DBgetSettings;
		this.findSetting		= DBfindSetting;
		this.getSetting			= DBgetSetting;
		this.permissions		= DBpermissions;
	    this.session			= DBsession;
		
		this.crc32				= DBcrc32;


		this.bSavesettings      = true;
		this.sCon				= "";
		this.caller				= "";
		this.bDebug				= true;
		this.bCatch            = true;
		
		this.oCO				= new CO();      // inherit !!
	}

	///////////////////////////////////////////////
	//  X M L  R E C O R D S E T   W R A P P E R //
	///////////////////////////////////////////////

	function XMLgetMainNodeObj(strName)
	{
		if (strName==null)
			return null;
		var nodeList = this.XMLObj.getElementsByTagName(strName);
		if (nodeList.length != 1)
			return null;
		else
			return nodeList.item(0)
	}
	function XMLgetRec(Index)
	{
		if (Index>=0)
		{
			var MainNodeObj = this.getMainNodeObj("RECORDS");
			var SubNodeObj = getSubNodeObj(MainNodeObj,"RECORDS/RECORD");
	
			if (SubNodeObj==null)
				return;
	
			return SubNodeObj.item(Index).text;
		}
	}
	
	function XMLgetByAttr(AttrName,AttrValue)
	{
		var Indexes = this.findAttr(AttrName,AttrValue);
		var Retval = new Array();
		for (var Index=0;Index<Indexes.length;Index++)
			Retval[Index] = this.getRec(Indexes[Index]);
		return Retval;
	}
	
	function XMLfindAttr(AttrName,AttrValue)
	{
		var MainNodeObj = this.getMainNodeObj("RECORDS");
		var SubNodeObj = getSubNodeObj(MainNodeObj,"RECORDS/RECORD");
		if (SubNodeObj==null)
			return -1;
		var Indexes = new Array();
		var Ind = 0;
		var Columns = new Array(SubNodeObj.length);
		for (var Index=0;Index<SubNodeObj.length;Index++)
			if (SubNodeObj.item(Index).getAttribute(AttrName)==AttrValue)
				Indexes[Ind++] = Index;
		return Indexes;
	}
	
	function getSubNodeObj(XMLObj, strName)
	{	
		if (XMLObj!=null)
		{
			var SubXML = Server.CreateObject("Microsoft.XMLDOM");
			SubXML.async = false;
			SubXML.loadXML(XMLObj.xml);
			return SubXML.getElementsByTagName(strName);
		}
		else
			return null;
	}
	
	///////////////////////////////////////////////////////////
	//  B U I L D   A R R A Y   F R O M   R E C O R D S E T  //
	///////////////////////////////////////////////////////////

	function DBgetArray(SQL,start,len)
	{
		var lb = start?Number(start):0;
		var ub = lb+Number(len);
		var data = new Array();
		
		this.open(SQL);
		for (this.rows=0;!this.rec.EOF;this.rows++)	/////// TABLE BODY ///////
		{
			if (this.rows>=lb && this.rows<ub || ub==lb) // display one page at a time
			{
				data[this.rec(0)] = this.row_map();
			}
			this.rec.MoveNext();
		}
		
		this.close();
		return data;
	}

	function DBrow_map()
	{
		return new Array();
	}

	/////////////////////////////////////////////////////////////////////
	//  B U I L D   H T M L   T A B L E   F R O M   R E C O R D S E T  //
	/////////////////////////////////////////////////////////////////////
	
	function DBgetTable(SQL,start,len)
	{
		var lb = start?Number(start):0;
		var ub = lb+Number(len);
		
		this.open(SQL);
		
		var Src = this.TH_map();		/////// TABLE HEADER ///////
		
		for (this.rows=0;!this.rec.EOF;this.rows++)	/////// TABLE BODY ///////
		{
			if (this.rows>=lb && this.rows<ub || ub==lb) // display one page at a time
				Src += this.TD_map();
			
			this.rec.MoveNext();
		}
		
		this.close();
		return Src;
	}

	function DBTH_map()		// virtual function
	{
		return "<TR><TD bgcolor=#FFFFFF>TH prototype</TD></TR>";
	}
	
	function DBTD_map()		// virtual function
	{
		return "<TR><TD bgcolor=#FFFFFF>TD prototype</TD></TR>"
	}

	function DBopen(SQL)
	{
	    //Response.Write("<!--\r\n\r\n"+SQL+"\r\n\r\n-->")
		this.rows	= 0;
		try
		{
			this.con.Open(this.ConnectString);
			this.rec.Open(SQL,this.con);
		}
		catch(e)
		{
			Response.Write("*** open failed ***<br>\r\n<!--\r\n"+(typeof(SQL)=="undefined"?"undefined SQL":SQL)+"\r\n"+e.description+"\r\n-->\r\n");
		}
	}

	function DBclose(SQL)
	{
	    try
		{
		   this.con.Close();
		}
		catch(e)
		{
			Response.Write("*** get failed ***<br>\r\n<!--\r\n"+(typeof(SQL)=="undefined"?"undefined SQL":SQL)+"\r\n"+e.description+"\r\n-->\r\n");
		}
	}

	function DBget(SQL)
	{	
		
		this.open(SQL);
		try
		{		
		  if (!this.rec.EOF)
			var value = this.rec(0).value;
		}
		catch(e)
		{
			Response.Write("*** get failed ***<br>\r\n<!--\r\n"+SQL+"\r\n"+e.description+"\r\n-->\r\n");
		}
		this.close(SQL);
		
		return value;
	}

	function DBgetrows(SQL)
	{
		this.open(SQL);
		if (!this.rec.State) return new Array();
		
		if (!this.rec.EOF)
			var tmp = this.rec.GetRows().toArray();
		else
			var tmp = new Array();
		
		this.close();
		return tmp;
	}	
	
	function DBexec(SQL)
	{	
		this.open(SQL);
		this.close();
		this.repl(SQL)
	}
	
	function DBrepl(SQL)
	{
		try
		{
			if(typeof(this.oCO.DBrepl)!="undefined")
			{
			   for(var _repli=0;_repli<this.oCO.DBrepl.length;_repli++)
			   {
			      this.con.Open(this.oCO.DBrepl[_repli]);
			      this.rec.Open(SQL,this.con);
			      this.con.Close();
			   }
			}
		}
		catch(e)
		{
			Response.Write("*** replication failed ***<br>\r\n<!--\r\n"+(typeof(SQL)=="undefined"?"undefined SQL":SQL)+"\r\n"+e.description+"\r\n-->\r\n");
		}
	}
	
	function DBtakeanumber(tablename)
	{
		// T E M P O R A R Y   W O R K A R O U N D  !!!!!!!!!!!!!!!!!!!!!!
		
		/*
		
		var retval = this.get("select tan_next from "+_app_db_prefix+"takeanumber where tan_name='"+tablename+"'");
		
		if (retval > 0)
			this.exec("update "+_app_db_prefix+"takeanumber set tan_next = tan_next + 1 where tan_name='"+tablename+"'");
		else
		{
			this.exec("insert into "+_app_db_prefix+"takeanumber values('"+tablename+"',2)");
			return 1;
		}
		*/
		
		var retval = this.get("select max(rev_id)+1 from "+tablename);
		
		
		
		
		return retval;
	}
	
	function DBgetanumber(tablename)
	{
		var retval = this.get("select tan_next from "+_app_db_prefix+"takeanumber where tan_name='"+tablename+"'");
		return retval;
	}
	
	function DBgetcombo(SQL,item)
	{
		this.open(SQL);
		if (!this.rec.State) return new Array();
		
		if (!this.rec.EOF)
			var tmp = this.rec.GetRows().toArray();
		else
			var tmp = new Array();
		
		var _src = "";
		for (var _i = 0; _i<tmp.length ; _i+=2)
			_src += "<option value=\""+tmp[_i]+"\""+(tmp[_i]==item?" selected":"")+">"+tmp[_i+1];
		
		this.close();
		return _src;
	}	
	
	function DBgetSettings(usr)
	{
		this.ConnectString = new String(this.oCO.ConnectString);
				
		var uid = Session("uid");
		
		//if(typeof(_session)=="object")
		//	uid = _session["uid"];		
		
		if (!this.ConnectString || !uid)
			return;
		
		
		
		// OLD SECURITY SYSTEM
		//var SQL = "SELECT S_NAME,S_VALUE FROM "+_db_prefix+"settings WHERE S_ACC_ID="+uid+" order by S_NAME";
		
		// NEW SECURITY SYSTEM
		var SQL = "SELECT rd_text  FROM usite_blackbabydetail WHERE rd_dt_id = 24 and rd_ds_id = 661 and rd_recno = "+uid;
		this.open(SQL);
		if(!this.rec.EOF)
		{
			var SQL = "SELECT \"PERM\",ds_desc  FROM usite_blackbabyset WHERE ds_rev_id = 1313 and ds_id in ("+this.rec(0).value+") and (ds_pub & 1) = 1";
		}
		this.close();
		
		
		
		
		
		this.open(SQL);
		var XMLObj = new ActiveXObject("Microsoft.XMLDOM");
		XMLObj.async = false;	
		var MainNode = XMLObj.createElement("RECORDS");
			
		while (!this.rec.EOF)
		{
			var CurNode = MainNode.appendChild(XMLObj.createElement("RECORD"));
			
			var S_Name  = this.rec(0).value;	
			var S_Value = this.rec(1).value;
			
			//	Response.Write("XML "+S_Name+" = "+S_Value+"<br>")
			
			if (S_Value)
				CurNode.appendChild(XMLObj.createTextNode(S_Value));
				
			CurNode.setAttribute("name",S_Name);
			
		    this.rec.MoveNext();
		}
		
		this.close();
		this.XMLObj.loadXML('<?xml version="1.0"?>'+MainNode.xml);  // MainNode.xml
		//Response.Write(this.XMLObj.xml)
		//Response.End()
	}
	
	function DBsaveSetting(SettingValue,SettingName)
	{
		//var Index =  this.findAttr("name",SettingName);
		var Index = 0
		
		if (Index >= 0)
		{
			// update record
			var val = "s_value='"+SettingValue+"',s_acc_id='"+this.usr+"'";
			
			//Response.Write("update settings set "+val+" where s_name='"+SettingName+"'<BR>");
			
			this.open("update "+_db_prefix+"settings set "+val+" where s_name='"+SettingName+"' and s_acc_id='"+this.usr+"'");
			this.close();
		}
		else
		{
			// insert record
			var val =  this.takeanumber(_app_db_prefix+"settings") + ",'" + SettingName + "','" + SettingValue + "','" + this.usr + "'";
			//Response.Write("insert into settings (s_id,s_name,s_value,s_acc_id) values ("+val+")<BR>");
			this.oDB.open("insert into "+_db_prefix+"settings (s_id,s_name,s_value,s_acc_id) values ("+val+")");
			this.oDB.close(); 
		}
	}
	
	function DBfindSetting(SettingName,SettingExt)
	{
		if(SettingExt)
		{	
			var DBmatch = "";
			var DBrange = this.getByAttr("name",SettingName);
				for(var i=0; i<DBrange.length ; i++)
					if(DBrange[i].substring(0,SettingExt.length)==SettingExt)
						return true
			return false;
		}
		else
			return this.getByAttr("name",SettingName).length>0?true:false;
	}
	
	function DBgetSetting(SettingName,SettingExt)
	{
		
		//return this.getByAttr("name",SettingName);
		//Response.Write(this.XMLObj.xml)
		//Response.Flush();
		if(SettingExt)
		{	
			var DBmatch = "";
			var DBrange = this.getByAttr("name",SettingName);
				for(var i=0; i<DBrange.length ; i++)
					if(DBrange[i].substring(0,SettingExt.length)==SettingExt)
						var DBmatch = DBrange[i].substring(SettingExt.length,DBrange[i].length);
			return DBmatch;
		}
		else
			return this.getByAttr("name",SettingName);
	}

	// SAVE NUMBERS
	function DBNumSetting(SettingValue,SettingName,SettingDefault)
	{
		//Response.Write("this.bSaveSettings="+this.bSaveSettings+" SettingValue="+SettingValue+" SettingName="+SettingName+" SettingDefault="+SettingDefault+"<BR>");
		//Response.End()
		if (this.bSaveSettings)
		{
			var Retval = SettingDefault;
			SettingValue = isNaN(SettingValue)?SettingValue:SettingValue.toString();
			if (SettingValue)
			{
				this.saveSetting(SettingValue,SettingName);
				Retval = SettingValue;
			}
		}
		else
		{
			var Retval = this.getSetting(SettingName);
			if (!Retval)
				Retval = String(SettingDefault);
			Retval = Retval?Retval:"";
		}
		return Retval;
	}

	// SAVE STRINGS
	function DBStrSetting(SettingValue,SettingName,SettingDefault)
	{
		//Response.Write("this.bSaveSettings="+this.bSaveSettings+" SettingValue="+SettingValue+" SettingName="+SettingName+" SettingDefault="+SettingDefault+"<BR>");
		
		if (this.bSaveSettings)
		{
				this.saveSetting(SettingValue,SettingName);
				var Retval = SettingValue;
		}
		else
		{
			var Retval = this.getSetting(SettingName);
			if (!Retval)
				Retval = SettingDefault
		}
		return Retval;
	}
	
	function DBlogin(_usr,_psw,_dir)
	{
		this.ConnectString = new String(this.oCO.ConnectString);

		try
		{
			Session("con") = "";
			Session("uid") = "";
			this.loginsec(_usr,_psw,_dir);
			Session("uidcrc") = "<"+Session("uid")+">";
		}
		catch (e)
		{
			Response.Write("<!--DBlogin" +(e.number & 0xFFFF).toString(16) + " " + e.description+"-->");
		}
	}
	
	function DBloginsec(_usr,_psw,_dir)
	{	
		
		//Session("uid") = this.get("select acc_id from "+_db_prefix+"acc where acc_name = '"+(_usr?_usr:"")+"' and acc_psw = '"+(_psw?_psw:"")+"'");
		
		var nSQL = "select ds_id,rd_dt_id,rd_text from "+_db_prefix+"blackbabyset,"+_db_prefix+"blackbabydetail where ds_data01 = '"+(_usr?_usr:"")+"' and ds_data02 = '"+(_psw?_psw:"")+"' and ds_pub & 9 = 1 and ds_rev_id = 661 and  ds_rev_id = rd_ds_id and ds_id = rd_recno"
		var _arr = this.getrows(nSQL);
		var _dat = new Array();
		for(var _i=_arr.length-3;_i>=0;_i-=3)
			_dat[_arr[_i+1]] = _arr[_i+2];
		
		//Response.Write(nSQL+"<br>"+_arr+"<br>");
		var uid = _arr[0];
		
		var pos = _dir.lastIndexOf("_");
		var nam = _dir?_dir.substring(0,pos):"";
		var lng = _dir?_dir.substring(pos+1,_dir.length):"";
		
		var nSQL = "select ds_id from "+_db_prefix+"blackbabyset where ds_rev_id = 659 and ds_title = \""+nam+"\" and ds_desc like \"%"+lng+"%\""
					+ (_dat[23]?("and ds_id in ("+_dat[23].replace(new RegExp(",*$"),"")+")"):"")

		var _arr = this.getrows(nSQL);

		//Response.Write(nSQL+"<br>");

		if(_arr && Number(_arr[0])>=0)
		{	
			Session("con") = this.oCO.Conn;
			Session("uid") = uid;
	
			Response.Write(nSQL+" "+Session("con")+" "+Session("uid"));
			
		}
		//Response.End();

	}	
	
	function DBloginValid()
	{
	
		this.ConnectString = new String(this.oCO.ConnectString);
		var uid = Session("uid")?Session("uid"):-1;
		
		try
		{
			var nSQL = "select rd_text from "+_db_prefix+"blackbabyset,"+_db_prefix+"blackbabydetail where ds_pub & 9 = 1 and ds_rev_id = 661 and  ds_rev_id = rd_ds_id and ds_id = "+uid+" and rd_recno = "+uid+" and rd_dt_id = 23"
			var _arr = this.getrows(nSQL);
			var nSQL = "select ds_title,ds_desc from "+_db_prefix+"blackbabyset where ds_rev_id = 659 "+(_arr[0]?("and ds_id in ("+_arr[0]+")"):"");
			var _arr = this.getrows(nSQL);
			
			if(_arr.length>0)
				return true;
				

				
			/*
			Response.Write(nSQL+"<br>")
			Response.End();

			var pos = _dir.lastIndexOf("_")
			var nam = _dir?_dir.substring(0,pos):"";
			var lng = _dir?_dir.substring(pos+1,_dir.length):"";
			var nSQL = "select ds_id,ds_desc from "+_db_prefix+"blackbabyset where ds_rev_id = 659 and ds_title = \""+nam+"\" and ds_desc like \"%"+lng+"%\""
					+ (_dat[23]?("and ds_id in ("+_dat[23].replace(new RegExp(",*$"),"")+")"):"")
			
			var param = this.getrows("select acc_id,acc_lng_code from "+_db_prefix+"acc where acc_id = "+(uid?uid:"-1"));
			//Response.Write(param+" "+("select acc_id,acc_lng_code from "+_db_prefix+"acc where acc_id = "+(uid?uid:"-1")));
			//Response.End();
			this.language = param[1];
			if ( uid && uid == param[0])
				return true;
			*/
			
		}
		catch (e)
		{
			Response.Write("<!--DBloginValid" + (e.number & 0xFFFF).toString(16) + " " + e.description+"-->");
		}
		return false;
	}
	
	/*
	function DBpermissions(checkfor)
	{
	
		var perm = this.getSetting("PERM");
		//Response.Write(perm.join(",")+"<br>")
		for (var Index=0;Index<checkfor.length;Index++)
		{
			//Response.Write("checkfor "+checkfor.length+" "+checkfor[Index]+"<br>");  //+" in "+perm.join(",")+"<br>");
			if ( (","+perm.join(",")+",").indexOf(","+checkfor[Index]+",") < 0 )
				return false;
		}
		//Response.Write("true<br>");
		
		return true;
	}
	*/
	
	// DOES NOT WORK ?
	function DBpermissions(checkfor)
	{
		var perm = this.getSetting("PERM");
		this.permissions_match = new Array();

		for (var Index=0;Index<checkfor.length;Index++)
		{
			//Response.Write("checkfor "+checkfor[Index]+"<br>") // +" in "+perm.join(",")+"<br>")
			if ( (","+perm.join(",")+",").indexOf(","+checkfor[Index]+",") >= 0 ) 	
				this.permissions_match[this.permissions_match.length] = checkfor[Index];
		}
		//Response.Write("match="+this.permissions_match+" ("+(this.permissions_match.length==checkfor.length)+")<br>");
		return this.permissions_match.length==checkfor.length;
	}
	
	
	function DBsession()
	{
	}
	
	// C R C  3 2  C A L C U L A T O R

	// CRC polynomial 0xEDB88320
	var Crc32Tab = new Array( 
	0x00000000,0x77073096,0xEE0E612C,0x990951BA,0x076DC419,0x706AF48F,0xE963A535,0x9E6495A3,
	0x0EDB8832,0x79DCB8A4,0xE0D5E91E,0x97D2D988,0x09B64C2B,0x7EB17CBD,0xE7B82D07,0x90BF1D91,
	0x1DB71064,0x6AB020F2,0xF3B97148,0x84BE41DE,0x1ADAD47D,0x6DDDE4EB,0xF4D4B551,0x83D385C7,
	0x136C9856,0x646BA8C0,0xFD62F97A,0x8A65C9EC,0x14015C4F,0x63066CD9,0xFA0F3D63,0x8D080DF5,
	0x3B6E20C8,0x4C69105E,0xD56041E4,0xA2677172,0x3C03E4D1,0x4B04D447,0xD20D85FD,0xA50AB56B,
	0x35B5A8FA,0x42B2986C,0xDBBBC9D6,0xACBCF940,0x32D86CE3,0x45DF5C75,0xDCD60DCF,0xABD13D59,
	0x26D930AC,0x51DE003A,0xC8D75180,0xBFD06116,0x21B4F4B5,0x56B3C423,0xCFBA9599,0xB8BDA50F,
	0x2802B89E,0x5F058808,0xC60CD9B2,0xB10BE924,0x2F6F7C87,0x58684C11,0xC1611DAB,0xB6662D3D,
	0x76DC4190,0x01DB7106,0x98D220BC,0xEFD5102A,0x71B18589,0x06B6B51F,0x9FBFE4A5,0xE8B8D433,
	0x7807C9A2,0x0F00F934,0x9609A88E,0xE10E9818,0x7F6A0DBB,0x086D3D2D,0x91646C97,0xE6635C01,
	0x6B6B51F4,0x1C6C6162,0x856530D8,0xF262004E,0x6C0695ED,0x1B01A57B,0x8208F4C1,0xF50FC457,
	0x65B0D9C6,0x12B7E950,0x8BBEB8EA,0xFCB9887C,0x62DD1DDF,0x15DA2D49,0x8CD37CF3,0xFBD44C65,
	0x4DB26158,0x3AB551CE,0xA3BC0074,0xD4BB30E2,0x4ADFA541,0x3DD895D7,0xA4D1C46D,0xD3D6F4FB,
	0x4369E96A,0x346ED9FC,0xAD678846,0xDA60B8D0,0x44042D73,0x33031DE5,0xAA0A4C5F,0xDD0D7CC9,
	0x5005713C,0x270241AA,0xBE0B1010,0xC90C2086,0x5768B525,0x206F85B3,0xB966D409,0xCE61E49F,
	0x5EDEF90E,0x29D9C998,0xB0D09822,0xC7D7A8B4,0x59B33D17,0x2EB40D81,0xB7BD5C3B,0xC0BA6CAD,
	0xEDB88320,0x9ABFB3B6,0x03B6E20C,0x74B1D29A,0xEAD54739,0x9DD277AF,0x04DB2615,0x73DC1683,
	0xE3630B12,0x94643B84,0x0D6D6A3E,0x7A6A5AA8,0xE40ECF0B,0x9309FF9D,0x0A00AE27,0x7D079EB1,
	0xF00F9344,0x8708A3D2,0x1E01F268,0x6906C2FE,0xF762575D,0x806567CB,0x196C3671,0x6E6B06E7,
	0xFED41B76,0x89D32BE0,0x10DA7A5A,0x67DD4ACC,0xF9B9DF6F,0x8EBEEFF9,0x17B7BE43,0x60B08ED5,
	0xD6D6A3E8,0xA1D1937E,0x38D8C2C4,0x4FDFF252,0xD1BB67F1,0xA6BC5767,0x3FB506DD,0x48B2364B,
	0xD80D2BDA,0xAF0A1B4C,0x36034AF6,0x41047A60,0xDF60EFC3,0xA867DF55,0x316E8EEF,0x4669BE79,
	0xCB61B38C,0xBC66831A,0x256FD2A0,0x5268E236,0xCC0C7795,0xBB0B4703,0x220216B9,0x5505262F,
	0xC5BA3BBE,0xB2BD0B28,0x2BB45A92,0x5CB36A04,0xC2D7FFA7,0xB5D0CF31,0x2CD99E8B,0x5BDEAE1D,
	0x9B64C2B0,0xEC63F226,0x756AA39C,0x026D930A,0x9C0906A9,0xEB0E363F,0x72076785,0x05005713,
	0x95BF4A82,0xE2B87A14,0x7BB12BAE,0x0CB61B38,0x92D28E9B,0xE5D5BE0D,0x7CDCEFB7,0x0BDBDF21,
	0x86D3D2D4,0xF1D4E242,0x68DDB3F8,0x1FDA836E,0x81BE16CD,0xF6B9265B,0x6FB077E1,0x18B74777,
	0x88085AE6,0xFF0F6A70,0x66063BCA,0x11010B5C,0x8F659EFF,0xF862AE69,0x616BFFD3,0x166CCF45,
	0xA00AE278,0xD70DD2EE,0x4E048354,0x3903B3C2,0xA7672661,0xD06016F7,0x4969474D,0x3E6E77DB,
	0xAED16A4A,0xD9D65ADC,0x40DF0B66,0x37D83BF0,0xA9BCAE53,0xDEBB9EC5,0x47B2CF7F,0x30B5FFE9,
	0xBDBDF21C,0xCABAC28A,0x53B39330,0x24B4A3A6,0xBAD03605,0xCDD70693,0x54DE5729,0x23D967BF,
	0xB3667A2E,0xC4614AB8,0x5D681B02,0x2A6F2B94,0xB40BBE37,0xC30C8EA1,0x5A05DF1B,0x2D02EF8D);

	// 'crc' should be initialized to 0xFFFFFFFF and after the computation it should be inverted.
	function Crc32Add(crc,c)
	{
		return Crc32Tab[(crc^c)&0xFF]^((crc>>8)&0x00FFFFFF);
	}	
	
	function DBcrc32(str)
	{
		var len = str.length;
		var crc = 0xFFFFFFFF;
		
		for (var n=0; n<len; n++)
			crc=Crc32Add(crc,str.charCodeAt(n));
			
		return (~crc)&0xFFFFFFFF;
	}
	
	function DYN_INCLUDE(dyn_title,dyn_version)
	{
	   var dyn_sSQL = "select rev_rev from usite_review where rev_title = \""+dyn_title+"\" and rev_desc = \""+dyn_version+"\" and rev_dir_lng = \""+_ws+"\" and rev_pub & 9 = 1 LIMIT 0,1"
	   
	   if(typeof(_oDB)=="object")
		  var exe = _oDB.get(dyn_sSQL);
	   else if(typeof(oDB)=="object")
		  var exe = oDB.get(dyn_sSQL);
	   
	   exe = "try {\r\n"
			   +exe
			   +"\r\n}"
			   +"\r\n"
			   +"catch(e)\r\n"
			   +"{\r\n"
			   +"  Response.Write(\"ERROR IN DYNAMIC INCLUDE \\\""+dyn_title+"\\\" "+dyn_version+"&lt;br&gt;\"+e.description)\r\n"
			   +"}"
			   +"\r\n"
		
		
		return exe
	}
%>
