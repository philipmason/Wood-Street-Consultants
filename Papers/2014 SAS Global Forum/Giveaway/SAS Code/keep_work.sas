%**************************************************************************;
%** Study           : -generic-                                          **;
%** Program name    : keep_work.sas                                      **;
%** Version number  : 1.0                                                **;
%** Program type    : macro                                              **;
%** Program location: /sas/bis/&env./macros                              **;
%** Author          : Phil Mason                                         **;
%** Site name       : Leiderdorp                                         **;
%** Date            : 11Jun2009                                          **;
%** SAS version     : 9.1.3                                              **;
%** OS Name/version : SunOS 5.8                                          **;
%** Data sets used  :                                                    **;
%** Macros used     :                                                    **;
%** Output created  :                                                    **;
%** Purpose         : sets up user libref which makes datasets go to it  **;
%**                   rather than work library, also writes logs to a    **;
%**                   directory for user - this only happens for         **;
%**                   non-production and if the user has a library setup **;
%** Comment         :                                                    **;
%**************************************************************************;
%** Modification history                                                 **;
%** Version         :                                                    **;
%** By              :                                                    **;
%** Date            :                                                    **;
%** Details         :                                                    **;
%**************************************************************************;

%macro keep_work ;

  %global _keepwork;
  %let _keepwork=1;

  %if %symexist(env)=0 %then %return ;
  %if "%upcase(&env)" = "PROD" %then %return ;
  %if %sysfunc(fileexist(/export/home/&_metauser/work))=0 %then %return ;

  %* allocate user libref so that all work datasets now go to an alternate location ;
  libname user "/export/home/&_metauser/work" ;

  options mprint nosymbolgen nomlogic;

  proc datasets lib=user kill NOLIST ;
  run ;

  %* Reroute log to same name as STP, or to username if not found;
  %local proglog;

  data _null_;
    prog=symget('_PROGRAM');
    index=index(upcase(prog),'(STOREDPROCESS)');
    if index>0 then do;
      txt=reverse(substr(prog,1,index-1));
      txt=reverse(substr(txt,1,index(txt,'/')-1));
    end;
    else txt=symget('_METAUSER');
    call symput('proglog',strip(txt)!!"_&_keepwork");
  run;

  %let _keepwork=%eval(&_keepwork+1);

  proc printto log="%sysfunc(pathname(user))/&proglog..log" new;
  run ;

%mend keep_work ;
