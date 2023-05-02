options mstored sasmstore=sasuser  ;

%macro test / store ;
  data test / pgm=work.test ;
  run ;
%mend test ;

%test
