Daily Tip 64 18/09/2003 8:36 AM

**Export to EXCEL via libname**

In SAS 9 you can now read & write EXCEL spreadsheets from data steps and
procedures. This greatly simplifies exporting data to EXCEL. The
following log shows how I created an EXCEL file called test.xls, with a
sheet called CLASS. The sheet lists variable names in the first row,
followed by values on subsequent rows.

Note the error message demonstrating that there are some limitations
with the EXCEL engine, preventing me from overwriting a sheet once I
have created it. Following that you can see that I can create more
sheets within the file.

***Documentation on EXCEL libname syntax***

[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../acpcref.hlp/a002107496.htm]{.underline}

***SAS Log***

41 libname out excel \'c:\\test.xls\' ;

NOTE: Libref OUT was successfully assigned as follows:

Engine: EXCEL

Physical Name: c:\\test.xls

42 data out.class ; set sashelp.class ; run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set OUT.class has 19 observations and 5 variables.

NOTE: DATA statement used (Total process time):

real time 0.02 seconds

cpu time 0.02 seconds

43 \* try to replace dataset ;

44 data out.class ; set sashelp.class ; run ;

ERROR: The MS Excel table class has been opened for OUTPUT. This table
already

exists, or there is a name conflict with an existing object. This table

will not be replaced. This engine does not support the REPLACE option.

NOTE: The SAS System stopped processing this step because of errors.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

45 \* make a new dataset ;

46 data out.shoes ; set sashelp.shoes ; run ;

NOTE: SAS variable labels, formats, and lengths are not written to DBMS
tables.

NOTE: There were 395 observations read from the data set SASHELP.SHOES.

NOTE: The data set OUT.shoes has 395 observations and 7 variables.

NOTE: DATA statement used (Total process time):

real time 0.02 seconds

cpu time 0.02 seconds

47 \* free it so we can read the spreadsheet from EXCEL ;

48 libname out ;

NOTE: Libref OUT has been deassigned.

Example tested under SAS 9.1, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
