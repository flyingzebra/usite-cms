<%@ Language=JavaScript %>
<HTML>
<body bgcolor=#E2D4A5 background="../images/feldman_texture.gif" leftmargin=0 rightmargin=0 topmargin=0 bottommargin=0>
	<form method=post name=main>

	<%
		var bImageMagick = false;

		var framing =  Request.Form("framing").Item?Number(Request.Form("framing").Item):0;
		var act =  Request.Form("act").Item;
		
		var ImageSource1 = Server.MapPath("../"+Session("dir").substring(0,Session("dir").lastIndexOf("_"))+"/images/"+Request.QueryString("src").Item)
		
		
		var bImageExists = true;
		
		var ImageSource2 = Server.MapPath("../"+Session("dir").substring(0,Session("dir").lastIndexOf("_"))+"/images/"+Request.QueryString("img").Item)
	
		
		
		if(bImageMagick)
		{
			var jpeg1 = new MAGICK();
			jpeg1.init(ImageSource1,ImageSource2)
		}
		else
		{
			var jpeg1 = Server.CreateObject("Persits.Jpeg");
			jpeg1.open( ImageSource1 );

			var jpeg2 = Server.CreateObject("Persits.Jpeg");
			jpeg2.open( ImageSource2 );
		}



		
		
		var dimstr = Request.QueryString("dim").Item
		var dim = dimstr.split(/x|:/);
		
		//Response.Write("<br>"+jpeg1.width+"x"+jpeg1.height);
		//Response.Write("<br>"+dim[0]+"x"+dim[1]+":"+dim[3]);
		

		
		var bHoriz = false;
		var bVar   = dimstr.indexOf("VAR")>=0?true:false;
		
		if(bImageExists)
		{
			bHoriz = isHoriz(jpeg1);
			var aspect1 = jpeg1.height/jpeg1.width;
			var aspect2 = (dim[0] && dim[1])?(Number(dim[1])/Number(dim[0])):1;
			
			//Response.Write(jpeg1.width+"x"+jpeg1.height+"<br>")
			//Response.Write(dim[0]+"x"+dim[1])
			
			if(aspect1==aspect2)
				bVar = true;
			
			framing = framing?Number(framing):0;
			if(act=="o")
				framing= 0;
			if(act=="^" || act=="<")
				framing= Number(framing)-20;
			if(act=="v" || act==">")
				framing= Number(framing)+20;
			if(act=="/\\" || act=="|<")
				framing= -100;
			if(act=="\\/" || act==">|")
				framing= 100;
				
			jpeg1.Quality = dim[2]?dim[2]:85;
			resizetoRect(jpeg1,dimstr,framing);
			//jpeg1.Sharpen(1,105);
			if(act)
			{
				if(bImageMagick)
					jpeg1.exit();
				else
					jpeg1.Save(ImageSource2);
			}
		}
		
		function isHoriz(picobj,size)
		{
			return  (picobj.height/picobj.width) < 1;
		}
		
		function resizetoRect(picobj,size,framing)
		{
			var splitarr = size.split(":");
			var sizes = splitarr[0].split("x");
			var sizex = Number(sizes[0]);
			var sizey = Number(sizes[1]);
			
			if(!isNaN(splitarr[1]))
				picobj.Quality = Number(splitarr[1]);
			
			if(isNaN(sizey) || sizey==0)
			{
				resizetoWidth(picobj,sizex,"",framing);
				return;
			}
			
			if(isNaN(sizex) || sizex==0)
			{
				resizetoHeight(picobj,sizey,"",framing);
				return;
			}		
			
			if (picobj.height==sizey && picobj.width==sizex)
				return;
				
			maxheight = sizey;
			maxwidth = sizex;		
			
			if (  (picobj.height*sizex/picobj.width) < maxheight )
				resizetoHeight(picobj,sizey,maxwidth,framing);
			else
				resizetoWidth(picobj,sizex,maxheight,framing)
		}	
		
		function resizetoSquare(picobj,size,framing)
		{
			if (picobj.height==size && picobj.width==size)
				return;
				
			maxheight = size;
			maxwidth = size;
	
			if (  (picobj.height*size/picobj.width) < maxheight )
				resizetoHeight(picobj,size,maxwidth,framing);
			else
				resizetoWidth(picobj,size,maxheight,framing)
		}
			
		function resizetoHeight(picobj,height,maxwidth,framing)
		{
			picobj.width  *= height/picobj.height;
			picobj.height = height;
			
			if (maxwidth && picobj.width>maxwidth)
			{
				xoffset = Math.round((picobj.width-maxwidth)/2) + Math.round((picobj.width-maxwidth)*framing/200)-1;
				Response.Write("xoffset="+xoffset+", 0, maxwidth+xoffset="+(maxwidth+xoffset)+", height="+height+"<br>")
				picobj.Crop(xoffset, 0, maxwidth+xoffset, height );
			}
	
		}
		
		function resizetoWidth(picobj,width,maxheight,framing)
		{
			picobj.height *= width/picobj.width;
			picobj.width  = width;
		
			if (maxheight && picobj.height>maxheight)
			{
				yoffset = Math.round((picobj.height-maxheight)/2) + Math.round((picobj.height-maxheight)*framing/200)-1
				//Response.Write("0, yoffset="+yoffset+", width="+width+", maxheight+yoffset="+(maxheight+yoffset)+"<br>");
				picobj.Crop(0, yoffset, width, maxheight+yoffset);
			}
		}	
	
	
function MAGICK()
{
   this.bDebug   = false;
   this.width    = 0;
   this.height   = 0;
   this.obj      = Server.CreateObject("ImageMagickObject.MagickImage.1");
   this.imgsrc   = "";
   this.imgdst   = "";
   this.imgtmp   = "";
   this.init     = MAGICK_init;
   this.exit     = MAGICK_exit;
   this.Crop     = MAGICK_Crop;
   this.Resize   = MAGICK_Resize;
}

function MAGICK_init(_imgsrc,_imgdst)
{
   this.imgsrc = _imgsrc;
   this.imgdst = _imgdst;
   this.imgtmp = _imgdst.substring(0,_imgdst.lastIndexOf("\\"))+"\\tmp.png";
   
   this.bCropped = false;
   
   this.width  = this.obj.Identify ("-format", "%w", this.imgsrc);
   this.height = this.obj.Identify ("-format", "%h", this.imgsrc);
   if(this.bDebug) Response.Write("detected: "+this.width+"x"+this.height+"<br>")
}

function MAGICK_exit()
{
	if(this.bCropped==false) this.Resize();
}

function MAGICK_Crop(_x1,_y1,_x2,_y2)
{
   this.bCropped = true;
   var _w  = Math.round(this.width)
   var _h  = Math.round(this.height)
   _x1     = Math.round(_x1);
   _x2     = Math.round(_x2);
   _y1     = Math.round(_y1);
   _y2     = Math.round(_y2);
   
   var rs1 = _w+"x"+_h+"!";
   var cp1 = _w+"x"+_h+"+"+_x1+"-"+(_h-_y2);
   var cp2 = _w+"x"+_h+"-"+(_w-_x2)+"+"+_y1;
   
   var conversion = this.obj.Convert(this.imgsrc,"-resize",rs1,"-crop", cp1,"-crop",cp2,this.imgdst);
   if(this.bDebug) Response.Write("Convert('-resize,"+rs1+",-crop','"+cp1+",-crop,"+cp2+"')<br>")
}

function MAGICK_Resize()
{
   if(this.bDebug) Response.Write("Convert('-resize','"+Math.round(this.width)+"x"+Math.round(this.height)+"!')<br>")
   var conversion = this.obj.Convert("-resize", Math.round(this.width)+"x"+Math.round(this.height)+"!", this.imgsrc, this.imgdst);
}		
	
	%>
	
	<table height="100%" width="100%">
	<tr>
		<td align=center valign=middle>
			<table>
			<tr>
				<td>
					<img src=<%="../"+Session("dir").substring(0,Session("dir").lastIndexOf("_"))+"/images/"+Request.QueryString("img").Item+"?"+(Math.floor(Math.random()*10000))%> onclick=window.close()>
				</td>
			
				<%
					if( bImageExists==true && bHoriz==false && bVar==false)
					{
						Response.Write("<td><input type=submit name=act value=\"/\\\" style=width:20px><br><input type=submit name=act value=\"^\" style=width:20px><br><input type=submit name=act value=\"o\" style=width:20px><br><input type=submit name=act value=\"v\" style=width:20px><br><input type=submit name=act value=\"\\/\" style=width:20px></td>")
					}
				%>
			
				</tr>
				<%
					if( bImageExists==true && bHoriz==true && bVar==false)
					{
						Response.Write("<tr><td><input type=submit name=act value=\"|&lt;\">&nbsp;<input type=submit name=act value=\"&lt;\">&nbsp;<input type=submit name=act value=\"o\">&nbsp;<input type=submit name=act value=\"&gt;\">&nbsp;<input type=submit name=act value=\"&gt;|\"></td></tr>")
					}
				%>
			</table>
		</td>
	</tr>
	</table>
	
	
	<input type=hidden name=framing value="<%=framing%>">
	
	</form>
</body>
</HTML>
