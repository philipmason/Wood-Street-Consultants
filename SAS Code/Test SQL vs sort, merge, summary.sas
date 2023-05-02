%macro makedata ;
data x ;
  array pad(10) $ 20 ;
  do a=1 to 100 ;
    do b=1 to 10 ;
      output ;
    end ;
  end ;
run ;

proc sort ;
  by b ;
run ;

data y ;
  set x ;
run ;

%mend makedata ;

%makedata


%let start=%sysfunc(time()) ;

proc sort data=x ;
  by a ;

proc sort data=y ;
  by a ;

data z1 ;
  merge x y ;
    by a ;
run ;

proc summary data=z1 nway ;
  class a ;
  var b ;
  output out=zz1(drop=_type_)
         sum= ;
run ;

%let end=%sysfunc(time()) ;
%let time=%sysevalf(&end-&start) ;
%put Sort, Merge & Summary took: &time ;

%makedata


%let start=%sysfunc(time()) ;

proc sql ;
  create table zz2 as
    select a,
           count(b) as _freq_,
           sum(b) as b
    from (select distinct x.a, x.b from x inner join y on x.a=y.a)
    group by a ;
quit ;

%let end=%sysfunc(time()) ;
%let time=%sysevalf(&end-&start) ;
%put SQL took: &time ;
