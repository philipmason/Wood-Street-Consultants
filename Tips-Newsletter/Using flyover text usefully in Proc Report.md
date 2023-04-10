Daily Tip 32 11/06/2003 2:54 PM

**Using flyover text usefully in Proc Report**

Flyover text appears (if defined) when you hover your mouse over
something. ODS supports the creation of flyover text with PDF & HTML
destinations. The following example shows how you could produce a report
which showed first names, but when hovering the mouse over a name the
whole name is displayed.

Remember that to see it you need to view your HTML in an external
browser, since the SAS results viewer will not display it properly.

**SAS Program**

ods html file=\'c:\\test.html\' ;

**data** class ;

retain fmtname \'\$full\' ;

length first last \$ **20** sex \$ **1** age **4** ;

input first last sex age ;

label=trim(first)\|\|\' \'\|\|last ;

cards ;

fred flintstone M 21

wilma flintstone F 19

ronald reagan M 99

barney rubble M 33

john thomas M 50

jenny thompson F 4

;

run ;

\* Make a format to show full name when given first name ;

**proc** **format** cntlin=class(rename=(first=start)) ;

run ;

**proc** **report** data=class nowd ;

columns first sex age fly;

define sex / order ;

define age / order ;

compute first ;

\* create flover text which will be full name, based on first name ;

call define(\_col\_,
\"style\",\"style=\[flyover=\"\|\|quote(trim(put(first,\$full.)))\|\|\"\]\");

endcomp ;

run ;

ods html close ;

**Output**

***The SAS System***

**first**

**sex**

**age**

**Fly**

jenny

F

4

.

wilma

 

19

.

fred

M

21

.

barney

 

33

.

john

 

50

.

ronald

 

99

.

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
