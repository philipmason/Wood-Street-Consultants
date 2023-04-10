Daily Tip 55 22/07/2003 10:39 PM

**Using DDE for customising MS Word output**

The following program shows an example of how to make use of DDE
(Dynamic Data Exchange) to send commands to MS Word. This can be very
useful when you can't quite get ODS to produce your ideal output.

The example uses commands to combine a graphic and a report, giving each
a different page orientation and using MS Word headers & footers.

The commands used with DDE for MS word are documented in the
hard-to-find help file called "wrdbasic.hlp" which can be found by
searching the internet. I found one reference to it at
[http://www.buoyantsolutions.net/PUBLIC/DOWNLOAD/wrdbasic.zip]{.underline}
\... Once you find this file you will be able to do almost anything in
MS Word from a SAS program which you would otherwise need to do
manually.

**Sample SAS code**

\* make a sample report ;

ods rtf file=\'c:\\sample.rtf\' ;

**proc** **print** data=sashelp.class ; **run** ;

ods rtf close ;

\* Make a sample graph ;

filename out \'c:\\test.png\' ;

goptions device=png gsfname=out ;

**proc** **gchart** data=sashelp.class ;

hbar age ;

**run** ;

filename out ;

\* Microsoft Word must already be running ;

filename word dde \'MSWORD\|system\' ;

\* send DDE commands to MS WORD to combine files and create a new one ;

**data** \_null\_ ;

file word ;

put \'\[FileNew .Template = \"normal.dot\", .NewTemplate = 0\]\' ;

put \'\[toggleportrait\]\' ;

put \'\[ViewZoom .TwoPages\]\' ;

put \'\[ViewFooter\]\' ;

put \'\[FormatFont .Points=10, .Font=\"Arial\", .Bold=1\]\' ;

put \'\[FormatParagraph .Alignment=1\]\' ;

put \'\[Insert \"This is my footer\"\]\' ;

put \'\[ViewFooter\]\' ;

put \'\[ViewHeader\]\' ;

put \'\[Insert \"This is my lovely header\"\]\' ;

put \'\[ViewHeader\]\' ;

put \'\[InsertPicture .name=\"C:\\test.png\"\]\' ;

put \'\[WordLeft\]\' ;

put \'\[SelectCurWord\]\' ;

put \'\[FormatPicture .scalex=150, .scaley=150\]\' ;

put \'\[WordRight\]\' ;

put \'\[insertpagebreak\]\' ;

put \'\[InsertFile .name=\"C:\\sample.rtf\"\]\' ;

put \'\[FileSaveAs .name=\"c:\\test.doc\"\]\' ;

put \'\[FileClose\]\' ;

**run** ;

*Note: I could say a lot more about DDE, but this is a quick SAS tip
rather than a paper or training course. I happen to have written a paper
on DDE to Word and also have a DDE training course -- please ask if you
are interested.*

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
