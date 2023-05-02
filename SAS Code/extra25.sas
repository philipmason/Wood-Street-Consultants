/***
Program Macro Name : chmod (version#007)
Date               : 19feb2004
Written By         : phil mason
Overview           : use chmod command to change files and authorities
Change History : 1mar04 (pm) added support for SAS views & catalogs
                 2mar04 (pm) added support for compressed files (Z)
                 2mar04 (pm) changed to do all files & directories and also go up a level to ensure we get containing dir
Variable Input Fields       : path  ... libref of the path for which we want to change permissions
                              local ... 1=run locally on UNIX, otherwise we run from client and remote submit to server
***/
%macro chmod(path=inprd,local=) ;
%put NOTE-USED: {};                                                                                                                                
%if &local= %then
  %do ;
    %syslput path=&path;
    rsubmit ;
  %end ;
   * Fix authorities so group has full access to datasets & indexes created ;
   * use a datastep to force pathname to resolve on UNIX, rather than windows ;
    data _null_ ;
	  length path $ 256 ;
	  path=pathname("&path") ;
	  put path= ;
	  call system('cd '||trim(path)) ;
    run ;
    x "chmod g=rxw *" ;
   * go up a level to fix the directory ;
    x "cd .." ;
    x "chmod g=rxw *" ;
%if &local= %then
  endrsubmit ; ;
%mend chmod ;

