/******************************************************************************
* Macro:           PERCENTILES                                                *
*                                                                             *
* Author:          Philip Mason                                               *
*                                                                             *
* Date Created:    01/08/2016                                                 *
*                                                                             *
* Description:     Generate percentiles using a variable from a table and     *
*                  then write them into a series of macro variables           *
*                                                                             *
* Parameters:      dset = dataset to use                                      *
*                  var = variable to use from dataset for generating %tiles   *
*                  pctlpts = list of percentiles to generate, separated by     *
*                            spaces. A global macro variable will be created  *
*                            for each one. e.g. 10 would produce &pct10       *
*                                                                             *
* Data Sources:    &dset                                                      *
*                                                                             *
* Data Output:     _stats                                                     *
*                                                                             *
* Auxiliary Files: n/a                                                        *
*                                                                             *
*-----------------------------------------------------------------------------*
* Modification History                                                        *
* Date        By   Details                                                    *
* 01/08/2016  PM   Original Coding                                            *
******************************************************************************/
%macro percentiles(dset, /* dataset to use */
                   var,  /* variable to use */
                   pctlpts=50 60 70 80 90 95 99, /* percentiles that we want */
                   clear_first=0 /* 1 = clear macro variables named 'PCT%' first */
                   ) ;
   * work out some percentiles ;
   proc univariate data=&dset noprint ;
      var &var ;
      output out=_stats 
             pctlpts  = &pctlpts
             pctlpre = pc
             pctlname = 
             %do i=1 %to %eval(%sysfunc(count(&pctlpts,%str( )))+1) ;
                %let item=%scan(%superq(pctlpts),&i,%str( )) ;
                t&item 
                %end ;
             ;
   run ;
 
   %if &clear_first %then %do ;
      %let pct_vars=;
      proc sql noprint ;
         select name into :pct_vars separated by ' '
         from dictionary.macros where name like 'PCT%' ;
      %symdel &pct_vars / nowarn ;
   %end ;
 
   * put the percentiles into global macro variables ;
   data _null_ ;
      length varname $ 32 ;
      dsid=open("_stats") ;
      call set(dsid) ;
      rc=fetch(dsid) ;
      do i=1 to attrn(dsid,'nvars') ;
         varname=varname(dsid,i) ;
         value=getvarn(dsid,i) ;
         call execute('%global '||varname||';') ;
         call symputx(varname,value) ;
         put varname '=' value ;
      end ;
      dsid=close(dsid) ;
   run ;
%mend percentiles ;