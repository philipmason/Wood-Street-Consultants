Daily Tip 58 05/08/2003 11:28 PM

**Make work files become permanent**

This technique relies on a feature within SAS that says if you have a
single level dataset name, then by default it will go to the WORK
library. However there is another feature within SAS that says that if
you allocate a library called USER then all single level datasets will
be stored there, rather than in WORK.

This means that you can write some code using single level dataset
names, and while testing they will be put in WORK and deleted at the end
of the SAS session. But you could then decide to keep those datasets by
simply allocating the USER library and pointing it to a directory to
keep those datasets.

The following SAS log demonstrates this.

**SAS Log**

1 \* Test code, and all single level datasets go to work library, which
is cleared when SAS

1 ! ends ;

2 data test ; x= 1 ; run ;

NOTE: The data set WORK.TEST has 1 observations and 1 variables.

NOTE: DATA statement used:

real time 0.27 seconds

cpu time 0.03 seconds

3

4 \* Once tested, define the USER libref, sending all single level
datasets to a permanent

4 ! location ;

5 libname user \'c:\\\' ;

NOTE: Libref USER was successfully assigned as follows:

Engine: V8

Physical Name: c:\\

6 data test ; x= 1 ; run ;

NOTE: The data set USER.TEST has 1 observations and 1 variables.

NOTE: DATA statement used:

real time 0.01 seconds

cpu time 0.01 seconds

7 \* when finished free the USER fileref to redirect datasets to WORK ;

8 libname user ;

NOTE: Libref USER has been deassigned.

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
