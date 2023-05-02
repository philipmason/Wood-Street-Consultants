* Eliminate LOG window scrolling delays ;
dm 'log;autoscroll 0' ;


proc datasets lib=work kill ;
run ; quit ;

%macro junk ;
  options nosource ;
  %do i=1 %to 100 ;
    data data&i ;
      array aa(100) $ 200 ;
      do i=1 to 100 ;
        aa(i)=' ' ;
      end ;
    run ;
  %end ;
  options source ;
%mend junk ;

%junk

proc datasets lib=work kill ;
run ; quit ;

%junk

options mprint ;
%macro sqldel ;
  proc sql ;
    drop table
    %do i=1 %to 99 ;
      data&i,
    %end ;
      data100
    ;
  quit ;
%mend sqldel ;
options nomprint ;

%sqldel

%junk

%let start=%sysfunc(datetime()) ;
options noxwait ;
%sysexec erase h:\user\sasfi612\saswork\data*.sd2 ;
options xwait ;
%let end=%sysfunc(datetime()) ;
%let elapsed=%sysevalf(&end-&start) ;
%put Start=%sysfunc(putn(&start,datetime.)), End=%sysfunc(putn(&end,datetime.)), Elapsed=&elapsed ;
