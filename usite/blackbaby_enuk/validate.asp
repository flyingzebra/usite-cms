<%@ Language=JavaScript%>
<!--#INCLUDE file = "ref.asp" -->

<%

	var login = Request.Form("login").Item;
	var p  = Request.QueryString("p").Item;
	var c  = Request.QueryString("c").Item;
	var d = Request.QueryString("d").Item;
	var arr = new Array()

	//Response.Write(login+" "+p+" "+c+" "+dt+"*<br>")
	if(login && p && c && d)
	{
	
	
		var sSQL = "select rd_recno from "+_db_prefix+"datadetail where rd_ds_id = "+d.toString().decrypt("nicnac")+" and rd_dt_id = 2 and replace(rd_text,'.','') = '"+login+"'";
		var arr = _oDB.getrows(sSQL);
		var id = arr[0].toString().encrypt("nicnac");
		
		var fw = "form_Q_P_E_"+p+"_A_C_E_"+c+"_A_d_E_"+d+"_A_dsid_E_"+id+".asp"
		
		if(arr.length==1)
			Response.Redirect(fw);
		else
			Response.Redirect("index.asp");
	}

%>


