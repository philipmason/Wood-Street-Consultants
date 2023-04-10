Daily Tip 42 26/06/2003 8:30 AM

**Using ODS Markup to create datastep code**

ODS Markup is an experimental ODS destination in SAS 8.2. It can display
data by using one of many different markup languages. Additionally it is
very flexible by allowing the use of custom tagsets. These tagsets
define how to layout the data.

The example below demonstrates the flexibility of the Markup destination
by using a tagset which produces SAS datastep code which will reproduce
the data selected.

For more information see paper by Brian T. Schellenberger (SAS
Institute) called *"Reintroduction to ODS:*

*The Philosophy of the Output Delivery System; or, How to Find Your Way
Around All Those Features" -
[http://support.sas.com/rnd/base/topics/odsprinter/intro.pdf]{.underline}*

**SAS Code**

proc template;

define tagset Tagsets.datastep;

notes \"This is the Datastep definition\";

define event table;

start:

put \"data;\" NL;

finish:

put \"run;\" NL;

end;

define event row;

finish:

put NL;

end;

define event table_head;

start:

put \"input \";

finish:

put \";\";

end;

define event table_body;

start:

put \"cards;\" NL;

end;

define event header;

start:

trigger data;

finish:

trigger data;

end;

define event data;

start:

put \" \" VALUE;

end;

end;

run;

ods markup type=datastep

file=\"b_out.sas\" ;

proc print data=sashelp.class ;

run ;

ods markup close ;

**Contents of b_out.sas**

data;

input Obs Name Sex Age Height Weight

;cards;

1 Alfred M 14 69.0 112.5

2 Alice F 13 56.5 84.0

3 Barbara F 13 65.3 98.0

4 Carol F 14 62.8 102.5

5 Henry M 14 63.5 102.5

6 James M 12 57.3 83.0

7 Jane F 12 59.8 84.5

8 Janet F 15 62.5 112.5

9 Jeffrey M 13 62.5 84.0

10 John M 12 59.0 99.5

11 Joyce F 11 51.3 50.5

12 Judy F 14 64.3 90.0

13 Louise F 12 56.3 77.0

14 Mary F 15 66.5 112.0

15 Philip M 16 72.0 150.0

16 Robert M 12 64.8 128.0

17 Ronald M 15 67.0 133.0

18 Thomas M 11 57.5 85.0

19 William M 15 66.5 112.0

run;

> **Note:** The problem I covered in SASTip3 with the KEEP= dataset
> option was fixed in version 8 of SAS. This means the following syntax
> can be inefficient in version 6, but not versions 8 & 9.
>
> **proc sort data=big(keep=name phone) ;**
>
> **by name ;**
>
> **run ;**

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
