%macro x ;
  %do i=1 %to 50 ;
    proc sql ;
      select count(*) from sasuser.houses ;
  %end ;
  quit ;
%mend x ;

%let start=%sysfunc(time()) ;
%x
%let end=%sysfunc(time()) ;
%let time1=%sysevalf(&end-&start) ;

%macro x ;
  proc sql ;
  %do i=1 %to 50 ;
    select count(*) from sasuser.houses ;
  %end ;
  quit ;
%mend x ;

%let start=%sysfunc(time()) ;
%x
%let end=%sysfunc(time()) ;
%let time2=%sysevalf(&end-&start) ;


%put time1=&time1 & time2=&time2 ;
