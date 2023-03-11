%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : html_parms_to_list.sas                             **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : picks up sets of macro variables which are in the  **
%*                   form used by HTML parameters. if we have one html  **
%*                   parm, e.g. &x=1, then we get a macro variable      **
%*                   called x with the value 1. However if we have      **
%*                   multiple values for an html parm, e.g. &x=1&x=2    **
%*                   then we get a macro variable called x0 with a count** 
%*                   of how many values there are, and a macro variable **
%*                   called x1 for the 1st value, and another called x2 **
%*                   for the second parameter. This macro combines all  **
%*                   values for an HTML parameter and creates a list of **
%*                   those values                                       **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%************************************************************************;
%*  ;


%macro html_parms_to_list(in,
                          out,
                          default=_:,   /* optional value to use as a default */
                          sep=%str( ),  /* optional one character separator */ 
                          quote=0,      /* 1=quote values, 0=dont quote values */
                          partstmt=0    /* 1=make part of where statement, 0=dont */
                          ) ;
  %global &out ;
  %let &out= ;
  %if &quote %then
    %let _q_=%str(%') ;
  %else
    %let _q_= ;
  %if %symexist(&in.0) %then
    %do ;
      %do j=1 %to &&&in.0 ;
        %let &out=&&&out..&sep.%superq(_q_)&&&in.&j%superq(_q_) ;
      %end ;
    %end ;
  %else
    %if %symexist(&in) %then
      %let &out=%superq(_q_)&&&in%superq(_q_) ;
    %else
      %let &out=%superq(_q_)&default%superq(_q_) ;
  %if %symexist(&in.0) %then
    %let &out=%qsubstr(%superq(&out),2) ;
  %if &partstmt=1 %then
    %do ;
      %if %symexist(&in) %then
        %do ;
          %if %superq(&in)=_ALL_ %then
            %let &out= ;
          %else
            %let &out=and &in in (%superq(&out)) ;
        %end ;
      %else
        %let &out=and &in in (%superq(&out)) ;
    %end ;
%mend html_parms_to_list ;
/*%let m0=2 ; %let m1=abc ; %let m2=def ; %html_parms_to_list(m,mlist) ; %put mlist=&mlist ;*/
/*%let m0=2 ; %let m1=abc ; %let m2=def ; %html_parms_to_list(m,mlist,sep=%str(,),quote=1) ; %put mlist=&mlist ;*/
/*%let m0=2 ; %let m1=abc ; %let m2=def ; %html_parms_to_list(m,mlist,sep=%str(,),quote=1,partstmt=1) ; %put mlist=&mlist ;*/
/*%symdel m0 ; %let m=1 ; %html_parms_to_list(m,mlist,quote=1,sep=%str(-)) ; %put mlist=&mlist ;*/
/*%symdel m0 ; %let m=1 ; %html_parms_to_list(m,mlist,quote=1,sep=%str(,),partstmt=1) ; %put mlist=&mlist ;*/
