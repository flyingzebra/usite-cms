<%@ Language=JavaScript %>


<!--#INCLUDE FILE = "../includes/GUI.asp" -->
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<%



	//////////////////////////////////////////////////////////////
	//  G E T   H I D D E N   I N P U T   P A R A M E T E R S   //
	//////////////////////////////////////////////////////////////

	var page			= Request.QueryString("page").Item;
	var back			= Request.QueryString("back").Item;
	var usr				= Request.Form("log").Item;
	var psw				= Request.Form("pwd").Item;
	var dir				= Request.Form("dir").Item;
	//var lng				= dir?dir.substring(dir.lastIndexOf("_")+1,dir.length):"";

var expires = new String(new Date(new Date()-(-1000*60*60*24*60)).format("%d/%m/%Y %H:%M:%S"));

Response.Cookies("UsernameCookie") = Request.Form("log").Item;
Response.Cookies("PasswordCookie") = Request.Form("pwd").Item;
Response.Cookies("RememberMeCookie") = "1";
Response.Cookies("UsernameCookie").Expires = expires;
Response.Cookies("PasswordCookie").Expires = expires;
Response.Cookies("RememberMeCookie").Expires = expires;


	
/*	
</pre><pre><i>% Information related to &#39;81.82.96.0 - 81.83.255.255&#39;</i>
</pre><pre><b><span class="bottom-dashed">inetnum</span></b>:         81.82.96.0 - 81.83.255.255
netname:         TELENET
descr:           Telenet Operaties N.V.
country:         BE
admin-c:         <a href="http://www.ripe.net/whois?searchtext=PS396-RIPE&amp;form_type=simple">PS396-RIPE</a>
tech-c:          <a href="http://www.ripe.net/whois?searchtext=PS396-RIPE&amp;form_type=simple">PS396-RIPE</a>
status:          ASSIGNED PA <a href="http://www.ripe.net/ripe/docs/ipv4-policies.html#assignment-type"><img width="84" alt="&quot;status:&quot; definitions" src="/images/icons/whois-definition.gif" title="&quot;status:&quot; definitions" height="15" border="0" /></a>
mnt-by:          <a href="http://www.ripe.net/whois?searchtext=TELENET-DBM&amp;form_type=simple">TELENET-DBM</a>
mnt-lower:       <a href="http://www.ripe.net/whois?searchtext=TELENET-DBM&amp;form_type=simple">TELENET-DBM</a>
source:          RIPE # Filtered
</pre><pre><b>role</b>:            Technical Internet
address:         Telenet Operaties N.V.
address:         Liersesteenweg 4
address:         B-2800 Mechelen
address:         Belgium
remarks:         trouble:      IMPORTANT: To report intrusion attempts, hacking,
remarks:         trouble:      IMPORTANT: spamming, or other unaccepted behavior
remarks:         trouble:      IMPORTANT: by a Telenet/Pandora customer, please
remarks:         trouble:      IMPORTANT: send a message to abuse@pandora.be
remarks:         trouble:      IMPORTANT: Voor het rapporteren van inbraakpogingen,
remarks:         trouble:      IMPORTANT: hacking, spamming, of ander onaanvaardbaar
remarks:         trouble:      IMPORTANT: gedrag van een Telenet/Pandora klant, gelieve
remarks:         trouble:      IMPORTANT: een bericht te zenden naar abuse@pandora.be
admin-c:         <a href="http://www.ripe.net/whois?searchtext=TI346-ORG&amp;form_type=simple">TI346-ORG</a>
tech-c:          <a href="http://www.ripe.net/whois?searchtext=TI346-ORG&amp;form_type=simple">TI346-ORG</a>
<span class="bottom-dashed">nic-hdl</span>:         PS396-RIPE
mnt-by:          <a href="http://www.ripe.net/whois?searchtext=TELENET-DBM&amp;form_type=simple">TELENET-DBM</a>
source:          RIPE # Filtered
abuse-mailbox:   <a href="http://www.ripe.net/whois?searchtext=abuse@pandora.be&amp;form_type=simple">abuse@pandora.be</a>
abuse-mailbox:   <a href="http://www.ripe.net/whois?searchtext=abuse@pandora.be&amp;form_type=simple">abuse@pandora.be</a>
abuse-mailbox:   <a href="http://www.ripe.net/whois?searchtext=abuse@pandora.be&amp;form_type=simple">abuse@pandora.be</a>
abuse-mailbox:   <a href="http://www.ripe.net/whois?searchtext=abuse@pandora.be&amp;form_type=simple">abuse@pandora.be</a>
</pre><pre><i>% Information related to &#39;81.83.0.0/16AS6848&#39;</i>
</pre><pre><b><span class="bottom-dashed">route</span></b>:           81.83.0.0/16
descr:           Telenet customers
<span class="bottom-dashed">origin</span>:          <a href="http://www.ripe.net/whois?searchtext=AS6848&amp;form_type=simple">AS6848</a>
mnt-by:          <a href="http://www.ripe.net/whois?searchtext=TELENET-OPS-MNT&amp;form_type=simple">TELENET-OPS-MNT</a>
source:          RIPE # Filtered
*/	
	
	

	
	
	
	
	if(dir) Session("dir") = dir;
	//if(lng) Session("_language") = lng;
	var oDB		= new DB();		// database object from DB.asp
	var pass  = 0;
	var bpage = page?true:false;

	///////////////////////////////////////////
	//  G E N E R A T E   S Q L   Q U E R Y	 //
	///////////////////////////////////////////
	
	oDB.caller = "validate.asp";
	oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	oDB.login(usr,psw,dir);
	
	pass = oDB.loginValid()?pass:1;	
	page = page?page:"men"+"u.a"+"sp";
	back = back?back:"wro"+"ng_pa"+"ssw"+"ord.a"+"sp";



	/////////////////////////////
	//  R I P E   L O O K U P  //
	/////////////////////////////



	var oHTTP = new HTTP();

oHTTP.error = true;	
	
if(!oHTTP.error)
{
	var userdata = new Array();
	
	String.prototype.ltrim = function () { return this.replace(/^ */,""); }
	String.prototype.rtrim = function () { return this.replace(/ *$/,""); }
	String.prototype.trim  = function () { return this.ltrim().rtrim(); }

	String.prototype.ltrimc = function (_c) { return this.replace(new RegExp("^"+_c+"*"),""); }
	String.prototype.rtrimc = function (_c) { return this.replace(new RegExp(_c+"*$"),""); }
	String.prototype.trimc  = function (_c) { return this.ltrim(_c).rtrim(_c); }	

	function stripHtml(strHTML) 
	{
		strOutput = strHTML.replace(/\n/g, ".$!$.")
		strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
		return strOutput;
	}
	
	userdata["HTTP_REFERER"] = Request.ServerVariables("HTTP_REFERER");
	userdata["HTTP_USER_AGENT"] = Request.ServerVariables("HTTP_USER_AGENT");
	userdata["REMOTE_HOST"] = Request.ServerVariables("REMOTE_HOST");
	

	var lookup = oHTTP.whois(userdata["REMOTE_HOST"]).split("\r\n");
	var cat = "";
	var flds = new Array();
	var fldc = 0;
	for(var i=0;i<lookup.length;i++)
	{
		if(lookup[i])
		{
			var pos = lookup[i].indexOf(":")
			if(pos>0)
			{
				var arg = lookup[i].substring(0,pos);
				if(arg.indexOf("<pre>")>0)
				{
					cat = stripHtml(arg)
					arg = cat;
				}
				
				var val = lookup[i].substring(pos+1,lookup[i].length).ltrim();
				if(userdata[cat+"_"+arg])
					userdata[cat+"_"+arg] = userdata[cat+"_"+arg]+"\r\n"+val;
				else
				{
					userdata[cat+"_"+arg] = val;
					flds[fldc++] = cat+"_"+arg;
				}
			}
		}
	}
	
	var FSO = Server.CreateObject("Scripting.FileSystemObject");
	var file 	= Server.MapPath("../admin/logs")+"\\login.csv";

	var sep = ";";
	var precolumns = new Array("srv_time"                          ,"srv_log"   ,"srv_pwd"  ,"srv_dir"  ,"srv_intruder","srv_admitted" ,"srv_remote_host"             ,"srv_user_agent"                 ,"srv_referrer");
	var predata    = new Array(new Date().format("%d-%m-%Y %H:%M:%S"),String(usr) ,String(psw),String(dir),""          ,String(pass==0),String(userdata["REMOTE_HOST"]),String(userdata["HTTP_USER_AGENT"]),String(userdata["HTTP_REFERER"]))

	// PUT ADDITIONAL USERDATA
	
	for(var i=0;i<precolumns.length;i++)
		userdata[precolumns[i]] = predata[i]

	
	var columns    = precolumns.concat(new Array("inetnum_inetnum","inetnum_netname","inetnum_descr","inetnum_country","inetnum_org","inetnum_admin-c","inetnum_tech-c","inetnum_status","inetnum_mnt-by","inetnum_mnt-lower","inetnum_mnt-routes","inetnum_source","organisation_organisation","organisation_org-name","organisation_org-type","organisation_address","organisation_phone","organisation_fax-no","organisation_admin-c","organisation_mnt-ref","organisation_mnt-by","organisation_source","role_role","role_address","role_remarks","role_admin-c","role_tech-c","role_nic-hdl","role_mnt-by","role_source","role_abuse-mailbox","route_route","route_descr","route_origin","route_mnt-by","route_source"));


	////////////////////////////////////////////
	//  I N T R U D E R   D E T E C T I O N   //
	////////////////////////////////////////////
	

	userdata["srv_intruder"] = "";
	var bSubmitData = userdata["srv_log"]!="undefined" 
					&& userdata["srv_pwd"]!="undefined"
					&& userdata["srv_dir"]!="undefined"
					&& userdata["srv_referrer"]!="undefined"
	userdata["srv_intruder"] +=  bSubmitData==false ? "UNARMED," : "";
	userdata["srv_intruder"] +=  userdata["inetnum_country"] && userdata["inetnum_country"].substring(0,2)=="EU"?(bSubmitData==false?"GHOST,":"*IMPOSTER*,"):"";
	userdata["srv_intruder"] = userdata["srv_intruder"]!="undefined"?userdata["srv_intruder"].substring(0,userdata["srv_intruder"].length-1):""
	
	//Response.Write((!!userdata["srv_log"] && !!userdata["srv_pwd"] && !!userdata["srv_dir"] && !!userdata["srv_referrer"])+"*")
	//Response.End();
	
	
	var ForAppending = 8;
	try
	{	
		var fileObj = FSO.OpenTextFile(file,ForAppending,false);
	}
	catch(e)
	{
		var fileObj = FSO.CreateTextFile(file,true,false);
		fileObj.Close();
		
		var ForAppending = 8;
		var fileObj = FSO.OpenTextFile(file,ForAppending,false);
		fileObj.Write("\""+columns.join("\""+sep+"\"")+"\"\r\n");
		fileObj.Close();
		var fileObj = FSO.OpenTextFile(file,ForAppending,false);
	}

	var param = new Array();
	var str = "";
	
	for(var i=0;i<columns.length;i++)
	{
		//Response.Write(userdata[columns[i]]+" "+columns[i]+"<br>")
		str += (i>0?sep:"")+"\""+(userdata[columns[i]]?userdata[columns[i]].replace(/"/g,"\\\"").replace(/\r\n/g," | "):"")+"\"";
	}

	fileObj.Write(str+"\r\n");
	fileObj.Close();

}
else
{

//Response.write("uid="+Session("uid"))
//   Response.End();
}









	function passreq( )
	{
		if(Session("change_pass")==true)
		{
			Session("change_pass")     = false;
			Session("change_password") = true;
		}
		else
			Session("change_password") = false;
	}
	
	if (pass==1)
	{
		if(usr)
			usr=usr.replace(/\x27/g,"\\'");
		if(psw)
			psw=psw.replace(/\x27/g,"\\'");

		//Response.Write("select acc_id from "+_db_prefix+"_acc where acc_name = '"+usr+"' and acc_psw = '"+psw+"'")
			
			
		var id = oDB.get("select acc_id from "+_db_prefix+"_acc where acc_name = '"+usr+"' and acc_psw = '"+psw+"'");

		if(id)
		{
			passreq();
			Session("uid") = id;  //.toString().encrypt("nicnac");
			if(bpage)
				Response.Redirect(page+"_Q_id_E_"+Session("uid")+".asp");
			else
				Response.Redirect("menu_Q_id_E_"+Session("uid")+".asp");
		}
			
	}
//Response.Write("uid="+Session("uid"))
//Response.End();
	
	switch(pass)
	{
		case 0: passreq(); Response.Redirect(page); break;
		case 1: Response.Redirect(back); break;
	}
%>