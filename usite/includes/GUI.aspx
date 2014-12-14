	
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
	this.param      = new Array();
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
	
	//function mysort(_a, _b)
	//{
	//    return  _a[_sortlevel] - _b[_sortlevel];
	//}
	
	for(var _sortlevel=this.maxtreedepth;_sortlevel>0;_sortlevel--)
		this.NodeData = radixSort_multi(this.NodeData,_sortlevel);
	
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

function GUI_SESSIONget(_connect,_querystring)
{	
	var _v = _querystring?decrypt(_querystring,"nicnac"):"";	
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

	function GetRGBA_HEXCol(Col)
	{
		var strCol='';
		var Hex = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];		
		for (var i=0;i<8;i++)
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

/*
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
*/

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







///////////////////////////////////////////////
//  PORTED Lagacy ASP PROTOTYPE FUNCTIONS    //
///////////////////////////////////////////////

function format(thisdate,fmt,lngcd) 
{
	fmt = fmt.replace( new RegExp("%Y", "g"), zerofill(thisdate.getFullYear(),4) );
	fmt = fmt.replace( new RegExp("%y", "g"), zerofill(thisdate.getYear(),4).substring(2,4) );
	fmt = fmt.replace( new RegExp("%m", "g"), zerofill(thisdate.getMonth()+1,2) );
	fmt = fmt.replace( new RegExp("%d", "g"), zerofill(thisdate.getDate(),2) );
	fmt = fmt.replace( new RegExp("%H", "g"), zerofill(thisdate.getHours(),2) );
	fmt = fmt.replace( new RegExp("%M", "g"), zerofill(thisdate.getMinutes(),2) );
	fmt = fmt.replace( new RegExp("%S", "g"), zerofill(thisdate.getSeconds(),2) );
	fmt = fmt.replace( new RegExp("%I", "g"), zerofill(thisdate.getHours()%12,2) );
	fmt = fmt.replace( new RegExp("%p", "g"), thisdate.getHours()<12?"AM":"PM" );
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
	
	fmt = fmt.replace( new RegExp("%a", "g"), days[thisdate.getDay()].substring(0,3) );
	fmt = fmt.replace( new RegExp("%A", "g"), days[thisdate.getDay()] );
	fmt = fmt.replace( new RegExp("%b", "g"), months[thisdate.getMonth()].substring(0,3) );
	fmt = fmt.replace( new RegExp("%B", "g"), months[thisdate.getMonth()] );
	fmt = fmt.replace( new RegExp("%%", "g"), "%" );
	return fmt;
}



function encrypt(text,pwd)
{
  var _today = new Date();
  _today = format(_today,"%y%m%d%H");
  var _text = _today + text;

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
  for(var i=0; i<_text.length; i++) {
    enc_chr = parseInt(_text.charCodeAt(i) ^ Math.floor((prand / modu) * 255));
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

function decrypt(text,pwd)
{
  if(text == null || text.length < 8) 
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
  var salt = parseInt(text.substring(text.length - 8, text.length), 16);
  var str = text.substring(0, text.length - 8);
  prand += salt;
  
  while(prand.length > 10) {
    prand = String(parseInt(prand.substring(0, 10)) + parseInt(prand.substring(10, prand.length)));
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
  

  var _encdelay   = Math.floor(  (new Date()-_encdate)/1000  )/60/60;   // EXPIRATION DELAY (in hours)

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

function digitmod(text,dig_l)
{
	return zerofill( text, text.length+dig_l-1-((text.length-1)%dig_l) );	
}

function ltrimzero(text) { return text.replace(/^0*/,""); }

function ltrim64code(text) { return text.replace(/^A*/,""); }

function lfill64code(text)
{
	// ADD LEADING A's BY GROUPS OF 4
	var lfill64code_str = "AAAAAAAAAAAAAAAAAAAAAAAAAAAA";
	return ( lfill64code_str.substring(0,3 - ((text.length-1) % 4)) + text );
}

function ltrim(text) { return text?text.replace(/^ */,""):""; }
function rtrim(text) { return text?text.replace(/ *$/,""):""; }
function trim(text) { return rtrim(ltrim(text)); }

function ColorString2Obj(_str : String)
{
	if(_str)
	{
		var colorobj : Color;
		if(_str.charAt(0)=="#" && _str.length==7)
		{
			var num = -(~Number("0xFF"+_str.substring(1,_str.length)))-1;
			colorobj = Color.FromArgb( num );
			return colorobj;
		}
		else if(_str.charAt(0)=="#" && _str.length==9)
		{
			var num = -(~Number("0x"+_str.substring(1,_str.length)))-1;
			colorobj = Color.FromArgb( num );
			return colorobj;
		}
		else
		{
			colorobj = Color.FromName(_str);
			return colorobj;
		}
	}
	else
		return Color.Black;
}

function drawText(nameOfItem : String, filenameOfItem : String , param : Array)
{
/*

        <textcolor>grey</textcolor>
        <hovercolor>red</hovercolor>
		<size>10</size>
		<maxheight>11.4</maxheight>
		<maxwidth>500</maxwidth>
		<bold>true</bold>
		<hover>true</hover>
*/

	var menuText = nameOfItem.toUpperCase();

	var size : float = param["size"] ? Number(param["size"]) : 7.5;
 	var height : int = param["maxheight"] ? Number(param["maxheight"]) : (Math.round(size) + 4);
	var width :  int = param["maxwidth"] ? Number(param["maxwidth"]) : 500;
 
	var bmp1 : Bitmap = new Bitmap(width, height);

	var f:Graphics = Graphics.FromImage(bmp1);
	f.TextRenderingHint = TextRenderingHint.SingleBitPerPixelGridFit;
	f.InterpolationMode = InterpolationMode.High;
	f.CompositingQuality = CompositingQuality.HighQuality;

  
	var dummyFont:Font;
	dummyFont = new Font("Arial", size , FontStyle.Bold);			// always measure bold text size

	var dummyText: SizeF;
	dummyText = f.MeasureString(menuText,dummyFont);

	var bmp : Bitmap = new Bitmap(Math.round(dummyText.Width), height);

	var g:Graphics = Graphics.FromImage(bmp);
	
	g.TextRenderingHint = TextRenderingHint.AntiAlias;
	g.FillRectangle(new SolidBrush(Color.White), 0, 0, width, height);
	
	

	
	var bBold : Boolean = false;
	if(param["bold"] && param["bold"].toLowerCase()=="true")
		bBold = true;

	var bHover : Boolean = false;
	if(param["hover"] && param["hover"].toLowerCase()=="true")
		bHover = true;		

	var brushColor:SolidBrush= new SolidBrush( ColorString2Obj( bHover==true?param["hovercolor"]:param["textcolor"] ) );
	var drawFont:Font;
	
	if(bBold==true || bHover==true)
			drawFont = new Font("Arial", size , FontStyle.Bold);
	else
			drawFont = new Font("Arial", size , FontStyle.Regular);

	g.DrawString(menuText, drawFont, brushColor , 0 ,1);
	//bmp.Save(Response.OutputStream, ImageFormat.Gif);
	
	var Path : String = Server.MapPath(filenameOfItem);

	if(bDebug)
		Response.Write(Path+"<br>");
	
	try
	{
		bmp.Save(Path, ImageFormat.Gif);
	}
	catch(e)
	{
		//Console.WriteLine(e.ToString());
		Response.Write("Error while saving to "+Path+"<br>")
	}
	bmp.Dispose();

}

%>
