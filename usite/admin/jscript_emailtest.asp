<%@ Language=JavaScript %>
<%
	var Mail = Server.CreateObject("Persits.Mailsender");

	Mail.Host     		= "thecandidates.com";
	Mail.From 		= "freddy.vandriessche@thecandidates.com";
	Mail.AddAddress("freddy.vandriessche@gmail.com");
	Mail.FromName   	= "Fredje";
	Mail.Subject 		= "Hoi hela"+new Date();
	Mail.Body 		= "TEST BODY "+new Date();
	Mail.IsHTML		= false;

	if(true)
	{
		Mail.Queue = True;
		Mail.Send();
	}
	else
	{
		Mail.Queue = false;
		Mail.Send();
	}
%>