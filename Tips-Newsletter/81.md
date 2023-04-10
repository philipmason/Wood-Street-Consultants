Daily Tip 81 20/11/2003 7:30 PM

**Changing orientation of RTF output**

When using ODS to produce RTF output, you can define the orientation to
use -- either Landscape or Portrait by using the orientation option. By
using this option in SAS 8.2 you can choose an orientation, but can't
change it for a single RTF file. However using SAS 9 you can change the
orientation during production of a single RTF file. The following
example shows this.

ods rtf file = \'c:\\test.rtf\';

\* This will be in Portrait orientation since that is the default ;

**proc** **print** data = sashelp.class;

**run**;

options orientation = landscape;

\* The option has changed, but now we need to tell RTF that it changed ;

ods rtf;

\* Now this will be in landscape ;

**proc** **print** data = sashelp.class;

**run**;

ods rtf close;

Example tested under SAS 8.2, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
