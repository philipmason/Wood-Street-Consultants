%macro testres(x,y,dpi) ;
 * x   ... number of inches across graphic ;
 * y   ... number of inches across graphic ;
 * dpi ... resolution in dots per inch ;
  filename out "c:\test&dpi..png" ;
  goptions reset=all                  /* reset everything first */
           dev=png                    /* driver to use */
     	     xmax=&x in
           ymax=&y in
   	     xpixels=%sysevalf(&x*&dpi)
           ypixels=%sysevalf(&y*&dpi)
           ftext="SAS Monospace"      /* choose a nice font */
           htext=3 pct                /* make font a good size */
           gsfname=out                /* where to save graphic */ ;
  proc gchart data=sashelp.class ;
    hbar3d age / discrete ;
  run ; quit ;
%mend testres ;
%testres(6,4,600) ;
%testres(6,4,50) ;
