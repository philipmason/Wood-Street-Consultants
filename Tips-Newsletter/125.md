Daily Tip 125 21/04/2005 12:27:00

**New IF functions**

> It's always worth looking at "What's New" for the latest SAS release.
> It often reveals very useful new additions, which often turn out to be
> available in prior releases of SAS also, though they are undocumented
> there. See
> [http://support.sas.com/software/91x/lrdictwhatsnew900.htm]{.underline}
> which describes what is new in SAS 9.1.3 Base SAS.
>
> Two of the more useful new functions are the IFN & IFC functions.
> These are useful for more efficient coding and can be used anywhere a
> function can be used, even in where clauses or macro language (using
> %sysfunc). In fact using the IF functions from macro language means
> that you can use IF logic in open code, rather than being forced to
> use a macro program.

**[IFN(condition, true-numeric-value, false-numeric-value,
missing-numeric-value)]{.underline}**

IFN returns a numeric value. It returns the true, false or missing value
depending on whether the condition is true, false or missing.
Documentation is at
[http://support.sas.com/91doc/getDoc/lrdict.hlp/a002604573.htm]{.underline}

**[IFC(condition, true-character-value, false-character-value,
missing-character-value)]{.underline}**

> IFC returns a character value. It returns the true, false or missing
> value depending on whether the condition is true, false or missing.
> Documentation is at
> [http://support.sas.com/91doc/getDoc/lrdict.hlp/a002604570.htm]{.underline}

**Example SAS Log**

21 \* without IFN function ;

22 data test1 ;

23 set sashelp.class ;

24 \* set entry price based on age ;

25 if age\>=13 then

26 price=12.50 ;

27 else

28 price=8 ;

29 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set WORK.TEST1 has 19 observations and 6 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

30 \* with IFN function ;

31 data test2 ;

32 set sashelp.class ;

33 \* set entry price based on age ;

34 price=ifn(age\>=13,12.50,8) ;

35 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set WORK.TEST2 has 19 observations and 6 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

36 %put %sysfunc(ifc(&sysscp=WIN,You are using Windows!,You are not
using Windows)) ;

You are using Windows!

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
