*** NEW IF FUNCTIONS ;
   * without IFN function ;
   data test1 ;
     set sashelp.class ;
    * set entry price based on age ;
     if age>=13 then
       price=12.50 ;
     else
       price=8 ;
   run ;

   * with IFN function ;
   data test2 ;
     set sashelp.class ;
    * set entry price based on age ;
     price=ifn(age>=13,12.50,8) ;
   run ;
