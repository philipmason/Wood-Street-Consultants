/* PLOT DETAILS OF SLICES IN A PIE GRAPH
In SAS 9 there is a new parameter in PROC GCHART that can be used when making PIE charts. It allows you to produce an inner pie overlay, showing major components that make up outer pie slices. This can be useful to get even more information into your chart. See the example below. */

ods html file='c:\workshop\hw06\test.html' gpath='c:\' ;
goptions reset=all device=png
         xmax=20 ymax=12          /* make PNG bigger */
         ftext='Arial' htext=4pct /* use some nice looking text */;

data countries;
  input country $ 1-14 region $16-26 Machinery;
  cards;
Taiwan         Asia       6.1
Korea          Asia       4.6
Malaysia       Asia       4.4
Malaysia2      Asia       3.9
Malaysia4      Asia       3.9
Malaysia5      Asia       1.5
U.S.           U.S.       39.1
Belgium        Europe     2.6
Germany        Europe     7.8
United Kingdom Europe     3.9
France         Europe     3.9
Santa          Antarctica 1.1
Bob            Antarctica 1.0
Cydonia        Mars       1.1
Tims House     Mars       1.0
China          Asia       10.2
Malaysia3      Asia       3.9
;
run;

proc gchart;
  pie region / angle=320
               slice=outside
               percent=inside
               value=none
               sumvar=Machinery
               detail_percent=best
               detail=country
               descending ;
run; quit;
ods html close ;
