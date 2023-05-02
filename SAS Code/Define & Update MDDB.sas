options msglevel=i ;

proc mddb data=sasuser.houses
          out=sasuser.testmddb ;
  class style street baths ;
  hierarchy style street baths ;
  hierarchy style street ;
  var _numeric_ ;
run ;

proc mddb in=sasuser.testmddb   /* existing mddb */
          data=sasuser.houses   /* data being added */
          out=sasuser.newmddb ; /* new mddb */
run ;
