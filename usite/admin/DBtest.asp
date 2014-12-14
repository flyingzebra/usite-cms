<%@ Language=JavaScript %>
<HTML>
<BODY>

<!--#INCLUDE FILE = "../includes/CO.asp" -->

<%
	var DB = Request.Form("Conn").Item;
	var go = Request.Form("go").Item;
	var Conn_input = Request.Form("Conn_input").Item;
			
	var oCO = new CO();
	
	if (DB)
		oCO.get(DB);
	else
		oCO.ConnectString = "";
	//else
	//	oCO.get(oCO.choice[0]);
	
	if (!Conn_input)
		Conn_input = oCO.ConnectString;
	
	var log = "";
	var result = "";
	var act = new Date();

	function logger(action)
	{
		var now = new Date();
		log += (now-act) + " ms\t: " + action +"\r\n"
		act = now;
	}

	var choice = "<OPTION value=''></OPTION>";
	for (var i=0;i<oCO.choice.length;i++)
		choice += "<OPTION"+(DB==oCO.choice[i]?" SELECTED":"")+" value='"+oCO.choice[i]+"'>"+oCO.choice[i];
	
	if (go=="OPEN")
	{	
		try
		{
			var ConObj = Server.CreateObject("ADODB.Connection");
			var RSObj  = Server.CreateObject("ADODB.Recordset");
			
			ConObj.Open(Conn_input);	
			logger("opened");
			ConObj.Close();
			logger("closed");
			result = "Connecntion successful !";
		}
		catch(e)
		{
			logger((e.number & 0xFFFF).toString(16) + " " + e.description);
			result = "Connecntion failed";
		}

	}
	
	if (go=="SELECT")
	{
		try
		{		    
		    var lngTopicID = 1;
		    
		    var SQL = "select count(*) from usite_review";
			var ConObj = Server.CreateObject("ADODB.Connection");
			var RSObj  = Server.CreateObject("ADODB.Recordset");
		
		
			logger ("query '"+SQL+"'");
			ConObj.Open(oCO.ConnectString);
			logger("opened");
			RSObj.Open(SQL, ConObj);
			if (!RSObj.EOF)
				var retval = RSObj(0).value;
			logger("get value ('"+retval+"')");
		
			ConObj.Close();
			logger("closed");
		
			result = "Custom query successful !";
		}
		catch(e)
		{
			logger((e.number & 0xFFFF).toString(16) + " " + e.description);
			result = "Custom query failed";
		}
	}
	
	if (go=="INSERT_DELETE")
	{
		try
		{
			var SQL = "INSERT INTO tblSmut (Smut,Word_replace) VALUES ('dick','d*ck')";
		
			var ConObj = Server.CreateObject("ADODB.Connection");
			var RSObj  = Server.CreateObject("ADODB.Recordset");
		
			ConObj.Open(oCO.ConnectString);
			logger("opened");
			RSObj.Open(SQL, ConObj);
			logger("query '"+SQL+"'");
			ConObj.Close();
			logger("closed");
		
			result = "Insert successful !";
		}
		catch(e)
		{
			logger((e.number & 0xFFFF).toString(16) + " " + e.description);
			result = "Insert failed";
		}
		
		try
		{
			var SQL = "DELETE FROM tblSmut WHERE Smut = 'dick'";
		
			var ConObj = Server.CreateObject("ADODB.Connection");
			var RSObj  = Server.CreateObject("ADODB.Recordset");
		
			ConObj.Open(oCO.ConnectString);
			logger("opened");
			RSObj.Open(SQL, ConObj);
			logger("query '"+SQL+"'");
			ConObj.Close();
			logger("closed");
		
			result = "Delete successful !";
		}
		catch(e)
		{
			logger((e.number & 0xFFFF).toString(16) + " " + e.description);
			result = "Delete failed";
		}
	}

 

	if (go=="DBFILE")
	{
		try
		{
			var ForReading = 1
			var FSO = Server.CreateObject("Scripting.FileSystemObject");
			fileobj = FSO.OpenTextFile(oCO.DBFile, ForReading, false);
			logger("opened '"+oCO.DBFile+"'");
			logger("closed");
			fileobj.Close();
			result = "File found";
		}
		catch(e)
		{
			var dump = "\r\nTried to open '"+oCO.DBFile+"'\r\nCurrent path = '"+Server.MapPath("/")+"'"
			logger((e.number & 0xFFFF).toString(16) + " " + e.description + dump);
			result = "File failed";
		}
	}
	
	if (go=="CUSTOM1")
	{	
		result = "nothing done.";
	}
	
%>

<html>
<head>
	<meta NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
	<meta http-equiv="content-type" content="text/html;charset=iso-8859-1">
	<title>DBtest</title>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-control" content="private">
	<meta http-equiv="Expires" content="0">
</head>

<body text="#333333" bgcolor="#669dce" link="#003366" alink="#cccccc" vlink="#336699" TOPMARGIN="0" LEFTMARGIN="0" RIGHTMARGIN=0 BOTTOMMARGIN=0">

<form name="view" METHOD="post">


<CENTER>
<table cellspacing="0" cellpadding="0"><tr><td>

<table width="100%">
	<tr>
		<td align=middle>
				<table><tr>
				<td>
					<select name='Conn' size='"<%=oCO.choice.length%>"' title='"Choose your Connection"' onchange=document.view.Conn_input.value='';document.view.submit()>
						<%=choice%>
					</select>
				</td>
				<td>
					<input type="button" value="Open" onclick=document.view.go.value='OPEN';document.view.submit()>	
				</td>
				<td>
					<input type="button" value="Select" onclick=document.view.go.value='SELECT';document.view.submit()>	
				</td>
				<td>
					<input type="button" value="Insert" onclick=document.view.go.value='INSERT_DELETE';document.view.submit()>	
				</td>
				<td>
					<input type="button" value="DBFile" onclick=document.view.go.value='DBFILE';document.view.submit() <%=oCO.DBFile?"":"DISABLED"%>>	
				</td>
				</tr>
				</table>
			
			</td>
	</tr>
	<tr>
		<td height="20" align=middle><TEXTAREA COLS=50 WRAP=off name="Conn_input"><%=Conn_input%></TEXTAREA></td>
	</tr>
	<tr>
		<td align=middle><TEXTAREA COLS=50 ROWS=10 WRAP=off id=textarea2 name=textarea2><%=log%></TEXTAREA></td>
	</tr>
	<tr>
		<td align=middle><font size=5><I><%=result%></I> </FONT></td>
	</tr>	
</table>
</CENTER>

<input type="hidden" name="go" value="">

</form>

</body>
</html>