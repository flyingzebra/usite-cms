<%@ Language=JavaScript  %>
<HTML>
<BODY BGCOLOR="#FFFFFF">
   <FORM METHOD="POST" ENCTYPE="multipart/form-data">
      <INPUT TYPE="FILE" SIZE="40" NAME="FILE1"><BR>
      <INPUT TYPE="FILE" SIZE="40" NAME="FILE2"><BR>
      <INPUT TYPE="FILE" SIZE="40" NAME="FILE3"><BR>
   <INPUT TYPE=SUBMIT VALUE="Upload!">
   </FORM>
</BODY>
</HTML>
 
<%
var Upload = Server.CreateObject("Persits.Upload");
Upload.ignoreNoPost = true;
var upload_path = Server.Mappath ("");
Response.Write(upload_path)

//Response.Write(Upload.TotalBytes)
hvar Count = Upload.Save("c:\\");
//Response.Write(Count + " file(s) uploaded to c:\\upload");
%>
