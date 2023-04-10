Daily Tip 44 01/07/2003 11:15 PM

**Undocumented special characters in ODS**

Here are some useful but undocumented character combinations you can use
in ODS. They can be useful to get your reports to be just how you want
them. Of particular use is the *set mark* which can be used to indent
text within a cell of ODS output (Proc Report, Tabulate, etc.). Also
very useful is *new-line* to force text within a cell to go to a new
line.

**\'03\'x\|\|\'\_\'**

Non-breakable space. The column width will be expanded in preference to
breaking here.

**\'03\'x\|\|\'m\'**

Set mark. This position will be remembered, and if the line is too long
and must be wrapped, it will wrap to here.

**\'03\'x\|\|\'n\'**

New-line. Forces a line-break here, as shown

These are described in a great paper written by Brian Schellenberger
(who is responsible for a huge amount of functionality in ODS -- thanks
Brian!) from SAS -

[http://support.sas.com/rnd/base/topics/odsprinter/qual.pdf]{.underline}

***SAS Program***

ods pdf file=\'c:\\test.pdf\' ;

**data**;

length a \$ **256** ;

a = \"First obs, not indented, and \" \|\|

\"of course wrapping to the start of the line since\" \|\|

\"it is too big to fit on just one line - see what I mean?\";

b = \"Another column, taking up some space\";

output;

a = \'03\'x \|\| \"m \" \|\| \'03\'x \|\| \"m\" \|\|

\"Second obs, indented, and \" \|\|

\"forced to wrap to the indent point even though\" \|\|

\"it is too big to fit on one line - see what I mean?\";

output;

**run**;

**proc** **report** noheader nowd ;

**run**;

ods pdf close ;

***SAS Output***

Note: If you haven't subscribed to the SAS Technology Report, I
recommend you do so. Find instructions at
[http://www.sas.com/news/newsletter/index.html]{.underline}

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
