<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<link rel="stylesheet" href="../includes/style.css" type="text/css">
<style>
A
{
	font-size:80%;
	font-family:Verdana;
}
A.on:link
{
	text-decoration: none;
	font-family:Arial;
	color:#607888;
}
A.sum:link
{
	text-decoration: none;
	font-family:Arial;
	color:#208020;
}
A.hid:link
{
	text-decoration: none;
	font-family:Arial;
	color:#F0E0E0;
}
A.met:link
{
	text-decoration: none;
	font-family:Arial;
	color:#C0C8D8;
}
</style>

<%
	var act = Request.QueryString("act").Item;
	var thisid = act?("action=#l"+act.substring(1,act.length).toString(10).decrypt("nicnac")):"";
%>

<form method=post <%=thisid%>>
<br>
<input type=submit name=actbutton value=save> <input type=submit name=actbutton value=cancel>
<br>
<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	
	
	var bDebug 		= false;
	var bShowSQL 	= false;
	
	var rev_type 		= 14;
	var bTypeBox 		= true;
	var tablename		= "reviewtype"
	
	var allow_types = new Array();
	if(bTypeBox==false)
	{
		_doctypes =  ["dummy"];
		topicnames = [rev_type+"_"]
	}
	
	var j=0;
	for(var i=0;i<_doctypes.length;i++)
		if(_doctypes[i])
			allow_types[j++] = Number(topicnames[i].substring(0,topicnames[i].indexOf("_")));

	
	var sessionname = "tree_data"+_dir+rev_type
	var cur_rev_type = 0;

	var oGUI = new GUI();
	var _uid = Session("uid");

	var oDB = new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(_uid);
	
	var level_sel = "_admin";
	
	if (oDB.loginValid()==false || oDB.permissions([zerofill(rev_type,2)+level_sel])==false)
		Response.Redirect("index.asp")

	var languages = oDB.getSetting(zerofill(rev_type,2)+"_L");
	var bSubmitted = Request.TotalBytes==0?false:true;
	var area_data = area_data
	
	// GET SESSION INFORMATION
	var cSep  = ';';
	var data  = Session(sessionname)?Session(sessionname).split(cSep):new Array();
	var bData = Session(sessionname)?true:false;	

	// INITIALISE TREE
	var oTREE		= new oGUI.TREE();
	oTREE.init();
	oTREE.bDebug = bDebug;
		
	// GET FORM PARAMETERS
	
	var actbutton  = Request.Form("actbutton").Item;
	var editbox	   = Request.Form("editbox").Item;
	var typebox	   = Request.Form("typebox").Item;
	var checkboxes = Request.Form("checkboxes").Item;
	
	// GET CHECKBOX FORM PARAMETERS 
	var checkarr =    _T["admin_treebit_tips"];
	var checktitles = _T["admin_treebit_titles"];
   
	var checkformarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		checkformarr[new String(checkarr[i])] = Request.Form("chk_"+checktitles[i]).Item;

	// GENERATE CHECKBOX ARRAY PARAMETERS

	var pubarr = new Array();
	for (var i=0;i<checkarr.length;i++)
		if (checkformarr[checkarr[i]])
		{
			var tmp = checkformarr[new String(checkarr[i])].split(",");
			for (var j=0 ; j<tmp.length ; j++)
				pubarr[new Number(tmp[j])] = pubarr[new Number(tmp[j])]?(pubarr[new Number(tmp[j])] + (1<<i)):(1<<i);
		}
	
	// INITIALISE DOCUMENT TYPES
	var doctype = new Array();
	var doctype_i = 0;
	for(var i=0;i<_doctypes.length;i++)
	{
		if(_doctypes[i])
		{
			doctype[doctype_i++] = Number(topicnames[i].substring(0,topicnames[i].indexOf("_")));
			doctype[doctype_i++] = _doctypes[i];
		}
	}

	
	// SELECT QUERY
	var enumcatfld = new Array();
	var catfld  = new Array("rt_id","rt_parent_id","rt_index","1 as rt_level","rt_name","rt_typ","rt_pub");
	var namefld = new Array("rt_id","rt_parent_id","rt_index",""             ,"rt_name","rt_typ","rt_pub");	
	var typefld = new Array("number","number"     ,"number"  ,"number"       ,"string"						,"number","number");
	var sSQL = "select "+catfld.join(",")+" from "+_db_prefix+tablename+" where rt_dir_lng = \""+_dir+"\" and rt_typ in (0,"+allow_types.join(",")+")";
	if(bShowSQL)
		Response.Write(sSQL)
	for (var i=0; i<catfld.length ; i++)
		enumcatfld[catfld[i]] = i;

	oTREE.in_interleave = catfld.length;

	// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
	if(bDebug)
	{
		for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
		{
			for( var _l=0;_l<oTREE.in_interleave;_l++)
				Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
			Response.Write("<br>")
		}
		Response.Write("<br>");
	}
	// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						

	switch(actbutton)
	{
		case "cancel": bData = false; break;
		case "ignore": act = ""; break;
		case "import (.csv)":
			var areadata = Request.Form("area_data").Item;
			Response.Write("NEW TREE LOADED FROM EXTERNAL DATA<br>");

			if(areadata)
				data = csv2array(areadata.replace(/\r\n/g,","),",",true);
			else
				data = new Array();

			Session(sessionname) = data.join(",");
			bData = true;
			act ="";
		break;
		case "export (.csv)":
				var j=0;
				var exportdat = new Array();
				for(var i=0;i<data.length;i++)
				{
					var bQuote = data[i] && typeof(data[i])=="string" && (data[i].indexOf(",")>=0 || data[i].indexOf("\"")>=0)?true:false
					var bNewLine = (i%oTREE.in_interleave)==0 && i>0;
					var val = (bNewLine?"\r\n":"") +(bQuote?("\""+data[i].replace(/"/g,"\"\"")+"\""):data[i]);
					
					if(bNewLine)
						exportdat[j-1] += val;
					else
						exportdat[j++] = val;
				}
				Response.Write("<textarea name=area_data style=width:500;height:300;>"+exportdat.join(",")+"</textarea><br><input type=submit name=actbutton value='import (.csv)'><br><br>");
		break;
		case "export (.xml)":
				var j=0;
				var spc = "                                                                ";
				var exportdat = new Array();
				exportdat[j++] = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<ROOT>\r\n  <row>"
				for(var i=0;i<data.length;i+=oTREE.in_interleave)
				{
					var bQuote = data[i] && typeof(data[i])=="string" && (data[i].indexOf(",")>=0 || data[i].indexOf("\"")>=0)?true:false
					var lev = Number(data[i+3])
					exportdat[j++] = spc.substring(0,lev*2)+"  <field id=\""+data[i]+"\" pub=\""+data[i+6]+"\" name=\""+data[i+4]+"\">";
					if(lev==Number(data[i+3+oTREE.in_interleave]))
						exportdat[j-1] += "</field>";
					else if(lev>Number(data[i+3+oTREE.in_interleave]) || !data[i+3+oTREE.in_interleave])
						exportdat[j-1] += "</field>\r\n"+spc.substring(0,lev*2)+"</field>";
						
				}
				exportdat[j++] = "  </row>\r\n</ROOT>"
				Response.Write("<textarea name=area_data style=width:500;height:300;>"+exportdat.join("\r\n")+"</textarea><br><input type=submit name=actbutton value='import (.csv)'><br><br>");
		break;		
		case "save":
			// SAVE TO DATABASE

			if (level_sel == "_admin" || level_sel == "_edit")
			{
			
				// INSERT DUMMY IF EMPTY
				if(data.length==0)
				{
					len=1;
					
					var last_id = oDB.get("SELECT MAX(rt_id) FROM "+_db_prefix+tablename);
					last_id = last_id?(Number(last_id)+1):1;
					
					data[enumcatfld["rt_id"]]			= last_id;
					data[enumcatfld["rt_parent_id"]]	= last_id;
					data[enumcatfld["rt_index"]]		= 1;
					data[enumcatfld["1 as rt_level"]]	= 0;
					data[enumcatfld["rt_name"]]			= "*** CLICK HERE ***";
					data[enumcatfld["rt_typ"]]			= bTypeBox==true?0:rev_type;
					data[enumcatfld["rt_pub"]]			= 0;
				}	

				// INDEXING FORM DATA
				var index_formdata = new Array();
				for(var i=0;i<data.length;i+=oTREE.in_interleave)
					index_formdata[data[i]] = i;
					
				// INDEXING DATABASE DATA
				var index_dbdata = new Array();
				var dbdata = oDB.getrows(sSQL);
				for(var i=0;i<dbdata.length;i+=oTREE.in_interleave)
					index_dbdata[dbdata[i]] = i;

				var len = index_formdata.length;
				if(index_formdata.length < index_dbdata.length)
					len = index_dbdata.length;
			
				// PREPARE INSERT STATEMENT
				//var botharr = new Array();
				//for (var i=1;i<catfld.length;i++)
				//	botharr[i-1] = catfld[i] + "=\"" + (typeof(data[i])=="string"?data[i].replace(/\x22/g,"\\\""):data[i]) + "\"" 
			
			
				// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
				//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
				//{
				//	for( var _l=0;_l<oTREE.in_interleave;_l++)
				//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
				//	Response.Write("<br>")
				//}
				//Response.Write("<br>");
				// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						
				
				for(var i=0;i<len;i++)
				{
					// FIND DIFFERENCES BETWEEN FORMDATA AND DBDATA
					var bFound = false;
					for(var j=1;j<oTREE.in_interleave;j++)
						if(data[index_formdata[i]+j] != dbdata[index_dbdata[i]+j])
							bFound = true;
							
					if(bFound)
					{
						//Response.Write( typeof(data[index_formdata[i]]) + " " + typeof(dbdata[index_dbdata[i]]) + "<br>" );
						//Response.Write( index_formdata[i] + " " + index_dbdata[i] + "<br>" );
						
						var sel = (typeof(data[index_formdata[i]])=="undefined"?1:0)
								 +(typeof(dbdata[index_dbdata[i]])=="undefined"?2:0)
						
						switch(sel)
						{
							case 0: // UPDATE
								// PUT SINGLE-QUOTES AROUND STRING VALUES
								var tmpdata = new Array();
								var k =0;
								for(var j=0;j<oTREE.in_interleave;j++)
								{
									//Response.Write(data[index_formdata[i]+j]+" = "+dbdata[index_dbdata[i]+j]+"<br>")
									if(data[index_formdata[i]+j] != dbdata[index_dbdata[i]+j] && j!=3 /* skip rt_level column */)
										if(typefld[j]=="string")
											tmpdata[k++] = namefld[j]+"='"+(data[index_formdata[i]+j]?data[index_formdata[i]+j].replace(/\x27/g,"\\'"):"")+"'";
										else
											tmpdata[k++] = namefld[j]+"="+(data[index_formdata[i]+j]?data[index_formdata[i]+j]:"0");
								}
								if(tmpdata.length>0)
								{
									SQL = "update "+_db_prefix+tablename+" set "+tmpdata.join(",")+" where rt_id="+dbdata[index_dbdata[i]];
									if(bShowSQL)
										Response.Write(SQL+"<br>");
									oDB.exec(SQL);
								}
							break;
							case 1:	// DELETE
								SQL = "delete from "+_db_prefix+tablename+" where rt_id="+dbdata[index_dbdata[i]];
								
								if(bShowSQL)
									Response.Write(SQL+"<br>");
								oDB.exec(SQL);
							break;
							case 2:	// INSERT
								// PUT SINGLE-QUOTES AROUND STRING VALUES
								var tmpdata = new Array();
								var k =0;
								
								var last_id = oDB.get("SELECT MAX(rt_id) FROM "+_db_prefix+tablename);
								tmpdata[k++] = namefld[0]+"="+(last_id?(Number(last_id)+1):"0");
								
								for(var j=1;j<oTREE.in_interleave;j++)
									if(j!=3 /* skip rt_level column */)
										if(typefld[j]=="string")
											tmpdata[k++] = namefld[j]+"='"+(data[index_formdata[i]+j]?data[index_formdata[i]+j].replace(/\x27/g,"\\'"):"")+"'";
										else
											tmpdata[k++] = namefld[j]+"="+(data[index_formdata[i]+j]?data[index_formdata[i]+j]:"0");
											
								tmpdata[k++] = "rt_dir_lng = \""+_dir+"\"";
								
								
								//Response.Write("("+index_formdata[i]+")<br>");
								SQL = "insert into "+_db_prefix+tablename+" set "+tmpdata.join(",");
								
								if(bShowSQL)
									Response.Write(SQL+"<br>");
								oDB.exec(SQL);
							break;
						}
						
						//Response.Write( data[index_formdata[i]+4] + " " + dbdata[index_dbdata[i]+4] + "<br>" );
					}
					
				}
			}

			act = "";
			bData = false;
		break;
	}
	
	var thisid = 0;
	var thisact = "";
	if (act && data)
	{
		var thisact = act.charAt(0);
		thisid  = act.substring(1,act.length).toString(10).decrypt("nicnac");
		
		oTREE.indexit(data);
		cur_rownr = oTREE.index[thisid];   // fill the id, and you get the rownumber
			
		if(cur_rownr >= 0 && actbutton == "ok")
			switch(thisact)
			{
				case "e":	// E D I T
						thisact = "";
						data[cur_rownr+4] = editbox;
						data[cur_rownr+5] = typebox;
						data[cur_rownr+6] = pubarr[thisid];
				break;
				case "d":	// D E L E T E   R O O T  +  C H I L D S
				case "x":   // D E L E T E   C H I L D S
					
					// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
					//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
					//{
					//	for( var _l=0;_l<oTREE.in_interleave;_l++)
					//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
					//	Response.Write("<br>")
					//}
					//Response.Write("<br>");
					// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////								
			
					oTREE.childsof(thisid,data);   //  >> this.childs
					oTREE.brothersof(thisid,data); //  >> this.brothers
					
					var cur_index = data[cur_rownr+2];
					
					if(thisact=="d")
						delete_arr(oTREE.childs.concat(cur_rownr));   // DELETE CHILDS + ROOT
					else
						delete_arr(oTREE.childs);   // DELETE CHILDS ONLY
					
					oTREE.index.length = 0;
					oTREE.indexit(data);
					
					// TODO PUSH BROTHERS UP > cur_index !!!!!!
					// PLEASE TEST THIS WHILE DELETING CHILDS NODES AND ROOT NODES !
					//Response.Write(oTREE.brothers+"<br>");
					
					if(thisact=="d" && oTREE.brothers)
						for(var i=0;i<oTREE.brothers.length;i++)
						{
							var cur_rownr = oTREE.index[oTREE.brothers[i]];
							if (Number(data[cur_rownr+2]) > Number(cur_index))
								data[cur_rownr+2]--;  // PUSH BROTHERS INDEX UP IF > cur_index
						}
					
					//Response.Write("current index = "+cur_index+"<br>");
					function delete_arr(arr)   // DELETE ARRAY OF TREE ELEMENTS
					{
						// INDEXING
						var indexarr = new Array();
						for(var j=0;j<arr.length;j++)
							indexarr[arr[j]] = true;
							
						var k = 0;
						for(var j=0;j<data.length;j+=oTREE.in_interleave)
						{
							if(indexarr[j] != true) // KEEP THIS ONE ?
							{
								for(var l=0;l<oTREE.in_interleave;l++)
									data[k+l] = data[j+l];  // COPY DATA
								k += oTREE.in_interleave
							}
							
							
						}
						data.length = k; // TRUNCATE ARRAY
					}
					
					// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
					//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
					//{
					//	for( var _l=0;_l<oTREE.in_interleave;_l++)
					//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
					//	Response.Write("<br>")
					//}
					//Response.Write("<br>");
					// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						
					thisact = "";
					
				break;
				case "b":	// I N S E R T   B E F O R E
						thisact = "";
						
						var maxid = 0						
						var cur_parent = 0;
						var cur_index = 0;
						var new_index= 0;
						
						for(var i=0;i<data.length;i+=oTREE.in_interleave)
						{
							// FIND MAXIMUM INDEX NUMBER + 1 (TO APPEND)
							if(Number(data[i])>maxid)
								maxid = Number(data[i]);
							if (data[i]==thisid)
							{
								cur_parent = data[i+1];
								cur_index  = data[i+2];	
							}
						}
						maxid++;
						
						
						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
						//	Response.Write("<br>")
						//}
						//Response.Write("<br>");
						// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						
						
						var bParentNode = cur_parent==thisid;
						if(bParentNode)
						{
							// INCREMENT ALL APPENDED PARENTNODE INDEXES ???							
							new_index = Number(data[cur_rownr+2]);
							for(var i=0;i<data.length;i+=oTREE.in_interleave)
							{
								if(data[i]==data[i+1] /* FIND ALL PARENTNODES */ && Number(data[i+2]) >= Number(data[cur_rownr+2]) /* ONLY PUSH HIGHER INDEXES DOWN */)
									data[i+2]++; // PUSH INDEXES ONE DOWN
							}
						}
						else
						{
							// INCREMENT ALL APPENDED INDEXES (WHICH HAVE SAME REFID) IF INDEX+1 EXISTS ???							
							new_index = Number(data[cur_rownr+2]);
							for(var i=0;i<data.length;i+=oTREE.in_interleave)
							{
								if(data[cur_rownr+1]==data[i+1] /* FIND ALL TUPPLES FROM THE SAME PARENT ID */ && Number(data[i+2]) >= Number(data[cur_rownr+2]) /* ONLY PUSH HIGHER INDEXES DOWN */ && data[i]!=data[i+1] /* BUGFIX: ROOT ELEMENT HAS THE SAME PARENT, MAYBE EVEN HAVING A HIGHER INDEX, BUT MAY NOT BE PUSHED DOWN !! */)
									data[i+2]++; // PUSH INDEXES ONE DOWN
							}
						}
						
						var e = data.length; // ARRAY APPENDIX POSITION
						
						for(var i=0;i<oTREE.in_interleave;i++)  // FILL DUMMY DATA
							data[e+i] = "";
						
						data[e] = maxid;
						data[e+1] = bParentNode==true?maxid:cur_parent;
						data[e+2] = new_index;
						data[e+3] = 1;
						data[e+4] = editbox;
						
						Session(sessionname) = data;	
						
						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
						//	Response.Write("<br>");
						//}
						//Response.Write("<br>");
				break;
				case "a":	// I N S E R T   A F T E R
						thisact = "";
						
						var maxid = 0						
						var cur_parent = 0;
						var cur_index = 0;
						var new_index= 0;
						
						for(var i=0;i<data.length;i+=oTREE.in_interleave)
						{
							// FIND MAXIMUM INDEX NUMBER + 1 (TO APPEND)
							if(Number(data[i])>maxid)
								maxid = Number(data[i]);
							if (data[i]==thisid)
							{
								cur_parent = Number(data[i+1]);
								cur_index  = Number(data[i+2]);	
							}
						}
						maxid++;
						
						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
						//	Response.Write("<br>")
						//}
						//Response.Write("<br>");
						// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						
						
						var bParentNode = cur_parent==thisid;
						if(bParentNode)
						{
							// INCREMENT ALL APPENDED PARENTNODE INDEXES ???							
							new_index = Number(data[cur_rownr+2])+1;
							for(var i=0;i<data.length;i+=oTREE.in_interleave)
							{
								if(data[i]==data[i+1] && Number(data[i+2]) > Number(data[cur_rownr+2]))
									data[i+2]++; // PUSH INDEXES ONE DOWN
							}
						}
						else
						{
							// INCREMENT ALL APPENDED INDEXES (WHICH HAVE SAME REFID) IF INDEX+1 EXISTS ???							
							//Response.Write("(<b>"+(cur_rownr+2)+"</b>)")
							new_index = Number(data[cur_rownr+2])+1;
							//Response.Write("(<b>push all indexes down from index="+data[cur_rownr+2]+"</b>)<br>")
							
							for(var i=0;i<data.length;i+=oTREE.in_interleave)
							{
								if(data[cur_rownr+1]==data[i+1] /* FIND ALL TUPPLES FROM THE SAME PARENT ID */ && Number(data[i+2]) > Number(data[cur_rownr+2]) /* ONLY PUSH HIGHER INDEXES DOWN */ && data[i]!=data[i+1] /* BUGFIX: ROOT ELEMENT HAS THE SAME PARENT, MAYBE EVEN HAVING A HIGHER INDEX, BUT MAY NOT BE PUSHED DOWN !! */)
								{
									if(bDebug)
										Response.Write("push down '"+data[i+4]+"' (index="+data[i+2]+")<br>");
									data[i+2]++; // PUSH INDEXES ONE DOWN
								}
							}
						}
						
						var e = data.length; // ARRAY APPENDIX POSITION
						
						for(var i=0;i<oTREE.in_interleave;i++)
							data[e+i] = "";
							
						data[e] = maxid;
						data[e+1] = bParentNode==true?maxid:cur_parent;
						data[e+2] = new_index;
						data[e+3] = 1;
						data[e+4] = editbox;
						
						Session(sessionname) = data;					
						
						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
						//	Response.Write("<br>");
						//}
						//Response.Write("<br>");
						// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						
				break;
				case "f":	// B R A N C H
						//thisact = "";


						var maxid = 0
						for(var i=0;i<data.length;i+=oTREE.in_interleave)
						{
							// FIND MAXIMUM INDEX NUMBER + 1 (TO APPEND)
							if(Number(data[i])>maxid)
								maxid = Number(data[i]);
						}
						maxid++;

						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;");
						//	Response.Write("<br>")
						//}
						//Response.Write("<br>");
						// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						

						var bChilds = false;
						var child_indexnr_max = 0;
						for(var j=0;j<data.length;j+=oTREE.in_interleave)
							if (data[j+1]==data[cur_rownr] && data[j]!=data[j+1])
							{
								bChilds = true;
								if(Number(data[j+2])>child_indexnr_max)
									child_indexnr_max = Number(data[j+2]);
							}

						if(bChilds==true)
						{
							//Response.Write( box_on+tab+"<b>add to index "+child_indexnr_max+" ?</b><br>"+box_off);
							var e = data.length; // ARRAY APPENDIX POSITION
							
							for(var i=0;i<oTREE.in_interleave;i++)
								data[e+i] = "";						
							
							data[e] = maxid;
							data[e+1] = data[cur_rownr];
							data[e+2] = child_indexnr_max+1;
							data[e+3] = 1;
							data[e+4] = editbox;
							data[e+5] = typebox;
							data[e+6] = pubarr[thisid];
							Session(sessionname) = data;						
						}
						else
						{
							var e = data.length; // ARRAY APPENDIX POSITION
							
							for(var i=0;i<oTREE.in_interleave;i++)
								data[e+i] = "";						
							
							data[e] = maxid;
							data[e+1] = data[cur_rownr];
							data[e+2] = 1;
							data[e+3] = 1;
							data[e+4] = editbox;
							data[e+5] = typebox;
							data[e+6] = pubarr[thisid];
							Session(sessionname) = data;
						}	

						// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
						//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
						//{
						//	for( var _l=0;_l<oTREE.in_interleave;_l++)
						//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
						//	Response.Write("<br>");
						//}
						//Response.Write("<br>");
						// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////
				break;
				case "c":	// C S V  B R A N C H
					//thisact = "";
						
					var maxid = 0						

					for(var i=0;i<data.length;i+=oTREE.in_interleave)
					{
						// FIND MAXIMUM INDEX NUMBER + 1 (TO APPEND)
						if(Number(data[i])>maxid)
							maxid = Number(data[i]);
					}
					maxid++;

					// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
					//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
					//{
					//	for( var _l=0;_l<oTREE.in_interleave;_l++)
					//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;");
					//	Response.Write("<br>")
					//}
					//Response.Write("<br>");
					// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						

					// P A R S E   C S V
					var csvarr = csv2array(editbox);
						
					// START ADDING	
					var bChilds = false;
					var child_indexnr_max = 0;
					for(var j=0;j<data.length;j+=oTREE.in_interleave)
						if (data[j+1]==data[cur_rownr] && data[j]!=data[j+1])
						{
							bChilds = true;
							if(Number(data[j+2])>child_indexnr_max)
								child_indexnr_max = Number(data[j+2]);
						}

					if(bChilds==true)
					{
						//Response.Write( box_on+tab+"<b>add to index "+child_indexnr_max+" ?</b><br>"+box_off);
						var e = data.length; // ARRAY APPENDIX POSITION
								
						for(var i=0;i<oTREE.in_interleave;i++)
							data[e+i] = "";						
								
						for(var csv_i=0;csv_i<csvarr.length;csv_i++)
						{
							data[e] = maxid;
							data[e+1] = data[cur_rownr];
							data[e+2] = child_indexnr_max+1+csv_i;
							data[e+3] = 1;
							data[e+4] = csvarr[csv_i];
							data[e+5] = typebox;
							data[e+6] = pubarr[thisid];
							Session(sessionname) = data;
							maxid++;
							e+=oTREE.in_interleave;
						}					
					}
					else
					{
						var e = data.length; // ARRAY APPENDIX POSITION
								
						for(var i=0;i<oTREE.in_interleave;i++)
							data[e+i] = "";						
								
						for(var csv_i=0;csv_i<csvarr.length;csv_i++)
						{
							data[e] = maxid;
							data[e+1] = data[cur_rownr];
							data[e+2] = 1+csv_i;
							data[e+3] = 1;
							data[e+4] = csvarr[csv_i];
							data[e+5] = typebox;
							data[e+6] = pubarr[thisid];
							Session(sessionname) = data;
							maxid++;
							e+=oTREE.in_interleave;
						}
					}

					// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
					//for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
					//{
					//	for( var _l=0;_l<oTREE.in_interleave;_l++)
					//		Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
					//	Response.Write("<br>");
					//}
					//Response.Write("<br>");
					// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////
					
				break;
			}
	}
	
	
	// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
	if(bDebug)
	{
		for(var _k=0;_k<data.length;_k+=oTREE.in_interleave)
		{
			for( var _l=0;_l<oTREE.in_interleave;_l++)
				Response.Write("("+(_k+_l)+") "+data[_k+_l]+"&nbsp;&nbsp;")
			Response.Write("<br>")
		}
		Response.Write("<br>");
	}
	// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////						

	
	Response.Write(bData==true?"":"NEW TREE LOADED FROM THE DATABASE<br>");	

	// GET FROM DATABASE
	var categories = bData==true ? data : oDB.getrows(sSQL);
	
	//Response.Write(categories.join("<br>"))	
		
	// FILL NULL-FIELDS WITH ID (NULL FIELDS CANNOT BE SORTED PROPERLY)
	var id_enum = enumcatfld["rt_id"];
	var txt_enum = enumcatfld["rt_name"];
	for (var i=0;i<categories.length;i+=catfld.length)
		if(!categories[i+txt_enum])
			categories[i+txt_enum] = "["+categories[i+id_enum]+"]";
		
	if (bData==false)
		data = categories;
	Session(sessionname) = categories.join(cSep);
	
	// BUILD TREE
	var tree		   = oTREE.load(categories);
	//var rev_categories = oTREE.combobox("name=category size=1");

	// INIT
	var attr = "name=category size=1";
	var dflt = "";

	var interval = 3;
	var indent = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

	oTREE.indexit(data);
	
	////////////////////////////////
	//  D I S P L A Y   T R E E   //
	////////////////////////////////
	
	var ordered_data = new Array();
	var ordered_data_i = 0;
	
	for (var i=0;i<oTREE.treedata.length;i+=oTREE.out_interleave)
	{
		//var prev_level = oTREE.treedata[i+1-oTREE.out_interleave];
		//var curr_level = oTREE.treedata[i+1];
		//var next_level = oTREE.treedata[i+1+oTREE.out_interleave];

		var id = oTREE.treedata[i];
		var midpagepos = (i/oTREE.out_interleave)>=10?oTREE.treedata[i-(10*oTREE.out_interleave)]:oTREE.treedata[0];
		var txt = "";
		var btn = "";
		var tab = indent.substring(0,(oTREE.treedata[i+1]-1)*18);
		 
		for(var j=0;j<oTREE.in_interleave;j++)
			ordered_data[ordered_data_i++] = data[oTREE.index[id]+j];
		// IS THERE AN ALTERNATE METHOD TO DO THIS FASTER LIKE TRUNC - CONCAT ??
		 
		if(thisid == id)
		{
			if(thisact=="t")
				Session("tree_textmode") = Session("tree_textmode")=="true" ? "false" : "true";

			if(Session("tree_textmode")=="true")
				var btn = "&nbsp;<a href=?act=e"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[edit]</a>"
				+"&nbsp;<a href=?act=b"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[insert before]</a>"
				+"&nbsp;<a href=?act=a"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[insert after]</a>"
				+"&nbsp;<a href=?act=d"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[delete root & childs]</a>"
				+"&nbsp;<a href=?act=x"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[delete childs only]</a>"
				+"&nbsp;<a href=?act=f"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[add child]</a>"
				+"&nbsp;<a href=?act=c"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[add csv child array]</a>"
				+"&nbsp;<a href=?act=p"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">[edit treepart]</a>"
				+"&nbsp;<a href=14_admin.asp?cat="+id.toString(10).encrypt("nicnac")+" target=_blank>[attachment]</a>"
				+"&nbsp;<a href=?act=t"+id.toString(10).encrypt("nicnac")+">gfxmode</a>";				
			else
				var btn = "&nbsp;<a href=?act=e"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_edit.gif\" title=\"edit\" border=0></a>"
				+"&nbsp;<a href=?act=b"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_insert_before.gif\" title=\"insert before\" border=0></a>"
				+"&nbsp;<a href=?act=a"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_insert_after.gif\" title=\"insert after\" border=0></a>"
				+"&nbsp;<a href=?act=d"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_delete.gif\" border=0 title=\"delete root & childs\"></a>"
				+"&nbsp;<a href=?act=x"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_delete2.gif\" border=0 title=\"delete childs only\"></a>"
				+"&nbsp;<a href=?act=f"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_branch.gif\" border=0 title=\"add child\"></a>"
				+"&nbsp;<a href=?act=c"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_branch2.gif\" border=0 title=\"add csv child array\"></a>"
				+"&nbsp;<a href=?act=p"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_partedit.gif\" border=0 title=\"edit treepart\"></a>"
				+"&nbsp;<a href=14_admin.asp?cat="+id.toString(10).encrypt("nicnac")+" target=_blank><IMG SRC=\"../images/ii_attach.gif\" border=0 title=\"attachment\"></a>"
				+"&nbsp;<a href=?act=t"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">textmode</a>";

			var box_on  = "<div style='border:solid #BDBABD 1px;padding:10px;background-color:#F7F3EF'>";
			var box_off = "</div>";

			if(bTypeBox)
			{
				var doctypesel = "<select name=typebox>\r\n";
				for(var dt=0;dt<doctype.length;dt+=2)
					doctypesel += " <option value="+doctype[dt]+(data[oTREE.index[id]+5]==doctype[dt]?" SELECTED":"")+">"+_T[doctype[dt+1]]+"\r\n"
				doctypesel += "</select>\r\n"
			}
			else
				var doctypesel = "<input name=typebox type=hidden value="+data[oTREE.index[id]+5]+">";

			switch(thisact)
			{
				case "e":
				{
					// JOIN THE OTHER DATA VALUES (NOT HELD BY THE TREE)
					var rt_par = data[oTREE.index[id]+1];
					var rt_idx = data[oTREE.index[id]+2];
					var rt_typ = data[oTREE.index[id]+5];
					var rt_pub = data[oTREE.index[id]+6];

					var checkboxes = "";
					for(var j=0;j<checkarr.length;j++)
						checkboxes += tab+"<input type=checkbox name=chk_"+checktitles[j]+" value="+id+" "+((rt_pub & (1<<j))?"checked":"")+">["+_T["admin_treebit_tips"][j]+"]"
	
					txt = box_on 
						  +(bDebug?(tab+"<b>"+msg+" "+id+"&gt;</b> (index="+rt_idx+") (parent="+rt_par+")<a name=l"+id+"></a><br>"):"")
						  +tab+doctypesel+"[type] ("+id+")<br>"
						  +tab+"<input name=editbox value='"+(oTREE.treedata[i+2]?oTREE.treedata[i+2].replace(/\x27/g,"&#039;"):"")+"' size=19>[text]<br>"
						  +checkboxes+"<br>"
						  +tab+"<input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"
						  +box_off;
				}
				break;
				case "d":
					txt = box_on+tab+"<b>delete root & childs&gt;</b> <a name=l"+id+"></a>"+oTREE.treedata[i+2]+" <input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"+box_off;
				break;
				case "x":
					txt = box_on+tab+"<b>delete childs only&gt;</b> <a name=l"+id+"></a>"+oTREE.treedata[i+2]+" <input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"+box_off;
				break;
				case "b":
					txt = box_on+tab+"<b>insert before&gt;</b> <a name=l"+id+"></a><input name=editbox value=''> <input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"
						 +tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>"+box_off;
				break;
				case "a":
					txt = box_on+tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>"
						+tab+"<b>insert after&gt;</b> <a name=l"+id+"></a><input name=editbox value=''> <input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"+box_off;
				break;
				case "f":
				case "c":
					var bChilds = false;
					
					//Response.Write("look for ("+data[cur_rownr]+")")
					/*
					for(var j=0;j<data.length;j+=oTREE.in_interleave)
						if (data[j+1]==data[cur_rownr] && data[j]!=data[j+1])
							bChilds = true;

					if(bChilds==true) 
						txt = box_on+tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+btn+"<br>"
							+tab+"<b>branched already</b><br>"+box_off;
					else
					*/
					
					var bChilds = false;
					var child_indexnr_max = 0;
					for(var j=0;j<data.length;j+=oTREE.in_interleave)
						if (data[j+1]==data[cur_rownr] && data[j]!=data[j+1])
						{
							bChilds = true;
							if(Number(data[j+2])>child_indexnr_max)
								child_indexnr_max = Number(data[j+2]);
						}					
					
					var rt_par = data[oTREE.index[id]];
					var rt_idx = child_indexnr_max + 1;
					var rt_pub = 0;
					
					var tab1 = indent.substring(0,(oTREE.treedata[i+1]-2)*18);
					
					var checkboxes = "";
					for(var j=0;j<checkarr.length;j++)
						checkboxes += tab+"<input type=checkbox name=chk_"+checktitles[j]+" value="+id+" "+((rt_pub & (1<<j))?"checked":"")+">["+_T["admin_treebit_tips"][j]+"]"
					
					var msg = thisact=="c"?"add csv child array":"add child";
		
					txt = box_on 
						  +tab1+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>"
						  +(bDebug?(tab+"<b>"+msg+" "+id+"&gt;</b> (index="+rt_idx+") (parent="+rt_par+")<a name=l"+id+"></a><br>"):"")
						  +tab+doctypesel+"[type]<br>"
						  +tab+"<input name=editbox value='' size=19>[text]<br>"
						  +checkboxes+"<br>"
						  +tab+"<input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"
						  +box_off;		
					
					
						//txt = box_on+tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>"
						//	+tab+tab+"<b>branch&gt;</b> <a name=l"+id+"></a><input name=editbox value=''> <input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"+box_off;
				break;
				case "p":

					oTREE.childsof(thisid,data);   //  >> this.childs
					var export_textarea = "";

					for(var j=0;j<oTREE.childs.length;j++)
					{
						for(k=0;k<oTREE.in_interleave;k++)
							if(data[oTREE.childs[j]+k])
								export_textarea += "\""+data[oTREE.childs[j]+k].toString().replace(/\x22/g,"\\\"")+"\",";
							else
								export_textarea += "\"\",";

						export_textarea += "\r\n";
					}
					
					//oTREE.brothersof(thisid,data); //  >> this.brothers
					//var cur_index = data[cur_rownr+2];
					
					//Response.Write(oTREE.childs);   // SHOW CHILDS

					var bChilds = false;
					var child_indexnr_max = 0;
					for(var j=0;j<data.length;j+=oTREE.in_interleave)
						if (data[j+1]==data[cur_rownr] && data[j]!=data[j+1])
						{
							bChilds = true;
							if(Number(data[j+2])>child_indexnr_max)
								child_indexnr_max = Number(data[j+2]);
						}					
					
					var rt_par = data[oTREE.index[id]];
					var rt_idx = child_indexnr_max + 1;
					var rt_pub = 0;
					
					var tab1 = indent.substring(0,(oTREE.treedata[i+1]-2)*18);
					
					var checkboxes = "";
					for(var j=0;j<checkarr.length;j++)
						checkboxes += tab+"<input type=checkbox name=chk_"+checktitles[j]+" value="+id+" "+((rt_pub & (1<<j))?"checked":"")+">["+_T["admin_treebit_tips"][j]+"]"
					
					var msg = "edit treepart";
		
					txt = box_on 
						  +tab1+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>"
						  +(bDebug?(tab+"<b>"+msg+" "+id+"&gt;</b> (index="+rt_idx+") (parent="+rt_par+")<a name=l"+id+"></a><br>"):"")
						  +tab+doctypesel+"[type]<br>"
						  +tab+"<textarea name=editbox style=width:500;height:300;>"+export_textarea+"</textarea>[text]<br>"
						  +checkboxes+"<br>"
						  +tab+"<input type=submit name=actbutton value='ok'> <input type=submit name=actbutton value='ignore'>"+btn+"<br>"
						  +box_off;	
				break;
				default:
					txt =  tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a href=?act=s"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+btn+"<br>"; 
				break;
			}
			//btn = "<tr><td><a href=?act=d"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">Delete</a></td><td><a href=?act=a"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">Add</a></td></tr>";
			//txt = "<table><tr><td>"+txt+"</td><td><a href=?act=e"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_edit.gif\" border=0></a></td><td><a href=?act=b"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_insert_before.gif\" border=0></a></td><td><a href=?act=a"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_insert_after.gif\" border=0></a></td><td><a href=?act=d"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_delete.gif\" border=0></a></td><td><a href=?act=f"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+"><IMG SRC=\"../images/ii_branch.gif\" border=0></a></td></tr></table>";

		}
		else if(id)
		{
			var rt_pub = data[oTREE.index[id]+6];
			var classdef = (rt_pub&1)==1?"class=on":"";
			var classdef = (rt_pub&2)==2?"class=sum":classdef;
			var classdef = (rt_pub&8)==8?"class=hid":classdef;
			var classdef = (rt_pub&16)==16?"class=met":classdef;
					
			txt = tab+"<a name=l"+id+"></a>"+(thisid==id?"<b>":"")+"<a "+classdef+" href=?act=e"+id.toString(10).encrypt("nicnac")+"#l"+midpagepos+">" + oTREE.treedata[i+2] + "</a>"+(thisid==id?"</b>":"")+"<br>";
		}
		if(id)
			Response.Write( txt+"\r\n" );
	}

	//Response.Write("<br>"+Session(sessionname)+"<br>");
	//Response.Write("<br>"+ordered_data.join(";")+"<br>");
	
	// OVERWRITE WITH SORTED DATA (OPTIONAL) 
	Session(sessionname) = ordered_data.join(";")
	
	// ------------------------------------------------------------------------------------------


// 	function csv2array(_csvstr)
//	{
//		var _bQuoted = false;
//		var _acc = "";
//
//		var _arr = _csvstr.split("\"\"");
//		var _output = new Array()
//		var _output_i = 0;
//
//		for(var _i=0;_i<_arr.length;_i++)
//		{
//			var _arr2 = _arr[_i].split("\"");
//			for(var _j=0;_j<_arr2.length;_j++)
//			{
//				var _arr3 = _arr2[_j].split(",");
//				for(var _k=0;_k<_arr3.length;_k++)
//				{
//					if(_bQuoted)
//						_acc += _arr3[_k] + (_k<(_arr3.length-1)?",":"")
//					else
//					{
//						if(_k<(_arr3.length-1))
//						{
//							_output[_output_i++] = _acc + _arr3[_k];
//							_acc = "";
//						}
//						else
//							_acc += _arr3[_k];
//
//					 }
//				}
//				_bQuoted =   _j<(_arr2.length-1)?!_bQuoted:_bQuoted;
//
//				/*   LEAVE UNQUOTED !!!!!!!!
//				if (_j<(_arr2.length-1))
//					_acc += "\""
//				*/
//			}
//		
//			if(_i<(_arr.length-1))
//			_acc += "\\\"";
//		}
//		_output[_output_i++] = _acc;
//		return _output
//	}

	
%>
<br>
<input type=submit name=actbutton value=save> <input type=submit name=actbutton value=cancel>
<br><br>
<input type=submit name=actbutton value="export (.csv)"> <input type=submit name=actbutton value="export (.xml)">
<br>
Size: <%=Session(sessionname)?Session(sessionname).length:0%> Bytes
<br>
<!--
SortLoad: <%=oTREE.sortload%>
-->
<br>
</form>
<!--#INCLUDE FILE = "../skins/adfooter.asp" -->

