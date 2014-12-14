<%
function CO()
{
	this.Conn			= "unknown";
	this.ConnectString	= "unknown";
	this.DBType			= "unknown";
	this.img			= "<img src='images/Powered_By_Unknown.gif'>"
	this.DBserver		= "UNKNOWN";
	this.DBversion		= "";
	this.choice			= new Array (
		"THEARTSERVER_MYSQL_DSNLESS"
		,"THEARTSERVER_REPL_MYSQL_DSNLESS"
		,"COINPETTO_MYSQL_DSNLESS"
		,"DIXYS_SQLSERVER_DSNLESS"
		,"BRAINBRIDGE_SQLSERVER_DSNLESS"
	);
	
	this.get			= COget;
}

function COget(Con)
{
	// DETECT LOGIN PARAMETERS (USED IN TAS_PRESS.ASP)
	if(!Con && typeof(_session)=="object" && _session["Con"])
		Con = _session["Con"];

//Response.Write("<br>con="+Con+"<br>")

	switch (Con)
	{
	
		// USITE WITH THECANDIDATES
		case "THEARTSERVER_MYSQL_DSNLESS":
			this.Conn		= Con;			
			this.ConnectString = "ODBC;driver={mysql};database=pegasus;server=localhost;uid=excalibur;pwd=200Dz4re;DSN=hercules;"			// LOCALE
			this.DBType		= "mySQL";
			this.DBDefault	= "hercules";
			this.DBserver	= "thecandidates.com";
			this.DBrepl     = new Array();
			//this.DBrepl     = new Array("ODBC;driver={mysql};database=hercules;server=86.39.158.41;uid=repl;pwd=xxlrepl00!;port=3307;DSN=repl;")      // REMOTE
		break;
	
		// LEAN USITE WITHOUT THECANDIDATES
	/*
		case "THEARTSERVER_MYSQL_DSNLESS":
			this.Conn		= Con;			
			this.ConnectString = "ODBC;driver={mysql};database=hercules;server=localhost;uid=excalibur;pwd=200Dz4re;DSN=hercules;"			// LOCALE
			this.DBType		= "mySQL";
			this.DBDefault	= "hercules";
			this.DBserver	= "thecandidates.com";
			this.DBrepl     = new Array();
			//this.DBrepl     = new Array("ODBC;driver={mysql};database=hercules;server=86.39.158.41;uid=repl;pwd=xxlrepl00!;port=3307;DSN=repl;")      // REMOTE
		break;
	*/
	
	
		case "THEARTSERVER_REPL_MYSQL_DSNLESS":
			this.Conn		= Con;			
			this.ConnectString = "ODBC;driver={mysql};database=hercules;server=86.39.158.41;uid=repl;pwd=xxlrepl00!;DSN=repl;"			// REMOTE
			this.DBType		= "mySQL";
			this.DBDefault	= "hercules";
			this.DBserver	= "thecandidates.com";
		break;			
		
		case "NSOWHAT_MYSQL_DSNLESS":
			this.Conn		= Con;			
			this.ConnectString = "ODBC;driver={mysql};database=n;server=localhost;uid=bxl;pwd=bxl00!;DSN=n;"			// LOCALE
			this.DBType		= "mySQL";
			this.DBDefault	= "hercules";
			this.DBserver	= "nsowhat.com";
		break;		
		
		case "COINPETTO_MYSQL_DSNLESS":
			this.Conn		= Con;			
			this.ConnectString = "ODBC;driver={mysql};database=coinpetto;server=localhost;uid=coinpetto_query;pwd=xxlcoinpetto;DSN=coinpetto_query;"			// LOCALE
			this.DBType		= "mySQL";
			this.DBDefault	= "coinpetto";
			this.DBserver	= "thecandidates.com";
		break;
		
		case "DIXYS_SQLSERVER_DSNLESS":
			this.Conn		= Con;	
			this.ConnectString = "Provider=SQLOLEDB.1;Password=freddy2009;Persist Security Info=True;User ID=thecandidates;Initial Catalog=DIXYSCOM;Data Source=sql.dixys.com,33003";
			this.DBDefault	= "dixyscom";
			this.DBType		= "SQLServer";
			this.DBserver	= "dixys.com";
		break;
		
		case "BRAINBRIDGE_SQLSERVER_DSNLESS":
			this.Conn		= Con;	
			this.ConnectString = "ODBC;driver={mysql};database=brainbridge;server=86.39.158.41\\SQLEXPRESS;uid=sa;pwd=xxlsa00!;DSN=brainbridge;";
			this.DBDefault	= "brainbridge";
			this.DBType		= "SQLServer";
			this.DBserver	= "thecandidates.com";
		break;
		
	}
}
%>