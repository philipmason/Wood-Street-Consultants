Daily Tip 24 29/05/2003 2:36 PM

**Writing messages to the LOG, while writing text elsewhere**

In SAS 9 there is a new statement called PUTLOG, which explicitly writes
to the SAS LOG. This means that you can direct regular PUT statements to
write to another destination, and write to the log using PUTLOG without
the need to redirect output to the LOG with a FILE LOG statement.

PUTLOG is similar to the ERROR statement, except PUTLOG does not set
\_error\_ to 1. The ERROR statement is also available in SAS 6 & 8.

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/lrdict.hlp/a002205777.htm&query=putlog#\~1]{.underline}

***SAS Log***

55 data test ;

56 put \'This goes to LOG by default\' ;

57 file print ;

58 put \'This goes to OUTPUT window, since I selected print\' ;

59 putlog \'but this still goes to the LOG\' ;

60 put \'This goes to OUTPUT\' ;

61 putlog \'NOTE: and I can write proper messages using colours\' ;

62 putlog \'WARNING: \...\' ;

63 putlog \'ERROR: \...\' ;

64 run ;

This goes to LOG by default

but this still goes to the LOG

NOTE: and I can write proper messages using colours

WARNING: \...

ERROR: \...

NOTE: 2 lines were written to file PRINT.

NOTE: The data set WORK.TEST has 1 observations and 0 variables.

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.01 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
