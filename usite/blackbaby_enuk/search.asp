<%@ Language=JavaScript%>
<!--#INCLUDE file = "ref.asp" -->

<%
	var oDB		= new DB();		// database object from DB.asp
	oDB.oCO.get("THEARTSERVER_MYSQL_DSNLESS");
	oDB.getSettings(oDB.oCO.ConnectString);
	var cm = Request.QueryString("cm").Item?Number(Request.QueryString("cm").Item):0;

	var SiderSafeURL	= "search";
	var SpiderSafeExt	= ".asp";
	var stdwidth		= 140;
	var limit			= 50;
	
	//var id = Request.QueryString("id").Item;
	//var id = id ? Number(id.decrypt("nicnac")) : -1
	
	var search_string = Request.Form("s").Item;
	var searcharr = search_string?csv2array(search_string," "):new Array();
	
	if(!search_string)
		Response.Redirect("00_index.asp")
	
	//Response.Write(searcharr)

	var ascl = [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4, 4,4,5,9,7,11,7,3,5,5,7,8,4,5,4,5,7,7,7,7,7,7,7,7,7,7,5,5,8,8,8,6,10,7,7,8,8,6,6,8,8,5,5,7,6,9,7,9,7,9,8,7,7,8,7,11,7,7,7,5,5,5,8,6,6,7,7,5,7,7,4,7,7,3,3,7,3,11,7,7,7,7,4,6,4,7,6,7,7,6,6,6,5,6,8,10,6,10,6,6,6,6,6,6,6,6,6,6,6,10,6,10,10,6,6,6,6,6,6,6,6,6,6,6,6,10,6,6,4,4,7,7,7,7,5,6,6,10,5,6,8,5,10,6,5,8,5,5,6,7,7,4,6,5,5,6,10,10,10,6,7,7,7,7,7,7,10,8,6,6,6,6,5,5,5,5,8,7,9,9,9,9,9,8,9,5,5,5,5,7,7,6,7,7,7,7,7,7,10,5,4,4,4,4,3,3,3,3,6,6,7,7,7,7,7,8,7,7,7,7,7,6,7,6];

	function pixelhack(str,maxpixels)
	{
		if(str)
		{
			str = str.toString();

			var alen = 0;
			// TODO HAAL DE MULTIPLE SPACES ERUIT MET REGEXP !!!
			//var log = "";
			for(var j=0;j<str.length && alen<maxpixels;j++)
			{
				alen += ascl[str.charCodeAt(j)];
				//log += 	ascl[str.charCodeAt(j)]+".";
			}
			return str.substring(0,j);
		}
		return "";
	}
 	

	function stripHtml(strHTML) 
	{
		if (strHTML)
		{
			var strOutput = strHTML.replace(/\n/g, ".$!$.");
			strOutput = strOutput.replace(/\<[^\>]+\>/g, "");
			strOutput = strOutput.replace(/\.\$\!\$\.\r\s*/g,"");
			strOutput = strOutput.replace(/\.\$\!\$\./g,"");
			strOutput = strOutput.replace(/\r\ \r/g,"");
			return strOutput;
		}
		return "";
	}
	
	function replacearray(str,arr,by)
	{
		for(var ra=0;ra<arr.length;ra++)
		{
			var rplc = arr[ra];
			rplc = rplc.replace(/[aáâàä]/,"[aáâàä]");
			rplc = rplc.replace(/[cç]/,"[cç]");
			rplc = rplc.replace(/[eéêèë]/,"[eéèê]");
			rplc = rplc.replace(/[iíîìï]/,"[iíìî]");
			rplc = rplc.replace(/[nñ]/,"[nñ]");
			rplc = rplc.replace(/[oóôòö]/,"[oóôòö]");
			rplc = rplc.replace(/[uúûùü]/,"[uúûùü]");
			rplc = rplc.replace(/[yýÿ]/,"[yýÿ]");
			str = str.replace(new RegExp("("+rplc+")","gi"),by);
		}
		return str;
	}


	var searchbar_index = new Array();
	for(var i=0;i<_T["searchbar_names"].length;i++)
		searchbar_index[_T["searchbar_names"][i]] = i;

	var rev_type = 20;
	var rev_typedesc = "pdf";

	var fieldarr = new Array();
	var field_i = 0;
	
	var arr = new Array();
	for(var i=0;i<searcharr.length;i++)
		arr[i] = "rev_title like \"%"+searcharr[i]+"%\"";
	fieldarr[field_i] = arr.join(" and ")
	field_i++;
	
	var arr = new Array();
	for(var i=0;i<searcharr.length;i++)
		arr[i] = "rev_desc like \"%"+searcharr[i]+"%\"";
	fieldarr[field_i] = arr.join(" and ")
	field_i++;	
	
	var arr = new Array();
	for(var i=0;i<searcharr.length;i++)
		arr[i] = "rev_header like \"%"+searcharr[i]+"%\"";
	fieldarr[field_i] = arr.join(" and ")
	field_i++;

	var arr = new Array();
	for(var i=0;i<searcharr.length;i++)
		arr[i] = "rev_rev like \"%"+searcharr[i]+"%\"";
	fieldarr[field_i] = arr.join(" and ")
	field_i++;		

	var fields = "(" + fieldarr.join(") or (") + ")";
	var searchSQL= fields?(" and ("+fields+")"):"";

	var dayfr = new Date();
	var dayto = new Date(dayfr);
	dayto.setDate(dayto.getDate()+1);
	
	var fr = dayfr.format("%Y-%m-%d");
	var to =dayto.format("%Y-%m-%d");

	var tablefld = new Array("rev_id","rev_desc","rev_date_published","rev_header","rev_title","rev_rev","rev_pub"
	,"''"
	,"''"
	);
%>

<style>
	.qtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.qtable td{ background-color:white;padding-left: 2px;padding-right: 2px;padding-top: 2px;padding-bottom: 2px;/*white-space: nowrap;*/}
	.gtable { background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.gtable td{ background-color: #e0e0e0; font-family: Verdana; font-size: 11px;}
	.utable td{ padding-left: 0px;padding-right: 0px;padding-top: 0px;padding-bottom: 0px;white-space: wrap; }
	b{font-size: 14px; color:#000000; font-weight:bold}
</style>

<center>

<%
	if(search_string && search_string.length>1)
	{
		// Q U E R Y
		var SQL = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 1) = 1 and (rev_pub & 8) <> 8 and rev_rt_typ = "+rev_type+" "+searchSQL+" order by rev_date_published desc,rev_desc desc,rev_header asc limit 0,"+(limit+1);
		//Response.Write(SQL+"<br>")
	
		var overview = oDB.getrows(SQL);
		
		var colwidth = 355;
		var marginwidth = 10;
		var editiondate = "";
		var searchresults = "<table cellspacing=0 cellpadding=0><tr><td valign=bottom><img src=../textilemagazine/images/recherche.gif></td><td width=10></td><td width=1 bgcolor=#327496></td><td width=10></td><td valign=top width="+colwidth +"><br>";
		var middle = Math.round(overview.length/(tablefld.length*2))*tablefld.length;
		
		for( var i=0 ; i < overview.length && i < (limit*tablefld.length) ; i+= tablefld.length )
		{
			var edidate = typeof(overview[i+2])=="date"?new Date(overview[i+2]).format("%m.%Y"):""
			if(editiondate != (overview[i+1]+edidate))
			{	
				
				editiondate = overview[i+1]+edidate;
				searchresults += "<span class=title style=color:#50B000;font-size:13px>"+ overview[i+1]+" - "+edidate.toUpperCase() + " - "   //.replace(/(.)/g,"$1&nbsp;")
				
			}
	
			var rowcolor =  "";
			var todoarrow = "../images/pijl-green.gif";
			if ( overview[i+6]=="1")
				rowcolor =" style=background-color:#FFFFEA";
			else
				todoarrow = overview[i+7]=="1" ? "../images/pijl-blue.gif":"../images/pijl-grey.gif"
			var bodyresults = "";
			//var bodyarr = replacearray(stripHtml(overview[i+5]),searcharr,"<span style=background-color:#FFFF00>$1</span>").split("<span");
			var bodyarr = replacearray(overview[i+5],searcharr,"<b>$1</b>").split("<b>");
			
			
			//bodyresults = bodyarr.join("<b>")
			var txt = "";
			var maxlen = 5;   // SHOW MAXIMUM 5 RESULTS WITHIN THE BODYTEXT 
			for(var j=0;j<bodyarr.length && j<maxlen;j++)
			{
				var prefix = bodyarr[j-1]?bodyarr[j-1]:"";
				prefix = prefix.substring(prefix.length-30,prefix.length);
				prefix = prefix.substring(prefix.indexOf(" "),prefix.length);
					
				if(bodyarr[j].length>100)
				{
					var btxt = bodyarr[j].substring(0,100);
					btxt = btxt.substring(0,btxt.lastIndexOf(" "));
					bodyresults += (txt?txt:prefix)+(bodyresults?"<b>":"")+btxt+"...";
					txt = "";
				}
				else
				{
					if(txt.length==0)
						txt = prefix+(bodyresults?"<b>":"")+bodyarr[j];
					else
						txt += "<b>"+bodyarr[j];
				}
			}
			bodyresults += txt	
			searchresults +=  stripHtml(overview[i+3]) + (overview[i+3] && overview[i+4]?(" - " ):"") + stripHtml(overview[i+4]) + "</span><br>"
					  +"<span style=color:#000000;font-family:Arial;font-size:13px>" + bodyresults +"</span> <a style=font-size:13px href='../"+_ws+"/pdf/pdf"+zerofill(overview[i],10)+"_1.pdf' target=_blank>[PDF]</a><br><br>"
	
			if (i == middle)
				searchresults += "<br></td><td width="+marginwidth+"></td><td width=1 style=background-color:#327496></td><td width="+marginwidth+"></td><td valign=top width="+colwidth+"><br>"	

		}
		searchresults += "</td></tr></table>";
	}

if(overview.length > (limit*tablefld.length))
	searchresults += "<tr class=voetnoot><td colspan=3 background=../images/stripedline.gif><img src=../images/scissor.gif><b> "+(_T["maximum"]+" "+limit+" "+_T["results"])+"</b></td></tr>";

_templdat[_enumtmpl["FOOTER"]] = "<p class=footer style=text-align:left;padding-left:0px>"
	+ (Request.QueryString("mode").Item == "login"?("<table cellspacing=0 cellpadding=0 width=241 class=small border=0><tr><td bgcolor=#FFFBF0 WIDTH=181 style=padding-left:5px;padding-right:0px;><form name=login method=post action=../admin/validate.asp><table height=100 width=100 cellspacing=2 cellpadding=3><tr><td width=100 style=font-family:verdana;font-size:13px>log</td><td><input size=6 type=text name=log maxlength=12></td></tr><tr><td width=100 style=font-family:verdana;font-size:13px>psw</td><td><input size=6 type=password name=pwd maxlength=12></td></tr><tr><td></td><td><input type=hidden name=dir value="+_dir+"><input type=submit value=login id=submit1 name=submit1></td></tr></table></form></td></tr></table>"):"")
	+"</p>";

if(!searchresults)
		searchresults = " &nbsp; <span class=title style=color:#50B000>Désolé aucun résultat pour votre recherche</span>";

_templdat[_enumtmpl["BODY"]] = searchresults;

if(_templtext)
	for(var i=0;i<_templdat.length;i++)
		_templtext = _templtext.replace("{_"+_tmplfld[i].toUpperCase()+"_}",_templdat[i]?_templdat[i]:("{_"+_tmplfld[i].toUpperCase()+"_}"))

%>




<%=_templtext%>


<!--  M A I N    T E X T    E N D  -->

<!--#INCLUDE file = "../skins/footer.asp" -->