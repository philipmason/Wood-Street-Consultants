Daily Tip 57 04/08/2003 10:06 PM

**Traffic lighting with Proc Tabulate**

Traffic lighting is to cause colours to change appropriately depending
on values. For instance values below a limit might appear in green,
whilst values over a limit appear in red. This can be easily
accomplished in SAS 8 using Proc Tabulate and ODS.

There are a few key things which make this work:

> 1\. make sure you open and close your ODS destination(s), since this
> only works with ODS
>
> 2\. create a format which takes ranges and returns the name of a
> colour for each
>
> 3\. use a style override to change the colour based on the value. In
> the example you can see that I set the *background colour* based on my
> format *traf*, using the total of *actual*.

**Example Code**

ods html file=\'test.html\' ;

proc **format** ;

value traf

low-120000=\'red\'

other=\'green\' ;

proc **tabulate** data=sashelp.prdsale ;

class country region ;

var actual ;

table actual\*sum\*{style={background=traf.}},country,region ;

run ;

ods html close ;

**Output**

***The SAS System***

**Sum of Actual Sales**

** **

**Region**

**EAST**

**WEST**

**Country**

127485.00

119505.00

**CANADA**

**GERMANY**

124547.00

121451.00

**U.S.A.**

118229.00

119120.00

*Note: the almost-daily SAS tips are back, having recovered from my hard
disk crash.*

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
