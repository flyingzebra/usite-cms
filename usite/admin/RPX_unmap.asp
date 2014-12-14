<%@ Language="JScript" %>

<%

var key = Request.QueryString("primaryKey").Item;
var id = Request.QueryString("identifier").Item;


var url = "https://rpxnow.com/api/v2/unmap";

var objSrvHTTP;
objSrvHTTP = Server.CreateObject ("Msxml2.ServerXMLHTTP.3.0");
objSrvHTTP.open ("POST",url, false);
objSrvHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
objSrvHTTP.send("apiKey=c999c39f9c78e3f6b6bab311dec3a8747c720e7f"
               +"&primaryKey="+key
               +"&identifier="+id);

Response.Clear();
Response.ContentType = "text/html";
Response.Write (objSrvHTTP.responseText);


%>

