%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : message_html_fragment.sas                          **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : this is used whenever we want to display a message **
%*                   to the user in the area we are currently writing   **
%*                   html to. Being in this macro also means that we    **
%*                   could change this to enhance the look/feel         **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             : Michael Wall                                       **
%*  Date           : 07 Jan 09                                          **
%*  Details        : Check type of message and display alert box if an  **
%*                   error.  Also display all messages as HTML text.    **
%************************************************************************;
%*  ;

%macro message_html_fragment(title,text) ;

  %if %symexist(_odsdest) %then
    %if %upcase(&_odsdest)=RTF or
        %upcase(&_odsdest)=PDF %then
      %return ; 

  %local element;

  data _null_;
    select(upcase(scan(symget('title'),1)));
      when('ERROR')     element='h1';
      when('WARNING')   element='h2';
      when('ATTENTION') element='h2';
      when('MESSAGE')   element='h3';
      when('NOTE')      element='h3';
      otherwise         element='h3';
    end;
    call symput('element',element);
  run;

  %if &element^=h3 %then %message_js_alert(&title.: &text);

  data _null_ ;
    file _webout ;
    element=symget('element');
    if element='h1' then do;
      put '<h1><font size="4" color="Red">' "&title" '</font></h1><p>' ; 
    end;
    else if element='h2' then do;
      put '<h2><font size="3" color="Orange">' "&title" '</font></h2><p>' ; 
    end;
    else if element='h3' then do;
      put '<h3><font size="2" color="Black">' "&title" '</font></h3><p>' ; 
    end;

    put "&text" ; 
    put '<hr>' ;
  run ;

%mend message_html_fragment ;
