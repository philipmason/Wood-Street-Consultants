* Create a list of STYLEs to use with the IN operator ;
*   the list is put into the VALUES macro variable ;
proc sql noprint ;
  select distinct quote(style)
    into :values separated by ','
    from sasuser.houses
    where price>100000 ;
quit ;
%put Values=&values ;

* Select observations using values in the VALUES macro variable ;
data not_bad ;
  set sasuser.houses ;
    where style in (&values) ;
run ;
