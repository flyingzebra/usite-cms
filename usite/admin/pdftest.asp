<%@ Language=JavaScript %>
<HTML>
<body>
<%


var Pdf = Server.CreateObject("Persits.Pdf");

/*
var Doc = Pdf.CreateDocument();

Doc.Title = "AspPDF Chapter 3 Hello World Sample";
Doc.Creator = "John Smith";

var Page = Doc.Pages.Add();
var Font = Doc.Fonts("Helvetica");

var Params = "x=0; y=650; width=612; alignment=center; size=50"

Page.Canvas.DrawText("Hello World!", Params, Font);


Filename = Doc.Save( Server.MapPath("../textilemagazine/pdf/hello.pdf"), false )

Response.Write ("Success! Download your PDF file <A HREF=../textilemagazine/pdf/hello.pdf>here</A>")
*/



var Doc = Pdf.OpenDocument( Server.MapPath("../textilemagazine/pdf/N° 012 - 05.2005 - distribution textile - Enseignes néerlandaises.pdf") )
//var Doc = Pdf.OpenDocument( Server.MapPath("../textilemagazine/pdf/hello.pdf") )




var PageCollection = Doc.Pages;

Response.Write("Doc.Pages.Count = "+Doc.Pages.Count+"<br>")

var txt = Doc.Pages(2).ExtractText()

/*
txt = txt.replace(/([^ ][^ ])\s([^ ])\s([^ ])\s([^ ][^ ])/g, "$1  $2   $3  $4");
txt = txt.replace(/([^ ][^ ])\s([^ ])\s([^ ][^ ])/g, "$1  $2  $3");
txt = txt.replace(/\s([^ ])\s/g, "$1");
txt = txt.replace(/- /g, "");
*/

Response.Write(Server.HTMLEncode(txt))



%>
</body>
</html>