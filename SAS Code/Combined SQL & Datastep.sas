data out / view=out ;
  set sasuser.houses ;
  if style='CONDO' then
    put 'obs=' _n_ price= ;
run ;
proc sql ;
  create table more as select * from out where price >100000 ;
;quit;run;
