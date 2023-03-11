%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : nobs.sas                                           **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 1Sep2008                                           **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : this macro returns the number of observations in a **
%*                   dataset. It is returned as the only output from    **
%*                   this macro so that a call can be inserted where    **
%*                   the number of observations would otherwise be used **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%************************************************************************;
%*  ;

%macro nobs(dset) ;
  %let dsid=%sysfunc(open(&dset)) ;
  %let nobs=%sysfunc(attrn(&dsid,nobs)) ;
  &nobs
  %let dsid=%sysfunc(close(&dsid)) ;
%mend nobs ;
/*options mlogic symbolgen ;*/
/*%put WARNING- nobs - %nobs(sashelp.class) ;*/
