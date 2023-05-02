Sample code for RTF
ods escapechar = '\';
title 'This document will have page x of y '
      j=r 'Page \{pageof}' ;
ods rtf file='c:\test.rtf' ;
proc print data=sashelp.prdsale;
run;
ods rtf close;

Sample code for PDF
ods escapechar = '\';
title 'This document will have page x of y '
      j=r 'Page \{thispage} of \{lastpage}' ;
ods pdf file='c:\test.pdf' ;
proc print data=sashelp.prdsale;
run;
ods pdf close;
