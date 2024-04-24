%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : backup.sas                                         **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 04Jan2010                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : exports medmon data for a study and compresses it  **
%* Comments        :                                                    **
%* Example         : %backup(0485-cl-e201)                              **                            
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*                                                                      **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%*                                                                      **
%************************************************************************;

%macro backup(study) ;
  %let project=%scan(&study,1,'-_') ;
  %let outdir=/sas/studydbs/&project/&study/data/dev/edata ;
  libname indir "&outdir/prod" ;
  %let outfile=mn_backup-%sysfunc(date(),yymmdd.) ;
 %* define output file;
  filename outfile "&outdir./&outfile.";
 %* cport all data;
  proc cport library=indir file=outfile memtype=data;
  run;
 %* zip the xpt file;
  filename cmd1 pipe "cd &outdir.; gzip -v < &outfile. > &outfile..gz" ;
 %* remove the xpt file;
  filename cmd2 pipe "cd &outdir.; rm '&outfile.'" ;
  data _null_ ;
    infile cmd1 ;
    input ;
    put _infile_ ;
  run ;
  data _null_ ;
    infile cmd2 ;
    input ;
    put _infile_ ;
  run ;
 %* deassign library;
  libname indir ;
 %* deassign filename;
  filename outfile ;
  filename cmd1 ;
  filename cmd2 ;
%mend backup ;
