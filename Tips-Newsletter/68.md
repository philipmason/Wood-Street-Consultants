Daily Tip 68 29/09/2003 5:38 PM

**Producing a spreadsheet for each BY group**

The following program shows how to use ODS to produce a separate file
for each BY group. This is done by using the **newfile=page** option. We
are using the HTML destination to produce files with an XLS suffix. This
means that EXCEL will be used to open the file (on many systems,
depending on preferences) when the files are opened; EXCEL then imports
the HTML to display the data as a spreadsheet.

We also use the ODS **path** option, to specify a base directory for all
other ODS files to use. This means that body files are written to
c:\\temp\\html and will be called body.xls, body1.xls, body2.xls, etc.

We also make use of the fact that we are using the HTML destination to
create an HTML **contents** file. This produces some HTML with links to
each of our spreadsheets, so we can conveniently see them all on one
page and click on the one we want to display.

***SAS Program***

ods listing close;

ods html path=\"c:\\temp\\\"

body=\"html\\body.xls\"

contents=\"contents.html\"

newfile=page;

**proc** **sort** data=sashelp.prdsale ;

by product ;

**run** ;

**proc** **tabulate** data=sashelp.prdsale ;

by product ;

class country region ;

var actual predict ;

table country all,

region all,

(actual predict)\*sum ;

**run** ;

ods html close ;

dm \"wbrowse \'c:\\temp\\contents.html\'\" wbrowse ;

P.S. According to the Forbes 400 list, Jim Goodnight is the 62^nd^
richest person in the United States (112^th^ in the world), with a net
worth of approximately 2.8 billion dollars.

Example tested under SAS 8.2, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
