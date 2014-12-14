<%@ Language=JavaScript%>
<!--#INCLUDE file = "ref.asp" -->
<!--#INCLUDE file = "../includes/FORM.asp" -->
 
<!--  M A I N    T E X T    B E G I N  -->

<%
	var bDebug = false;

	var pid = Request.QueryString("p").Item;
	var cid = Request.QueryString("c").Item;
	var drevid = Request.QueryString("d").Item;
	var drevid = drevid?drevid.toString().decrypt("nicnac"):-1;
	var dsid = Request.QueryString("dsid").Item;
	var dsid = dsid?dsid.toString().decrypt("nicnac"):-1;	
	var bSubmitted = Request.TotalBytes==0?false:true;

	function filltempl(tmpltext,tmpldat,tmplfld)
	{

	
		for(var i=0;i<tmpldat.length;i++)
		{
			if(bDebug)
				Response.Write(Server.HTMLEncode("{_"+tmplfld[i].toUpperCase()+"_}"+" "+(tmpldat[i]?tmpldat[i]:("{_"+tmplfld[i].toUpperCase()+"_}")))+"<br><br>")
			tmpltext = tmpltext.replace("{_"+tmplfld[i].toUpperCase()+"_}",tmpldat[i]?tmpldat[i]:("{_"+tmplfld[i].toUpperCase()+"_}"))
		}
		return tmpltext
	}

	String.prototype.isDigit = function ()
	{
		for (var z=0;z<this.length;z++)
			if (this.charCodeAt(z) <= 47 || this.charCodeAt(z) >=  58)
				return false;
		return true;
	}
	
	String.prototype.isAlpha = function ()
	{
		for (var z=0;z<this.length;z++)
			if ((this.charCodeAt(z) <= 64) || (this.charCodeAt(z) >=  91) && (this.charCodeAt(z) <= 96) || (this.charCodeAt(z) >=  123) )
				return false;
		return true;
	}
	
	String.prototype.isAlnum = function ()
	{
		for (var z=0;z<this.length;z++)
			if ( ((this.charCodeAt(z) <= 47) || (this.charCodeAt(z) >=  58)) &&  (   (this.charCodeAt(z) <= 64) || (this.charCodeAt(z) >=  91) && (this.charCodeAt(z) <= 96) || (this.charCodeAt(z) >=  123)  ) )
				return false;
		return true;
	}
	
	String.prototype.isForbidden = function (forbiddenchars)
	{
		for (var z=0;z<forbiddenchars.length;z++)
			if (this.indexOf(forbiddenchars.substring(z,z+1))>=0)
				return true;
		return false;
	}
	
	String.prototype.indexOneOf = function (_oneof)
	{
		//Response.Write("#"+Server.HTMLEncode(_oneof.join(","))+"#")
	
		var _minpos = this.indexOf(Server.HTMLEncode(_oneof[0]));
		if(_minpos<0)
			_minpos = this.length;
		
		//Response.Write("*"+_minpos+_oneof[0]+"*")
		for(var _i=1;_i<_oneof.length;_i++)
		{
			var _pos = this.indexOf(_oneof[_i])
			if(_pos>=0 && _pos<_minpos)
				_minpos = _pos;
		}
		return _minpos;
	}

	String.prototype.insertpos = function (ins,pos)
	{
		return this.substring(0,pos)+ins+this.substring(pos,this.length);
	}	
	
	function stripHtml(strHTML) 
	{
		strOutput = strHTML
		aScript=strOutput.split(/\/script>/i);
		for(i=0;i<aScript.length;i++)
			aScript[i]=aScript[i].replace(/\<script.+/i,"");
		strOutput=aScript.join('');
		strOutput = strOutput.replace(/\<[^\>]+\>/g, "")
		return strOutput;
	}
	
	function HtmlDecode(s) 
	{ 
	      var out = ""; 
	      if (s==null) return; 
	  
	      var l = s.length; 
	      for (var i=0; i<l; i++) 
	      { 
	            var ch = s.charAt(i); 
	            
	            if (ch == '&') 
	            { 
	                  var semicolonIndex = s.indexOf(';', i+1); 
	                  
	            if (semicolonIndex > 0) 
	            { 
	                        var entity = s.substring(i + 1, semicolonIndex); 
	                        if (entity.length > 1 && entity.charAt(0) == '#') 
	                        { 
	                              if (entity.charAt(1) == 'x' || entity.charAt(1) == 'X') 
	                                    ch = String.fromCharCode(eval('0'+entity.substring(1))); 
	                              else 
	                                    ch = String.fromCharCode(eval(entity.substring(1))); 
	                        } 
	                    else 
	                      { 
	                              switch (entity) 
	                              { 
	                                    case 'quot': ch = String.fromCharCode(0x0022); break; 
	                                    case 'amp': ch = String.fromCharCode(0x0026); break; 
	                                    case 'lt': ch = String.fromCharCode(0x003c); break; 
	                                    case 'gt': ch = String.fromCharCode(0x003e); break; 
	                                    case 'nbsp': ch = String.fromCharCode(0x00a0); break; 
	                                    case 'iexcl': ch = String.fromCharCode(0x00a1); break; 
	                                    case 'cent': ch = String.fromCharCode(0x00a2); break; 
	                                    case 'pound': ch = String.fromCharCode(0x00a3); break; 
	                                    case 'curren': ch = String.fromCharCode(0x00a4); break; 
	                                    case 'yen': ch = String.fromCharCode(0x00a5); break; 
	                                    case 'brvbar': ch = String.fromCharCode(0x00a6); break; 
	                                    case 'sect': ch = String.fromCharCode(0x00a7); break; 
	                                    case 'uml': ch = String.fromCharCode(0x00a8); break; 
	                                    case 'copy': ch = String.fromCharCode(0x00a9); break; 
	                                    case 'ordf': ch = String.fromCharCode(0x00aa); break; 
	                                    case 'laquo': ch = String.fromCharCode(0x00ab); break; 
	                                    case 'not': ch = String.fromCharCode(0x00ac); break; 
	                                    case 'shy': ch = String.fromCharCode(0x00ad); break; 
	                                    case 'reg': ch = String.fromCharCode(0x00ae); break; 
	                                    case 'macr': ch = String.fromCharCode(0x00af); break; 
	                                    case 'deg': ch = String.fromCharCode(0x00b0); break; 
	                                    case 'plusmn': ch = String.fromCharCode(0x00b1); break; 
	                                    case 'sup2': ch = String.fromCharCode(0x00b2); break; 
	                                    case 'sup3': ch = String.fromCharCode(0x00b3); break; 
	                                    case 'acute': ch = String.fromCharCode(0x00b4); break; 
	                                    case 'micro': ch = String.fromCharCode(0x00b5); break; 
	                                    case 'para': ch = String.fromCharCode(0x00b6); break; 
	                                    case 'middot': ch = String.fromCharCode(0x00b7); break; 
	                                    case 'cedil': ch = String.fromCharCode(0x00b8); break; 
	                                    case 'sup1': ch = String.fromCharCode(0x00b9); break; 
	                                    case 'ordm': ch = String.fromCharCode(0x00ba); break; 
	                                    case 'raquo': ch = String.fromCharCode(0x00bb); break; 
	                                    case 'frac14': ch = String.fromCharCode(0x00bc); break; 
	                                    case 'frac12': ch = String.fromCharCode(0x00bd); break; 
	                                    case 'frac34': ch = String.fromCharCode(0x00be); break; 
	                                    case 'iquest': ch = String.fromCharCode(0x00bf); break; 
	                                    case 'Agrave': ch = String.fromCharCode(0x00c0); break; 
	                                    case 'Aacute': ch = String.fromCharCode(0x00c1); break; 
	                                    case 'Acirc': ch = String.fromCharCode(0x00c2); break; 
	                                    case 'Atilde': ch = String.fromCharCode(0x00c3); break; 
	                                    case 'Auml': ch = String.fromCharCode(0x00c4); break; 
	                                    case 'Aring': ch = String.fromCharCode(0x00c5); break; 
	                                    case 'AElig': ch = String.fromCharCode(0x00c6); break; 
	                                    case 'Ccedil': ch = String.fromCharCode(0x00c7); break; 
	                                    case 'Egrave': ch = String.fromCharCode(0x00c8); break; 
	                                    case 'Eacute': ch = String.fromCharCode(0x00c9); break; 
	                                    case 'Ecirc': ch = String.fromCharCode(0x00ca); break; 
	                                    case 'Euml': ch = String.fromCharCode(0x00cb); break; 
	                                    case 'Igrave': ch = String.fromCharCode(0x00cc); break; 
	                                    case 'Iacute': ch = String.fromCharCode(0x00cd); break; 
	                                    case 'Icirc': ch = String.fromCharCode(0x00ce ); break; 
	                                    case 'Iuml': ch = String.fromCharCode(0x00cf); break; 
	                                    case 'ETH': ch = String.fromCharCode(0x00d0); break; 
	                                    case 'Ntilde': ch = String.fromCharCode(0x00d1); break; 
	                                    case 'Ograve': ch = String.fromCharCode(0x00d2); break; 
	                                    case 'Oacute': ch = String.fromCharCode(0x00d3); break; 
	                                    case 'Ocirc': ch = String.fromCharCode(0x00d4); break; 
	                                    case 'Otilde': ch = String.fromCharCode(0x00d5); break; 
	                                    case 'Ouml': ch = String.fromCharCode(0x00d6); break; 
	                                    case 'times': ch = String.fromCharCode(0x00d7); break; 
	                                    case 'Oslash': ch = String.fromCharCode(0x00d8); break; 
	                                    case 'Ugrave': ch = String.fromCharCode(0x00d9); break; 
	                                    case 'Uacute': ch = String.fromCharCode(0x00da); break; 
	                                    case 'Ucirc': ch = String.fromCharCode(0x00db); break; 
	                                    case 'Uuml': ch = String.fromCharCode(0x00dc); break; 
	                                    case 'Yacute': ch = String.fromCharCode(0x00dd); break; 
	                                    case 'THORN': ch = String.fromCharCode(0x00de); break; 
	                                    case 'szlig': ch = String.fromCharCode(0x00df); break; 
	                                    case 'agrave': ch = String.fromCharCode(0x00e0); break; 
	                                    case 'aacute': ch = String.fromCharCode(0x00e1); break; 
	                                    case 'acirc': ch = String.fromCharCode(0x00e2); break; 
	                                    case 'atilde': ch = String.fromCharCode(0x00e3); break; 
	                                    case 'auml': ch = String.fromCharCode(0x00e4); break; 
	                                    case 'aring': ch = String.fromCharCode(0x00e5); break; 
	                                    case 'aelig': ch = String.fromCharCode(0x00e6); break; 
	                                    case 'ccedil': ch = String.fromCharCode(0x00e7); break; 
	                                    case 'egrave': ch = String.fromCharCode(0x00e8); break; 
	                                    case 'eacute': ch = String.fromCharCode(0x00e9); break; 
	                                    case 'ecirc': ch = String.fromCharCode(0x00ea); break; 
	                                    case 'euml': ch = String.fromCharCode(0x00eb); break; 
	                                    case 'igrave': ch = String.fromCharCode(0x00ec); break; 
	                                    case 'iacute': ch = String.fromCharCode(0x00ed); break; 
	                                    case 'icirc': ch = String.fromCharCode(0x00ee); break; 
	                                    case 'iuml': ch = String.fromCharCode(0x00ef); break; 
	                                    case 'eth': ch = String.fromCharCode(0x00f0); break; 
	                                    case 'ntilde': ch = String.fromCharCode(0x00f1); break; 
	                                    case 'ograve': ch = String.fromCharCode(0x00f2); break; 
	                                    case 'oacute': ch = String.fromCharCode(0x00f3); break; 
	                                    case 'ocirc': ch = String.fromCharCode(0x00f4); break; 
	                                    case 'otilde': ch = String.fromCharCode(0x00f5); break; 
	                                    case 'ouml': ch = String.fromCharCode(0x00f6); break; 
	                                    case 'divide': ch = String.fromCharCode(0x00f7); break; 
	                                    case 'oslash': ch = String.fromCharCode(0x00f8); break; 
	                                    case 'ugrave': ch = String.fromCharCode(0x00f9); break; 
	                                    case 'uacute': ch = String.fromCharCode(0x00fa); break; 
	                                    case 'ucirc': ch = String.fromCharCode(0x00fb); break; 
	                                    case 'uuml': ch = String.fromCharCode(0x00fc); break; 
	                                    case 'yacute': ch = String.fromCharCode(0x00fd); break; 
	                                    case 'thorn': ch = String.fromCharCode(0x00fe); break; 
	                                    case 'yuml': ch = String.fromCharCode(0x00ff); break; 
	                                    case 'OElig': ch = String.fromCharCode(0x0152); break; 
	                                    case 'oelig': ch = String.fromCharCode(0x0153); break; 
	                                    case 'Scaron': ch = String.fromCharCode(0x0160); break; 
	                                    case 'scaron': ch = String.fromCharCode(0x0161); break; 
	                                    case 'Yuml': ch = String.fromCharCode(0x0178); break; 
	                                    case 'fnof': ch = String.fromCharCode(0x0192); break; 
	                                    case 'circ': ch = String.fromCharCode(0x02c6); break; 
	                                    case 'tilde': ch = String.fromCharCode(0x02dc); break; 
	                                    case 'Alpha': ch = String.fromCharCode(0x0391); break; 
	                                    case 'Beta': ch = String.fromCharCode(0x0392); break; 
	                                    case 'Gamma': ch = String.fromCharCode(0x0393); break; 
	                                    case 'Delta': ch = String.fromCharCode(0x0394); break; 
	                                    case 'Epsilon': ch = String.fromCharCode(0x0395); break; 
	                                    case 'Zeta': ch = String.fromCharCode(0x0396); break; 
	                                    case 'Eta': ch = String.fromCharCode(0x0397); break; 
	                                    case 'Theta': ch = String.fromCharCode(0x0398); break; 
	                                    case 'Iota': ch = String.fromCharCode(0x0399); break; 
	                                    case 'Kappa': ch = String.fromCharCode(0x039a); break; 
	                                    case 'Lambda': ch = String.fromCharCode(0x039b); break; 
	                                    case 'Mu': ch = String.fromCharCode(0x039c); break; 
	                                    case 'Nu': ch = String.fromCharCode(0x039d); break; 
	                                    case 'Xi': ch = String.fromCharCode(0x039e); break; 
	                                    case 'Omicron': ch = String.fromCharCode(0x039f); break; 
	                                    case 'Pi': ch = String.fromCharCode(0x03a0); break; 
	                                    case ' Rho ': ch = String.fromCharCode(0x03a1); break; 
	                                    case 'Sigma': ch = String.fromCharCode(0x03a3); break; 
	                                    case 'Tau': ch = String.fromCharCode(0x03a4); break; 
	                                    case 'Upsilon': ch = String.fromCharCode(0x03a5); break; 
	                                    case 'Phi': ch = String.fromCharCode(0x03a6); break; 
	                                    case 'Chi': ch = String.fromCharCode(0x03a7); break; 
	                                    case 'Psi': ch = String.fromCharCode(0x03a8); break; 
	                                    case 'Omega': ch = String.fromCharCode(0x03a9); break; 
	                                    case 'alpha': ch = String.fromCharCode(0x03b1); break; 
	                                    case 'beta': ch = String.fromCharCode(0x03b2); break; 
	                                    case 'gamma': ch = String.fromCharCode(0x03b3); break; 
	                                    case 'delta': ch = String.fromCharCode(0x03b4); break; 
	                                    case 'epsilon': ch = String.fromCharCode(0x03b5); break; 
	                                    case 'zeta': ch = String.fromCharCode(0x03b6); break; 
	                                    case 'eta': ch = String.fromCharCode(0x03b7); break; 
	                                    case 'theta': ch = String.fromCharCode(0x03b8); break; 
	                                    case 'iota': ch = String.fromCharCode(0x03b9); break; 
	                                    case 'kappa': ch = String.fromCharCode(0x03ba); break; 
	                                    case 'lambda': ch = String.fromCharCode(0x03bb); break; 
	                                    case 'mu': ch = String.fromCharCode(0x03bc); break; 
	                                    case 'nu': ch = String.fromCharCode(0x03bd); break; 
	                                    case 'xi': ch = String.fromCharCode(0x03be); break; 
	                                    case 'omicron': ch = String.fromCharCode(0x03bf); break; 
	                                    case 'pi': ch = String.fromCharCode(0x03c0); break; 
	                                    case 'rho': ch = String.fromCharCode(0x03c1); break; 
	                                    case 'sigmaf': ch = String.fromCharCode(0x03c2); break; 
	                                    case 'sigma': ch = String.fromCharCode(0x03c3); break; 
	                                    case 'tau': ch = String.fromCharCode(0x03c4); break; 
	                                    case 'upsilon': ch = String.fromCharCode(0x03c5); break; 
	                                    case 'phi': ch = String.fromCharCode(0x03c6); break; 
	                                    case 'chi': ch = String.fromCharCode(0x03c7); break; 
	                                    case 'psi': ch = String.fromCharCode(0x03c8); break; 
	                                    case 'omega': ch = String.fromCharCode(0x03c9); break; 
	                                    case 'thetasym': ch = String.fromCharCode(0x03d1); break; 
	                                    case 'upsih': ch = String.fromCharCode(0x03d2); break; 
	                                    case 'piv': ch = String.fromCharCode(0x03d6); break; 
	                                    case 'ensp': ch = String.fromCharCode(0x2002); break; 
	                                    case 'emsp': ch = String.fromCharCode(0x2003); break; 
	                                    case 'thinsp': ch = String.fromCharCode(0x2009); break; 
	                                    case 'zwnj': ch = String.fromCharCode(0x200c); break; 
	                                    case 'zwj': ch = String.fromCharCode(0x200d); break; 
	                                    case 'lrm': ch = String.fromCharCode(0x200e); break; 
	                                    case 'rlm': ch = String.fromCharCode(0x200f); break; 
	                                    case 'ndash': ch = String.fromCharCode(0x2013); break; 
	                                    case 'mdash': ch = String.fromCharCode(0x2014); break; 
	                                    case 'lsquo': ch = String.fromCharCode(0x2018); break; 
	                                    case 'rsquo': ch = String.fromCharCode(0x2019); break; 
	                                    case 'sbquo': ch = String.fromCharCode(0x201a); break; 
	                                    case 'ldquo': ch = String.fromCharCode(0x201c); break; 
	                                    case 'rdquo': ch = String.fromCharCode(0x201d); break; 
	                                    case 'bdquo': ch = String.fromCharCode(0x201e); break; 
	                                    case 'dagger': ch = String.fromCharCode(0x2020); break; 
	                                    case 'Dagger': ch = String.fromCharCode(0x2021); break; 
	                                    case 'bull': ch = String.fromCharCode(0x2022); break; 
	                                    case 'hellip': ch = String.fromCharCode(0x2026); break; 
	                                    case 'permil': ch = String.fromCharCode(0x2030); break; 
	                                    case 'prime': ch = String.fromCharCode(0x2032); break; 
	                                    case 'Prime': ch = String.fromCharCode(0x2033); break; 
	                                    case 'lsaquo': ch = String.fromCharCode(0x2039); break; 
	                                    case 'rsaquo': ch = String.fromCharCode(0x203a); break; 
	                                    case 'oline': ch = String.fromCharCode(0x203e); break; 
	                                    case 'frasl': ch = String.fromCharCode(0x2044); break; 
	                                    case 'euro': ch = String.fromCharCode(0x20ac); break; 
	                                    case 'image': ch = String.fromCharCode(0x2111); break; 
	                                    case 'weierp': ch = String.fromCharCode(0x2118); break; 
	                                    case 'real': ch = String.fromCharCode(0x211c); break; 
	                                    case 'trade': ch = String.fromCharCode(0x2122); break; 
	                                    case 'alefsym': ch = String.fromCharCode(0x2135); break; 
	                                    case 'larr': ch = String.fromCharCode(0x2190); break; 
	                                    case 'uarr': ch = String.fromCharCode(0x2191); break; 
	                                    case 'rarr': ch = String.fromCharCode(0x2192); break; 
	                                    case 'darr': ch = String.fromCharCode(0x2193); break; 
	                                    case 'harr': ch = String.fromCharCode(0x2194); break; 
	                                    case 'crarr': ch = String.fromCharCode(0x21b5); break; 
	                                    case 'lArr': ch = String.fromCharCode(0x21d0); break; 
	                                    case 'uArr': ch = String.fromCharCode(0x21d1); break; 
	                                    case 'rArr': ch = String.fromCharCode(0x21d2); break; 
	                                    case 'dArr': ch = String.fromCharCode(0x21d3); break; 
	                                    case 'hArr': ch = String.fromCharCode(0x21d4); break; 
	                                    case 'forall': ch = String.fromCharCode(0x2200); break; 
	                                    case 'part': ch = String.fromCharCode(0x2202); break; 
	                                    case 'exist': ch = String.fromCharCode(0x2203); break; 
	                                    case 'empty': ch = String.fromCharCode(0x2205); break; 
	                                    case 'nabla': ch = String.fromCharCode(0x2207); break; 
	                                    case 'isin': ch = String.fromCharCode(0x2208); break; 
	                                    case 'notin': ch = String.fromCharCode(0x2209); break; 
	                                    case 'ni': ch = String.fromCharCode(0x220b); break; 
	                                    case 'prod': ch = String.fromCharCode(0x220f); break; 
	                                    case 'sum': ch = String.fromCharCode(0x2211); break; 
	                                    case 'minus': ch = String.fromCharCode(0x2212); break; 
	                                    case 'lowast': ch = String.fromCharCode(0x2217); break; 
	                                    case 'radic': ch = String.fromCharCode(0x221a); break; 
	                                    case 'prop': ch = String.fromCharCode(0x221d); break; 
	                                    case 'infin': ch = String.fromCharCode(0x221e); break; 
	                                    case 'ang': ch = String.fromCharCode(0x2220); break; 
	                                    case 'and': ch = String.fromCharCode(0x2227); break; 
	                                    case 'or': ch = String.fromCharCode(0x2228); break; 
	                                    case 'cap': ch = String.fromCharCode(0x2229); break; 
	                                    case 'cup': ch = String.fromCharCode(0x222a); break; 
	                                    case 'int': ch = String.fromCharCode(0x222b); break; 
	                                    case 'there4': ch = String.fromCharCode(0x2234); break; 
	                                    case 'sim': ch = String.fromCharCode(0x223c); break; 
	                                    case 'cong': ch = String.fromCharCode(0x2245); break; 
	                                    case 'asymp': ch = String.fromCharCode(0x2248); break; 
	                                    case 'ne': ch = String.fromCharCode(0x2260); break; 
	                                    case 'equiv': ch = String.fromCharCode(0x2261); break; 
	                                    case 'le': ch = String.fromCharCode(0x2264); break; 
	                                    case 'ge': ch = String.fromCharCode(0x2265); break; 
	                                    case 'sub': ch = String.fromCharCode(0x2282); break; 
	                                    case 'sup': ch = String.fromCharCode(0x2283); break; 
	                                    case 'nsub': ch = String.fromCharCode(0x2284); break; 
	                                    case 'sube': ch = String.fromCharCode(0x2286); break; 
	                                    case 'supe': ch = String.fromCharCode(0x2287); break; 
	                                    case 'oplus': ch = String.fromCharCode(0x2295); break; 
	                                    case 'otimes': ch = String.fromCharCode(0x2297); break; 
	                                    case 'perp': ch = String.fromCharCode(0x22a5); break; 
	                                    case 'sdot': ch = String.fromCharCode(0x22c5); break; 
	                                    case 'lceil': ch = String.fromCharCode(0x2308); break; 
	                                    case 'rceil': ch = String.fromCharCode(0x2309); break; 
	                                    case 'lfloor': ch = String.fromCharCode(0x230a); break; 
	                                    case 'rfloor': ch = String.fromCharCode(0x230b); break; 
	                                    case 'lang': ch = String.fromCharCode(0x2329); break; 
	                                    case 'rang': ch = String.fromCharCode(0x232a); break; 
	                                    case 'loz': ch = String.fromCharCode(0x25ca); break; 
	                                    case 'spades': ch = String.fromCharCode(0x2660); break; 
	                                    case 'clubs': ch = String.fromCharCode(0x2663); break; 
	                                    case 'hearts': ch = String.fromCharCode(0x2665); break; 
	                                    case 'diams': ch = String.fromCharCode(0x2666); break; 
	                                    default: ch = ''; break; 
	                              } 
	                        } 
	                        i = semicolonIndex; 
	                  } 
	            } 
	            
	            out += ch; 
	      } 
	  
	      return out; 
	      
	} 
	

	
if(pid)
	{
		//var id = id ? Number(id.decrypt("nicnac")) : -1
		var pid = pid ? Number(pid) : -1
		
		var tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","0","rev_actimg","rev_pub")
		var act = Request.Form("act").Item;
		
		//var SQL = "select rev_rev from "+_db_prefix+"review where rev_rt_cat = " + pid + " and (rev_pub & 1) = 1 limit 0,1";
		//var bodytxt = _oDB.getrows(SQL).toString();
		
		var txt = filltempl(_bodytext,_templdat,_tmplfld);
		
		//if(bDebug)	
		//	Response.Write(txt+"\r\n\r\n\r\n\r\n\r\n\r\n");
		
		if(txt)
		{
			var pos = new Array();
			var ipos = 0;
			
			//txt = parse(txt,"<form","</form",0,0);
			txt = txt.replace(/<input/gi,"<INPUT").replace(/<select/gi,"<SELECT").replace(/<textarea/gi,"<TEXTAREA").replace(/ NAME=/gi," name=");
			var txtarr = txt.split(/<INPUT|<SELECT|<TEXTAREA/);
			
			//if(bDebug)
			//	Response.Write("<p style=background-color:#E0E0E0>"+Server.HTMLEncode(txtarr.join("\r\n\r\n")).replace(/\r\n/g,"</p><p style=background-color:#E0E0E0>")+"</p><br>" );
			
			var cumul_length = txtarr[0].length;;
			//Response.Write(txtarr[0]+"\r\n\r\n");
			for(var i=1; i<txtarr.length;i++)
			{
				//Response.Write(Server.HTMLEncode(txt.substring(cumul_length,cumul_length+10))+"<br>")
				var tag = txt.substring(cumul_length,cumul_length+10);
				tag = tag.substring(0,tag.indexOf(" "));
				
				//Response.Write(Server.HTMLEncode(tag)+"<br>")
				
				txtarr[i]   = tag + txtarr[i];
				var lasttagtxt = txtarr[i-1].substring(0,txtarr[i-1].lastIndexOf("</"));
				
				if(bDebug)
					Response.Write("<span style=background-color:#FFFF00>("+i+")"+Server.HTMLEncode(txtarr[i].substring(0,txtarr[i].indexOf(">")+1))+"</span><br>")
				
				//if(bDebug)
				//	Response.Write("<span style=background-color:#FFFF00>"+Server.HTMLEncode(lasttagtxt.substring(lasttagtxt.lastIndexOf("<"),lasttagtxt.length))+"</span><br>")
				
				//pos[ipos++] = cumul_length+lasttagtxt.lastIndexOf("<");
				//lasttagtxt = lasttagtxt.substring(lasttagtxt.lastIndexOf("<"),lasttagtxt.length)
				//pos[ipos++] = (cumul_length - txtarr[i-1].length) + txtarr[i-1].lastIndexOf("</")
				
				pos[ipos++] = cumul_length + txtarr[i].indexOf("name=")+("name=").length;	// position of input name
				if(bDebug)
				{
					var exn = txtarr[i].substring(pos[ipos-1]-cumul_length,pos[ipos-1])
					if(exn.charAt(0)=="\"")
						name = exn.substring(1,exn.substring(1,exn.length).indexOf("\"")+1)
					else
						name = exn.split(/ |>/)[0]
					
					Response.Write("<span style=color:#FF0000>EXTRACTED NAME = \""+ name  +"\"</span><br>");
					Response.Write("<span style=color:#FF0000>FORM VALUE = \""+ Request.Form(name).Item  +"\"</span><br><br>");
				}
				
				cumul_length += txtarr[i].length;
			}
			
			// PARSE FORM NAMES
			
			var j = 0;
			var formfld = new Array();
			var namepos = new Array();
			
			// ADD ID TAG BY DEFAULT !!!!!
			formfld[j++] = "mn_ID";
			formfld[j++] = "mn_DATETIME";
			formfld[j++] = "HIDDENFORMDATA";
			formfld[j++] = "FORMNAMEARRAY";
			formfld[j++] = "FETCHDB_URL";
			
			// ADD ID TIME STAMP BY DEFAULT !!!!!
			//formfld[j++] = "mn_DATETIME";
			
			var curpos = pos[0];
			for(var i=1; i<pos.length;i++)
			{
				var subtxt = txt.substring(curpos,pos[i])
				var name = subtxt.substring(0,subtxt.indexOf(">"));
				
				if(name.charAt(0)=="\"")
					name = name.substring(1,name.substring(1,name.length).indexOf("\"")+1)
				else
					name = name.split(/ |>/)[0]				
				
				if(bDebug)
					Response.Write("<span style=color:#00A000>PARSING FORM NAME = \""+ name  +"\"</span><br>");
				
				formfld[j] = name;
				
				//var end_tag = subtxt.indexOneOf([" ",">"]);
				//formfld[j] = subtxt.substring(0,end_tag);
				//if(bDebug)
				//	Response.Write(Server.HTMLEncode(subtxt)+" ["+formfld[j] + "] " +subtxt.substring(0,subtxt.indexOneOf([" ",">","\""]))+"<br>\r\n")	
				
				// NAMEPOS = RIGHT AFTER END-TAG  (POSITION OF THE EXCLAMATION SIGN, IF APPLICABLE)
				
				namepos[formfld[j]] = pos[i-1]+subtxt.indexOf(">")+1;
				j++;
				
				curpos = pos[i];
			}
			
			
			// STRING-SORT FORM NAMES
			//function strsort(_a, _b)
			//{
			//    return  _a > _b;
			//}			
				

			// PURGE OUT DOUBLE FORM NAMES
			var _j=0;
			var _prev_id;
			for (var _i=0;_i<formfld.length;_i++)
			{
				if(_prev_id != formfld[_i])
					formfld[_j++] = formfld[_i];
				_prev_id = formfld[_i];
			}
			formfld.length = _j;
			

			// FETCH FORM DATA
			var formarr  = new Array();
			var enumfld  = new Array();
			
			var dd = new Array();
			if(drevid>0 && dsid>0 && bSubmitted==false)
			{
				// LOAD XML
				var sSQL = "select rev_id,rev_rev from "+_db_prefix+"review where rev_id = "+drevid;
				var xmld = _oDB.getrows(sSQL);
				var rev_id = xmld[0];
				
				var XMLObj = loadXML(xmld[1]);
				var fields = XMLObj.getElementsByTagName("ROOT/row/field");
				var enumdataset = new Array();
				for(var i=0;i<fields.length;i++)
					enumdataset[ fields.item(i).text.substring(1,fields.item(i).text.length-1) ] = fields.item(i).getAttribute("name")
					
				// LOAD DATADETAIL
				var sSQL = "select rd_dt_id,rd_text from "+_db_prefix+"datadetail where rd_recno = "+dsid+" and rd_ds_id = "+drevid;
				//Response.Write(sSQL)
				
				
				
				// PUT DATA INTO NAMED VARIABLES
				var ddetail = _oDB.getrows(sSQL);
				for(var i=0;i<ddetail.length;i+=2)
				{
					dd[ enumdataset[ddetail[i]] ] = ddetail[i+1];
					//Response.Write("dd["+enumdataset[ddetail[i]]+"] = "+ddetail[i+1]+"<br>");
				}
				
				//Response.Write("<br><br>"+ddetail.join("<br>")+"<br><br>");
				//Response.Write(Server.HTMLEncode(xmld[0])+"!!!!!!!!!!!"+sSQL);
			}
			
			function FETCHFORM(name)
			{
				if(drevid>0 && dsid>0 && bSubmitted==false)
				{
					var d = dd[name];
					return d?d:"";
				}
				else
					return Request.Form(name).Item;				
			}
			
			for(var i=0;i<formfld.length;i++)
			{
				enumfld[formfld[i]] = i;
				formarr[i] = FETCHFORM(formfld[i]);
					
				if (bDebug)
					Response.Write("FORM['"+formfld[i]+"' ("+i+")] = '"+formarr[i]+"'<br>")
			}
			
			
			
			var txt = filltempl(_bodytext,_templdat,_tmplfld);
			
			// FILL ID WITH DUMMY DATA (TO GET ACCEPTANCE)
			formarr[0] = "-1";
			formarr[1] = "-1";
			formarr[2] = "-1";
			formarr[3] = "-1";
			
			// VALIDATE FORM DATA
			var Valids = new Array();
			var Err = new Array();
			for(var i=0;i<formfld.length;i++)
			{
				Err[i] = validate_std(formfld[i]);
				//Response.Write("err="+Err[i]+" ("+formfld[i]+") *"+formarr[enumfld[formfld[i]]]+"* "+validate_std(formfld[i],true)+"<br>")
			}
			// I S   E V E R Y T H I N G   V A L I D  ?
			
			//Response.End();
			if((Valids.length == formfld.length && dsid<0)
			|| (Valids.length == formfld.length && bSubmitted==true && dsid>0))
			{
				// OVERRIDE WITH XML ID
				var k = 0;
				formarr[k++] = _oDB.takeanumber("xml").toString();  // (mn_ID)
				formarr[k++] = new String(new Date());				// (mn_DATETIME)
				
				
				
				// B U I L D   H I D D E N F O R M D A T A   (HIDDENFORMDATA)
				formarr[k] = "";
				for(var i=k+1;i<formfld.length;i++)
					formarr[k] += "<input type=hidden name=\""+formfld[i]+"\" value=\""+Server.HTMLEncode(formarr[i])+"\">\r\n";
				k++;
				
				// B U I L D   F O R M   N A M E   A R R A Y  (FORMNAMEARRAY)
				formarr[k++] = formfld.slice(k,formfld.length).join("\",\"");
				
				
				for(var i=k+1;i<formfld.length;i++)
					formarr[k]+= "<input type=hidden name=\""+formfld[i]+"\" value=\""+formarr[i]+"\">\r\n";
				
				//  X M L   P R O C E S S I N G
				
				var FSO = Server.CreateObject("Scripting.FileSystemObject");
				var crc24      = Math.floor((_oDB.crc32(pid.toString())/256)+(1<<23));
				var numberbase =  anyfill(base64encode(crc24),4,"A") + anyfill(base64encode(pid),6,"A");
				
				// O V E R W R I T E   D T D
				
				var dtdfile = Server.MapPath("../"+_ws+"/xml")+"\\"+numberbase+".dtd";
				try
				{
					var fileObj = FSO.CreateTextFile(dtdfile,true,false);
					fileObj.Write("<!ELEMENT ROOT (row)+>\r\n");
					fileObj.Write("\t<!ELEMENT row ("+formfld.join(",")+")>\r\n");
					for(var i=0;i<formfld.length;i++)
						fileObj.Write("\t\t<!ELEMENT "+formfld[i]+" (#PCDATA)>\r\n");
					fileObj.Close();
				}
				catch(e)
				{
					Response.Write(numberbase+".dtd not found or insufficient access-rights. Please create this file first.<br>")
					//Response.End();
				}
				
				// APPEND XML RECORD
				
				var xmlfile = Server.MapPath("../"+_ws+"/xml")+"\\"+numberbase+".xml";
				if(!FSO.FileExists(xmlfile))
				{
					try
					{
					var fileObj = FSO.CreateTextFile(xmlfile,true,false);
					fileObj.Write("<"+"?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
					fileObj.Write("<!DOCTYPE ROOT SYSTEM \""+(numberbase+".dtd")+"\">\r\n");
					fileObj.Write("<ROOT>\r\n");
					fileObj.Close();
					}
					catch(e)
					{
						Response.Write(numberbase+".xml not found or insufficient access-rights. Please create this file first.<br>")
						//Response.End();
					}					
				}
				try
				{
					var ForAppending = 8;
					var fileObj = FSO.OpenTextFile(xmlfile,ForAppending,false);
					fileObj.Write("\t<row>\r\n");
					for(var i=0;i<formfld.length;i++)
						if(formarr[i] && formarr[i].length>0)
							fileObj.Write("\t\t<field name=\""+formfld[i]+"\">"+Server.HTMLEncode(formarr[i])+"</field>\r\n");
						else
							fileObj.Write("\t\t<"+formfld[i]+"/>\r\n");
					fileObj.Write("\t</row>\r\n");
					fileObj.Close();
				}
				catch(e)
				{
					Response.Write(numberbase+".xml file not found.<br>")
					//Response.End();
				}
				
				
				/*	
				// SEND E-MAIL ORDER
				try
				{
					var Mail = Server.CreateObject("Persits.Mailsender");
				
					Mail.Host = "localhost";
					Mail.From = "piron@nobel.be";	// FROM
					Mail.FromName = "Nobel";
					var arr = tmpl_overview[tmpl_enumfld["rev_email"]].replace(/,/g,";").split(";");
					
					for(var i=0;i<arr.length;i++)
					{
						//Response.Write(arr[i]+"<br>");
						Mail.AddAddress(arr[i]);  // DELIVERED TO
					}
					Mail.Subject = "Piron abonnement";
					Mail.Body = stripHtml(HtmlDecode(bodytext.replace(/\r\n/gm,"")).replace(/<br>/gim,"\r\n"));
				
					Mail.Send();
					
					//Response.Write(bodytext);
				}
				catch (e)
				{
					var returnpage = "06_index.asp";
					Response.Write(bodytext);
					Response.Write("<BR><BR><CENTER>Mail sender failed,<BR><BR> " + (e.number & 0xFFFF).toString(16) + " " + e.description + "<BR><BR> please contact <a href=mailto:blackbaby@pandora.be>administrator</a><BR><BR><INPUT type='button' value='Back' onclick=document.location='"+returnpage+"' id='button'1 name='button'1></CENTER>");
					Response.End();
				}
					
				*/
				
				// INFORM USER ABOUT SUCCESSFUL SUBSCRIPTION
				
				var tmpl_tablefld = new Array("rev_id","rev_title","rev_desc","rev_header","rev_rev","rev_pub","rev_email","rev_url")	
				var sSQL = "select "+tmpl_tablefld.join()+" from "+_db_prefix+"review where rev_rt_cat = "+cid+" and (rev_pub & 1) = 1 LIMIT 0,1";
				var tmpl_overview = _oDB.getrows(sSQL);
				
				if(bDebug)
					Response.Write("<br><span style=background-color:#F0FFFF>"+sSQL+"</span><br>")
				
				var tmpl_enumfld  = new Array();
				for(var i=0;i<tmpl_tablefld.length;i++)
					tmpl_enumfld[tmpl_tablefld[i]] = i;
					
				var bodytext = tmpl_overview[tmpl_enumfld["rev_rev"]];
				
				
				
				
				
				// FILL TEMPLATE
				
				
				
				if(bodytext)
				{
					// TODO INVOKE FILLTEMPLATE, BUT FIRST, PARSING ALGORITHM IN REF.ASP NEEDS TO BE WRITTEN AS A FUNCTION
				
					// FORM RELATED TEMPLATE
					for(var i=0;i<formfld.length;i++)
					{
						myRegExp = new RegExp("{_"+formfld[i]+"_}", "g")
						bodytext = bodytext.replace(myRegExp,formarr[enumfld[formfld[i]]])
					}
				}
					
				//Response.Write("<table cellspacing=\"0\" cellpadding=\"8\"  style=\"border: 1px solid #E0E0E0\" width="+(_body_width-4)+"><tr><td class=body>"+bodytext+"</td></tr></table>");
				
				_templdat[_enumtmpl["BODY"]] =  bodytext;


			}
			else
			{
				if(bDebug)
					Response.Write("<br>THERE WHERE ERRORS !!!<br>")
			
				// DISPLAY FORM DATA WITH ERROR MESSAGES
				var offsetpos = 0;
				for(var i=1;i<formfld.length;i++)
				{
					if(bDebug)
						Response.Write("FORMCHECK['"+formfld[i]+"'] = '"+Err[i]+"'<br>");
						
					if(Err[i])
					{
						// INSERT ATTRIBUTES + ERROR MESSAGE
						var insertpos = namepos[formfld[i]];
						//var insertattr = " value=\""+formarr[i]+"\"";
						var inserttxt = "<img src=../images/exclame.gif title="+Err[i]+" hspace=1>";
						
						//txt = txt.insertpos(insertattr,offsetpos+insertpos-1);
						//offsetpos += insertattr.length;
						txt = txt.insertpos(inserttxt,offsetpos+insertpos);
						offsetpos += inserttxt.length;
					}
					else
					{
						// INSERT ATTRIBUTES
						/*
						if(formarr[i]!="-1")
						{
							var insertpos = namepos[formfld[i]];
							var insertattr = " value=\""+formarr[i]+"\"";
							
							txt = txt.insertpos(insertattr,offsetpos+insertpos-1);
							offsetpos += insertattr.length;
						}
						*/
					}
				
				}
				
				
				// POST PROCESSING (COMBO BOXES)
				
				var oFORM = new FORM();
				var oPARSE = new oFORM.PARSE();
				oPARSE.get(txt);
				
				var len = oPARSE.src.length/2;
				//Response.Write(Server.HTMLEncode(oPARSE.src[0])+"<br>")
				
				for(var j=1;j<len;j++)
				{
					var bodypart = oPARSE.src[j*2-1];
					if(bodypart)
					{
						var val = FETCHFORM(oPARSE.tnames[j]);
						
						if(val && val.length>0)
						{
							switch(oPARSE.types[j])
							{
								case "input":
									if(bodypart.indexOf("type=submit")<0 && bodypart.indexOf("type=\"submit")<0)
									{
										// CAUTION !!!  value attribute must be at the END of the enclosed tag,
										//              otherwise, it's beeing removed !!
										bodypart = bodypart.replace(/ value=".*"/gi,"").replace(/ value=.*[ >]/gi,">");
										bodypart = bodypart.substring(0,bodypart.length-1)+" value=\""+Server.HTMLEncode(val)+"\""+">";
										//+"<img src=../images/exclame.gif title="+Err[j-1]+" hspace=1>";
										oPARSE.src[j*2-1] = bodypart;
									}
								break;
								case "textarea":
									bodypart = bodypart.substring(0,bodypart.indexOf(">"))+">"+(FETCHFORM(oPARSE.tnames[j]))+"</textarea>";
									oPARSE.src[j*2-1] = bodypart;
								break;
								case "select":
								
									bodypart = bodypart.replace(/ selected /gi,"");
									bodypart = bodypart.replace(/ selected>/gi,">"); 
									
									var rplc = "value=\""+FETCHFORM(oPARSE.tnames[j])+"\"";
									var by   = "value=\""+FETCHFORM(oPARSE.tnames[j])+"\" selected ";
									
									if(bDebug)
										Response.Write("<br>#REPLACE '"+Server.HTMLEncode(rplc)+"' BY '"+Server.HTMLEncode(by)+"'<br>");
										
									bodypart = bodypart.replace(new RegExp(rplc,""),by);
									
									var rplc = "value="+FETCHFORM(oPARSE.tnames[j])+"([ >])";
									var by   = "value=\""+FETCHFORM(oPARSE.tnames[j])+"\" selected $1";
									
									if(bDebug)
										Response.Write("<br>#REPLACE '"+Server.HTMLEncode(rplc)+"' BY '"+Server.HTMLEncode(by)+"'<br>");
									
									bodypart = bodypart.replace(new RegExp(rplc,""),by);
									
									var rplc = ">"+FETCHFORM(oPARSE.tnames[j])+"<";
									var by   = " selected>"+FETCHFORM(oPARSE.tnames[j])+"<";
									
									if(bDebug)
										Response.Write("<br>#REPLACE '"+Server.HTMLEncode(rplc)+"' BY '"+Server.HTMLEncode(by)+"'<br>");
									
									bodypart = bodypart.replace(new RegExp(rplc,""),by);									
									
									
									oPARSE.src[j*2-1] = bodypart;	
									
								break;
							}
						}
					}
				}
				
				
				
				// O V E R R I D E   B O D Y   T E X T				
				_templdat[_enumtmpl["BODY"]] =  oPARSE.src.join("");
			}
			
			//Response.Write(formarr+"<br>"+formfld)
			// ALL FIELDS STARTING WITH "_MN" ARE MANDATORY
			//Response.Write(formarr);
		}
		
		
		
		////  I N V O K E   E X T R A   P A R S E R
		
		_templdat[_enumtmpl["BODY"]] = oDATA.parse(_templdat[_enumtmpl["BODY"]])
		
		
	}
	
	//function replacepos(str,chr,pos)
	//{
	//	return str.substring(0,pos)+chr+str.substring(pos+1,str.length);
	//}
	


	function validate_std(test)
	{
		//if (bSubmitted==false)
		//	return "";
		
		//Response.Write("TESTING['"+test+"']<br>")
		
		var val = formarr[enumfld[test]];
		if (!val)
			val = "";
		
		val = val.toString().replace(/\'/g,"\\\'");

		var bRequired = false;
		var decision  = test;
		if(test.indexOf("mn_")==0)
		{
			bRequired = true;
			decision  = test.substring(("_mn").length,test.length);
		}
		
		//if(bDebug)
		//Response.Write("TESTING['"+test+"'] "+(!val && bRequired==true)+"<br>")		
		
		if (!val && bRequired==true)
			return _T["mandatory"]?_T["mandatory"]:"mandatory";
		
		switch (decision)
		{
			case "name":
				if (!val.isAlnum())
					return "alfanumerisch";
				var result = _oDB.get("select acc_name from "+_db_prefix+"acc where acc_name='"+val+"'");
				if (result)
					return _T["inuse"]?_T["inuse"]:"already in use";
			break;
			case "psw":
				if(val.length<4)
					return "min. 4 tekens";
				if (!val.isAlnum())
					return _T["alphanumericexpected"]?_T["alphanumericexpected"]:"alphanimeric input expected";
			break;
			case "vat":
			case "nr":
			case "zip":
				if (!val.isDigit())
					return _T["numericexpected"]?_T["numericexpected"]:"alphanimeric input expected";
			break;
		}
		
		if(val && decision.substring(decision.length-("email").length,decision.length)=="email")
		{
				var atpos = val.indexOf('@');
				var dotpos = val.lastIndexOf('.');
				var totlen = val.length;
				var forbidden = " ~\'^\`\"*+=\\|][(){}$&!#%/:,;"
				
				if (!(!val.isForbidden(forbidden) && atpos>0 && dotpos>2 && dotpos>atpos && atpos<(totlen-4) && dotpos<(totlen-2) ))
					return _T["invalid"]
					
		}
		
		
		Valids[Valids.length] = true;
		
		return "";
	}	

	function parse(str,startstr,endstr,startoffset,endoffset)
	{
		return str.substring(
			str.toLowerCase().indexOf(startstr)
			+startstr.length
			+startoffset
			,
			str.toLowerCase().indexOf(endstr.toLowerCase())+endoffset
			);
	}
	
	function parse_from(str,startstr,startoffset)
	{
		return str.substring(str.indexOf(startstr)+startstr.length+startoffset,str.length);
	}
	
	function parse_to(str,endstr,endoffset)
	{
		if (str)
			return str.substring(0,str.indexOf(endstr)+endoffset);
		else
			return "";
	}

%>


<%=filltempl(new String(_templtext),_templdat,_tmplfld)%>


<p class="footer" style="text-align:left;padding-left:0px">
	<%if(Request.QueryString("mode").Item == "login")
	  {
	%>
		<table cellspacing="0" cellpadding="0" width="241" class="small" border="1">
			<tr><td bgcolor="#FFFBF0" WIDTH="181" style="padding-left:5px;padding-right:0px;"><form name="login" method="post" action="../admin/validate.asp"><table height="100" width="100" cellspacing="2" cellpadding="3"><tr><td width="100" style="font-family:verdana;font-size:13px">log</td><td><input size="6" type="text" name="log" maxlength="12"></td></tr><tr><td width="100" style="font-family:verdana;font-size:13px">psw</td><td><input size="6" type="password" name="pwd" maxlength="12"></td></tr><tr><td></td><td><input type="hidden" name="dir" value="<%=_dir%>"><input type="submit" value="login"></td></tr></table></form></td></tr>
		</table>
	<%
	  }
	  else
	  {
	%>
		<!--img SRC="../images/mugo_sponsors.gif" WIDTH="268" HEIGHT="49">
		<a href="../art-event_nlbe/index_Q_P_E_<%=Request.QueryString("P").Item%>.asp?mode=login"><img src="../images/spc.gif" width="10" height="30" hspace="50" border="0"></a><br-->
	<%
	  }
	%>
</p>




<!--  M A I N    T E X T    E N D  -->