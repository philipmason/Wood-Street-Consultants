Daily Tip 50 10/07/2003 6:32 AM

**Sorting array elements**

In SAS 9 there is a new routine which can be used to sort the values of
a list of variables passed to it. SORTN should be used for sorting
numerics, and SORTC for character values. If the variables belong to an
array then these sort routines effectively sort the values of the array.
The sorts are always done into ascending sequence, but by specifying the
variables in reverse order you can effectively sort in descending
sequence.

Note: character variables must be same length.

**SAS Log**

88 call sortn(of v50-v1);

89 put \'Down: \' v(1)= v(2)= v(3)= v(48)= v(49)= v(50)= ;

90 \* sort values between 3 character variables ;

91 \* note: character variables must be same length to avoid errors ;

92 x=\'3 dogs \' ;

93 y=\'1 cat \' ;

94 z=\'2 frogs\' ;

95 call sortc(x,y,z) ;

96 put x= y= z= ;

97 run ;

NOTE: The SORTN function or routine is experimental in release 9.0.

Up: v1=1 v2=2 v3=3 v48=48 v49=49 v50=50

Down: v1=50 v2=49 v3=48 v48=3 v49=2 v50=1

NOTE: The SORTC function or routine is experimental in release 9.0.

x=1 cat y=2 frogs z=3 dogs

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.01 seconds

Note: there was a mistake in SASTip49 with respect to "How to calculate
factorials". It should have said....

> • Before version 7 use ... sixfact=gamma(7);
>
> • From version 7 use ... sixfact=fact(6);

*Please feel free to pass this tip to your colleagues, and encourage
them to subscribe by sending an email to
[tips@woodstreet.org.uk]{.underline}*

*Example tested under SAS 9.08., Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
