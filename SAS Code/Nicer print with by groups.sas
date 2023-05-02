proc sort data=sasuser.houses ;
  by style ;
run ;

proc print data=sasuser.houses ;
  by style ;
  var style _numeric_ ;
run ;

proc print data=sasuser.houses ;
  by style ;
  id style ;
  var _numeric_ ;
run ;
