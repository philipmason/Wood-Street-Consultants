*** SOME BASICS OF CREATING XML IN SAS 9 ;

libname test xml 'c:\workshop\hw06\test.xml' ;
data test.sample ;
  name='Phil Mason' ;
  age=40 ;
  sex='M' ;
  phone='01491 824905' ;
  country='England' ;
run ;
libname test ;


*** WHAT HAPPENS IF YOU WRITE MULTIPLE DATASETS TO AN XML FILE? ;
libname test xml 'c:\workshop\hw06\test.xml' ;
data test.a ; x=1 ; run ;
data test.b ; x=1 ; run ;
data test.c ; x=1 ; run ;
libname test ;

libname test xml 'c:\workshop\hw06\test.xml' ;
data test.a test.b test.c ; x=1 ; run ;
libname test ;

libname test xml 'c:\workshop\hw06\test.xml' ;
data a b c ; x=1 ; run ;
proc copy in=work out=test ;
  select a b c ;
run ;
libname test ;


*** SAS CODE TO USE XML ;
libname test2 xml 'c:\workshop\hw06\test.xml' ;
proc print data=test2.sample ;
run ;
libname test2 ;

