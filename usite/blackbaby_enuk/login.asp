<%@ Language=JavaScript%>
<!--#INCLUDE file = "ref.asp" -->

<p class="footer" style="text-align:left;padding-left:0px">
		<table cellspacing="0" cellpadding="0" width="241" class="small" border="1">
			<tr><td bgcolor="#FFFBF0" WIDTH="181" style="padding-left:5px;padding-right:0px;"><form name="login" method="post" action="../admin/validate.asp"><table height="100" width="100" cellspacing="2" cellpadding="3"><tr><td width="100" style="font-family:verdana;font-size:13px">log</td><td><input size="6" type="text" name="log" maxlength="12"></td></tr><tr><td width="100" style="font-family:verdana;font-size:13px">psw</td><td><input size="6" type="password" name="pwd" maxlength="12"></td></tr><tr><td></td><td><input type="hidden" name="dir" value="<%=_dir%>"><input type="submit" value="login"></td></tr></table></form></td></tr>
		</table>
</p>
<script><%Response.End()%>