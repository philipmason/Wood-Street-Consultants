Daily Tip 27 27/05/2003 3:39 PM

**Creating a range of macro variables from SQL with leading zeroes**

In versions of SAS prior to SAS 9 you could create ranges of macro
variables, but could not use leading zeroes in the macro variable names.
So in 8.2 you might end up with macro variables like var8, var9, var10.
But in SAS 9 you could create variables like var08, var09, var10. This
can make further use of those macro variables easier to code.

See syntax of the *select* statement, with description of *into* -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../proc.hlp/tw5520sqlselect.htm]{.underline}

***SAS Program***

**proc** **sql** noprint ;

select name into :name01-:name19 from sashelp.class ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
