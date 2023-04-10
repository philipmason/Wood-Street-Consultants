Daily Tip 4 Created on Tuesday, 22 April 2003

**Using unusual variable names**

From version 8 onwards there is some extra functionality provided with
variable names within SAS, compared to what can be done in version 6.
For instance variable names can be:

> • Upper & lower case
>
> • Up to 32 characters long
>
> • Referencing variables is case insensitive
>
> • Spaces and some special symbols are allowed (depending on options)

To use embedded spaces and special symbols you need to specify the
following option

options validvarname=any;

The following example shows how to then create a variable name and use
it.

**data** test ;

\'#1 @ the \"Top\"\'n=\'John\' ;

\"Applied Statistician\'s\"N=**1** ;

**run** ;

**proc** **print** ;

id \'#1 @ the \"Top\"\'n ;

var \"Applied Statistician\'s\"N ;

**run** ;

Partial output from a PROC CONTENTS on the dataset TEST follows.

Alphabetic List of Variables and Attributes

\# Variable Type Len

1 #1 @ the \"Top\" Char 4

2 Applied Statistician\'s Num 8

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrcon.hlp/a000998953.htm#a000998930]{.underline}

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
