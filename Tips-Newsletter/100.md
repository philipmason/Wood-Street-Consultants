Daily Tip 100 13/05/2004 4:12 PM

**Getting the date, time & size of a non-SAS file**

There are useful functions within SAS which can be used to tell you
about SAS files (datasets, catalogs, etc.) but if you want information
about other files then you may need to use other techniques. Here is one
that is handy under windows and demonstrates some useful techniques.

1 -- we generate a directory listing and read it via a pipe
[http://v8doc.sas.com/bin/ixcgisol/sashtml/win/zunnamed.htm]{.underline}

2 -- we read the required information from that listing

3 -- we write the information into macro variables, which are defined
globally so they can be used throughout SAS
[http://v8doc.sas.com/bin/ixcgisol/sashtml/macro/z0206954.htm]{.underline}

4 -- we make use of field justification to ensure that our comma
formatted file size is left justified, rather than right
[http://v8doc.sas.com/sashtml/lgref/z0199354.htm]{.underline}

**Example SAS Program**

**%macro** getstats(dir_cmd) ;

filename cmd pipe \"&dir_cmd\" ;

data \_null\_ ;

infile cmd truncover ;

\* This works on windows XP Professional, but on other version you might
need to adjust the settings to

read the information you want from different positions ;

input \#**6** @**1** date ddmmyy10.

@**13** time time5.

@**20** size comma17. ;

\* Now write the data to macro variables to be used ;

call symput(\'\_date\',put(date,date9.)) ;

call symput(\'\_time\',put(time,time5.)) ;

\* note we use left justification within formatted field , otherwise
number is right justified within field ;

call symput(\'\_size\',put(size,comma9. -l)) ;

run ;

%global \_date \_time \_size ;

**%mend** getstats ;

\%***getstats***(dir c:\\windows\\notepad.exe) ;

%put Date=&\_date Time=&\_time Size=&\_size ;

*Example tested under SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
