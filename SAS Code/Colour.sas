libname tips 'c:\tips' ;
proc datasets lib=work nolist ;
  delete temp /mt=cat ;
run ; quit ;
dm 'build tips.tips.colour.frame' build  ;
