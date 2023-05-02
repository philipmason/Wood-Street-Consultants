%let my_special_macro="oh no it's not" ;
proc sql ;
create table sasuser.macros as
  select name,value from
    sashelp.vmacro
        where scope='GLOBAL' ;
quit ;
dm 'vt sasuser.macros' vt ;
