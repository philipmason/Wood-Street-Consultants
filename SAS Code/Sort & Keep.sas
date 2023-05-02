data x ;
  array x(99) $ 200 ;
  do i=1 to 1000 ;
    output ;
  end ;
run ;

proc sort data=x(keep=x1) out=temp ;
  by x1 ;
run ;

data y / view=y ;
  set x(keep=x1) ;
run ;

proc sort data=y out=temp ;
  by x1 ;
run ;

data z2 ;
  set x(keep=x1) ;
run ;

proc sort data=z2 out=temp ;
  by x1 ;
run ;
