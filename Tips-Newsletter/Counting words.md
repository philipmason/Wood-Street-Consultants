Daily Tip 15 14/05/2003 12:44 PM

**Counting words**

Rather than using a more convoluted technique for counting the number of
occurrences of a word in a character string, in SAS 9 we can now use the
COUNT function. It will simply count the number of sub-strings that
occur in a string, optionally ignoring the case (as in my example).

Documentation on the count function can be found at
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a002260230.htm]{.underline}

***SAS Log***

15 data \_null\_ ;

16 sentence=\'This is ONE way of using one in One sentence\' ;

17 num=count(sentence,\'one\',\'i\') ;

18 put num= ;

19 run ;

num=3

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
