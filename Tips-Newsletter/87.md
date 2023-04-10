Daily Tip 87 09/12/2003 12:53 PM

**Get list of paper sizes**

You can use Proc Registry to get a list of the names of available paper
sizes and their dimensions. This is useful to see what paper sizes are
supported and therefore can be selected from ODS.

***Sample code***

**proc** **registry** list startat=\"CORE\\PRINTING\\PAPER SIZES\";

**run**;

\* We can set the paper size to a pre-defined size, or enter
measurements ;

options papersize=a3;

\* Now we produce output and can verify in MS Word

that the page size is A3 as selected ;

ods rtf file=\'c:\\test.rtf\' ;

**proc** **print** data=sashelp.prdsale;

**run** ;

ods rtf close ;

***Part of Log***

\[ Letter\]

Height=double:11

Units=\"IN\"

Width=double:8.5

\...

\[ ISO A4\]

Height=double:29.7

Units=\"CM\"

Width=double:21

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
