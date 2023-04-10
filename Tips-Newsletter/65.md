Daily Tip 65 22/09/2003 18:23:00

**Using native EXCEL formatting from ODS**

It is possible to use native EXCEL formatting direct from ODS. This is
done by producing HTML which is imported by EXCEL. The HTML code
contains embedded Microsoft Office XML commands which set the formatting
required. In the following example we cause a column of figures to be
displayed as fractions.

***SAS Log***

8 ods html file=\'c:\\both.xls\' ;

NOTE: Writing HTML Body file: c:\\both.xls

9 data x ;

10 do value=.1 to 1 by .1 ;

11 fraction=value ;

12 output ;

13 end ;

14 run ;

NOTE: The data set WORK.X has 10 observations and 2 variables.

NOTE: DATA statement used (Total process time):

real time 0.04 seconds

cpu time 0.04 seconds

15 proc print ;

16 var value ;

17 var fraction /
style(data)={htmlstyle=\"mso-number-format:\\#\\/\\#\"};

18 run ;

NOTE: There were 10 observations read from the data set WORK.X.

NOTE: PROCEDURE PRINT used (Total process time):

real time 0.50 seconds

cpu time 0.09 seconds

19 ods html close ;

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
