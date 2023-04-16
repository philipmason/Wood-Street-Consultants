Daily Tip 61 25/08/2003 4:54 PM

**ODS - expanding your tagsets**

The MARKUP destination in ODS is supported in SAS 9 and experimental in
8.2. You can however get advanced access to some of the new tagsets from
SAS 9 by downloading the latest tagsets from
[http://support.sas.com/rnd/base/index-xml-resources.html]{.underline}.
Simply go to this web page, download the tagset definitions, which are
in the form of a SAS program, and run it in SAS 8.2 or SAS 9. You will
then have the latest tagsets available.

One tagset you get which is not available in SAS 8.2 is HTML4. This
allows you to produce version 4 HTML code, rather than version 3.2 which
the HTML destination produces. The following log shows how to produce a
file containing HTML version 4 markup language.

***SAS Log***

5 ods markup tagset=html4 file=\'c:\\test.html\' ;

WARNING: MARKUP is experimental in this release.

NOTE: Writing MARKUP file: c:\\test.html

6 proc means data=sashelp.class nway ;

7 run ;

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: PROCEDURE MEANS used:

real time 0.05 seconds

cpu time 0.01 seconds

ods markup close ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
