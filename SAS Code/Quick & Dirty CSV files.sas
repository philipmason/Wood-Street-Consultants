** Point output to a file ;
* PROC PRINTTO FILE='c:\sas\test.txt ;

**
options nodate
        nonumber
        ls=254
        ps=32767 ;

proc tabulate data=sasuser.houses
              formchar=',             '
              noseps ;
  class style ;
  var price sqfeet ;
  table sum*(price sqfeet), style all ;
run ;

** Reset output ;
* proc printto ;
run ;
