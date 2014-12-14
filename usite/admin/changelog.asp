<%@ Language=JavaScript %>

<FORM name=main method=post>

<input name=act value="reset" type=submit>  <input name=act value="refresh" type=submit><br>

<TEXTAREA cols=100 rows=60>
<%
if(Request.Form("act").Item=="reset")
	Session("chh") = "";
	
Response.Write(Session("chh"));
%>
</TEXTAREA>

</FORM>