proc sql noprint;
  select name into :varlist separated by " "
  from dictionary.columns
  where upcase(libname)="SASUSER" and upcase(memname)="HOUSES"
  order by name;
quit;

proc print data=sasuser.houses ;
  var &varlist;
run;
