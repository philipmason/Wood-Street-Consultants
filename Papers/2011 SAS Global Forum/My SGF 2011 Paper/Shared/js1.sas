*ProcessBody;

data _null_ ;
  input ;
  file _webout ;
  put _infile_ ;
cards4 ;
<html>
<head>
<script type='text/javascript'>
var popwin = null ;

function open_popup()
{
  if (popwin == null)
    popwin = window.open('http://xs103:8080/SASStoredProcess1/do?_program=SBIP://Foundation/cmis/info(StoredProcess)','','top=150,left=350,width=250,height=50,status=0,toolbar=0,location=0,menubar=0,directories=0,resizable=0,scrollbars=0') ;
}

function close_popup()
{
  if (popwin != null)
    {popwin.close() ; popwin = null;}
}

function checkKey()
{
  var key=String.fromCharCode(window.event.keyCode) ;
  if (key == 'X')
    { alert("You pressed the X key") ; }
}

</script>
</head>
<body onload='alert("finished loading");' onunload='alert("finished unloading");'
      onkeypress='window.status="key pressed is: " + String.fromCharCode(window.event.keyCode) ;'
      onkeyup='window.status="key up"; checkKey() ;'>
Pop-up a window with information by moving over <a href='#' 
      onmouseover='open_popup(); window.status="Hovering over the link" ; return true ;'
      onmouseout='close_popup(); window.status=" " ; return true ;'>here</a>.
<p>
Pop-up a window with information by clicking <a href='#' onmousedown='open_popup();' onmouseup='close_popup();'>here</a>.
<p>
<a href='#' ondblclick='open_popup();'>Double click to open</a>, <a href='#' onclick='close_popup();'>single click to close here</a>.
<p>
<a href='#' style='font-size="x-large"' onmousemove='open_popup();'>Move mouse over this to open</a>, <a style='font-size="x-large"' href='#' onmousemove='close_popup();'>move over this to close</a>.
<p>
Press <b>X</b> to make an alert window pop up.
;;;;
run ;

data _null_ ;
  file _webout ;
  put '<h1>Cookies</h1>' ;
  htcook=htmldecode("&_htcook") ;
  put htcook ;
  put '</body>' ;
  put '</html>' ;
run ;
%STPBEGIN;
%STPEND;
*';*";*/;run;
