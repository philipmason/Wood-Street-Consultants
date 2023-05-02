%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : anno_info.sas                                      **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : produce an annotate file which can be used to add  **
%*                   an icon to a graph which will link to info about   **
%*                   the data used for that graph                       **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             : Phil Mason                                         **
%*  Date           : 10 Sep 2008                                        **
%*  Details        : Changed size to use cells rather than pct to fix   **
%*                   problem when we have very long graphs              **
%************************************************************************;


%*** create an annotate dataset which can then be used to add an icon on a graph, which when clicked on
     will call the stored process again, but will toggle the value of the parameter called zoom ;
%macro anno_info(parms) ;
 %* define the annotate macros ;
  %annomac ;

 %* build a link variable ;
  %let link=http://&_SRVNAME:&_SRVPORT&_URL?_program=SBIP%3A%2F%2FFoundation%2F&env.%2Fbis%2Fmedmon%2Fanno_info%28StoredProcess%29%nrstr(&parms)=&parms ;

 * create the annotate dataset to add the zoom icon with hyperlink ;
  data anno_info ;
    length function style $ 8 
           html $ 240 ;
    retain when 'a' ;
    %system(5,3,4) ;
/*    function='move' ;*/
/*    x=80 ;*/
/*    y=1 ;*/
/*    output ;*/
    %slice (99, 2, 0, 360, .30, purple, ps, 0); 
    html="title=""Info"" href=""&link""" ;
/*    function='image' ;*/
/*    imgpath='/sas/bis/info.gif' ;*/
/*    style='fit' ;*/
/*    x=99 ;*/
/*    y=19 ;*/
/*    output ;*/
/*    %circle (99, 2, .4, purple); */
    %LABEL (99.2, 2.2, "i", white, 0, 0, .4, swissb, +); 
  run ;
%mend anno_info ;
/*%anno_info ;*/
/*proc gchart data=sashelp.class anno=anno_info ;*/
/*  vbar age / discrete raxis=axis1 ;*/
/*run ;*/
/*quit ;*/
