<%@ Language=JavaScript%>
<!--#INCLUDE FILE = "ref.asp" -->
<html>
<head>
<title>Het formulier wordt verstuurd</title>
</head>
	<body>
	<%

	
	var Mail = Server.CreateObject("Persits.Mailsender");
	var crlf = "\r\n";
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	oDB.getSettings(oDB.oCO.ConnectString);
	
	var email = Request.QueryString("newsletter").Item;
	var page = Request.QueryString("page").Item;
	var returnpage = page?page:"../"+_dir+"/00_index.asp";



	var sMessageText = "";
	var sSubject	 = "";
	
	switch(_language)
	{
		case "nlbe":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Dit is een automatische E-mail van www."+_ws+".be" + crlf + crlf;
		    sMessageText += "Gelieve mij te abonneren op de nieuwsbrief van "+_ws+" :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Bedankt." + crlf + crlf;
		break;
		case "nl":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Dit is een automatische E-mail van www."+_ws+".nl" + crlf + crlf;
		    sMessageText += "Gelieve mij te abonneren op de nieuwsbrief van "+_ws+" :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Bedankt." + crlf + crlf;
		break;
		case "frbe":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Ceci est un E-mail van www."+_ws+".be" + crlf + crlf;
		    sMessageText += "Veuillez me souscrire à la newsletter du Art Server :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Merci." + crlf + crlf;
		break;
		case "fr":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Ceci est un E-mail van www."+_ws+".fr" + crlf + crlf;
		    sMessageText += "Veuillez me souscrire à la newsletter du Art Server :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Merci." + crlf + crlf;
		break;
		case "de":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Dieses ist eine automatisierte E-mail von www."+_ws+".de" + crlf + crlf;
		    sMessageText += "Bitte unterzeichnen zum Art Server newsletter :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Danke." + crlf + crlf;
		break;
		case "it":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "Ciò è un E-mail automatico da www."+_ws+".it" + crlf + crlf;
		    sMessageText += "Abbonarselo prego al bollettino dell'Art Server :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Grazie." + crlf + crlf;
		break;
		case "enuk":
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "This is an automated E-mail from www."+_ws+".co.uk" + crlf + crlf;
		    sMessageText += "Please subscribe me to the newsletter of "+_ws+" :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Many thanks." + crlf + crlf;
		break;
		default:
			sSubject = "newsletter "+_ws+" ("+_language+")";
			sMessageText =  "This is an automated E-mail from www."+_ws+".com" + crlf + crlf;
		    sMessageText += "Please subscribe me to the newsletter of "+_ws+" :" + crlf + crlf;
		    sMessageText += "E-mail: " + email + crlf + crlf;
		    sMessageText += "Many thanks." + crlf + crlf;
		break;
		
	}

	var emails = oDB.getrows("select concat(ml_email,ml_lng_code) from "+_db_prefix+"mailing");
	var emailpool = ";"+emails.join(";")+";";

	Mail.Host = "localhost";
	Mail.From = email;
	Mail.FromName = email;
	Mail.AddAddress(_notify);
	Mail.Subject = sSubject;
	Mail.Body = sMessageText;


if (emailpool.indexOf(";"+email+_dir+";")<0)	
{
	var id = oDB.takeanumber(_db_prefix+"mailing");
	var SQL = "insert into "+_db_prefix+"mailing (ml_id,ml_email,ml_status,ml_lng_code) values("+id+",'"+email+"',1,'"+_dir+"')";
	//Response.Write("<!--"+SQL+"-->");
	//Response.Flush();
	oDB.exec(SQL);

	try
	{
		Mail.Send();
		Response.Redirect(returnpage+"?p=1");
	}
	catch (e)
	{
		Response.Write("<BR><BR><CENTER>Mail sender failed,<BR><BR> " + (e.number & 0xFFFF).toString(16) + " " + e.description + "<BR><BR> please contact <a href=mailto:blackbaby@pandora.be>administrator</a><BR><BR><INPUT type='button' value='Back' onclick=document.location='"+returnpage+"'></CENTER>");
	}
}
else
	Response.Redirect(returnpage+"?p=1");


	%>
	</body>
</html>
