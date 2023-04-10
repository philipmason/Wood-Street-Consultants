Daily Tip 7 Created on Friday, 25 April 2003

**Running VB macros in EXCEL from SAS**

Using DDE, you can send an Excel 4.0 DDE function call to execute a
saved EXCEL Visual Basic macro. This works with all versions of EXCEL,
including EXCEL 2000 & EXCEL XP.

filename excdata dde \'Excel\|System\';

data \_null\_;

file excdata;

put \' RUN(\"File.xls!Macro2\",FALSE)\]\';

run;

where ***File.xls*** is the name of the Excel file where the macro is
stored and ***Macro2*** is the name of the Macro you wish to run.
**Note**: these names are case-sensitive.

For some nice DDE examples -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/hostwin.hlp/ddeexamples.htm&query=dde#\~1]{.underline}

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
