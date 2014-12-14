<%@ Language=JavaScript %>
<%var _db_prefix = "usite_"%>
<!--#INCLUDE file = "usite/includes/DB.asp" -->
<%

//Response.Flush()
	var bDebug = true;
	var host = Request.ServerVariables("HTTP_HOST").Item;
	
	

	switch(host)
	{

		case "www.nobel.be":
		case "nobel.be":
		case "www.artinbelgium.be":
		case "artinbelgium.be":
		%>
<html>
<head>
<title>Nobel - Art E-Zine</title>
<meta name="ICBM" content="50.6917, 4.4442">
<meta name="DC.title" content="Nobel">
<META NAME="geo.position" CONTENT="50.6917;4.4442"> 
<META NAME="geo.placename" CONTENT="Lasne">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-WBR">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.be" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.nobel.be" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="nobel.be">
<meta name="keywords" content="Freddy Vandriessche,Nicolas Poncelet, Gwennaëlle Gribaumont, Sabine Huysman">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.nobel.be/theartserver/frbe/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		Response.End();
		break;

		case "master.nobel.be":
		%>
<html>
<head>
<title>Nobel - Art E-Zine</title>
<meta name="ICBM" content="50.6917, 4.4442">
<meta name="DC.title" content="Nobel">
<META NAME="geo.position" CONTENT="50.6917;4.4442"> 
<META NAME="geo.placename" CONTENT="Lasne">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-WBR">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.be" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.nobel.be" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="nobel.be">
<meta name="keywords" content="Freddy Vandriessche,Nicolas Poncelet, Gwennaëlle Gribaumont, Sabine Huysman">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://master.nobel.be/theartserver/frbe/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		Response.End();
		break;

		case "www.theartserver.nl":
		case "theartserver.nl":
		%>
<html>
<head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.nl" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.nl" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.nl">
<meta name="keywords" content="Freddy Vandriessche,Willy Laureys,Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.nl/theartserver/nlbe/00_index_Q_skin_E_1.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		break;

		case "www.theartserver.fr":
		case "theartserver.fr":
		%>
<html>
<head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.fr" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.fr" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.fr">
<meta name="keywords" content="Freddy Vandriessche,Willy Laureys,Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.fr/theartserver/fr/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>			
		<%
		break;

		case "www.theartserver.it":
		case "theartserver.it":
		%>
<html>
<head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.it" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.it" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.it">
<meta name="keywords" content="Freddy Vandriessche,Willy Laureys,Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.it/theartserver/it/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		break;

		case "www.theartserver.co.uk":
		case "theartserver.co.uk":
		%>
<html>
<head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.co.uk" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.co.uk" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.co.uk">
<meta name="keywords" content="Freddy Vandriessche,Willy Laureys,Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.co.uk/theartserver/enuk/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		break;

		case "www.theartserver.de":
		case "theartserver.de":
		%>
<html>
<head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen">
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.de" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.de" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.de">
<meta name="keywords" content="Freddy Vandriessche,Willy Laureys,Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>
<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.de/theartserver/de/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>
</html>
		<%
		break;

		case "www.theartserver.com":
		case "theartserver.com":
		%>
<html><head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen"> 
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.com" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.com" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.com">
<meta name="keywords" content="Freddy Vandriessche, Willy Laureys, Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>

<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.com/theartserver/com/index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>

</html>
		<%
		Response.End();
		break;

		case "www.theartserver.org":
		case "theartserver.org":
		%>
<html><head>
<title>The Art Server - Art E-Zine</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="The Art Server">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen"> 
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.theartserver.com" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.theartserver.org" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="theartserver.org">
<meta name="verify-v1" content="FKSK0+GA1PMEiBoFfnYj5AkIUGJ0ViJdpiGlrkImacU=" />
<meta name="keywords" content="Freddy Vandriessche, Willy Laureys, Guy Goethals, Arnold Eloy, kunst cultuur literatuur boeken cd muziek">
</head>

<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.theartserver.org/theartserver/nlbe/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>

</html>
		<%
		Response.End();
		break;

		
		case "www.artprice.be":
		case "artprice.be":
		case "www.artprice.lu":
		case "artprice.lu":
		case "www.artprice.nl":
		case "artprice.nl":
%>
<html><head>
<title>ARTPRICE.BE</title>
<meta name="ICBM" content="51.22166, 4.40861">
<meta name="DC.title" content="ARTPRICE.BE">
<META NAME="geo.position" CONTENT="51.22166;4.40861"> 
<META NAME="geo.placename" CONTENT="Antwerpen"> 
<META NAME="geo.country" CONTENT="BE"> 
<META NAME="geo.region" CONTENT="BE-VAN">
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.artprice.be" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.artprice.be" r (n 0 s 0 v 0 l 0))'>
<meta name="description" content="artprice.be">
<meta name="keywords" content="Nicolas Poncelet">
</head>

<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.artprice.be/artprice/nlbe/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>

</html>
<%
		Response.End();
		break;

		case "www.aesm2007.be":
		case "aesm.be":
		%>
<html>
<head>
<title>AESM.BE</title>
<META Name="author" Content="Black Baby sprl">
<META Name="description" Content="">
<META Name="keywords" Content="">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="http://www.aesm2007.be/aesm/frbe/00_index.asp" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>

</html>	
		<%
		break;

		case "www.mountainbike2005.be":
		case "mountainbike2005.be":
		%>
<html><head>
<title>MOUNTAINBIKE 2005</title>
<meta http-equiv="content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="p3p" content='CP="CAO DSP AND SO ON" policyref="/w3c/p3p.xml"'>
<meta http-equiv="PICS-label" content='(PICS-1.1 "http://www.icra.org/ratingsv02.html" l gen true for "http://www.arapb.be" r (cz 1 lz 1 nz 1 oz 1 vz 1) "http://www.rsac.org/ratingsv01.html" l gen true for "http://www.arapb.be" r (n 0 s 0 v 0 l 0))'>	
</head>

<frameset border=0 rows="100%,*" frameborder="no" marginleft=0 margintop=0 marginright=0 marginbottom=0>
<frame src="mountainbike/" scrolling=auto frameborder="no" border=0 noresize>
<frame topmargin="0" marginwidth=0 scrolling=no marginheight=0 frameborder="no" border=0 noresize>
</frameset>

</html>
		<%
		break;	

		default:


		String.prototype.decrypt =  function (pwd)
		{
		  if(this == null || this.length < 8) 
		  {
			Response.Write("A salt value could not be extracted from the encrypted message because it's length is too short. The message cannot be decrypted.");
			return;
		  }
		  
		  if(pwd == null || pwd.length <= 0)
		  {
			Response.Write("Please enter a password with which to decrypt the message.");
			return;
		  }
		  
		  var prand = "";
		  for(var i=0; i<pwd.length; i++) {
			prand += pwd.charCodeAt(i).toString();
		  }
		  var sPos = Math.floor(prand.length / 5);
		  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
		  var incr = Math.round(pwd.length / 2);
		  var modu = Math.pow(2, 31) - 1;
		  var salt = parseInt(this.substring(this.length - 8, this.length), 16);
		  var str = this.substring(0, this.length - 8);
		  prand += salt;
		  while(prand.length > 10) {
			prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
		  }
		  prand = (mult * prand + incr) % modu;
		  var enc_chr = "";
		  var enc_str = "";
		  for(var i=0; i<str.length; i+=2) {
			enc_chr = parseInt(parseInt(str.substring(i, i+2), 16) ^ Math.floor((prand / modu) * 255));
			enc_str += String.fromCharCode(enc_chr);
			prand = (mult * prand + incr) % modu;
		  }
		
		  
		
		  var _today = new Date();
		  var _encdatestr = enc_str.substring(0,8);
		  var _century=20;
		  var _year   = Number(_encdatestr.substring(0,2));
		  var _month  = Number(_encdatestr.substring(2,4));
		  var _day    = Number(_encdatestr.substring(4,6));
		  var _hour   = Number(_encdatestr.substring(6,8));
		  var _min    = 0;
		  var _sec    = 0;
		  var _encdate    = new Date((_year>90?(_century-1):_century)*100+_year,_month-1,_day,_hour,_min,_sec);
		  
		  // DO NOT 'DECLARE' FOLLOWING VARIABLE !!!!
		  _encdelay   = Math.floor(  (new Date()-_encdate)/1000  )/60/60;   // EXPIRATION DELAY (in hours)
		
		  //Response.Write("#"+_encdatestr+"/"+enc_str.substring(8,enc_str.length)+"<br>");
		
		  return enc_str.substring(8,enc_str.length);
		}
		
		function argparser(_str)
		{
			var _enum = new Array();
			if(_str)
			{
				if(_str.substring(0,6)=="&quot;")
					_str = _str.substring(6,_str.length-6);
				else
					_str = _str.charAt(0)=="\"" ? _str.substring(1,_str.length-1) : ("id="+_str);
				var _parr = new String(_str).split(/,|=/);
	
				for(var _i=0;_i<_parr.length;_i+=2)
				{
				   _enum[_parr[_i]] = _enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1];
				   _enum[_i/2] = _parr[_i];
				   if(bDebug)
						Response.Write("_enum["+_parr[_i]+"] = "+(_enum[_parr[_i]]?(_enum[_parr[_i]]+","+_parr[_i+1]).replace(/%2C/g,","):_parr[_i+1])+"<br>\r\n")
				}
				if(bDebug)
					Response.Write("<br>("+_str+")<br>");
			}
			return _enum;
		}		
		



		var _oDB		= new DB();		// database object from DB.asp
		_oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
		_oDB.getSettings(_oDB.oCO.ConnectString);

		var enumfld = new Array();
		var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
		for(var i=tablefld.length-1;i>=0;i--)
			enumfld[tablefld[i]] = i;
		enumfld["subtitle"] = i++;
	
		var hostarr = host.split(".");
		var purehost = hostarr[hostarr.length-2] + "." + hostarr[hostarr.length-1]
	
		var sSQL = "select "+tablefld+" from usite_blackbabyset where ds_rev_id = 659 and ds_data01 = \"http://www."+purehost.replace(/www\./,"")+"\"";
		//Response.Write("<!--"+sSQL+"-->")
		//Response.Write(sSQL)
		//Response.End();
		var arr = _oDB.getrows(sSQL);
		
		//Response.Write("<!--\r\n\r\n  "+sSQL+" \r\n\r\n-->")

       if(arr.length==0)
       {
			var _oDB		= new DB();		// database object from DB.asp
			_oDB.oCO.get("NSOWHAT_MYSQL_DSNLESS");
			_oDB.getSettings(_oDB.oCO.ConnectString);

			var enumfld = new Array();
			var tablefld = new Array("ds_id","ds_rev_id","ds_num01","ds_num02","ds_title","ds_desc","ds_header","ds_datetime01","ds_data01","ds_data02","ds_data03","ds_data04","ds_data05","ds_data06","ds_pub");
			for(var i=tablefld.length-1;i>=0;i--)
				enumfld[tablefld[i]] = i;
			enumfld["subtitle"] = i++;
		
			var hostarr = host.split(".");
			var purehost = hostarr[hostarr.length-2] + "." + hostarr[hostarr.length-1]
		
			var sSQL = "select "+tablefld+" from usite_blackbabyset where ds_rev_id = 659 and ds_data01 = \"http://www."+purehost.replace(/www\./,"")+"\"";
			//Response.Write("<!--"+sSQL+"-->")
			//Response.Write(sSQL)
			//Response.End();
			var arr = _oDB.getrows(sSQL);
	    }




		
		if(arr.length==0)
		{
			LangArr = new Array();
			arr[enumfld["ds_header"]] = host.replace(/www\./,"")
			arr[enumfld["name"]] = host.replace(/www\./,"")
			var subtitle = "new domain name";
		}
		else	
		{
			var sitedir = arr[enumfld["ds_title"]];
			var sSQL = "select rev_rev from usite_review where rev_rt_typ = 21 and rev_dir_lng = \""+sitedir+"\" and rev_pub & 9 = 1 order by rev_pub desc LIMIT 0,1";
			var txt = _oDB.get(sSQL);
			var bSplashFound = !!txt;
			
			
			
			if(bSplashFound && (arr[enumfld["ds_pub"]]&9)==1)
			{
			
				var _proj = arr[enumfld["ds_data02"]];
				var _ws  = arr[enumfld["ds_title"]];

				var _app_db_prefix = "usite_";
				var bSplitLanguages  = false;
				if(typeof(_db_prefix)!="string")
					var _db_prefix = _app_db_prefix+(bSplitLanguages?(_language+"_"):"");	
			
				// DO SOME TAG PROCESSING ON THE SPLASH PAGE
				var arr = txt?txt.split("{_"):new Array();	// SEARCH FOR FUNCTION CALLS INSIDE TEMPLATE
				var _tmplfield 	= new Array();
				var _tmplfld = new Array();
				var _templdat = new Array();
				var _enumfld = new Array();
				
				for(var i=1;i<arr.length;i++)
					_tmplfld[i-1] = arr[i].substring(0,arr[i].indexOf("_}"));			
				
				if(bDebug)
					    Response.Write("<!-- _tmplfld = "+_tmplfld+"-->\r\n")
				
				for(var i=0;i<_tmplfld.length;i++)
				{
					_templdat[i] = "";
					_enumfld[_tmplfld[i]] = i;
					
					var curfield = _tmplfld[i];
					var curarg   = "";
				   if(curfield && curfield.indexOf("{")>=0 && curfield.indexOf("}")>=0 && curfield.indexOf("}") > curfield.indexOf("{"))
					{
						curarg   = curfield.substring(curfield.indexOf("{")+1,curfield.indexOf("}"))
						curfield = curfield.substring(0,curfield.indexOf("{"));
					}

					_tmplfield[i] = curfield
						
					//_tmplfield[i] = new String(curfield);
					
					if(bDebug)
					    Response.Write("<!-- DETECTED "+_tmplfield[i]+" "+_i+" "+curfield+" "+_tmplfld[i]+"-->\r\n")
					
					
					
					switch(curfield)
					{
						case "MDIR":
							_templdat[i] = "http://www."+purehost+"/"+(_proj?_proj:"usite")+"/"+sitedir;
						break;						
						case "DOM":
							_templdat[i] = purehost;
						break;
						case "PRJ":
							_templdat[i] = _proj?_proj:"usite";
						break;	
						case "ROOT":
							_templdat[i] = _proj+"/";	
						break;
						case "WS":
							_templdat[i] = sitedir;
						break;
						case "NBSP":
							_templdat[i] = "&nbsp;";
						break;					
						case "EXEC":
								var arg = argparser(curarg);
								if(arg["script"])
								{
									_templdat[i] = "<!--EXEC-->";//unescape(arg["script"]);
									eval(unescape(arg["script"]));
								}
								else if(arg["scriptid"])
								{
								    _templdat[i] = "<!--EXEC-->";
									var rid = arg["scriptid"].toString().decrypt("nicnac");
									var sSQL = "select rev_rev from "+_db_prefix+"review where rev_dir_lng=\""+_ws+"\" and (rev_pub & 9) = 1 and rev_id = "+rid+" limit 0,1"
									var script = _oDB.get(sSQL);
									
									//Response.Write(script)
									eval(script);

								}								
						break;
						case "UP":
							_templdat[i] = "<";
						break;		
						case "DN":
							_templdat[i] = ">";
						break;					
						
					}
					
					//Response.Write("<!--"+_templdat[i]+" "+i+"-->\r\n")
				}

			   // CLEAR TAGS AFTER USE	
			   for(var _i=0;_i<_tmplfld.length;_i++)
			   {
					   txt = txt.replace("{_"+_tmplfield[_i]+"_}",_templdat[_i]?_templdat[_i]:("{_"+_tmplfield[_i]+"_}"));
					   if(bDebug)
					   {
					      Response.Write("<!-- REPLACE {_"+_tmplfield[_i]+"_} by \r\n");
					      Response.Write(_templdat[_i]+"\r\n-->\r\n\r\n");
					   }
			   }
			   
				Response.Write(txt);
				Response.End();
			}
			else
			{
				var sSQL = "select rd_text from usite_blackbabydetail where rd_ds_id = 659 and rd_dt_id = 9 and rd_recno = "+arr[enumfld["ds_id"]];
				var subtitle = _oDB.get(sSQL);
				var _proj = arr[enumfld["ds_data02"]]				
	
				var LangArr = arr[enumfld["ds_desc"]].split(" ");	

				if(LangArr.length==1 && (arr[enumfld["ds_pub"]]&9)==1)
				{
						Response.Redirect(LangArr[0].replace(/([a-z][a-z])([a-z][a-z])/g,arr[enumfld["ds_data01"]]+"/"+(_proj?_proj:"usite")+"/"+arr[enumfld["ds_title"]]+"_$1$2/index.asp"))

					//Server.Transfer(LangArr[0].replace(/([a-z][a-z])([a-z][a-z])/g,"usite/"+arr[enumfld["ds_title"]]+"_$1$2/index.asp"))

				}
				else
				{
%>
<P align=center>&nbsp;</P>
<P align=center><FONT face="Tahoma, Arial, Helvetica, sans-serif" size=4></FONT>&nbsp;</P>
<P align=center><FONT face="Tahoma, Arial, Helvetica, sans-serif" size=5><%=arr[enumfld["ds_header"]]%></FONT></P>
<P align=center><FONT size=4 face="Tahoma, Arial, Helvetica, sans-serif"><%=subtitle%></FONT></P>
<P align=center><IMG alt="" hspace=0 src="<%=_proj?_proj:"usite"%>/images/potlood.jpg" border=0><br><%=LangArr.join(" ").replace(/([a-z][a-z])([a-z][a-z])/g,"<a href="+arr[enumfld["ds_data01"]]+"/"+(_proj?_proj:"usite")+"/"+arr[enumfld["ds_title"]]+"_$1$2/"+((arr[enumfld["ds_pub"]]&9)==1?"index.asp":"login.asp")+"><img src="+(_proj?_proj:"usite")+"/images/ii_$1.gif border=0></a>")%></P>
<%
				}
			}
			
		}
		
		//Response.Write("<!--\r\n\r\n  "+sSQL+" \r\n\r\n-->")
		Response.End();

		break;




	}
	
	
%>

