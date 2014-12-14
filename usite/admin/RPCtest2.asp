<%@ Language="JScript" %>

<%

var url = "https://rpxnow.com/api/v2/auth_info";

//var url = "http://www.thecandidates.com/usite/admin/RPCtest3.asp";

var objSrvHTTP;
objSrvHTTP = Server.CreateObject ("Msxml2.ServerXMLHTTP.3.0");
objSrvHTTP.open ("POST",url, false);

 objSrvHTTP.setRequestHeader("Man", "POST http://api.google.com/search/beta2 HTTP/1.1")
 objSrvHTTP.setRequestHeader("MessageType", "CALL")
 objSrvHTTP.setRequestHeader("Content-Type", "text/xml")
 //objSrvHTTP.setRequestHeader("apiKey","c999c39f9c78e3f6b6bab311dec3a8747c720e7f");
 //objSrvHTTP.setRequestHeader("token","6f2d6978908f035b4ea6a73b8aea2c2b1c4fbbef")
 objSrvHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");


objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f&token=6f2d6978908f035b4ea6a73b8aea2c2b1c4fbbef");

Response.Clear();
Response.ContentType = "text/html";
Response.Write (objSrvHTTP.responseText);

%>

