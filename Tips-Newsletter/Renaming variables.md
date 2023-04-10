Daily Tip 6 Created on Thursday, 24 April 2003

**Renaming variables**

In version 6 you must rename variables one by one using either the
RENAME statement or RENAME dataset option. However in v8 onwards you can
rename a range of variables.

For info on the RENAME dataset option -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a000131169.htm]{.underline}

For info on the RENAME statement -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a000203026.htm]{.underline}

**SAS Program or Log**

**data** x ;

array a(**10**) \$ **2** ;

**run** ;

\* Rename in v6 ;

**proc** **print** data=x(rename=(a1=b1 a2=b2 a3=b3 a4=b4 a5=b5

a6=b6 a7=b7 a8=b8 a9=b9 a10=b10)) ;

\* Rename in v8 or v9 ;

**proc** **print** data=x(rename=(a1-a10=b1-b10)) ;

**run** ;

**data** y ;

array x(**50**) \$ **2** ;

rename x1-x50=something_else1-something_else50 ;

**run** ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
