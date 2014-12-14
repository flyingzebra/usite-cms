<%@ Language="JScript" %>

<%

/*
var url = "https://rpxnow.com/api/v2/map";

var objSrvHTTP;
objSrvHTTP = Server.CreateObject ("Msxml2.ServerXMLHTTP.3.0");
objSrvHTTP.open ("POST",url, false);
objSrvHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
//objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f"
//               +"&identifier=http:\/\/thecandidates.myopenid.com\/"
//               +"&primaryKey=40404");
objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f"
               +"&identifier=https:\/\/www.google.com\/accounts\/o8\/id?id=AItOawkCqr6tAflf1JORadTgp66Sx4441r3xLco"
               +"&primaryKey=40404");
Response.Clear();
Response.ContentType = "text/html";
Response.Write (objSrvHTTP.responseText);



var url = "https://rpxnow.com/api/v2/mappings";

var objSrvHTTP;
objSrvHTTP = Server.CreateObject ("Msxml2.ServerXMLHTTP.3.0");
objSrvHTTP.open ("POST",url, false);
objSrvHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f"
               +"&primaryKey=40404");

Response.Clear();
Response.ContentType = "text/html";
Response.Write (objSrvHTTP.responseText);
*/

var url = "https://rpxnow.com/api/v2/unmap";

var objSrvHTTP;
objSrvHTTP = Server.CreateObject ("Msxml2.ServerXMLHTTP.3.0");
objSrvHTTP.open ("POST",url, false);
objSrvHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f"
               +"&primaryKey=12805"
               +"&identifier=https:\/\/www.google.com\/accounts\/o8\/id?id=AItOawkJyubwfnyhVDeVT9Kga9tyQR2WZT0tmKk");

Response.Clear();
Response.ContentType = "text/html";
Response.Write (objSrvHTTP.responseText);


%>

