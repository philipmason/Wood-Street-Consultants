proc format ; value x
1-2='ok'
3-4='ok'
5-7='ok'
8-9='ok' ;
run ;

data ;
  do i=1 to 9 by .5 ;
    put i 4.1 + 2 i x. ;
  end ;
run ;
