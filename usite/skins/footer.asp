<%
if (typeof(skin_cat)=="undefined")
	var skin_cat = 0;

if (typeof(skin_mode)=="undefined")
	var skin_mode = 1;
	
if (typeof(_print_cmd)=="undefined")
	var _print_cmd = "view.mode.value='print';";
	
if (typeof(_back_cmd)=="undefined")
	var _print_cmd = "view.mode.value='';";

if (typeof(_print_action)=="undefined")
	var _print_action = "view.submit();";
	
if(typeof(_rightbanner_width)=="undefined")
	var _rightbanner_width = 220;
	
var bDebug = false;
	
%>
	</td>
	<td valign="top">
		<!-- C O M M E R C I A L   A R E A -->
		<!--img SRC="../images/menu_bar4.gif" WIDTH="<%=1+_rightbanner_width%>" HEIGHT="20" border="0"><br-->
		
		<!-- RIGHT MENU BAR WITH SHADOW-->
		<!--table cellspacing="0" cellpadding="0" border="0">		<tr height=<%=6%>><td WIDTH="<%=1+_rightbanner_width%>"><img SRC="../images/nbox1.gif" WIDTH="<%=1+_rightbanner_width%>" HEIGHT="6" border=0></td></tr>		<tr height=<%=40-6-1%>><td bgcolor=#F7F3EF></td></tr>		<tr height=<%=1%>><td bgcolor=#BDBABD></td></tr>		</table-->
		
		<!-- RIGHT MENU BAR WITHOUT SHADOW-->
		
		<%
		if(_urlpart.substring(0,2) == "02")
		{
		%>
		<table cellspacing="0" cellpadding="0" border="0">
		<tr height="<%=40%>"><td><img SRC="../images/skins/nobel_f2_lowerpart_221_40.gif" WIDTH="221" HEIGHT="40"></td></tr>
		</table>
		<%
		}
		else
		{
		%>
		<!--table cellspacing="0" cellpadding="0" border="0">
		<tr height="<%=40%>"><td><img SRC="../images/skins/nobel_f_lowerpart_221_40.gif" WIDTH="221" HEIGHT="40"></td></tr>
		</table-->
		
		<!--table cellspacing="0" cellpadding="0" border="0">
		<tr height="<%=40%>"><td><img SRC="../images/skins/nobel_birds_lowerpart_221_40.gif" WIDTH="221" HEIGHT="40"></td></tr>
		</table-->
		
		<table cellspacing="0" cellpadding="0" border="0">
		<tr height="<%=40%>"><td><img SRC="../images/skins/nobel_etincelles_221_40.gif" WIDTH="221" HEIGHT="40"></td></tr>
		</table>
		
		
			
		<%
		}
		%>
		
		<!--table cellspacing="0" cellpadding="0" border="0">		<tr height="<%=24%>"><td WIDTH="<%=1+_rightbanner_width%>" bgcolor="#000000"></td></tr>		<tr height="<%=40-1-24%>"><td bgcolor="#F7F3EF">test</td></tr>		<tr height="<%=1%>"><td bgcolor="#BDBABD"></td></tr>		</table-->
		

		<!-- R I G H T   B A N N E R   A R E A   B E G I N-->
		
		
		<%
			// LOAD PROMO ITEMS WHEN NEEDED
			if(typeof(_promo)=="undefined")
			{
				var rev_type = 13;
				var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_url","rev_rev","rev_rt_cat","rev_pub");
				var extraSQL = "order by rev_date_published desc LIMIT 0,6";
				var SQL		 = "select "+tablefld.join(",")+" from "+_db_prefix+"review where (rev_pub & 3) > 0 and rev_rt_typ = "+rev_type+" and rev_date_published < SYSDATE() "+extraSQL;
				if(bDebug) Response.Write(SQL);
				var overview		= _oDB.getrows( SQL );
				var _promo			= overview;
				var _promo_tablefld	= tablefld;
			}
			
			var enumfld = new Array();
		 	for (var i=0; i<_promo_tablefld.length ; i++)
				enumfld[_promo_tablefld[i]] = i;
		%>

		<style>
		H2.home
		{
		    FONT-WEIGHT: normal;
		    FONT-SIZE: x-small;
		    MARGIN-BOTTOM: 5px;
		    PADDING-BOTTOM: 2px;
		    COLOR: #212930;
		    BORDER-BOTTOM: #cccccc 1px solid;
		    FONT-FAMILY: Verdana
		}
		</style>


		<table cellpadding="0" cellspacing="0" width="<%=_rightbanner_width%>">
		<%
		for(var i=0;i<_promo.length;i+=tablefld.length)
		{		
			if((_promo[i+enumfld["rev_pub"]] & 1) == 1)
			{
				if(Number(_promo[i+enumfld["rev_rt_cat"]]) == 163)
				{
					%><tr valign="top"><td bgcolor="#BCB8B5" width="1" valign="top"><img SRC="../images/nbox4.gif" WIDTH="1" height=1 border="0"></td><td colspan=2><%=_promo[i+enumfld["rev_rev"]]%><br></td></tr><%
				}
				else
				{
					%>	<tr valign="top">
							<td bgcolor="#BCB8B5" width="1" valign="top"><img SRC="../images/nbox4.gif" WIDTH="1" HEIGHT="6" border="0"></td>
							<td width="5"></td>
							<td width="<%=_rightbanner_width-5%>">
								<h2 class="home">
									<%=_promo[i+enumfld["rev_title"]]%>&nbsp;
								</h2>
								<table cellpadding="0" cellspacing="0" class="body">
									<tr valign="top">
										<td width="60">						
											<%
													var imgpath = "../images/promo";
													var thisid = _promo[i+enumfld["rev_id"]];
													var relurl = "13_detail_Q_id_E_"+thisid.toString().encrypt("nicnac")+".asp#"+base64encode(thisid.toString());

													_oGUI.ICON.init();
													_oGUI.ICON.type = 3;
													_oGUI.ICON.attr = "align=left class=small";
													_oGUI.ICON.add(imgpath+"/img"+zerofill(thisid,10)+"_t50_1.jpg",relurl+(_promo[i+enumfld["rev_url"]]?" target=_blank":""),"",_promo[i+enumfld["rev_desc"]]);
											%>
											<%=_oGUI.ICON.get()%>
										</td>
										<td class="small" style="text-align=left">
											<a href="<%=relurl+(_promo[i+enumfld["rev_url"]]?" target=_blank":"")%>">
												<%=_promo[i+enumfld["rev_desc"]]%>
											</a>
											<br>
											<%=_promo[i+enumfld["rev_header"]]%>
										</td>
									</tr>
									<tr>
										<td colspan="2" class="small">
												<a href="<%=relurl+(_promo[i+enumfld["rev_url"]]?" target=_blank":"")%>">
													<%=_T["readmore"]%>...
												</a>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						<tr>
							<td bgcolor="#BCB8B5" width="1" valign="top"><img SRC="../images/nbox4.gif" WIDTH="1" HEIGHT="6" border="0"></td>
							<td width="5"></td>
							<td>
												&nbsp;
							</td>
						</tr>
					<%
					}
			}
		}
		%><tr>
				<td colspan="3" height="1" bgcolor="#BCB8B5">
				
				
				
				
				
				
				
				
			
				
				
				
				
				</td>
			</tr>
		</table>
		<!-- R I G H T   B A N N E R   A R E A   E N D -->		
		
		
		<!--img SRC="../images/ads/empty_rightbanner2.gif" WIDTH="<%=_rightbanner_width%>" HEIGHT="810"-->

		
	</td>
</tr>
<tr>
	<td colspan="3">
	
	
	
	
	
			<a name="login"></a>
			
			<form name="view" method="post" action="#login">

<%
			var adminbutton = "";
			if ( ("<"+Session("uid")+">") == Session("uidcrc") )
			{
				adminbutton = "<a href=../admin/menu.asp>admin</a> | "
			}
%>
			<table cellspacing="0" cellpadding="0" width="100%"><tr><td align="left">
			<table cellspacing="1" cellpadding="2" bgcolor="#EAEAEA" height="12"><tr><td bgcolor="#FFFFFF" style="font-family:Verdana;font-size:10px;color=#D0D0D0"><%=adminbutton%><a href="#top">top</a> | <%=new Date().format("%d %m %Y %H:%M")%></td></tr></table>
			
			</td>
			<td align="middle">
			<!--				<%					if(_pagename=="00_index")					{					%>				<a href=http://www.theartserver.be/theartserver/nlbe/00_index.asp>nlbe</a> | <a href=http://www.nobel.be>frbe</a> | <a href=http://www.theartserver.nl target=_top>nlnl</a> | <a href=http://www.theartserver.co.uk target=_top>enuk</a> | <a href=http://www.theartserver.fr target=_top>fr</a> | <a href=http://www.theartserver.de target=_top>de</a>  | <a href=http://www.theartserver.it target=_top>it</a>				<%					}				%>			-->
			</td>
			
			<td align="right">
			<!--			<table cellspacing="1" cellpadding="2" bgcolor="#EAEAEA" height="12"><tr><td bgcolor="#FFFFFF" style="font-family:Verdana;font-size:10px;color=#D0D0D0"><a href="JavaScript:<%=_print_action%>" onmouseover="<%=_print_cmd%>">print</a></td></tr></table>			-->
			</td></tr></table>	
			
			
			
	</td>
</tr>
</table>
		<input type="hidden" name="mode">
		</form>
</body>
</html>