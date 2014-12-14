<%
	var bSubmitted = Request.TotalBytes==0?false:true;
	var dt = Number(Request.QueryString("dt").Item.toString().decrypt("nicnac"));
	var id = Number(Request.QueryString("id").Item.toString().decrypt("nicnac"));
	var _uid = Session("uid");
	var _dir = Session("dir");
	var act = Request.Form("act").Item;

	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get(Session("con"));
	oDB.getSettings(Session("uid"));
	var bAdmin = oDB.permissions([zerofill(ds_type,2)+"_admin"]);
	var bEdit = oDB.permissions([zerofill(ds_type,2)+"_edit"]);
	var bDelete = oDB.permissions([zerofill(ds_type,2)+"_delete"]);
	
	if (oDB.loginValid()==false || (bAdmin==false && bDelete==false))
		Response.Redirect("index.asp")
		
		Response.Flush()
		
		
	// Q U E R Y   F O R   X M L   T A B L E   D E F I N I T I O N S
	
	var deftablefld = new Array("rev_id","rev_title","rev_url","rev_ref","rev_header","rev_rev","rev_publisher");
	var defenumfld = new Array();
	for (var i=0; i<deftablefld.length ; i++)
		defenumfld[deftablefld[i]] = i;

	var sSQL = "select "+deftablefld.join(",")+" from usite_review where rev_rt_typ = "+ds_type+" and rev_dir_lng = \""+_ws+"\""
	var enum_tabledefs = new Array();
	var tabledefs = oDB.getrows(sSQL);
	for(var j=0;j<tabledefs.length;j+=deftablefld.length)
	{
		enum_tabledefs[tabledefs[j]] = tabledefs.slice(j,j+deftablefld.length);
		//Response.Write("enum_tabledefs["+tabledefs[j]+"] = ("+tabledefs[j+1]+") "+tabledefs[j+deftablefld.length-1]+"<br>")
	}
	
	if(!enum_tabledefs[dt])
	{
		Response.Write("CURRENT TABLE DEFINITION <!--"+dt+"-->DOES NOT EXIST");
		Response.End();
	}

    var true_dt = enum_tabledefs[dt][defenumfld["rev_ref"]]?enum_tabledefs[dt][defenumfld["rev_ref"]]:dt;
	
	
	
	function physdb(tid)
	{
	    var oarr = enum_tabledefs[tid];		
		if(oarr && oarr!=null && oarr[defenumfld["rev_publisher"]])
		{
			var oarrs = oarr[defenumfld["rev_publisher"]].split(",");
			return {"masterdb":(oarrs[0]?oarrs[0]:"dataset"),"detaildb":(oarrs[1]?oarrs[1]:"datadetail"),"filter":(oarrs[2]?oarrs[2]:"")}
		}
		else
			return {"masterdb":"dataset","detaildb":"datadetail"}
	}

	var phys = physdb(true_dt);
	masterdb = phys["masterdb"];
	detaildb = phys["detaildb"];


	
		

	var bUpdateDONE = false;
	if(bSubmitted && act=="save")
	{
		var data1 = oDB.getrows("select ds_id from "+_db_prefix+masterdb+" where ds_id = "+Request.Form("NEWID").Item+" and ds_rev_id = "+true_dt);
		if(detaildb)
			var data2 = oDB.getrows("select rd_recno from "+_db_prefix+detaildb+" where rd_recno = "+Request.Form("NEWID").Item+" and rd_ds_id = "+true_dt);
		
		if(data1.length==0 && data1.length==0)
		{
			var uSQL = "update "+_db_prefix+masterdb+" set ds_id = "+Request.Form("NEWID").Item+" where ds_id = "+id+" and ds_rev_id = "+true_dt			
			if(bDebug)
				Response.Write(uSQL+"<br>");
			oDB.exec(uSQL);
			if(detaildb)
			{
				var uSQL = "update "+_db_prefix+detaildb+" set rd_recno = "+Request.Form("NEWID").Item+" where rd_recno = "+id+" and rd_ds_id = "+true_dt;
				if(bDebug)
					Response.Write(uSQL+"<br>");
				oDB.exec(uSQL);
			}
			bUpdateDONE = true;
			
			id = Request.Form("NEWID").Item;

			Response.Write("<script>"
			 +" try{window.opener.document.main.act.value='';}catch(e){};"
			 +" try{window.opener.document.main.submit();}catch(e){};"
			 +"</script>");			
		}
		else
			Response.Write("THIS ID ALREADY EXISTS !!")
	}
	
	if(bSubmitted && act=="delete after save")
	{
		var sSQL = "select ds_id from "+_db_prefix+masterdb+" where ds_id = "+id+" and ds_rev_id = "+true_dt;
		Response.Write(sSQL)
		var data1 = oDB.getrows(sSQL);
		if(bDebug)
			Response.Write(sSQL+"<br>");
		
		if(detaildb)
		{
			var sSQL = "select rd_recno from "+_db_prefix+detaildb+" where rd_recno = "+id+" and rd_ds_id = "+true_dt
			var data2 = oDB.getrows(sSQL);
			if(bDebug)
				Response.Write(sSQL+"<br>");
		}
		
		if(detaildb)
			Response.Write("<center>"+data1.length+" master records, and "+data2.length+" detail records found</center>")
		else
			Response.Write("<center>"+data1.length+" master records found</center>")
	}
	
	if(bSubmitted && act=="delete")
	{
		var data1 = oDB.getrows("select ds_id from "+_db_prefix+masterdb+" where ds_id = "+id+" and ds_rev_id = "+true_dt);
		var uSQL = "delete from "+_db_prefix+masterdb+" where ds_id = "+id+" and ds_rev_id = "+true_dt			
		//Response.Write(uSQL+"<br>");
		oDB.exec(uSQL);
		
		if(detaildb)
		{
			var data2 = oDB.getrows("select rd_recno from "+_db_prefix+detaildb+" where rd_recno = "+id+" and rd_ds_id = "+true_dt);		
			var uSQL = "delete from "+_db_prefix+detaildb+" where rd_recno = "+id+" and rd_ds_id = "+true_dt;
			//Response.Write(uSQL+"<br>");
			oDB.exec(uSQL);
		}

		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");	

		if(detaildb)
			Response.Write("<center>"+data1.length+" master records, and "+data2.length+" detail records sucessfully deleted</center>")		
		else
			Response.Write("<center>"+data1.length+" master records sucessfully deleted</center>")
	}
	var newID = Request.Form("NEWID").Item?Number(Request.Form("NEWID").Item):id;
	
	if(act==_T["admin_moveup"] && newID>1 )
		newID--;
	else if(act==_T["admin_movedown"] && newID>0)
		newID++;

	if(bSubmitted && (act==_T["admin_moveup"] || act==_T["admin_movedown"]))
	{
		
		
		var data1 = oDB.getrows("select ds_id from "+_db_prefix+masterdb+" where ds_id = "+newID+" and ds_rev_id = "+true_dt);

		//bDebug = true;
		if(!data1[0] && newID>0)
		{
			var uSQL1 = "update "+_db_prefix+masterdb+" set ds_id = "+newID+" where ds_id = "+id+" and ds_rev_id = "+true_dt;			
			var uSQL2 = "update "+_db_prefix+detaildb+" set rd_recno = "+newID+" where rd_recno = "+id+" and rd_ds_id = "+true_dt;

			if(bDebug)
			{
				Response.Write(uSQL1+"<br>");
				Response.Write(uSQL2+"<br>");
			}
			else
			{
				oDB.exec(uSQL1);
				if(detaildb)
					oDB.exec(uSQL2);
			}
			
			bUpdateDONE = true;
			bSubmitted = newID>1?false:true;  // disable id when reached at lowest row ID
		}
		else if(data1[0] && newID>0)
		{ 


			// eventually check if record 0 already exists ??
			var uSQL1 = "update "+_db_prefix+masterdb+" set ds_id = 0 where ds_id = "+id+" and ds_rev_id = "+true_dt;			
			if(bDebug)
				Response.Write(uSQL1+"<br>");
			var uSQL2 = "update "+_db_prefix+masterdb+" set ds_id = "+id+" where ds_id = "+newID+" and ds_rev_id = "+true_dt;
			if(bDebug)
				Response.Write(uSQL2+"<br>");

			// PERHAPS GROUP UPDATES INTO ONE TRANSACTION
			
			var uSQL3 = "update "+_db_prefix+masterdb+" set ds_id = "+newID+" where ds_id = 0 and ds_rev_id = "+true_dt;			
			if(bDebug)
				Response.Write(uSQL3+"<br>");

			if(!bDebug)
			{
				oDB.exec(uSQL1);
				oDB.exec(uSQL2);
				oDB.exec(uSQL3);
			}

			if(detaildb)
			{
				var uSQL4 = "update "+_db_prefix+detaildb+" set rd_recno = 0 where rd_recno = "+id+" and rd_ds_id = "+true_dt;
				if(bDebug)
					Response.Write(uSQL4+"<br>");
				var uSQL5 = "update "+_db_prefix+detaildb+" set rd_recno = "+id+" where rd_recno = "+newID+" and rd_ds_id = "+true_dt;
				if(bDebug)
					Response.Write(uSQL5+"<br>");
				var uSQL6 = "update "+_db_prefix+detaildb+" set rd_recno = "+newID+" where rd_recno = 0 and rd_ds_id = "+true_dt;
				if(bDebug)
					Response.Write(uSQL6+"<br>");

				if(!bDebug)
				{				
					oDB.exec(uSQL4);
					oDB.exec(uSQL5);
					oDB.exec(uSQL6);
				}
			}
			
			
			bUpdateDONE = true;
			bSubmitted = newID>1?false:true;  // disable id when reached at lowest row ID

		}
		//bDebug = true;

		Response.Write("<script>"
		 +" try{window.opener.document.main.act.value='';}catch(e){};"
		 +" try{window.opener.document.main.submit();}catch(e){};"
		 +"</script>");	
	
	}
	Response.Write("<form method=\"post\" name=\"main\" action=\"?dt="+Request.QueryString("dt")+"&id="+(newID?newID.toString().encrypt("nicnac"):Request.QueryString("id"))+"\">\r\n")
	Response.Write("<center>\r\n");
	var commands = "<table cellpadding=10><tr><td width=100></td><td><input type=\"button\" src=\"../images/i_cancel.gif\" name=\"act\" value=\"cancel\" onclick=\"top.close()\"></td>"
			+"<td>"+(act=="delete after save" && (bAdmin || bDelete) ? "<table bgcolor=#800000><tr><td><input type=\"submit\" src=\"../images/i_delete.gif\" name=\"act\" value=\"delete\"></td></tr></table>":"<input type=\"submit\" src=\"../images/i_save.gif\" name=\"act\" value=\"save\">")+"</td>"
			+(bAdmin || bDelete ? "<td><input type=\"submit\" name=\"act\" value=\"delete after save\"></td>" : "")+"</tr></table>"
			+"<br><br>\r\n"

	Response.Write("<table cellspacing=\"2\" cellpadding=\"2\" border=\"0\" style=\"font-size:11px\">\r\n");
	Response.Write("<tr><td bgcolor=#EFD0D0>ID</td><td bgcolor=#E0E0E0><input name=NEWID value="+Number(newID)+" "+(bSubmitted || bAdmin==false?"disabled":"")+">");
	Response.Write("<input type=\"submit\" name=\"act\" value=\""+_T["admin_moveup"]+"\"><input type=\"submit\" name=\"act\" value=\""+_T["admin_movedown"]+"\">");
	Response.Write("</td></tr>");
	
	Response.Write("</table>\r\n<br>\r\n");
	
	Response.Write(commands);
	Response.Write("</center>\r\n</form>\r\n");
	
	//if(bUpdateDONE==true)
		//Response.Redirect(zerofill(ds_type,2)+"_rec_dlg_Q_dt_E_"+Request.QueryString("dt").Item+"_A_id_E_"+(id?id.toString().encrypt("nicnac"):0)+".asp")
%>