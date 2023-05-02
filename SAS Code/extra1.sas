libname out excel 'c:\test.xls' ;
data out.class ; set sashelp.class ; run ;
 * try to replace dataset ;
   data out.class ; set sashelp.class ; run ;

   * make a new dataset ;
   data out.shoes ; set sashelp.shoes ; run ;

   * free it so we can read the spreadsheet from EXCEL ;
   libname out ;
