%**************************************************************************
%** Study           : -generic-                                          **
%** Program name    : var_label.sas                                      **
%** Version number  : 1.0                                                **
%** Program type    : macro                                              **
%** Program location: /sas/bis/&env./macros                              **
%** Author          : Phil Mason                                         **
%** Site name       : Leiderdorp                                         **
%** Date            : 11Jun2009                                          **
%** SAS version     : 9.1.3                                              **
%** OS Name/version : SunOS 5.8                                          **
%** Data sets used  :                                                    **
%** Macros used     :                                                    **
%** Output created  :                                                    **
%** Purpose         : returns the label of a variable                    **
%** Usage           : title "%var_label(db.labs,_tchol)"                 **
%** Comment         :                                                    **
%** Parameters                                                           **
%**   dset          : dataset                                            **
%**   var           : variable whose label we want                       **
%**                 :                                                    **
%**************************************************************************
%** Modification history                                                 **
%** Version         :                                                    **
%** By              :                                                    **
%** Date            :                                                    **
%** Details         :                                                    **
%**************************************************************************
;

%macro var_label(dset,var) ;
  %let dsid=%sysfunc(open(&dset)) ;
  %let vn=%sysfunc(varnum(&dsid,&var)) ;
  %let lab= ;
  %if &vn>0 %then
    %let lab=%sysfunc(varlabel(&dsid,&vn)) ;
  %if %superq(lab)= %then
    %do ;
      %let var=%sysfunc(compress(&var,_)) ; %* remove underscores ;
      %let vn=%sysfunc(varnum(&dsid,&var)) ;
      %if &vn>0 %then
        %let lab=%sysfunc(varlabel(&dsid,&vn)) ;
    %end ;
  %if %superq(lab)= %then
    %let lab=%sysfunc(compress(&var,_)) ;
  &lab
  %let dsid=%sysfunc(close(&dsid)) ;
%mend var_label ;
