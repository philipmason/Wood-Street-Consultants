Daily Tip 26 03/06/2003 1:30 PM

**Compiled data steps**

For those who haven't seen compiled data steps before here is the basic
code. The example shows how the *%sysfunc* is executed at compile time,
and so the *compile_time* value does not change once the code is
compiled. Then each time we run the code the *time()* function is run,
and gives the current time.

**SAS Code**

**data** test **/ pgm=test** ;

format compile_time exec_time time8. ;

compile_time=%sysfunc(time()) ; \* gets the current time, when compiled
;

exec_time=time() ; \* gets the current time when run ;

put compile_time= exec_time= ;

**run** ;

**data** pgm=test ; **run** ; \* run a compiled data step ;

**SAS Log**

33 data pgm=test ; run ;

NOTE: DATA STEP program loaded from file WORK.TEST.

compile_time=13:21:34 exec_time=13:22:38

NOTE: The data set WORK.TEST has 1 observations and 2 variables.

NOTE: DATA statement used:

real time 0.01 seconds

cpu time 0.01 seconds

***Execute & Describe***

Prior to version 8.2 source code was not kept with compiled code, which
meant that if you lost it then it may be difficult to rewrite the code.
However from 8.2 onwards you can use the *describe* statement to display
the original source code. You can also use the *execute* statement to
rerun the original source code, to produce a newly compiled data step.

**SAS Log**

34 data pgm=test ;

35 **describe** ;

36 run ;

NOTE: DATA step stored program WORK.TEST is defined as:

data test / pgm=test ;

format compile_time exec_time time8. ;

compile_time=48093.5910000801 ;

exec_time=time() ;

put compile_time= exec_time= ;

run ;

NOTE: DATA statement used:

real time 0.00 seconds

cpu time 0.00 seconds

37 data pgm=test ;

38 **execute** ;

39 run ;

NOTE: DATA STEP program loaded from file WORK.TEST.

compile_time=13:21:34 exec_time=13:28:12

NOTE: The data set WORK.TEST has 1 observations and 2 variables.

NOTE: DATA statement used:

real time 0.01 seconds

cpu time 0.01 seconds

For more information see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/lrcon.hlp/a000739603.htm&query=pgm#\~1]{.underline}

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
