%macro loop ;
  proc datasets lib=work kill ;
    %do i=1 %to 6 ;
      copy in=sasuser out=work ;
        select houses ;
      age houses test01-test03 ;
    %end ;
  run ;
  quit ;
%mend loop ;

%loop
