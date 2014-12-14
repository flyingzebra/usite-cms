<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/clheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->
<%

Response.Write("a\rb\rc\r"+Request.QueryString("search").Item+Math.random())

//Response.Write(Math.random()*10)
%>