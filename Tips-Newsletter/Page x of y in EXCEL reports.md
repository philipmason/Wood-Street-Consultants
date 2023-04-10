Daily Tip 18 19/05/2003 4:03 PM

**Page x of y in EXCEL reports**

The wonders of ODS were revealed to me at Pharmasug by Chevell Parker
from SAS Institute. This tip is based on one of the many great examples
in his paper "Generating Custom Excel Spreadsheets using ODS".

Using the HTMLCSS destination we can write an HTML file and CSS file.
Since we name the spreadsheet using an XLS suffix it will be opened by
EXCEL. EXCEL will then import the HTML into a spreadsheet. The headtext
option on the ODS statement puts the text in quotes into our HTML code.
That text uses special XML MS Office commands to set a header and footer
in our EXCEL file.

In the header we use:

> • &P - current page number
>
> • &N - total number of pages

In the footer we use:

> • &L - left justify text
>
> • &C - centre text
>
> • &R - right justify text
>
> • &D - date
>
> • &T - time

For more information on the MS Office XML commands see --
[msdn.microsoft.com/library/default.asp?url=/library/en-us/dnoffxml/html/ofxml2k.asp]{.underline}

***SAS Program***

ods htmlcss file=\'c:\\temp.xls\'

stylesheet=\"c:\\temp.css\"

headtext=\'\<style\> \@Page {mso-header-data:\"Page &P of &N\";

mso-footer-data:\"&Lleft text &Cpage &P&R&D&T\"} ;

\</style\>\' ;

**proc** **print** data=sashelp.prdsale ;

**run** ;

ods htmlcss close ;

*Example tested under SAS 8.2 & 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
