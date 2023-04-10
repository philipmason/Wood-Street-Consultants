Daily Tip 52 14/07/2003 5:42 PM

**Flexible date formats**

There are a number of date formats which are useful when you want to
vary the separators used. These are MMDDYYxw, DDYYMMxw and YYMMDDxw. The
x specifies a separator or no separator, where:

> • B separates with a blank
>
> • C separates with a colon
>
> • D separates with a dash
>
> • N indicates no separator
>
> • P separates with a period
>
> • S separates with a slash.

The w specifies the width of the output field (Default: 8). Range: 2-10.

Note that when w is from 2 to 5, SAS prints as much of the month and day
as possible. When w is 7, the date appears as a two-digit year without
separators, and the value is right aligned in the output field.

**SAS Log**

13 data \_null\_ ;

14 now=today() ;

15 put \'Blanks \... \' now yymmddb8. ;

16 put \'Colon \... \' now yymmddc8. ;

17 put \'Dash \... \' now yymmddd8. ;

18 put \'No Separator \... \' now yymmddn8. ;

19 put \'Period \... \' now yymmddp8. ;

20 put \'Slash \... \' now yymmdds8. ;

21 run ;

Blanks \... 03 07 18

Colon \... 03:07:18

Dash \... 03-07-18

No Separator \... 20030718

Period \... 03.07.18

Slash \... 03/07/18

NOTE: DATA statement used:

real time 0.01 seconds

cpu time 0.01 seconds

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
