	
<%

///////////////////////////
//  G U I    C L A S S   //
///////////////////////////

function GUI()
{
	this.LBOX		= GUI_LBOX;
	this.IBOX		= GUI_IBOX;
	this.NBOX		= GUI_NBOX;
	this.ICADDY		= GUI_ICADDY;
	this.BUTTON		= GUI_BUTTON;
	this.CALENDAR	= GUI_CALENDAR;
	this.ICON		= GUI_ICON;
	this.TREE		= GUI_TREE;
	this.SESSION	= GUI_SESSION;
	this.initXML    = GUIinitXML;
	this.init		= GUIinit;
	this.init();
}

function GUIinit()
{
	// instantiate subclass objects
	this.LBox		= new this.LBOX;
	this.IBOX		= new this.IBOX;
	this.NBOX		= new this.NBOX;
	this.Icaddy		= new this.ICADDY;		
	this.Button		= new this.BUTTON;
	this.Calendar	= new this.CALENDAR;
	this.Icon		= new this.ICON;
	this.Tree		= new this.TREE;
	this.Session	= new this.SESSION;
	this.param    = new Array();
}

function GUIinitXML(_xml)
{
	var _obj = _xml.item(0).childNodes;
	var _olen = _obj.length
	
	for(var _i=0;_i<_olen;_i++)
		this.param[_obj.item(_i).tagName] = "";
	
	for(var _i=0;_i<_olen;_i++)
		this.param[_obj.item(_i).tagName] = this.param[_obj.item(_i).tagName]?(this.param[_obj.item(_i).tagName]+","+_obj.item(_i).text):_obj.item(_i).text
}











// LAB SUBCLASS DEFINITIONS

function GUI_LBOX()
{
	this.get	= getGUI_LBOX;
	this.init	= GUI_LBOXinit;
	this.init();
}

function getGUI_LBOX(title,txt,tmpaction)
{
	var crlf = "\r\n";
	var src = crlf+"<TABLE style=font-size:12 cellspacing=0 cellpadding=0>"

	  src+=crlf+"<TR>"
	    src+=crlf+"<TD bgcolor=#ffffff><IMG src=images/dummy.gif height=1 width=1></TD>"
	    src+=crlf+"<TD bgcolor=#446eb7><IMG src=images/dummy.gif height=1 width=50></TD>"
	  	src+=crlf+"<TD bgcolor=#ffffff><IMG src=images/dummy.gif height=1 width=1></TD>"
	  	src+=crlf+"<TD colspan=2 bgcolor="+this.rcolor+" width="+this.width+"></TD>"
	  	src+=crlf+"<TD bgcolor="+this.rcolor+" width=2></TD>"
	  src+=crlf+"</TR>"

	  src+=crlf+"<TR>"
	  	src+=crlf+"<TD bgcolor=#446eb7><IMG src=images/dummy.gif width=1></TD>"
	  	src+=crlf+"<TD bgcolor="+this.lcolor+" onclick="+tmpaction+" onmouseover=this.style.backgroundColor='"+this.lhcolor+"';this.style.cursor='hand' onmouseout=this.style.backgroundColor='"+this.lcolor+"' title=select><TABLE><TR><TD  NOWRAP style=font-size:12;color:white>"+title+"</TD></TR></TABLE></TD>"
	  	src+=crlf+"<TD bgcolor=#446eb7></TD>"
	  	src+=crlf+"<TD colspan=2 bgcolor="+this.rcolor+"><TABLE cellspacing=1 cellpadding=0 bgcolor="+this.frmcolor+"><TR><TD bgcolor="+this.rcolor+">"+txt+"</TD></TR></TABLE></TD>"
	  	src+=crlf+"<TD bgcolor="+this.rcolor+" width=2></TD>"
	  src+=crlf+"</TR>"

	  src+=crlf+"<TR>"
	    src+=crlf+"<TD bgcolor=#ffffff><IMG src=images/dummy.gif height=1 width=1></TD>"
	    src+=crlf+"<TD bgcolor=#446eb7><IMG src=images/dummy.gif height=1 width=50></TD>"
	  	src+=crlf+"<TD bgcolor=#ffffff><IMG src=images/dummy.gif height=1 width=1></TD>"
	  	src+=crlf+"<TD colspan=2 bgcolor="+this.rcolor+"></TD>"
	  	src+=crlf+"<TD bgcolor="+this.rcolor+" width=2></TD>"
	  src+=crlf+"</TR>"

	src+=crlf+"<TR><TD height=5></TD></TR>"
	src+=crlf+"</TABLE>"
    return src
}

function GUI_LBOXinit()
{
	this.width = 173;
	this.lcolor = "#003366";
	this.lhcolor = "#800000";
	this.rcolor = "#d4d0c8";
	this.frmcolor = this.rcolor;
}

function GUI_IBOX(image,txt)
{
	this.get	= getGUI_IBOX;
	this.height = 100;
	this.readmore = true;
	//this.init	= GUI_IBOXinit;
	//this.init();
}

function getGUI_IBOX(img,title,desc,txt,url,title_img)
{
	if (!title_img)
		title_img = "../images/ibox3.gif";
		
	var mtr = Math.round(4*this.height/100);
	var src = '<table cellspacing="0" cellpadding="0">'
		+'<tr><td><img src="../images/ibox1.gif"></td><td><img src="../images/ibox2.gif"></td><td><a href='+url+'><img src="'+title_img+'" border=0></a></td><td><img src="../images/ibox4.gif"></td></tr>'
		+'<tr>'
			+'<td><img src="../images/ibox5.gif" height='+this.height+' width=18></td><td><a href='+url+'>'+img+'</a></td><td>'
			//+'<td><img src="../images/ibox5.gif" height='+this.height+' width=18></td><td><a href='+url+'><img src='+img+' width=100 height='+this.height+' border=0></a></td><td>'
			+'<table cellspacing="0" cellpadding="0">'
				+'<tr><td><img src="../images/ibox11.gif" height='+mtr+' width=420></td></tr>'
				+'<tr><td height='+(this.height-2-mtr)+' width=420 valign=top>'
					+'<table><tr><td class=bodybold><b>'+title+'</b></td><td class=bodybold>'+desc+'</td></tr><tr><td colspan=2><img src="../images/ibox12.gif" width=400></td></tr><tr><td colspan=2 class=nieuws>'+txt+(this.readmore?' <a href='+url+' class=voetnoot>Lees meer &gt;&gt;&gt;':'')+'</a></td></tr></table>'
				+'</td></tr>'
				+'<tr><td><img src="../images/ibox12.gif"></td></tr>'
			+'</table>'
			+'</td><td><img src="../images/ibox6.gif" height='+this.height+' width=55></td>'
		+'</tr>'
		+'<tr><td><img src="../images/ibox7.gif"></td><td><img src="../images/ibox8.gif"></td><td><img src="../images/ibox9.gif"></td><td><img src="../images/ibox10.gif"></td></tr>'
	+'</table>'
	return src;
}

function GUI_NBOX()
{
	this.crlf	  = "\r\n";
	this.get	  = getGUI_NBOX;
	this.add	  = addGUI_NBOX;
	this.tailHTML = tailHTMLGUI_NBOX;
	this.param    = new Array();
	this.initXML  = GUI_NBOXinitXML;
	this.init	  = GUI_NBOXinit;
	this.init();
}

function addGUI_NBOX(ltext,rtext)
{
	this.data[this.data_index++] = ltext;
	this.data[this.data_index++] = rtext;
}

function tailHTMLGUI_NBOX()
{
	return 	this.crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+7)+"\" class=\"small\">"
			+this.crlf+"<tr height=\"5\"><td bgcolor=\""+this.param["NBOX:bg5"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh8"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+this.param["NBOX:lm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\" WIDTH=\""+this.param["NBOX:rm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg3"]+"\" WIDTH=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg6"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh9"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td></tr>"
			+this.crlf+"</table>"
			+this.crlf+"<table cellspacing=\"0\" cellpadding=\"0\" class=\"small\">"
			+this.crlf+"<tr height=\"1\"><td HEIGHT=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh9"]+"\" border=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+5)+"\" HEIGHT=\"1\" hspace=1></td></tr>"
			+this.crlf+"</table>";
}

function getGUI_NBOX(titleimg,tmpaction)
{
	var crlf = "\r\n";

	//if(this.bDebug)
	//	Response.Write(this.param["NBOX:leftcaddy"])

	var src_loop = "";
	var l = this.data_index;
	for (var i=0;i<l;i+=2)
	{
		src_loop += crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+6+(this.param["NBOX:openbody"]==true?5:1))+"\" class=\"small\">";
		if (i!=0 && this.param["NBOX:dottedline"]==true)
		{
			src_loop += crlf+"<tr><td bgcolor=\"#B9B9BE\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"spc.gif\" border=\"0\" WIDTH=\"1\"  HEIGHT=\"12\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+this.param["NBOX:lm"]+"\" align=\"right\" style=\"background-image:url('"+this.param["NBOX:path"]+"dottedline.gif');background-position:left 0px\"></td><td bgcolor=\""+this.param["NBOX:bg2"]+"\"  WIDTH=\""+this.param["NBOX:rm"]+"\" style=\"background-image:url('"+this.param["NBOX:path"]+"dottedline.gif');background-position:left 0px\"></td><td bgcolor=\""+this.param["NBOX:bg3"]+"\" WIDTH=\"5\">&nbsp;</td><td bgcolor=\""+(this.param["NBOX:openbody"]==true && i==0 ?this.param["NBOX:bg4"]:this.param["NBOX:bg5"])+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"spc.gif\" title=OOOOO border=\"0\" WIDTH=\""+(this.param["NBOX:openbody"]==true?5:1)+"\" HEIGHT=\""+this.param["NBOX:lineheight"]+"\"></td></tr>";
		}
		src_loop += crlf+"<tr><td bgcolor=\"#B9B9BE\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"spc.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\""+(this.param["NBOX:openbody"]==true && i>0?1:this.param["NBOX:lineheight"])+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+(this.param["NBOX:lm"]-this.param["NBOX:padding"])+"\" align=\"right\" style=padding-left:0px;padding-right:"+this.param["NBOX:padding"]+"px;>"+this.data[i]+"</td><td bgcolor=\""+this.param["NBOX:bg2"]+"\" WIDTH=\""+(this.param["NBOX:rm"]-this.param["NBOX:padding"])+"\" style=padding-left:"+this.param["NBOX:padding"]+"px;padding-right:0px;>"+this.data[i+1]+"</td><td bgcolor=\""+this.param["NBOX:bg3"]+"\" WIDTH=\"5\"> </td><td bgcolor=\""+(this.param["NBOX:openbody"]==true && i==0 ?this.param["NBOX:bg4"]:this.param["NBOX:bg5"])+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh11"]+"\" border=\"0\" WIDTH=\""+(this.param["NBOX:openbody"]==true?5:1)+"\" HEIGHT=\""+(this.param["NBOX:openbody"]==true && i>0?1:this.param["NBOX:lineheight"])+"\"></td></tr>";
		src_loop += crlf+crlf+crlf+"</table>";
	}



if (this.param["NBOX:leftcaddy"]==false)
{
	var src =   "";
	if(titleimg)
	   src += crlf+"<table cellspacing=\"0\" cellpadding=\"0\">"
			 +crlf+"<tr><td><img src=\""+this.param["NBOX:path"]+"nbox3.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"20\"></td><td>"+ (tmpaction?("<a href="+tmpaction+">"):"") +"<img src=\""+titleimg+"\" border=\"0\" width=\""+this.param["NBOX:titlewidth"]+"\" height=\"20\">"+(tmpaction?"</a>":"")+"</td>"+  (this.param["NBOX:rightcaddy"]==false?("<td><img src=\""+this.param["NBOX:path"]+"ibox3.gif\" border=\"0\" WIDTH=\""+(this.param["NBOX:tw"]<=418?1:(this.param["NBOX:tw"]-418))+"\" HEIGHT=\"20\"></td><td><img src=\""+this.param["NBOX:path"]+"nbox3.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"20\"></td>"):"<td><img src=\""+this.param["NBOX:path"]+"nbox6.gif\" border=\"0\" WIDTH=\"3\" HEIGHT=\"20\"></td>")+"</tr>"
		     +crlf+"</table>";
    src +=   crlf+"<table cellspacing=\"0\" cellpadding=\"0\" class=\"small\">"
			+crlf+"<tr><td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh1"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh2"]+"\" border=\"0\" WIDTH=\""+this.param["NBOX:lm"]+"\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh3"]+"\" border=\"0\" WIDTH=\""+this.param["NBOX:rm"]+"\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh4"]+"\" border=\"0\" WIDTH=\"5\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+(this.param["NBOX:openbody"]==true?this.param["NBOX:sh5"]:this.param["NBOX:sh6"])+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"6\"></td>"+(this.param["NBOX:rightcaddy"]==false?"":"<td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh10"]+"\" border=\"0\" WIDTH=\"4\" HEIGHT=\"6\"></td>")+"</tr>"
			+crlf+"</table>"
			+crlf+src_loop
			+crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+7)+"\" class=\"small\">"
			+crlf+"<tr><td bgcolor=\""+this.param["NBOX:bg5"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh8"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+(this.param["NBOX:lm"]-this.param["NBOX:padding"])+"\" align=\"right\" style=padding-left:0px;padding-right:"+this.param["NBOX:padding"]+"px;>   </td><td bgcolor=\""+this.param["NBOX:bg2"]+"\" WIDTH=\""+(this.param["NBOX:rm"]-this.param["NBOX:padding"])+"\" style=padding-left:"+this.param["NBOX:padding"]+"px;padding-right:0px;>   </td><td bgcolor=\""+this.param["NBOX:bg3"]+"\" WIDTH=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg6"]+"\" WIDTH=\"1\" height=\"5\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh9"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td></tr>"
			+crlf+"</table>";
if (this.param["NBOX:bTail"])
	src +=   crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+7)+"\" class=\"small\">"
			+crlf+"<tr height=\"5\"><td bgcolor=\""+this.param["NBOX:bg5"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh8"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+this.param["NBOX:lm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\" WIDTH=\""+this.param["NBOX:rm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\" WIDTH=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg6"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh9"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td></tr>"
			+crlf+"</table>"
			+crlf+"<table cellspacing=\"0\" cellpadding=\"0\" class=\"small\">"
			+crlf+"<tr height=\"1\"><td HEIGHT=\"1\"><img src=\""+this.param["NBOX:path"]+"nbox5.gif\" border=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+5)+"\" HEIGHT=\"1\" hspace=1></td></tr>"
			+crlf+"</table>";
}
else
{ // NEW CADDY
var src =   "";
if(titleimg)
      src += crlf+"<table cellspacing=\"0\" cellpadding=\"0\">"
			+crlf+"<tr><td><img src=\""+this.param["NBOX:path"]+"ibox3.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"20\"></td><td>"+ (tmpaction?("<a href=\""+tmpaction+"\">"):"") +"<img src=\""+titleimg+"\" border=\"0\" width=\""+this.param["NBOX:titlewidth"]+"\" height=\"20\">"+(tmpaction?"</a>":"")+"</td>"+(this.param["NBOX:rightcaddy"]==false?("<td><img src=\""+this.param["NBOX:path"]+"ibox3.gif\" border=\"0\" WIDTH=\""+(this.param["NBOX:tw"]<=418?1:(this.param["NBOX:tw"]-418))+"\" HEIGHT=\"20\"></td><td><img src=\""+this.param["NBOX:path"]+"nbox3.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"20\"></td><td><img src=\""+this.param["NBOX:path"]+"spc.gif\" title=OOOO border=\"0\" WIDTH=\"2\" HEIGHT=\"20\"></td>"):"<td><img src=\""+this.param["NBOX:path"]+"nbox6.gif\" border=\"0\" WIDTH=\"4\" HEIGHT=\"20\"></td>")+"</tr>"
			+crlf+"</table>";
src +=		 crlf+"<table cellspacing=\"0\" cellpadding=\"0\" class=\"small\">"
			+crlf+"<tr><td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh1"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+""+this.param["NBOX:sh2"]+"\" border=\"0\" WIDTH=\""+this.param["NBOX:lm"]+"\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+""+this.param["NBOX:sh3"]+"\" border=\"0\" WIDTH=\""+this.param["NBOX:rm"]+"\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+""+this.param["NBOX:sh4"]+"\" border=\"0\" WIDTH=\"5\" HEIGHT=\"6\"></td><td><img src=\""+this.param["NBOX:path"]+(this.param["NBOX:openbody"]==true?this.param["NBOX:sh5"]:this.param["NBOX:sh6"])+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"6\"></td>"+(this.param["NBOX:openbody"]==true?"<td><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh7"]+"\" border=\"0\" WIDTH=\"4\" HEIGHT=\"6\"></td>":"")+(this.param["NBOX:rightcaddy"]==false?"":"<td><img src=\""+this.param["NBOX:path"]+"nbox7.gif\" border=\"0\" WIDTH=\"4\" HEIGHT=\"6\"></td>")+"</tr>"
			+crlf+"</table>"
			+crlf+src_loop
			+crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+7)+"\" class=\"small\">"
			+crlf+"<tr><td bgcolor=\""+this.param["NBOX:bg5"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"nbox5.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+(this.param["NBOX:lm"]-this.param["NBOX:padding"])+"\" align=\"right\" style=padding-left:0px;padding-right:"+this.param["NBOX:padding"]+"px;>   </td><td bgcolor=\""+this.param["NBOX:bg2"]+"\" WIDTH=\""+(this.param["NBOX:rm"]-this.param["NBOX:padding"])+"\" style=padding-left:"+this.param["NBOX:padding"]+"px;padding-right:0px;>   </td><td bgcolor=\""+this.param["NBOX:bg3"]+"\" WIDTH=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg6"]+"\" WIDTH=\"1\" height=\"5\"><img src=\""+this.param["NBOX:path"]+this.param["NBOX:sh9"]+"\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td></tr>"
			+crlf+"</table>";
if (this.param["NBOX:bTail"])
	src +=crlf+"<table cellspacing=\"0\" cellpadding=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+7)+"\" class=\"small\">"
			+crlf+"<tr height=\"5\"><td bgcolor=\""+this.param["NBOX:bg5"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"nbox5.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\"  WIDTH=\""+this.param["NBOX:lm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\" WIDTH=\""+this.param["NBOX:rm"]+"\"></td><td bgcolor=\""+this.param["NBOX:bg1"]+"\" WIDTH=\"5\"></td><td bgcolor=\""+this.param["NBOX:bg6"]+"\" WIDTH=\"1\"><img src=\""+this.param["NBOX:path"]+"nbox5.gif\" border=\"0\" WIDTH=\"1\" HEIGHT=\"5\"></td></tr>"
			+crlf+"</table>"
			+crlf+"<table cellspacing=\"0\" cellpadding=\"0\" class=\"small\">"
			+crlf+"<tr height=\"1\"><td HEIGHT=\"1\"><img src=\""+this.param["NBOX:path"]+"nbox5.gif\" border=\"0\" width=\""+(this.param["NBOX:lm"]+this.param["NBOX:rm"]+5)+"\" HEIGHT=\"1\" hspace=1></td></tr>"
			+crlf+"</table>"
}

	this.data = new Array();
	this.data_index = 0;
    return src
}

function GUI_NBOXinit()
{
	this.param["NBOX:bTail"] = true;
	
	this.param["NBOX:lm"] = 95; //145;
	this.param["NBOX:rm"] = 250; //439;
	this.param["NBOX:tw"] = this.param["NBOX:lm"] + this.param["NBOX:rm"];   // totale lengte > 418 !!!!
	
	this.param["NBOX:titlewidth"] = 350;
	
	this.param["NBOX:path"] = "../images/";
	this.param["NBOX:leftcaddy"] = false;
	this.param["NBOX:rightcaddy"] = false;
	this.param["NBOX:dottedline"] = true;
	this.param["NBOX:openbody"] = false;
	this.param["NBOX:bg1"] = "#F4F0ED";
	this.param["NBOX:bg2"] = "#FFFBF0";
	this.param["NBOX:bg3"] = "#F4F0ED";
	this.param["NBOX:bg4"] = "#F4F0ED";
	this.param["NBOX:bg5"] = "#B9B9BE";
	this.param["NBOX:bg6"] = "#B9B9BE";
		
	this.param["NBOX:padding"] = 5;
	this.param["NBOX:lineheight"] = 12;
	this.param["NBOX:sh1"] = "nbox4.gif";
	this.param["NBOX:sh2"] = "nbox1.gif";
	this.param["NBOX:sh3"] = "nbox2.gif";
	this.param["NBOX:sh4"] = "nbox1.gif";
	this.param["NBOX:sh5"] = "nbox1.gif";
	this.param["NBOX:sh6"] = "nbox4.gif";
	
	this.param["NBOX:sh7"] = "nbox1.gif";
	
	this.param["NBOX:sh8"] = "nbox5.gif";
	this.param["NBOX:sh9"] = "nbox5.gif";
	this.param["NBOX:sh10"] = "nbox7.gif";
	this.param["NBOX:sh11"] = "spc.gif";	
	this.data_index = 0;
	this.data = new Array();
	this.crlf = "\r\n";
	this.bDebug = false;
}


function GUI_NBOXinitXML(_xml)
{
	var _obj = _xml.item(0).childNodes;
	var _olen = _obj.length
	
	for(var _i=0;_i<_olen;_i++)
		this.param[_obj.item(_i).tagName] = "";
	
	for(var _i=0;_i<_olen;_i++)
		this.param[_obj.item(_i).tagName] = this.param[_obj.item(_i).tagName]?(this.param[_obj.item(_i).tagName]+","+_obj.item(_i).text):_obj.item(_i).text
		

	if(this.bDebug)
		for(var _i=0;_i<_olen;_i++)
			Response.Write("param['"+_obj.item(_i).tagName+"']="+this.param[_obj.item(_i).tagName]+"<br>")

	if(this.param["NBOX:bTail"])
		this.param["NBOX:bTail"] = this.param["NBOX:bTail"]=="true";
	if(this.param["NBOX:lm"])		
		this.param["NBOX:lm"] = Number(this.param["NBOX:lm"]);
	if(this.param["NBOX:rm"])
		this.param["NBOX:rm"] = Number(this.param["NBOX:rm"]);
	if(this.param["NBOX:tw"])
		this.param["NBOX:tw"] = Number(this.param["NBOX:tw"]);
	if(this.param["NBOX:titlewidth"])
		this.param["NBOX:titlewidth"] = Number(this.param["NBOX:titlewidth"]);
	if(this.param["NBOX:leftcaddy"])
		this.param["NBOX:leftcaddy"] = this.param["NBOX:leftcaddy"]=="true";
	if(this.param["NBOX:rightcaddy"])
		this.param["NBOX:rightcaddy"] = this.param["NBOX:rightcaddy"]=="true";
	if(this.param["NBOX:dottedline"])
		this.param["NBOX:dottedline"] = this.param["NBOX:dottedline"]=="true";
	if(this.param["NBOX:openbody"])
		this.param["NBOX:openbody"] = this.param["NBOX:openbody"]=="true";
}

function GUI_ICADDY(txt)
{
	this.get	= getGUI_ICADDY;
	this.height = 100;
}

function getGUI_ICADDY(txt)
{
	var src = '<table cellspacing="0" cellpadding="0">'
		+'<tr><td colspan=3><img src="../images/icaddy1.gif"></td></tr>'
		+'<tr>'
			+'<td><img src="../images/icaddy2.gif" width=15 height='+this.height+'></td>'
			+'<td>'+txt+'</td>'
			+'<td><img src="../images/icaddy3.gif" width=28 height='+this.height+'></td>'
		+'</tr>'
		+'<tr><td colspan=3><img src="../images/icaddy4.gif"></td></tr>'
	+'</table>'
	return src;
}

function GUI_BUTTON()
{
	this.get			= getGUI_BUTTON;
	this.init			= GUI_BUTTONinit;
	this.tan			= 0;
	this.path			= "images/";
	this.init();
}

function getGUI_BUTTON(action,img,altimg,tooltip,attr)
{
	var src = "";
	var t = this.tan++;
	src	+= "<IMG border='0' name='b"+t+"' src='"+this.path+img+"' onMouseover=this.src='"+this.path+altimg+"';this.style.cursor='hand' onMouseout=this.src='"+this.path+img+"' "+(action?("onclick="+action):"")+" title='"+tooltip+"' "+(attr?attr:"")+">";
    return src;
}

function GUI_BUTTONinit()
{
	//Response.Write("init");
}

function GUI_CALENDAR()
{
	this.get			= getGUI_CALENDAR;
	this.events			= eventsGUI_CALENDAR;
	this.init			= GUI_CALENDARinit;
	this.curday			= new Date();
	this.today			= new Date();
	this.basedate		= new Date();
	this.init();
}

function GUI_CALENDARinit()
{
	this.i		   = 0;
	this.monthname = ["J A N U A R Y","F E B R U A R Y","M A R C H","A P R I L","M A Y","J U N E","J U L Y","A U G U S T","S E P T E M B E R","O C T O B E R","N O V E M B E R","D E C E M B E R"];
	this.daynr	   = 0;
	this.clickedcolor = "lightblue";
	this.fgcolor =		"black";
	this.bgcolor =      "white"
	this.todayfgcolor = "white";
	this.todaybgcolor =	"black";
	//this.palette = ["#FFFFFF","#FFEEEE","#FFDDDD","#FFCCCC","#FFBBBB","#FFAAAA","#FF9999","#FF8888","#FF7777","#FF6666","#FF5555","#FF4444","#FF3333","#FF2222","#FF1111","#FF0000"];
	this.palette = ["#FFFFFF","#F0F0FF","#E9EBFF","#E3E7FF","#DDE3FF","#D7DFFF","#D1DBFF","#CBD7FF","#C5D3FF","#BFCFFF","#B9CBFF","#B3C7FF","#ADC3FF","#A7BFFF","#A0BBFF","#9AB7FF","#94B3FF","#8EAFFF","#88ABFF","#82A7FF","#7CA3FF","#769FFF","#709BFF","#6A97FF","#6493FF","#5E8FFF","#6191F9","#6493F4","#6795EF","#6B98EA","#6E9AE4","#719CDF","#759FDA","#78A1D5","#7BA3D0","#7EA5CA","#82A8C5","#85AAC0","#88ACBB","#8CAFB6","#8FB1B0","#92B3AB","#95B5A6","#99B8A1","#9CBA9C","#9FBC96","#A3BF91","#A6C18C","#A9C387","#ACC582","#B0C87C","#B3CA77","#B6CC72","#BACF6D","#BDD168","#C0D362","#C3D55D","#C7D858","#CADA53","#CDDC4E","#D1DF48","#D4E143","#D7E33E","#DAE539","#DEE834","#E1EA2E","#E4EC29","#E8EF24","#EBF11F","#EEF31A","#F1F514","#F5F80F","#F8FA0A","#FBFC05","#FFFF00","#FFFF00","#FFF400","#FFE900","#FFDF00","#FFD400","#FFC900","#FFBF00","#FFB400","#FFAA00","#FF9F00","#FF9400","#FF8A00","#FF7F00","#FF7400","#FF6A00","#FF5F00","#FF5500","#FF4A00","#FF3F00","#FF3500","#FF2A00","#FF1F00","#FF1500","#FF0A00","#FF0000"]
	this.maxval	= this.palette.length-1;
	this.selected = new Array();
	this.min = 1;
	this.max = 10;
	
	this.basedate.setHours(0,0,0,0);
	this.basedate.setDate(1);
	this.basedate.setMonth(0);	
	
}

function firstdaynameofthemonth(tmpdate)
{
	var localcopy = new Date(tmpdate);
	localcopy.setDate(1); 
	return localcopy.getDay()==0?6:localcopy.getDay()-1;
}

function lastdayofthemonth(tmpdate)
{
	var localcopy = new Date(tmpdate) 
	var ctrl = localcopy.getMonth();

	localcopy.setDate(29); if (localcopy.getMonth()!=ctrl)	return 28;
	localcopy.setDate(30); if (localcopy.getMonth()!=ctrl)	return 29;
	localcopy.setDate(31); if (localcopy.getMonth()!=ctrl)	return 30;
	return 31;
}

function yeardaynumber(tmpdate)
{
	var localcopy = new Date(tmpdate) 
	localcopy.setHours(0,0,0,0);
	localcopy.setDate(1);
	localcopy.setMonth(0);
	return Math.round((tmpdate-localcopy)/(1000*60*60*24))
}

function getGUI_CALENDAR(curday)
{
	if (curday)
		this.curday = new Date(curday);

	this.basedate.setHours(0,0,0,0);
	this.basedate.setDate(1);
	this.curmonth = this.curday.getMonth();
		 	
	// TODO FIX HOLIDAY MANAGEMENT
	var holiday = new Array();	
	var firstday = firstdaynameofthemonth(this.curday);
	var lastday = lastdayofthemonth(this.curday)+firstday-1;

	var firstdate = new Date(this.curday);
	firstdate.setHours(0,0,0,0)
	firstdate.setDate(1);
	
	// DAYOFFSET = THE DAY WE START COUNTING SELECTION INDEXES
	var dayoffset = Math.round((curday-this.basedate)/(1000*60*60*24));
	
	//yeardaynumber(firstdate);
	if (!this.selected)
		this.selected = new Array();
	
	this.curday.setDate(this.today.getDate());
	var todayday = (this.curday.getFullYear()==this.today.getFullYear() && this.curday.getMonth()==this.today.getMonth()?this.today.getDate():0);
	var curselected = 0;

	this.fgcolor =		"black";
	this.todaybgcolor =	"black";
	this.todayfgcolor = "white";

	var src = "<table cellspacing=1 cellpadding=1 style=background-Color:black;font-family:Verdana;vertical-align:top; width=102 height=102>"
			 +"<tr style=text-align:center;font-size:8px;color:white;font-weight:bold><td>M</td><td>T</td><td>W</td><td>T</td><td>F</td><td style=color:lightblue>S</td><td style=color:lightblue>S</td></tr>";
			 for (this.i=0;this.i<37;this.i++)
			 {
				if (this.i%7==0)
					src += "<tr style=text-align:right;font-size:7px;>";
				this.daynr = this.i>=firstday && this.i<=lastday?this.i-firstday+1:"&nbsp;";
				
				curselected = Math.round(this.selected[this.daynr+dayoffset-1]*(this.palette.length-1)/this.maxval);
				
				//Response.Write("<!--"+ curselected + " " + (this.palette.length/this.maxval) +" "+ (this.selected[this.daynr+dayoffset-1]) +"-->\r\n")
				
				var cur_fgcolor = this.daynr==todayday ? this.todayfgcolor : this.fgcolor;
				var cur_bgcolor = this.daynr==todayday ? this.todaybgcolor : (curselected?(curselected<=this.palette.length?this.palette[curselected]:this.palette[this.palette.length-1]):this.bgcolor);
				
				src += "<td style=color:"+cur_fgcolor+";background-Color:"+cur_bgcolor+" "+(this.selected[this.daynr+dayoffset-1]?("style=background-color:"+this.holidaycolor):"")+" "+this.events()+">"+this.daynr+"</td>";
				if (this.i%7==6)
					src += "</tr>";	
			 }
			 src += "<td colspan=5 bgcolor=white style=text-align:right;font-size:7px;font-weight:bold;color:darkblue;>"+this.monthname[this.curmonth]+"</td></tr>";		
	src += "</table>";

	return src;
}



function eventsGUI_CALENDAR() { /*   V I R T U A L   */ return ""; }



function GUI_ICON()
{
	this.add			= addGUI_ICON;
	this.getimg			= getimgGUI_ICON;
	this.get			= getGUI_ICON;
	this.init			= GUI_ICONinit;
	this.type			= 0;
	this.attr			= "align=center class=small";
	this.attr_sep		= "";
	this.init();
}

function GUI_ICONinit()
{
	this.images  = true;
	this.data_index = 0;
	this.data = new Array();
	this.maxlength = 5;
}

function addGUI_ICON(imgsrc,link,text,alt)
{
	this.data[this.data_index++] = imgsrc;
	this.data[this.data_index++] = link;
	this.data[this.data_index++] = text;
	this.data[this.data_index++] = alt;
}

function getimgGUI_ICON(imgsrc,alt)
{
	if(this.images==true)
		if(alt)
			return "<img src="+imgsrc+" alt=\""+alt+"\" border=0>";
		else
			return "<img src="+imgsrc+" border=0>";
	else
		return imgsrc;
}

function getGUI_ICON()
{
   var _iterator = 4
   var _icons = "";
   var length = this.data_index-_iterator; 
   for(var _i=0;_i<this.data_index;_i+=_iterator)
   {
		var _idx = _i/_iterator;
		var sep = _i==length?"":"</td><td valign=top>";
		
		switch(this.type)
		{
			case 0:
				var sw = _i==length?((_idx%5)==4?3:5):(_idx%5)
				if(sw==0)
					_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
							+"<tr><td height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
							+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox23.gif width=8 height=100></td></tr>"
							+"<tr><td><img src=../images/ibox22.gif width=109 height=12></td></tr>"
							+"</table>"+this.data[_i+2]+"</p>"+sep;
				
				switch(sw)
				{
					case 0:

					break;
					case 4:
					if (sep)
						sep = "</td></tr></table><table "+this.attr_sep+"><tr><td valign=top>";	
					case 1:
					case 2:
					case 3:
					_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
							+"<tr><td height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
							+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox23.gif width=8 height=100></td></tr>"
							+"<tr><td><img src=../images/ibox24.gif width=109 height=12></td></tr>"
							+"</table>\r\n"+this.data[_i+2]+"</p>"+sep;
					break;
					case 5:
					if (sep)
						sep = "</td></tr></table><table "+this.attr_sep+"><tr><td valign=top>";
					_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
							+"<tr><td height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
							+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox21.gif width=11 height=100></td></tr>"
							+"<tr><td><img src=../images/ibox20.gif width=112 height=12></td></tr>"
							+"</table>\r\n"+this.data[_i+2]+"</p>"+sep;
					break;
				}
			break;
			case 1:
				_icons += "<table cellspacing=0 cellpadding=0 "+this.attr+">"
						+"<tr><td width=41 height=1 align=left><img src=../images/pix.gif width=39 height=1></td></tr>"
						+"<tr><td><img src=../images/pix.gif width=1 height=37><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox27.gif width=3 height=37></td></tr>"
						+"<tr><td><img src=../images/ibox28.gif width=41 height=3></td></tr>"
						+"</table>\r\n<span "+this.attr+">"+this.data[_i+2]+"</span>"+sep;
				break;
			case 2:
				switch(_i==length?((_idx%2)==1?1:2):(_idx%2))
				{
					case 0:
						_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
								+"<tr><td height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
								+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox23.gif width=8 height=100></td></tr>"
								+"<tr><td><img src=../images/ibox22.gif width=109 height=12></td></tr>"
								+"</table>\r\n"+this.data[_i+2]+"</p>"+sep;
					break;
					case 1:
					if (sep)
						sep = "</td></tr></table><table "+this.attr_sep+"><tr><td valign=top>";
						_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
								+"<tr><td width=112 height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
								+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox21.gif width=11 height=100></td></tr>"
								+"<tr><td><img src=../images/ibox20.gif width=112 height=12></td></tr>"
								+"</table>\r\n"+this.data[_i+2]+"</p>"+sep;
					break;
					case 2:
					if (sep)
						sep = "</td></tr></table><table "+this.attr_sep+"><tr><td valign=top>";
						_icons += "<p align=center class=small><table cellspacing=0 cellpadding=0>"
								+"<tr><td width=112 height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
								+"<tr><td><img src=../images/pix.gif width=1 height=100><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox21.gif width=11 height=100></td></tr>"
								+"<tr><td><img src=../images/ibox20.gif width=112 height=12></td></tr>"
								+"</table>\r\n"+this.data[_i+2]+"</p>"+sep;
					break;
				}
			break;
			case 3:
				_icons += "<table cellspacing=0 cellpadding=0 "+this.attr+">"
						+"<tr><td width=54 height=1 align=left><img src=../images/pix.gif width=52 height=1></td></tr>"
						+"<tr><td><img src=../images/pix.gif width=1 height=50><a href="+this.data[_i+1]+">"+this.getimg(this.data[_i],this.data[_i+3])+"</a><img src=../images/ibox27.gif width=3 height=50></td></tr>"
						+"<tr><td><img src=../images/ibox28.gif width=54 height=3></td></tr>"
						+"</table>\r\n<span "+this.attr+">"+this.data[_i+2]+"</span>"+sep;
			break;

				
		}
		
	}
	return _icons;
}

///////////////////////////
//  T R E E   C L A S S  //
///////////////////////////

function GUI_TREE()
{
	this.init			= GUI_TREEinit;
	this.load			= GUI_TREEload;
	this.indent			= GUI_TREEindent;
	this.childsof		= GUI_TREEchildsof;
	this.brothersof		= GUI_TREEbrothersof;
	this.childbrothersof= GUI_TREEchildbrothersof;
	this.traceref		= GUI_TREEtraceref;
	this.traceto		= GUI_TREEtraceto;
	this.combobox		= GUI_TREEcombobox;
	this.indexit		= GUI_TREEindexit;
	
	this.insertbefore  = GUI_TREEinsertbefore;
	this.insertafter   = GUI_TREEinsertafter;
	this.isparent      = GUI_TREEisparent;
	this.edit		   = GUI_TREEedit;
	this.del		   = GUI_TREEdelete;

	this.init();
}

function GUI_TREEinit()
{
	this.treedepth		= 0;
	this.maxtreedept	= 0;
	this.acc_id			= new String();
	this.acc_index		= new String();
	this.acc_rownr		= new String();
	
	// "id,parent_id,index,level,desc"
	this.in_interleave	= 5;
	
	// "id,level,desc"
	this.out_interleave	= 3;
	
	this.remap			= new Array(0,3,4);
	this.order			= new Array();
	this.treedata		= new Array();
	
	this.childs			= new Array();
	this.index			= new Array();
	this.bIsParent		= new Array();
	
	this.NodeData		= new Array();
	
	this.sortload		= 0;
	this.bIncludeRoot	= false;	// childsof option
	this.rootdepth		= 0;		// childsof return value

	this.combo_seltxt	= "";
	
	this.bDebug = false;
}

function GUI_TREEindexit(_arrdata)	
{
	this.arrdata = _arrdata
	// CLEAR INDEX ARRAY
	this.index.length = 0;
	
	// BUILD NEW INDEX
	for (var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
		if(this.arrdata[_i])
		{
			//Response.Write(this.bIsParent[this.arrdata[_i+1]]+"<br>")
			//Response.Flush();
			this.index[this.arrdata[_i]] = _i;							// fill the id, and you get the rownumber
			this.bIsParent[this.arrdata[_i+1]] = true;	// fill the id, and you get the parent id
		}
	return this.index;
}

function GUI_TREEinsertbefore()
{
}

function GUI_TREEinsertafter()
{
}

function GUI_TREEisparent(_thisid)
{
}

function GUI_TREEedit()
{
}

function GUI_TREEdelete()
{
}

function GUI_TREEbrothersof(_thisid,_arrdata)
{
	this.childs = new Array();
	
	this.indexit(_arrdata);
	var _cur_rownr = this.index[_thisid];
	var _cur_parent = this.arrdata[_cur_rownr+1];
	var _bRootNode = _cur_parent==_thisid;
	var _j = 0;

	//Response.Write("cur_rownr="+_cur_rownr+"<br>")
	//Response.Write("Rootnode="+_bRootNode+"<br>")

	if(_bRootNode == true)
	{
		// FIND ALL ROWNUMBERS OF ROOT NODES
		for(var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
		{
			if(this.arrdata[_i]==this.arrdata[_i+1] /* ROOT NODES */)
			{
				//Response.Write(this.arrdata[_i]+"=="+this.arrdata[_i+1]+" ("+_i+")<br>");
				this.childs[_j++] = this.arrdata[_i];
			}
		}
	}
	else
	{
		// FIND ALL ROWNUMBERS OF SUBNODES HAVING THE SAME PARENT (EXCEPT MAIN NODES)				
		for(var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
		{
			if(this.arrdata[_cur_rownr+1]==this.arrdata[_i+1] /* FIND ALL TUPPLES HAVING THE SAME PARENT ID */ && this.arrdata[_i]!=this.arrdata[_i+1] /* EXCEPT ROOT NODES */)
				this.childs[_j++] = this.arrdata[_i];
		}
	}
	return this.childs;   //   R E T U R N I N G  A R R A Y   O F   R T _ I D   ! ! ! ! !
}


function digit(m, dig)
 { var str = String(Math.round(m));
   if( dig >= str.length ) return 0;
   return str.charAt(str.length - 1 - dig) - 0;
 }

function pass(a, N, dig)
 { var counter = new Array(11);
   var temp = new Array();
   var i, d;

   for( d = 0; d <= 9; d++ ) counter[d] = 0;
   for( i = 0; i < N; i++ ) counter[ digit(a[i], dig) ] ++;
   for( d = 1; d <= 9; d++ ) counter[d] += counter[d-1];

   for( i = N-1; i >= 0; i-- )
    { temp[ counter[ digit(a[i], dig) ] -- ] = a[i]; }

   for( i = 0; i < N; i++ ) a[i] = temp[i+1];
 }

function radixSort(a, N)
 { var p,  i,  maxLen = 0;
   for( i = 1; i <= N; i++ )
    { var str = Math.round(a[i]).toString();
      if( str.length > maxLen ) maxLen = str.length;
    }
   for( p=0; p < maxLen; p++ )
      pass(a, N, p);
   return a;
 }

function pass_multi(a, N, dig, L)
 { var counter = new Array(11);
   var temp = new Array();
   var i, d;

   for( d = 0; d <= 9; d++ ) counter[d] = 0;
   for( i = 0; i < N; i++ ) counter[ digit(a[i][L], dig) ] ++;
   for( d = 1; d <= 9; d++ ) counter[d] += counter[d-1];

   for( i = N-1; i >= 0; i-- )
    { temp[ counter[ digit(a[i][L], dig) ] -- ] = a[i]; }

   for( i = 0; i < N; i++ ) a[i] = temp[i+1];
 }

function radixSort_multi(a, L)
 { var p,  i,  maxLen = 0; var N = a.length;
   for( i = 1; i <= N; i++ )
    { 
      var str = String(Math.round(a[i-1][L]));
      if( str.length > maxLen ) maxLen = str.length;
    }
   for( p=0; p < maxLen; p++ )
      pass_multi(a, N, p, L);
   return a;
 }


function GUI_TREEload(_arrdata,_filter_id,_filter_level)
{
	this.arrdata = _arrdata;
	
	// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
	
	if (this.bDebug == true)
	{
		for(var _k=0;_k<this.arrdata.length;_k+=this.in_interleave)
		{
			for( var _l=0;_l<this.in_interleave;_l++)
			{
				Response.Write("("+(_k+_l)+") "+this.arrdata[_k+_l]+"&nbsp;&nbsp;")
			}
			Response.Write("<br>")
		}
		Response.Write("<br>");
	}
	
	// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////	

	this.maxtreedepth = 0;

	this.order=new Array();
	var _j = 0
	// QUANTISING HORIZONTAL TREE INDENTATION (BY TRACKING ROOT ELEMENT)
	for (var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
	{
		this.acc_id    = this.arrdata[_i+1];
		this.acc_index = this.arrdata[_i+2];
		this.treedepth = 0;

		// TRACE ALL PARENT REFERENCES FROM A GIVEN POINT		
		var root_index = this.traceref(_i);

		if(!_filter_id || (","+this.acc_id+",").indexOf(","+_filter_id+",") >= 0)
		{
			// CALCULATE MAX TREE-DEPTH
			if(this.treedepth>this.maxtreedepth)
				this.maxtreedepth = this.treedepth;
			this.arrdata[_i+3] = this.treedepth;
				
			// ACCUMULATE PATHWAY INDEXES FOR SORTING
			this.order[_j++] = this.acc_index;
		}
		else
		{
			this.order[_j++] = this.acc_index;
			this.arrdata[_i+3] = -1;
		}
	}
		
	// QUANTISING VERTICAL TREE POSITIONS
	var indexmax = 0;
	var levelcut = ",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
	
	this.NodeData = new Array();

	for (var _i=0;_i<this.order.length;_i++)
	{
		var pathway = String(_i+","+this.order[_i]+levelcut.substring(0,this.maxtreedepth*2)).split(",");
		pathway.length = this.maxtreedepth+1;
		this.NodeData[_i] = pathway;
	}

	if(this.bDebug)
		Response.Write("(id-1),index_level1,index_level2,...<br><br>")

	// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
	if(this.bDebug)
	{
		for (var _i=0;_i<this.order.length;_i++)
			Response.Write(this.NodeData[_i]+" "+this.arrdata[this.in_interleave * Number(this.NodeData[_i][0])+4]+"<br>");
		Response.Write("<br>");
		Response.Flush();
	}
	// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////	

	// C A S C A D I N G   S O R T  //
	
	if(this.bDebug)
		Response.Write("<br>SORTING DATA<br><br>");
	
	var _sort_i = 0;
	
	// MEASURE SORTLOAD
	//function mysort(_a, _b)
	//{
	//	var _dif = _a[_sortlevel] - _b[_sortlevel];
	//	if(_dif>0) _sort_i ++;
	 //   return  _dif;
	//}
	
	function mysort(_a, _b)
	{
	    return  _a[_sortlevel] - _b[_sortlevel];
	}
	
	for(var _sortlevel=this.maxtreedepth;_sortlevel>0;_sortlevel--)
		this.NodeData.sort(mysort);
	
	this.sortload = _sort_i;
	
	//////////////////////////////////
	
	
	// DEBUGGING   v v v  /////////////////////////////////////////////////////////////////////////////////////////
	if(this.bDebug)
	{
		for (var _i=0;_i<this.order.length;_i++)
			Response.Write(this.NodeData[_i]+" "+this.arrdata[this.in_interleave * Number(this.NodeData[_i][0])+4]+"<br>");
		Response.Write("<br>");
	}
	// DEBUGGING  ^ ^ ^   /////////////////////////////////////////////////////////////////////////////////////////	

	
	// REMAP DATA INTO ORDERED ARRAY STREAM
	var _k=0;
	for (var _i=0;_i<this.order.length;_i++)
	{
		var _idx = this.in_interleave * Number(this.NodeData[_i][0]);
		//Response.Write("<br>");
		if(this.arrdata[_idx+3]>=0 && (!_filter_level || _filter_level==this.arrdata[_idx+3]))	// ONLY VIEW LEVEL >= 0
			for(var _j=0;_j<this.out_interleave;_j++)
			{
				this.treedata[_k++] = this.arrdata[_idx+this.remap[_j]];
				//Response.Write("("+(_idx+this.remap[_j])+") "+this.arrdata[_idx+this.remap[_j]]+" ");
			}
	}
	
	//Response.Write(this.treedata)
		
	return this.treedata;
}

function GUI_TREEindent(_arrdata,_branch_index)
{
	this.arrdata = _arrdata;
	this.maxtreedepth = 0;
	var bBranch  = _branch_index?true:false;

	// QUANTISING HORIZONTAL TREE INDENTATION (BY TRACKING ROOT ELEMENT)
	for (var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
	{
		this.acc_index = this.arrdata[_i+2];
		this.treedepth = 0;

		// TRACE ALL PARENT REFERENCES FROM A GIVEN POINT		
		var root_index = this.traceref(_i);

		if(bBranch==false || root_index==_branch_index)
		{
			// CALCULATE MAX TREE-DEPTH
			if(this.treedepth>this.maxtreedepth)
				this.maxtreedepth = this.treedepth;
			//this.arrdata[_i+3] = this.treedepth;
			
			// ACCUMULATE PATHWAYS
			this.order[_i/this.in_interleave] = this.acc_index;
		}
	}
	return this.arrdata;
}

function GUI_TREEtraceref(_index)
{
	var _id = this.arrdata[_index];
	var _refid = this.arrdata[_index+1];
	this.treedepth++;
	
	if(_id == _refid)
		return this.arrdata[_index+2];
	else
	{
		for (var _j=0;_j<this.arrdata.length;_j+=this.in_interleave)
			if(this.arrdata[_j] == _refid)
			{
				this.acc_id    = this.arrdata[_j+1] + "," + this.acc_id;
				this.acc_index = this.arrdata[_j+2] + "," + this.acc_index;
				 	
				this.traceref(_j);
				return this.arrdata[_j+2];
			}
	}
	
	return 0;
}

// PUT ALL ROWNRS INTO ONE LINEAR ARRAY
function GUI_TREEtraceto(_index,_thisid)
{
	var _id = this.arrdata[_index];
	var _refid = this.arrdata[_index+1];
	this.treedepth++;
	
	if(this.treedepth>100)
		return 0;

	if(_id == _refid)
		return this.arrdata[_index+2];
	else
	{
		for (var _j=0;_j<this.arrdata.length;_j+=this.in_interleave)
			if(this.arrdata[_j] == _refid)
			{
				if(this.arrdata[_j]!=_thisid)
				{
					this.acc_rownr = (_j) + "," + this.acc_rownr;
					this.traceto(_j,_thisid);
				}
				else
					this.bFoundpath = true;
				return this.arrdata[_j+2];
			}
	}
	
	return 0;
}

function GUI_TREEchildsof(_thisid,_arrdata,_branch_index)
{
	this.arrdata = _arrdata;
	
	this.maxtreedepth = 0;
	var bBranch  = _branch_index?true:false;
	var _idx = 0;
	for (var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
	{
		this.acc_rownr = _i.toString();

		// TRACE ALL PARENT REFERENCES FROM A GIVEN POINT		
		this.bFoundpath		= false;
		var root_index = this.traceto(_i,_thisid);
		
		// ACCUMULATE PATHWAYS
		if(this.bFoundpath==true && (bBranch==false || root_index==_branch_index))
			this.childs = this.childs.concat(this.acc_rownr.split(","));
			
		if(this.bIncludeRoot == true && this.arrdata[_i] == _thisid)
		{
			this.rootdepth = this.treedepth;
			this.childs = this.childs.concat(_i);
		}
			
		this.treedepth = 0;  // reset this because it is accumulative
	}
	

	
	//function numsort(_a, _b)
	//{
	//    return  _a - _b;
	//}
	
	// PURGE OUT DOUBLES
		
	this.childs = radixSort(this.childs);
	//Response.Write(this.childs+"<br>");
	var _j=0;
	var _prev_id
	for (var _i=0;_i<this.childs.length;_i++)
	{
		var bFound = false;
		

		for(var _k=_j-1;_k>=0;_k--)
		{
			//Response.Write(this.childs[_k]+" "+this.childs[_i]+"<br>")
			if(this.childs[_k] == this.childs[_i])
			{
				bFound = true;
				_k=0;
			}
		}
		
		if(bFound==false)
			this.childs[_j++] = Number(this.childs[_i]);
		_prev_id = this.childs[_i];
	}
	this.childs.length = _j;
	//return this.childs;
	//Response.Write(this.childs+"<br>");
}


function GUI_TREEchildbrothersof(_thisid,_arrdata,_branch_index)
{
	this.childs = new Array();
	this.indexit(_arrdata);
	var _j = 0;

	// FIND ALL ROWNUMBERS OF SUBNODES HAVING THE SAME PARENT (EXCEPT MAIN NODES)				
	for(var _i=0;_i<this.arrdata.length;_i+=this.in_interleave)
	{
		//Response.Write(this.arrdata[_i]+" "+this.arrdata[_i+1]+" "+(Number(this.arrdata[_i+1])==_thisid)+" "+this.arrdata[_i]+"<br>")

		var bExclude = this.bIncludeRoot == false && this.arrdata[_i] == _thisid
		
		if(this.arrdata[_i+1]==_thisid && bExclude==false)
			this.childs = this.childs.concat(_i);
	}

	return this.childs;
}

function GUI_TREEcombobox(attr,dflt,_indent_offset)
{
	var tmp = "<select "+attr+"><option value=0 "+(!dflt?"selected":"")+">";
	var interval = 7;
	_indent_offset = _indent_offset?_indent_offset:0	
	//var indent = "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -";
	var indent = " &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;"
	for (var i=0;i<this.treedata.length;i+=this.out_interleave)
	{
		if(dflt==this.treedata[i])
			this.combo_seltxt = this.treedata[i+2];
		tmp += "<option value="+this.treedata[i]+" "+(dflt==this.treedata[i]?"selected":"" )+">"+( indent.substring(0,this.treedata[i+1]*interval+(interval*_indent_offset-interval)     ))+this.treedata[i+2];
		//tmp += "<option value="+this.treedata[i]+" "+(dflt==this.treedata[i]?"selected":"" )+">"+(indent.substring(0,this.treedata[i+1]*3-3))+this.treedata[i+2];
	}
	tmp += "</select>";
	return tmp;
return ""
}

/////////////////////////////////
//  S E S S I O N   C L A S S  //
/////////////////////////////////


function GUI_SESSION()
{
	this.init	= GUI_SESSIONinit;
	this.get	= GUI_SESSIONget;
	this.param	= new Array();
	this.init();
}

function GUI_SESSIONinit()
{
}

function GUI_SESSIONget(_connect,_v)
{	
	var _v = Request.QueryString("v").Item?Request.QueryString("v").Item.decrypt("nicnac"):"";
	var _varr = _v.split(",");

	this.param["Con"] = _connect;
	this.param["uid"] = _varr[0];
	this.param["dir"] = _varr[1];
	
	// TODO EXTEND WITH DECODED V INFO
	
	return this.param;
}

///////////////////////////////
//  T A B B O X   C L A S S  //
///////////////////////////////

function tabbox()
{
	// properties
	this.bTabbed    = false;
	this.Tooltip	= "";
	this.Tabwidth   = 200;
	this.Boxwidth	= 200;
	this.Bordercolor	= "#446EB7";
	this.Tabcolor		= "#003366";
	this.TabTextcolor	= "#FFFFFF";
	this.Boxcolor		= "#d4d0c8";
	this.align = "right";
	
	// native functions
	this.get		= TabBoxget;
}

function TabBoxget( title,content )
{
	var src = "";
	var crlf = "\r\n";
	var ExtraWidth = this.Boxwidth<this.Tabwidth?0:(this.Boxwidth-this.Tabwidth);

	if (this.bTabbed)
	{
		if (title.length > 0)
		{
			src = crlf+"<TABLE border=0 bordercolor=red style=font-size:12 cellspacing=0 cellpadding=0 title='"+this.Tooltip+"'>";

			src+=crlf+"<TR>";
			  src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			  src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width="+this.Tabwidth+"></TD>";
			  src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=crlf+"</TR>";

			src+=crlf+"<TR>";
				src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD id='boxcolor' bgcolor="+this.Tabcolor+"><TABLE style=font-size:12;color:"+this.TabTextcolor+"><TR><TD NOWRAP>"+title+"</TD></TR></TABLE></TD>";
				src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=crlf+"</TR>";
			src+=crlf+"</TABLE>";
		}
		src+=crlf+"<TABLE border=0 bordercolor=red style=font-size:12 cellspacing=0 cellpadding=0 title='"+this.Tooltip+"'>";
		src+=crlf+"<TR>";
		    src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
		    src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width='"+this.Boxwidth+"'></TD>";
		    src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=crlf+"</TR>";

		src+=crlf+"<TR>";
			src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=crlf+"<TD bgcolor="+this.Boxcolor+" style=color:black align="+this.align+"><TABLE style=font-size:12><TR><TD>"+content+"</TD></TR></TABLE></TD>";
			src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=crlf+"</TR>";

		src+=crlf+"<TR>";
			src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=crlf+"</TR>";
	}
	else
	{
		src+=crlf+"<TABLE style=font-size:12 cellspacing=0 cellpadding=0 title='"+this.Tooltip+"'>";
			src+=crlf+"<TR>";
			  src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			  src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width="+this.Tabwidth+"></TD>";
			  src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			  src+=crlf+"<TD colspan=2 bgcolor=#d4d0c8 width="+this.Boxwidth+"></TD>";
			  src+=crlf+"<TD bgcolor=#d4d0c8 width=2></TD>";
			src+=crlf+"</TR>";

			src+=crlf+"<TR>";
				src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD id='boxcolor' bgcolor='#003366'><TABLE style=font-size:12;color:white><TR><TD NOWRAP>"+title+"</TD></TR></TABLE></TD>";
				src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD colspan=2 bgcolor=#d4d0c8 align="+this.align+">"+content+"</TD>";
				src+=crlf+"<TD bgcolor=#d4d0c8 width=2></TD>";
			src+=crlf+"</TR>";

		  	src+=crlf+"<TR>";
				src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
				src+=crlf+"<TD colspan=2 bgcolor=#d4d0c8></TD>";
				src+=crlf+"<TD bgcolor=#d4d0c8 width=2></TD>";
			src+=crlf+"</TR>";
	}
	src+=crlf+"<TR><TD height=5><IMG src=images/dummy.gif height=1 width=1></TD></TR>";
	src+=crlf+"</TABLE>";
	return src;
}

/////////////////////////
//  B O X   C L A S S  //
/////////////////////////

	function box()
	{

		// Native functions
		this.get		= Boxget;
		this.init		= Boxinit;
		this.open		= Boxopen;
		this.close		= Boxclose;

		// Initialisation
		this.init();
	}

	function Boxinit()
	{
		this.bTabbed		= true;
		this.Tooltip		= "";
		this.Tabwidth		= "200";
		this.Boxwidth		= "200";
		this.Stretch		= "1";
		this.Bordercolor	= "#446EB7";
		this.Tabcolor		= "#003366";
		this.Tabcolor		= "#d4d0c8";
		this.TabTextcolor	= "#FFFFFF";
		this.Boxcolor		= "#d4d0c8";
		this.crlf			= "\r\n";
	}

	function Boxopen()
	{
		var src=this.crlf+"<TABLE border=0 bordercolor=red style=font-size:12 cellspacing=0 cellpadding=0 title='"+this.Tooltip+"' width='"+this.Stretch+"'>";
		src+=this.crlf+"<TR>";
		    src+=this.crlf+"<TD ><IMG src=images/dummy.gif height=1 width='"+this.Stretch+"'></TD>";
		    src+=this.crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width='"+this.Boxwidth+"'></TD>";
		    src+=this.crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=this.crlf+"</TR>";

		src+=this.crlf+"<TR>";
			src+=this.crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=this.crlf+"<TD bgcolor="+this.Boxcolor+" style=color:black align=right><TABLE style=font-size:12><TR><TD>"
		return src;
	}

	function Boxclose()
	{
		var src="</TD></TR></TABLE></TD>";
			src+=this.crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=this.crlf+"</TR>";
		src+=this.crlf+"<TR>";
			src+=this.crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=this.crlf+"<TD bgcolor="+this.Bordercolor+"><IMG src=images/dummy.gif height=1 width=1></TD>";
			src+=this.crlf+"<TD ><IMG src=images/dummy.gif height=1 width=1></TD>";
		src+=this.crlf+"</TR>";

		src+=this.crlf+"<TR><TD height=5><IMG src=images/dummy.gif height=1 width=1></TD></TR>";
		src+=this.crlf+"</TABLE>";
		return src;
	}

	function Boxget( content )
	{
		return this.open() + content + this.close();
	}


//////////////////////////
// S B O X   C L A S S  //
//////////////////////////

function sbox(src,width)
{
	var s;
	if (width==100)
	{
		//s = "<table cellspacing=0 cellpadding=0 bgcolor=black><tr><td width=102 align=center>"+src+"</td><td width=10><img src=../images/sbox1.gif valign=top><br><img src=../images/sbox2.gif></td></tr><tr><td colspan=2><img src=../images/sbox3.gif><img src=../images/sbox4.gif><img src=../images/sbox5.gif></td></tr></table>\r\n"	
	
	    s = "<table cellspacing=0 cellpadding=0>"
	        +"<tr><td width=112 height=1 align=left><img src=../images/pix.gif width=102 height=1></td></tr>"
	        +"<tr><td><img src=../images/pix.gif width=1 height=100>"+src+"<img src=../images/ibox21.gif width=11 height=100></td></tr>"
	        +"<tr><td><img src=../images/ibox20.gif width=112 height=12></td></tr>"
			+"</table>\r\n";

	
/*
		s = "<table cellpadding=0 cellspacing=0>"
		+"<tr>"
		+"<td><table cellpadding=1 cellspacing=0 bgcolor=#000000><tr><td width="+width+">"+src+"</td></tr></table></td>"
		+"<td valign=top><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14><br><img src=../images/sbox2.gif WIDTH=10 HEIGHT="+(width-12)+" border=0></td>"
		+"</tr>"
		+"<tr>"
		+"<td><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11><img src=../images/sbox4.gif width="+(width-12)+" height=11 border=0></td>"
		+"<td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11 border=0></td>"
		+"</tr>"
		+"</table>";
*/
/*
		s = "<table cellpadding=0 cellspacing=0 bgcolor=black>"
		+"<tr height=102 width=102>"
		+"   <td width=102><img src=../images/sbox6.gif width=102 height=1 border=0><br><img src=../images/sbox7.gif width=1 height=100 border=0>"+src+"<img src=../images/sbox7.gif width=1 height=100 border=0><br><img src=../images/sbox6.gif width=102 height=1 border=0></td>"
		+"   <td width=10><img src=../images/sbox1.gif width=10 height=14 border=0><br><img src=../images/sbox2.gif width=10 height="+(width-12)+" border=0></td>"
		+"</tr>"
		+"<tr height=11 width=102>"
		+"   <td><img src=../images/sbox3.gif width=14 height=11 border=0><img src=../images/sbox4.gif width="+(width-12)+" height=11 border=0></td>"
		+"   <td width=10><img src=../images/sbox5.gif width=10 height=11 border=0></td>"
		+"</tr>"
		+"</table>";
*/	
		}
	else
		s = "<table cellpadding=0 cellspacing=0>"
		+"<tr>"
		+"<td><table cellpadding=1 cellspacing=0 bgcolor=#000000><tr><td>"+src+"</td></tr></table></td>"
		+"<td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td>"
		+"</tr>"
		+"<tr>"
		+"<td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td>"
		+"<td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td>"
		+"</tr>"
		+"</table>";
	return s;
}

function sbox2(src,width)
{
	var s =
	"<table cellpadding=0 cellspacing=0>"
	+"<tr>"
		+"<td>"
		+"<table cellpadding=0 cellspacing=0><tr><td"+(width?(" width="+width):"")+">"+src+"</td></tr></table>"
		+"</td>"
		+"<td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td>"
	+"</tr>"
	+"<tr>"
		+"<td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td>"
		+"<td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td>"
	+"</tr>"
	+"</table>";
	
	return s;
}

function sbox3(src)
{
	var s = "<table cellpadding=0 cellspacing=0>"
			+"<tr><td><img src=../images/dot.gif width=1 height=10></td></tr>"
			+"<tr><td>"+src+"</td><td><img SRC=../images/ads/banner_sh1.gif WIDTH=4 HEIGHT=98></td></tr>"
			+"<tr><td colspan=2><img SRC=../images/ads/banner_sh2.gif WIDTH=200 HEIGHT=5></td></tr>"
			+"</table>";
	
	return s;
}

function box_on()
{
	var s =
	"<table cellpadding=0 cellspacing=0>"
	+"<tr>"
	+"<td><table cellpadding=0 cellspacing=0><tr><td>"
	return s;
}

function box_off()
{
	var s = "</td></tr></table></td>"
	+"<td valign=top background=../images/sbox2.gif><img src=../images/sbox1.gif WIDTH=10 HEIGHT=14></td>"
	+"</tr>"
	+"<tr>"
	+"<td align=left background=../images/sbox4.gif><img src=../images/sbox3.gif WIDTH=14 HEIGHT=11></td>"
	+"<td><img src=../images/sbox5.gif WIDTH=10 HEIGHT=11></td>"
	+"</tr>"
	+"</table>";
	return s;
}

//////////////////////////////
// R E V I E W   C L A S S  //
//////////////////////////////

function rev()
{
	// Native functions
	this.get		= Revget;
	this.write		= Revwrite;
	this.init		= Revinit;
	//this.open	= Revopen;
	//this.close	= Revclose;
		
	// Initialisation
	this.init();
}

function Revinit(param)
{
	this.img			= "";
	this.imgpath		= "../images/full/";
	this.imgwidth		= "100";
	this.imgheight		= "";
	this.title			= "";
	this.author			= "";
	this.review			= "";
	this.finish			= "";
	this.ref			= "";
	this.publisher		= "";
	this.url			= "";
	this.price			= "";
	this.desc			= "";
	this.place			= "";
	this.date			= "";
	this.bTogglePos		= false;
	this.align			= "left";
	this.vspace			= 0;
	this.hspace			= 0;
	this.website1		= "../images/website1.gif";
	this.website2		= "../images/website2.gif";
	this.email1			= "../images/email1.gif";
	this.email2			= "../images/email2.gif";
	this.skinnr			= 0;
	
	this.skin0			= RevSkin0;
	this.skin1			= RevSkin1;
	this.skin2			= RevSkin2;
	this.skin3			= RevSkin3;
	this.skin4			= RevSkin4;
	
	this.crlf			= "\r\n";
}

function Revwrite(param)
{
	Response.Write(this.get(param));
}

function Revget(param)
{

	// img title author review finish ref publisher price
	if (param)
	{

		
		if (param.length==9)
		{
			this.width		= _body_width;
			this.img		= param[0];
			this.title		= param[1];
			this.author		= param[2];
			this.review		= param[3];
			this.finish		= param[4];
			this.ref		= param[5];
			this.publisher	= param[6];
			this.url		= param[7];
			this.price		= param[8];
		}
		
		// gallery		
		if (param.length==7 && this.skinnr !=4)
		{
			this.width		= _body_width;
			this.img		= param[0];
			this.title		= param[1];
			this.url		= param[2];
			this.email		= param[3];
			this.review		= param[4];
			this.img1		= param[5];
			this.img2		= param[6];
		}
		
		// books
		if (param.length==7 && this.skinnr ==4)
		{
			this.width		= _body_width;
			this.img		= param[0];
			this.title		= param[1];
			this.desc		= param[2];
			this.header		= param[3];
			this.language	= param[4];
			this.url		= param[5];
			this.email  = param[6];
		}		
		
		// agenda
		if (param.length==12)
		{
			this.width		= _body_width;
			this.id			= param[0];
			this.title		= param[1];
			this.datefrom	= param[2];
			this.dateto		= param[3];
			this.desc		= param[4];
			this.img		= param[5];
			this.review		= param[6];
			this.place		= param[7];
			this.phone		= param[8];
			this.fax		= param[9];
			this.email		= param[10];
			this.url		= param[11];
		}		
	}
	
	switch(this.skinnr)
	{
		case 0: return this.skin0();
		case 1: return this.skin1();
		case 2: return this.skin2();
		case 3: return this.skin3();
		case 4: return this.skin4();
	}
	
}

function RevSkin0()
{
	var s = "";
	s += "<table><tr>"+this.crlf;
	s += "<td>"+this.crlf;
	s += "<p class=bodybold><b>"+this.title + "</b><br>"+this.crlf;
	s += this.author + "</p>"+this.crlf;
	s += "</td>"+this.crlf;
	s += "</tr></table><br>"+this.crlf;

	//s += box_on();
	s += "<table cellspacing=1 cellpadding=8 bgcolor=#E0E0E0 width="+this.width+"><tr>"+this.crlf;
	s += "<td bgcolor=white colspan=2>"
	
	s += "<table height=100% ><tr>"+this.crlf;
	s += "<td valign=top>" + sbox2("<img src="+this.imgpath+this.img+" "+(this.imgwidth?("width="+this.imgwidth):"")+" "+(this.imgheight?("height="+this.imgheight):"")+" align="+this.align+" border=0 vspace="+this.vspace+" hspace="+this.hspace+">") + this.crlf;
	s += "</td>"+this.crlf;
	s += "<td style=vertical-align:top class=body>"+this.crlf;
	
	if (this.publisher && this.url)
		s += "<table height=100% cellspacing=0 cellpadding=0><tr><td style=vertical-align:top class=body>"+this.review+"</td></tr><tr><td align=right><a href='"+this.url+"' title='"+this.url+"' target=_blank><img src='"+this.website1+"' alt='"+this.url+"' border=0 onmouseover=this.src='"+this.website2+"' onmouseout=this.src='"+this.website1+"'></a></td></tr></table>"
	else
		s += this.review + this.crlf;
		
	s += "</td>"+this.crlf;
	s += "</tr></table>"+this.crlf;

	s += "</td>"+this.crlf;

	s += "</tr><tr>"+this.crlf;

	s += "<td bgcolor=white class=body><i>"+this.finish+"</i></td>"+this.crlf;
	s += "<td bgcolor=white width=25% class=body><i>"+this.ref+"</i></td>"+this.crlf;

	s += "</tr><tr>"+this.crlf;

	s += "<td bgcolor=white class=body>"+this.crlf;
		s += "<table cellspacing=0 cellpadding=0 width=100% ><tr>"+this.crlf;
		s += "<td align=left class=body><i>"+this.publisher+"</i></td>"+this.crlf;
		if (!this.publisher && this.url)
			s += "<td align=right class=body><a href='"+this.url+"' title='"+this.url+"' target=_blank><img src='"+this.website1+"' alt='"+this.url+"' border=0 onmouseover=this.src='"+this.website2+"' onmouseout=this.src='"+this.website1+"'></a></td>"+this.crlf;
		else
			s += "<td></td>";
		s += "</tr></table>"+this.crlf;
	s+= "</td>"+this.crlf;
	s+= "<td bgcolor=white class=body style=text-align:right><i>"+this.price+"</i></td>"+this.crlf;
	s+= "</tr></table>"+this.crlf;
	
	//s += box_off();
	s += "<br><br>"+this.crlf;
	
	if (this.bTogglePos)
		this.align = this.align!="right"?"right":"left"
	return s;
}

function RevSkin1()
{
	var s = "";


	s += "<table width="+this.width+" cellspacing=1 class=qtable>"+this.crlf;
	s += "<tr>"+this.crlf;
	s += "	<td width=10% rowspan=3 bgcolor=white valign=top class=qnormal>"+this.crlf;
if (this.img)
	s += sbox2("<table bgcolor=black cellspacing=1><tr><td bgcolor=white><img src="+this.imgpath+this.img+"?"+(Math.floor(Math.random()*100))+"></td></tr></table>")+this.crlf;

	s += "	</td>"+this.crlf;
	s += "<td  bgcolor=white class=qnormal>"+Title(this.title,50,0x6A9CBD,0x367AA9)+"</td>"+this.crlf;
	s += "</tr>"+this.crlf;
	s += "<tr>"+this.crlf;
	s += "	<td bgcolor=white>"+this.crlf;
	if (mywebsite)
		s += "<a href="+this.url+" title="+this.url+" target=_blank><img src=../images/website1.gif alt="+this.url+" border=0 onmouseover=this.src='../images/website2.gif' onmouseout=this.src='../images/website1.gif' WIDTH=100 HEIGHT=25></a>"+this.crlf;
	s += "	</td>"+this.crlf;
	s += "</tr>"+this.crlf;
	s += "<tr>"+this.crlf;
	s += "	<td bgcolor=white>"+this.crlf;
	if (myemail)
		s += "<a href=\"mailto:"+this.email+"\" title=\""+this.email+"\"><img src=\""+this.email1+"\" alt="+this.email+" border=0 onmouseover=this.src=\""+this.email2+"\" onmouseout=this.src=\""+this.email1+"\" WIDTH=90 HEIGHT=25></a>"
	s += "	</td>"+this.crlf;
	s += "</tr>"+this.crlf;
	if (mytext)
		s += "<tr><td colspan=2 bgcolor=white><p align=justify>"+this.review+"</p></td></tr>"+this.crlf;
	s += "</table>"+this.crlf;
	
	s += "<img src=../images/spacer.gif height=4><br>"+this.crlf;
	
	s += "<table width="+this.width+" cellspacing=1 class=qtable>"+this.crlf;
	s += "<tr>"+this.crlf;
	s += "	<td bgcolor=white class=qnormal>"+this.crlf;
	s += "		<table>"+this.crlf;
	s += "		<tr>"+this.crlf;
	s += "			<td width=170>"+this.crlf;
if (this.img1)
	s +=				sbox2("<table bgcolor=black cellspacing=1><tr><td bgcolor=white><img src="+this.imgpath+this.img1+"?"+(Math.floor(Math.random()*100))+"></td></tr></table>")+this.crlf;

	s += "			</td>"+this.crlf;
	s += "			<td width=170>"+this.crlf;
if (this.img2)
	s +=			sbox2("<table bgcolor=black cellspacing=1><tr><td bgcolor=white><img src="+this.imgpath+this.img2+"?"+(Math.floor(Math.random()*100))+"></td></tr></table>")+this.crlf;
	
	s += "			</td>"+this.crlf;
	s += "		</tr>"+this.crlf;
	s += "		</table>"+this.crlf;
	s += "	</td>"+this.crlf;
	s += "</tr>"+this.crlf;
	s += "</table>"+this.crlf;
	s += "<br>"+this.crlf;
	s += "<br>"+this.crlf;
	
	return s;
}

function RevSkin2()
{
	var s = "";
	s += "<table><tr>"+this.crlf;
	s += "<td>"+this.crlf;
	
	if (this.title)
		s += "<span class=title>"+this.title+"</span><br>"+this.crlf;
	s += "<span class=voetnoot>"+this.desc+"</span><br><br>";
	
	var fromto = "";
	if (typeof(this.datefrom)=="object")
	{
		var ynow = new Date().format("%Y");
		var yfrom = new Date(this.datefrom).format("%Y");
		
		fromto += new Date(this.datefrom).format("%d %B","nl-be");
		if (  ynow != yfrom || yto && ynow != yto )
			fromto += " <span class=voetnoot>" + yfrom + "</span>";
		
		
		var yto = "";
		
		if (typeof(this.dateto)=="object")
			if (new Date(this.datefrom).format("%d%m%Y") != new Date(this.dateto).format("%d%m%Y"))
			{
				fromto += " - "+new Date(this.dateto).format("%d %B","nl-be");
				yto = new Date(this.dateto).format("%Y");
				if (  ynow != yfrom || yto && ynow != yto)
					fromto += " <span class=voetnoot>"+ yto + "</span>";
			}

	}
	
	s += "<span class=voetnoot><b>"+fromto+"</b></span>"+this.crlf;
	
	/*
	if (this.datefrom)
		s += new Date(this.datefrom).format("%d.%m.%Y")

	if (this.dateto)
		s +=" - "+new Date(this.dateto).format("%d.%m.%Y")+"<br>"+this.crlf;
	else
		s +="<br>"+this.crlf;
	*/

	s += "</td>"+this.crlf;
	s += "</tr></table>"+this.crlf;

	//s += box_on();
	s += "<table cellspacing=1 cellpadding=8 bgcolor=#E0E0E0 width="+this.width+"><tr>"+this.crlf;
	s += "<td bgcolor=white colspan=2>"
	
	s += "<table height='100%'><tr>"+this.crlf;
	
	if (this.bCalendar)
	{
		this.bHTML = true;
		this.img = oCalendar.get(tmp,this.img);
	}
	
	/*
	if (this.bHTML)
		s += "<td valign=top>" + sbox2(this.img) + this.crlf;
	else
		s += "<td valign=top>" + sbox2("<img src="+this.imgpath+this.img+" "+(this.imgwidth?("width="+this.imgwidth):"")+" "+(this.imgheight?("height="+this.imgheight):"")+" align="+this.align+" border=0 vspace="+this.vspace+" hspace="+this.hspace+">") + this.crlf;

	s += "</td>"+this.crlf;
	*/
	
	s += "<td style=vertical-align:top class=body>"+this.crlf;
	
	s += this.review + this.crlf;
		
	s += "</td>"+this.crlf;
	s += "</tr></table>"+this.crlf;

	s += "</td>"+this.crlf;

	s += "</tr><tr>"+this.crlf;

	if (this.place)
		s += "<td bgcolor=white class=body width='75%'><i>"+this.place+"</i></td>"+this.crlf;
	else
		s+= "<td bgcolor=white></td>"+this.crlf;
		
	s += "<td bgcolor=white class=body  width='25%'>";
	if (this.phone)
	{
		var arr = this.phone.split(",");
		for(var i=0;i<arr.length;i++)
			s += "<img src=../images/phone.gif> <small>"+arr[i]+"</small><br>";
	}
	if (this.fax)
	s += "<img src=../images/fax.gif> <small>"+this.fax+"</small><br>";
	if (this.email)
		s += "<a href=\"mailto:"+this.email+"\" title=\""+this.email+"\"><img src=\""+this.email1+"\" alt="+this.email+" border=0 onmouseover=this.src=\""+this.email2+"\" onmouseout=this.src=\""+this.email1+"\" WIDTH=90 HEIGHT=25></a><br>"
	if (this.url)
		s += "<a href='"+this.url+"' title='"+this.url+"' target=_blank><img src='"+this.website1+"' alt='"+this.url+"' border=0 onmouseover=this.src='"+this.website2+"' onmouseout=this.src='"+this.website1+"' WIDTH=90 HEIGHT=25></a>";

	s += "</td>"+this.crlf;
	s+= "</tr></table>"+this.crlf;
	
	//s += box_off();
	
	s += "<br><br>"+this.crlf;
	
	return s;
}

function RevSkin3()
{
/*
	var s = "<STYLE>"
		  + ".qtable {"
		  + " background-color: #e0e0e0;"
		  + " font-family: Verdana;"
		  + " font-size: 11px;"
		  + "}"
		  + ".qtable td"
		  + "{"
		  + "background-color: white;"
		  + "padding-left: 2px;"
		  + "padding-right: 2px;"
		  + "padding-top: 0px;"
		  + "padding-bottom: 0px;"
		  + "white-space: nowrap;"
		  + "}"
		  + "</STYLE>";
		  
  s +=  "<table cellspacing=1 class=qtable width="+_body_width+">"
*/

var  s =   "<tr>"
	   +"<td><a href=04_02_03_index.asp#"+this.id+">"+new Date(this.datefrom).format("%d.%m");

     if (this.dateto)	   
     	s +=" - "+new Date(this.dateto).format("%d.%m")+"</a></td>"

     s+=    "<td>"+this.title +"</td>"
	   +"<td>"+this.desc+"</td>"
	   +"</tr>"
/*
	   +"</table>";


			this.title		= param[0];
			this.datefrom	= param[1];
			this.dateto		= param[2];
			this.desc		= param[3];
			this.img		= param[4];
			this.review		= param[5];
			this.place		= param[6];
			this.phone		= param[7];
			this.email		= param[8];
			this.url		= param[9];
*/
	   
	   return s;
}

function RevSkin4()
{
	var s = "";
	s += "<table><tr>"+this.crlf;
	s += "<td>"+this.crlf;

	s += "</td>"+this.crlf;
	s += "</tr></table>"+this.crlf;

	s += "<table cellspacing=1 cellpadding=8 bgcolor=#E0E0E0 width="+this.width+"><tr>"+this.crlf;
	s += "<td bgcolor=white height=135 valign=top>";
	
	
	
	
	if (this.img)
	{
		s += this.img;
		//	s += sbox("<a href='"+this.url+"' title='"+this.url+"' target=_blank>"+this.img+"</a>")+this.crlf;
	}
	
	s += "</td>";
	s += "<td bgcolor=white>"
	
	s += "<table height='100%'><tr>"+this.crlf;
	
	s += "<td class=body style=vertical-align:top>"+this.crlf;
	
	if (this.title)
		s += "<p class=bodybold><b><big>"+this.title + "</b></big><br>"+this.crlf + this.desc + "</p>"+this.crlf;
	
	s += this.header + this.crlf;
		
	s += "</td>"+this.crlf;
	s += "</tr></table>"+this.crlf;

	s += "</td>"+this.crlf;

	s += "</tr><tr>"+this.crlf;

	s += "<td bgcolor=white class=body width='20%'>"
	
	if (this.url)
		s += "<center><a href='"+this.url+"' title='"+this.url+"' target=_blank><img src='"+this.website1+"' alt='"+this.url+"' border=0 onmouseover=this.src='"+this.website2+"' onmouseout=this.src='"+this.website1+"' WIDTH=90 HEIGHT=25></a></center>";
	if (this.email)
		s += "<center><a href=\"mailto:"+this.email+"\" title=\""+this.email+"\"><img src=\""+this.email1+"\" alt="+this.email+" border=0 onmouseover=this.src=\""+this.email2+"\" onmouseout=this.src=\""+this.email1+"\" WIDTH=90 HEIGHT=25></a></center>"

	s += "</td>"+this.crlf;
		
	s += "<td bgcolor=white class=body width='80%'><i>"+this.language+"</i></td>"+this.crlf;

	s+= "</tr></table>"+this.crlf;

	
	s += "<br><br>"+this.crlf;
	
	return s;
	
	
	/*
					 js
				,formarr[enumfld["title"]]
				,formarr[enumfld["desc"]]
				,formarr[enumfld["header"]]
				,formarr[enumfld["language"]]
				,formarr[enumfld["url"]]
	*/
}

function virtuaTag(virtuaTag_text)
{
	strOutput = virtuaTag_text.replace(/\<[^\>]+\>/g, "")
	return strOutput;
}

///////////////////////////////////
// T I T L E   G E N E R A T O R //
///////////////////////////////////

	function Title(text,size,lCol,rCol)
	{
		var init = " style=font-family:Times;font-style:italic;font-size:"+size+"px;line-height:";
			
		var colortext = "";
		
		// SHADOW
		//colortext += "<TABLE"+init+(size+10)+"px;margin-left:5px;filter:alpha(opacity=15);color=#000000><TR><TD>"+text+"</TD></TR></TABLE>";
		//colortext += "<DIV  "+init+ size+"px;margin-top:-"+(size+15)+"px;margin-left:2px;color=#000000>"+text+"</DIV>";
		//colortext += "<DIV  "+init+ size+"px;margin-top:-"+(size-1)+"px;margin-left:-2px;color=#FFFFFF>"+text+"</DIV>";
		//colortext += "<DIV  "+init+ size+"px;margin-top:-"+(size-1)+"px>";
		
		colortext += "<TABLE"+init+size+"px;color=#000000><TR><TD>"+text+"</TD></TR></TABLE>";
		colortext += "<DIV  "+init+ size+"px;margin-top:-"+(size+2)+"px;margin-left:-2px;color=#FFFFFF>"+text+"</DIV>";
		colortext += "<DIV  "+init+ size+"px;margin-top:-"+(size-1)+"px>";
		
		if (!text)
			return "";
			
		var len = text.length;

		for (var i=0;i<len;i++)
			colortext += "<FONT color=#"+GetHEXCol(GetInterpCol(GetRGBCol(lCol),GetRGBCol(rCol),i/(len-1)))+">"+text.charAt(i)+"</FONT>";
		colortext +="</DIV>";
		return colortext;
				
	}

	function GetInterpCol(RGB1,RGB2,pct)
	{
		var RGB = new Array(3);
		for (var i=0;i<3;i++)
			RGB[i]=RGB1[i]+(RGB2[i]-RGB1[i])*pct;	
		return (RGB[0]<<16 | RGB[1]<<8 | RGB[2]);
	}


	function GetRGBCol(Col)
	{
		var Range = new Array(3);
		for (var i=2;i>=0;i--)
		{
			Range[i]=Col&0xFF;
			Col=Col>>8;
		}
		return Range;
	}

	function GetHEXCol(Col)
	{
		var strCol='';
		var Hex = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];		
		for (var i=0;i<6;i++)
		{
			strCol=Hex[Col&0xF]+strCol;
			Col=Col>>4;
		}	
		return strCol;
	}
		
	function zerofill(arg,n)
	{
		var z = "0000000000" + arg;
		return z.substring(z.length-n,z.length)
	}
	
	function anyfill(arg,n,char)
	{
		var _anyfill_str = arg;
		for(var _anyfill_i=n-arg.length;_anyfill_i>0;_anyfill_i--)
			_anyfill_str = char + _anyfill_str;
		return _anyfill_str;
	}	

	function Replace(expression,find,replacement)
	{
		replacement = replacement?replacement:"";

		if (find && expression)
		{
			var pos = expression.indexOf(find);
			if (pos>=0)
				return expression.substring(0,pos)+replacement+expression.substring(pos+find.length,expression.length)
			else
				return expression;
		}
	}
	
	function ParseDate(curDate)
	{
		var century = 20;

		if (!curDate)
			return "";

		switch (curDate.length)
		{
		case 0:
			return "";
		case 6:
			if (Number(curDate.substring(4,6))>90)
				century = 19;
			var tempDate = curDate.substring(2,4) + "/" + curDate.substring(0,2) + "/" + century + curDate.substring(4,6);
			if (IsDate(tempDate))
				return new Date(tempDate);	// format DDMMYY
			break;
		case 8:
			var sign = curDate.substring(3,1);
			if (!(IsNumeric(sign) && IsNumeric(curDate.charAt(5))))
			{
				if (Number(curDate.substring(6,8))>90)
					century = 19;
				var tempDate = curDate.substring(3,5) + "/" + curDate.substring(0,2) + "/" + century + curDate.substring(6,8);
				if (IsDate(tempDate))
					return new Date(tempDate);	// format DDxMMxYY
			}
			else
			{
				var tempDate = curDate.substring(2,4) + "/" + curDate.substring(0,2) + "/" + curDate.substring(4,9);
				if (IsDate(tempDate))
					return new Date(tempDate);	// format DDMMYYYY
			}
			break;
		case 10:
			var tempDate = curDate.substring(3,5) + "/" + curDate.substring(0,2) + "/" + curDate.substring(6,10)
			if (IsDate(tempDate))						// format DDxMMxYYYY
				return new Date(tempDate);
			break;
		}
		return;
	}

function IsDate(arg)
{
	//Response.Write(arg+"<BR>")
	// TODO VALIDATE DATE
	return true;
}

function IsNumeric(arg)
{
	return !isNaN(Number(arg));
}




function base64encode(base64encode_n)
{
	var base64encode_str='';
	var Base64 = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','_'];		
	for (var enc_i=0;enc_i<4;enc_i++)
	{
		base64encode_str=Base64[base64encode_n&0x3F]+base64encode_str;
		base64encode_n=base64encode_n>>6;
	}	
	return base64encode_str;
}

function base32encode(base32encode_n)
{
	var base32encode_str='';
	var Base32 = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5'];		
	for (var enc_i=0;enc_i<8;enc_i++)
	{
		base32encode_str=Base32[base32encode_n&0x1F]+base32encode_str;
		base32encode_n=base32encode_n>>5;
	}	
	return base32encode_str;
}

function hex2base64( hex2base64_str )
{
	var hex2base64_s = "";
	hex2base64_str = hex2base64_str.digitmod(3);   //zerofill( hex2base64_str,hex2base64_str.length+(hex2base64_str.length%3));
	for (var hex2base64_i=0;hex2base64_i<hex2base64_str.length;hex2base64_i+=6)		
		hex2base64_s += base64encode(Number( "0x"+hex2base64_str.substring(hex2base64_i,hex2base64_i+6) ));
	return hex2base64_s;
}

function base64decode( base64decode_n )
{
	var base64decode_n = base64decode_n.lfill64code();
	var Base64 = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','_'];		
	var invBase64 = new Array();
	for (var base64decode_i=0;base64decode_i<Base64.length;base64decode_i++)
		invBase64[new String(Base64[base64decode_i])] = base64decode_i;
			
	var base64decode_div = 64*64*64;
	var base64decode_v = 0;
	for(var base64decode_i=0;base64decode_i<4;base64decode_i++)
		base64decode_v += (base64decode_div>>(6*base64decode_i)) * invBase64[base64decode_n.charAt(base64decode_i)];  // multiplier * decimal parts

	return parseInt("0x"+GetHEX6(base64decode_v));
}

function base642hex( base642hex_str )
{
	var base642hex_s = "";
	for (var base642hex_i=0;base642hex_i<base642hex_str.length;base642hex_i+=4)
		base642hex_s += base64decode( base642hex_str.substring(base642hex_i,base642hex_i+4) );			
	return base642hex_s.toLowerCase();
}


///////////////////////////
//  H T T P   C L A S S  //
///////////////////////////

	
function HTTP()
{
	this.path					= "";
	this.name					= "";
	this.http					= Server.Createobject("Dynu.HTTP");
	this.get					= HTTP_get;
	this.url_splitter			= HTTP_url_splitter;
	this.url_argument_splitter	= HTTP_url_argument_splitter;
	this.labeltrack				= HTTP_labeltrack;
	this.spider					= HTTP_spider;
}

function HTTP_get(_name,_path,_arg_arr)
{
	if(!_name) _name = this.name;
	if(!_path) _path = this.path;
		
	var _urlsplit_arr = HTTP_url_splitter(_name);   // SPLIT URL INTO BASENAME, EXTENTION, ARGUMENTS
	//Response.Write("["+_urlsplit_arr[2]+"]");
		
	this.http.Reset();
		
	if(_urlsplit_arr[2])
		this.http.SetQueryString(_urlsplit_arr[2]);

	this.http.SetHeader("user-agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)");
	//Response.Write("get("+_path+_urlsplit_arr[0]+_urlsplit_arr[1]+") ["+_arg_arr+"]<br>");
	this.http.SetURL(_path+_urlsplit_arr[0]+_urlsplit_arr[1]);
	if(_arg_arr)
		for(var _get_i=0;_get_i<_arg_arr.length;_get_i+=2)
		{
			//Response.Write("["+_arg_arr[_get_i]+"]["+_arg_arr[_get_i+1]+"]");
			this.http.SetFormData(_arg_arr[_get_i],_arg_arr[_get_i+1]);
		}	
			
	return this.http.PostURL();
}

function HTTP_url_splitter(_str)
{
	// SPLITTING URL INTO 3 PARTS : FILENAME, EXTENTION , ARUMENTS, INNERPAGE REF
	var _dot_pos = _str.lastIndexOf(".");
	var _qq_pos = _str.indexOf("_Q_");
	var _q_pos = _str.indexOf("?");
		
	if(_qq_pos>=0)
	{
		// ISAPI ARGUMENTS
		var _ext  = _str.substring(_dot_pos,_str.length);
		var _args = _str.substring(_qq_pos+3,_dot_pos);
		_args = _args.replace(/_Q_/g,"?");
		_args = _args.replace(/_E_/g,"=");
		_args = _args.replace(/_A_/g,"&");
		var _name = _str.substring(0,_qq_pos);
	}
	else if(_q_pos>=0)
	{
		// NORMAL ARGUMENTS
		var _ext = _str.substring(_dot_pos,_q_pos);
		var _args = _str.substring(_q_pos+1,_str.length);
		var _name = _str.substring(0,_dot_pos); 
	}
	else
	{
		// NO ARGUMENTS
		var _ext = _str.substring(_dot_pos,_str.length);
		var _args = "";
		var _name = _str.substring(0,_dot_pos);
	}
		
	var _ref = "";
	var _ref_pos = _ext.lastIndexOf("#");
	if(_ref_pos>=0)
	{
		_ref = _ext.substring(_ref_pos+1,_ext.length);
		_ext = _ext.substring(0,_ref_pos);
	}
		
	return [_name,_ext,_args,_ref];	
}
	
function HTTP_url_argument_splitter(_str)
{
	var _arg_arr = new Array();
	var _j = 0;
	var _strarr = _str.split("&");
	for( var _arg_i=0 ; _arg_i<_strarr.length ; _arg_i++)
	{
		var _tmp = _strarr[_arg_i].split("=");
		_arg_arr[_j++] = _tmp[0];
		_arg_arr[_j++] = _tmp[1];
	}
	return _arg_arr;
}
	
function HTTP_labeltrack(_str,_find,_exclude_arr)
{
	if(!_str)
		return;
			
	var _exclude = "";
	if(_exclude_arr)
		_exclude = ","+_exclude_arr.join(",")+"," 

	_str = _str.replace(/<A/g,"<a");  // REPLACE ALL UPPERCASE ANCHORS
		
	var href_arr = new Array();
	var href_i = 0;
		
	var _arr = _str.split("<a");
		
	//Response.Write("#<textarea cols=200 rows=20>"+_str+"</textarea>#")	
		
	for(var _i=1;_i<_arr.length;_i++)
	{
		var _anchor = "<a" + _arr[_i].substring(0,_arr[_i].indexOf(">"))+">";
		href_pos = _anchor.indexOf("href=");
		if(_find)
			find_pos = _find?_anchor.indexOf(_find):-1;  // LOOK FOR TRACKING LABEL IF APPLICABLE
				
		//Response.Write("#<textarea id=textarea1 name=textarea1>"+_anchor+"</textarea>#")	
				
		// EXTRACT HREF INFORMATION FROM ANCHORS
		if(href_pos>0 && (find_pos>0 || !_find))
		{					
				var href_txt = _anchor.substring(href_pos+5,_anchor.length);
				if(_anchor.charAt(href_pos+5)=="\"")
				{
					// href between quotes
					href_txt = href_txt.substring(1,href_txt.indexOf("\""));
						
					if(_exclude.indexOf(","+href_txt+",")<0)
						href_arr[href_i++] = href_txt;
				}
				else
				{
					// href ending with space or endtag
					var space_pos = href_txt.indexOf(" ");
					if(space_pos>0)
						href_txt = href_txt.substring(0,href_txt.indexOf(" "));
					else
						href_txt = href_txt.substring(0,href_txt.indexOf(">"));
							
					if(_exclude.indexOf(","+href_txt+",")<0)
						href_arr[href_i++] = href_txt;
				}
		}				
	}
	return href_arr;
}

	
function HTTP_spider(_arg)
{
	var level = 0;
	var _inc		   = new Array();
	var _trackback_arr = new Array();
	var _visited	   = new Array();
		
	recursive_linktrack(_arg);		// START RECURSIVE LOOP
		
	function recursive_linktrack(_trackback_links)
	{
		if(_trackback_links.length==0)
			return;
			
		level++;
		if(level>20)		// STACK OVERLOAD PROTECTION
			return;
	
		_trackback_arr[level] = _trackback_links;
		_visited = _visited.concat(_trackback_links);	// ADD TO VISITED LINKS
			
		for(_inc[level]=0;_inc[level]<_trackback_arr[level].length;_inc[level]++)
		{
			var link = _trackback_arr[level][_inc[level]];
			var txt = oHttp.get(link,oHttp.path);						// GET HTML PAGE
			var arr = oHttp.labeltrack(txt,"rel=trackme",_visited);		// TRACK ALL LINKS OF INTEREST AND EXCLUDE VISITED LINKS
				
			//var levelspc = ("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;").substring(0,(level-1)*12)
			//Response.Write(levelspc+"found "+arr.length+" linktracks<br><br>");
				
			recursive_linktrack(arr);
		}	
		level--;
		return;
	}
		
	return _visited;
}

function csv2array(_csvstr,_sep,_bNoBackslashQuote)
{
	_sep = _sep?_sep:",";
	_bNoBackslashQuote = _bNoBackslashQuote?true:false;

	var _bQuoted = false;
	var _acc = "";

	var _arr = _csvstr.split("\"\"");
	var _output = new Array()
	var _output_i = 0;

	for(var _i=0;_i<_arr.length;_i++)
	{
		var _arr2 = _arr[_i].split("\"");
		for(var _j=0;_j<_arr2.length;_j++)
		{
			var _arr3 = _arr2[_j].split(_sep);
			for(var _k=0;_k<_arr3.length;_k++)
			{
				if(_bQuoted)
					_acc += _arr3[_k] + (_k<(_arr3.length-1)?_sep:"")
				else
				{
					if(_k<(_arr3.length-1))
					{
						_output[_output_i++] = _acc + _arr3[_k];
						_acc = "";
					}
					else
						_acc += _arr3[_k];

				 }
			}
			_bQuoted =   _j<(_arr2.length-1)?!_bQuoted:_bQuoted;

			/*   LEAVE UNQUOTED !!!!!!!!
			if (_j<(_arr2.length-1))
				_acc += "\""
			*/
		}
		if(_i<(_arr.length-1))
			_acc += (_bNoBackslashQuote ? "\"" : "\\\"");
	}
	_output[_output_i++] = _acc;
	return _output
}


////////////////////////////
//  P R O T O T Y P E S   //
////////////////////////////

Date.prototype.format = function (fmt,lngcd) 
{
	fmt = fmt.replace( new RegExp("%Y", "g"), zerofill(this.getFullYear(),4) );
	fmt = fmt.replace( new RegExp("%y", "g"), zerofill(this.getYear(),4).substring(2,4) );
	fmt = fmt.replace( new RegExp("%m", "g"), zerofill(this.getMonth()+1,2) );
	fmt = fmt.replace( new RegExp("%d", "g"), zerofill(this.getDate(),2) );
	fmt = fmt.replace( new RegExp("%H", "g"), zerofill(this.getHours(),2) );
	fmt = fmt.replace( new RegExp("%M", "g"), zerofill(this.getMinutes(),2) );
	fmt = fmt.replace( new RegExp("%S", "g"), zerofill(this.getSeconds(),2) );
	fmt = fmt.replace( new RegExp("%I", "g"), zerofill(this.getHours()%12,2) );
	fmt = fmt.replace( new RegExp("%p", "g"), this.getHours()<12?"AM":"PM" );
	if (fmt.indexOf("%")<0)
		return fmt;
 
	var days = new Array();
	var sdays = new Array();
	var months = new Array();
	
	switch( lngcd?lngcd.substring(0,2):"" )
	{
		case "nl":
			var days = ['zondag','maandag','dinsdag','woensdag','donderdag','vrijdag','zaterdag'];
			var sdays = ["Zo","Ma","Di","Wo","Do","Vr","Za"];
			var months =  ['januari','februari','maart','april','mei','juni','juli','augustus','september','oktober','november','december'];
			break;
		case "en":
		default:
			var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
			var sdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
			var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
			break;
	}
	
	fmt = fmt.replace( new RegExp("%a", "g"), days[this.getDay()].substring(0,3) );
	fmt = fmt.replace( new RegExp("%A", "g"), days[this.getDay()] );
	fmt = fmt.replace( new RegExp("%b", "g"), months[this.getMonth()].substring(0,3) );
	fmt = fmt.replace( new RegExp("%B", "g"), months[this.getMonth()] );
	fmt = fmt.replace( new RegExp("%%", "g"), "%" );
	return fmt;
}

String.prototype.toDateString = function (fmt)
{
	var thisdate = this.toDate();
	
	if (typeof(thisdate)=="object")
		return thisdate.format(fmt);
	else
		return this;
} 



String.prototype.cutTo = function (length,endchar,startpos)
{
	var cutTo_str = this.substring(startpos,startpos+length);

	if( endchar && cutTo_str.indexOf(endchar)>=0 )
		return this.substring(startpos,startpos+cutTo_str.indexOf(endchar));
	else
		return cutTo_str;
}

String.prototype.toDate = function (fmt,lngcd) 
{
	var century=20;
	var year=0;
	var month=0;
	var day=0;
	var hour=0;
	var min=0;
	var sec=0;
	var ampm=-1;

	if(!fmt)
	{
		switch (this.length)
		{
		case 0:
			return;
			
		case 6:	// format DDMMYY
			day   = Number(this.substring(0,2));
			month = Number(this.substring(2,4));
			year  = Number(this.substring(4,6));
			return new Date((year>90?(century-1):century)*100+year,month-1,day,hour,min,sec);
			
		case 8: // format DDxMMxYY or DDMMYYYY
			var sign = this.substring(3,1);					
			if (!(IsNumeric(sign) && IsNumeric(this.charAt(5))))
			{
				day   = Number(this.substring(0,2));
				month = Number(this.substring(3,5));
				year  = Number(this.substring(6,8));
				return new Date((year>90?(century-1):century)*100+year,month-1,day,hour,min,sec);
			}
			else
			{
				day   = Number(this.substring(0,2));
				month = Number(this.substring(2,4));
				year  = Number(this.substring(4,8));
				return new Date(year,month-1,day,hour,min,sec);
			}
			
		case 10: // format YYYYxMMxDD or DDxMMxYYYY
			if (!IsNumeric(this.charAt(7)))
			{
				year  = Number(this.substring(0,4));
				month = Number(this.substring(5,7));
				day   = Number(this.substring(8,10));
			}
			else
			{
				day   = Number(this.substring(0,2));
				month = Number(this.substring(3,5));
				year  = Number(this.substring(6,10));
			}
			return new Date(year,month-1,day,hour,min,sec);

		case 16: // format YYYYxMMxDD HHxMM or DDxMMxYYYY HHxMM
			if (!IsNumeric(this.charAt(7)))
			{
				year  = Number(this.substring(0,4));
				month = Number(this.substring(5,7));
				day   = Number(this.substring(8,10));
				hour  = Number(this.substring(11,13));
				min	  = Number(this.substring(14,16));
				sec   = 0;
			}
			else
			{
				day   = Number(this.substring(0,2));
				month = Number(this.substring(3,5));
				year  = Number(this.substring(6,10));
				hour  = Number(this.substring(11,13));
				min	  = Number(this.substring(14,16));
				sec   = 0;
			}
			return new Date(year,month-1,day,hour,min,sec);
			
		case 19: // format YYYYxMMxDD HHxMMxSS
			year   = Number(this.substring(0,4));
			month  = Number(this.substring(5,7));
			day    = Number(this.substring(8,10));
			hour   = Number(this.substring(11,13));
			min	   = Number(this.substring(14,16));
			sec	   = Number(this.substring(17,19));		
			return new Date(year,month-1,day,hour,min,sec);
			
		default: // null date
			fmt = "%m/%d/%Y %H:%M:%S %p";
		}	
	}

	
	var dpos = 0;
	for(var i_toDate=0;i_toDate<fmt.length;i_toDate++)
	{
		if(fmt.charAt(i_toDate)=='%')
		{
			i_toDate++
			var e = fmt.charAt(i_toDate+1);
			if (e=='%') e = "";
			
			switch(fmt.charAt(i_toDate))
			{
				case 'Y':
					year = this.cutTo(4,e,dpos);
					dpos += year.length;
					year = Number(year);
				break;
				case 'y':
					year = this.cutTo(2,e,dpos);	
					dpos += year.length;
					year = Number(year);
				break;
				case 'm':
					month = this.cutTo(2,e,dpos);	
					dpos += month.length;
					month = Number(month);
				break;
				case 'd':
					day = this.cutTo(2,e,dpos);	
					dpos += day.length;
					day = Number(day);
				break;
				case 'H':
					hour = this.cutTo(2,e,dpos);	
					dpos += hour.length;
					hour = Number(hour);
				break;
				case 'M':
					min = this.cutTo(2,e,dpos);	
					dpos += min.length;
					min = Number(min);
				break;
				case 'S':
					sec = this.cutTo(2,e,dpos);	
					dpos += sec.length;
					sec = Number(sec);
				break;
				case 'I':
					hour = this.cutTo(2,e,dpos);	
					dpos += hour.length;
					hour = Number(hour);
					ampm = 0;
				break;
				case 'p':
					ampm =  this.cutTo(2,e,dpos);	
					dpos += ampm.length;
					ampm = ampm=="PM"?12:0;
				break;
				case '%':
					dpos += 1;
			}
		}
		else
			dpos++;
	}

	if (ampm>=0)
		hour = (hour+ampm)%24
	
	return new Date(year,month-1,day,hour,min,sec);
}

String.prototype.encrypt =  function (pwd)
{
  var _today = new Date();
  _today = _today.format("%y%m%d%H");
  var _this = _today + this;

  if(pwd == null || pwd.length <= 0) {
    Response.Write("Please enter a password with which to encrypt the message.");
    return null;
  }
  var prand = "";
  for(var i=0; i<pwd.length; i++) {
    prand += pwd.charCodeAt(i).toString();
  }
  var sPos = Math.floor(prand.length / 5);
  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
  var incr = Math.ceil(pwd.length / 2);
  var modu = Math.pow(2, 31) - 1;
  if(mult < 2) {
    Response.Write("Algorithm cannot find a suitable hash. Please choose a different password. \nPossible considerations are to choose a more complex or longer password.");
    return null;
  }
  var salt = Math.round(Math.random() * 1000000000) % 100000000;
  prand += salt;
  while(prand.length > 10) {
    prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
  }
  prand = (mult * prand + incr) % modu;
  var enc_chr = "";
  var enc_str = "";
  for(var i=0; i<_this.length; i++) {
    enc_chr = parseInt(_this.charCodeAt(i) ^ Math.floor((prand / modu) * 255));
    if(enc_chr < 16) {
      enc_str += "0" + enc_chr.toString(16);
    } else enc_str += enc_chr.toString(16);
    prand = (mult * prand + incr) % modu;
  }
  salt = salt.toString(16);
  while(salt.length < 8)salt = "0" + salt;
  enc_str += salt;
  return enc_str;
}

String.prototype.decrypt =  function (pwd)
{
  if(this == null || this.length < 8) 
  {
    Response.Write("A salt value could not be extracted from the encrypted message because it's length is too short. The message cannot be decrypted.");
    return;
  }
  
  if(pwd == null || pwd.length <= 0)
  {
    Response.Write("Please enter a password with which to decrypt the message.");
    return;
  }
  
  var prand = "";
  for(var i=0; i<pwd.length; i++) {
    prand += pwd.charCodeAt(i).toString();
  }
  var sPos = Math.floor(prand.length / 5);
  var mult = parseInt(prand.charAt(sPos) + prand.charAt(sPos*2) + prand.charAt(sPos*3) + prand.charAt(sPos*4) + prand.charAt(sPos*5));
  var incr = Math.round(pwd.length / 2);
  var modu = Math.pow(2, 31) - 1;
  var salt = parseInt(this.substring(this.length - 8, this.length), 16);
  var str = this.substring(0, this.length - 8);
  prand += salt;
  while(prand.length > 10) {
    prand = (parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length))).toString();
  }
  prand = (mult * prand + incr) % modu;
  var enc_chr = "";
  var enc_str = "";
  for(var i=0; i<str.length; i+=2) {
    enc_chr = parseInt(parseInt(str.substring(i, i+2), 16) ^ Math.floor((prand / modu) * 255));
    enc_str += String.fromCharCode(enc_chr);
    prand = (mult * prand + incr) % modu;
  }

  

  var _today = new Date();
  var _encdatestr = enc_str.substring(0,8);
  var _century=20;
  var _year   = Number(_encdatestr.substring(0,2));
  var _month  = Number(_encdatestr.substring(2,4));
  var _day    = Number(_encdatestr.substring(4,6));
  var _hour   = Number(_encdatestr.substring(6,8));
  var _min    = 0;
  var _sec    = 0;
  var _encdate    = new Date((_year>90?(_century-1):_century)*100+_year,_month-1,_day,_hour,_min,_sec);
  
  // DO NOT 'DECLARE' FOLLOWING VARIABLE !!!!
  _encdelay   = Math.floor(  (new Date()-_encdate)/1000  )/60/60;   // EXPIRATION DELAY (in hours)

  //Response.Write("#"+_encdatestr+"/"+enc_str.substring(8,enc_str.length)+"<br>");

  return enc_str.substring(8,enc_str.length);
}


//////////////////////////////////
// B A S E   6 4   C O D I N G  //
//////////////////////////////////
// range: 0-16777215 (24 bits)  //
//////////////////////////////////
		
function GetHEX6(HEX6_n)
{
	var HEX6_s="";
	var Hex = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];		
	for (var k=0;k<6;k++)
	{
		HEX6_s=Hex[HEX6_n&0xF]+HEX6_s;
		HEX6_n=HEX6_n>>4;
	}	
	return HEX6_s;
}

String.prototype.digitmod =  function (dig_l)
{
	return zerofill( this, this.length+dig_l-1-((this.length-1)%dig_l) );	
}

String.prototype.ltrimzero = function ( ) { return this.replace(/^0*/,""); }

String.prototype.ltrim64code = function () { return this.replace(/^A*/,""); }

String.prototype.lfill64code = function ()
{
	// ADD LEADING A's BY GROUPS OF 4
	var lfill64code_str = "AAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	return ( lfill64code_str.substring(0,3 - ((this.length-1) % 4)) + this );
}

	String.prototype.ltrim = function () { return this.replace(/^ */,""); }
	String.prototype.rtrim = function () { return this.replace(/ *$/,""); }
	String.prototype.trim  = function () { return this.ltrim().rtrim(); }

%>
