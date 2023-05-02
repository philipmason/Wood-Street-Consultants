goptions device=actximg ;
/*goptions device=javaimg ;*/
ods html body='c:\test.html'
         gpath='c:\'
         (url=none) ;
proc gchart data=sashelp.shoes ;
  vbar3d product / sumvar=sales ;
run ;
ods html close ;
