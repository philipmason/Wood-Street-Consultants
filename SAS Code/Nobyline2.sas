*===> Code which works correctly.

options nobyline ;

proc gplot data=sasuser.houses NOCACHE ;
  by style ;
  title 'Style is #byval(style)' ;
  plot sqfeet*price ;
run ;
