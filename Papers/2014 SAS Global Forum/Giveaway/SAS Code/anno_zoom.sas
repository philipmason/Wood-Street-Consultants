%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : anno_zoom.sas                                      **
%* Version number  : 002                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : produce an annotate file which can be used to add  **
%*                   an icon to a graph which will reproduce that       **
%*                   graph in a zoomed in or out form                   **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             : Phil Mason                                         **
%*  Date           : 9 Sep 2008                                         **
%*  Details        : Added code to pass pagenum if it is present        **
%*************************************************************************
%*  By             : Phil Mason                                         **
%*  Date           : 15 Sep 2008                                        **
%*  Details        : Added subject_per_graph if it is present           **
%************************************************************************;


%*** create an annotate dataset which can then be used to add an icon on a graph, which when clicked on
     will call the stored process again, but will toggle the value of the parameter called zoom ;
%macro anno_zoom / parmbuff ;
  %global zoom ;
 %* define the annotate macros ;
  %annomac ;

 %* work out any extra parms ;
  %let len=%length(%superq(syspbuff)) ;
  %if &len>2 %then
    %let parms=%qsubstr(%superq(syspbuff),2,%eval(&len-2)) ;
  %else
    %let parms= ;

 %* if we have pagenum defined, then pass it as a parm too ;
  %if %symexist(pagenum) %then
    %let parms=%superq(parms)%nrstr(&pagenum=)&pagenum ;

 %* if we have Subjects_per_Graph defined, then pass it as a parm too ;
  %if %symexist(Subjects_per_Graph) %then
    %let parms=%superq(parms)%nrstr(&subjects_per_graph=)&subjects_per_graph ;

 %* if we dont have a zoom parameter then set it to 0= not zoomed ;
  %if %symexist(zoom)=0 %then
    %let zoom=0 ;

 %* toggle the value of the zoom parameter ;
  %if &zoom=1 %then
    %let zoom=0 ;
  %else
    %let zoom=1 ;

 %* build a link variable which is the current stored process with the zoom parameter added ;
  %let link=http://&_SRVNAME:&_SRVPORT&_URL?_program=&_PROGRAM%nrstr(&zoom=)&zoom&parms ;

 * create the annotate dataset to add the zoom icon with hyperlink ;
  data anno_zoom ;
    length style $ 8 html $ 240 ;
    retain when 'a' ;
    %system(5,5,5) ;
    %slice (2, 2, 0, 360, 1, orange, ps, 0); 
    %circle (2, 2, 1.5, orange); 
    html="title=""Zoom"" href=""&link""" ;
    %circle (2, 2, 2, orange); 
  %if &zoom=1 %then
    %LABEL (2, 2, "+", black, 0, 0, 2, swissb, +); 
  %else
    %LABEL (2, 2, "-", black, 0, 0, 2, swissb, +); 
  ;
  run ;
%mend anno_zoom ;
