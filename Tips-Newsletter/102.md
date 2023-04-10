Daily Tip 102 17/06/2004 9:34 AM

**Adding a progress "bar" to a data step**

If you have a long running data step then you may find yourself sitting
there wondering if SAS is actually doing anything or not. One way to
indicate what is happening is to display an indicator of progress to the
user. The following macro will show the number of the record currently
being read in. If you were to show this for every record it would slow
down the data step while the display was updated, so you specify how
often to update the display. Typically updating about every 1000 records
will give a good indication without slowing things down.

**The PROGRESS macro**

**%macro** progress(every) ;

window progress irow=**4** rows=**7** columns=**40**

\#**1** @**6** \'Processing record: \' \_n\_ persist=yes ;

if mod(\_n\_,&every)=**0** then

display progress noinput ;

**%mend** progress ;

**How to use it**

All you need to do is to add the macro call to your data step. The
following data step updates the record count every 1000 records read in.

**data** x ;

infile \'m:\\datasets\\x.txt\' ;

input name \$30. phone \$18. ;

\%***progress***(**1000**) ;

**run** ;

*Example tested under SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
