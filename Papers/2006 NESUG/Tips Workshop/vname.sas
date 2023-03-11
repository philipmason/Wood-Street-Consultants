data test ;
  set sashelp.prdsal3 ;
 * make an array containing all character variables currently defined ;
  array c(*) _character_ ; 
 * loop through array ;
  do _i=1 to dim(c) ;
    vname=vname(c(_i)) ;
   * uppercase each character variable, except COUNTRY ;
    if vname^="COUNTRY" then
      c(_i)=upcase(c(_i)) ;
  end ;
run ;

