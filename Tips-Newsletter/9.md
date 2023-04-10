Daily Tip 9 Created on Tuesday, 29 April 2003

**Graph & table in a Word document**

Here is some [simple]{.underline} ODS code to show how easy it is to put
a graph & table on a single page in a MS Word document. Important
features of the code are:

> • *Goption Reset=all*, ensures all graphic options are reset to
> default before changing ones we want to
>
> • *Device=jpeg*, needed to specify device driver to use for producing
> graph
>
> • *Ods rtf*, specifies that we want to produce RTF output which can be
> read by MS Word
>
> • *File='c:\\gt.rtf'*, is the name of the rtf file we are making
>
> • *Startpage=no*, tells ODS to not go to a new page after each
> procedure

For info on ODS RTF, see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../odsug.hlp/a002233360.htm]{.underline}

For info on goptions device=, see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../graphref.hlp/gopdict-device.htm]{.underline}

***SAS Program***

goptions reset=all device=jpeg ;

Ods rtf file=\'c:\\gt.rtf\' startpage=no ;

**proc** **gchart** data=sashelp.class ;

vbar3d age;

**run**;

**proc** **print** data=sashelp.class ;

**run**;

ods rtf close ;

Note: [Pharmasug 2003]{.underline} is in Miami, May 4-7 2003. I will be
presenting a ½ day course \"[SAS Tips & Techniques]{.underline}\" and a
paper in Coders Corner \"[Customising ODS output for Microsoft Word
using DDE]{.underline}\". Hope to meet some of you there.

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
