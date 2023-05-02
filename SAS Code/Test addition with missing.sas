data a ;
  x=1 ; output ;
  x=2 ; output ;
  x=. ; output ;
run ;

data _null_ ;
  retain z 0 ;
  set a ;
  y + x ;
  z=z + x ;
  put x= y= z= ;
run ;
