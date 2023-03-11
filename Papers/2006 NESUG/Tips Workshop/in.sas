*** in ;
data sample ;
  set sashelp.class ;
  if age in (11, 13:15, 18:25) ;
run ;
