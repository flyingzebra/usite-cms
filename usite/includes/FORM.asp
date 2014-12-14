<%
function FORM()
{
	this.PARSE		= FORM_PARSE;
	this.IO         = FORM_IO;
	this.URL		= FORM_URL;
	this.init		= FORMinit;
	this.init();
}

function FORMinit()
{
	// instantiate subclass objects
	this.parse		= new this.PARSE;
	this.io 		= new this.IO;
	this.tnames		= new Array();
	this.unames		= new Array();
	this.types		= new Array();
	this.src   		= new Array();
	this.values		= new Array();
}

function FORM_PARSE()
{
	this.get		 = getFORM_PARSE;
	this.init		 = FORM_PARSEinit;
	this.init();
}

function FORM_IO()
{
	this.put         = putFORM_IO;
	this.get         = getFORM_IO;
	this.init        = FORM_IOinit;
	this.init();
}

function FORM_URL()
{
	this.prefill	 = prefillFORM_URL;
        this.put         = putFORM_URL;	   



	this.init        = FORM_URLinit;
	this.init();
}

function FORM_URLinit()
{
	this.bDebug		 = false;
	this.bSpiderSafe 	 = false;
	this.SpiderSafeLength 	 = -1;
     	this.param_arr		 = new Array();
     	this.value_arr		 = new Array();
	this.preparam_arr	 = new Array();
	this.prevalue_arr	 = new Array();
}

function prefillFORM_URL(_param_arr,_value_arr)
{
//     if(typeof(_param_arr)!="object")  _param_arr = typeof(_param_arr)=="number"?new Array(new Number(_param_arr)):new Array(_param_arr);
//     if(typeof(_value_arr)!="object")  _value_arr = typeof(_value_arr)=="number"?new Array(new Number(_value_arr)):new Array(_value_arr);

     this.preparam_arr		 = new Array();
     this.prevalue_arr		 = new Array();

     var _val = Request.QueryString("P").Item; if(_val) { this.preparam_arr[0] = "P" ; this.prevalue_arr[0] = _val }
     var _val = Request.QueryString("S").Item; if(_val) { this.preparam_arr[1] = "S" ; this.prevalue_arr[1] = _val }

     if(typeof(_param_arr)=="object")
     {
	this.preparam_arr = this.preparam_arr.concat(_param_arr);
	this.prevalue_arr = this.prevalue_arr.concat(_value_arr);
     }
}

function putFORM_URL(_param_arr,_value_arr)
{
//     if(typeof(_param_arr)!="object")  _param_arr = typeof(_param_arr)=="number"?new Array(new Number(_param_arr)):new Array(_param_arr);
//     if(typeof(_value_arr)!="object")  _value_arr = typeof(_value_arr)=="number"?new Array(new Number(_value_arr)):new Array(_value_arr);

	var _str = _url.substring(_url.lastIndexOf("/")+1,_url.length);

	if(_param_arr.length==0)
	   return _str;

	this.param_arr = this.preparam_arr.concat(_param_arr);
	this.value_arr = this.prevalue_arr.concat(_value_arr);

	if(this.bSpiderSafe)
	{
		_pos = _str.lastIndexOf(".");
		_ext = _str.substring(_pos,_str.length);
		_str = _str.substring(0,_pos);
		this.SpiderSafeLength = this.SpiderSafeLength==-1?this.param_arr.length:this.SpiderSafeLength;

		var _equarr = new Array();
		for(var _j=0;_j<this.SpiderSafeLength;_j++)
			_equarr[_j] = this.param_arr[_j]+"_E_"+this.value_arr[_j];
		_str += (this.SpiderSafeLength>0?("_Q_"+_equarr.join("_A_")):"")+_ext;
		if(this.SpiderSafeLength < this.param_arr.length)
		{
			var _equarr = new Array();
			for(var _j=this.SpiderSafeLength;_j<this.param_arr.length;_j++)
				_equarr[_j-this.SpiderSafeLength] = this.param_arr[_j]+"="+this.value_arr[_j];
			_str += "?"+_equarr.join("&");	
		}
	}
	else
	{
		var _equarr = new Array();
		for(var _j=0;_j<this.param_arr.length;_j++)
			_equarr[_j] = this.param_arr[_j]+"="+this.value_arr[_j];
		_str += "?"+_equarr.join("&");
	}
	return _str;
}


function FORM_IOinit()
{
	this.bDebug		= false;
	this.bSubmitted = true;
}

function putFORM_IO(value,type,format)
{
// DATABASE >> FORM
switch(type)
{
    case "date":
		var df = format;
		if(df)
		{
			df = df.replace(/%d/g,"dd");
			df = df.replace(/%m/g,"mm");
			df = df.replace(/%Y/g,"yyyy");
			df = df.replace(/%H/g,"hh");
			df = df.replace(/%M/g,"mm");
			df = df.replace(/%S/g,"dd");
			df = df.replace(/%/g,"");
		}
		var vdate = typeof(value)=="date"?new Date(value).format(format):
					   (value?value.toString().toDate("%Y-%m-%d %H:%M:%S").format(format):"");
		return vdate;
	break;
	default:
	return value;
}

}

function getFORM_IO(value,type,format)
{
// FORM >> DATABASE
	switch(type)
	{
		case "date":
			return value?value.toString().toDate(format).format("%Y-%m-%d %H:%M:%S"):"";
		default: return value;
	}
}


function getFORM_PARSE(_txt)
{
	if(!_txt)
		return false;
	
	_txt = _txt.replace(/<input/gi,"<inputinput");
	_txt = _txt.replace(/<select/gi,"<selectselect");
	_txt = _txt.replace(/<textarea/gi,"<textareatextarea");
	
	this.tnames		= new Array();
	this.unames		= new Array();
	this.types		= new Array();
	this.values		= new Array();
	this.src		= new Array();
	
	var _arr = _txt.split(/<input|<select|<textarea/ig);
	
	var _j=0;
	this.src[_j++] = _arr[0]
	
	for(var _i=0;_i<_arr.length;_i++)
	{
		var _str = _arr[_i];
		if(_str)
		{
			this.types[_i] = _str.substring(0,_str.indexOf(" "));
			var _name = _str.split(/name=/i)[1];
			_name = _name?(_name.split(/>| |"|'/)[0]):"";

			this.tnames[_i] = _name;
			this.unames[_i] = _name;
			
			var _value = _str.split(/value=/i)[1];
			_value = _value?(_name.split(/>| |"|'/)[0]):"";
			
			switch(this.types[_i])
			{
				case "input":
					var _src =  "<"+_str.substring(0,_str.indexOf(">")+1);
					this.src[_j++] = _src;
					this.src[_j++] = _str.substring(_src.length-1,_str.length);
				break;
				case "select":
					var _src =  "<"+_str.split(/<\/select>/i)[0]+"</select>";
					this.src[_j++] = _src;
					this.src[_j++] = _str.substring(_src.length-1,_str.length);
				break;
				case "textarea":
					var _src =  "<"+_str.split(/<\/textarea>/i)[0]+"</textarea>";
					this.src[_j++] = _src;
					this.src[_j++] = _str.substring(_src.length-1,_str.length);
				break;
			}
			
		}
	}
	this.unames = purge_doubles(this.unames.sort());	
	return true;
}

function FORM_PARSEinit()
{
	this.bDebug		= false;
}


/// E X T R A   F U N C T I O N S

function purge_doubles(_parr)
{
	var _j=0;
	var _prev_id;
	for (var _i=0;_i<_parr.length;_i++)
	{
		if(_prev_id != _parr[_i])
			_parr[_j++] = _parr[_i];
		_prev_id = _parr[_i];
	}
	_parr.length = _j;
	return _parr;
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

%>





