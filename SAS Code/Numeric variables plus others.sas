proc sql ;
select name into :vars separated by ','
  from dictionary.columns
  where libname='SASUSER' & memname='HOUSES' & type='num' ;

select &vars,
       style
from sasuser.houses ;
%put vars=&vars;
