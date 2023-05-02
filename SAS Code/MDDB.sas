proc mddb data=sasuser.houses
          out=work.testmddb ;
  class style street bedrooms ;
  var price ;
  hierarchy style street bedrooms / name="Type of home" ;
  hierarchy style street ;
  hierarchy style ;
run ;
