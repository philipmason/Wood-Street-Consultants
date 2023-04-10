Daily Tip 48 07/07/2003 10:51 PM

**Flexible new date format**

In SAS version 9 there is a new date informat which interprets dates
being read based on the value of a system option. The system option is
called DATESTYLE and it is used to identify sequence of month, day and
year when the ANYDATE informat data is ambiguous. When dates being read
are not ambiguous, then the option is ignored and date is read
correctly.

For more information on this please see the SAS-L post found at
[http://www.listserv.uga.edu/cgi-bin/wa?A2=ind0205A&L=sas-l&P=R4765&D=1&H=0&O=D&T=1]{.underline}

***SAS Log***

33 options datestyle=mdy;

34 data \_null\_;

35 date=input(\'01/02/03\',anydtdte8.); \* ambiguous date ;

36 put date=date9.;

37 run;

date=02JAN2003

NOTE: DATA statement used (Total process time):

real time 0.51 seconds

cpu time 0.00 seconds

38 options datestyle=ydm;

39 data \_null\_;

40 date=input(\'01/02/03\',anydtdte8.); \* ambiguous date ;

41 put date=date9.;

42 run;

date=02MAR2001

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

43 options datestyle=myd;

44 data \_null\_;

45 date=input(\'01/31/2003\',anydtdte10.); \* unambiguous date, so
option ignored ;

46 put date=date9.;

47 run;

date=31JAN2003

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
