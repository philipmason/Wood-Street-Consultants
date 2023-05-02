*** Original *** ;
data test ;
  set sasuser.houses ;
run ;

proc sort data=test ;
  by style price ;
run ;

*** Improved *** ;
data test1 / view=test1 ;
  set sasuser.houses ;
run ;

proc sort data=test1 out=test2 ;
  by style price ;
run ;
