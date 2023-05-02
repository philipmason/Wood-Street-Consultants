data _null_ ;
  set sashelp.prdsale ;
  put actual-numeric-month ; * numeric range ;
  put country-character-product ; * character range ;
run ;
