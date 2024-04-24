%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%* Macro name      : ods_button.sas                                     **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 21Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : This macro makes standard title statements for use **
%*                   in graphs or text reports                          **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*                                                                      **
%*  Reference      : 001                                                **
%*  By             : Michael Wall                                       **
%*  Date           : 03 Dec 08                                          **
%*  Details        : Remove # from URL                                  **
%*                                                                      **
%*  By             : Philip Mason                                       **
%*  Date           : 05 Aug 2009                                        **
%*  Details        : added an stpend to fix a problem from a calling    **
%*                   stored process                                     **
%*                                                                      **
%************************************************************************;

%macro ods_button(ods=) ;
  %if %symexist(_odsdest) %then
    %if %upcase(&_odsdest)=RTF or
        %upcase(&_odsdest)=PDF %then
      %return ;

  %if &bypass=0 %then
    %stpend ;

  data _null_ ;
    file _webout  ;
    %* REF001: Remove trailing # from URL  - START;
    put '<a href="#"'
           'onClick="var loc = window.location ; loc = loc + ''&_odsdest=rtf'' ; loc = loc.replace(''#'','''') ; window.open(loc) ;"'
           'style="background:black;color:white;font-size:large"><button>Send to RTF</button></a>' ;
    %* REF001: Remove trailing # from URL  - STOP;
  run ;

%mend ods_button ;
