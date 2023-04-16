Daily Tip 66 24/09/2003 11:20 AM

**Creating CSV files from datastep, easily**

You can write all values from a datastep in CSV format using one
statement:

Put (\_all\_) (:) ;

This writes all variables in the data step data ector, except for \_n\_
& \_error\_. It separates each of them by a comma.

***SAS Log***

32 filename out \'c:\\out.csv\' ;

33 data \_null\_;

34 file out dsd;

35 set sashelp.class;

36 put (\_all\_) (:);

37 run;

bb

NOTE: The file OUT is:

File Name=c:\\out.csv,

RECFM=V,LRECL=256

NOTE: 19 records were written to the file OUT.

The minimum record length was 17.

The maximum record length was 21.

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: DATA statement used (Total process time):

real time 0.13 seconds

cpu time 0.04 seconds

38 filename out ;

NOTE: Fileref OUT has been deassigned.

Example tested under SAS 9.0, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
