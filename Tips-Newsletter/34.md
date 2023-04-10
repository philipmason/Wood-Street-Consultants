Daily Tip 34 16/06/2003 8:18 PM

**Importing & exporting between SAS & Microsoft Access**

If you have "SAS/Access for PC File Formats" licensed then it is now
very easy to import and export data between SAS and Microsoft Access.
You can reference Access tables directly with a libname statement -- no
engine is required. To read a table into SAS just refer to the libref
and use table name as the dataset name. To write a table to Access use
the libref and dataset name, which becomes the table name.

Libname statement syntax, when used with PC Files -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../acpcref.hlp/a002107496.htm]{.underline}

***SAS Log***

98 libname tabs \'x:\\my documents\\db1.mdb\' ;

NOTE: Libref TABS was successfully assigned as follows:

Engine: ACCESS

Physical Name: x:\\my documents\\db1.mdb

99 data x ;

100 set tabs.names ; **\* read table NAMES from database DB1 ;**

101 run ;

NOTE: There were 3 observations read from the data set TABS.names.

NOTE: The data set WORK.X has 3 observations and 3 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

102 data tabs.new ; **\* Create a new table called NEW in database DB1
;**

103 set sashelp.class ;

104 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set TABS.new has 19 observations and 5 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.02 seconds

105 libname tabs ;

NOTE: Libref TABS has been deassigned.

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
