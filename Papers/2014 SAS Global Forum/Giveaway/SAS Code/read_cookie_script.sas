%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : read_cookie_script.sas                             **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : Writes javascript which will read a cookie and     **
%*                   create a javascript variable of the same name.     **
%*                   This should usually be run before the stpbegin     **
%*                   macro has been run, so that we can read the cookie **
%*                   we need before its value is needed in other        **
%*                   scripts                                            **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             :                                                    **
%*  Date           :                                                    **
%*  Details        :                                                    **
%************************************************************************;
%*  ;

%macro read_cookie_script(name,alert=0) ;
 * name - name of cookie to read ;
 * alert - 0=no alert, 1=do a javascript pop-up window alert with value of cookie ;
  data _null_ ;
    file _webout ;
    put "<script>var &name = readCookie('&name') ;" ;
    %if &alert %then
      put "alert(&name) ;" ;;
    put "</script>" ;
  run ;
%mend read_cookie_script ;
