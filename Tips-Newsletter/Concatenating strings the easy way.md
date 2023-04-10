Daily Tip 22 27/05/2003 8:08 PM

**Concatenating strings the easy way**

In SAS 9 there is a new function called CATX which makes concatenating
strings easy. It will concatenate any number of character strings,
removing leading & trailing blanks and inserting a separator.

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/lrdict.hlp/a002256379.htm&query=catx#\~1]{.underline}

***SAS Log***

1 data test ;

2 a=\' Phil \' ;

3 b=\' Mason \' ;

4 c=trim(left(a))!!\' \'!!left(b) ;

5 d=catx(\' \',a,b) ;

6 put c= d= ;

7 run ;

c=Phil Mason d=Phil Mason

NOTE: The data set WORK.TEST has 1 observations and 4 variables.

NOTE: DATA statement used (Total process time):

real time 0.55 seconds

cpu time 0.06 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
