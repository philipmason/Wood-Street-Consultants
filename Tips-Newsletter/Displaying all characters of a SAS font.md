Daily Tip 62 26/08/2003 9:33 PM

**Displaying all characters of a SAS font**

You can use the GFONT procedure to display the characters from one of
the SAS supplied fonts that come with SAS/Graph. This can be useful for
fonts which have special characters, so that you can see what characters
you must specify in order to get the special characters.

The following is a macro which will make a chart containing a list of
all characters within a font. The chart is saved into a graphic file.
You can then look at the chart to look up characters you want to use.

***SAS Program***

**%macro** showfont(font) ;

filename font \"c:\\&font..png\" ;

goptions reset=all device=png gsfname=font ;

title \"Font: &font\" ;

proc gfont name=&font

nobuild

height=**.4** cm

romcol=red

romfont=swissl

romht=**.3** cm

showroman ;

run;

quit;

**%mend** showfont ;

\%***showfont***(math)

\%***showfont***(greek)

***Charts produced***

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason

Remember: I am offering 3 courses at NESUG next week -- to register go
to [www.nesug.org]{.underline}
