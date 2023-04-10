Daily Tip 20 22/05/2003 9:15 PM

**Putting interactive graphs on web pages**

ODS and some great graphic drivers make it easy to put interactive
graphs onto web pages. The code below demonstrates two methods. The
first creates HTML code which displays an interactive graph using an
activex control -- this works great on windows platforms. The second
produces HTML code which displays an interactive graph using a JAVA
applet -- this is great for windows and non-windows platforms. Remember
you need the appropriate control/applet installed, but can add some HTML
code to prompt the user to install it if needed (see reference for
how-to).

For info on the ACTIVEX control & driver -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/a002114269.htm]{.underline}

For info on the JAVA applet & driver -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/a002252934.htm]{.underline}

***SAS Program***

ods html file=\'c:\\active.html\' ;

goptions reset=all **device=activex** ;

**proc** **gchart** data=sashelp.prdsale ;

vbar3d country / group=region subgroup=prodtype sumvar=actual ;

**run** ; **quit** ;

ods html close ;

ods html file=\'c:\\java.html\' ;

goptions reset=all **device=java** ;

**proc** **gchart** data=sashelp.prdsale ;

vbar3d country / group=region subgroup=prodtype sumvar=actual ;

**run** ; **quit** ;

ods html close ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
