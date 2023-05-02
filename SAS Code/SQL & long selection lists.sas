proc sql ;
  select name into :namelist separated by ',' from sasuser.class where sex='F' ;
quit ;
%put namelist=&namelist;