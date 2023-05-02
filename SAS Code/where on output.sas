proc summary data=sasuser.houses ;
  class style street ;
  var _numeric_ ;
  output sum=
         out=temp(where=(_type_ in (1,3))) ;
run ;

proc freq ;
  table _type_ ;
run ;
