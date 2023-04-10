Daily Tip 126 22/04/2005 11:04:00

**Using the ZIP engine to read zip files**

There is a currently undocumented filename engine available in SAS 9
that can be used to read from compressed ZIP files directly. You simply
specify the engine "SASZIPAM" on a filename statement, and when
referring to it you must specify the file within it that you wish to
read. In the example below "tomcat.zip" contains a number of files. I
want to read "tomat.log" and therefore specify "in(tomcat.log)", where
"in" is the libref and "tomcat.log" is the file I will read from the zip
file.

**Sample SAS Program**

filename in saszipam \'c:\\tomcat.zip\';

**data** \_null\_;

infile in(tomcat.log);

input ;

put \_infile\_;

if \_n\_\>**10** then

stop ;

**run**;

**Sample SAS Log**

4 filename in saszipam \'c:\\tomcat.zip\';

5 data \_null\_;

6 infile in(tomcat.log);

7 input ;

8 put \_infile\_;

9 if \_n\_\>10 then

10 stop ;

11 run;

NOTE: The infile library IN is:

Stream=c:\\tomcat.zip

NOTE: The infile IN(tomcat.log) is:

File Name=tomcat.log,

Compressed Size=1894,Uncompressed Size=15793,

Compression Level=-1,Clear Text=Yes

Using CATALINA_BASE: C:\\Tomcat4.1

Using CATALINA_HOME: C:\\Tomcat4.1

Using CATALINA_TMPDIR: C:\\Tomcat4.1\\temp

Using JAVA_HOME: C:\\j2sdk1.4.2_04

Using Security Manager

Starting service Tomcat-Standalone

Apache Tomcat/4.1.18

INFO: System properties were read from a file.

This discovery service deployment looks up remote services.

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--

NOTE: A total of 11 records were read from the infile library IN.

NOTE: 11 records were read from the infile IN(tomcat.log).

NOTE: DATA statement used (Total process time):

real time 0.78 seconds

cpu time 0.06 seconds

**References**

> • SUGI paper & examples ...
> [http://www.devenezia.com/papers/sugi-29/sugi-29-devenezia.pdf]{.underline}
> and
> [http://www.devenezia.com/papers/sugi-29/examples/example12-readzipped\...]{.underline}
>
> • Threads from SAS-L ... [http://xrl.us/ffcd]{.underline}

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
