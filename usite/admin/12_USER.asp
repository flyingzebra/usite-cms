<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<!--#INCLUDE FILE = "../includes/GUI.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var bDebug = false;
	function debug(_dstr)
	{
		if (bDebug)
		{
			Response.Write(_dstr+"\r\n<br>");
			Response.Flush();
		}
	}

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));

	if (oDB.loginValid()==false)
		Response.Redirect("index.asp");
	
	var acc_type = 13;
	var imgpath = "../images/promo/"
	var perm_languages = oDB.getSetting(zerofill(acc_type,2)+"_L");
		
	var imglen = 1;
	var bUpload = false;
	var bSaved  = false;

	var id = Request.QueryString("id").Item?Number(Request.QueryString("id").Item.toString().decrypt("nicnac")):0;

	// NO URL PARAMETER ID ?  TRY TO GET IT FROM FORM DATA
	if(id==0)
		var id = Request.Form("id").Item?Number(Request.Form("id").Item):0;
	
	var refid = id;
	var sSQL = "SELECT acc_id from "+_db_prefix+"acc where acc_id="+id;
	debug(sSQL);
	var bExists = Number( oDB.get(sSQL) )==Number(id);
	var now = new Date(oDB.get("SELECT UNIX_TIMESTAMP()")*1000);
	

	var ctxtwidth = 26;
	var ctxawidth = 23;
	var ctxaheight = 10;

	var oGUI		= new GUI();
	var oButton		= new oGUI.BUTTON();

var tablefld = new Array(
  "acc_id",
  "acc_pir_id",
  "acc_name",
  "acc_psw",
  "acc_gender",
  "acc_firstname",
  "acc_lastname",
  "acc_alias",
  "acc_lng_code",
  "acc_company",
  "acc_vat",
  "acc_tel",
  "acc_fax",
  "acc_email",
  "acc_url",
  "acc_address", 
  "acc_city",
  "acc_zip",
  "acc_country", 
  "acc_expire_date",
  "acc_remarks" 
 );

var formfld = new Array( 
  "id",
  "code",
  "login",
  "password",
  "gender",
  "firstname",
  "lastname",
  "alias",
  "language",
  "company",
  "vat",
  "tel",
  "fax",
  "email",
  "url",
  "address", 
  "city",
  "zip",
  "country", 
  "expire_date", 
  "remarks",
  "act"
   );


	


	var enumfld = new Array();
 	for (var i=0; i<formfld.length ; i++)
		enumfld[formfld[i]] = i;



	
	///////////////////////////////////////////////
	//  S A V E   U P L O A D E D   I M A G E S  //
	///////////////////////////////////////////////

	//try { var Upload = Server.CreateObject("Persits.Upload.1");  var FormCollection = Upload.Form; bUpload = true; } catch(e) {}
	//try { var Count = Upload.Save(Server.Mappath ("../images/upload")); bSave = true; } catch(e) {}

	/////////////////////////////////////////////////////////////
	//  C O L L E C T   M U L T I P A R T   F O R M - D A T A  //
	/////////////////////////////////////////////////////////////

	//var bMultipart = skin_mode==0?false:true;
	var bMultipart = false;

	var bSubmitted = false;
	if (bUpload==true)
		bSubmitted = bMultipart?(!new Enumerator(FormCollection).atEnd()):(Request.TotalBytes==0?false:true);
	else
		bSubmitted = Request.TotalBytes==0?false:true;

	var formarr = new Array();
	formarr[0] = id;

	if (!bSubmitted)
	{
		var sSQL = "SELECT "+tablefld.join(",")+" from "+_db_prefix+"acc where acc_id="+id
		if(bDebug)
		{
			Response.Write(sSQL);
			Response.Flush();
		}
		formarr = oDB.getrows(sSQL);
	}
	else
	{
		if(bMultipart==true)
		{
			for (var objEnum=new Enumerator(FormCollection); !objEnum.atEnd() ; objEnum.moveNext())
			{
				var idx = enumfld[objEnum.item().name];
				formarr[idx] = objEnum.item().value; //? ("\""+Server.HTMLEncode(objEnum.item().value.replace(/\x22/g,"\\\""))+"\""):"\"\""
			}
		}
		else
		{
			var formarr = new Array();
			for (var i=0;i<formfld.length;i++)
				formarr[i] = Request.Form(formfld[i]).Item;
		}

	}	


	///////////////////////////////////////////
	// E X T R A   I N I T I A L I S E R S   //
	///////////////////////////////////////////



	
if (formarr[enumfld["act"]]=="piron lookup >>>")
{
	// SEARCH ID FROM PIRON
	var id_arr = oDB.getrows("select pir_id from piron where pir_lastname = \""+formarr[enumfld["lastname"]]+"\" and pir_firstname = \""+formarr[enumfld["firstname"]]+"\"");
	if(id_arr && id_arr.length==1)
		formarr[enumfld["code"]] = id_arr;
}

	

function textfield(name,args,extra)
{
	if(!args)
		var args = ["","size=40"];
	var textfield_data = (formarr[enumfld[name]] && typeof(formarr[enumfld[name]])!="undefined")?formarr[enumfld[name]]:"";
	textfield_data = Server.HTMLEncode(textfield_data);
	return "<td"+(typeof(args)!="undefined"?(" "+args[0]):"")+">"+ HTMLfldname[enumfld[name]] +"</td>"
	     + "<td><input name="+name+" type=text value=\""+textfield_data+"\""+(typeof(args)!="undefined"?(" "+args[1]):"")+">"+(extra?extra:"")+"</td>";
}

function checkbox(name,args)
{
	var checkfield_data = (formarr[enumfld[name]] && typeof(formarr[enumfld[name]])!="undefined")?formarr[enumfld[name]]:"";
	return "<td>"+ HTMLfldname[enumfld[name]] +"</td><td><input name="+name+" type=checkbox value=1 "+(checkfield_data=="1"?"CHECKED":"")+" "+(typeof(args)!="undefined"?(" "+args):"")+"></td>"
}

function datefield(name,args,extra)
{
	if(!args)
		var args = ["","size=11"];

  var datefield_data = typeof(formarr[enumfld[name]])=="date"?new Date(formarr[enumfld[name]]).format("%Y-%m-%d"):formarr[enumfld[name]];
  if (datefield_data==null)
	datefield_data = "";
  var fld = "<input type=text name="+name+" value=\""+datefield_data+"\""+(typeof(args[1])!="undefined"?(" "+args[1]):"")+">";

  return "<td"+(typeof(args)!="undefined"?(" "+args[0]):"")+">"+HTMLfldname[enumfld[name]]+"</td><td>"+fld+(extra?extra:"")+"</td>";
}

function datefield_hidden(name,args)
{
  var fld = "<input type=hidden name="+name+" value=\""+(typeof(formarr[enumfld[name]])=="date"?new Date(formarr[enumfld[name]]).format("%Y-%m-%d %H:%M:%S"):formarr[enumfld[name]])+"\""+(typeof(args)!="undefined"?(" "+args):"")+">"
  return fld;
}

var HTMLfldname = new Array( 
 "id",
  "code",
  "login",
  "password",
  "gender",
  "firstname",
  "lastname",
  "alias",
  "language",
  "company",
  "VAT number",
  "phone",
  "fax",
  "e-mail",
  "url",
  "address & nr, box", 
  "city",
  "zip",
  "country", 
  "expire_date", 
  "remarks" );




 


	///////////////////////////////
	//  S E C U R I T Y  //
	///////////////////////////////

	//if ((oDB.get("SELECT acc_pub from "+_db_prefix+"acc where acc_id="+id) & 4) == 4)
	//{
	//	Response.Clear();
	//	Response.Write("<script>window.close()</script>");
	//	Response.End();
	//}

	/////////////////////////////////////////////
	//  R E S I Z E   I M A G E S  //
	/////////////////////////////////////////////

	var dbnamearr = ["acc_img1","acc_img2"]
	var resizearr = [100,100];

	if (bUpload)
	{
		var FileCollection = Upload.Files;

		var i = 0;

		for (var objEnum=new Enumerator(FileCollection); !objEnum.atEnd() ; objEnum.moveNext())
		{
			var obj = objEnum.item();

			if (obj.path.substring(obj.path.length-4,obj.path.length)==".jpg")
			{
				var imgnr = Number(obj.name.substring(4,6));
				var iactimg = enumfld["actimg"];
				formarr[iactimg] = formarr[iactimg] ? (formarr[iactimg] | Math.pow(2,imgnr-1)) : Math.pow(2,imgnr-1);
				var jpeg = Server.CreateObject("Persits.Jpeg");
				jpeg.open( obj.path );

				resizeto(jpeg,resizearr[imgnr-1],true);
				jpeg.Save(Server.MapPath(imgpath) + "\\img"+zerofill(refid,10)+"_"+imgnr+".jpg");

				jpeg.open( obj.path );
				resizeto(jpeg,50,true);
				jpeg.Save(Server.MapPath(imgpath) + "\\img"+zerofill(refid,10)+"_t50_"+imgnr+".jpg");
			}
			i++;
		}		
	}
	
	
	function resizeto(picobj,size,bsquare)
	{		
		if (bsquare)
			maxheight = size
		else
			maxheight = 550;

		if (  (picobj.height*size/picobj.width) > maxheight && !bsquare )
		{
		    picobj.width  *= maxheight/picobj.height;
			picobj.height = maxheight;
			
		}
		else
		{
			picobj.height *= size/picobj.width;
			picobj.width  = size;
			
			if (picobj.height>maxheight && bsquare==true)
			{
				var yoffset = (picobj.height-size)/2;
				picobj.Crop(0, yoffset, size, maxheight+yoffset);
			}			
		}
	}
	
	
	
	///////////////////////////////////////
	//  D A T A B A S E   S T O R A G E  //
	///////////////////////////////////////

	if (bSubmitted && bExists==true)
	{
		formarr[enumfld["mod_acc"]] = Session("uid");
		formarr[enumfld["mod_date"]] = now.format("%Y-%m-%d %H:%M:%S");
		date_published = formarr[enumfld["date_published"]];	//  backup of Date object
		if (formarr[enumfld["date_published"]])
			formarr[enumfld["date_published"]] = new Date(formarr[enumfld["date_published"]]).format("%Y-%m-%d %H:%M:%S");
		else
			formarr[enumfld["date_published"]] = "";
	}
	else if(bSubmitted && bExists==false)
	{
		formarr[enumfld["pir_id"]] = null;
		formarr[enumfld["id"]] = Number(oDB.takeanumber(_app_db_prefix+"acc"));
	}
	

	var botharr = new Array();
	for (var i=1;i<tablefld.length;i++)
		botharr[i-1] = tablefld[i] + "=\"" + (typeof(formarr[i])=="string"?formarr[i].replace(/\x22/g,"\\\""):formarr[i]) + "\"" 

	var singlearr = new Array();
	for (var i=0;i<tablefld.length;i++)
		singlearr[i] = (typeof(formarr[i])=="string"?("\""+formarr[i].replace(/\x22/g,"\\\"")+"\""):formarr[i]);

	if (bSubmitted)
	{

		if (bExists==true)
		{
			formarr[enumfld["mod_date"]] = now.format("%Y-%m-%d %H:%M:%S");
		
			var SQL = "update "+_db_prefix+"acc  set " + botharr.join(",") + " where acc_id="+id
			if(bDebug)
				Response.Write("<br>"+SQL+"<br>")
			
			try { oDB.exec(SQL) }
			catch(e)
			{ Response.Write("<!--"+SQL+"-->\r\n")}
			
			if (id != refid)		// UPDATE IMG MAP FROM REFERENCE ID
			{
				var SQL = "update "+_db_prefix+"acc  set " + botharr[enumfld["actimg"]-1] + " where acc_id="+refid;
				if(bDebug)
					Response.Write("<br>"+SQL+"<br>")				
				try { oDB.exec(SQL) }
				catch (e)
				{ Response.Write("<!--"+SQL+"-->\r\n") }

			}
			Response.Write("<script>parent.frames['view'].location.reload()</script>");	
		}
		else
		{			
			var SQL = "insert into "+_db_prefix+"acc ("+tablefld.join(",")+") values ("+singlearr.join(",")+")"	
			if(bDebug)
				Response.Write("<br>"+SQL+"<br>")
			try { oDB.exec(SQL) }
			catch (e)
			{ Response.Write("<!--"+SQL+"-->\r\n") }
			
			var s_val = new Array();
			s_val[0] = oDB.takeanumber(_db_prefix+"settings");
			s_val[1] = formarr[enumfld["id"]];
			s_val[2] = "\"PERM\"";
			s_val[3] = "\"14_admin\"";
			insert_proc(s_val);
			
			s_val[0] = oDB.takeanumber(_db_prefix+"settings");
			s_val[3] = "\"15_admin\"";
			insert_proc(s_val);

			s_val[0] = oDB.takeanumber(_db_prefix+"settings");
			s_val[3] = "\"16_admin\"";
			insert_proc(s_val);
			
			s_val[0] = oDB.takeanumber(_db_prefix+"settings");
			s_val[2] = "\"SITE\"";
			s_val[3] = "\"%\"";
			insert_proc(s_val);
			
			Response.Write("<script>parent.frames['view'].location.reload()</script>");	
		}
	}

	function insert_proc(s_val)
	{
			var SQL = "insert into "+_db_prefix+"settings (s_id,s_acc_id,s_name,s_value) values ("+s_val.join(",")+")"	
			if(bDebug)
				Response.Write("<br>"+SQL+"<br>")
			try { oDB.exec(SQL) }
			catch (e)
			{ Response.Write("<!--"+SQL+"-->\r\n") }
	}


	if (bSubmitted && bExists==true)
	{
		formarr[enumfld["date_published"]] = date_published; // retrieve Date object
	}
	
	
	if (formarr[enumfld["act"]]=="save")
	{
		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");
	}
	// UPDATE OTHER ITEMS
		//oDB.exec("UPDATE revgallery SET acc_alias='"+myname+"',acc_url='"+mywebsite+"',acc_email='"+myemail+"',acc_txt='"+mytext+"' WHERE acc_id="+id);




	var formHTML = new Array( 
	 "<input name=id type=hidden value=\""+(formarr[enumfld["id"]]?formarr[enumfld["id"]]:"")+"\">",
	  textfield("firstname"),
	  textfield("lastname"),
	  textfield("alias"),
	  textfield("gender"),
	  textfield("code",["style=font-weight:bold","size=11"],"<input type=submit name=act value=\"piron lookup >>>\" align=right style=width:150px>"),
	  textfield("login"),
	  textfield("password"),
	  textfield("language"),
	  textfield("company"),
	  textfield("vat"),
	  textfield("tel"),
	  textfield("fax"),
	  textfield("email"),
	  textfield("url"),
	  textfield("address"),  
	  textfield("city"),
	  textfield("zip"),
	  textfield("country"), 
	  datefield("expire_date",["style=font-weight:bold","size=11"],"<input type=submit name=act value=\"payments lookup >>>\" align=right style=width:150px>"), 
	  textfield("remarks") );
%>

<style>
	.qtable { background-color: #DCDCDC; font-family: Verdana; font-size: 11px;}
	.qtable td{ background-color:white;padding-left: 2px;padding-right: 2px;padding-top: 2px;padding-bottom: 2px;white-space: nowrap;}
	.gtable { background-color: #DCDCDC; font-family: Verdana; font-size: 11px;}
	.gtable td{ background-color: #DCDCDC; font-family: Verdana; font-size: 11px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
</style>

<form method="post" name="main" <%=bMultipart==true?"ENCTYPE=\"multipart/form-data\"":""%>>

<table>
<tr>
	<td valign=top>
	    
		<%=box_on()%>
		<table cellspacing="1" cellpadding="5" bgcolor="black">
		<tr>
			<td bgcolor="#DCDCDC">
				<table cellspacing="0" cellpadding="2" class=gtable>
				<tr>
				<%=formHTML.join("</tr>\r\n<tr>")%>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		<%=box_off()%>
		<%
		var commands = "&nbsp;<input type=\"button\" src=../images/i_cancel.gif name=\"act\" value=\"close\" onclick='top.close()'>";
		commands += "&nbsp;&nbsp;&nbsp;&nbsp;";
		commands += "&nbsp;<input type=\"submit\" src=../images/i_save.gif name=\"act\" value=\"save\">";
		%>
		<br>
		<%=commands%>
	</td>
		<%rightpane()%>
</tr>
</table>

</form>

<br>
<a NAME="down"></a>



<script>
function gorefresh()
{
	/*
	setTimeout("gorefresh()",5000);
	
	var plaintxt = stripHtml(main.header.value);	// remove HTML
	plaintxt = plaintxt.replace(/\s+/g,"");			// remove spaces and non-printable chars
	headerlength.innerHTML  = plaintxt.length;	
	
	var plaintxt = stripHtml(main.rev.value);		// remove HTML
	plaintxt = plaintxt.replace(/\s+/g,"");			// remove spaces and non-printable chars
	textlength.innerHTML  = plaintxt.length;
	*/
}
window.onload=gorefresh;

function copy_images()
{
		var answer = confirm ("Copy all images from master document ?");
		if (answer)
			alert("TODO");
		return;
}
</script>

<%


function stripHtml(strHTML) 
{
	// Replace all newLinet with .$!$. string
	strOutput = strHTML
	//strOutput = strHTML.replace(/\n/g, ".$!$.")
	
	// Replace all <script>s with an empty string
	aScript=strOutput.split(/\/script>/i);
	for(i=0;i<aScript.length;i++)
		aScript[i]=aScript[i].replace(/\<script.+/i,"");
	strOutput=aScript.join('');
	// Replace all HTML tag matches with the empty string
	strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
	// Remove empty lines
	//strOutput = strOutput.replace(/\.\$\!\$\.\r\s*/g,"")
	// Replace all .$!$. with the empty string
	//strOutput = strOutput.replace(/\.\$\!\$\./g,"")
	// Remove empty lines
	//strOutput = strOutput.replace(/\r\ \r/g,"")
	//alert(strOutput)
	return strOutput;
}

	function editor()
	{
%>
<script language="Javascript1.2" src="../includes/editor.js"></script>
<script>
	_editor_url = "../includes/";
</script>




<br>





<script language="javascript1.2">
editor_generate('rev'); // field, width, height
</script>


<%
}

if(typeof(formarr[enumfld["expire_date"]])=="string")
	formarr[enumfld["expire_date"]] = new Date(formarr[enumfld["expire_date"]].toDate("%Y-%m-%d"));





////////////////////////////////////////////////////////////
///////                                              ///////
///////    D E D I C A T E D   C O D E               ///////
///////                                              ///////
////////////////////////////////////////////////////////////


function rightpane()
{

}


%>

