**** COUNTC ;

data _null_ ;
  long='a b c d a e d a e t g d a c s' ;
  num_a=countc(long,'a') ;
  put num_a= ;
run ;

*** COUNT ;

data _null_ ;
  long='dog cat rat bat dog camel dingo snake bigdog' ;
  num_dog=count(long,'dog') ;
  put num_dog= ;
run ;
