21   * without IFN function ;
22   data test1 ;
23     set sashelp.class ;
24    * set entry price based on age ;
25     if age>=13 then
26       price=12.50 ;
27     else
28       price=8 ;
29   run ;
NOTE: There were 19 observations read from the data set SASHELP.CLASS.
NOTE: The data set WORK.TEST1 has 19 observations and 6 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
30   * with IFN function ;
31   data test2 ;
32     set sashelp.class ;
33    * set entry price based on age ;
34     price=ifn(age>=13,12.50,8) ;
35   run ;
NOTE: There were 19 observations read from the data set SASHELP.CLASS.
NOTE: The data set WORK.TEST2 has 19 observations and 6 variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
36   %put %sysfunc(ifc(&sysscp=WIN,You are using Windows!,You are not using Windows)) ;
You are using Windows!
