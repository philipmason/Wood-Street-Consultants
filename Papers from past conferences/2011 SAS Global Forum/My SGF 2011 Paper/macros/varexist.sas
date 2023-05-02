%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Stored Process  : varexist.sas                                       **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/macros                               **
%* Author          : Phil Mason                                         **
%* Date            : 21Jan2009                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%* Usage           : %if %varexist(sashelp.class,sexx) %then ...        **
%* Purpose         : returns a 1 if a variable exists, otherwise        **
%*                   returns a 0 - so it can be used in macro logic     **
%*                                                                      **
%* Comments        :                                                    **
%************************************************************************;

%macro varexist(dset,var) ;
  %let dsid=%sysfunc(open(&dset)) ;
  %if %sysfunc(varnum(&dsid,&var))>0 %then
    1 ;
  %else
    0 ;
  %let dsid=%sysfunc(close(&dsid)) ;
%mend varexist ;
