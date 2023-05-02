%put ******* BEFORE ******* ;
%put _user_ ;
%let dsid=%sysfunc(open(serveur.parm,i)) ;
%syscall set(dsid) ;
%let rc=%sysfunc(fetch(&dsid)) ;
%let rc=%sysfunc(close(&dsid)) ;
%put ******* AFTER ******* ;
%put _user_ ;
