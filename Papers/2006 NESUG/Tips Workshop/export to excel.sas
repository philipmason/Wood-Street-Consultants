/* EXPORTING TO EXCEL */

libname nice 'c:\workshop\hw06\nice.xls' ;

data nice.test ;
  set sashelp.class ;
run ;

libname nice ;
