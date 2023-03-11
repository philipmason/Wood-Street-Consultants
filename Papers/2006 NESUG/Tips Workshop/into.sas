*** CREATING A RANGE OF MACRO VARIABLES FROM SQL WITH LEADING ZEROES ;
proc sql noprint ;
  select name into :name01-:name19 from sashelp.class ;
%put _user_ ;
