Daily Tip 30 09/06/2003 5:22 PM

**Run macro code from a data step**

Call Execute can be used to submit statements from a data step which
will run after the data step -- if those statements are data step code.
However if the statements can be run immediately, such as a macro
assignment statement, then they will be. The following example shows how
a macro assignment statement is executed during a data step, and then
the resolve function gets the value that was just assigned.

Call Execute ...
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a000127810.htm]{.underline}

Resolve ...
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a000245940.htm]{.underline}

***SAS Log***

353 %let x=0 ;

354 data \_null\_ ;

355 call execute(\'%let x=1 ;\') ;

356 x=resolve(\'&x\') ;

357 put x= ;

358 run ;

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

x=1

NOTE: CALL EXECUTE routine executed successfully, but no SAS statements
were generated.

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
