<%


function CANDI()
{
    this.main = candiform;
    this.fetchform = CAFfetchform;
    this.isDataField = CAFisDataField;
	this.mailsender = CAFmailsender;
	this.VDBloadfieldnames = CAFVDBloadfieldnames;
	this.stdmailprep = CAFstdmailprep;
	this.DBdetaildata = CAFDBdetaildata;
    this.getRecID  = CAFgetRecID;
	
	this._app_db_prefix = "usite";
    this._detaildb = "_candidetail";
    this._masterdb = "_candiset";
	
	this.datadetail_ids = new Array();
	this.datadetail     = new Array();

    this.bMultiPart = false;
    this.edit_ids = new Array();
    this.edit_fld = new Array();
    this.ds = 0;
    this.bDebug = false;
    this.bSQLDebug = false;
    this.bSaved  = false;
    this.ses  = "";
	this.sid  = 0;

    this.mpform = new Array();
    this.activeform = new Array();
	this.allform = new Array();
    this.formtotalbytes = 0;
    this.bSubmitted = false;
	this.bReadOnly = false;
	
	this.PHYfieldnames = new Array();   // Physical fieldnames
	this.VDBfieldnames = new Array();   // Virtual fieldnames
	this.EXTfieldnames = new Array();   // EXTERNAL Physical fieldnames
	
	this.mail_Host      = "relay-auth.mailprotect.be";
	this.mail_User      = "thecandidatescom";
	this.mail_Pass      = "BFnS43";
	
    this.mail_From      = "updates@thecandidates.com";
	this.mail_Bounce    = "bounc@thecandidates.com"
	this.mail_Addresses = new Array("info@thecandidates.com");
	this.mail_Attachments = new Array();
	this.mail_BCC       = new Array();

	this.mail_FromName  = "";
	this.mail_Subject   = "[SUBJECT]";
	this.mail_Body      = "[BODY]";
	this.mail_IsHTML    = false;
    
	
}

function CAFgetRecID()
{
    var sSQL = "select rd_recno from "+this._app_db_prefix+this._detaildb+" where rd_ds_id = "+this.ds+" and rd_recno="+my_decrypt(this.ses);
    if(this.bDebug) Response.Write(sSQL+"<br>");
    return _oDB.getrows(sSQL);
}

function CAFDBdetaildata()
{
	//////////////////////////////
	// FETCH DATA FROM DATABASE //
	//////////////////////////////
	
	this.sid = this.ses ? Number(my_decrypt(this.ses)) : 0;
	var sSQL = "SELECT rd_dt_id,rd_text FROM "+this._app_db_prefix+this._detaildb+" where rd_ds_id = "+this.ds+" and rd_recno = "+this.sid;
	if(this.bSQLDebug==true)
		Response.Write(sSQL+"<br>");
		
		

	var buf = _oDB.getrows(sSQL);

		if(this.bSubmitted==false && this.bDebug==true)
		{
		   Response.Write("importing structured data...<br>");
		}

		oDATA.namecache_data["DATACACHE_1"]["_session"] = my_encrypt(this.sid.toString());


	for(var j=0;j<buf.length;j+=2)
	{
	  var db_value = buf[j+1];
	  this.datadetail_ids[j/2] = buf[j];
	  this.datadetail[buf[j]] = db_value;
	  
	  if(this.bDebug==true)
		Response.Write("this.datadetail["+buf[j]+"] = "+this.datadetail[buf[j]]+"<br>");
	  
	}

}


function CAFmailsender()
{
    if(!this.mail_Body) return;
	
	if(this.bDebug)
	{
		Response.Write("Mail.From = '"+this.mail_From+"'<br>");
		Response.Write("Mail.FromName = '"+this.mail_FromName+"'<br>");
		Response.Write("Mail.Addresses = '"+this.mail_Addresses+"'<br>");
		Response.Write("Mail.BCC = '"+this.mail_BCC+"'<br>");
		Response.Write("Mail.Subject = '"+this.mail_Subject+"'<br>");
		Response.Write("Mail.Body = '"+this.mail_Body+"'<br>");
		Response.Write("Mail.IsHTML = '"+this.mail_IsHTML+"'<br>");
		for(var _msi=0;_msi<this.mail_Attachments.length;_msi++)
		   Response.Write("Mail.AddAttachment('"+this.mail_Attachments[_msi]+"')<br>");
	}

	var Mail = Server.CreateObject("Persits.Mailsender");
    Mail.Host 		    = this.mail_Host;
	Mail.Username       = this.mail_User;
	Mail.password       = this.mail_Pass;
	Mail.From 		    = this.mail_From;
	
	if(this.mail_Bounce)
	   Mail.MailFrom = "bounce@thecandidates.com";
	
	for(var msi=0;msi<this.mail_Addresses.length;msi++)
	    Mail.AddAddress(this.mail_Addresses[msi]);
	for(var msi=0;msi<this.mail_BCC.length;msi++)
	    Mail.AddBCC(this.mail_BCC[msi]);
	if(this.mail_Attachments.length>0)
	{
		for(var _msi=0;_msi<this.mail_Attachments.length;_msi++)
			Mail.AddAttachment(this.mail_Attachments[_msi]);
	}

	Mail.FromName   	= this.mail_FromName;
	Mail.Subject 		= this.mail_Subject;
	Mail.Body 		    = this.mail_Body;
	Mail.IsHTML		    = this.mail_IsHTML;

	Mail.Queue          = true;

    try
    {
	    Mail.Send();
    }
	catch(e)
	{
	  var txt="There was an error on this page.\n\n";
	  txt+="Error description: " + e.description + "\n\n";
	  txt+="Click OK to continue.\n\n";
	  Response.Write(txt)
	}
}

function CAFstdmailprep()
{
    this.sid = this.ses ? Number(my_decrypt(this.ses)) : 0;
    this.mail_FromName    = this.mail_From;
	
    var oCO2 = new CO();
    oCO2.connectstring = "ODBC;driver={mysql};database=coinpetto;server=localhost;uid=sbslink;pwd=xxlsbslink;DSN=sbslink";
    var ConObj2 = Server.CreateObject("ADODB.Connection");
    var RSObj2  = Server.CreateObject("ADODB.Recordset");	
		
	var _sSQL = "select voornaam,naam from dbo_t_kandidaten_basis where pnr = " + this.sid;
	ConObj2.Open(oCO2.connectstring);RSObj2.Open(_sSQL, ConObj2);var _arr = RSObj2.EOF?new Array():RSObj2.GetRows().toArray();RSObj2.Close();ConObj2.Close();

    this.mail_Subject     = _arr[0]+" "+_arr[1]+" ["+ this.sid +"]";
	
    if(this.mail_BCC.length==0)
	this.mail_BCC       = new Array("freddy.vandriessche@gmail.com");

	this.mail_Body = "";
	
	for(var j=0;j<this.allform.length;j++)
	{
		var formname = this.allform[j]?this.allform[j]:"";
		
		
		
		var displayname = formname;
		
		if(this.isDataField(formname) && this.VDBfieldnames[formname.substring(1,formname.length)])
		  displayname = this.VDBfieldnames[formname.substring(1,formname.length)];
		  
		if(formname!="x" && formname!="y")
			this.mail_Body += displayname+" = "+this.mpform[formname]+"\r\n"
			
		//Response.Write(displayname+" = "+this.mpform[formname]+"<br>")
	}
}




function CAFisDataField(_str)
{
   return _str && _str.charAt(0)=='d' && !isNaN(_str.charAt(1));
}


function CAFVDBloadfieldnames()
{

   
		var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub");
		var sSQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+this.ds;
		var overview = _oDB.getrows(sSQL);

	
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
			//enumdataset[DBfieldID[i]] = fields.item(i).getAttribute("name");
			this.VDBfieldnames[DBfieldID[i]] = fields.item(i).getAttribute("name");
			if(this.bDebug)
			    Response.Write("VDBfieldnames["+DBfieldID[i]+"] = "+this.VDBfieldnames[DBfieldID[i]]+"<br>");
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
			this.PHYfieldnames[hID] = hfields.item(i).getAttribute("name");
			//enumheader[hID] = hfields.item(i).getAttribute("name");
			//headername[i] = hfields.item(i).getAttribute("name");
			
			if(this.bDebug)
			{
				//Response.Write("header["+i+"] = "+header[i]+"<br>");
				Response.Write("PHYfieldnames["+hID+"] = "+this.PHYfieldnames[hID]+"<br>");
			}
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
	return xmlDoc;
}


function CAFfetchform()
{

  // FETCH MULTIPART FORM DATA
  try 
  {
	var Upload = Server.CreateObject("Persits.Upload.1");
	var FormCollection = Upload.Form;
  }
  catch(e)
  {
	this.bMultiPart = false;
	function Upload() { this.Form = UploadForm }
	function UploadForm() {}
        
        // TODO HERE: Eventually set all this.bMultiPart this.activeform[obj.name] = true 
  }

  try {var Count = Upload.Save(Server.Mappath ("../images/upload")); this.bSaved = true; } catch(e) {};

  for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
  {
	var obj = objEnum.item();
	var idx = obj.name;
	this.mpform[obj.name] = obj.value;

        this.formtotalbytes += obj.value.length;
        // DETECT FORM DATA THAT IS REALLY THERE (ONLY POSSIBLE WITH MULTIPART FORMS)
        if(this.isDataField(idx))
          this.activeform[idx.substring(1,idx.length)] = true; 
        if(this.bDebug)
          Response.Write("this.mpform["+obj.name+"] = '"+obj.value+"'<br>");
	this.allform[this.allform.length] =  idx;
  }

  var FileCollection = Upload.Files;
  for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
  {
	var obj = objEnum.item();
	var idx = obj.name;
	this.mpform[obj.name] = obj.path;
        if(this.isDataField(idx))
          this.activeform[idx.substring(1,idx.length)] = true; 
        if(this.bDebug)
          Response.Write("this.mpform["+obj.name+"] = '"+obj.path+"'<br>");
        this.allform[this.allform.length] =  idx;
  }

  if(this.bMultiPart==false)
  	try{ Request.Form("act").Item } catch(e) { Response.Write("ERROR READING MULTIPART FORM"); this.bMultiPart=true;}

  this.bSubmitted = this.formtotalbytes==0?false:true;

}






function candiform()
{
var setc = 0;
var setclause = new Array();

if(this.bMultiPart==true)
{
	// FETCH MULTIPART FORM DATA
	try 
	{
		var Upload = Server.CreateObject("Persits.Upload.1");
		var FormCollection = Upload.Form;
	}
	catch(e)
	{
		this.bMultiPart = false;
		function Upload() { this.Form = UploadForm }
		function UploadForm() {}
		
		// TODO HERE: Eventually set all this.bMultiPart this.activeform[obj.name] = true 
	}
}
else
{
		function Upload() { this.Form = UploadForm }
		function UploadForm() {}
		
		// BUILD A DECOY FORM COLLECTION
		var FormCollection = new Array();
		for(var _cf=0;_cf<this.edit_ids.length;_cf++)
			FormCollection[_cf] = {name:("d"+this.edit_ids[_cf]),value:Request.Form("d"+this.edit_ids[_cf]).Item}
		


}


//Response.Write("*"+(this.bSaved==true))


if(this.bSaved!=true)
{
	try {var Count = Upload.Save(Server.Mappath ("../images/upload")); this.bSaved = true; } catch(e) {};

	for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
	{
	var obj = objEnum.item();
	var idx = obj.name;
	
	this.mpform[obj.name] = obj.value;
		this.formtotalbytes += obj.value?obj.value.length:0;
		// DETECT FORM DATA THAT IS REALLY THERE (ONLY POSSIBLE WITH MULTIPART FORMS)
		if(this.isDataField(idx))
		  this.activeform[idx.substring(1,idx.length)] = true; 
		if(this.bDebug)
		  Response.Write("this.mpform["+obj.name+"] = '"+obj.value+"'<br>");
		this.allform[this.allform.length] =  idx;
	}
}




this.bSubmitted = this.formtotalbytes==0?false:((this.bMultiPart?this.mpform["act"]:Request.Form("act").Item)=="OK"?false:true);




var oFORM = new FORM();
var oFORMIO = new oFORM.IO();
oFORMIO.bSubmitted = this.bSubmitted;




/////////////////////////////////////
//    L O A D   S E T T I N G S    //
/////////////////////////////////////

var oSETTINGS = new SETTINGS();
oSETTINGS.id = this.ds;
oSETTINGS.load();

var enumsettings = new Array();
if(oSETTINGS.settingdata["FIELD_PROPERTIES"].length>0)
	for(var j=0;j<oSETTINGS.settingdata["FIELD_PROPERTIES"].length;j+=oSETTINGS.paramtablefld.length)
        {
		enumsettings[oSETTINGS.settingdata["FIELD_PROPERTIES"][j+1]] = j+1;
                //Response.Write("enumsettings["+oSETTINGS.settingdata["FIELD_PROPERTIES"].join("*")+"] = "+(j+1)+"<br>")

        }

var tablefld = new Array("ds_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_datetime02","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
var enumfld = new Array();
for (var j=0; j<tablefld.length ; j++)
	enumfld[tablefld[j]] = j;



// GET RECORD ID BACK AFTER FIRST SUBMIT  (OVERRIDE IF NECESSARY)
var tmpval = this.getRecID()
this.sid = 0;


String.prototype.ltrim = function () { return this.replace(/^ */,""); }





if(tmpval[0] && isNaN(Number(tmpval[0]))==false && this.ses)
{
   
   this.sid = Number(tmpval[0]);
   //Session("arobar_uid") = my_encrypt(tmpval[0]);
}
else
{ 
  this.sid = this.ses ? Number(my_decrypt(this.ses)) : 0;
  if (this.sid==0)
	Response.Redirect("index.asp");
     
}





if(this.sid>0)
{
	//////////////////////////////
	// FETCH DATA FROM DATABASE //
	//////////////////////////////
	
	var sSQL = "SELECT rd_dt_id,rd_text FROM "+this._app_db_prefix+this._detaildb+" where rd_ds_id = "+this.ds+" and rd_recno = "+this.sid;
	var buf = _oDB.getrows(sSQL);
	
	if(this.bSubmitted==false && this.bDebug==true)
	{
	   Response.Write("importing structured data...<br>");
	}
	if(this.bSQLDebug==true)
		Response.Write(sSQL+"<br>");


	oDATA.namecache_data["DATACACHE_1"]["_session"] = my_encrypt(this.sid.toString());

	for(var j=0;j<buf.length;j+=2)
	{
	  var db_value = buf[j+1];
	  var en = enumsettings["["+buf[j]+"]"];
	  var type = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
	  var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
	  this.datadetail[buf[j]] = db_value;
	  
	  db_value = oFORMIO.put(db_value,type,format);
	  oDATA.namecache_data["DATACACHE_1"][buf[j]] = db_value;
	  
	  //Response.Write("namecache["+buf[j]+"] = "+db_value+" ("+format+")<br>")
	  //if(this.bDebug==true)
	  //  Response.Write("oDATA.namecache_data[DATACACHE_1]["+buf[j]+"] = "+db_value+" (buf[j+1] = "+buf[j+1]+")<br>");
	  
	  if(this.bDebug==true)
	    Response.Write("this.datadetail["+buf[j]+"] = "+this.datadetail[buf[j]]+"<br>");
	  
	}
	
	///////////////////////
	// REQUEST FORM DATA //
	///////////////////////


 
	var dat = new Array();
	for(var j=0;j<this.edit_ids.length;j++)
	{
		var curfieldID = this.edit_ids[j];
		
		//Response.Write("DBDATA["+curfieldID+"] = "+oDATA.namecache_data["DATACACHE_1"][curfieldID]+"<br>");
		
		// GET FIELD SETTINGS
		var en    = enumsettings["["+curfieldID+"]"];
		var type  = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+2];
		var format = oSETTINGS.settingdata["FIELD_PROPERTIES"][en+3];
		
		var form_value = this.bMultiPart?this.mpform["d"+curfieldID]:Request.Form("d"+curfieldID).Item;

		if(this.bDebug)
		   Response.Write(curfieldID+" "+en+" "+type+" "+oSETTINGS.settingdata["FIELD_PROPERTIES"].slice(en,en+3).join("<br>")+" "+"*<br>");

		//Response.Write("this.edit_ids="+this.edit_ids+"<br>")
		//Response.Write(oDATA.namecache_data["DATACACHE_1"]);
		//Response.Write("<br>($"+db_value+"$) $"+form_value+"$)\r\n<br><br>")
		
		var db_value = oDATA.namecache_data["DATACACHE_1"][curfieldID];
		form_value   = form_value?form_value.trim():"";
		
		// INTERPRET FORM DATA FORMATTING
		form_value = oFORMIO.get(form_value,type,format);
		db_value   = oFORMIO.get(db_value,type,format);
		form_value = form_value.replace(/"/g,"\\\"");	
                var value = "";			
		
		if(this.bSubmitted==true)
			value = form_value;	
		else
                        value = db_value;


		////////////////////////////
		//    IMAGE PROCESSING    //
		////////////////////////////


		switch(type)
		{
		case "img":
			///////////////////////////////////
			//    RESIZE UPLOADED IMAGERY    //
			///////////////////////////////////
			
			var FileCollection = Upload.Files;
			var filepath = "../"+_ws+"/images";
			var arrformats = format.split(",");
			var filebase   = zerofill(this.ds,10)+"_"+zerofill(this.sid,6)+"_"+zerofill(curfieldID,3);
			var fs	       = Server.CreateObject("Scripting.FileSystemObject");
			var source_path	= Server.Mappath("../images/upload")+"\\";
			var dest	= Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
			var _attr       = "align=center"
			
			if(this.bSubmitted==true)
			{				
				if (this.bMultiPart && this.bSaved)
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
							for(var jj=0;jj<arrformats.length;jj++)
							{
								jpeg.open( obj.path );
								jpeg.Quality = 90;
								jpeg.Interpolation = 2;
								
								resizetoRect(jpeg,arrformats[jj]);
								//jpeg.Sharpen(1,105);
								var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+jj+".jpg";
								jpeg.Save(savefile);
								
								form_value = (isNaN(form_value)?0:Number(form_value)) | (1<<jj);  // alter bitmap !
								
								bValidImage = true;
								
								if(this.bDebug)
									Response.Write("IMAGE SAVED: "+savefile+"<br><br>");
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
						try {fs.DeleteFile(dest)}catch(e){if (this.bDebug) Response.Write("*delete* "+dest+": "+e)};
						
						for(var jj=0;jj<1000 && fs.FileExists(dest)==false;jj++)
						if(fs.FileExists(source))
						{
							try {fs.MoveFile(source,dest)}catch(e){if (this.bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
						}
					}
				}
			}			
			
			
			var name = "d"+curfieldID;
			var actimg = isNaN(value)?0:Number(value);
			
			
			var bFileExists = fs.FileExists(dest);
			var imgpanel = "<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&1)==1?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
			+"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^((1<<("+(arrformats.length)+"))-1);main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
			+(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
			+"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
			+(bFileExists?"</a>":"")
			+"<br><br>JPG<br>Image<br><br><input SIZE=1 name=\"FILE"+zerofill(curfieldID,3)+"\" type=FILE onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">   "
			+"</td></tr></table>";
			
			/*
			// DISPLAY ALL AVAILABLE FORMATS
			var bitlength = actimg.toString(2).length;
			if(actimg>0)
				for(var jj=0;jj<bitlength;jj++)
					imgpanel += (bFileExists?("<a href=imgframer.asp?img=img"+filebase+"_"+jj+".jpg&src=src"+filebase+".jpg&dim="+arrformats[jj]+" target=_blank>"+arrformats[jj]+"</a><br>"):"")
			*/
			
			value = imgpanel + "<input type=hidden name="+name+" value=\""+value+"\">"
			
			break;
		 
		 
			case "gallery":

			if(this.bSubmitted==true)
			{				
				if (this.bMultiPart && this.bSaved)
				{
					if(format && format.indexOf("(")>0 && format.indexOf(")")>0)
					{
						var args = argsplitter(format);
						format = args[0];
						var arg  = argparser(args[1]);
						arg["size"]=arg["size"].split(",");
					}
					else
					{
						var arg = new Array();
						arg["size"]=format.split(",");
						format = "param";
					}
					
					var arrformats = arg["size"];
					
					
					
					var bValidImage = false;
					for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
					{
						var obj = objEnum.item();
						var ext = obj.path.substring(obj.path.lastIndexOf("."),obj.path.length).toLowerCase();
						var imgnr = Number(obj.name.substring(4,7));
						imgsubnr =  Number(obj.name.substring(8,10));
						
						filebase = zerofill(this.ds,10)+"_"+zerofill(this.sid,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(imgsubnr,2)
						dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
						
						if((ext==".jpg" || ext ==".jpeg") && imgnr == curfieldID)
						{
							var jpeg = Server.CreateObject("Persits.Jpeg");
							
							for(var jj=0;jj<arrformats.length;jj++)
							{
								jpeg.open( obj.path );
								jpeg.Quality = 90;
								jpeg.Interpolation = 2;
								
								resizetoRect(jpeg,arrformats[jj]);
								//jpeg.Sharpen(1,105);
								var savefile = Server.MapPath(filepath) + "\\img"+filebase+"_"+jj+".jpg";
								jpeg.Save(savefile);
								
								bValidImage = true;
								if(this.bDebug)
									Response.Write("IMAGE SAVED: "+savefile+"<br><br>")
							}
							
							value = (isNaN(value)?0:Number(value)) | (1<<imgsubnr);  // alter bitmap !
							
							
							if(this.bDebug)
								Response.Write("BITMAP: ["+zerofill(form_value.toString(2),16)+"]<br><br>")
							
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
						try {fs.DeleteFile(dest)}catch(e){if (this.bDebug) Response.Write("*delete* "+dest+": "+e)};
						
						for(var jj=0;jj<1000 && fs.FileExists(dest)==false;jj++)
							if(fs.FileExists(source))
							{
								try {fs.MoveFile(source,dest)}catch(e){if (this.bDebug) Response.Write("*movefile* source:"+source+" TO dest:"+dest+" "+e+"<br>")};
								if(this.bDebug)
									Response.Write("IMAGE MOVED: source:"+source+" TO dest:"+dest+"<br><br>");
							}
					}
				}
			}


			///////////////////////////////////
			//    RESIZE UPLOADED IMAGERY    //
			///////////////////////////////////
			
			var FileCollection = Upload.Files;
			var filepath = "../"+_ws+"/images";

			var fs		= Server.CreateObject("Scripting.FileSystemObject");
			var source_path	= Server.Mappath("../images/upload")+"\\";
			var filebase 	= "";
			var dest	= ""
			var imgsubnr 	= 0;
			



			// SPECIAL SWITCH FOR GALLERY SIZE
			var opts = oDATA.namecache_data["DATACACHE_1"][9];
			

			var bitlength = (opts&4?4:0)+(opts&8?12:0);
			//var bitlength = value==0?0:value.toString(2).length;

			var actimg = isNaN(value)?0:Number(value);	

			var imgpanel = new Array(bitlength);
		        var name = "d"+curfieldID;

                        //Response.Write("actimg = "+zerofill(actimg.toString(2),16)+"<br>")
	
			for(var b=0;b<bitlength;b++)
			{
				
				filebase = zerofill(this.ds,10)+"_"+zerofill(this.sid,6)+"_"+zerofill(curfieldID,3)+"_"+zerofill(b,2)
				
				dest = Server.MapPath(filepath)+ "\\src" + filebase +".jpg";
				var bFileExists = fs.FileExists(dest);
				
				
				imgpanel[b] = ((b%4)==0 && b>0?"</td></tr><tr><td>":"")
				+"<table height=100 width=100 bgcolor=black cellspacing=1><tr><td style=font-size:12px;background-color:white align=center "+((actimg&(1<<b))?(" background="+filepath+"/img"+filebase+"_0.jpg?"+(Math.floor(Math.random()*10000))):"")+" valign=top>"
				+"<IMG border='0' name='b0' src='../images/exit.gif' onMouseover=this.src='../images/exit.gif';this.style.cursor='hand' onMouseout=this.src='../images/exit.gif' onclick=main."+name+".value=main."+name+".value^(1<<"+b+");main.submit(); title='remove image' hspace=3 vspace=2 align=left>"
				+(bFileExists?("<a href=disp.asp?d="+escape("<html><body bgcolor=black leftmargin=0 topmargin=0 rightmargin=0 bottommargin=0><table height='100%' width='100%' cellspacing=0 cellpadding=0><tr><td valign=middle align=center><img src="+filepath+"/src"+filebase+".jpg?"+(Math.floor(Math.random()*10000))+" onclick=window.close()></td></tr></table></body></html>")+" target=_blank>"):"")
				+"<IMG border='0' name='b0' "+(bFileExists?"src='../images/full_green.gif'":"src='../images/full.gif'")+"' onclick='' hspace=3 vspace=2 title='full screen' align=right>"
				+(bFileExists?"</a>":"")
				+"<br><br>JPG<br>Image<br><br><input SIZE=1 name=\"FILE"+zerofill(curfieldID,3)+"_"+zerofill(b,2)+"\" type=FILE value=\""+Server.HTMLEncode(value)+"\"  onchange=main."+name+".value=(main."+name+".value|1);main.submit() onmouseover=this.style.cursor='hand' style=\"background-color:white;border:'1px solid #FFFFFF';font:'10px Verdana';text-align=right;\">   "
				+"</td></tr></table>";
				
				/*
				// DISPLAY ALL AVAILABLE FORMATS			
							for(var jj=0;jj<arrformats.length;jj++)
							{				
								imgpanel[b] += (bFileExists?("<a href=imgframer.asp?img=img"+filebase+"_"+jj+".jpg&src=src"+filebase+".jpg&dim="+arrformats[jj]+" target=_blank><small>"+arrformats[jj]+"</small></a><br>"):"")
							}
				*/
				
			}
			
			value = "<table cellspacing=0 cellpadding=5><tr><td valign=top>"+imgpanel.join("</td><td width=10> </td><td valign=top>")+"</td></tr></table>"+"<input name="+name+" type=hidden value=\""+value+"\"><br></td></tr>";	
			break;
		}	
		
			


		if(this.bSubmitted==true && this.activeform[curfieldID])
		{	
			if(!db_value && form_value)
			{
			  // INSERT
			  var SQL = "insert into "+this._app_db_prefix+this._detaildb+" (rd_ds_id,rd_dt_id,rd_recno,rd_text) value ("+this.ds+","+curfieldID+","+this.sid+",\""+form_value+"\")";
			
                         if (this.bSQLDebug) Response.Write((this.bReadOnly?"(NOT EXECUTED)":"")+SQL+"<br>");
			 if(!this.bReadOnly) _oDB.exec(SQL);
			}
			else if(db_value && !form_value)
			{
			  // DELETE
			  var SQL = "delete from "+this._app_db_prefix+this._detaildb+" where rd_ds_id = "+this.ds+" and rd_dt_id = "+curfieldID+" and rd_recno = "+this.sid;
			 
			  if (this.bSQLDebug) Response.Write((this.bReadOnly?"(NOT EXECUTED)":"")+SQL+"<br>");
			  if(!this.bReadOnly) _oDB.exec(SQL); 
			}
			else if(db_value && form_value && db_value != form_value)
			{
			  // UPDATE
			  var SQL = "update "+this._app_db_prefix+this._detaildb+" set rd_text = \""+form_value+"\" where rd_ds_id = "+this.ds+" and rd_dt_id = "+curfieldID+" and rd_recno = "+this.sid; 
			 if (this.bSQLDebug) Response.Write((this.bReadOnly?"(NOT EXECUTED)":"")+SQL+"<br>");
			 if(!this.bReadOnly) _oDB.exec(SQL); 
			}

			if(this.edit_fld[j])
			   if(type=="date")
				setclause[setc++] = this.edit_fld[j]+" = "+ (!isNaN(new Date(form_value))?("\""+form_value+"\""):"null");
			   else
			        setclause[setc++] = this.edit_fld[j]+" = \""+ form_value +"\"";	
		}


			
		// INTERPRET DB DATA FORMATTING
		value = oFORMIO.put(value,type,format);
		oDATA.namecache_data["DATACACHE_1"][curfieldID] = value;
	
		
		
		//Response.Write(type+" "+j+" "+this.edit_ids.length+"<br>");
	}



    //Response.Write("*"+setclause.length+"*<br>")

    if(setclause.length>0)
    {
      // CREATE IF RECORD DOES NOT EXISTS
      var SQL = "select count(*) from "+this._app_db_prefix+this._masterdb+" where ds_rev_id = "+this.ds+" and ds_id = "+this.sid;
      if(!_oDB.get(SQL))
      {
        var SQL = "insert into "+this._app_db_prefix+this._masterdb+" (ds_rev_id,ds_id) values ("+this.ds+","+this.sid+")";
        if(this.bSQLDebug) Response.Write((this.bReadOnly?"(NOT EXECUTED)":"")+SQL+"<br>");
        if(!this.bReadOnly) _oDB.exec(SQL);
      }

       var SQL = "update "+this._app_db_prefix+this._masterdb+" set "+setclause+" where ds_rev_id = "+this.ds+" and ds_id = "+this.sid;
       if(this.bSQLDebug)
           Response.Write((this.bReadOnly?"(NOT EXECUTED)":"")+SQL+"<br>")
       if(!this.bReadOnly) _oDB.exec(SQL);
    }

	

}

function resizetoRect(picobj,size)
{

//Response.Write(size+"<br>")

	var splitarr = size.split(":");
	var sizes = splitarr[0].split("x");
	var sizex = Number(sizes[0]);
	var sizey = Number(sizes[1]);
	
	if(!isNaN(splitarr[1]))
		picobj.Quality = Number(splitarr[1]);
	
	if(isNaN(sizex) && isNaN(sizey))
		return;
	
	if(sizes[1]=="MAXVAR" && !isNaN(sizex))
	{
		if(picobj.height>550)
		{
			if (  picobj.width > sizex )
				resizetoWidth(picobj,sizex);			
			
			if (  picobj.height > 550 )
			{
				sizey = 550;
				resizetoHeight(picobj,sizey);
			}
		}
		else
		{
			maxheight = sizey;
			maxwidth = sizex;
			
			resizetoWidth(picobj,sizex,maxheight);
			
			if (  picobj.height > 550 )
			{
				sizey = 550;
				resizetoHeight(picobj,sizey);
			}
		}
		return;
	}


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
		resizetoWidth(picobj,sizex,maxheight);

	
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


function argsplitter(_str)
{
    if(_str && _str.indexOf("(")>0 && _str.indexOf(")")>0)
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
	else
	{
		return new Array(new String(_str))
	}
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



}

function my_encrypt(_str)
{
   return _str?_str.toString().encrypt("nicnac"):"";
}

function my_decrypt(_str)
{
   return _str?_str.decrypt("nicnac"):"";
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

function VIRTUALDB()
{
   this.init              = UD_init;

   this.map_data          = new Array();
   this.map_enum          = new Array();
   this.map               = new Array();
   this.output            = new Array();
   this.key               = new Array();
   this.key_sync          = new Array();

   this.header_iar        = new Array();
   this.header_arr        = new Array();
   this.header_enu        = new Array();
   this.header_idx        = new Array();
   this.header_idc		  = new Array();
   this.detail_arr        = new Array();
   this.detail_idx        = new Array();
   this.inserted_id       = 1;
   this.status            = 0;
   this.bDebug            = false;
   this.bSQLDebug         = false;
   this.bDisable          = false;
   this.masterdb          = "dataset";
   this.detaildb          = "datadetail";

   this.dslengths         = {"ds_title":256
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
}







///////////////////           M A P P E R           //////////////////////



function MAPPING()
{
   this.v                 = UD_v;
   this.m                 = UD_m;
   this.insert_dataset    = UD_insert_dataset;
   this.insert_datadetail = UD_insert_datadetail;
   this.sync_init         = UD_sync_init;
   this.sync_dataset      = UD_sync_dataset;
   this.sync_datadetail   = UD_sync_datadetail;
   this.delete_data       = UD_delete_data;
   this.init              = UD_init;
   this.copy_create       = UD_copy_create;
   this.select            = UD_select;

   this.map_data          = new Array();
   this.map_enum          = new Array();
   this.map_inv_enum	  = new Array();
   this.map               = new Array();
   this.output            = new Array();
   this.key               = new Array();
   this.key_sync          = new Array();

   this.header_iar        = new Array();
   this.header_arr        = new Array();
   this.header_enu        = new Array();
   this.header_idx        = new Array();
   this.header_idc		  = new Array();
   this.detail_arr        = new Array();
   this.detail_idx        = new Array();
   this.inserted_id       = 1;
   this.status            = 0;
   this.bDebug            = false;
   this.bSQLDebug         = false;
   this.bDisable          = false;
   this.masterdb          = "dataset";
   this.detaildb          = "datadetail";

   this.dslengths         = {"ds_title":256
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
}

function UD_v(v_arr)
{
   var idx = this.map.length; 
   this.map[idx]   = v_arr[0]; // INDEX
   this.map[idx+1] = v_arr[1]; // VALUE
   this.output[this.map[idx]-1] = this.map[idx+1];
   if(this.bDebug)
      Response.Write("ASSIGN: ["+this.map[idx]+"] "+this.map[idx+1]+"<br>")
}

function UD_m(m_arr)
{
   var idx = this.map.length; 
   this.map[idx]   = m_arr[0];
   this.map[idx+1] = this.map_data[ this.map_enum[m_arr[1]] ];
   this.output[this.map[idx]-1] = this.map[idx+1];
   this.map_inv_enum[m_arr[0]] = m_arr[1];
   
   //Response.Write("this.map_inv_enum["+m_arr[0]+"] = "+m_arr[1]+"<br>")
   
   if(this.bDebug)
   {
      Response.Write("DATA: "+this.map_data+"<br>");
	  Response.Write("DATA-INDEX: this.map_enum["+m_arr[1]+"] = "+this.map_enum[m_arr[1]]+"<br>")
      Response.Write("MAPPING: ["+this.map[idx]+"] "+this.map[idx+1]+"<br>")
   }
}


function UD_init()
{
	// R E A D   M E T A   D A T A
	
	var datafld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_publisher","rev_pub"); 
	var dataset = _oDB.getrows("select "+datafld.join(",")+" from "+_db_prefix+"review where rev_id = "+this.ds);
	var enumdatafld = new Array();
	for (var jj=0; jj<datafld.length ; jj++)
		enumdatafld[datafld[jj]] = jj;
		
    if(dataset[enumdatafld["rev_publisher"]])
	{
	   var db = dataset[enumdatafld["rev_publisher"]].split(",");
	   this.masterdb = db[0];
	   this.detaildb = db[1];
	}

    if(!this.masterdb)
	   Response.Write("*PLEASE DEFINE oMapping.masterdb !*")

	// R E A D   X M L   H E A D E R S E T
	
	if(this.bDebug)
		Response.Write("DATA HEADERS:  XML<br>"+Server.HTMLEncode(dataset[enumdatafld["rev_header"]]).replace(/\r\n/g,"<br>")+"<br>");
	var XMLObj = loadXML(dataset[enumdatafld["rev_header"]]);
	var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
    this.header_idx.length = 0;
	for(var jj=0;jj<hfields.length;jj++)
	{
	    var idx = hfields.item(jj).text.substring(1,hfields.item(jj).text.length-1);
		var name = hfields.item(jj).getAttribute("name");
		
	    this.header_iar[ jj ] = idx;
		this.header_arr[ jj ] = name;
		this.header_enu[ name ] = jj;
        this.header_idx[ idx ] = name;
		this.header_idc[ idx ] = jj;
	}

	// R E A D   X M L   D E T A I L S E T

	if(this.bDebug)
		Response.Write("DATA DETAILS:  XML<br>"+Server.HTMLEncode(dataset[enumdatafld["rev_rev"]]).replace(/\r\n/g,"<br>")+"<br>");
	var XMLObj = loadXML(dataset[enumdatafld["rev_rev"]]);
	var dfields = XMLObj.getElementsByTagName("ROOT/row/field");
        
	this.detail_idx.length = 0;
	for(var jj=0;jj<dfields.length;jj++)
	{
	    this.detail_arr[jj*2] = dfields.item(jj).text.substring(1,dfields.item(jj).text.length-1)
		this.detail_arr[jj*2+1] = dfields.item(jj).getAttribute("name");
        this.detail_idx[ dfields.item(jj).text.substring(1,dfields.item(jj).text.length-1) ] = dfields.item(jj).getAttribute("name");
	}
}

function UD_delete_data()
{
      if(this.masterdb)
      {
         var dSQL = "delete from "+_app_db_prefix+this.masterdb+" where ds_rev_id = "+this.ds;
		 if(this.bSQLDebug) Response.Write(dSQL+(this.bDisable?"":" *DONE*")+"<br>");
         if(!this.bDisable) _oDB.exec(dSQL);
      }
      if(this.detaildb)
      {
         var dSQL = "delete from "+_app_db_prefix+this.detaildb+" where rd_ds_id = "+this.ds;
		 if(this.bSQLDebug) Response.Write(dSQL+(this.bDisable?"":" *DONE*")+"<br>");
         if(!this.bDisable) _oDB.exec(dSQL);
      }
}

function UD_insert_dataset()
{
   var field_arr = new Array();
   var value_arr = new Array();

   for(var jj=0;jj<this.map.length;jj+=2)
   {
      if(this.header_idx[this.map[jj]])
      {
		var fld = this.header_idx[this.map[jj]];
		var val = this.map[jj+1];
		
		var quot = (fld=="ds_num01" || fld=="ds_num02") ? "" : "\"";
		if((fld=="ds_datetime01" || fld=="ds_datetime01") && !val)
		{
		  val = "null";
		  quot = "";
		}
		
		if(typeof(val)=="number")  val = val.toString();
		
		if(typeof(val)=="string" && this.dslengths[fld])
		val = val.substring(0,this.dslengths[fld]);
		
		val = (val==null) ? "null" : (quot+(val?val.replace(/"/g,"\\\""):"")+quot);
		
		field_arr[field_arr.length] = fld;
		value_arr[value_arr.length] = val;
      }
   }

   var sSQL = "select max(ds_id) from usite_candidataset where ds_rev_id = "+this.ds;
   this.inserted_id = _oDB.get(sSQL);
   this.inserted_id = this.inserted_id?(Number(this.inserted_id)+1):1;

   var iSQL = "insert into usite_candidataset (ds_id,ds_rev_id,ds_pub,"+field_arr.join(",")+") value ("+this.inserted_id+","+this.ds+","+this.status+","+value_arr.join(",")+")";
   if(this.bSQLDebug) Response.Write(iSQL+(this.bDisable?"":" *DONE*")+"<br>");
   if(!this.bDisable) _oDB.exec(iSQL);
}

function UD_sync_init(keys)
{
  // BUILD KEY NAMES
   this.key = keys;
   var keynames = new Array();
   for(var jj=0;jj<this.key.length;jj++)
      keynames[keynames.length] = this.header_idx[this.key[jj]];

   var merge_key_idx = new Array();
   var sSQL = "select ds_pub,"+keynames.join("|")+" from usite_candidataset where ds_rev_id = "+this.ds;
   Response.Write(sSQL)
   var target = _oDB.getrows(sSQL);
    
   for(var jj=0;jj<target.length;jj+=(keynames.length+1))
   {
       Response.Write( "$$$$ "+(jj+1)+" "+(jj+keynames.length+1)+" $$$$" )
       this.key_sync[  target.slice(jj+1,jj+keynames.length+1).join(",") ] = target[jj];
	   if(this.bDebug)
	      Response.Write("this.key_sync["+target.slice(jj+1,jj+keynames.length+1).join(",")+"] = "+target[jj]+"<br>")
   }
}


function UD_sync_dataset()
{
   var field_arr = new Array();
   var value_arr = new Array();


   //Response.Write("***"+this.header_idx[2]+"***")

   for(var jj=0;jj<this.map.length;jj+=2)
   {
      if(this.header_idx[this.map[jj]])
      {
		var fld = this.header_idx[this.map[jj]];
		var val = this.map[jj+1];
		
		var quot = (fld=="ds_num01" || fld=="ds_num02") ? "" : "\"";
		if((fld=="ds_datetime01" || fld=="ds_datetime01") && !val)
		{
		val = "null";
		quot = "";
		}
		
		if(typeof(val)=="number")  val = val.toString();
		
		if(typeof(val)=="string" && this.dslengths[fld])
		val = val.substring(0,this.dslengths[fld]);
		
		val = (val==null) ? "null" : (quot+(val?val.replace(/"/g,"\\\""):"")+quot);
		
		field_arr[field_arr.length] = fld;
		value_arr[value_arr.length] = val;
      }
   }
   
   /*
   var sSQL = "select max(ds_id) from usite_candidataset where ds_rev_id = "+this.ds;
   this.inserted_id = _oDB.get(sSQL);
   this.inserted_id = this.inserted_id?(Number(this.inserted_id)+1):1;

   var iSQL = "insert into usite_candidataset (ds_id,ds_rev_id,ds_pub,"+field_arr.join(",")+") value ("+this.inserted_id+","+this.ds+","+this.status+","+value_arr.join(",")+")";
   if(this.bSQLDebug) Response.Write(iSQL+(this.bDisable?"":" *DONE*")+"<br>");
   if(!this.bDisable) _oDB.exec(iSQL);
   */
}

function UD_sync_datadetail(_id)
{
   var field_arr = new Array();
   var value_arr = new Array();
   for(var jj=0;jj<this.map.length;jj+=2)
   {
		var fld = this.header_idx[this.map[jj]];
		var val = this.map[jj+1];
		
		var quot = "\"";
		
		if(typeof(val)=="number")  val = val.toString();
		//if(typeof(val)=="object")  val = "2009-01-01 00:00:00"
		
		if(val!=null && val.length!=0)
		{
		 val = quot+(val?val.replace(/"/g,"\\\""):"")+quot;
		 var iSQL = "insert into usite_candidatadetail (rd_ds_id,rd_dt_id,rd_recno,rd_text) value ("+this.ds+","+this.map[jj]+","+_id+","+val+")";
			
		 if(this.bSQLDebug) Response.Write(iSQL+"<br>");
		 if(!this.bDisable) _oDB.exec(iSQL);
		}
   }
}

function UD_insert_datadetail(_id)
{
   var field_arr = new Array();
   var value_arr = new Array();
   for(var jj=0;jj<this.map.length;jj+=2)
   {
		var fld = this.header_idx[this.map[jj]];
		var val = this.map[jj+1];
		
		var quot = "\"";
		
		if(typeof(val)=="number")  val = val.toString();
		//if(typeof(val)=="object")  val = "2009-01-01 00:00:00"
		
		if(val!=null && val.length!=0)
		{
		 val = quot+(val?val.replace(/"/g,"\\\""):"")+quot;
		 var iSQL = "insert into usite_candidatadetail (rd_ds_id,rd_dt_id,rd_recno,rd_text) value ("+this.ds+","+this.map[jj]+","+_id+","+val+")";
			
		 if(this.bSQLDebug) Response.Write(iSQL+"<br>");
		 if(!this.bDisable) _oDB.exec(iSQL);
		}
   }
}

function UD_view_datadetail(_id)
{
   var field_arr = new Array();
   var value_arr = new Array();
   for(var jj=0;jj<this.map.length;jj+=2)
   {
		var fld = this.header_idx[this.map[jj]];
		var val = this.map[jj+1];
		
		var quot = "\"";
		if(typeof(val)=="number")  val = val.toString();
		if(typeof(val)=="object")  val = "2009-01-01 00:00:00";
		
		if(val!=null && val.length!=0)
		{
			val = quot+(val?val.replace(/"/g,"\\\""):"")+quot;
			var iSQL = "insert into usite_candidatadetail (rd_ds_id,rd_dt_id,rd_recno,rd_text) value ("+this.ds+","+this.map[jj]+","+_id+","+val+")";
			
			if(this.bSQLDebug) Response.Write(iSQL+"<br>");
			if(!this.bDisable) _oDB.exec(iSQL);
		}
   }
}


function UD_copy_create(_ds_to_copy)
{



}

function UD_select(_whereclause,_orderby)
{
   if(this.header_arr.length==0)
		this.init();
   var _sSQL = "select ds_id,"+this.header_arr+" from "+_app_db_prefix
   +this.masterdb+(_whereclause?(" where ds_rev_id = "+this.ds+" and "+_whereclause):" where ds_rev_id = "+this.ds)
   +(_orderby?(" "+_orderby):"");
   if(this.bSQLDebug) Response.Write(_sSQL+"<br>");
      
   return _sSQL;
}




///////////////////           T A B L E   F R O M   V D B           //////////////////////




function TABLE()
{
    this.mapping  = new Object();
    this.settings = new Object();

    this.data     = new Array();
    this.columns  = new Array();
	this.zebra    = new Array("tile","tile_pink")
	
    this.get      = TABLE_get;
    this.head     = "<table>";
    this.foot     = "</table>";
	this.colheaderclass = "tile";
    this.bVConfig    = true;  // USE VIRTUAL DATABASE CONFIGURATION
    this.bVSettings  = true;  // USE VIRTUAL DATABASE SETTINGS

    this.bSubmitted = false;
    this.f_columns = new Array();
    this.f_data    = new Array();
	
	this.formdata  = new Array();
	this.formdata_idx = new Array();
	this.formdata_eidx = new Array();
	this.formdata_rowid = new Array();
	this.diplay_colheader = true;
}




function argsplitter(_str)
{
    if(_str && _str.indexOf("(")>0 && _str.indexOf(")")>0)
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
	else
	{
		return new Array(_str)
	}
}



function TABLE_get()
{

   // INDEX SETTINGS

   var LIST_PROPERTIES_IDX = new Array();
   for(var _x=0 ; _x<this.settings.settingdata["LIST_PROPERTIES"].length ; _x+=this.settings.paramtablefld.length)
   {
      var idx = this.settings.settingdata["LIST_PROPERTIES"][_x+1];
      idx = idx.substring(1,idx.length-1);
      LIST_PROPERTIES_IDX[idx] = _x;
   }

   // GENEREATE COLUMN HEADERS ( + COLUMN COUNT )





   for(var _x=0;_x < this.columns.length;_x++)
   {
     var set_idx = LIST_PROPERTIES_IDX[this.columns[_x]];
     if(this.bVConfig==false || this.settings.settingdata["LIST_PROPERTIES"][set_idx+3])
     {
         if(this.bVSettings)
         {
            var _l = this.f_columns.length;

            //this.f_columns[_l] = this.mapping.header_arr[_x];
            if(this.bVConfig)
               this.f_columns[_l] = this.mapping.detail_idx[this.mapping.header_iar[_x-1]];
            if(this.bVSettings && this.settings.settingdata["LIST_PROPERTIES"][set_idx+2])
               this.f_columns[_l] = this.settings.settingdata["LIST_PROPERTIES"][set_idx+2];
         }
         else
            this.f_columns[this.f_columns.length] = this.columns[_x];
     }
   }
   var colheader = this.diplay_colheader?("<tr><td class="+this.colheaderclass+">"+ this.f_columns.join("</td><td class="+this.colheaderclass+">")+"</td></tr>\r\n"):"";





//Response.Write(this.data.join("<br>")+"<br>")

  // PROCESS TABLE BODY

   var _xi = 0;
   var colid = 0;
   for(var _x=0;_x<this.data.length;_x++)
   {
      var colnr = _x%this.columns.length;
      var col_idx = this.columns[colnr];
      var set_idx = LIST_PROPERTIES_IDX[col_idx];
	  var lp = this.settings.settingdata["LIST_PROPERTIES"]; 
	  var col_name = lp[set_idx+2];
      var col_type = lp[set_idx+3];
      var col_format = lp[set_idx+4];
	  var col_attr = lp[set_idx+5];
	  if(colnr==0)
	     colid = this.data[_x];
	    

      if(this.bVConfig==false || col_name)
      {
         this.f_data[_xi] = this.data[_x];
		 
		 
         switch(col_type)
         {		 
		    case "number":
			    if(col_format)
				{	
					var args = argsplitter(col_format);
					var format = args[0];
					switch(format)
					{
						case "check":
						var arg  = argparser(args[1]);
						
						//check("opt=opm_can%2Copm_kl%2CCV%2Clink,ico=can_fb")
						
						var opt = arg["opt"]?arg["opt"].split("%2C"):new Array();
						
						var str = "";
						if(arg["ico"])
						{
							for(var jj=0;jj<opt.length;jj++)
							   if(Number(this.f_data[_xi]) & (1<<jj))
							   {
								  cstr = "<img src=../"+_ws+"/images/"+arg["ico"]+"_"+zerofill(jj+1,6)+".gif title=\""+opt[jj]+"\" border=0> ";
								  if(arg["p"])
								     cstr = "<a href=index.asp?p="+arg["p"]+"&s="+Request.QueryString("s").Item+"&i="+Request.QueryString("i").Item+"&rid="+colid+"&fid="+(opt[jj]?opt[jj].substring(1,opt[jj].length-1):"")+" target=_blank>"+cstr+"</a>"
								  str += cstr;
							   }
						}
						else
						{
							for(var jj=0;jj<opt.length;jj++)
							   if(Number(this.f_data[_xi]) & (1<<jj))
								  str += opt[jj]+" ";
						}
						  
						this.f_data[_xi] = str;
						break;	
					}
					
				}
			    _xi++;
			break;
            case "string":
			    if(col_format)
				{
					var args = argsplitter(col_format);
					var format = args[0];
					
					switch(format)
					{
						case "textarea":
						   var arg  = argparser(args[1]);
						   if(arg["edit"])
						   {
						        var fname = "f"+zerofill(colid,6)+"_"+zerofill(col_idx,6);
						        var fv = Request.Form(fname).Item;
								this.bSubmitted = Request.Form("act").Item?true:false;
						   
						        var val = this.bSubmitted?fv:this.f_data[_xi]
								this.f_data[_xi] = "<textarea name="+fname+" "+col_attr+">"+val+"</textarea>"
								   + "<input type=submit name=act value=bewaren>";
								   
								var fv = Request.Form(fname).Item;
								this.formdata[this.formdata.length] = fv;
								this.formdata_rowid[this.formdata_rowid.length] = colid;
								if(!this.formdata_eidx[col_idx])
								{
								   this.formdata_eidx[col_idx] = this.formdata_idx.length+1;
								   this.formdata_idx[this.formdata_idx.length] = col_idx;
								}
						   }
						   else
						      this.f_data[_xi] = this.f_data[_xi].replace(/\r\n/g,"<br>"); 
						break;
					}
				}
			    _xi++;
            break;
            case "date":
                this.f_data[_xi] = (new Date(this.f_data[_xi])).format(col_format);
				_xi++;
            break;
            case "file":
                if(this.f_data[_xi])
                    this.f_data[_xi] = "<a href=\"../"+_ws+"/res/"+this.f_data[_xi]+"?"+(Math.floor(Math.random()*10000))+"\" target=_blank><img src=../images/full_green.gif border=0></a>";
                else
                    this.f_data[_xi] = "<center>-</center>"
				_xi++;
            break;
			case "ref":
			   	if(col_format)
				{
					var args = argsplitter(col_format);
					var format = args[0];
					
					switch(format)
					{
						case "refexe":
						   var arg  = argparser(args[1]);

						   
						   if(typeof(scriptbuf)=="undefined" && arg["scriptid"])
						      var scriptbuf = _oDB.get("select rev_rev from usite_review where rev_pub & 1 = 1 and rev_id = "+arg["scriptid"].decrypt("nicnac")+" limit 0,1")
						
						   eval(scriptbuf);
						   this.f_data[_xi] = retval;
						   
						break;
					}
					_xi++;
				}
			break;
         }
         
      }
   }
  

   

   // GENERATE TABLE BODY

   var _row = new Array();
   var _z = 0;
   for(var _x=0;_x<this.f_data.length;_x+=this.f_columns.length)
   {
      var bAlt = (_x/this.f_columns.length)%2
      _row[_z++] = "<td class="+(bAlt?this.zebra[0]:this.zebra[1])+">"+this.f_data.slice(_x,_x+this.f_columns.length).join("</td><td class="+(bAlt?this.zebra[0]:this.zebra[1])+">")+"</td>"
   }
   return this.head+colheader+"<TR>"+_row.join("</TR><TR>")+"</TR>"+this.foot
}







function utf16to8(str) {
    var out, i, len, c;

    out = "";
    len = str.length;
    for(i = 0; i < len; i++) {
	c = str.charCodeAt(i);
	if ((c >= 0x0001) && (c <= 0x007F)) {
	    out += str.charAt(i);
	} else if (c > 0x07FF) {
	    out += String.fromCharCode(0xE0 | ((c >> 12) & 0x0F));
	    out += String.fromCharCode(0x80 | ((c >>  6) & 0x3F));
	    out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
	} else {
	    out += String.fromCharCode(0xC0 | ((c >>  6) & 0x1F));
	    out += String.fromCharCode(0x80 | ((c >>  0) & 0x3F));
	}
    }
    return out;
}

function utf8to16(str) {
    var out, i, len, c;
    var char2, char3;

    out = "";
    len = str.length;
    i = 0;
    while(i < len) {
	c = str.charCodeAt(i++);
	switch(c >> 4)
	{ 
	  case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
	    // 0xxxxxxx
	    out += str.charAt(i-1);
	    break;
	  case 12: case 13:
	    // 110x xxxx   10xx xxxx
	    char2 = str.charCodeAt(i++);
	    out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
	    break;
	  case 14:
	    // 1110 xxxx  10xx xxxx  10xx xxxx
	    char2 = str.charCodeAt(i++);
	    char3 = str.charCodeAt(i++);
	    out += String.fromCharCode(((c & 0x0F) << 12) |
					   ((char2 & 0x3F) << 6) |
					   ((char3 & 0x3F) << 0));
	    break;
	}
    }

    return out;
}





%>
