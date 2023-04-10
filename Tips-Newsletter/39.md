Daily Tip 39 23/06/2003 11:26 PM

**Changing procedure titles in ODS**

Many procedures will display the procedure name in output produced by
ODS. If you want to save some space and turn the procedure name off you
can use *ODS NOPTITLE* to do so. This works for PDF, RTF, HTML & Listing
destinations (and possibly more).

If you are using a table of contents in HTML then you will still get the
procedure title there, but this can also be removed. Using *ODS
PROCLABEL ' '* will remove the procedure title. If you wanted some text
in its place then you could specify that rather than a blank.

For a whole paper about ODS Tips & Techniques see Lauren Haworths web
site -
[http://www.laurenhaworth.com/pubs_current.htm#ODStips]{.underline}

**SAS Program**

ods html body=\'c:\\test.html\'

contents=\'c:\\contents.html\'

frame=\'c:\\frame.html\' ;

ods noptitle ; \* turn off procedure title in body ;

ods proclabel \' \' ; \* turn off procedure title in contents ;

title \'Sales frequencies\' ;

**proc** **freq** data=sashelp.prdsale ;

table country ;

**run** ;

ods html close ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
