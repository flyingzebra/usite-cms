<%@ Language=JavaScript %>


<%//=Request.QueryString().Item%>
<%
	var ToDo = Request.QueryString("ToDo").Item;
	var imgDir = Request.QueryString("imgDir").Item;
	var DEP1 = Request.QueryString("DEP1").Item;
	var DEP = Request.QueryString("DEP").Item;
	
	var _host = Request.ServerVariables("HTTP_HOST").Item
	var _url = Request.ServerVariables("URL").Item;



/*

ToDo=InsertImage
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
&imgDir=/devedit/demo/testimages
&wi=0
&tn=1
&du=0
&dd=0
&dt=1

*/

%>



<%
switch(ToDo)
{
case "InsertImage":
%>


		<script language=JavaScript>

		window.onload = this.focus;

		window.opener.doStyles()
		window.onerror = function() { return true; }
		var myPage = window.opener;
		var imageAlign

		var imageDir = Array('.','..')
		if (window.opener.imageEdit) {
			imageAlign = window.opener.selectedImage.align
		}

		function toggleUploadDiv()
		{
			if(uploadDiv.style.display == "none")
			{
				document.getElementById("toggleButton").value = "«";
				document.getElementById("upload").focus();
				document.getElementById("upload").select();
				uploadDiv.style.display = "inline";
				dummyDiv.style.display = "inline";
				divList.style.height = 225;
				previewWindow.style.height = 50;
			}
			else
			{
				document.getElementById("toggleButton").value = "»";
				document.getElementById("upload").focus();
				document.getElementById("upload").select();
				uploadDiv.style.display = "none";
				dummyDiv.style.display = "none";
				divList.style.height = 325;
				previewWindow.style.height = 150;
			}
		}

		function outputImageLibraryOptions()
		{
			document.write(opener.imageLibs);

			// Loop through all of the image libraries and find the selected one
			for(i = 0; i < selImageLib.options.length; i++)
			{
				if(selImageLib.options[i].value == "<%=imgDir%>")
				{
					selImageLib.selectedIndex = i;
					break;
				}
			}
		}

		function switchImageLibrary(thePath)
		{
			// Change the path of the image library
			document.location.href = '<%="http://"+_host+_url%>?ToDo=InsertImage&DEP=<%=DEP%>&DEP1=<%=DEP1%>&imgDir='+thePath+'&dd=0&du=0&wi=0&tn=1&dt=1&wi=0';
		}

		function previewModify() {

			var imageWidth = myPage.selectedImage.width;
			var imageHeight = myPage.selectedImage.height;
			var imageBorder = myPage.selectedImage.border;
			var imageAltTag = myPage.selectedImage.alt;
			var imageHspace = myPage.selectedImage.hspace;
			var imageVspace = myPage.selectedImage.vspace;

			document.getElementById("previewWindow").innerHTML = "<img src=" + selectedImage.replace(/ /g, "%20") + ">"

			insertButton.value = "Modify"
			document.title = "Modify Image Properties"

			if (document.getElementById("deleteButton") != null) {
				deleteButton.disabled = true
			}

			previewButton.disabled = false
			insertButton.disabled = false

			if (document.getElementById("backgdButton") != null) {
				backgdButton.disabled = false
			}

			image_width.value = imageWidth;
			image_height.value = imageHeight;

			if (imageBorder == "") {
				imageBorder = "0"
			}

			border.value = imageBorder;
			alt_tag.value = imageAltTag;
			hspace.value = imageHspace;
			vspace.value = imageVspace;
			// tableForm.cell_width.value = cellWidth;
			this.focus();
		}

		function deleteImage(imgSrc)
		{
			var delImg = confirm("Are you sure you wish to delete this file?");

			if (delImg == true) {
				document.location.href = '<%="http://"+_host+_url%>?ToDo=DeleteImage&DEP=<%=DEP%>&DEP1=<%=DEP1%>&imgDir=<%=imgDir%>&tn=1&dt=1&wi=0&du=0&dd=0&imgSrc='+imgSrc;
			}

		}

		function setBackground(imgSrc)
		{
			var setBg = confirm("Are you sure you wish to set this image as the page background image?");

			if (setBg == true) {
				window.opener.setBackgd(imgSrc);
				self.close();
			}
		}

		function viewImage(imgSrc)
		{
			var sWidth =  screen.availWidth;
			var sHeight = screen.availHeight;
			
			window.open(imgSrc, 'image', 'width=500, height=500,scrollbars=yes,resizable=yes,left='+(sWidth/2-250)+',top='+(sHeight/2-250));
		}

		function grey(tr) {
				tr.className = 'b4';
		}

		function ungrey(tr) {
				tr.className = '';
		}

		function insertImage(imgSrc) {

			var error = 0;

				imageWidth = image_width.value
				imageHeight = image_height.value
				imageBorder = border.value
				imageHspace = hspace.value
				imageVspace = vspace.value

				if (isNaN(imageWidth) || imageWidth < 0) {
					alert("Image width must contain a valid, positive number")
					error = 1
					image_width.select()
					image_width.focus()
				} else if (isNaN(imageHeight) || imageHeight < 0) {
					alert("Image height must contain a valid, positive number")
					error = 1
					image_height.select()
					image_height.focus()
				} else if (isNaN(imageBorder) || imageBorder < 0 || imageBorder == "") {
					alert("Image border must contain a valid, positive number")
					error = 1
					border.select()
					border.focus()
				} else if (isNaN(imageHspace) || imageHspace < 0) {
					alert("Horizontal spacing must contain a valid, positive number")
					error = 1
					hspace.select()
					hspace.focus()
				} else if (isNaN(vspace.value) || vspace.value < 0) {
					alert("Vertical spacing must contain a valid, positive number")
					error = 1
					vspace.select()
					vspace.focus()
				}

				if (error != 1) {

					var sel = window.opener.foo.document.selection;
					if (sel!=null) {
						var rng = sel.createRange();
						if (rng!=null) {

							if (window.opener.imageEdit) {
								oImage = window.opener.selectedImage
								if (imgSrc.indexOf("http") >= 0) {
									oImage.src = imgSrc
								} else {
									oImage.src = window.opener.HTTPStr + "://" + window.opener.URL + imgSrc
								}
							} else { 
								HTMLTextField = '<img id="de_element_image" src="' + imgSrc + '">';
								rng.pasteHTML(HTMLTextField)

								oImage = window.opener.foo.document.getElementById("de_element_image")
							}

							if (imageWidth != "")
								oImage.width = imageWidth

							if (imageHeight != "")
								oImage.height = imageHeight

							oImage.alt = alt_tag.value
							oImage.border = border.value
							
							if (hspace.value != "") {
								oImage.hspace = hspace.value
							}

							if (vspace.value != "") {
								oImage.vspace = vspace.value
							} else {
								oImage.removeAttribute('vspace',0)
							}

							if (align[align.selectedIndex].text != "None") {
								oImage.align = align[align.selectedIndex].text
							} else {
								oImage.removeAttribute('align',0)
							}

							styles = sStyles[sStyles.selectedIndex].text

							if (styles != "") {
								oImage.className = styles
							} else {
								oImage.removeAttribute('className',0)
							}

							// window.opener.doToolbar()
							// window.opener.foo.focus();
							self.close();

							if (window.opener.imageEdit) {
								// do nothing
							} else { 
								oImage.removeAttribute("id")
							}


						} // End if
					} // End If
				}
		} // End function

		function insertExtImage() {
			selectedImage = document.getElementById("externalImage").value
			
			if (previousImage != null) {
				previousImage.style.border = "3px solid #FFFFFF"
			}

			document.getElementById("previewWindow").innerHTML = "<img src=" + selectedImage.replace(/ /g, "%20") + ">"

			if (document.getElementById("deleteButton") != null) {
				deleteButton.disabled = true
			}

			previewButton.disabled = false
			insertButton.disabled = false

			if (document.getElementById("backgdButton") != null) {
				backgdButton.disabled = false
			}

		} // End function

		var imageFolder = "<%=imgDir%>/"
		var previousImage
		var selectedImage
		var selectedImageEncoded
		function doSelect(oImage) {
			selectedImage = imageFolder + oImage.childNodes(0).name
			selectedImageEncoded = oImage.childNodes(0).name2
			
			oImage.style.border = "3px solid #08246B"
			currentImage = oImage
			if (previousImage != null) {
				if (previousImage != currentImage) {
					previousImage.style.border = "3px solid #FFFFFF"
				}
			}
			previousImage = currentImage

			document.getElementById("previewWindow").innerHTML = "<img src=" + selectedImage.replace(/ /g, "%20") + ">"
			previewButton.disabled = false
			insertButton.disabled = false
			
			if (document.getElementById("backgdButton") != null) {
				backgdButton.disabled = false
			}

			if (document.getElementById("deleteButton") != null) {
				deleteButton.disabled = false
			}
		}

		function printStyleList() {
			if (window.opener.document.getElementById("sStyles") != null) {
				document.write(window.opener.document.getElementById("sStyles").outerHTML);
				document.getElementById("sStyles").className = "text70";
					if (document.getElementById("sStyles").options[0].text == "Style") {
						document.getElementById("sStyles").options[0] = null;
						document.getElementById("sStyles").options[0].text = "";
					} else {
						document.getElementById("sStyles").options[1].text = "";
					}

				document.getElementById("sStyles").onchange = null;  
				document.getElementById("sStyles").onmouseenter = null; 
			} else {
				document.write("<select id=sStyles class=text70><option selected></option></select>")
			}
		}

		function printAlign() {
			if ((imageAlign != undefined) && (imageAlign != "")) {
				document.write('<option selected>' + imageAlign)
				document.write('<option>')
			} else {
				document.write('<option selected>')
			}
		}

		function CheckImageForm()
		{
			//upload, upload1, upload2, upload3, upload4
			var imgDir = '<%=imgDir%>';
			var u1 = document.getElementById("upload");
			var u2 = document.getElementById("upload1");
			var u3 = document.getElementById("upload2");
			var u4 = document.getElementById("upload3")
			var u5 = document.getElementById("upload4");

			// Extract just the filename from the paths of the files being uploaded
			u1_file = u1.value;
			last = u1_file.lastIndexOf ("\\", u1_file.length-1);
			u1_file = u1_file.substring (last + 1);

			u2_file = u2.value;
			last = u2_file.lastIndexOf ("\\", u2_file.length-1);
			u2_file = u2_file.substring (last + 1);

			u3_file = u3.value;
			last = u3_file.lastIndexOf ("\\", u3_file.length-1);
			u3_file = u3_file.substring (last + 1);

			u4_file = u4.value;
			last = u4_file.lastIndexOf ("\\", u4_file.length-1);
			u4_file = u4_file.substring (last + 1);

			u5_file = u5.value;
			last = u5_file.lastIndexOf ("\\", u5_file.length-1);
			u5_file = u5_file.substring (last + 1);

			if(u1_file == "" && u2_file == "" && u3_file == "" && u4_file == "" && u5_file == "")
			{
				alert('Please chose an image to upload first!');
				return false;
			}

			// Loop through the imageDir array
			if(u1_file != "")
			{
				for(i = 0; i < imageDir.length; i++)
				{
					if(u1_file == imageDir[i])
					{
						if(!confirm(u1_file + ' already exists. Are you sure you want to overwrite it?'))
						{
							return false;
						}
					}
				}
			}

			if(u2_file != "")
			{
				for(i = 0; i < imageDir.length; i++)
				{
					if(u2_file == imageDir[i])
					{
						if(!confirm(u2_file + ' already exists. Are you sure you want to overwrite it?'))
						{
							return false;
						}
					}
				}
			}

			if(u3_file != "")
			{
				for(i = 0; i < imageDir.length; i++)
				{
					if(u3_file == imageDir[i])
					{
						if(!confirm(u3_file + ' already exists. Are you sure you want to overwrite it?'))
						{
							return false;
						}
					}
				}
			}

			if(u4_file != "")
			{
				for(i = 0; i < imageDir.length; i++)
				{
					if(u4_file == imageDir[i])
					{
						if(!confirm(u4_file + ' already exists. Are you sure you want to overwrite it?'))
						{
							return false;
						}
					}
				}
			}

			if(u5_file != "")
			{
				for(i = 0; i < imageDir.length; i++)
				{
					if(u5_file == imageDir[i])
					{
						if(!confirm(u5_file + ' already exists. Are you sure you want to overwrite it?'))
						{
							return false;
						}
					}
				}
			}

			return true;
		}

		</script>

		<title>Insert Image</title>
		<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
		<body bgcolor=threedface style="border: 1px buttonhighlight;">
		<div class="appOutside">
		<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
			<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
			<span>Enter the URL of the image to insert or choose an image from those shown below and click on the insert button to add it to your content.</span>
		</div>
		<br>
		<form enctype="multipart/form-data" action="<%="http://"+_host+_url%>?ToDo=UploadImage&DEP=<%=DEP%>&DEP1=<%=DEP1%>&imgDir=<%=imgDir%>&wi=0&tn=1&dd=0&dt=1&du=0" method="post" onSubmit="return CheckImageForm()">
		<span class="appInside1" style="width:350px">
			<div class="appInside2">
							<div class="appInside3" style="padding:11px"><span class="appTitle">Upload Image</span>
					<br>
					<input type="file" name="upload" class="Text230"> <input type="submit" value="Upload" class="Text75"> <input type="button" value="»" class="Text15" onClick="toggleUploadDiv()" id="toggleButton">
					<span class="err" style="position:absolute; left:40; top:86;"></span>
					<div id="uploadDiv" style="display:none">
						<input type="file" name="upload1" class="Text230"><br>
						<input type="file" name="upload2" class="Text230"><br>
						<input type="file" name="upload3" class="Text230"><br>
						<input type="file" name="upload4" class="Text230">
					</div>
							</div>
			</div>
		</span>
		&nbsp;
		 			<span class="appInside1" style="width:350px">
				<div class="appInside2">
					<div class="appInside3" style="padding:11px"><span class="appTitle">External Image</span>
						<br>
						<input type="text" name="externalImage" id="externalImage" class="Text240" value="http://">&nbsp;<input type=button value=Load class="Text75" onClick="insertExtImage()"><br>
						<div style="height:100; display:none" id="dummyDiv">
							&nbsp;
						</div>
					</div>
				</div>
			</span>
				</form>
		<span class="appInside1" style="width:350px">
			<div class="appInside2">
				<div class="appInside3" style="padding:11px"><span class="appTitle">Internal Image</span>
					<table border=0 cellspacing=0 cellpadding=0 style="padding-bottom:5px">
					<tr><td><select style="width:242px; font-size:11px; font-family:Arial;" name="selImageLib">
						<script>outputImageLibraryOptions();</script>
					</select>
					</td><td><input type=button value="Switch" class=text75 onClick="switchImageLibrary(selImageLib.value)"></td></tr>
					</table>
			<div style="height:325px; width:325px; overflow: auto; border: 2px inset; background-color: #FFFFFF" id="divList">
							<table border="0" cellspacing="0" cellpadding="5" style="width:100%">
							  <tr>
			</tr><tr></tr><tr>		<tr>
			<td width="100%" class="body" >
				<font color="gray">[The selected image library is empty]</font>
			</td>
		</tr>
					</table>
				</div>
				</div>
			</div>
		</span>
		&nbsp;
		<span class="appInside1" style="width:350px; position:absolute">
			<div class="appInside2">
				<div class="appInside3" style="padding:11px"><span class="appTitle">Preview</span><br>
					<span id="previewWindow" style="padding:10px; height:150px; width:240px; overflow: auto; border: 2px inset; background-color: #FFFFFF">
					</span><input type="button" name="previewButton" value="Preview" class="Text75" onClick="javascript:viewImage(selectedImage)" disabled=true style="position:absolute; left:257px;">
				</div>
			</div>
		</span>

		<span class="appInside1" style="width:350px; padding-top:5px;">
			<div class="appInside2">
				<div class="appInside3" style="padding:11px"><span class="appTitle">Image Properties</span>
				<table border="0" cellspacing="0" cellpadding="5">
				  <tr>
					<td class="body" width="70">Alternate Text:</td>
					<td class="body" width="88">
					  <input type="text" name="alt_tag" size="50" class="Text70">
					</td>
					<td class="body" width="80">Border:</td>
					<td class="body" width="80">
					<input type="text" name="border" size="3" class="Text70" maxlength="3" value="0">
					</td>
				  </tr>
				  <tr>
					<td class="body">Image Width:</td>
					<td class="body">
					  <input type="text" name="image_width" size="3" class="Text70" maxlength="3">
				  </td>
					<td class="body">Image Height:</td>
					<td class="body">
					  <input type="text" name="image_height" size="3" class="Text70" maxlength="3">
					</td>
				  </tr>
				  <tr>
					<td class="body">Horizontal Spacing:</td>
					<td class="body">
					  <input type="text" name="hspace" size="3" class="Text70" maxlength="3">
					</td>
					<td class="body">Vertical Spacing:</td>
					<td class="body">
					  <input type="text" name="vspace" size="3" class="Text70" maxlength="3">
					</td>
				  </tr>
					<tr>
						<td class="body">Alignment:</td>
						<td class="body">
						  <SELECT class=text70 name=align>
							<script>printAlign()</script>
							<option>Baseline
							<option>Top
							<option>Middle
							<option>Bottom
							<option>TextTop
							<option>ABSMiddle
							<option>ABSBottom
							<option>Left
							<option>Right</option>
						  </select>
						</td>
						<td class="body">Style:</td>
						<td class="body"><script>printStyleList()</script></td>
					</tr>
				</table>
				</div>
			</div>
		</span>

		<div style="padding-top: 6px;">
				<input type="button" name="backgdButton" value="Backgd" class="Text75" onClick="javascript:setBackground(selectedImage)" disabled=true>
		
				<input type="button" name="deleteButton" value="Delete" class="Text75" onClick="javascript:deleteImage(selectedImageEncoded)" disabled>
				</div>

		</div>
		<div style="padding-top: 6px; float: right;">
		<input type="button" name="insertButton" value="Insert" class="Text75" onClick="javascript:insertImage(selectedImage)" disabled=true>
		<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
		</div>

		</table>

		<script defer>

		if (window.opener.imageEdit)
		{
			selectedImage = window.opener.selectedImage.src;
			previewModify();
		}

		</script>

<%
break;










/*
ToDo=MoreColors
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "MoreColors":
%>
<script type="text/javascript" src="../includes/de_colors.js"></script>
<script language=javascript>
var myPage = window.opener;

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				doColors()
			}
	};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

function doColors() {
	window.opener.doColor(myColor);
	self.close();
}

</script>

<style>
.outerSlideContainer	{width: 210; height: 14;  margin-top: 3px; margin-bottom: 0; border: 0px solid #FFFFFF; position:relative; }
.gradContainer			{width: 200; height: 14; position: absolute; z-index: 4; font-size: 1; overflow: hidden; margin-left: 4px;}
.sliderHandle			{width: 9; height: 12; cursor: hand; border: 0 outset white; overflow: hidden; z-index: 5;}
.lineContainer1			{width: 199; height: 6; z-index: 0; margin-left: 5px;}
.lineContainer2			{width: 66; height: 6; z-index: 0; }
.line1				{width: 199; height: 14; z-index: 0; overflow: hidden; filter: alpha(style=1)}
.line2				{width: 66; height: 14; z-index: 0; overflow: hidden; filter: alpha(style=1)}
#colorBox			{width: 20; height: 20; border: 1 inset window; margin-left: 2px;}
#colorImage			{width: 164; height: 20; border: 1px inset window; cursor: hand;}
body	{ margin: 10px;}
</style>

<title>Colors</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;" onload="init()">
<div class="appOutside">

<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Select your desired color and click 'OK' to use the selected color</span>
</div>
<br>
	 	  
<table border="0" cellspacing="0" cellpadding="0" style="width:93%">
  <tr> 
	<td class="body">

<span class="appInside1" style="width:235px; height:100%">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle"></span>

<span style="background-color: #000000; width:200px; height:200px; border: 0px solid #000000"><img id=colorImg galleryimg="no" src="../includes/images/popups/color.jpg" width=200 height=200 onClick="doColor(this)" style="filter:alpha(opacity=100);"><img id=cursorImg width=11 height=11 src="../includes/images/popups/cursor.gif" style="position:absolute;" onmousedown="drags()" galleryimg="no"></span>
<span class="outerSlideContainer">
	<div class="gradContainer" onclick="clickOnGrad(vSlider)"></div>
	<span class="lineContainer1" id="redLeft" style="background: RGB(255, 255, 255);">
		<div class="line1" id="redLeft2" style="background: RGB(0,0,0);"></div>
		<div id=win98 style="display:none"><img src="../includes/images/popups/win98_transition.jpg" width=199 height=14></div>
	</span>
	<div class="sliderHandle" id="vSlider" type="x" value="0" onchange="update(this)"><img src="../includes/images/popups/arrow.gif" width=9 height=12></div>
</span>
<input type=hidden id=hBox value="0">
<input type=hidden id=sBox value="0">
<input type=hidden id=lBox value="0">

</div>
</div>
</span>

</td>
	<td class=body align=right>
<span class="appInside1" style="width:100px; height:100%;">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px">
		<table cellspacing=0 cellpadding=5 border=0>
		<tr>
		<td class=body>Red:</td>
		<td><input type=text id=rBox onkeydown="checkInputRGB()" maxlength=3 onChange="doRGB()" class=Text50></td>
		</tr>
		<tr>
		<td class=body>Green:</td>
		<td><input type=text id=gBox onkeydown="checkInputRGB()" maxlength=3 onChange="doRGB()" class=Text50></td>
		<tr>
		<td class=body>Blue:</td>
		<td><input type=text id=bBox onkeydown="checkInputRGB()" maxlength=3 onChange="doRGB()" class=Text50></td>
		</tr>
		<tr>
		<td class=body>HEX:</td>
		<td class=body><input type=text id=hexBox onChange="HexToRGB(this.value)" onkeydown="checkInputHex()" maxlength=6 class=Text50></td>
		</tr>
		</table>
		<br>
		<div id=myColor><div id=colorBox style="width:100px; height:90px; border: 1px solid #000000"></div></div>
		</div>
	</div>
</span>

	</td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="doColors" value="OK" class="Text75" onClick="javascript:doColors();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

<%
break;

/*

ToDo=InsertTable
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de

*/

case "InsertTable":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

// Functions for color popup
var oPopup = window.createPopup();
function showColorMenu(menu, width, height) {

	lefter = event.clientX;
	leftoff = event.offsetX;
	topper = event.clientY;
	topoff = event.offsetY;

	var oPopBody = oPopup.document.body;
	moveMe = 0

	var HTMLContent = window.opener.eval(menu).innerHTML
	oPopBody.innerHTML = HTMLContent
	oPopup.show(lefter - leftoff - 2 - moveMe, topper - topoff + 22, width, height, document.body);

	return false;
}

function setValues() {
	imageForm.image_width.value = imageWidth;
	imageForm.image_height.value = imageHeight;

	if (imageBorder == "") {
		imageBorder = "0"
	}

	imageForm.border.value = imageBorder;
	imageForm.alt_tag.value = imageAltTag;
	imageForm.hspace.value = imageHspace;
	imageForm.vspace.value = imageVspace;
	// tableForm.cell_width.value = cellWidth;
	this.focus();
}

function button_over(td) {
	window.opener.button_over(td)
}

function button_out(td) {
	window.opener.button_out(td)
}

function doColor(td) {
	if (td)
		document.tableForm.bgcolor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
	else 
		document.tableForm.bgcolor.value = ''

	oPopup.hide()
}

function doMoreColors() {
	colorWin = window.open(window.opener.popupColorWin,'','width=420,height=370,scrollbars=no,resizable=no,titlebar=0,top=' + (screen.availHeight-400) / 2 + ',left=' + (screen.availWidth-420) / 2)
}
// End functions

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}


function InsertTable() {
	error = 0
	var sel = window.opener.foo.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			border = document.tableForm.border.value
			columns = document.tableForm.columns.value
			padding = document.tableForm.padding.value
			rows = document.tableForm.rows.value
			spacing = document.tableForm.spacing.value
			width = document.tableForm.width.value
			height = document.tableForm.height.value
			bgcolor = document.tableForm.bgcolor.value
			align = document.tableForm.align[tableForm.align.selectedIndex].text
			styles = document.tableForm.sStyles[tableForm.sStyles.selectedIndex].text

			if (isNaN(rows) || rows < 0 || rows == "") {
			 	alert("Rows must contain a valid, positive number")
				document.tableForm.rows.select()
				document.tableForm.rows.focus()
				error = 1
			} else if (isNaN(columns) || columns < 0 || columns == "") {
			 	alert("Columns must contain a valid, positive number")
				document.tableForm.columns.select()
				document.tableForm.columns.focus()
				error = 1
			} else if (width < 0 || width == "") {
			 	alert("Width must contain a valid, positive number")
				document.tableForm.width.select()
				document.tableForm.width.focus()
				error = 1
			} else if (isNaN(padding) || padding < 0 || padding == "") {
			 	alert("Cell Padding must contain a valid, positive number")
				document.tableForm.padding.select()
				document.tableForm.padding.focus()
				error = 1
			} else if (isNaN(spacing) || spacing < 0 || spacing == "") {
			 	alert("Cell Spacing must contain a valid, positive number")
				document.tableForm.spacing.select()
				document.tableForm.spacing.focus()
				error = 1
			} else if (isNaN(border) || border < 0 || border == "") {
			 	alert("Border must contain a valid, positive number")
				document.tableForm.border.select()
				document.tableForm.border.focus()
				error = 1
			}
			

        		if (error != 1) {
				if (bgcolor != "None") {
					bgcolor = " bgcolor =" + bgcolor
				} else {
					bgcolor = ""
				}
				
					if (height != "") {
						height = " height=" + height
					} else {
						height = ""
					}

					if (align != "") {
						align = " align=" + align
					} else {
						align = ""
					}

					if (styles != "") {
						styles = " class=" + styles
					} else {
						styles = ""
					}

        			HTMLTable = "<Table id=ewp_element_to_style width=" + width + height + align + styles + " border=" + border + " cellpadding=" + padding + " cellspacing=" + spacing + bgcolor + ">"
        
        			for (i=0; i<rows; i++) {
        				HTMLTable = HTMLTable + "<tr>"
        				for (j=0; j<columns; j++) {
        					HTMLTable = HTMLTable + "<td>&nbsp</td>"
        				}
        			
        				HTMLTable = HTMLTable + "</tr>"
        			}
        			
        			HTMLTable = HTMLTable + "</table>"
        			rng.pasteHTML(HTMLTable)
					oTable = window.opener.foo.document.getElementById("ewp_element_to_style")
					
					if (window.opener.borderShown == "yes") {
						oTable.runtimeStyle.border = "1px dotted #BFBFBF"
	
						allRows = oTable.rows
						for (y=0; y < allRows.length; y++) {
						 	allCellsInRow = allRows[y].cells
							for (x=0; x < allCellsInRow.length; x++) {
								allCellsInRow[x].runtimeStyle.border = "1px dotted #BFBFBF"
							}
						}
					}
					oTable.removeAttribute("id")

					}
        		}
	}
	
	if (error != 1) {
		// window.opener.foo.focus();
		self.close();
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertTable()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Table</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=tableForm>
<div class="appOutside">
 
<!-- <span class="appInside1" style="width:100%">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle">Insert Table</span>
-->
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a table into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
		<tr>
		  <td class="body">Rows:</td>
		  <td class="body"><input type="text" name="rows" size="2" class="text70" value="1" maxlength="2">
		  </td>
		  <td class="body">Cell Padding:</td>
		  <td class="body"><input type="text" name="padding" size="2" class="text70" value="2" maxlength="2">
		  </td>
		</tr>
		<tr>
		  <td class="body">Columns:</td>
		  <td class="body">
			<input type="text" name="columns" size="2" class="text70" value="1" maxlength="2">
		  </td>
		  <td class="body">Cell Spacing:</td>
		  <td class="body">
			<input type="text" name="spacing" size="2" class="text70" maxlength="2" value="2">
		  </td>
		</tr>
		<tr>
		  <td class="body">Width:</td>
		  <td class="body">
			<input type="text" name="width" size="2" class="text70" maxlength="4" value="100%">
		  </td>
		  <td class="body">Height:</td>
		  <td class="body">
			<input type="text" name="height" size="2" class="text70" maxlength="4" value="">
		  </td>
		</tr>
		<tr>
		  <td class="body">Background Color:</td>
		  <td class="body">
		  <input type="text" name="bgcolor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
		  </td>
		  <td class="body">Border:</td>
		  <td class="body"><input type="text" name="border" size="2" class="text70" maxlength="2" value="1"></td>
		</tr>
		<tr>
		  <td class="body">Alignment:</td>
		  <td class="body">
			<select name="align" class="text70">
				<option value=""></option>
				<option value="Left">Left</option>
				<option value="Center">Center</option>
				<option value="Right">Right</option>
			</select>
		  </td>
		  <td class="body">Style:</td>
		  <td class="body">
				<script>printStyleList()</script>
		  </td>
		</tr>
	  </table>

<!--	</div>
	</div>
</span>
-->

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertTable" value="OK" class="Text75" onClick="javascript:InsertTable();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>
</form>
<%
break;

/*
ToDo=ModifyTable
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "ModifyTable":
%>
<script language=javascript>
var myTable = window.opener;
window.opener.doStyles()
window.onload = setValues;

var tableBgColor = myTable.selectedTable.bgColor;
var tableSpacing = myTable.selectedTable.cellSpacing;
var tablePadding = myTable.selectedTable.cellPadding;
var tableBorder = myTable.selectedTable.border;
var tableWidth = myTable.selectedTable.width;
var tableHeight = myTable.selectedTable.height;
var tableAlign = myTable.selectedTable.align;

// Functions for color popup
var oPopup = window.createPopup();
function showColorMenu(menu, width, height) {

	lefter = event.clientX;
	leftoff = event.offsetX;
	topper = event.clientY;
	topoff = event.offsetY;

	var oPopBody = oPopup.document.body;
	moveMe = 0

	var HTMLContent = window.opener.eval(menu).innerHTML
	oPopBody.innerHTML = HTMLContent
	oPopup.show(lefter - leftoff - 2 - moveMe, topper - topoff + 22, width, height, document.body);

	return false;
}

function button_over(td) {
	window.opener.button_over(td)
}

function button_out(td) {
	window.opener.button_out(td)
}

function doColor(td) {
	if (td)
		document.tableForm.table_bgcolor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
	else 
		document.tableForm.table_bgcolor.value = ''

	oPopup.hide()
}

function doMoreColors() {
	colorWin = window.open(window.opener.popupColorWin,'','width=420,height=370,scrollbars=no,resizable=no,titlebar=0,top=' + (screen.availHeight-400) / 2 + ',left=' + (screen.availWidth-420) / 2)
}

// End functions

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
			if (document.getElementById("sStyles").options[0].text == "Style") {
				document.getElementById("sStyles").options[0] = null;
				document.getElementById("sStyles").options[0].text = "";
			} else {
				document.getElementById("sStyles").options[1].text = "";
			}

		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

function setValues() {

	if (tableSpacing == "") tableSpacing = 2;
	if (tablePadding == "") tablePadding = 1;
	if (tableBorder == "") tableBorder = 0;

	tableForm.table_bgcolor.value = tableBgColor;
	tableForm.table_padding.value = tablePadding;
	tableForm.table_spacing.value = tableSpacing;
	tableForm.table_border.value = tableBorder;
	tableForm.table_width.value = tableWidth;
	tableForm.table_height.value = tableHeight;
	this.focus();
}

function doModify() {

	var error = 0;
	if (isNaN(tableForm.table_padding.value) || tableForm.table_padding.value < 0 || tableForm.table_padding.value == "") {
		alert("Cell Padding must contain a valid, positive number")
		error = 1
		tableForm.table_padding.select()
		tableForm.table_padding.focus()
	} else if (isNaN(tableForm.table_spacing.value) || tableForm.table_spacing.value < 0 || tableForm.table_spacing.value == "") {
		alert("Cell Spacing must contain a valid, positive number")
		error = 1
		tableForm.table_spacing.select()
		tableForm.table_spacing.focus()
	} else if (isNaN(tableForm.table_border.value) || tableForm.table_border.value < 0 || tableForm.table_border.value == "") {
		alert("Border must contain a valid, positive number")
		error = 1
		tableForm.table_border.select()
		tableForm.table_border.focus()
	}

	if (error != 1) {
        	myTable.selectedTable.cellPadding = tableForm.table_padding.value
        	myTable.selectedTable.cellSpacing = tableForm.table_spacing.value
        	myTable.selectedTable.border = tableForm.table_border.value
			myTable.selectedTable.width = tableForm.table_width.value
			myTable.selectedTable.height = tableForm.table_height.value

        	if (tableForm.table_bgcolor.value != "") {
        		myTable.selectedTable.bgColor = tableForm.table_bgcolor.value
        	} else {
        		myTable.selectedTable.removeAttribute('bgColor',0)
        	}

			styles = document.tableForm.sStyles[tableForm.sStyles.selectedIndex].text

			if (styles != "") {
				myTable.selectedTable.className = styles
			} else {
				myTable.selectedTable.removeAttribute('className',0)
			}
        
			if (tableForm.table_align[tableForm.table_align.selectedIndex].text != "None") {
       			myTable.selectedTable.align = tableForm.table_align[tableForm.table_align.selectedIndex].text
			} else {
       			myTable.selectedTable.removeAttribute('align',0)
			}

        	window.close()
	}
}

function printAlign() {
	if ((tableAlign != undefined) && (tableAlign != "")) {
		document.write('<option selected>' + tableAlign)
		document.write('<option>')
	} else {
		document.write('<option selected>')
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				doModify()					
			}
	};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
		event.cancelBubble = true;
		event.returnValue = false;
		return false;
	}
};

</script>
<title>Modify Table Properties</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=tableForm>
<div class="appOutside">

<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to modify the properties of your table.</span>
</div>
<br>
	 	  
	<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
	  <tr>
		<td class="body" width="90">Background Color:</td>
		<td class="body">
		  <input type="text" name="table_bgcolor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
		  </td>
		<td class="body" width="80">Cell Padding:</td>
		<td class="body">
		  <input type="text" name="table_padding" size="2" class="text70" maxlength="2">
	  </td>
	  </tr>
	  <tr>
		<td class="body" width="80">Border:</td>
		<td class="body">
		  <input type="text" name="table_border" size="2" class="text70" value="1" maxlength="2">
	  </td>
		<td class="body" width="80">Cell Spacing:</td>
		<td class="body">
		  <input type="text" name="table_spacing" size="2" class="text70" value="2" maxlength="2">
	  </td>
	  </tr>
	  <tr>
		<td class="body" width="80">Width:</td>
		<td class="body">
		  <input type="text" name="table_width" size="3" class="text70" value="" maxlength="4">
		</td>
		<td class="body" width="80">Height:</td>
		<td class="body">
		  <input type="text" name="table_height" size="3" class="text70" value="" maxlength="4">
		</td>
	  </tr>
	  <tr>
		  <td class="body">Alignment:</td>
		  <td class="body">
			<select name="table_align" class="text70">
				<script>printAlign()</script>
				<option value="Left">Left</option>
				<option value="Center">Center</option>
				<option value="Right">Right</option>
			</select>
		  </td>
		  <td class="body">Style:</td>
		  <td class="body">
				<script>printStyleList()</script>
		  </td>
		</tr>
	</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="modifyTable" value="OK" class="Text75" onClick="javascript:doModify();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>
</form>

<%
break;

/*
ToDo=ModifyCell
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "ModifyCell":
%>
<script language=javascript>
var myTable = window.opener;
window.opener.doStyles()
window.onload = setValues;

var cellBgColor = myTable.selectedTD.bgColor;
var cellWidth = myTable.selectedTD.width;
var cellHeight = myTable.selectedTD.height;
var cellAlign = myTable.selectedTD.align;
var cellvAlign = myTable.selectedTD.vAlign;
var tablePadding = myTable.selectedTable.cellPadding;

// Functions for color popup
var oPopup = window.createPopup();
function showColorMenu(menu, width, height) {

	lefter = event.clientX;
	leftoff = event.offsetX;
	topper = event.clientY;
	topoff = event.offsetY;

	var oPopBody = oPopup.document.body;
	moveMe = 0

	var HTMLContent = window.opener.eval(menu).innerHTML
	oPopBody.innerHTML = HTMLContent
	oPopup.show(lefter - leftoff - 2 - moveMe, topper - topoff + 22, width, height, document.body);

	return false;
}

function button_over(td) {
	window.opener.button_over(td)
}

function button_out(td) {
	window.opener.button_out(td)
}

function doColor(td) {
	if (td)
		document.tableForm.table_bgcolor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
	else 
		document.tableForm.table_bgcolor.value = ''

	oPopup.hide()
}

function doMoreColors() {
	colorWin = window.open(window.opener.popupColorWin,'','width=420,height=370,scrollbars=no,resizable=no,titlebar=0,top=' + (screen.availHeight-400) / 2 + ',left=' + (screen.availWidth-420) / 2)
}

// End functions

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
			if (document.getElementById("sStyles").options[0].text == "Style") {
				document.getElementById("sStyles").options[0] = null;
				document.getElementById("sStyles").options[0].text = "";
			} else {
				document.getElementById("sStyles").options[1].text = "";
			}

		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

function setValues() {

	tableForm.table_bgcolor.value = cellBgColor;
	tableForm.cell_width.value = cellWidth;
	tableForm.cell_height.value = cellHeight;	
	this.focus();
}

function doModify() {

	var error = 0;
	if (tableForm.cell_width.value < 0) {
		alert("Cell width must contain a valid, positive number")
		error = 1
		tableForm.cell_width.select()
		tableForm.cell_width.focus()
	}


	if (tableForm.cell_height.value < 0) {
		alert("Cell height must contain a valid, positive number")
		error = 1
		tableForm.cell_height.select()
		tableForm.cell_height.focus()
	}

	if (error != 1) {
        	myTable.selectedTD.width = tableForm.cell_width.value
        	myTable.selectedTD.height = tableForm.cell_height.value

			if (tableForm.table_bgcolor.value != "") {
        		myTable.selectedTD.bgColor = tableForm.table_bgcolor.value
        	} else {
        		myTable.selectedTD.removeAttribute('bgColor',0)
        	}

			styles = document.tableForm.sStyles[tableForm.sStyles.selectedIndex].text

			if (styles != "") {
				myTable.selectedTD.className = styles
			} else {
				myTable.selectedTD.removeAttribute('className',0)
			}

			if (tableForm.align[tableForm.align.selectedIndex].text != "None") {
        		myTable.selectedTD.align = tableForm.align[tableForm.align.selectedIndex].text
        	} else {
        		myTable.selectedTD.removeAttribute('align',0)
        	}

			if (tableForm.valign[tableForm.valign.selectedIndex].text != "None") {
        		myTable.selectedTD.vAlign = tableForm.valign[tableForm.valign.selectedIndex].text
        	} else {
        		myTable.selectedTD.removeAttribute('vAlign',0)
        	}
			
			window.opener.doToolbar()
        	window.close()
	}
}

function printAlign() {
	if ((cellAlign != undefined) && (cellAlign != "")) {
		document.write('<option selected>' + cellAlign)
		document.write('<option>None')
	} else {
		document.write('<option selected>None')
	}
}

function printvAlign() {
	if ((cellvAlign != undefined) && (cellvAlign != "")) {
		document.write('<option selected>' + cellvAlign)
		document.write('<option>None')
	} else {
		document.write('<option selected>None')
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				doModify()
			}
	};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Modify Cell Properties</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=tableForm>
<div class="appOutside">

<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to modify the properties of your table cell.</span>
</div>
<br>
	 	  
<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr> 
	<td class="body" width="90">Background Color:</td>
		<td class="body">
		  <input type="text" name="table_bgcolor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
		  </td>
	<td class="body" width="80">Cell Width:</td>
	<td class="body"> 
	  <input type="text" name="cell_width" size="3" class="Text70" maxlength="3">
	</td>
  </tr>
  <tr> 
	<td class="body" width="80">Horizontal Align:</td>
	<td class="body"> 
	  <SELECT class=text70 name=align>
		<script>printAlign()</script>
		<option>Left 
		<option>Center 
		<option>Right</option>
	  </select>
	</td>
	<td class="body" width="80">Cell Height:</td>
	<td class="body"> 
	  <input type="text" name="cell_height" size="3" class="Text70" maxlength="3">
	</td>
  </tr>
  <tr> 
	<td class="body" width="80">Vertical Align:</td>
	<td class="body"> 
	  <select class=text70 name=valign>
		<script>printvAlign()</script>
		<option>Top 
		<option>Middle 
		<option>Bottom</option>
	  </select>
	</td>
	<td class="body">Style:</td>
	<td class="body"><script>printStyleList()</script>
	</td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="modifyCell" value="OK" class="Text75" onClick="javascript:doModify();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=InsertForm&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertForm":
%>
<script language=JavaScript>
window.onload = this.focus

function InsertForm() {
	error = 0
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.formForm.form_name.value
			action = document.formForm.form_action.value
			method = document.formForm.form_method[formForm.form_method.selectedIndex].text

        		if (error != 1) {

				if (method != "None") {
					method = ' method="' + method + '"'
				} else {
					method = ""
				}

				if (name != "") {
					name = ' name="' + name + '"'
				} else {
					name = ""
				}

				if (action != "") {
					action = ' action="' + action + '"'
				} else {
					action = ""
				}

        			HTMLForm = "<form id=ewp_element_to_style" + name + action + method +">&nbsp;</form>"
         			rng.pasteHTML(HTMLForm)

					oForm = window.opener.foo.document.getElementById("ewp_element_to_style")
					
					if (window.opener.borderShown == "yes") {
						oForm.runtimeStyle.border = "1px dotted #FF0000"
					}

					oForm.removeAttribute("id")


        		}
		}
	
	}
	
	if (error != 1) {
		// window.opener.foo.focus();
		self.close();
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertForm()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Form</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=formForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a form into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body">
	  <input type="text" name="form_name" size="10" class="Text70" maxlength="50">
  </td>
  </tr>
  <tr>
	<td class="body" width="80">Action:</td>
	<td class="body">
	  <input type="text" name="form_action" size="50" class="Text250">
  </td>
  </tr>
  <tr>
	<td class="body" width="80">Method:</td>
	<td class="body">
	  <select class=text70 name=form_method>
		<option selected>None
		<option>Post
		<option>Get</option>
		</select>
	</td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertForm" value="OK" class="Text75" onClick="javascript:InsertForm();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=ModifyForm&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "ModifyForm":
%>
<script language=javascript>
var myPage = window.opener;
window.onload = setValues;

var formName = myPage.selectedForm.name;
var formAction = myPage.selectedForm.action;
var formMethod = myPage.selectedForm.method;

function setValues() {

	formForm.form_name.value = formName;
	formForm.form_action.value = formAction;
	this.focus();
}

function doModify() {

	if (formForm.form_name.value != "") {
		myPage.selectedForm.name = formForm.form_name.value
	} else {
		myPage.selectedForm.removeAttribute('name',0)
	}

	if (formForm.form_action.value != "") {
		myPage.selectedForm.action = formForm.form_action.value
	} else {
		myPage.selectedForm.removeAttribute('action',0)
	}

	if (formForm.method[formForm.method.selectedIndex].text != "None") {
    	myPage.selectedForm.method = formForm.method[formForm.method.selectedIndex].text
    } else {
		myPage.selectedForm.removeAttribute('method',0)
    }
        
    window.close()
}

function printMethod() {
	if ((formMethod != undefined) && (formMethod != "")) {
		document.write('<option selected>' + formMethod)
		document.write('<option>None')
	} else {
		document.write('<option selected>None')
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				doModify()
			}
	};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Modify Form Properties</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=formForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to modify the properties of your form.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body">
	  <input type="text" name="form_name" size="10" class="Text70" maxlength="50">
  </td>
  </tr>
  <tr>
	<td class="body" width="80">Action:</td>
	<td class="body">
	  <input type="text" name="form_action" size="50" class="Text250">
  </td>
  </tr>
  <tr>
	<td class="body" width="80">Method:</td>
	<td class="body">
	  <SELECT class=text70 name=method>
		<script>printMethod()</script>
		<option>Post
		<option>Get</option>
	  </select>
  </td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="modifyForm" value="OK" class="Text75" onClick="javascript:doModify();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>

<%
break;

/*
ToDo=InsertTextField&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertTextField":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

var error
function InsertTextField() {
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.textForm.text_name.value
			width = document.textForm.text_width.value
			max = document.textForm.text_max.value
			value = document.textForm.text_value.value
			type = document.textForm.text_type[textForm.text_type.selectedIndex].text
			styles = document.textForm.sStyles[textForm.sStyles.selectedIndex].text

		error = 0
		if (isNaN(width) || width < 0) {
				alert("Character width must contain a valid, positive number")
				error = 1
				textForm.text_width.select()
				textForm.text_width.focus()
		} else if (isNaN(max) || max < 0) {
				alert("Maximum characters must contain a valid, positive number")
				error = 1
				textForm.text_max.select()
				textForm.text_max.focus()
		}

		if (error != 1) {
				if (value != "") {
					value = ' value="' + value + '"'
				} else {
					value = ""
				}

				if (name != "") {
					name = ' name="' + name + '"'
				} else {
					name = ""
				}

				if (width != "") {
					width = ' size="' + width + '"'
				} else {
					width = ""
				}

				if (max != "") {
					max = ' maxlength="' + max + '"'
				} else {
					max = ""
				}

				if (styles != "") {
					styles = " class=" + styles
				} else {
					styles = ""
				}

        			HTMLTextField = '<input type="' + type + '"' + name + styles + value + width + max + '>'
					// window.opener.foo.focus();
         			rng.pasteHTML(HTMLTextField)
		} // End if
		} // End if
	} // End If

	if (error != 1) {
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertTextField()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Text Field</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=textForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a text field into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body" width="200">
	  <input type="text" name="text_name" size="10" class="Text70" maxlength="50">
  </td>
	<td class="body" width="80">Initial Value:</td>
	<td class="body">
	  <input type="text" name="text_value" size="10" class="Text70">
	</td>
  </tr>
  <tr>
	<td class="body" width="80">Character Width:</td>
	<td class="body">
	  <input type="text" name="text_width" size="3" class="Text70" maxlength="3">
	</td>
	<td class="body" width="80">Maximum Characters:</td>
	<td class="body">
	  <input type="text" name="text_max" size="3" class="Text70" maxlength="3">
	</td>
  </tr>
  <tr>
	<td class="body" width="80">Type:</td>
	<td class="body">
	  <select name="text_type" class=text70>
	  <option selected>Text
	  <option>Password</option>
	  </select>
	</td>
	<td class="body">Style:</td>
	<td class="body"><script>printStyleList()</script></td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertTextField" value="OK" class="Text75" onClick="javascript:InsertTextField();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>
</form>
<%
break;

/*
ToDo=InsertTextArea&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertTextArea":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

var error
function InsertTextArea() {
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.textForm.text_name.value
			rows = document.textForm.text_lines.value
			cols = document.textForm.text_width.value
			value = document.textForm.text_value.value
			styles = document.textForm.sStyles[textForm.sStyles.selectedIndex].text

		error = 0
		if (isNaN(cols) || cols < 0) {
				alert("Character width must contain a valid, positive number")
				error = 1
				textForm.text_width.select()
				textForm.text_width.focus()
		} else if (isNaN(rows) || rows < 0) {
				alert("Lines must contain a valid, positive number")
				error = 1
				textForm.text_lines.select()
				textForm.text_lines.focus()
		}

		if (error != 1) {
				if (value != "") {
					value = value
				} else {
					value = ""
				}

				if (name != "") {
					name = ' name="' + name + '"'
				} else {
					name = ""
				}

				if (cols != "") {
					cols = ' cols="' + cols + '"'
				} else {
					cols = ""
				}

				if (rows != "") {
					rows = ' rows="' + rows + '"'
				} else {
					rows = ""
				}

				if (styles != "") {
					styles = " class=" + styles
				} else {
					styles = ""
				}

        			HTMLTextField = '<textarea' + name + cols + rows + styles + '>' + value + '</textarea>'
					// window.opener.foo.focus();
         			rng.pasteHTML(HTMLTextField)
		} // End if
		} // End if
	} // End If

	if (error != 1) {
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertTextArea()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Text Area</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=textForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a text area into your webpage.</span>
</div>
<br>
	  
<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="85">Name:</td>
	<td class="body" width="160">
	  <input type="text" name="text_name" size="10" class="Text70" maxlength="50">
  </td>
	<td class="body" width="85">Initial Value:</td>
	<td class="body">
	  <input type="text" name="text_value" size="10" class="Text70">
	</td>
  </tr>
  <tr>
	<td class="body">Character Width:</td>
	<td class="body">
	  <input type="text" name="text_width" size="3" class="Text70" maxlength="3">
	</td>
	<td class="body">Lines:</td>
	<td class="body">
	  <input type="text" name="text_lines" size="3" class="Text70" maxlength="3">
	</td>
  </tr> 
	<tr>
		<td class="body">Style:</td>
		<td class="body"><script>printStyleList()</script></td>
		<td class=body>&nbsp;</td>
		<td class=body>&nbsp;</td>
	</tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertTextField" value="OK" class="Text75" onClick="javascript:InsertTextArea();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=InsertHidden&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertHidden":
%>
<script language=JavaScript>
window.onload = this.focus
var error
function InsertHiddenField() {
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.hiddenForm.hidden_name.value
			value = document.hiddenForm.hidden_value.value

		error = 0

		if (error != 1) {
				if (value != "None") {
					value = ' value="' + value + '"'
				} else {
					value = ""
				}

				if (name != "") {
					name = ' name="' + name + '"'
				} else {
					name = ""
				}

        		HTMLTextField = '<input id=ewp_element_to_style type=hidden' + name + value + '>'
         		rng.pasteHTML(HTMLTextField)

				oHidden = window.opener.foo.document.getElementById("ewp_element_to_style")
					
				if (window.opener.borderShown == "yes") {
					oHidden.runtimeStyle.border = "0px"
					oHidden.runtimeStyle.width = "20px"
					oHidden.runtimeStyle.height = "20px"
					oHidden.runtimeStyle.backgroundImage = "url(/devedit/demo/de/../includes/images/hidden.gif)"
					oHidden.runtimeStyle.fontSize = "99px"
				}

				oHidden.removeAttribute("id")


		} // End if
		} // End if
	} // End If

	if (error != 1) {
		// window.opener.foo.focus();
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertHiddenField()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Hidden Field</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=hiddenForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a hidden field into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body" width="200">
	  <input type="text" name="hidden_name" size="10" class="Text150" maxlength="50">
  </td>
  </tr>
  <tr>
	<td class="body" width="80">Initial Value:</td>
	<td class="body">
	  <input type="text" name="hidden_value" size="10" class="Text150">
	</td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertHiddenField" value="OK" class="Text75" onClick="javascript:InsertHiddenField();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=InsertButton&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertButton":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

function InsertButton() {
	error = 0
	var sel = window.opener.foo.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {

			name = document.buttonForm.button_name.value
			value = document.buttonForm.button_value.value
			type = document.buttonForm.button_type[buttonForm.button_type.selectedIndex].text
			styles = document.buttonForm.sStyles[buttonForm.sStyles.selectedIndex].text

			if (value != "") {
				value = ' value="' + value + '"'
			} else {
				value = ""
			}

			if (name != "") {
				name = ' name="' + name + '"'
			} else {
				name = ""
			}

			if (styles != "") {
				styles = " class=" + styles
			} else {
				styles = ""
			}

			HTMLTextField = '<input type="' + type + '"' + name + value + styles + '>'
			rng.pasteHTML(HTMLTextField)
		} // End if
	} // End If

	if (error != 1) {
		// window.opener.foo.focus();
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertButton()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Button</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=buttonForm>
<div class="appOutside">

<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a Button into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body" width="200">
	  <input type="text" name="button_name" size="10" class="Text70" maxlength="50">
  </td>
	<td class="body" width="90">Initial Value:</td>
	<td class="body">
	  <input type="text" name="button_value" size="10" class="Text70">
	</td>
  </tr>
  <tr>
	<td class="body" width="80">Type:</td>
	<td class="body">
	  <select name="button_type" class=text70>
		<option selected>Submit
		<option>Reset
		<option>Button</option>
	  </select>
	</td>
	<td class="body">Style:</td>
	<td class="body"><script>printStyleList()</script></td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertButton" value="OK" class="Text75" onClick="javascript:InsertButton();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
*/

case "":
%>


<%
break;

/*
ToDo=InsertCheckbox&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertCheckbox":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

var error
function InsertCheckbox() {
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.checkboxForm.checkbox_name.value
			value = document.checkboxForm.checkbox_value.value
			checked = document.checkboxForm.checkbox_type[checkboxForm.checkbox_type.selectedIndex].text
			styles = document.checkboxForm.sStyles[checkboxForm.sStyles.selectedIndex].text

		if (value != "") {
			value = ' value="' + value + '"'
		} else {
			value = ""
		}

		if (name != "") {
			name = ' name="' + name + '"'
		} else {
			name = ""
		}

		if (checked == "Unchecked"){
			checked = ""
		}

		if (styles != "") {
			styles = " class=" + styles
		} else {
			styles = ""
		}

		HTMLTextField = '<input type=checkbox ' + checked + name + value + styles + '>'
		// window.opener.foo.focus();
		rng.pasteHTML(HTMLTextField)
		
		} // End if
	} // End If

	if (error != 1) {
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertCheckbox()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert CheckBox</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=checkboxForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a checkBox into your webpage.</span>
</div>
<br>
	  
<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
	  <tr>
		<td class="body" width="90">Name:</td>
		<td class="body" width="190">
		  <input type="text" name="checkbox_name" size="10" class="Text70" maxlength="50">
	  </td>
		<td class="body" width="90">Initial Value:</td>
		<td class="body">
		  <input type="text" name="checkbox_value" size="10" class="Text70">
		</td>
	  </tr>
	  <tr>
		<td class="body">Initial State:</td>
		<td class="body">
		  <select name="checkbox_type" class=text70>
			<option>Checked</option>
			<option selected>Unchecked</option>
		  </select>
		</td>
		<td class="body">Style:</td>
		<td class="body"><script>printStyleList()</script></td>
	  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertCheckbox" value="OK" class="Text75" onClick="javascript:InsertCheckbox();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>
</form>
<%
break;

/*
ToDo=InsertRadio&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

var error
function InsertRadio() {
	var sel = window.opener.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {
			name = document.radioForm.radio_name.value
			value = document.radioForm.radio_value.value
			checked = document.radioForm.radio_type[radioForm.radio_type.selectedIndex].text
			styles = document.radioForm.sStyles[radioForm.sStyles.selectedIndex].text

		if (value != "") {
			value = ' value="' + value + '"'
		} else {
			value = ""
		}

		if (name != "") {
			name = ' name="' + name + '"'
		} else {
			name = ""
		}

		if (checked == "Unchecked"){
			checked = ""
		}

		if (styles != "") {
			styles = " class=" + styles
		} else {
			styles = ""
		}

		HTMLTextField = '<input type=radio ' + checked + name + value + styles + '>'
		// window.opener.foo.focus();
		rng.pasteHTML(HTMLTextField)
		
		} // End if
	} // End If

	if (error != 1) {
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertRadio()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Radio Button</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=radioForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a radio button  into your webpage.</span>
</div>
<br>
	  
<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="80">Name:</td>
	<td class="body" width="190">
	  <input type="text" name="radio_name" size="10" class="Text70" maxlength="50">
  </td>
	<td class="body" width="90">Initial Value:</td>
	<td class="body">
	  <input type="text" name="radio_value" size="10" class="Text70">
	</td>
  </tr>
  
  <tr>
	<td class="body" width="90">Initial State:</td>
	<td class="body">
	  <select name="radio_type" class=text70>
		<option>Checked</option>
		<option selected>Unchecked</option>
	  </select>
	</td>
	<td class="body">Style:</td>
	<td class="body"><script>printStyleList()</script></td>
  </tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertRadio" value="OK" class="Text75" onClick="javascript:InsertRadio();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=InsertSelect&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertSelect":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text70";
		document.getElementById("sStyles").options[0] = null;
		document.getElementById("sStyles").options[0].text = "";
		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

var error
function InsertSelectBox() 
	{
	
	var error = 0
	var sel = window.opener.document.selection;
	if (sel!=null) 
		{
		var rng = sel.createRange();
	   	if (rng!=null) 
			{
			name = document.textForm.selectbox_name.value
			tmpOptions = "";
			for (i=0; i < optionArray.length; ++i)
				{
				optionArray[i][2] == true ? itemSelected = " selected" : itemSelected = ""
				tmpOptions = tmpOptions + "<option value=\"" + optionArray[i][1] + "\"" + itemSelected + ">" + optionArray[i][0] + "</option>";
				}
			//alert(tmpOptions);
			styles = document.textForm.sStyles[textForm.sStyles.selectedIndex].text
			multiple = document.textForm.selectType.selectedIndex;
			size = document.textForm.selectSize.value;
			if (isNaN(size)) {
				error = 1
				document.textForm.selectSize.focus()
				document.textForm.selectSize.select()
				alert("Size must contain a valid, positive number")
			}
	
			if (error != 1) 
				{
				name != "" ? name = ' name="' + name + '"' : name = ""
				multiple == 1 ? multiple = " multiple " : multiple = ""
				styles != "" ? styles = " class=" + styles : styles = ""
				size != 0 ? size = "size=" + size : size = ""
				if (multiple != 1)
					size = ""
				HTMLSelectBox = "<select" + name + styles + multiple + size + ">" + tmpOptions + "</select>"	
				// window.opener.foo.focus();
				//myPage.selectedSelectBox.outerHTML = HTMLSelectBox
       			rng.pasteHTML(HTMLSelectBox)
			} // End if
		} // End if
	} // End If

	if (error != 1) {
		self.close();
	}
} // End function

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertSelectBox()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Select</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=textForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert a select field into your webpage.</span>
</div>
<br>
	  
<script>
	optionArray = new Array();
	
	function addOption(textObj,valueObj,selectObj)
		{
		if (textObj.value.replace(/[ ]/g,"") != "")
			{selectObj.options[selectObj.length] = new Option(textObj.value,valueObj.value);}
		}
	
	function editOption(optionObj,formObj)
		{
		formObj.optionText.value = optionObj[optionObj.selectedIndex].text;
		formObj.optionValue.value = optionObj[optionObj.selectedIndex].value;
		optionTag = optionObj[optionObj.selectedIndex].outerHTML.replace(optionObj[optionObj.selectedIndex].text,"");
		formObj.optionSelected.checked = optionArray[optionObj.selectedIndex][2];
		//alert(optionObj[optionObj.selectedIndex].outerHTML);
		formObj.formUpdate.disabled = false;
		formObj.removeOption.disabled = false;
		}
		
	function updateOption(textTextObj,textValueObj,selectObj)
		{
		selectObj.options[selectObj.selectedIndex].text = textTextObj.value;
		selectObj.options[selectObj.selectedIndex].value = textValueObj.value;
		selectObj.options[selectObj.options.length] = new Option();
		selectObj.options[selectObj.options.length - 1].selected = true;
		selectObj.options[selectObj.options.length - 1] = null;
		selectObj.form.removeOption.disabled = true;
		}
	
	function deleteOption(selectObj, formObj)
		{
		selectObj.options[selectObj.selectedIndex] = null;
		clearForm(formObj);
		}
		
	
	function doOption(formObj, currentAction)
		{
		if (currentAction.indexOf("add") == 0)
			{
			addOption(formObj.optionText, formObj.optionValue,formObj.tmpSelect);
			optionArray[optionArray.length] = new Array(formObj.optionText.value, formObj.optionValue.value, formObj.optionSelected.checked);
			formObj.optionText.focus();
			clearForm(formObj);
			}
		else if (currentAction.indexOf("update") == 0)
			{
			thisItem = formObj.tmpSelect.selectedIndex;
			updateOption(formObj.optionText, formObj.optionValue,formObj.tmpSelect);
			optionArray[thisItem] = new Array(formObj.optionText.value, formObj.optionValue.value, formObj.optionSelected.checked);
			clearForm(formObj);
			}
		else if (currentAction.indexOf("remove") == 0)
			{
			optionArray.splice(formObj.tmpSelect.selectedIndex,1)
			deleteOption(formObj.tmpSelect);
			clearForm(formObj);
			}
		else
			{}	
		}

	function doSize(selectObj, formObj) {
		if (selectObj.selectedIndex == 1)
			formObj.selectSize.disabled = false
		else
			formObj.selectSize.disabled = true
	}
	
	function clearForm(formObj)
		{
		formObj.optionText.value = "";
		formObj.optionValue.value = "";
		// formObj.formAction.value = "Add Option";
		formObj.optionSelected.checked = false;
		formObj.tmpSelect.selectedIndex = -1;
		formObj.formUpdate.disabled = true;
		formObj.removeOption.disabled = true;
		}
</script>	  

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="85">Name:</td>
	<td class="body" width="160"><input type="text" name="selectbox_name" size="20" class="Text150" maxlength="50"></td>
	<td>&nbsp;</td>
	<td class="body" width="85" colspan="2">Maintain Options:</td>
  </tr>
  <tr><!--- Current Options --->
	<td class="body" valign="top">Current Options:</td>
	<td class="body"><select style="width:150px" name="tmpSelect" size="5" onchange="editOption(this, this.form);" class=text150></select></td>
	<!--- Add / Mod Options --->
	<td>&nbsp;</td>
	<td class="body" valign="top" colspan="2" valign="top" rowspan=2>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td class="body" nowrap>Text:</td>
				<td><input type="text" name="optionText" size="15" class="Text70"></td>
			</tr>
			<tr>
				<td class="body" nowrap>Value:</td>
				<td><input type="text" name="optionValue" size="15" class="Text70"></td>
			</tr>
			<tr>
				<td class="body" nowrap>Selected:</td>
				<td><input type="Checkbox" name="optionSelected"></td>
			</tr>
			<tr>
				<td colspan=2>&nbsp;</td>
			</tr>
			<tr>
				<td align="right"><input name="formAction" type="Button" value="Add" onclick="doOption(this.form, 'add');" class=text75>&nbsp;&nbsp;</td>
				<td><input name="formUpdate" type="Button" value="Update" onclick="doOption(this.form,'update');" class=text75 disabled>&nbsp;&nbsp;<input name="removeOption" type="Button" onclick="deleteOption(this.form.tmpSelect, this.form);" value="Delete" class=text75 disabled></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td class="body">Type:</td>
	<td><select class="Text150" name="selectType" onchange="doSize(this, this.form);"><option value="">Single Select</option><option value="multiple">Multiple Select</option></select></td>
	<td>&nbsp;</td>
  </tr>
  <tr>
  	<td class="body">Size:</td>
	<td><input type="Text" class="text150" name="selectSize" disabled value=0></td>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
  	<td class="body">Style:</td>
	<td><script>printStyleList()</script></td>
	<td>&nbsp;</td>
	<td colspan="2">&nbsp;</td>
  </tr>
</table>


</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertSelectbox" value="OK" class="Text75" onClick="javascript:InsertSelectBox();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=InsertFlash
&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
&flashDir=/devedit/demo/testflash
&wi=0&tn=0&du=0&dd=0&dt=1
*/

case "InsertFlash":
%>

<title>Insert Flash</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">

<script defer>
if (window.opener.flashEdit) {
	selectedFlash = window.opener.selectedFlash
	previewModify()

}
</script>

<script language=JavaScript>
window.onload = this.focus

var selectedFlash
var selectedFlashFile
var flashAlign
var flashLoop

var flashFiles = Array('.','..')
if (window.opener.flashEdit) {
	flashAlign = window.opener.selectedFlash.align
	flashLoop = window.opener.selectedFlash.loop
}

function outputFlashLibraryOptions()
{
	document.write(opener.flashLibs);

	// Loop through all of the image libraries and find the selected one
	for(i = 0; i < selFlashLib.options.length; i++)
	{
		if(selFlashLib.options[i].value == "/devedit/demo/testflash")
		{
			selFlashLib.selectedIndex = i;
			break;
		}
	}
}

function switchFlashLibrary(thePath)
{
	// Change the path of the flash library
	document.location.href = 'http://www.interspire.com/devedit/demo/de/class.devedit.php?ToDo=InsertFlash&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de&DEP1=/devedit/demo/de&flashDir='+thePath+'&dd=0&du=0&wi=0&tn=0&dt=1&wi=0';
}

function printAlign() {
	if ((flashAlign != undefined) && (flashAlign != "")) {
		document.write('<option selected>' + flashAlign)
		document.write('<option>')
	} else {
		document.write('<option selected>')
	}
}

function printLoop() {
	if (flashLoop != undefined) {
		document.write('<option value="' + flashLoop + '" selected>' + flashLoop + '</option>')
		document.write('<option value=""></option>')
	}
}

var selectedFlashEmbed
function previewModify() {

	objectTag = /(<(object|\/object)([\s\S]*?)>)/gi
	paramTag = /(<param([\s\S]*?)>)/gi

	code = selectedFlash.outerHTML.replace(objectTag,"")
	code = code.replace(paramTag,"")
	tempFrame.document.write("<html><head></head><body>" + code + "</body></html>")
	tempFrame.document.close()
	selectedFlashEmbed = tempFrame.document.embeds[0]
	selectedFlashFile = selectedFlash.movie

	document.getElementById("previewWindow").innerHTML = "<embed src='" + selectedFlash.movie + "' quality='high' pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='236' height='176' bgcolor='#009933' WMODE=transparent></embed>"

	image_width.value = selectedFlash.width
	image_height.value = selectedFlash.height
	hspace.value = selectedFlash.hspace
	vspace.value = selectedFlash.vspace

	insertButton.value = "Modify"
	document.title = "Modify Flash Properties"
	previewButton.disabled = false
	insertButton.disabled = false

}

function deleteFlash(flashSrc)
{
	var delImg = confirm("Are you sure you wish to delete this file?");

	if (delImg == true) {
		document.location.href = 'http://www.interspire.com/devedit/demo/de/class.devedit.php?ToDo=DeleteFlash&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de&DEP1=/devedit/demo/de&flashDir=/devedit/demo/testflash&tn=0&dt=1&wi=0&du=0&dd=0&flashSrc='+flashSrc;
	}

}

function viewImage(flashSrc)
{
	var sWidth =  screen.availWidth;
	var sHeight = screen.availHeight;
	
	window.open(flashSrc, 'image', 'width=500, height=500,scrollbars=yes,resizable=yes,left='+(sWidth/2-250)+',top='+(sHeight/2-250));
}

function grey(tr) {
		tr.className = 'b4';
}

function ungrey(tr) {
		tr.className = '';
}

function insertImage(flashSrc) {

	var error = 0;

		imageWidth = image_width.value
		imageHeight = image_height.value
		imageHspace = hspace.value
		imageVspace = vspace.value

		if (isNaN(imageWidth) || imageWidth < 0) {
			alert("Flash width must contain a valid, positive number")
			error = 1
			image_width.select()
			image_width.focus()
		} else if (isNaN(imageHeight) || imageHeight < 0) {
			alert("Flash height must contain a valid, positive number")
			error = 1
			image_height.select()
			image_height.focus()
		} else if (isNaN(imageHspace) || imageHspace < 0) {
			alert("Horizontal spacing must contain a valid, positive number")
			error = 1
			hspace.select()
			hspace.focus()
		} else if (isNaN(vspace.value) || vspace.value < 0) {
			alert("Vertical spacing must contain a valid, positive number")
			error = 1
			vspace.select()
			vspace.focus()
		}

		if (error != 1) {

			var sel = window.opener.foo.document.selection;
			if (sel!=null) {
				var rng = sel.createRange();
				if (rng!=null) {

					// Are we modifying or inserting?
					if (window.opener.flashEdit) {

						if (imageWidth != "") {
							selectedFlash.width = imageWidth
							selectedFlashEmbed.width = imageWidth
						} else {
							selectedFlash.removeAttribute("width")
							selectedFlashEmbed.removeAttribute("width")
						}

						if (imageHeight != "") {
							selectedFlash.height = imageHeight
							selectedFlashEmbed.height = imageHeight
						} else {
							selectedFlash.removeAttribute("height")
							selectedFlashEmbed.removeAttribute("height")
						}


						if (vspace.value != "") {
							selectedFlash.vspace = vspace.value
							selectedFlashEmbed.vspace = vspace.value
						} else {
							selectedFlash.removeAttribute("vspace")
							selectedFlashEmbed.removeAttribute("vspace")
						}

						if (hspace .value != "") {
							selectedFlash.hspace = hspace.value
							selectedFlashEmbed.hspace = vspace.value
						} else {
							selectedFlash.removeAttribute("hspace")
							selectedFlashEmbed.removeAttribute("hspace")
						}

						if (align[align.selectedIndex].text != "") {
							selectedFlash.align = align[align.selectedIndex].text
						} else {
							selectedFlash.removeAttribute("align")
						}


						selectedFlash.movie = flashSrc

						if (loop[loop.selectedIndex].value != "") {
							selectedFlash.loop =  loop[loop.selectedIndex].value
							selectedFlashEmbed.loop =  loop[loop.selectedIndex].value
						} else {
							selectedFlash.removeAttribute("loop")
							selectedFlashEmbed.removeAttribute("loop")
						}

						embedTag = /(<embed([\s\S]*?)>)/gi
						closeEmbedTag = /(<\/embed([\s\S]*?)>)/gi

						originalFlash = selectedFlash.outerHTML

						code = originalFlash.replace(closeEmbedTag, "")
						code = code.replace(embedTag, selectedFlashEmbed.outerHTML + "</embed>")
						selectedFlash.outerHTML = code

						selectedFlash.runtimeStyle.backgroundImage = "url(/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de/../includes/images/hidden.gif)"

					} else {

						if (imageWidth != "")
							imageWidth = ' width=' + imageWidth + '" '
						else
							imageWidth = ''

						if (imageHeight != "")
							imageHeight = ' height=' + imageHeight + '" '
						else
							imageHeight = ''

						if (vspace.value != "")
							vSpace = ' vspace=' + vspace.value + '" '
						else
							vSpace = ''

						if (hspace.value != "")
							hSpace = ' hspace=' + hspace.value + '" '
						else
							hSpace = ''

						if (align[align.selectedIndex].text != "")
							falign = ' align="' + align[align.selectedIndex].text + '" '
						else
							falign = ''

						HTMLTextField = 
						'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0"' + imageHeight + imageWidth + vSpace + hSpace + falign + '>' +
						'<param name=movie value="' + flashSrc + '">' +
						'<param name="LOOP" value="' + loop[loop.selectedIndex].value + '">' + 
						'<embed src="' + flashSrc +
						'" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash"' 
						+ imageWidth + imageHeight + vSpace + hSpace + falign + ' loop="' + loop[loop.selectedIndex].value + '"></embed></object>'

						rng.pasteHTML(HTMLTextField)
					}	
				

					//window.opener.foo.focus();
					self.close();

					// oFlash.removeAttribute("id")


				} // End if
			} // End If
		}
} // End function

function insertExtFlash() {
	selectedFlashFile = document.getElementById("externalFlash").value
	
	if (previousFlash != null) {
		previousFlash.style.border = "3px solid #FFFFFF"
	}

	document.getElementById("previewWindow").innerHTML = "<embed src='" + selectedFlashFile.replace(/ /g, "%20") + "' quality='high' pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='236' height='176' bgcolor='#009933' WMODE=transparent></embed>"

	if (document.getElementById("deleteButton") != null) {
	deleteButton.disabled = true
	}

	previewButton.disabled = false
	insertButton.disabled = false

} // End function

var flashFolder = "/devedit/demo/testflash/"
var previousFlash
var selectedFlashEncoded
function doSelect(oFlash) {
	selectedFlashFile = flashFolder + oFlash.childNodes(0).name
	selectedFlashEncoded = oFlash.childNodes(0).name2
	
	oFlash.style.border = "3px solid #08246B"
	currentFlash = oFlash
	if (previousFlash != null) {
		if (previousFlash != currentFlash) {
			previousFlash.style.border = "3px solid #FFFFFF"
		}
	}
	previousFlash = currentFlash

	document.getElementById("previewWindow").innerHTML = "<embed src='" + selectedFlashFile.replace(/ /g, "%20") + "' quality='high' pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='236' height='176' bgcolor='#009933' WMODE=transparent></embed>"

	previewButton.disabled = false
	insertButton.disabled = false

	if (document.getElementById("deleteButton") != null) {
	deleteButton.disabled = false
	}
}

function CheckFlashForm()
{
	//upload, upload1, upload2, upload3, upload4
	var flashDir = '/devedit/demo/testflash';
	var f1 = document.getElementById("upload");

	// Extract just the filename from the paths of the files being uploaded
	f1_file = f1.value;
	last = f1_file.lastIndexOf ("\\", f1_file.length-1);
	f1_file = f1_file.substring (last + 1);

	if(f1_file == "")
	{
		alert('Please chose a flash file to upload first!');
		return false;
	}

	// Loop through the flashDir array
	if(f1_file != "")
	{
		for(i = 0; i < flashFiles.length; i++)
		{
			if(f1_file == flashFiles[i])
			{
				if(!confirm(f1_file + ' already exists. Are you sure you want to overwrite it?'))
				{
					return false;
				}
			}
		}
	}

	return true;
}

</script>
<title>Insert Flash</title>

<body bgcolor=threedface style="border: 1px buttonhighlight;">
<iframe id=tempFrame style="display:none"></iframe>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the URL of the flash file to insert or select a flash file from those show below. Click 'Insert' to insert the flash file.</span>
</div>
<br>

<form enctype="multipart/form-data" action="http://www.interspire.com/devedit/demo/de/class.devedit.php?ToDo=UploadFlash&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de&DEP1=/devedit/demo/de&flashDir=/devedit/demo/testflash&wi=0&tn=0&dd=0&dt=1&du=0" method="post" onSubmit="return CheckFlashForm()">
<span class="appInside1" style="width:350px">
	<div class="appInside2">
			<div class="appInside3" style="padding:11px"><span class="appTitle">Upload Flash</span>
			<br>
				<input type="file" name="upload" class="Text240"> <input type="submit" value="Upload" class="Text75">
				<span class="err" style="position:absolute; left:40; top:86;"></span>
			</div>
	</div>
</span>
&nbsp;
 <span class="appInside1" style="width:350px">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle">External Flash</span>
			<br>
			<input type="text" name="externalFlash" id="externalFlash" class="Text240" value="http://">&nbsp;<input type=button value=Load class="Text75" onClick="insertExtFlash()">
		</div>
	</div>
</span>
</form>

<span class="appInside1" style="width:350px">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle">Internal Flash</span>
			<table border=0 cellspacing=0 cellpadding=0 style="padding-bottom:5px">
			<tr><td><select style="width:242px; font-size:11px; font-family:Arial;" name="selFlashLib">
				<script>outputFlashLibraryOptions();</script>
			</select>
			</td><td><input type=button value="Switch" class=text75 onClick="switchFlashLibrary(selFlashLib.value)"></td></tr>
			</table>
	<div style="height:325px; width:325px; overflow: auto; border: 2px inset; background-color: #FFFFFF">
			<table border="0" cellspacing="0" cellpadding="3" style="width:100%">
			  <tr>
					<tr>
				<td width="100%" class="body" >
					<font color="gray">[The selected flash library is empty]</font>
				</td>
			</tr>
				</table>
		</div>
		</div>
	</div>
</span>
&nbsp;
<span class="appInside1" style="width:350px; position:absolute">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle">Preview</span><br>
			<span id="previewWindow" style="height:180px; width:240px; overflow: auto; border: 2px inset; background-color: #FFFFFF">
			</span><input type="button" name="previewButton" value="Preview" class="Text75" onClick="javascript:viewImage(selectedFlashFile)" disabled=true style="position:absolute; left:257px;">
		</div>
	</div>
</span>

<span class="appInside1" style="width:350px; padding-top:5px;">
	<div class="appInside2">
		<div class="appInside3" style="padding:11px"><span class="appTitle">Flash Properties</span>
		<table border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td class="body" width="70">Loop:</td>
			<td class="body" width="88">
				<select class="Text70" name=loop>
					<script>printLoop()</script>
					<option value="true">True</option>
					<option value="false">False</option>
				</select>
			</td>
			<td class="body">Alignment:</td>
				<td class="body">
				  <SELECT class=text70 name=align>
					<script>printAlign()</script>
					<option>Baseline
					<option>Top
					<option>Middle
					<option>Bottom
					<option>TextTop
					<option>ABSMiddle
					<option>ABSBottom
					<option>Left
					<option>Right</option>
				  </select>
				</td>
		  </tr>
		  <tr>
			<td class="body">Flash Width:</td>
			<td class="body">
			  <input type="text" name="image_width" size="3" class="Text70" maxlength="3">
		  </td>
			<td class="body">Flash Height:</td>
			<td class="body">
			  <input type="text" name="image_height" size="3" class="Text70" maxlength="3">
			</td>
		  </tr>
		  <tr>
			<td class="body">Horizontal Spacing:</td>
			<td class="body">
			  <input type="text" name="hspace" size="3" class="Text70" maxlength="3">
			</td>
			<td class="body">Vertical Spacing:</td>
			<td class="body">
			  <input type="text" name="vspace" size="3" class="Text70" maxlength="3">
			</td>
		  </tr>
		</table>
		</div>
	</div>
</span>

<div style="padding-top: 6px;">
<input type="button" name="deleteButton" value="Delete" class="Text75" onClick="javascript:deleteFlash(selectedFlashEncoded)"  disabled>
</div>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertButton" value="Insert" class="Text75" onClick="javascript:insertImage(selectedFlashFile)" disabled=true>
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</table>

<script defer>

if (window.opener.imageEdit)
{
	selectedImage = window.opener.selectedImage.src;
	previewModify();
}

</script>
<%
break;

/*
ToDo=Chars
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "Chars":
%>
<script language=JavaScript>
window.onload = this.focus

function insert_char(oChar) {
	var sel = window.opener.foo.document.selection;
	var rng = sel.createRange();
	rng.pasteHTML(oChar.innerHTML)
	window.close()
}

</script>
<style>
.char { cursor: hand; border-left: 1px solid #EEEEEE; border-top: 1px solid #EEEEEE; border-right: 1px solid #999999; border-bottom: 1px solid #999999; padding-bottom: 4px; padding-top: 4px; width: 29px; }
</style>
<title>Insert Special Characters</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=textForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Click on the required special character to insert that character into your webpage.</span>
</div>
<br>

<table bgcolor='threedface'>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&nbsp;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&iexcl;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&cent;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&pound;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&yen;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&sect;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&uml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&copy;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&laquo;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&not;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&reg;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&deg;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&plusmn;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&acute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&micro;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&para;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&middot;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&cedil;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&raquo;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&iquest;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Agrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Aacute;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&Acirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Atilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Auml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Aring;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&AElig;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ccedil;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Egrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Eacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ecirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Euml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Igrave;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&Iacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Icirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Iuml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ntilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ograve;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Oacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ocirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Otilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ouml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Oslash;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ugrave;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&Uacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Ucirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&Uuml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&szlig;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&agrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&aacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&acirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&atilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&auml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&aring;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&aelig;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&ccedil;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&egrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&eacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ecirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&euml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&igrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&iacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&icirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&iuml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ntilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ograve;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&oacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ocirc;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&otilde;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ouml;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&divide;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&oslash;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ugrave;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&uacute;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&ucirc</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&uuml</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&yuml;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8218;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#402;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8222;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8230;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8224;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8225;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#710;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8240;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8249;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#338;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8216;</div></td>
  </tr>
  <tr>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8217;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8220;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8221;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8226;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8211;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8212;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#732;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8482;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#8250;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#339;</div></td>
	<td align='center'><div onClick="insert_char(this);" class="char">&#376;</div></td>
  </tr>
</table>
<%
break;

/*
ToDo=PageProperties&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "PageProperties":
%>
<script language=javascript>

var myPage = window.opener;

var pageTitle = myPage.foo.document.title;
var pageBgColor = myPage.foo.document.body.bgColor;
var pageLinkColor = myPage.foo.document.body.link;
var pageTextColor = myPage.foo.document.body.text;
var backgroundImage = myPage.foo.document.body.background;
var metaKeywords = ""
var metaDescription = ""
var oDescription
var oKeywords

var metaData = myPage.foo.document.getElementsByTagName('META')
for (var m = 0; m < metaData.length; m++) {
	if (metaData[m].name.toUpperCase() == "KEYWORDS") {
      metaKeywords = metaData[m].content
	  oKeywords = metaData[m]
	}
	  
	if (metaData[m].name.toUpperCase() == 'DESCRIPTION') {
      metaDescription = metaData[m].content
	  oDescription = metaData[m]
	}

}

window.onload = setValues;

// Functions for color popup
var oPopup = window.createPopup();
var colorType = 0
function showColorMenu(menu, width, height) {

	lefter = event.clientX;
	leftoff = event.offsetX;
	topper = event.clientY;
	topoff = event.offsetY;

	var oPopBody = oPopup.document.body;
	moveMe = 0

	if (menu == "colorMenu3") {
		menu = "colorMenu"
		colorType = 3
	} else if (menu == "colorMenu2") {
		menu = "colorMenu"
		colorType = 2
	} else {
		colorType = 1
	}


	var HTMLContent = window.opener.eval(menu).innerHTML
	oPopBody.innerHTML = HTMLContent
	oPopup.show(lefter - leftoff - 2 - moveMe, topper - topoff + 22, width, height, document.body);

	return false;
}

function button_over(td) {
	window.opener.button_over(td)
}

function button_out(td) {
	window.opener.button_out(td)
}

function doColor(td) {
	if (td) {
		if (colorType == 3) {
			document.pageForm.linkcolor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
		} else if (colorType == 2) {
			document.pageForm.textcolor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
		} else {
			document.pageForm.bgColor.value = td.childNodes(0).style.backgroundColor.toUpperCase()
		}
	} else {
		if (colorType == 3) {
			document.pageForm.linkcolor.value = ''
		} else if (colorType == 2) {
			document.pageForm.textcolor.value = ''
		} else {
			document.pageForm.bgColor.value = ''
		}
	}
	oPopup.hide()
}

function doMoreColors() {
	colorWin = window.open(window.opener.popupColorWin,'','width=420,height=370,scrollbars=no,resizable=no,titlebar=0,top=' + (screen.availHeight-400) / 2 + ',left=' + (screen.availWidth-420) / 2)
}

// End functions

function setValues() {

	pageForm.pagetitle.value = pageTitle;
	pageForm.description.value = metaDescription;
	pageForm.keywords.value = metaKeywords;
	pageForm.bgImage.value = backgroundImage;
	pageForm.bgColor.value = pageBgColor;
	pageForm.linkcolor.value = pageLinkColor;
	pageForm.textcolor.value = pageTextColor;
	this.focus();
}

function doModify() {
	var bgImage = pageForm.bgImage.value
	var bgcolor = pageForm.bgColor.value
	var linkcolor = pageForm.linkcolor.value
	var textcolor = pageForm.textcolor.value

	if (bgImage != "") { myPage.foo.document.body.background = bgImage } else { myPage.foo.document.body.removeAttribute("background",0) }
	if (bgcolor != "") { myPage.foo.document.body.bgColor = bgcolor } else { myPage.foo.document.body.removeAttribute("bgColor",0) }
	if (linkcolor != "None") { myPage.foo.document.body.link = linkcolor } else { myPage.foo.document.body.removeAttribute("link",0) }
	if (textcolor != "None") { myPage.foo.document.body.text = textcolor } else { myPage.foo.document.body.removeAttribute("text",0) }

	myPage.foo.document.title = pageForm.pagetitle.value
	
	var oHead = myPage.foo.document.getElementsByTagName('HEAD')

	if (oKeywords != null) {
		oKeywords.content = pageForm.keywords.value
	} else {
		var oMetaKeywords = myPage.foo.document.createElement("META");
		oMetaKeywords.name = "Keywords"
		oMetaKeywords.content = pageForm.keywords.value
		oHead(0).appendChild(oMetaKeywords)
	}

		if (oDescription != null){
			oDescription.content = pageForm.description.value
		} else {
			var oMetaDesc= myPage.foo.document.createElement("META");
			oMetaDesc.name = "Description"
			oMetaDesc.content = pageForm.description.value
			oHead(0).appendChild(oMetaDesc);
		}

	window.close()
}

function printLinkColor() {
	if ((pageLinkColor != undefined) && (pageLinkColor != "")) {
		document.write('<option selected style="BACKGROUND-COLOR: ' + pageLinkColor + '">' + pageLinkColor)
		document.write('<option>None')
	} else {
		document.write('<option selected>None')
	}
}

function printTextColor() {
	if ((pageTextColor != undefined) && (pageTextColor != "")) {
		document.write('<option selected style="BACKGROUND-COLOR: ' + pageTextColor + '">' + pageTextColor)
		document.write('<option>None')
	} else {
		document.write('<option selected>None')
	}
}

document.onkeydown = function () { 
	if (event.keyCode == 13) {	// ENTER
				doModify()			
	}
};

document.onkeypress = onkeyup = function () { 
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;
	}
};

</script>
<title>Modify Page Properties</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=pageForm>
<div class="appOutside">

<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to modify the  properties of your page.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" width="92%">
	  <tr>
		<td class="body" width="100">Page Title:</td>
		<td class="body">
		  <input type="text" name="pagetitle" maxlength="100" class=text220>
		</td>
	  </tr>
	  <tr>
		<td class="body" valign="top">Description:</td>
		<td class="body">
		  <textarea name="description" class="text220" rows="4"></textarea>
		</td>
	  </tr>
	  <tr>
		<td class="body">Keywords:</td>
		<td class="body">
		  <input type="text" name="keywords" maxlength="300" class=text220>
		</td>
	  </tr>
	  <tr>
		<td class="body">Background Image:</td>
		<td class="body">
		  <input type="text" name="bgImage" maxlength="300" class=text220>
		  </td>
	  </tr> 
		  <tr>
		<td class="body">Background Color:</td>
		  <td class="body">
		  <input type="text" name="bgColor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
		  </td>
		  </tr>
		  <tr>
			<td class="body">Text Color:</td>
			<td class="body">
			  <input type="text" name="textcolor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu2',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
			</td>
		  </tr>
		  <tr>
			<td class="body">Link Color:</td>
			<td class="body">
			  <input type="text" name="linkcolor" size="2" class="text70" maxlength="7" value=""><img onClick="showColorMenu('colorMenu3',157,158)" src="../includes/images/popups/colors.gif" width=21 height=20 hspace=5 style="position: relative; top:5px" onmouseover="window.opener.button_over(this);" onmouseout="window.opener.button_out(this);" onmousedown="window.opener.button_down(this);" class=toolbutton>
			</td>
		  </tr>
	    </table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="modifyPage" value="OK" class="Text75" onClick="javascript:doModify();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>

<%
break;

/*
ToDo=DoSpell
&JS=19944210715679719.js
&other=SpellCheck
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "DoSpell":
%>
<html>
<head>
<script language="javascript" type="text/javascript">

function QueryString(key)
{
	var value = null;
	for (var i=0;i<QueryString.keys.length;i++)
	{
		if (QueryString.keys[i]==key)
		{
			value = QueryString.values[i];
			break;
		}
	}
	return value;
}
QueryString.keys = new Array();
QueryString.values = new Array();

function QueryString_Parse()
{
	var query = window.location.search.substring(1);
	var pairs = query.split("&");
	
	for (var i=0;i<pairs.length;i++)
	{
		var pos = pairs[i].indexOf('=');
		if (pos >= 0)
		{
			var argname = pairs[i].substring(0,pos);
			var value = pairs[i].substring(pos+1);
			QueryString.keys[QueryString.keys.length] = argname;
			QueryString.values[QueryString.values.length] = value;		
		}
	}

}

QueryString_Parse();

var win = window.opener;
var nw = new Array(); // array that stores wrong words
var ec = -1;
var currec = 0;
var orig = win.foo.document.body.innerText;
var init = false;

window.attachEvent("onfocus",redoSpellCheck);

function word(pos) {
	this.position=pos;
	this.addSuggestion=addSuggestion;
	this.suggestions=new Object();
	this.suggCount=0;
	this.status=0; // 0 = unchanged, 1 = ignored, 2 = changed, 3 = not found
	try{
	    this.word = win.arr[pos].word;
	}
	catch(e){
	    this.word = null;
	    this.status = 3;
	}
}

function addSuggestion(s) {
	this.suggestions[this.suggCount]=s;
	this.suggCount++;
}

function initForm(){
    /* set up initial form values */
    setWord(0);
    init=true;
}

function setWord(idx){
    var oOption;
    if (currec > ec || ec == -1) {
        alert("Spelling check is complete");
        window.close();
    }else{
        if(nw[idx].status != 0){
            setWord(++currec);
            return;
        }
        if(win.arr[nw[currec].position].getWord()){
            notWord.value = nw[idx].word;
            if(nw[idx].suggCount > 0) {
                sugg.innerHTML = ""; // clear all options then repopulate
                for(j=0; j<nw[idx].suggCount;j++){
                    oOption = document.createElement("OPTION");
                    sugg.options.add(oOption);
                    oOption.innerText = nw[idx].suggestions[j];
                    oOption.value = nw[idx].suggestions[j];
                }

				if (nw[idx].suggestions[0] != "(no suggestions)")
				{
	                repWord.value = nw[idx].suggestions[0];
					sugg.disabled = false
				} else {
					repWord.value = nw[idx].word
					repWord.select()
					repWord.focus()
					sugg.disabled = true
				}

            }
        }
    }
}

function selectSuggestion(obj){
    repWord.value = sugg[obj.selectedIndex].value;
}

function ignore(){
    nw[currec].status=1;
    setWord(++currec);
}
function ignoreAll(){
    var ic = currec;
    nw[currec].status=1;
    for(i=currec;i<ec;i++){
        if(nw[ic].word == nw[i].word) nw[i].status=1;
    }
    setWord(++currec);
}

function isvalid(wrd){
	for(i=0;i<sugg.options.length;i++) if(sugg.options[i].value==wrd) return true;
	return false;
}

function change(){
    var newword = repWord.value;
    var numwords;
    if(newword.length != 0){numwords = getWordCount();} else {numwords = 0;}
    nw[currec].status=2;
    win.arr[nw[currec].position].fixWord(newword, numwords);
    // if (!isvalid(newword)){redoSpellCheck();return;}
    orig = win.foo.document.body.innerText;
    setWord(++currec);
}

function changeAll(){
    var ic = currec;
    var newword = repWord.value;
    var numwords;
    if(newword.length != 0){numwords = getWordCount();} else {numwords = 0;}
    nw[currec].status=2;
    for(i=ic;i<=ec;i++){
        if(nw[ic].word == nw[i].word){
            nw[i].status=2;
            win.arr[nw[i].position].fixWord(newword, numwords);
        }
    }
    // if (!isvalid(newword)){redoSpellCheck();return;}
    orig = win.foo.document.body.innerText;
    setWord(++currec);
}

function getWordCount(){
    var r = repWord.createTextRange();
    var rEnd = true; var wordcount=0;
    // loop until I run out of words
    while(rEnd){
        if(r.text.match(/[\ \n\r]+$/)) r.moveEnd("character",-1); // strip out any trailing line feeds and spaces
        t=r.text; // grab the text
        if((t!="." || t!="!" || t!="?") && (rEnd!=0 && t.match("[A-Za-z]"))) r.collapse();
        /* grab the next word */
        r.move("word",1); rEnd = r.expand("word");
        wordcount++;
    }
    return wordcount;
}

function redoSpellCheck(){
    if(win.foo.document.body.innerText != orig && init){
        init = false; // we've started the resubmit process, don't restart it!
        alert("You've changed the content directly or replaced \na word with one not in the dictionary. \nThe spellcheck will be repeated.");
        win.rng.select(); // reselect original range
        win.spellCheck(); // redo the spellcheck
        return;
    }
}

// Include the JavaScript suggestions file
document.write("<\script language=javascript type=text/javascript src=http://www.spellcheckme.com/delete_js.php?file=" + QueryString('JS') + "></\script>");

</script>


<style type="text/css">
	body    { background-color: threedface; border:0px; }
	div     { font-family:Tahoma; font-size:11px; }
	.btn    { width:75px; height:22px; font-family:Tahoma; font-size:11px; margin-top:7px; }
</style>
</head>

<body onload="initForm();">
<table border="0" cellpadding="0" cellspacing="0" width="285">
<tr><td valign="top">
<div><label for="notWord">Not in Dictionary</label></div>
<div><input type="text" id="notWord" style="width:200px;" disabled></div>

<div style="margin-top:7px;"><label for="repWord">Replace with</label></div>
<div><input type="text" id="repWord" style="width:200px;"></div>

<div style="margin-top:7px;"><label for="sugg">Suggestions</label></div>
<select id="sugg" size="5" style="width:200px;" onclick="selectSuggestion(this);">
</select>
</td><td valign="top" align="right">

<button onclick="ignore();" class="btn">Ignore</button><br>
<button onclick="ignoreAll();" class="btn">Ignore All</button><br>
<button onclick="change();" class="btn" style="margin-top:15px;">Change</button><br>
<button onclick="changeAll();" class="btn">Change All</button><br>
<button onclick="window.close();" class="btn" style="margin-top:40px;">Cancel</button>

</td>
</tr></table>
</body>
</html>
<%
break;

/*
ToDo=SpellCheck
*/

case "SpellCheck":
%>
<html>
<head>
<script language="javascript" type="text/javascript">
var win = window.opener;

function getWords(){
    var wrds = "";
    for(var i=0; i<win.arr.length; i++){
        wrds += i + ',' + win.arr[i].word;
        if (i<win.arr.length-1) wrds += ",";
    }
    document.frm.words.value = wrds;
    document.frm.lang.value = win.spellLang;
	document.frm.myRef.value = document.location
    document.frm.submit();
}	

</script>
</head>
<body onload="getWords();">
<form name="frm" method="post" action="http://www.spellcheckme.com/suggestions_wep.php">
<input type="hidden" name="words" value="">
<input type="hidden" name="myRef" value="">
<input type="hidden" name="lang" value="">
<font face=verdana size=2>Checking spelling. Please wait...</font>
</form>

</body>
</html>
<%
break;

/*
ToDo=InsertLink&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertLink":
%>
		<script language=JavaScript>

		window.onload = doLoad;
		window.opener.doStyles();

		function doLoad() {
			ci = window.opener.customLinks
			
			for (i = 0; i < ci.length; i++)
			{
				newOption = document.createElement("option");
				newOption.text = ci[i][0]
				val = ci[i][1];
				linkPart = ci[i][1].substring(0, ci[i][1].indexOf("|"))
				targetPart = ci[i][1].substring(ci[i][1].indexOf("|")+1, ci[i][1].length)
				newOption.value = linkPart
				newOption.id = targetPart
				document.getElementById("libraryText").add(newOption)
			}

			// If there are no custom links, hide the custom link TR
			if(ci.length == 0)
			{
				document.getElementById("trCustomLink").style.display = "none";
			}
		}

		function printStyleList() {
			if (window.opener.document.getElementById("sStyles") != null) {
				document.write(window.opener.document.getElementById("sStyles").outerHTML);
				document.getElementById("sStyles").className = "text90";
					if (document.getElementById("sStyles").options[0].text == "Style") {
						document.getElementById("sStyles").options[0] = null;
						document.getElementById("sStyles").options[0].text = "";
					} else {
						document.getElementById("sStyles").options[1].text = "";
					}
				document.getElementById("sStyles").onchange = null;  
				document.getElementById("sStyles").onmouseenter = null; 
			} else {
				document.write("<select id=sStyles class=text70><option selected></option></select>")
			}
		}


		function getLink() {
				if (window.opener.foo.document.selection.type == "Control") {
					var oControlRange = window.opener.foo.document.selection.createRange();
					if (oControlRange(0).tagName.toUpperCase() == "IMG") {
						var oSel = oControlRange(0).parentNode;
					} else {
						alert("Link can only be created on an Image or Text")
					}
				} else {
					oSel = window.opener.foo.document.selection.createRange().parentElement()
					while (oSel.tagName.toUpperCase() != "A")
					{
						oSel = oSel.parentElement
						if (oSel == null) {
							oSel = window.opener.foo.document.selection.createRange().parentElement()
							break
						}
					}
				}

				if (oSel.tagName.toUpperCase() == "A")
				{
					document.linkForm.targetWindow.value = oSel.target
					document.linkForm.link.value = oSel.getAttribute("href",2)
				}
			}

			function InsertLink() {
				targetWindow = document.linkForm.targetWindow.value;
				var linkSource = document.linkForm.link.value
				styles = document.linkForm.sStyles[linkForm.sStyles.selectedIndex].text

				if (linkSource != "")
				{
					var oNewLink = window.opener.foo.document.createElement("<A>");
					oNewSelection = window.opener.foo.document.selection.createRange()

					if (window.opener.foo.document.selection.type == "Control")
					{
						selectedImage = window.opener.foo.document.selection.createRange()(0);
						selectedImage.width = selectedImage.width
						selectedImage.height = selectedImage.height
					}

					oNewSelection.execCommand("CreateLink",false,linkSource);

					if (window.opener.foo.document.selection.type == "Control")
					{
						oLink = oNewSelection(0).parentNode;
					} else
						oLink = oNewSelection.parentElement()

					if (targetWindow != "")
					{
						oLink.target = targetWindow;
					} else
						oLink.removeAttribute("target")

					if (styles != "")
						oLink.className = styles
					else
						oLink.removeAttribute("className")

					// window.opener.foo.focus();
					window.opener.doToolbar()
					window.opener.showLink()
					self.close();
				} else {
					alert("URL cannot be left blank")
					document.linkForm.link.focus()
				}
			}

			function CreateLink(LinkSource) {
				document.linkForm.link.value = LinkSource;
				document.linkForm.link.focus()
			}

			function RemoveLink() {
				if (window.opener.foo.document.selection.type == "Control")
				{
					selectedImage = window.opener.foo.document.selection.createRange()(0);
					selectedImage.width = selectedImage.width
					selectedImage.height = selectedImage.height
				}

				window.opener.foo.document.execCommand("Unlink");
				// window.opener.foo.focus();
				window.opener.showLink()
				self.close();
			}

			function getAnchors() {
				var allLinks = window.opener.foo.document.body.getElementsByTagName("A");
				for (a=0; a < allLinks.length; a++) {
						if (allLinks[a].href.toUpperCase() == "") {
							document.write("<option value=#" + allLinks[a].name + ">" + allLinks[a].name + "</option>")
						}
				}
			}
		</script>
		<title>Link Manager</title>
		<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
		<body bgcolor=threedface style="border: 1px buttonhighlight;">
		<form name=linkForm>
		<div class="appOutside">

		<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
			<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
			<span>Enter the required information and click the &quot;OK&quot; button to insert a link into your webpage.</span>
		</div>
		<br>

		<table border="0" cellspacing="0" cellpadding="5" width="92%">
				  <tr>
					<td class=body width="100">URL:</td>
					<td class=body>
					  <input type="text" name="link" value="" class="Text220">
					</td>
				  </tr>
				  <tr id="trCustomLink">
					<td class=body width="100">Pre-defined Links:</td>
					<td class=body>
					  <select id="libraryText" name="libraryText" class="Text220" onChange="link.value = libraryText[libraryText.selectedIndex].value; targetWindow.value = libraryText[libraryText.selectedIndex].id; link.focus()">
					  <option value=""></option>
					  </select>
					</td>
				  </tr>
				  <tr>
					<td class=body>Target Window:</td>
					<td class=body>
					  <input type="text" name="targetWindow" value="" class="Text90">
					  <select name="targetText" class="Text90" onChange="targetWindow.value = targetText[targetText.selectedIndex].value; targetText.value = ''; targetWindow.focus()">
					  <option value=""></option>
					  <option value="">None</option>
					  <option value=_blank>_blank</option>
					  <option value=_parent>_parent</option>
					  <option value=_self>_self</option>
					  <option value=_top>_top</option>
					  </select></td>
					</td>
				  </tr>
				  <tr>
				  <td class=body>Anchor:</td>
				  <td class=body>
					  <select name="targetAnchor" class="Text90" onChange="link.value = targetAnchor[targetAnchor.selectedIndex].value; targetAnchor.value = ''; link.focus()">
						<option value=""></option>
						<script>getAnchors()</script>
					  </select></td>
				  </tr>
				  <tr>
				  <td class="body">Style:</td>
				  <td class="body">
						<script>printStyleList()</script>
				  </td>
				  </tr>
				  <tr id="trFiller" style="display:none">
					<td colspan="2" width="100%" height="20">
						&nbsp;
					</td>
				  </tr>
				</table>

		</div>
		<div style="padding-top: 6px; float: right;">
		<input type="button" name="insertLink" value="Insert Link" class="Text75" onClick="javascript:InsertLink();">
				<input type="button" name="removeLink" value="Remove Link" class="Text85" onClick="javascript:RemoveLink();">
				<input type=button name="Cancel" value="Cancel" class="Text75" onClick="javascript:window.close()">
		</div>
			</form>
			<script>getLink()</script>

<%
break;

/*
ToDo=InsertEmail&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertEmail":
%>
<script language=JavaScript>
window.onload = this.focus
window.opener.doStyles()

function printStyleList() {
	if (window.opener.document.getElementById("sStyles") != null) {
		document.write(window.opener.document.getElementById("sStyles").outerHTML);
		document.getElementById("sStyles").className = "text90";
			if (document.getElementById("sStyles").options[0].text == "Style") {
				document.getElementById("sStyles").options[0] = null;
				document.getElementById("sStyles").options[0].text = "";
			} else {
				document.getElementById("sStyles").options[1].text = "";
			}

		document.getElementById("sStyles").onchange = null;  
		document.getElementById("sStyles").onmouseenter = null; 
	} else {
		document.write("<select id=sStyles class=text70><option selected></option></select>")
	}
}

function getLink() {
		if (window.opener.foo.document.selection.type == "Control") {
			var oControlRange = window.opener.foo.document.selection.createRange();
			if (oControlRange(0).tagName.toUpperCase() == "IMG") {
				var oSel = oControlRange(0).parentNode;
			} else {
				alert("Link can only be created on an Image or Text")
			}
		} else {
			oSel = window.opener.foo.document.selection.createRange().parentElement();
		}

		if (oSel.tagName.toUpperCase() == "A")
		{
			myHref = oSel.getAttribute("href",2)
			if (myHref.indexOf("?") >-1 )
			{
				myHrefEmail = myHref.substring(7, myHref.indexOf("?"))
				myHrefSubject = myHref.substring(myHref.indexOf(myHrefEmail)+myHrefEmail.length+9, myHref.length)
			} else {
				myHrefEmail = myHref.substring(7, myHref.length)
				myHrefSubject = ""
			}

			document.emailForm.email.value = myHrefEmail
			document.emailForm.subject.value = myHrefSubject
		}
}

function InsertEmail() {
	error = 0
	var sel = window.opener.foo.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {

			if (window.opener.foo.document.selection.type == "Control")
				{
					selectedImage = window.opener.foo.document.selection.createRange()(0);
					selectedImage.width = selectedImage.width
					selectedImage.height = selectedImage.height
				}

			email = document.emailForm.email.value
			subject = document.emailForm.subject.value
			styles = document.emailForm.sStyles[emailForm.sStyles.selectedIndex].text

        	if (error != 1) {

				if (email == "") {
					alert("Email address cannot be left blank")
					document.emailForm.email.focus
					error = 1
				} else {
					mailto = "mailto:" + email
					if (subject != "")
					{
						mailto = mailto + "?subject=" + subject
					}

					rng.execCommand("CreateLink",false,mailto)

					if (window.opener.foo.document.selection.type == "Control")
						oLink = rng(0).parentNode;
					else
						oLink = rng.parentElement()

					if (styles != "")
						oLink.className = styles
					else
						oLink.removeAttribute("className")
				}
			}
		}
	}
	
	if (error != 1) {
		// window.opener.foo.focus()
		window.opener.doToolbar()
		window.opener.showLink()
		self.close();
	}
}

function RemoveLink() {
	if (window.opener.foo.document.selection.type == "Control")
	{
		selectedImage = window.opener.foo.document.selection.createRange()(0);
		selectedImage.width = selectedImage.width
		selectedImage.height = selectedImage.height
	}

	window.opener.foo.document.execCommand("Unlink");
	// window.opener.foo.focus();
	window.opener.showLink()
	self.close();
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertEmail()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Email Link</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=emailForm>
<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to create a link to an email address in your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
	  <tr>
		    <td class="body" width="90">Email Address:</td>
			<td class="body">
			  <input type="text" name="email" size="10" class="Text150" maxlength="150">
		  </td>
		  </tr>
		  <tr>
		    <td class="body" width="80">
			Subject:</td>
			<td class="body">
			  <input type="text" name="subject" size="10" class="Text150">
		  </td>
		  </tr>
		  <tr>
		  <td class="body">Style:</td>
		  <td class="body">
				<script>printStyleList()</script>
		  </td>
		</tr>
</table>

</div>
<div style="padding-top: 6px; float: right;">
<input type="button" name="insertLink" value="Insert Email Link" class="Text120" onClick="javascript:InsertEmail();">
<input type="button" name="removeLink" value="Remove Email Link" class="Text120" onClick="javascript:RemoveLink();">
<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>
</form>
<script>getLink()</script>
<%
break;

/*
ToDo=InsertAnchor&DEP1=/devedit/demo/de&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "InsertAnchor":
%>
<script language=JavaScript>
window.onload = this.focus

window.onload = doLoad;

function doLoad() {
		document.anchorForm.anchor_name.focus()
}

function InsertAnchor() {
	error = 0
	var sel = window.opener.foo.document.selection;
	if (sel!=null) {
		var rng = sel.createRange();
	   	if (rng!=null) {

			name = document.anchorForm.anchor_name.value

        	if (error != 1) {
				if (name == "") {
					alert("Anchor name cannot be left blank")
					document.anchorForm.anchor_name.focus
					error = 1
				} else {

					selectedText = window.opener.foo.document.selection.createRange().htmlText

					rng.pasteHTML("<a id=ewp_element_to_style name=" + anchorForm.anchor_name.value + ">" + selectedText + "</a>")
					oAnchor = window.opener.foo.document.getElementById("ewp_element_to_style")
					
					if (window.opener.borderShown == "yes") {
						oAnchor.runtimeStyle.width = "20px"
						oAnchor.runtimeStyle.height = "20px"
						oAnchor.runtimeStyle.textIndent  = "20px"
						oAnchor.runtimeStyle.backgroundRepeat  = "no-repeat"
						oAnchor.runtimeStyle.backgroundImage = "url(/devedit/demo/de/../includes/images/anchor.gif)"
					}

					oAnchor.removeAttribute("id")
				}
			}
		}
	}
	
	if (error != 1) {
		// window.opener.foo.focus()
		self.close();
	}
}

document.onkeydown = function () { 
			if (event.keyCode == 13) {	// ENTER
				InsertAnchor()
			}
};

document.onkeypress = onkeyup = function () {
	if (event.keyCode == 13) {	// ENTER
	event.cancelBubble = true;
	event.returnValue = false;
	return false;			
	}
};

</script>
<title>Insert Anchor</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor=threedface style="border: 1px buttonhighlight;">
<form name=anchorForm>

<div class="appOutside">
<div style="border: solid 1px #000000; background-color: #FFFFEE; padding:5px;">
	<img src="../includes/images/popups/bulb.gif" align=left width=16 height=17>
	<span>Enter the required information and click on the &quot;OK&quot; button to insert an anchor into your webpage.</span>
</div>
<br>

<table border="0" cellspacing="0" cellpadding="5" style="width:92%">
  <tr>
	<td class="body" width="90">Anchor Name:</td>
	<td class="body">
	  <input type="text" name="anchor_name" size="10" class="Text150" maxlength="150">
  </td>
  </tr>
</table>
	
</div>
<div style="padding-top: 6px; float: right;">
	<input type="button" name="insertAnchor" value="OK" class="Text75" onClick="javascript:InsertAnchor();">
	<input type="button" name="Submit" value="Cancel" class="Text75" onClick="javascript:window.close()">
</div>

</form>
<%
break;

/*
ToDo=ShowHelp
&DEP1=/devedit/demo/de
&DEP=/home/httpd/vhosts/interspire.com/httpdocs/devedit/demo/de
*/

case "ShowHelp":
%>
<HTML>
<TITLE>&nbsp;The WYSIWYG Editor and commands</title>
<link rel="stylesheet" href="../includes/de_styles.css" type="text/css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="15" colspan="2"><img src="../includes/images/1x1.gif" width="1" height="15"></td>
  </tr>
  <tr> 
    <td width="15"><img src="../includes/images/1x1.gif" width="15" height="1"></td>
    <td class="heading1">Help</td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td class="body"> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class=body><b>Note: If an option below is not visible or accessible in your editor, then your administrator may have disabled it.</b></td>
          <td align="right" width="100"><b><a href="javascript:window.close()" class=bodylink><b>Close Window</b></a></b></td>
        </tr>
      </table>
      <img src="../includes/images/1x1.gif" width="1" height="10"><br>
      <table width="98%" border="0" cellspacing="0" cellpadding="0" class="bevel1">
        <tr> 
          <td>&nbsp;The WYSIWYG Editor and commands</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="2"><img src="../includes/images/1x1.gif" width="1" height="10"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td class="body"> 
      <table width="98%" border="0" cellspacing="5" cellpadding="0" class=bevel2>
        <tr> 
          <td colspan="3" class="bodybold">Save</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_save.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To save your work, click on the 'Save' icon.</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Fullscreen Mode</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_fullscreen.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To expand the active window to a full screen click on the 'Fullscreen Mode' Icon. Concurrent clicks on this icon will toggle this feature on and off.</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Cut (Ctrl+X)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_cut.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To cut a portion of the document, highlight the desired portion and click the 'Cut' icon (keyboard shortcut - CTRL+X).</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Copy (Ctrl+C)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_copy.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To copy a portion of the document, highlight the desired portion and click the 'Copy' icon (keyboard shortcut - CTRL+C).</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Paste (Ctrl+V)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_paste.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To paste a portion that has already been cut (or copied), click where you want to place the desired portion on the page and click the 'Paste' icon (keyboard shortcut - CTRL+V).<br><br>To paste from Microsoft Word, click on the drop down icon next to the Paste Icon.</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Paste from Microsoft Word (Ctrl + D)</td>
        </tr>
        <tr> 
          <td valign="top">&nbsp;</td>
          <td>&nbsp;</td>
          <td class="body">To Paste from Microsoft Word: Copy your desired text from Microsoft Word and click the drop down icon next to the paste icon. Select the 'Paste from MS Word Option'. This will remove the tags that Microsoft Word automatically places around your text. It will also remove most text formatting as well.</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Find and Replace</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_find.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To find and replace words or phrases within the text:<br> Select the search and replace feature. Enter the word or phrase you wish to replace and type it in the 'Find what' field<br><br>Select the new word or phrase you wish to replace the searched text with in the 'Replace with' field.<br><br>You can choose to 'find next' which allows you to manually replace instances of the searched text, or you can choose 'replace all' which allows you to replace all instances of the selected text.<br><br>Selecting the optional 'Match Case' tab allows you to search for a word or phrase with exactly the same upper or lower-case spelling of the word or phrase entered in 'Find What'. Not selecting this option means that a word entered in the 'Find what' field with upper case characters will return a search of upper and lower case matches of the same word.<br><br>Selecting the optional 'Match whole word only' tab allows the search to only display the words that are an exact match of the word or phrase entered in the 'Find What' field.</td>
        </tr>
        <tr> 
          <td colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold">Undo (Ctrl+Z)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_undo.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To undo the last change, click the 'Undo' icon (keyboard shortcut - CTRL+Z). Each consecutive click will undo the previous change to the document.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Redo (Ctrl+Y)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_redo.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To redo the last change, click the 'Redo' icon (keyboard shortcut - CTRL+Y). Each consecutive click will repeat the last change to the document.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Check Spelling (F7)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_spellcheck.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To check spelling, select the text you would like to spell check (if you do not select the text, then your whole document will be checked)<br><br>Click on the spell checker icon or right click on the mouse and scroll down to 'Check spelling'.<br><br>You will be taken to the first incorrectly spelled word. You can then choose to<br><br>-	Change the incorrectly spelled word with the suggested words provided<br>-	Ignore the incorrectly spelled word (i.e. not make any changes to it)<br><br>To check spelling of a single word, highlight the word and right click on the mouse to get a selection of suggested replacements. To replace the miss-spelt word with one of the suggested words, simple select one of the replacements.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Remove Text Formatting</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_remove_format.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">This command allows you to select a specific portion of text and remove any of the formatting which it contains. To remove any text formatting select the desired portion of text and Click the 'Remove Text Formatting' button.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Bold (Ctrl+B)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_bold.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To bold text, select the desired portion of text and click the 'Bold' icon (keyboard shortcut - CTRL+B). Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Underline (Ctrl+U)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_underline.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To underline text, select the desired portion of text and click the 'Underline' icon (keyboard shortcut - CTRL+U). Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Italic (Ctrl+I)</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_italic.gif" width="23" height="22" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To convert text to italic, select the desired portion of text and click the 'Italic' icon (keyboard shortcut - CTRL+I). Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Strikethrough</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_strikethrough.gif" width="23" height="22" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To format text as strike through Select the text you want formatted by highlighting it and select the 'Strike through' icon. Each consecutive click will toggle this feature on and off</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Number List</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_numbers.gif" width="23" height="22" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To start a numbered text list, click the 'Insert Numbered List' icon. If text has already been selected, the selection will be converted to a numbered list. Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Bullet List</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_bullets.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To start a bullet text list, click the 'Insert Bullet List' icon. If text has already been selected, the selection will be converted to a bullet list. Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Decrease Indent</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_decrease_indent.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To decrease indent of a paragraph, click the 'Decrease Indent' icon. Each consecutive click will move text further to the left.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Increase Indent</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_increase_indent.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To increase indent of a paragraph, click the 'Increase Indent' icon. Each consecutive click will move text further to the right.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Superscript</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_superscript.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To convert text to superscript (vertically aligned higher): Select the desired portion of text and click the 'Superscript' icon.  Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Subscript</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_subscript.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To convert text to subscript (vertically aligned lower): Select the desired portion of text and click the 'Subscript' icon.  Each consecutive click will toggle this function on and off.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Align Left</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_align_left.gif" width="23" height="22" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To align to the left, make a selection in the document and click the 'Align Left' icon.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Align Center</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_align_center.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To align to the center, make a selection in the document and click the 'Align Center' icon.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Align Right</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_align_right.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To align to the right, make a selection in the document and click the 'Align Right' icon.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Justify</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_align_justify.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body"> To justify a paragraph or text, make a selection in the document and click the 'Justify' icon. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Horizontal Line</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_hr.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a horizontal line, select the location to insert the line and click the 'Insert Horizontal Line' icon.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Create or Modify Link</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_link.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To create a hyperlink, select the text or image to create the link on, then click the 'Create or Modify Link' icon. if applicable, the popup window will contain existing link information. You can type the full URL of the page you want to link to in the URL text box. You can also enter the target window information (optional) and an anchor name (if linking to an anchor - optional).<br><br>For quick access to links, you can choose to insert a pre-defined link from the 'Pre-defined links' dropdown list.<br><br>When finished, click the 'Insert Link' button to insert the hyperLink you just created, or click 'Remove Link' to remove an existing link. Clicking 'Cancel' will close the window and take you back to the editor.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Anchor</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_anchor.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert an anchor, select a desired spot on the web page you are editing and click the 'Insert / Modify Anchor' icon. In the dialogue box, type the name for the anchor.<br><br>When finished, click the 'OK' button to insert the anchor, or 'Cancel' to close the box.<br><br>To modify an anchor select the anchor (displayed as an anchor icon when guidelines are switched on) and click the 'Insert / Modify Anchor' icon. Make your changes and hit the 'OK' button or click 'Cancel' to close the window.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Create Email Link</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_email.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To create an email link, select text or an image on the web page you are editing where you would like the link to appear. Click the 'Create Email Link' icon. In the dialogue box, type the email address for the link and the subject of the email.<br><br>When finished, click the 'OK' button to insert the email link, or 'Cancel' to close the box.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Font</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="70"><img src="../includes/images/image_font.gif" width="60" height="20" border="1"></td>
                <td>&nbsp;</td>
                <td class="body">To change the font of text, select the desired portion of text and click the 'Font' drop-down menu.<br><br>Select the desired font (choose from Default - Times New Roman, Arial, Verdana, Tahoma, Courier New or Georgia).</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Font Size</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="70"><img src="../includes/images/image_size.gif" width="44" height="20" border="1"></td>
                <td>&nbsp;</td>
                <td class="body">To change the size of text, select the desired portion of text and click the 'Size' drop-down menu.<br><br>Select the desired size (text size 1-7).</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Format</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="70"><img src="../includes/images/image_format.gif" width="60" height="20" border="1"></td>
                <td>&nbsp;</td>
                <td class="body">To change the format of text, select the desired portion of text and click the 'Format' drop-down menu.<br><br>Select the desired format (choose from Normal, Superscript, Subscript and H1-H6).</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Style</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="90"><img src="../includes/images/image_style.gif" width="90" height="20" border="1"></td>
                <td>&nbsp;</td>
                <td class="body">To change the style of text, images, form objects, tables, table cells etc select the desired element and click the 'Style' drop-down menu, which will display all styles defined in the style-sheet.<br><br>Select the desired style from the menu.<br><br>Note: this function will not work if there is no style-sheet applied to the page.</td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Font Color</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_font_color.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To change the colour of text, select the desired portion of text and click the 'Colour' drop-down menu.<br><br>Select the desired colour from the large selection in the drop-down menu. To define your own custom color, click on the 'More Colors...' button at the bottom of the color picker.<br><br>This will launch the advanced color picker, where you can select a color from the color map, or specify your own color using RGB or hex values. You can also change the contrast of the color by clicking on the contrast gradient</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Highlight Color</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_highlight.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To change the highlighted colour of text, select the desired portion of text and click the 'Highlight' drop-down menu.<br><br>Select the desired colour from the large selection in the drop-down menu. To define your own custom color, click on the 'More Colors...' button at the bottom of the color picker.<br><br>This will launch the advanced color picker, where you can select a color from the color map, or specify your own color using RGB or hex values. You can also change the contrast of the color by clicking on the contrast gradient</td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Table Functions</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_table_down.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert or modify a table or cell, select the 'Table Functions' icon to display a list of available Table Functions.<br><br>If a Table Function is NOT available, you will need to select, or place your cursor inside the table you wish to modify.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Table</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert a table, select the desired location, then click the 'Insert Table' icon.<br><br>A new window will pop-up with the following fields: Rows - number of rows in table; Columns - number of columns in table; Width - width of table; BgColour - background colour of table; Cell Padding - padding around cells; Cell Spacing - spacing between cells and Border - border around cells.<br><br>Fill in table details then click the 'OK' button to insert table, or click 'Cancel' to go back to the editor.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Modify Table Properties</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To modify table properties, select a table or click anywhere inside the table to modify, then click the 'Modify Table Properties' icon.<br><br>A pop-up window will appear with the table's properties. Click the 'OK' button to save your changes, or click 'Cancel' to go back to the editor.<br><br>Note: this function will not work if a table has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Modify Cell Properties</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To modify cell properties, click inside the cell to modify, then click the 'Modify Cell Properties' icon.<br><br>A pop-up window will appear with the cells' properties.<br><br>Click the 'OK' button to save your changes, or click 'Cancel' to go back to the editor.<br><br>Note: this function will not work if a cell has not been selected and does not work across multiple cells.</td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Column to the Right</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert a column to the right of your cursor, click inside cell after which to insert a column, then click the 'Insert Column to the Right' icon.<br><br>Each consecutive click will insert another column after the selected cell.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Column to the Left</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert column to the left of your cursor, click inside cell before which to insert a column, then click the 'Insert Column to the Left' icon.<br><br>Each consecutive click will insert another column before the selected cell.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Row Above</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert row above, click inside cell above which to insert a row, then click the 'Insert Row Above' icon.<br><br>Each consecutive click will insert another row above the selected cell.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Row Below</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert row below, click inside cell below which to insert a row, then click the 'Insert Row Below' icon.<br><br>Each consecutive click will insert another row below the selected cell.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold"> Delete Row</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To delete a row, click inside cell which is in the row to be deleted, then click the 'Delete Row' icon.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Delete Column</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To delete a column, click inside cell which is in the column to be deleted, then click the 'Delete Column' icon.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" height="21" colspan="3" class="bodybold">Insert Column</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert a column, click inside cell which is in the column to be inserted, then click the 'Insert Column' icon.<br><br>Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Decrease Column Span</td>
        </tr>
        <tr> 
          <td valign="top"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To decrease column span, click inside cell who's span is to be decreased, then click the 'Decrease Column Span' icon.<br><br>Each consecutive click will further decrease the column span of the selected cell. Note: this function will not work if a cell has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Form Functions</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_form_down.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert or modify a Form, select the 'Form Functions' icon to display a list of available Form Functions.<br><br>If a Form Function is NOT available, you will need to place your cursor inside the Form you wish to modify.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Form</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_form.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a form, select desired position then click the 'Insert Form' icon.<br><br>A new window will pop-up with the following fields: Name - name of form; Action - location of script that processes the form and Method - post, get or none.<br><br>Fill in form details or leave blank for a blank form.<br><br>When finished, click the 'OK' button to insert form, or click 'Cancel' to go back to the editor.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Modify Form Properties</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_modify_form.gif" width="23" height="22" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To modify form properties, click anywhere inside the form to modify, then click the 'Modify Form Properties' icon.<br><br>A pop-up window will appear with the form's properties.<br><Br>Click the 'OK' button to save your changes, or click 'Cancel' to go back to the editor. Note: this function will not work if a form has not been selected.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Text Field</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_textfield.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a text field, select desired position then click the 'Insert/Modify Text Field' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of text field; Character width - the width of the text field, in characters; Type - type of text field (Text or Password); Initial value - initial text in field and Maximum characters - maximum number of characters allowed.<br><br>Set the attributes then click the 'OK' button to insert text field, or click 'Cancel' to go back to the editor.<br><br>To modify a text field's properties, select desired text field and click the 'Insert/Modify Text Field' icon.<br><Br>A pop-up window will appear with the text field's attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes, or click 'Cancel' to go back to the editor.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Text Area</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_textarea.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a text area, select desired position then click the 'Insert/Modify Text Area' icon<br><br>A pop-up window will appear with the following attributes: Name - name of text area; Character width - the width of the text area, in characters; Initial value - initial text in area and Lines - number of lines allowed in the text area.<br><br>Set the attributes then click the 'OK' button to insert the text area, or click 'Cancel' to go back to the editor.<br><br>To modify a text area's properties, select desired text area and click the 'Insert/Modify Text Area' icon.<br><br>A pop-up window will appear with the text area's attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes, or click 'Cancel' to go back to the editor. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Hidden Area</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_hidden.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a hidden field, select desired position then click the 'Insert/Modify Hidden Field' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of hidden field and Initial value - initial value of hidden field.<br><br>Set the attributes then click the 'OK' button to insert the hidden field, or click 'Cancel' to go back to the editor.<br><br>To modify a hidden field's properties, select desired hidden field and click the 'Insert/Modify Hidden Field' icon.<br><br>A pop-up window will appear with the hidden field's attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes or click 'Cancel' to go back to the editor. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Button</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_button.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a button, select desired position then click the 'Insert/Modify Button' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of text area; Type - type of button (Submit, Reset or Button) and Initial value - initial text on the button.<br><br>Set the attributes then click 'OK' to insert button, or click 'Cancel' to go back to the editor.<br><br>To modify a button's properties, select desired button and click the 'Insert/Modify Button' icon.<br><br>A pop-up window will appear with the button's attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes or click 'Cancel' to go back to the editor. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Checkbox</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_checkbox.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a checkbox, select desired position then click the 'Insert/Modify Checkbox' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of checkbox; Initial state - checked or unchecked and Initial value - value of checkbox.<br><br>Set the attributes then click the 'OK' button to insert the checkbox, or click 'Cancel' to go back to the editor.<br><br>To modify a checkbox' properties, select desired checkbox and click the 'Insert/Modify Checkbox' icon.<br><br>A pop-up window will appear with the checkbox' attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes or click 'Cancel' to go back to the editor. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
	<tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Radio Button</td>
        </tr>
	<tr> 
          <td valign="top"><img src="../includes/images/button_radio.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a radio button, select desired position then click the 'Insert/Modify Radio Button' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of radio button; Initial state - checked or unchecked and Initial value - value of radio button.<br><br>Set the attributes then click the 'OK' to insert the radio button, or click 'Cancel' to go back to the editor.<br><br>To modify a checkbox' properties, select desired checkbox and click the 'Insert/Modify Radio Button' icon.<br><br>A pop-up window will appear with the checkbox' attributes.<br><br>Modify any attributes desired, then click the 'OK' button to save changes or click 'Cancel' to go back to the editor. </td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
	<tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Select Field</td>
        </tr>
	<tr> 
          <td valign="top"><img src="../includes/images/button_select.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To insert a select field, select the desired position then click the 'Insert/Modify Select Field' icon.<br><br>A pop-up window will appear with the following attributes: Name - name of the select list; Current Options - The options available for selection in the list; Type - how the list will be displayed (a single option, or multiple options); Size - how many list items will be shown; Style - The style to be applied to this select field, if any.<br><br>To add options to the select list, use the text, value and selected boxes under the 'Maintain Options' heading.<br><br>To modify a select lists properties, select the desired list and click the 'Insert/Modify Select List' button. A popup window will appear with the select lists attributes.<br><br>Modify the desired attributes, then click the 'OK' button to save changes or click 'Cancel' to go back to the editor.</td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
	<tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Flash</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_flash.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">If a flash movie is NOT selected, clicking this icon will open the Flash Manager.<br><br>If a flash movie IS selected, then clicking this icon will open the 'Modify Flash Properties' popup window.<br><br>To modify the properties of the selected flash movie, set the required attributes and click the 'Modify' button.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert / Modify Image</td>
        </tr>
	<tr> 
          <td valign="top"><img src="../includes/images/button_image.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">If an image is NOT selected, clicking this icon will open the Image Manager.<br><br>If an image IS selected, then clicking this icon will open the 'Modify Image Properties' popup window.<br><br>To modify the image properties of the selected image, set the required attributes and click the 'Modify' button.</td>
        </tr>
        <tr> 
          <td colspan="3" class="bodybold"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Textbox</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_textbox.gif" width="21" height="20" border="1"></td>
          <td>&nbsp;</td>
          <td class="body">To add a text box anywhere within the page, select the location where you want the text box to reside in the active window and click on the 'insert text box icon' that will place a text box where you have specified. <br><br>To resize the text box, click on the text box frame (turn 'show/hide guidelines' on if you cannot see the textbox outline). Then click on side/corner of the frame you wish to resize from and drag to a size you require. The text you type will be contained within the text box and will stretch to the size of the text box.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Special Characters</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_chars.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To insert a special character, click the 'Insert Special Character' icon.<br><br>A pop-up window will appear with a list of special characters.<br><br>Click the icon of the character to insert into your webpage.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Modify Page Properties</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_properties.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To modify page properties, click the 'Modify Page Properties' icon.<br><br>A pop-up window will appear with page attributes: Page Title - title of page; Description - description of page; Background Image - The URL of the image curently set as the page background image; Keywords - keywords page is to be recognized by; Background Colour - the background colour of page; Text Colour - colour of text in page and Link Colour - the colour of links in page.<br><br>When finished modifying, click the 'PL' button to save changes, or click 'Cancel' to go back to the editor.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold"> Clean Up HTML Code</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_clean_code.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To clean HTML code, click the 'Clean HTML Code' icon.<br><br>This will remove any empty span and paragraph tags, all xml tags, all tags that have a colon in the tag name (i.e. <tag:with:colon>) and remove style and class attributes.<br><br>This is useful when copying and pasting from Microsoft Word documents to remove unnecessary HTML code. </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Insert Custom HTML</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_custom_inserts.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">There may be a list of available items to insert that you can preview and choose from. This list will usually contain customized items in HTML such as logos and formatted text specific to your site. To preview an item, click on the item in the list, and the item will appear the preview field below. To select the item, click on it and choose 'OK'.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Toggle Absolute Positioning</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_absolute.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To position a text box or image using absolute positioning, select the the textbox or image and select the 'absolute positioning' icon. You can now click and drag an image or text box to the location you would like it to reside within the active window.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Show / Hide Guidelines</td>
        </tr>
        <tr> 
          <td valign="top"><img src="../includes/images/button_show_borders.gif" width="21" height="20" border="1"></td>
          <td valign="top">&nbsp;</td>
          <td valign="top" class="body">To show or hide guidelines, click the 'Show/Hide Guidelines' icon.<br><br>This will toggle between displaying table and form guidelines and not showing any guidelines at all.<br><br>Tables and cells will have a broken grey line around them, forms will have a broken red line around them, while hidden fields will be a pink square when showing guidelines.<br><br>Note that the status bar (at the bottom of the window) will reflect the guidelines mode currently in use.</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Source Mode</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="90"><img src="../includes/images/status_source_up.gif" width="98" height="22" border="1"></td>
                <td>&nbsp;</td>
                <td class="body"> To switch to source code editing mode, click the 'Source' button at the bottom of the editor.<br><br>This will switch to HTML code editng mode.<br><br>To switch back to WYSIWYG Editing, click the 'Edit' button at the bottom of the editor.<br><br>This is recommended for advanced users only </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"><img src="../includes/images/1x1.gif" width="1" height="5"></td>
        </tr>
        <tr> 
          <td valign="top" colspan="3" class="bodybold">Preview Mode</td>
        </tr>
        <tr> 
          <td valign="top" colspan="3"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
              <tr> 
                <td valign="top" width="90"><img src="../includes/images/status_preview_up.gif" width="98" height="22" border="1"></td>
                <td>&nbsp;</td>
                <td class="body">To show a preview of the page being edited, click the 'Preview' button at the bottom of the editor.<br><br>This is useful in previewing a file to see how it will look exactly in your browser, before changes are saved.<br><br>To switch back to editing mode, click the 'Edit' button at the bottom of the editor.</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td colspan="2"><img src="../includes/images/1x1.gif" width="1" height="10"></td>
  </tr>
</table>
</body>
</html>
<%
break;

/*
*/

case "":
%>

<%
break;

/*
*/

case "":
%>

<%
break;

/*
*/

case "":
%>

<%
break;


}
%>


