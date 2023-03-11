%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : nvars.sas                                          **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : this macro returns the number of variables in a    **
%*                   dataset. It is returned as the only output from    **
%*                   this macro so that a call can be inserted where    **
%*                   the number of variables would otherwise be used    **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%************************************************************************;
%*  ;

%macro nvars(dset) ;
  %let dsid=%sysfunc(open(&dset)) ;
  %let nvars=%sysfunc(attrn(&dsid,nvars)) ;
  &nvars
  %let dsid=%sysfunc(close(&dsid)) ;
%mend nvars ;
/*options mlogic symbolgen ;*/
/*%put WARNING- Nvars - %nvars(sashelp.class) ;*/
