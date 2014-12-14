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

var skin_data = new Array();
skin_data[0] = [ "news_1.png","news_2.png","news_3.png","bg_newswall.gif","#CEDFEF","#CEDFEF","news_6.png","ArtCornerLogo.gif","treebar_corner.gif"];
skin_data[1] = [ "pray_1.png","pray_2.png","pray_3.png","bg_praywall.gif","#FEFEF8","#CEDFEF","pray_6.png","ArtCornerLogo.gif","treebar_corner.gif"];
skin_data[2] = [ "marj_1.gif","marj_2.gif","marj_3.gif","bg_marjwall.gif","#A3CEE1","#A3CEE1","marj_6.gif","marj_5.gif","bg_treebar.gif"];


//  S K I N   M O D E   0   :  E M P T Y
//  S K I N   M O D E   1   :  F U L L S C R E E N
//  S K I N   M O D E   2   :  N E W S L E T T E R S

if (skin_mode == 0)
{
%>
	</body>
</html>
<%
}
else if ( skin_mode == 1 || skin_mode == 2)
{

	if (mode=="print")
	{
	%>
	<form name="view" method="post" action=#login>
		<input type="hidden" name="mode" value="<%=mode%>">
	</form>

	</td>
	</tr>
	<tr>
	<td bgcolor=white>
		<table cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td align="left">
			</td>
			<td align="right">
				<table cellspacing="1" cellpadding="2" bgcolor="#EAEAEA" height="12"><tr><td bgcolor="#FFFFFF" style="font-family:Verdana;font-size:10px;color=#D0D0D0"><a href="JavaScript:<%=_print_action%>" onmouseover="<%=_back_cmd%>">terug</a></td></tr></table>
			</td>
		</tr>
		</table>
	</td>
	</tr>
	</table>
	<%
	}
	else
	{
		%>
	</td>
	<td valign="top">
		<!-- C O M M E R C I A L   A R E A -->

	</td>
	<td width="1" valign="top" height=100%>
		<table cellspacing="0" cellpadding="0" border="0" height=100%>
		<tr height="<%=24%>"><td WIDTH="<%=48%>" bgcolor="#000000"></td></tr>
		<tr height="<%=40-1-24%>"><td bgcolor="#F7F3EF"></td></tr>
		<tr height="<%=1%>"><td bgcolor="#BDBABD"></td></tr>
		<tr><td bgcolor=#BDBABD></td></tr>
		</table>
	</td>
	<td bgcolor="<%=skin_data[skinnr][4]%>" width="48" background="<%=_basedir+"images/skins/"+skin_data[skinnr][6]%>" valign="top" height=100%>
		<table cellspacing="0" cellpadding="0" border="0" height=100%>
		<tr height="<%=24%>"><td WIDTH="<%=48%>" bgcolor="#000000"></td></tr>
		<tr height="<%=40-1-24%>"><td bgcolor="#F7F3EF"></td></tr>
		<tr height="<%=1%>"><td bgcolor="#F7F3EF"></td></tr>
		<tr><td bgcolor=#F7F3EF></td></tr>
		</table>
	</td>
	<td width=100% bgcolor=black>
	</td>
	
</tr>
</table>
		<a name="login"></a>
</body>
</html>
<%
	}
}
%>
