/* PAGE X OF Y IN RTF */

ods escapechar = '\';
title 'This document will have page x of y '
      j=r 'Page \{pageof}' ;
ods rtf file='c:\workshop\hw06\test.rtf' ;

proc print data=sashelp.prdsale;
run;

ods rtf close;




/* SAMPLE CODE FOR PDF */

ods escapechar = '\';
title 'This document will have page x of y '
      j=r 'Page \{thispage} of \{lastpage}' ;
ods pdf file='c:\workshop\hw06\test.pdf' ;

proc print data=sashelp.prdsale;
run;

ods pdf close;
