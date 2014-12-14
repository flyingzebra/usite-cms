<%@ Language=JavaScript %>
<HTML>
<body>
<%


try
{
  var Upload = Server.CreateObject("Persits.Upload.1");
  Response.Write("upload: "+Upload.Expires+"<br>")
  Response.Write("upload: "+Upload.Version+"<br>")
  Response.Write(((new Date(Upload.Expires)).getYear() == "1899")+"<br>")
  
}
catch(e)
{
	Response.Write("Server.CreateObject(\"Persits.Upload.1\")  FAILED<br>")
}

try
{
  var jpeg = Server.CreateObject("Persits.Jpeg");
  Response.Write("jpeg: "+jpeg.Expires+"<br>");
  Response.Write("jpeg: "+jpeg.Version+"<br>")
}
catch(e)
{
	Response.Write("Server.CreateObject(\"Persits.Jpeg\")  FAILED<br>")
}


try
{
  var Mail = Server.CreateObject("Persits.Mailsender");
  Response.Write("mail: "+Mail.Expires+"<br>")
  Response.Write("mail: "+Mail.Version+"<br>")
}
catch(e)
{
	Response.Write("Server.CreateObject(\"Persits.Mailsender\")  FAILED<br>")
}

//

//var Pdf = Server.CreateObject("Persits.Pdf");
//Response.Write("pdf: "+Pdf.Expires+"<br>")

%>

</body>
</HTML>
