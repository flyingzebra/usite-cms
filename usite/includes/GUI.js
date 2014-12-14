///////////////////////////
//  G U I    C L A S S   //
///////////////////////////


function zerofill(arg,n)
{
	var z = "0000000000" + arg;
	return z.substring(z.length-n,z.length)
}
	

Date.prototype.format = function (fmt) 
{
	fmt = fmt.replace( new RegExp("%Y", "g"), zerofill(this.getYear(),4) );
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

	var days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
	var months = ['January','February','March','April','May','June','July','August','September','October','November','December']
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

String.prototype.toDate = function () 
{
	if (!this)
		return;
			
	var century=20;year=0,month=0,day=0,hour=0,min=0,sec=0;
	
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
		
	case 10: // format DDxMMxYYYY
		day   = Number(this.substring(0,2));
		month = Number(this.substring(3,5));
		year  = Number(this.substring(6,10));
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
		return;
	}
}

