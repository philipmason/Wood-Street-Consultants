Daily Tip 3 Created on Thursday, 17 April 2003

**Several ways to tune a SORT**

Here is a brief (& incomplete) list of things you can look at if you
want to make your PROC SORT go faster. Always test the methods and
combinations of them to see what works best for you.

> • Use version 9, which uses a product called SYNCSORT to perform
> sorts, which is usually faster than the old SAS sort. It is also
> multi-threaded to make use of multiple processors.

Proc sort data=x threads ;

> • Use TAGSORT where the BY variables combined length is short compared
> to observation length and dataset is huge.

Proc sort data=x tagsort ;

> • Usually don't need order maintained, so specify NOEQUALS

proc sort data=data-set NOEQUALS ;

> • More sort work datasets on some operating systems such as MVS

Options sortwkno=6 ;

> • Reduce observations sorted by using a WHERE clause

proc sort data=xxx(where=(price\>1000)) out=yyy ;

> • Can use all available memory for sorting

options sortsize=max ;

> • If data is grouped, but not sorted, then use NOTSORTED to avoid the
> need to sort.

proc print data=calendar ;

by month NOTSORTED ;

> • If external data is pre-sorted, perhaps coming from another database
> via an import then tell SAS it is sorted in a particular order.

Data new(SORTEDBY=year month) ; Set x.y ; run ;

> • Reduce variables sorted with KEEP dataset option, but beware that
> using the following syntax will not help. This is because the KEEP is
> applied after the observations have been sorted. Kind of like applying
> it to the output, rather than the input.

proc sort data=xxx(keep=a b c d e) ;

by a ;

run ;

> You can use the following syntax to force the keep to apply to the
> input. The view only returns the variables kept to the PROC SORT. That
> works best for long observation lengths where we only want to keep a
> small amount of the data.

data yyy / view=yyy ;

set xxx(keep=a b c d e) ;

run ;

proc sort data=yyy out=xxx ;

by a ;

run ;

See the following for more information no **Proc Sort** -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../proc.hlp/a000057941.htm]{.underline}

*Examples for illustration only and not tested* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
