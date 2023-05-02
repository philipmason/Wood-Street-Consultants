proc format ;
  value test
    0='Y'
    1='N'
    2='Y'
    3='N'
    4='Y'
    5='N'
    6='Y'
    7='N'
    8='Y'
    9='N' ;
  value testb (fuzz=0)
    0='Y'
    1='N'
    2='Y'
    3='N'
    4='Y'
    5='N'
    6='Y'
    7='N'
    8='Y'
    9='N' ;
run ;

data _null_ ;
  do i=1 to 1e7 ;
    x=putn(MOD(i,10),'test.') ;
  end ;
run ;

data _null_ ;
  do i=1 to 1e7 ;
    x=putn(MOD(i,10),'testb.') ;
  end ;
run ;
