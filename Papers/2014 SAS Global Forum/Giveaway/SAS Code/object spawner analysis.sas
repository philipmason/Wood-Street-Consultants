data objspawn ;
  infile '/sas/software/sasenvironmentv9/Lev1/SASMain/ObjectSpawner/logs/objspawn.log' truncover ;
/*  infile '/export/home/v2000927/objspawn.log' truncover ;*/
  length connection user $ 16 ;
  format date date9. time time. ;
  input @1 date yymmdd8.
        @10 time time11.
        @23 code 8. 
        @32 msg $200. ;
  if index(msg,'New client connection') then
    do ;
      connection=scan(msg,4,' ().') ;
      user=scan(msg,12,' ().') ;
      status='open  ' ;
    end ;
  else
    if index(msg,'Client connection') then
      do ;
        connection=scan(msg,3,' ().') ;
        status='closed' ;
      end ;
/*  _error_=1 ;*/
/*  if _n_>10 then stop ;*/
run ;
proc sort data=objspawn(where=(status>' ')) out=connections ;
  by connection descending status ;
run ;
data incomplete ;
  set connections ;
    by connection ;
  if first.connection & last.connection ;
run ;
data redirecting ;
  length port $ 8 ;
  set objspawn ;
  i=index(msg,'Redirecting') ;
  if i>0 ;
  port=substr(msg,index(msg,'port')+4) ;
run ;
proc freq data=redirecting ;
  table port ;
run ;
proc freq data=objspawn ;
  table code / out=code noprint ;
  table msg / out=msg noprint ;
run ;
proc sort data=code ; by descending count ; run ;
proc print data=code ; id code ; var count percent ; where count>1 ; run ;
proc sort data=msg ; by descending count ; run ;
proc print data=msg ; id msg ; var count percent ; where count>1 ; run ;
