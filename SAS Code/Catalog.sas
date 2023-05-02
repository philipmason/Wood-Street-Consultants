filename test catalog 'sashelp.assist.houses.source' ;
data _null_ ;
  infile test ;
  input ;
  put _infile_ ;
run ;
