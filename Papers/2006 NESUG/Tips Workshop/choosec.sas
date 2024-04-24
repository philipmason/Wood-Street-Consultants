*** CHOOSEC & CHOOSEN ;
data _null_ ;
  third=choosec(3,'dog','cat','rat','bat') ;
  put third= ;
  last=choosec(-1,'dog','cat','rat','bat') ;
  put last= ;
run ;
