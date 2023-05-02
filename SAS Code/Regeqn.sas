title 'Regression using REGEQN option' ;

Symbol1 Interpol = RLCLM99  /*Lin regr with 99% CIs*/
        Value    = star
        Height   = 3
        CV       = red
        CI       = blue
        CO       = green
        L        = 1;

axis1 label=(a=90);
axis2 minor=none ;

proc gplot data=sashelp.retail ;
  plot sales*year / REGEQN     /*-- Put Equation on Graph --*/
        vaxis=axis1
        haxis=axis2 ;
run;
quit;
