Daily Tip 33 13/06/2003 10:06 AM

**Area charts which can compare magnitudes of variables in categories**

The GAREABAR procedure in SAS/Graph lets you compare the magnitudes of 2
variables for each category of data using exact and relative magnitudes
of values. It only works with ODS using the *activex* or *actimgx*
driver though.

The following example plots *sales* on the x-axis, relative percent of
number of *salespersons* on the y-axis, with a bar for each *site*.
Additionally each bar is sub-grouped by *quarter*.

Proc gAreaBar -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/a002252885.htm]{.underline}

***SAS Log***

goptions reset=all device=activex ;

ods html file=\'c:\\test.html\' ;

**data** totals;

input Site \$ Quarter \$ Sales Salespersons;

cards;

Lima 1 4043.97 4

NY 1 4225.26 12

Rome 1 16543.97 6

Lima 2 3723.44 5

NY 2 4595.07 18

Rome 2 2558.29 10

Lima 3 4437.96 8

NY 3 5847.91 24

Rome 3 3789.85 14

Lima 4 6065.57 10

NY 4 23388.51 26

Rome 4 1509.08 16

;

**proc** **gareabar** data=totals;

hbar site\*salespersons /sumvar=sales

subgroup=quarter

rstat=SUM

wstat=PCT;

**run** ; **quit** ;

ods html close;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
