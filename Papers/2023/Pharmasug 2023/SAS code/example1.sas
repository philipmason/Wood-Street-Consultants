proc scaproc ;
   record "%sysfunc(pathname(work))/example1.txt";
run ;
data test ;
   set sashelp.prdsale sashelp.prdsal2 ;
run ;
proc scaproc ;
   write ;
run ;
