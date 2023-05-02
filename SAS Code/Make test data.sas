proc format ;
  value $test
    'a'='Formatted a'
    'c'='Formatted c' ;
run;
data sasuser.test ;
  format x $ test. ;
  do x='a','b','c';
    y=ranuni(1)*100;
    output ;
  end ;
run ;
proc print data=sasuser.test ;run;
