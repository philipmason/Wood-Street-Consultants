Daily Tip 56 23/07/2003 10:58 PM

**Browsing external files**

From SAS 8 onwards Proc FSList & the FSList command are part of base SAS
-- which means you can use them even if you don't have SAS/FSP. They are
useful if you want to browse the contents of text in a file from within
SAS, since they open a window and display the file contents.

To browse a text file from the command line you can enter a command like
this ...

fslist \'c:\\frame.html\'

To open a selection window to allow you to choose a file to browse you
can enter the following on the command line ...

fslist

Or you could run the procedure like this ...

**proc** **fslist** file=\'c:\\config.sas\';

**run** ;

Information on FSLIST is at
[http://v8doc.sas.com/bin/ixcgisol/sashtml/proc/z0327036.htm]{.underline}
and on PROC FSLIST is at
[http://v8doc.sas.com/bin/ixcgisol/sashtml/proc/z0327035.htm]{.underline}

*Note: Another more reliable source for wrdbasic.hlp in yesterdays tip
is [http://nature.berkeley.edu/\~alyons/ftp/wrdbasic.zip]{.underline}*

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
