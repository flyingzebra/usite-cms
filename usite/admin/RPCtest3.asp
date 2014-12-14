<%@ Language="JScript" %>

<%

Response.Write(Request.Form("apiKey").Item+"**"+Request.Form("token").Item);

%>

