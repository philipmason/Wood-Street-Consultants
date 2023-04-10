Daily Tip 17 16/05/2003 8:38 PM

**Using wildcards for file lists**

From SAS 8 onwards (depending on operating system) you can use wildcards
to describe external filenames defined via a fileref. This enables you
to write more flexible code, which will match the files in existence as
it runs. It also provides a short-hand way to describe a range of files.

The example below shows how I could read from all text files in a
directory by using *'\*.txt'* to match all files with a file type of
*txt*.

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/hostwin.hlp/refextfile.htm&query=wildcard#a000115463]{.underline}

***SAS Log***

filename c_all 'c:\\\*.txt' ;

57 filename c \'c:\\\*.txt\' ;

58 data test ;

59 infile c ;

60 input ;

61 run ;

NOTE: The infile C is:

File Name=c:\\test.txt,

File List=c:\\\*.txt,RECFM=V,LRECL=256

NOTE: The infile C is:

File Name=c:\\dumpconsole.txt,

File List=c:\\\*.txt,RECFM=V,LRECL=256

NOTE: 0 records were read from the infile C.

NOTE: 0 records were read from the infile C.

NOTE: The data set WORK.TEST has 0 observations and 0 variables.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
