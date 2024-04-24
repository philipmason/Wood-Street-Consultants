%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : bar_table.sas                                      **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : this will produce a tabular report which also      **
%*                   displays traffic lighting for the values in each   **
%*                   cell. Additionally it displays bars which are      **
%*                   proportional to the values in the column           **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  Reference      : 001                                                **
%*  By             : Phil Mason                                         **
%*  Date           : 22Jan2009                                          **
%*  Details        : Added color support for RTF                        **
%************************************************************************;
%*  ;


%macro bar_table(dset=,
                 where=,
                 byvars=,
                 vars=_numeric_,
                 highest=%str(<span style=""background-color: red ;"">),
                 highest2=lightred,
                 high=%str(<span style=""background-color: orange ;"">),
                 high2=lightorange,
                 normal=%str(<span style=""background-color: lightgreen ;"">),
                 normal2=white,
                 low=%str(<span style=""background-color: #00ccff ;"">),
                 low2=lightblue,
                 lowest=%str(<span style=""background-color: #00ffff ;"">),
                 lowest2=lightblue,
                 missing=%str(<span style=""background-color: #ffffff ;"">),
                 minmax_fmts=1,
                 link=%nrstr(<a title=""Drill Down"" href=""http://&_srvname.:&_srvport.&_url.?_program=&firstPart.bar_table%28StoredProcess%29&subjid=),
                 unprotect=,       /* if unprotect specified, then unprotect that column so links can be used in the variable */
                 moreInfo=,        /* if specified, produces a special link for more information */
                 dsetLink=,        /* if specified use this rather than dset when building URL for drill down over columns */
                 columnLinks=1,    /* 1=use links over columns, 0=dont */
                 width=20,
                 bypass=0          /* 0=use HTML specific code, 1=bypass html specific code */
                 ) ;

  %if %superq(moreInfo)> & &bypass=0 %then
    title2 link= "%superq(moreInfo)" "Click here for more information" ;;
  data bar_table mw2;
    set &dset.
    %if %superq(vars)> %then 
      (keep=&byvars &vars) ;
    ;
    %if %superq(where)> %then
      where &where ;
    ;
  run ;

  %if %superq(vars)= %then
    %do ;
      data _null_ ;
        length varlist $ 400 ;
        set bar_table(obs=1) ;
        array nums(*) _numeric_ ;
        do i=1 to dim(nums) ;
          varlist=strip(varlist)||' '||vname(nums(i)) ;
        end ; 
        call symputx('vars',varlist) ;
      run ;
    %end ;
  proc summary data=bar_table ;
    %if %superq(where)> %then
      where &where ;;
    var &vars ;
    output out=max max= ;
  run ;
  proc summary data=bar_table ;
    %if %superq(where)> %then
      where &where ;;
    var &vars ;
    output out=min min= ;
  run ;

  %let c=%eval(%sysfunc(count(%sysfunc(compbl(%superq(vars))),%str( )))+1) ;
  %do i=1 %to &c ;
    %let v=%scan(%superq(vars),&i) ;
    %put i=&i v=&v ;
    %MakeFormat(&v) ;
  %end ;

  proc sort data=bar_table ;
    by &byvars ;
  run ;
  options nobyline ;
  %if &bypass=0 %then
    %let protectspecialchars=off ;
  %else
    %let protectspecialchars=on ;

  data _null_ ;
    length lab $ 100 ;
    set bar_table(obs=1) ;
    call execute('proc report data=bar_table(keep=&byvars &vars) nowd split=''!'' ;') ;
    call execute("  columns &byvars &vars ;") ;
    array nnn(*) &vars ;
    call execute("  define subjid / ' Subject ' style(column)={cellwidth=90 just=r protectspecialchars=&protectspecialchars}
                  style(header)={cellwidth=90 just=r protectspecialchars=&protectspecialchars};") ;
    do i=1 to dim(nnn) ;%*1;
      v=vname(nnn(i)) ;
      lab=vlabel(v) ;
      if lab='' or upcase(lab)='V' then
        lab=v ;
     %* use contents of variable for link ;
      %if "&unprotect">"" %then
        %do ;%*2;
          if upcase("&unprotect")=upcase(v) then
            call execute("  define "||
                          strip(v)||
                          " / style(column)={cellwidth=90 just=r protectspecialchars=&protectspecialchars}"||
                          "   style(header)={cellwidth=90 just=r protectspecialchars=&protectspecialchars};") ;
        %end ;%*2;
     %* use alternate dset for drill down link ;
      %if "&dsetlink">"" %then
        %let dset=&dsetlink ;
      %if &columnLinks=1 & &bypass=0 %then
        call execute("  define "||
                      strip(v)||
                      " / ' %superq(link)*"||
                      '&vars='||strip(v)||
                      '&dset='||"&dset"||
                      '&byvars='||"&byvars"||
                      """>"||
                      strip(lab)||
                      "</a>' style(column)={cellwidth=90 just=r protectspecialchars=&protectspecialchars}
                             style(header)={cellwidth=90 just=r protectspecialchars=&protectspecialchars};") ;
      %else
        call execute("  define "||
                      strip(v)||
                      " / style(column)={cellwidth=90 just=r protectspecialchars=&protectspecialchars}
                          style(header)={cellwidth=90 just=r protectspecialchars=&protectspecialchars};") ;
      ;
/* ref001 - start */
      %if &bypass=1 %then
        %do ; %*3;
          call execute("compute "||
                       strip(v)||
                       " ;") ;
          call execute("  length color $ 40 ;") ;
          call execute("  color='style=[background='||scan("||
                       strip(v)||
                       ",1,'@')||']' ;") ;
          call execute("  call define(_col_, 'style', color) ;") ;
          call execute("  "||
                       strip(v)||
                       "=scan("||
                       strip(v)||
                       ",2,'@') ;") ;
          call execute('endcomp ;') ;
        %end ; %*3;
/* ref001 - end */
    end ; %*1;
  run ;
%mend bar_table ;

/*options source2 mprint fmtsearch=(db) sasautos=("/sas/bi/macros" sasautos) ;*/
/*ods _all_ close ; ods html style=statdoc ;*/
/*title 'Vital Signs - Detailed Report' ;*/
/*%bar_table(dset=medmon.vs,where=subjid="1001",byvars=visit datetime subjid,vars=diabp sysbp pulse,minmax_fmts=0) ;*/
/*%bar_table(dset=medmon.vs,byvars=visit datetime subjid,vars=diabp sysbp pulse,minmax_fmts=0) ;*/
/*ods _all_ close ; ods listing ;*/
