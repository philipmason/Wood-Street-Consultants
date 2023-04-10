Daily Tip 8 28/04/2003 10:31 AM

**Getting the right special character in a graph**

Many people who export graphics to MS Word make use of the CGM device
drivers. Drivers such as the CGM drivers have hardware fonts associated
with them, which give high quality results in output.

Each character of text that is displayed in a graph has an ASCII code
associated with it. This ASCII code may have a different character
assigned in different character sets or fonts. So if you type in one
character and then produce a graph, you may get a different character
displayed depending on which driver and font is being used.

In the following code our ± (plus or minus) sign has been typed into the
title statement, but comes out as a quote when we produce the graph.
This can be fixed by specifying a hardware font which has the correct
symbol for that ASCII code.

See the following for more information on using hardware fonts -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/font-using-hardware-fonts.htm#font-alternative-hw-fonts]{.underline}

***SAS Program***

goptions reset=all;

GOPTIONS device=cgmmw6c gsfmode=replace gsfname=graph ;

filename graph \"c:\\test.cgm\";

\*\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--;

\*\*\* This \*does not\* produce my plus/minus sign \*\*\*;

TITLE j=c \"Intent-to-Treat, Survivial ± 1.5\" ;

**proc** **gchart** data=sashelp.class ;

vbar sex ;

**run** ;

\*\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--;

\*\*\* This \*does\* produce my plus/minus sign \*\*\*;

TITLE **f=hwcgm005** j=c \"Intent-to-Treat, Survivial ± 1.5\" ;

**proc** **gchart** data=sashelp.class ;

vbar sex ;

**run** ;

You can run PROC GDEVICE, select the driver and use the CHARTYPE window
to look at what hardware fonts are available for a device driver
([http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/gdevice-using.htm]{.underline}).

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
