Daily Tip 82 24/11/2003 11:32 AM

**Generating graphs automatically for some procedures**

There is a new feature available for some procedures in SAS 9 which will
produce a graphic automatically for certain statistical procedures that
are used. One such procedure is PROC LIFETEST. To get the graph you
simply turn ODS GRAPHICS ON and then choose the graph required using the
plots=(variable) option on proc lifetest.

***Sample code***

ods listing close ;

ods html file=\'lifetest.html\' style=mystyle;

ods graphics on;

**proc** **lifetest** data=sasuser.fitness;

time age;

survival confband=all plots=(hwb);

**run**;

ods graphics off;

ods html close;

***Graph produced***

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
