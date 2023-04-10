Daily Tip 19 21/05/2003 2:13 PM

**Exporting to EXCEL**

If you have "SAS/Access for PC File Formats" licensed then it is now
very easy to import and export data between SAS and Microsoft EXCEL. You
can reference EXCEL spreadsheets directly with a libname statement -- no
engine is required. You can then refer to a spreadsheet using the libref
and a worksheet by using a "dataset name". For instance in the example
below, nice.test refers to the spreadsheet 'c:\\nice.xls' and within it
the worksheet called 'test'.

Libname statement syntax, when used with PC Files -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../acpcref.hlp/a002107496.htm]{.underline}

***SAS Log***

11 libname nice \'c:\\nice.xls\' ;

NOTE: Libref NICE was successfully assigned as follows:

Engine: EXCEL

Physical Name: c:\\nice.xls

12 data nice.test ;

13 set sashelp.class ;

14 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set NICE.test has 19 observations and 5 variables.

NOTE: DATA statement used (Total process time):

real time 0.04 seconds

cpu time 0.02 seconds

15 libname nice ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
