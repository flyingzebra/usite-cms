<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var bDebug		 = false; 

	var ds_type      = 23;
	var masterdb     = "dataset";
	var detaildb     = "datadetail";
	var settingspage = 22;
	var defaultstep  = 50;
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
	var overridesubj = Request.QueryString("overridesubj").Item;
	var overrideto = Request.QueryString("overrideto").Item;
	var overridesender = Request.QueryString("overridesender").Item;
	var subject = Request.QueryString("subject").Item;
	var sender = Request.QueryString("sender").Item;
	var ses = Request.QueryString("ses").Item?Request.QueryString("ses").Item:Math.round(Math.random()*999999);
	var body = Request.Form("body").Item;
	var overridebody = Request.QueryString("overridebody").Item;
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

	function ReadFile(filename)
	{
		var ForReading = 1;
		fileobj = FSO.OpenTextFile(filename, ForReading, false);
		var txt = fileobj.ReadAll();
		fileobj.Close();
		return txt;
	}

	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
			
	var deftablefld = new Array("rev_url","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;
	
	var sSQL = "select "+deftablefld.join(",")+" from "+_db_prefix+"review where rev_id = "+id;
	var tabledefs = oDB.getrows(sSQL);

	if(bDebug)
		Response.Write("<br>"+sSQL+"<br><br>")

	
	//Response.Write(tabledefs)

	// R E A D   X M L   D A T A S E T
	
	var XMLObj = loadXML(tabledefs[defenumfld["rev_rev"]]);
	var fields = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumdataset = new Array();
	for(var i=0;i<fields.length;i++)
		enumdataset[ fields.item(i).text ] = fields.item(i).getAttribute("name");

	// R E A D   X M L   H E A D E R S E T	

	var XMLObj = loadXML(tabledefs[defenumfld["rev_header"]]);
	var hfields = XMLObj.getElementsByTagName("ROOT/row/field");
	var enumcolnames = new Array()  
	for(var i=0;i<hfields.length;i++)
		enumcolnames[ enumdataset[hfields.item(i).text] ] = hfields.item(i).getAttribute("name");

	var emailto = "";
	for(var i=0;i<hfields.length;i++)
		if(!emailto && enumdataset[hfields.item(i).text].indexOf("email")>=0)
			emailto = enumdataset[hfields.item(i).text];

	if(bDebug)
		Response.Write("E-mail address column selected: "+emailto)
	

	////////////////////////////////
	// ESTIMATE NUMBER OF RECORDS //
	////////////////////////////////

	if(typeof(whereclause)!="string")
		var whereclause = "";
	

	if(Request.QueryString("overrideto").Item=="manual")
	{
		// ESTIMATE RECORD LENGTH FROM SESSION VARIABLE
		
		Session(_pagename+ses+"_1")=Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").replace(/<br>/g,","):"";
		
		var overview = Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1").split(","):new Array();
		var overviewlength = overview.length;
		
	}
	else
	{
		// ESTIMATE RECORD LENGTH FROM DATABASE
		
		
		if(enumcolnames[emailto])
			whereclause += " and "+enumcolnames[emailto]+" LIKE '%@%.%' "
			
		if(overrideto=="distinct")	
			var lSQL = "select count(distinct "+enumcolnames[emailto]+") from "+_db_prefix+masterdb+" where ds_rev_id = "+id+" and (ds_pub & 1) = 1 "+whereclause;
		else
			var lSQL = "select count(*) from "+_db_prefix+masterdb+" where ds_rev_id = "+id+" and (ds_pub & 1) = 1 "+whereclause;
		
		var overviewlength = oDB.get(lSQL);
		
		if(bDebug)
			Response.Write("<br>"+lSQL+"<br><br>");
	}
	
	if(bDebug)
		Response.Write("MAILING LIST : "+overviewlength+" items")
	
	
	var todo = overviewlength-(sq+step);
	

	if(act && (todo>=0 || sq==0))
	{
		var url = Request.QueryString().Item;
		url = url.substring(0,url.indexOf("&sq=")>=0?url.indexOf("&sq="):url.length)+"&sq="+Number(sq+step)
		
		// D A T A   P R O C E S S I N G
		
		var c_from = enumcolnames["from"] && !from?enumcolnames["from"]:from
		var c_sender = enumcolnames["sender"] && (!overridesender || !sender)?enumcolnames["sender"]:sender
		var c_emailto = enumcolnames[emailto] && (overrideto!="override" || !to)?enumcolnames[emailto]:to
		var c_subject = enumcolnames["subject"] && (!overridesubj || !subject)?enumcolnames["subject"]:subject
		//if(enumcolnames["body"])
		
		enumcolnames["body"] = enumcolnames["body"]?enumcolnames["body"]:"";
		
		var c_body = enumcolnames["body"] && !overridebody || !Session(_pagename+ses)?enumcolnames["body"].replace(/"/g,"\\\""):(Session(_pagename+ses).replace(/"/g,"\\\""))
		//else
		//	var c_body = "\"[empty]\"";
		
		var c_attachments = Session(_pagename+ses+"_2");
		var c_embedded_img = Session(_pagename+ses+"_3");
		
		// D A T A S E T   Q U E R Y
		var colarr = new Array(
			 quote(c_from)
			,overridesender?quote(c_sender):(c_sender?c_sender:"''")
			,(c_emailto?c_emailto:"''")
			,overridesubj?quote(c_subject):(c_subject?c_subject:"''")
			,overridebody?quote(c_body):(c_body?c_body:"''")
			,quote(c_attachments)
			//,quote(c_embedded_img)
			)
		
		if(Request.QueryString("overrideto").Item=="manual")
		{
			var arr = new Array();
			for(var j=sq*colarr.length;j<(sq+step)*colarr.length;j+=colarr.length)
			{
				arr[j]    = c_from;
				arr[j+1]  = c_sender;
				arr[j+2]  = overview[j/colarr.length];
				arr[j+3]  = c_subject;
				arr[j+4]  = c_body;
				arr[j+5]  = c_attachments;
				//arr[j+6]  = c_embedded_img;
			}
		}
		else
		{
			var lSQL = "select "+colarr.join(",")+" from "+_db_prefix+masterdb+" where ds_rev_id = "+id+" and (ds_pub & 1) = 1 "+whereclause+(overrideto=="distinct"?(" group by "+enumcolnames[emailto]):"")+" order by ds_id LIMIT "+sq+","+step;		
			var arr = oDB.getrows(lSQL);
			
			
			if(bDebug)
				Response.Write(lSQL+" #1<br><br>")
		}
		
		if(act.indexOf("send to")==0)
			Response.Write("<a href=?"+url+">TODO ("+Math.round(100*(todo+step)/overviewlength)+"%)</a>\r\n<br><br>");
		
		
		if(act=="simulation" || act=="set body text" || act=="set list" || act=="set attachments")
		{
			if(act=="simulation")
				for(var j=0;j<arr.length;j+=colarr.length)
				{
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td align=right width=50>from:</td><td>"+(arr[j+1]?(arr[j+1]+" &lt;"+arr[j]+"&gt;"):arr[j])+"</td></tr>");
					Response.Write("<tr><td align=right width=50>to:</td><td>"+arr[j+2]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>subject:</td><td>"+arr[j+3]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>attachments:</td><td>"+arr[j+5]+"</td></tr>");
					Response.Write("</table><hr>");
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td colspan=2 style=font-weight:bold>"+arr[j+4]+"</td></tr>");
					Response.Write("</table><hr>");
				}
				
			if(act=="set body text")
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
			for(var j=0;j<arr.length;j+=6)
			{
			
				if(isValidEmail(arr[j+2])==true)
				{
					// MAIL SENDER
					
					var Mail = Server.CreateObject("Persits.Mailsender");
					Mail.Host     	= "blackbaby.org";
					Mail.LogonUser ("blackbaby.org", "MXadmin", "xxlmxadmin");
					Mail.From 	  	= arr[j];
					Mail.FromName   = arr[j+1]?arr[j+1]:arr[j];
					Mail.Subject 	= arr[j+3];
					Mail.Body 		= arr[j+4];//.replace(/<br>/gi,"\r\n");
					Mail.IsHTML		= true;
					Mail.AddAddress(arr[j+2]);
					Mail.Queue 		= true;

/*
					Response.Write("Host = "+Mail.Host+"<br>");
					Response.Write("Port = "+Mail.Port+"<br>");
					Response.Write("Username = "+Mail.Username+"<br>");
					Response.Write("Password = "+Mail.Password+"<br>");
					Response.Write("From = "+Mail.From+"<br>");
					Response.Write("FromName = "+Mail.FromName+"<br>");
					Response.Write("Subject = "+Mail.Subject+"<br>");
*/
					var FSO = Server.CreateObject("Scripting.FileSystemObject");
					
					//Mail.AddAttachment(arr[j+5])
					//Mail.AddAttachmentMem("test.jpg",Readfile(arr[j+5]))
					
					if(arr[j+5])
					{
						var arratt = arr[j+5].split(",");
						for(var k=0;k<arratt.length;k++)
						{
							Response.Write(arratt[k]+"<br>");
							Response.Flush();
							Response.Write(FSO.FileExists(arratt[k])+"<br>");
							Response.Flush()
							Mail.AddAttachment(arratt[k]);
							
						}
					}
					
					//Response.End();   ///////////////////// REMOVE THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!
					
					
					try { Mail.Send() }
					catch (e)
					{
						var returnpage = "index.asp";
						Response.Write("<BR><BR><CENTER>Mail sender failed,<BR><BR> " + (e.number & 0xFFFF).toString(16) + " " + e.description + "<BR><BR> please contact <a href=mailto:blackbaby@pandora.be>administrator</a><BR><BR><INPUT type='button' value='Back' onclick=document.location='"+returnpage+"' id='button'1 name='button'1></CENTER>");
						//Response.End();
					}
					
					
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td align=right width=50>from:</td><td>"+(arr[j+1]?(arr[j+1]+" &lt;"+arr[j]+"&gt;"):arr[j])+"</td></tr>");
					Response.Write("<tr><td align=right width=50>to:</td><td>"+arr[j+2]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>subject:</td><td>"+arr[j+3]+"</td></tr>");
					Response.Write("<tr><td align=right width=50>attachments:</td><td>"+arr[j+5]+"</td></tr>");
					Response.Write("</table><hr>");
					Response.Write("<table cellspacing=1 cellpadding=0 class=small width=500>");
					Response.Write("<tr><td colspan=2 style=font-weight:bold>"+arr[j+4]+"</td></tr>");
					Response.Write("</table><hr>");
					
				}
			}
			
			Response.Write("<script>\r\n");
			Response.Write("function reloadme() {setTimeout(\"window.location='?"+url+"'\",3000)}\r\n");
			Response.Write("window.onload=reloadme;\r\n");
			Response.Write("</script>");
		}
			
			
		
	
	}



if(!act || act=="simulation" || (act=="simulation" && !to) || todo<=0)
{
%>

<a name=boxtop></a>
<center>
	<form name=panel method=get action=#boxtop>
	<table cellspacing=1 cellpadding=10 bgcolor="#000000">
	<tr>
		<td bgcolor="#D4D0C8">
			<table>
				<tr><td class=small>from</td><td><select name=from>		
				<%
						var sSQL = "select rev_email from "+_db_prefix+"review where rev_rt_typ = 26 and rev_dir_lng = \""+_ws+"\" and (rev_pub & 1) = 1 and (rev_pub & 8) = 0 order by (rev_pub & 2) desc"
						var arr = oDB.getrows(sSQL)
						
						for(var j=0;j<arr.length;j++)
							if(arr[j])
								Response.Write("\t\t\t<option value=\""+arr[j].toString().encrypt("nicnac")+"\""+(arr[j]==from?" SELECTED":"")+">"+arr[j]+"\r\n")
				
				%>
				</select>
				<%
						if(bDebug)
							Response.Write("<br>"+sSQL+"<br><br>")
				%>
				</td></tr>
				<tr><td class=small title="Sender name">sender</td><td class=small><input name=sender value="<%=Server.HTMLEncode(Request.QueryString("sender").Item)%>" style=width:300px><input type=checkbox name=overridesender <%=Request.QueryString("overridesender").Item?"checked":""%>> override</td></tr>					
				<tr><td class=small title="E-mail destination address">to</td><td class=small>
				
				<table bgcolor=#B4B0A8 cellspacing=0 cellpadding=0 align=left><tr><td><small>
				
				<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small><%=Session(_pagename+ses+"_1")?Session(_pagename+ses+"_1"):"[empty] &nbsp;"%></td></tr></table></td><td class=small ></td></tr></table>	
				
				<!--input name=to value="<%=Server.HTMLEncode(Request.QueryString("to").Item)%>" onclick=document.getElementById('o3').checked=true style=width:300px-->
				
				<!--input type=submit name=act value="set list" style=width:50px -->
				
				<input type=radio id=o1 name=overrideto value="" <%=Request.QueryString("overrideto").Item=="all" || !Request.QueryString("overrideto").Item?"checked":""%> onclick="document.panel.to.disabled=true"> full DB &nbsp;		
				<input type=radio id=o2 name=overrideto value="distinct" <%=Request.QueryString("overrideto").Item=="distinct"?"checked":""%> onclick="document.panel.to.disabled=true"> distinct DB &nbsp;	
				<input type=radio id=o3 name=overrideto value="override" <%=Request.QueryString("overrideto").Item=="override"?"checked":""%> onclick="document.panel.to.disabled=false"> override &nbsp;
				<input type=radio id=o4 name=overrideto value="manual" <%=Request.QueryString("overrideto").Item=="manual"?"checked":""%> onclick="document.panel.to.disabled=true"> manual &nbsp;
				
				</small>
				
				<br><input type=submit name=act value="set list" style=width:100px onmousedown=document.getElementById('o4').checked=true>
				
				
				</td></tr></table>
				</tr>		
				
				<tr><td class=small title="E-mail subject">subject</td><td class=small><input name=subject value="<%=Server.HTMLEncode(Request.QueryString("subject").Item)%>" style=width:300px><input type=checkbox name=overridesubj <%=Request.QueryString("overridesubj").Item?"checked":""%>> override</td></tr>
				
				<tr><td class=small title="E-mail body text">body</td><td class=small>
				<%
					var checkboxes = "<input type=checkbox name=overridebody "+(Request.QueryString("overridebody").Item?"checked":"")+"> override"
								+"<br><input type=checkbox name=htmlbody "+(Request.QueryString("htmlbody").Item?"checked":"")+"> HTML"
					
					if(Request.QueryString("htmlbody").Item)
					{
						Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses)?Session(_pagename+ses):"[empty] &nbsp;")+"</td></tr></table></td><td class=small >"+checkboxes+"</td></tr></table>")	
						Response.Write("<br><input type=submit name=act value=\"set body text\" style=width:100px>")
					}
					else
					{
						Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses)?Session(_pagename+ses):"[empty] &nbsp;")+"</td></tr></table></td><td class=small >"+checkboxes+"</td></tr></table>")	
						Response.Write("<br><input type=submit name=act value=\"set body text\" style=width:100px>")
					}
				%>
				</td></tr>
				
				<tr><td class=small title="Attachments">attachments</td><td class=small>	
				<%
						Response.Write("<table cellspacing=0 cellpadding=0><tr><td><table bgcolor=#FFFFFF cellspacing=10 cellpadding=1 border=0 style=width:300px><tr><td class=small>"+(Session(_pagename+ses+"_2")?Session(_pagename+ses+"_2"):"[empty] &nbsp;")+"</td></tr></table></td><td class=small ></td></tr></table>")	
						Response.Write("<br><input type=submit name=act value=\"set attachments\" style=width:100px>")				
				%>
				</td></tr>
				<tr><td class=small title="number of sends per step">step</td><td class=small><input name=step value="<%=step%>" maxlength=4 size=4 style="width:100px"></td></tr>
			</table>
		</td>
	</tr>
	</table>
	<br>
	
	<script>
	window.onload = updatecontrols;
	function updatecontrols()
	{
		if(document.panel.overrideto.value)
			document.panel.to.disabled = true;
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
