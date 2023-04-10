Daily Tip 25 02/06/2003 4:07 PM

**IN operator now accepts integer ranges**

In SAS 9 the IN operator has been enhanced to accept integer ranges.
This works well with IF statements, but doesn't seem to work with WHERE
statements (yet).

***SAS Log***

73 data sample ;

74 set sashelp.class ;

75 if age in (11, 13:15, 18:25) ;

76 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set WORK.SAMPLE has 13 observations and 5 variables.

NOTE: DATA statement used (Total process time):

real time 0.03 seconds

cpu time 0.02 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
