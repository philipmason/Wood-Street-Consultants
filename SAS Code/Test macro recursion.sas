%let count=0 ;

%macro x;
  %let count=%sysevalf(&count+1) ;
  %put &count: X calling Y ;
  %y
%mend x ;

%macro y;
  %let count=%sysevalf(&count+1) ;
  %put &count: Y calling X ;
  %x
%mend y ;

%x
