%macro x;
  %macro y ;
    %macro z ;
      %put in z ;
    %mend z ;

    %put in y ;
  %mend y ;

  %put in x ;
%mend x ;

%x;
%y
%z
