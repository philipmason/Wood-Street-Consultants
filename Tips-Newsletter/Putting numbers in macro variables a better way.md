Daily Tip 23 28/05/2003 2:13 PM

**Putting numbers in macro variables a better way**

In SAS 9 there is a new function called SYMPUTX which creates a macro
variable from a numeric variable without writing a note to the log, and
trims leading & trailing blanks. It will use a field up to 32 characters
wide and you can optionally tell it which symbol table to put the macro
variable into.

The example below show how SAS does an automatic type conversion and
uses BEST12.2 to convert a numeric to character in line 44. The
following line shows how we can explicitly do the conversion and trim
the result. The next line shows how to use SYMPUTX to simplify the
process.

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/lrdict.hlp/a002295697.htm&query=symputx#\~1]{.underline}

***SAS Log***

42 data test ;

43 my_val=12345 ;

44 call symput(\'value0\',my_val) ; \* auto conversion done ;

45 call symput(\'value1\',trim(left(put(my_val,8.)))) ; \* v8 ;

46 call symputx(\'value2\',my_val) ; \* SAS 9 ;

47 run ;

NOTE: Numeric values have been converted to character values at the
places given by:

(Line):(Column).

44:24

NOTE: The data set WORK.TEST has 1 observations and 1 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

48 %put =-\>&value0\<-==-\>&value1\<-==-\>&value2\<-=;

=-\> 12345\<-==-\>12345\<-==-\>12345\<-=

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
