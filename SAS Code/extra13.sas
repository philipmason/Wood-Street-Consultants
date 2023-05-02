%let dest=rtf; * pdf, ps or rtf ;
%let cols=2 ;
ods &dest columns=&cols file="c:\test.&dest" ;
goptions rotate=landscape ;
proc print data=sashelp.shoes ;
  var region stores sales ;
run ;
ods &dest close ;
