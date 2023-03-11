/* AREA CHARTS WHICH CAN COMPARE MAGNITUDES OF VARIABLES IN CATEGORIES */

goptions reset=all device=activex ;
 
ods html file='c:\workshop\hw06\test.html' ;

data totals; 
   input Site $ Quarter $ Sales Salespersons; 
cards; 
Lima    1 4043.97    4 
NY      1 4225.26   12 
Rome    1 16543.97   6 
Lima    2 3723.44    5 
NY      2 4595.07   18 
Rome    2 2558.29   10 
Lima    3 4437.96    8 
NY      3 5847.91   24 
Rome    3 3789.85   14 
Lima    4 6065.57   10 
NY      4 23388.51  26 
Rome    4 1509.08   16 
; 
proc gareabar data=totals;
   hbar site*salespersons /sumvar=sales
                           subgroup=quarter
                           rstat=SUM
                           wstat=PCT;
run ; quit ;
 
ods html close;
