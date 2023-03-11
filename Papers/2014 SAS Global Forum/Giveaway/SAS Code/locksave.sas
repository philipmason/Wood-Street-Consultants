**************************************************************************;
** Study           : -generic-                                          **;
** Program name    :locksave.sas                                        **;
** Version number  : 1.0                                                **;
** Program type    : data                                               **;
** Program location: /sas/bis/&env./tools/macros                        **;
** Author          : Gerard Hermus                                      **;
** Site name       : APERD                                              **;
** Date            : 19Nov2008                                          **;
** SAS version     : 9.1.3                                              **;
** OS Name/version : SunOS 5.8                                          **;
** Data sets used  : dataview.libraries                                 **;
** Macros used     : -none-                                             **;
** Output created  :                                                    **;
** Purpose         : Take lock on dset, and save                        **;
** Comment         :                                                    **;
**************************************************************************;
** Modification history                                                 **;
** Version         :                                                    **;
** By              :                                                    **;
** Date            :                                                    **;
** Details         :                                                    **;
**************************************************************************; 

%macro locksave(_type=lock,
                _member=,
                _timeout=60,
                _retry=0.01);

   %if &_type=lock %then %do;
      %* set start time;
      %local _starttime;
      %let _starttime=%sysfunc(datetime());
      %* try locking until lock is obtained or until timeout is exceeded;
      %do %until(&syslckrc=0 or %sysevalf(%sysfunc(datetime())>(&_starttime + &_timeout)));
         options noerrorabend;
         lock &_member;
         options errorabend;
         %* pause before retrying;
         %let sleep=sleep(&_retry.,1);
      %end;
   %end;
   %else %do;
      %* release lock;
      lock &_member clear;
   %end;
%mend;
