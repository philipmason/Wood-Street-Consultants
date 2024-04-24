/* MAKE COMBINED BAR CHART AND PLOT THE EASY WAY */

goptions reset=all device=activex ;
 
ods html file='c:\workshop\hw06\test.html' ;
 
proc gbarline data=sashelp.prdsale;
  bar product / sumvar=actual ;
  plot / sumvar=predict ;
run; quit;
 
ods html close;
