<%@ Language=JavaScript %>
<!--#INCLUDE FILE = "../skins/adheader.asp" -->
<!--#INCLUDE FILE = "../includes/DB.asp" -->

<%
	//////////////////////////////////////////////////////////////////
	//  D E C L A R A T I O N   A N D  I N I T I A L I S A T I O N  //
	//////////////////////////////////////////////////////////////////
	
	var rev_type = 35;
	var cat_type = 2;
	var bCrosslanguage = true;
	var bDataManager   = true;
	var rev_cols = new Array("rev_title","rev_desc");
	var rev_fnct = new Array("run","edit");
	var rev_search = [["script","rev_rev"]];
	var insfld = new Array();
	insfld["rev_title"] = "";
	insfld["rev_desc"] =  "";
	
	
%>

<!--#INCLUDE FILE = "GENERAL_admin.asp"-->

<%

//Response.Write(overview.join("<br>")+"<br>**************************************************<br>")

		//if(bDoUpdate)
		{
			for( var i=0 ; i < overview.length ; i+= tablefld.length )
			{
				var check_mask = (1<<(checkarr.length))-1
				var pub = bSubmitted==true?(pubarr[overview[i+enumfld["rev_id"]]]?pubarr[overview[i+enumfld["rev_id"]]]:0):overview[i+enumfld["rev_pub"]];
				
				//Response.Write((pub & check_mask)+" "+(overview[i+enumfld["rev_pub"]] & check_mask)+"<br>")
				
				if ((pub & check_mask) != (overview[i+enumfld["rev_pub"]] & check_mask))
				{
					var uSQL = "update "+_db_prefix+"review set rev_pub = (rev_pub & ~"+check_mask+") | "+pub+" where rev_id = "+overview[i+enumfld["rev_id"]];					
					Response.Write(uSQL)
				}
			}
		}

%>

<!--#INCLUDE FILE = "../skins/adfooter.asp"-->
