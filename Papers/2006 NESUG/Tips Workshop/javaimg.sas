/* USING JAVA & ACTIVEX TO GENERATE STATIC GRAPHS */

goptions device=actximg ;

ods html body='c:\workshop\hw06\test.html'
         gpath='c:\workshop\hw06\'
         (url=none) ;

proc gchart data=sashelp.shoes ;
  vbar3d product / sumvar=sales ;
run ;

ods html close ;




goptions device=javaimg ;
ods html body='c:\workshop\hw06\test.html'
         gpath='c:\workshop\hw06\'
         (url=none) ;

proc gchart data=sashelp.shoes ;
  vbar3d product / sumvar=sales ;
run ;

ods html close ;
