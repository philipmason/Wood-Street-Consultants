ods html body='c:\body.html'
         contents='c:\contents.html'
         page='c:\page.html' 
         frame='c:\frame.html' ;
proc sort data=sashelp.prdsale ;
  by country region ;
proc print data=sashelp.prdsale ;
  by country region ;
run ;
ods html close ;
dm "wbrowse 'c:\frame.html'" ;
