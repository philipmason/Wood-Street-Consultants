goptions reset=all gsfname=g device=png xmax=6in ymax=4in xpixels=1800
         ypixels=1200 ftext='Arial' htext=5pct;
filename g 'c:\sex11.png' ; proc gchart data=sashelp.class ; where age=11 ; pie sex ; run ;
filename g 'c:\sex12.png' ; proc gchart data=sashelp.class ; where age=12 ; pie sex ; run ;
filename g 'c:\sex13.png' ; proc gchart data=sashelp.class ; where age=13 ; pie sex ; run ;
filename g 'c:\sex14.png' ; proc gchart data=sashelp.class ; where age=14 ; pie sex ; run ;
filename g 'c:\sex15.png' ; proc gchart data=sashelp.class ; where age=15 ; pie sex ; run ;
filename g 'c:\sex16.png' ; proc gchart data=sashelp.class ; where age=16 ; pie sex ; run ;
filename g 'c:\vbar.png' ;
pattern1  image='c:\sex11.png' ;
pattern2  image='c:\sex12.png' ;
pattern3  image='c:\sex13.png' ;
pattern4  image='c:\sex14.png' ;
pattern5  image='c:\sex15.png' ;
pattern6  image='c:\sex16.png' ;
title c=red 'Male ... ' c=green 'Female' ;
proc gchart data=sashelp.class  ;
  vbar age / subgroup=age discrete width=20 nolegend ; 
run; quit;
