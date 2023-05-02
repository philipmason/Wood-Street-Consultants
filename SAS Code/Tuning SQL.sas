data a ; do x=1 to 1e5 ; z=uniform(2)*1e3; output ; end ; run ;
data b ; do y=1 to 1e5 ; zz=uniform(2)*1e3;output ; end ; run ;

proc sql ;
create table test as select * from a full join b on x=y where x<10 ;
quit;

proc sql ;
create table test as select * from a(where=(x<10))
 full join b(where=(y<10)) on x=y ;
quit;
