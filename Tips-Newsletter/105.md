Daily Tip 105 17/09/2004 10:22:00

**Running SAS 8.2 code from SAS 9**

In some cases you may have code that needs to be run using SAS 8.2,
whilst running other things from SAS 9. A client of mine had a case of
this since they had a product which had procedures created with
SAS/Toolkit in 8.2, and these would not work in 9.1. Fortunately we can
use SAS/Connect to run code on 8.2. We can then retrieve datasets if
needed.

Additionally I could create a stored process in 9.1 which could run the
code on 8.2, thereby fitting 8.2 into the SAS 9 IOM architecture.

In the code below I start the SAS spawner, though you would usually do
this outside of SAS.

**SAS Code**

options noxwait noxsync ;

x \'\"C:\\Program Files\\SAS Institute\\SAS\\V8\\spawner.exe\" -comamid
tcp\' ;

signon speedy;

rsubmit ;

%put REMOTE: &sysver;

endrsubmit ;

%put LOCAL: &sysver;

signoff ;

**SAS Log**

38 options noxwait noxsync ;

39 x \'\"C:\\Program Files\\SAS Institute\\SAS\\V8\\spawner.exe\"
-comamid tcp\'

39 ! ;

40 signon speedy;

NOTE: Remote signon to SPEEDY commencing (SAS Release 9.01.01M2P033104).

NOTE: Copyright (c) 1999-2001 by SAS Institute Inc., Cary, NC, USA.

NOTE: SAS (r) Proprietary Software Release 8.2 (TS2M0)

Licensed to PHILIP MASON, Site 0031371002.

NOTE: This session is executing on the WIN_PRO platform.

NOTE: SAS initialization used:

real time 0.21 seconds

cpu time 0.21 seconds

NOTE: Remote signon to SPEEDY complete.

41 rsubmit ;

NOTE: Remote submit to SPEEDY commencing.

1 %put REMOTE: &sysver;

REMOTE: 8.2

NOTE: Remote submit to SPEEDY complete.

42 %put LOCAL: &sysver;

LOCAL: 9.1

43 signoff ;

NOTE: Remote signoff from SPEEDY commencing.

NOTE: SAS Institute Inc., SAS Campus Drive, Cary, NC USA 27513-2414

NOTE: The SAS System used:

real time 0.21 seconds

cpu time 0.21 seconds

NOTE: Remote signoff from SPEEDY complete.

*Example tested under SAS 9.1.2 & SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
