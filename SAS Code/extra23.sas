proc registry list startat="CORE\PRINTING\PAPER SIZES";
run;
* We can set the paper size to a pre-defined size, or enter measurements ;
options papersize=a3;
* Now we produce output and can verify in MS Word 
  that the page size is A3 as selected ;
ods rtf file='c:\test.rtf' ;
proc print data=sashelp.prdsale;
run ;
ods rtf close ;
