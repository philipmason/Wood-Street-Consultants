%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%* Macro name      : message_js_alert.sas                               **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Michael Wall                                       **
%* Date            : 07 Jan 2009                                        **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%* Purpose         : Used to display a JavaScript alert box with a      **
%*                   message.  Idea is that all messages will look the  **
%*                   same.  So updating this messgae macro will update  **
%*                   all messages in the system                         **
%* Comments        :                                                    **
%*************************************************************************
%*  Modification history                                                **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%************************************************************************;
%*  ;

%macro message_js_alert(text) ;

  %* Bring up a Javascript message box;
  data _null_ ;
    file _webout ;
    txt = '<script type="text/javascript">alert("' !! "&text" !! '")</script>';
    put txt;
  run;

%mend message_js_alert;
