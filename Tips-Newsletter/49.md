Daily Tip 49 09/07/2003 10:12 AM

**Logic & Functions**

There is a useful page of links with interesting tips about logic &
functions in the data step. You can find it at
[http://support.sas.com/techsup/faq/data_step/logifunc.html]{.underline} -
but I have summarized some of the gems of information below.

**How to find week of year for a date variable datevar**

data getweek;

datevar=today();

week=intck(\'week\',intnx(\'year\',datevar,0),datevar)+1;

run;

**How to calculate age**

data one;

bday=\'19jan1973\'d;

current=today();

age=int(intck(\'month\',bday,current)/12);

if month(bday)=month(current) then

age=age-(day(bday)\>day(current));

run;

**How to calculate the value of pi**

Before version 7 use ...

pi=arcos(-1);

From version 7 use ...

pi=constant(\'pi\');

**How to calculate factorials**

Before version 7 use ...

sixfact=gamma(7);

From version 7 use ...

sixfact=fact(6);

**Inverse trigonometry functions**

inv(cosh)

arcosh_x=log(x+sqrt(x\*\*2-1));

inv(sinh)

arsinh_x=log(x+sqrt(x\*\*2+1));

inv(tanh)

artanh_x=0.5\*log((1+x)/(1-x));

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
