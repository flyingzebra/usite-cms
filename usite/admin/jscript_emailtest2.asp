<%@ Language=JavaScript %>
<%
	var Mail = Server.CreateObject("Persits.Mailsender");

	Mail.Host     		= "thecandidates.com";
	Mail.From 		= "info@thecandidates.com";
	Mail.AddAddress("freddy.vandriessche@gmail.com");
	Mail.FromName   	= "Fredje";
	Mail.Subject 		= "Hoi hela"+new Date();
	Mail.Body 		= "TEST BODY "+new Date();
	Mail.IsHTML		= false;
	
	Mail.Username = "thecandidatescom"
	Mail.Password = "tfv563"
	Mail.Host = "relay-auth.mailprotect.be"



	Mail.Queue = false;
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

%>