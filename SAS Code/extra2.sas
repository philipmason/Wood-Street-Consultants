   ods html file='c:\both.xls' ;
   data x ;
     do value=.1 to 1 by .1 ;
       fraction=value ;
       output ;
     end ;
   run ;
   proc print ;
     var value ;
     var fraction / style(data)={htmlstyle="mso-number-format:\#\/\#"};
   run ;
   ods html close ;
