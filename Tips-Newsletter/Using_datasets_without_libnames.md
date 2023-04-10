Daily Tip 1 Created on Tuesday, 15 April 2003

**Using datasets without libnames**

In SAS versions 8 onwards you can directly reference SAS datasets,
without needing to define a libname. This is done by enclosing the
physical file name in quotes.

***SAS Log***

15 \* Create a version 6 dataset ;

16 data \'c:\\test.sd2\' ; run ;

NOTE: c:\\test.sd2 is a Version 6 data set. In future releases of SAS
you may not be able to

create or update Version 6 data sets. Use PROC COPY to convert the data
set to Version 9.

NOTE: The data set c:\\test.sd2 has 1 observations and 0 variables.

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

17 \* Create a version 8 dataset ;

18 data \'c:\\test.sd7\' ; run ;

NOTE: The data set c:\\test.sd7 has 1 observations and 0 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

19 \* Create a version 9 dataset ;

20 data \'c:\\test.sas7bdat\' ; run ;

NOTE: The data set c:\\test.sas7bdat has 1 observations and 0 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

21

22 \* access a dataset directly ;

23 proc print data=\'c:\\test.sas7bdat\' ; run ;

NOTE: No variables in data set c:\\test.sas7bdat.

NOTE: PROCEDURE PRINT used (Total process time):

real time 0.01 seconds

cpu time 0.00 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
