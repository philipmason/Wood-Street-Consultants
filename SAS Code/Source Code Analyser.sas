* Prototype for analysing source code - useful if you have a lot
  of source code you need an overview of ;

%macro se(report,item) ;
  options nosource ;
  DATA SASUSER.source(drop=line) ;
    array files(15) $ 30 _temporary_ ('batch0' 'batch_jce' 'batch_macros_19971229'
                                     'select' 'report_select' 'report_zones' 'report_alldiv' 'report_succ'
                                     'report' 'report2' 'archive' 'fmvar1' 'batch_end' 'ctrlgest' 'bondrate') ;
    length file $ 200
           LINE $ 200
           datastep $17
           proc $ 20
           macro $ 8 ;
    retain count 0
           dir 'Y:\FMSHARE\MIDDLE OFFICE\SAS\SOURCE\'
           suffix '.sas' ;
    if count=0 then
      link next ;
    infile dummy filevar=file eof=next length=len missover ;
  *  if _n_>1000 then stop ;
    INPUT LINE & @ ;
    linenum+1 ;

    %if &item> %then
      %do ;
        if index(upcase(line),dequote(upcase("&item")))>0 then
          put linenum line ;
      %end ;

    INPUT @1 @'%MACRO ' macro
          @1 @'PROC ' PROC
          @1 @'DATA ' datastep @ ;
    if macro||proc||datastep>' ' & len-index(line,' ')>0 ;
    proc=compress(proc,';') ;
    return ;
  next:
    count+1 ;
    if count>dim(files) then
      stop ;
    linenum=0 ;
    file=trim(dir)||files(count) ;
    if suffix>' ' then
      file=trim(file)||suffix ;
  run ;
  %if &report> %then
    %do ;
      proc freq ;
        table proc ;
      run ;
    %end ;
  options source ;
%mend se ;
%se ;
%se(1)
%se(,'proc format')
%se(,'/*')
