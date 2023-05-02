*** This will be TRUE ;
%put =======> %eval(2<10) ;

*** This is TRUE, but stupid EVAL thinks it isnt ;
%put =======> %eval(2.<10.) ;

*** Since it can only use integers, it bombs out here ;
%put =======> %eval(9**99) ;

***************************************************************************;
*** SAS came to the rescue with a floating point evaluation macro function ;
%put =======> %sysevalf(2<10) ;

%put =======> %sysevalf(2.<10.) ;

%put =======> %sysevalf(9**99) ;
