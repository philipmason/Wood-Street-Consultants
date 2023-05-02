data wide ;
  length var1-var1000 $ 10 ;
  do i=1 to 1000 ;
    if mod(_n_,50)=1 then
      var1='X' ;
    output ;
  end ;
run ;

%macro test(n) ;
%do i=1 %to &n ;
  data _null_ ;
    set wide ;
    if var1='X' ;
  run ;

  data _null_ ;
    set wide ;
    where var1='X' ;
  run ;
%end ;
%mend ;

options mprint ;

%test(4)
