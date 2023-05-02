data big ;
  array big(1000) $ 10 ;
  do i=1 to 1000 ;
    output ;
  end ;
run ;

options nosource ;
%macro test(n,des=Test) ;
    %do i=1 %to %eval(&n+1) ;
      %if &i=2 %then
        %let start=%sysfunc(time()) ;
      %code ;
    %end ;
  %let end=%sysfunc(time()) ;
  %let avg=%sysevalf((&end-&start)/&n) ;
  %put Average time for &n runs of &des: &avg ;
%mend test ;

%macro code ;
  data _null_ ;
    set big ;
      where big500='Phil' ;
  run ;
%mend code ;

%test(20,des=WHERE statement test)



%macro code ;
  data _null_ ;
    set big ;
      if big500='Phil' ;
  run ;
%mend code ;

%test(20,des=IF statement test)



%macro code ;
  data _null_ ;
    set big(where=(big500='Phil')) ;
  run ;
%mend code ;

%test(20,des=WHERE dataset option test)



%macro code ;
  data _null_ ;
    set big(keep=big500 where=(big500='Phil')) ;
  run ;
%mend code ;

%test(20,des=WHERE dataset option plus KEEP test)



%macro code ;
  data _null_ ;
    set big(keep=big500) ;
      where big500='Phil' ;
  run ;
%mend code ;

%test(20,des=WHERE statement plus KEEP test)



%macro code ;
  data _null_ ;
    set big(keep=big500) ;
      if big500='Phil' ;
  run ;
%mend code ;

%test(20,des=IF statement plus KEEP test)

options source ;
