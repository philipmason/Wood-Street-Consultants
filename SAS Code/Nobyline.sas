*===> Code which doesn't work.

options nobyline ;

proc gplot data=sasuser.houses ;
  by style ;
  title 'Style is #byval(style)' ;
  plot sqfeet*price ;
run ;
