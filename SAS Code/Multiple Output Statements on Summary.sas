proc summary data=sasuser.houses ;
  class style street ;
  var price sqfeet ;
  output out=nway(where=(_type_=3))
         sum=
         mean(price)=avgprice ;
  output out=style(where=(_type_=2))
         sum= ;
  output out=street(where=(_type_=1))
         sum=
         n(sqfeet)=num ;
run ;
