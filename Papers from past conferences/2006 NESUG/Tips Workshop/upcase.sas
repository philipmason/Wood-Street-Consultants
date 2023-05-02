*** IGNORING CASE FOR COMPARISONS ;
proc print data=sashelp.class ;
  where upcase(name)='BARB' ;
run ;

