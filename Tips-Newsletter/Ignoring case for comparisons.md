Daily Tip 111 01/11/2004 11:25:00

**Ignoring case for comparisons**

When comparing text in SAS you will note that uppercase and lowercase
are not equivalent. So "abc" does not equal "ABC". Sometimes you may
want to compare text and ignore case. There are several ways to do this.

**Method 1**

If using a where clause you can use the **upcase()** function against
any variables, and make sure that any text literals are in uppercase.

e.g.

**proc** **print** data=mydata ;

where upcase(name)=\'PHIL\' ;

**run** ;

**Method 2**

In a datastep convert all text to uppercase, so you will then compare
uppercase with uppercase. You also need to make sure that any text in
custom formats is also in uppercase. The following code demonstrates a
simple but effective technique for creating an array containing all
character variables and then processing them in some way. You can also
use the **VNAME()** function to handle individual variables as
exceptions.

e.g.

**data** test ;

set sashelp.prdsale ;

\* make an array containing all character variables currently defined ;

array c(\*) \_character\_ ;

\* loop through array ;

do \_i=**1** to dim(c) ;

vname=vname(c(\_i)) ;

\* uppercase each character variable, except COUNTRY ;

if vname\^=\"COUNTRY\" then

c(\_i)=upcase(c(\_i)) ;

end ;

**run** ;

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
