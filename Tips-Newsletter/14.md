Daily Tip 14 13/05/2003 11:41 PM

**Hardware vs. Software fonts in graphs**

If you have ever been disappointed by the quality of text in graphs then
you may not have made use of hardware fonts. It's easy to use them and
if you're using windows you can select true-type fonts easily. In the
following example I produce PNG format graphs, which are Portable
Network Graphics (these have some advantages over some other formats
which I will cover another time). Note that when using true-type fonts
you should put the font name in quotes, but if you use software fonts
then you don't use the quotes. e.g. *goptions ftext=swiss ;*

For info on the FTEXT goption see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/gopdict-ftext.htm]{.underline}

***SAS Program***

filename sw \'c:\\software font.png\' ; \* file to save graph using
software font ;

filename hw \'c:\\hardware font.png\' ; \* file to save graph using
hardware font ;

goptions reset=all gsfname=sw dev=png xmax=**6** ymax=**4**;

**proc** **gchart** data=sashelp.class;

vbar sex / sumvar=height ;

**run**;

\* produce second graph using the Arial Font with text height set to 6%
of total ;

goptions gsfname=hw ftext=\'Arial\' htext=**6**pct ;

vbar sex / sumvar=height ;

**run**;

**quit**;

**Software Font**

**Hardware Font**

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
