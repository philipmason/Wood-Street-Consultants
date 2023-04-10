Daily Tip 73 09/10/2003 12:34 PM

**Are your random numbers really random?**

It is important to understand how random numbers work in SAS. If you set
an initial seed value for the CALL RANUNI routine or the RANUNI
function, you will get a sequence of random numbers which are
repeatable. If you use the same seed again, you will get the same
series.

If you change the seed using the CALL RANUNI routine, then you will
begin a new sequence of random numbers. If you change the seed using the
RANUNI function, then it makes no difference at all. The first seed used
with the RANUNI function selects the series of random numbers, and each
other call of the function ignores the seed provided.

Call RANUNI ...
[http://v8doc.sas.com/bin/ixcgisol/sashtml/lgref/z0127852.htm]{.underline}

***SAS Program***

**data** case;

retain Seed_1 Seed_2 Seed_3 **1** ;

do i=**1** to **10**;

call ranuni(Seed_1,X1) ; \* call with unchanging seed ;

call ranuni(Seed_2,X2) ; \* call with seed changing half way through ;

X3=ranuni(Seed_3) ; \* function with seed changing half way through ;

output;

\* change seed for last 5 rows ;

if i=**5** then

do;

Seed_2=**2**;

Seed_3=**2**;

end;

end;

**run**;

**proc** **print**;

id i;

var Seed_1-Seed_3 X1-X3;

**run**;

***SAS Output***

I SEED_1 SEED_2 SEED_3 X1 X2 X3

1 397204094 397204094 1 0.18496 0.18496 0.18496

2 2083249653 2083249653 1 0.97009 0.97009 0.97009

3 858616159 858616159 1 0.39982 0.39982 0.39982

4 557054349 557054349 1 0.25940 0.25940 0.25940

5 1979126465 1979126465 1 0.92160 0.92160 0.92160

6 2081507258 794408188 2 0.96928 0.36993 0.96928

7 1166038895 2019015659 2 0.54298 0.94018 0.54298

8 1141799280 1717232318 2 0.53169 0.79965 0.53169

9 106931857 1114108698 2 0.04979 0.51880 0.04979

10 142950581 1810769283 2 0.06657 0.84321 0.06657

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
