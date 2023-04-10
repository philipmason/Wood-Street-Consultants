Daily Tip 67 25/09/2003 11:11 AM

**Specifying character/numeric variable ranges**

Many people know about the \_character\_ , \_numeric\_ & \_all\_ which
can be used to specify all character, numeric or any variables currently
defined in a data step. There are other common ways of specifying
variable ranges using single or double dashed ranges. A less common
method though is to specify to use all variables of a particular type
between two variables. This selects variables in the order they are
defined to the dataset, not alphabetical order.

a-numeric-b

uses all variables between a & b, which are numeric.

a-character-b

uses all variables between a & b, which are character.

***SAS Program***

**data** \_null\_ ;

set sashelp.prdsale ;

put actual-numeric-month ; \* numeric range ;

put country-character-product ; \* character range ;

**run** ;

Example tested under SAS 9.0, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
