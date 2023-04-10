Daily Tip 85 28/11/2003 4:56 PM

**Page x of y in RTF & PDF**

In SAS 9 if you want to add page numbers to your RTF output in the form
of "page x of y" then you can use the in-line formatting by specifying
an escape character and {pageof} -- which will generate RTF code to
display *x of y* on each page. {pageof} only works for the RTF
destination.

If you want to do this for the PDF or Printer destination.then you need
to use a slightly different technique. You can use the in-line style
directive *{thispage}* which will give the current page number, and
*{lastpage}* will give the last page number.

For some very preliminary documentation see
[http://support.sas.com/rnd/base/topics/odsprinter/new9.html]{.underline}

***Sample code for RTF***

ods escapechar = \'\\\';

title \'This document will have page x of y \'

j=r \'Page \\{pageof}\' ;

ods rtf file=\'c:\\test.rtf\' ;

**proc** **print** data=sashelp.prdsale;

**run**;

ods rtf close;

***Sample code for PDF***

ods escapechar = \'\\\';

title \'This document will have page x of y \'

j=r \'Page \\{thispage} of \\{lastpage}\' ;

ods pdf file=\'c:\\test.pdf\' ;

**proc** **print** data=sashelp.prdsale;

**run**;

ods pdf close;

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
