proc format ;
  value one 1='one' ;

data houses;
  set sasuser.houses;
  format baths one. ;
run ;

proc mddb data=houses out=sasuser.test2 ;
  var price;
  class style baths;
  hierarchy style baths ;
run ;

libname x sassfio 'c:\sas\sasuser\test2.sm2' ;

data _null_ ;
  set x.nway ;
  if baths='one' then put 'ONE:- ' _all_ ;
  if baths=1 then put '1:- ' _all_ ;
run ;
