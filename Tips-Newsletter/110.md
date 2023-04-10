Daily Tip 110 29/10/2004 14:51:00

**Reading more complex XML files**

SAS 9 has great XML support, and can read basic XML very easily using
the XML engine. You can also use XML maps to read more complex XML
files. However I have found that this can be cumbersome (or almost
impossible) to use if you have a hierarchical XML file with many levels,
which can change its structure without notice.

To get around this I have written some code to process more complex XML
files.

**%macro** xml_reader(path=D:\\My Documents\\Work\\National
Statistics\\Aggregate,

file=hier1.xml,

out=hier,

linelen=**200**,

maxlev=**99**,

pc=**0**) ;

\* path, physical path to directory where XML file is located ;

\* file, name of XML file ;

\* out, name of SAS dataset to create ;

\* linelen, maximum length of XML line to read in ;

\* maxlev, maximum number of levels in XML hierarchy ;

\* pc, 0=normal XML processing, 1=parent/child processing ;

\*\*\* NOTE: there are other ways to import XML which are easier, but
these dont work

for all types of XML. If it is a simple \"tabular\" XML file, you can
possibly

use the XML engine to process it. XML produced from other databases for

export is likely to be in this form. If it is a little more complex you
can use

the XML mapping utility to create an XML map and then use the XML engine

to process it. This code is useful when you have a multi level hierarchy
or

a more complex structure ;

\* point to the XML file ;

filename in \"&path\\&file\" ;

data &out(keep=lev: text parent child) ;

array lev(\*) \$ &linelen lev01-lev&maxlev ;

retain level max **0**

lev: ;

length line text \$ &linelen ;

infile in truncover end=end ;

input line \$&linelen.**.** ;

\* last time through write out the maximum level we got to in the XML ;

if end then

call symput(\'max\',max) ;

\* find tag ;

start=index(line,\'\<\') ;

\* handle case when we dont have any tags on line ;

if start=**0** then

do ;

text=line ;

output ;

return ;

end ;

put start=;

\* throw away any characters that may be before the first tag - need to
fix this later to keep these ;

line=substr(line,start) ;

put line=;

c=count(line,\'\<\') ;

\* get each tag from line - handles multiple tags on a line ;

do i=**1** to c ;

tag=scan(line,i,\'\<\>\') ;

\* throw away ?xml tag ;

first=substr(tag,**1**,**1**) ;

if first in (\'?\',\'!\') then

delete ;

if first=\'/\' then

do ;

dont_write=**1** ;

lev(level)=\' \' ;

level+(-**1**) ;

end ;

else

do ;

dont_write=**0** ;

plus=**1** ;

level+**1** ;

\* remember maximum level so we can drop variables we dont want ;

max=max(max,level) ;

lev(level)=tag ;

end ;

end=index(line,\'\>\') ;

\* get rest of line excluding tag just read ;

line=substr(line,end+**1**) ;

start=index(line,\'\<\') ;

if start\>**1** then

text=substr(line,**1**,start-**1**) ;

if not dont_write then

do ;

if plus & level\>**1** then

do ;

parent=lev(level-**1**) ;

child=lev(level) ;

end ;

output ;

end ;

end ;

run ;

filename in ;

%let dropfrom=%eval(&max+1) ;

%let len=%length(&maxlev) ;

%if &pc %then

%do ;

data &out ;

set &out(keep=parent child) ;

where parent\>\'\' & child\>\'\' ;

run ;

proc sort data=hier nodupkey ;

by parent child ;

run ;

%end ;

%else

%do ;

data &out ;

set &out(drop=parent child
lev%sysfunc(putn(&dropfrom,z&len.**.**))-lev&maxlev) ;

run ;

%end ;

\* browse the XML produced ;

dm \"vt &out\" vt ;

**%mend** xml_reader ;

options mprint ;

\* need to check xml spec and see that I handle various things ;

\* need to test on various XML layouts ;

\* need to handle XML stream as input, rather than a file ;

**Sample data**

If you want to try my code on a sample XML file, then you can save this
file and use the sample invocations below,
[http://www.w3schools.com/xml/cd_catalog.xml]{.underline}

**Sample invocations**

\%***xml_reader***(file=cd_catalog.xml) ;

\%***xml_reader***(file=cd_catalog.xml,pc=**1**) ;

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
