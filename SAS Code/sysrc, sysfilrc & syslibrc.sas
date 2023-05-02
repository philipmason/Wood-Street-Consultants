** Reset ;  proc printto ; run ; %let sysrc=0 ; %let sysfilrc=0 ; %let syslibrc=0 ; %put Reset: &sysrc &syserr &sysfilrc &syslibrc ; **;

libname y 'c:\re' ;
options nosource ; %put ; %put ===> Detect an error in a libname statement ; %put ;
%put    sysrc = &sysrc ;
%put   syserr = &syserr ;
%put sysfilrc = &sysfilrc ;
%put syslibrc = &syslibrc ;
%put ; %put ; options source ;

data _null_ ;
  sysrc=libname('y','c:\re') ;
  sysmsg=sysmsg() ;
  put sysrc= sysmsg= ;
run ;

** Reset ;  proc printto ; run ; %let sysrc=0 ; %let sysfilrc=0 ; %let syslibrc=0 ; %put Reset: &sysrc &syserr &sysfilrc &syslibrc ; **;


filename x ;
filename x ;
options nosource ; %put ; %put ===> Detect an error in a filename statement ; %put ;
%put    sysrc = &sysrc ;
%put   syserr = &syserr ;
%put sysfilrc = &sysfilrc ;
%put syslibrc = &syslibrc ;
%put ; %put ; options source ;

** Reset ;  proc printto ; run ; %let sysrc=0 ; %let sysfilrc=0 ; %let syslibrc=0 ; %put Reset: &sysrc &syserr &sysfilrc &syslibrc ; **;

proc unknown ;
run ;
options nosource ; %put ; %put ===> Detect an error in a Procedure ; %put ;
%put    sysrc = &sysrc ;
%put   syserr = &syserr ;
%put sysfilrc = &sysfilrc ;
%put syslibrc = &syslibrc ;
%put ; %put ; options source ;

** Reset ;  proc printto ; run ; %let sysrc=0 ; %let sysfilrc=0 ; %let syslibrc=0 ; %put Reset: &sysrc &syserr &sysfilrc &syslibrc ; **;

options xsync noxwait ;
%sysexec zzz ;
options xsync xwait ;
options nosource ; %put ; %put ===> Detect an error in a system command ; %put ===> You need XSYNC otherwise it does not work ; %put ;
%put    sysrc = &sysrc ;
%put   syserr = &syserr ;
%put sysfilrc = &sysfilrc ;
%put syslibrc = &syslibrc ;
%put ; %put ; options source ;
