%let dsid=%sysfunc(open(sasuser.houses,i)) ;
%syscall set(dsid) ;
%let rc=%sysfunc(fetch(&dsid)) ;
%let rc=%sysfunc(close(&dsid)) ;
%put _user_ ;
