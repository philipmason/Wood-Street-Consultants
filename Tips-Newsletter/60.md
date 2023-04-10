Daily Tip 60 13/08/2003 8:54 AM

**Combining small values**

Sometimes you might want to combine many small, insignificant values
before you display the data to a user. This can highlight the larger
more significant figures and unclutter reports and graphic legends. In
applications where many kinds of data are involved it is advantageous to
use generalised techniques to do this.

Below is a macro which can be used to combine small values in a
subgrouped bar chart. It can also be easily adapted to work with other
data. Additionally, by adding a where clause to the Proc Gchart we could
exclude all small values, only charting the large ones.

***SAS Code***

**%macro** limit(limit=**0.01**,

class1=a,

class2=b,

anal=x,

more=**.**,

in=in,

out=out) ;

\* Limit \... values less that this percentage are combined ;

\* class1 \... 1st classification variable ;

\* class2 \... 2nd classification variable ;

\* anal \... analysis variable ;

\* more \... value to use for values that are combined ;

proc sql ;

create table &out as

select &class1,

&class2,

sum(&anal) as &anal

from (select &class1,

case when(&anal/sum(&anal)\<&limit) then &more

else &class2

end as &class2,

&anal

from &in

group by &class1)

group by &class1,

&class2 ;

quit ;

**%mend** limit ;

\*\*\* Create test data ;

**data** in ;

do a=**1** to **10** ;

do b=**1** to **100** ;

x=ranuni(**1**)\***100** ;

output ;

end ;

end ;

**run** ;

filename graph \'c:\\g1.png\' ;

goptions device=png gsfname=graph ;

**proc** **gchart** data=in ;

vbar a / subgroup=b sumvar=x discrete ;

**run** ; quit ;

\*\*\* Use limit macro to avoid large confusing legends and
imperceptibly tiny bar segments ;

\%***limit***(limit=**0.02**) ;

filename graph \'c:\\g2.png\' ;

**proc** **gchart** data=out ;

vbar a / subgroup=b sumvar=x discrete ;

**run** ; quit ;

***Default Graph produced***

***Graph with small values combined***

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
