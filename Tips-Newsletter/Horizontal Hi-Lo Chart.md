Daily Tip 63 27/08/2003 7:52 AM

**Horizontal Hi-Lo Chart**

By default, SAS creates vertical hi-lo charts and unfortunately there is
no way to create horizontal ones. What we can do is create a vertical
chart and then turn our axes values ninety degrees around on the bars,
making our output appear as a horizontal chart.

***SAS Program***

goptions reset=all ;

axis1 major=none minor=none label=none value=none;

axis2 value=(angle=**90**) label=none;

axis3 value=(angle=**90**);

symbol1 i=none;

symbol2 i=hilot;

**proc** **gplot** data=sasuser.houses;

plot price\*style=**1** / vaxis=axis1 haxis=axis2;

plot2 price\*style=**12** / vaxis=axis3;

**run**;

quit;

Note: This tip is taken from "Tips from the Techies Technical Support,
SAS South Pacific" by Masrur Khan and Peter Mallik -- you can find the
full PowerPoint file on the support.sas.com website.

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason

**Remember**: I am offering 3 courses at NESUG next week -- to register
go to [www.nesug.org]{.underline}
