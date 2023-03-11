%*************************************************************************
%*------------------- Copyright Astellas Europe B.V --------------------**
%*----------------------------------------------------------------------**
%*                                                                      **
%* Macro name      : write_Cookie_functions.sas                         **
%* Version number  : 001                                                **
%* Location        : /sas/bis/&env/tools/medmon/macros                  **
%* Author          : Phil Mason                                         **
%* Date            : 19Aug2008                                          **
%* SAS version     : 9.1.3 SP4                                          **
%* Macros called   :                                                    **
%*                                                                      **
%* Purpose         : This macro should be run before stpbegin macro so  **
%*                   that the script is defined that defines 3          **
%*                   javascript functions which are used for dealing    **
%*                   with cookies:                                      **
%*                   - createCookie(name,value,days)                    **
%*                   - readCookie(name)                                 **
%*                   - eraseCookie(name)                                **
%* Comments        :                                                    **
%*                                                                      **
%*************************************************************************
%*  Modification history                                                **
%*  By             : Phil Mason                                         **
%*  Date           : 9Sep2008                                           **
%*  Details        : Changed url to use &srvname:&srvport               **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 19Sep2008                                          **
%*  Details        : Remove javascript errors by improving code         **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 04Aug2008                                          **
%*  Details        : Added a function called set_window to support the  **
%*                   new framework that allows turning reports on/off   **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 26Aug2009                                          **
%*  Details        : added set_window2 to support SDTM in medmon        **
%*                                                                      **
%*  By             : Phil Mason                                         **
%*  Date           : 14Jan2010                                          **
%*  Details        : changed set_window call to also use X & Y pixels   **
%*                                                                      **
%************************************************************************;


%macro write_cookie_functions ;
  %if %symexist(_odsdest) %then
    %if %upcase(&_odsdest)=RTF or
        %upcase(&_odsdest)=PDF %then
      %return ; 

  data _null_ ;
    file _webout ;

    put '<script type="text/javascript" language="javascript">' ;
    put 'function testMe (form)' ;
    put '{' ; *1;
    put 'var ctr = 0;' ;
    put 'var mctr = 4; /* this is the maximum number of options you want selected */' ;
    put 'var selObj = document.getElementById(''m'');' ;
    put 'for (var i=0; i< selObj.options.length; i++)' ;
    put '  {' ; *2;
    put '  if (selObj.options[i].selected===true) {' ; *3;
    put '    ctr++;' ;
    put '    if (ctr>mctr) { selObj.options[i].selected=false ;}' ;
    put '    }' ; *3;
    put '  }' ;*2;
    put 'if (ctr>mctr)' ;
    put '  {' ; *4;
    put '  alert("You have selected too many lab measures, only " + mctr + " are permitted.");' ;
    put '  return false;' ;
    put '  }' ; *4;
    put 'return true;' ;
    put '}' ;*1;

    put 'function set_window(new_url,w,h)' ;
    put "{ parent.document.location.href = ""http://&_srvname:&_srvport/SASStoredProcess/do?_program=SBIP%3A%2F%2FFoundation%2F&env.%2Fbis%2Fmedmon%2Fmain2%28StoredProcess%29" @ ;
    put '&_gopt_xpixels=" + w + "&_gopt_ypixels=" + h + "&_study=" + new_url ; }' ;

    put 'function set_window2(new_url, sdtm)' ;
    put "{ parent.document.location.href = ""http://&_srvname:&_srvport/SASStoredProcess/do?_program=SBIP%3A%2F%2FFoundation%2F&env.%2Fbis%2Fmedmon%2Fmain2%28StoredProcess%29" @ ;
    put '&_study=" + new_url + "&sdtm=" + sdtm ; }' ;

    put 'function cookie_save(cookies)' ;
    put "{ window.parent.document.getElementById('main').src = ""http://&_srvname:&_srvport/SASStoredProcess/do?_program=SBIP%3A%2F%2FFoundation%2F&env.%2Fbis%2Fmedmon%2Fcookie_save%28StoredProcess%29" @ ;
    put '&cookies=" + cookies ; }' ;

    put 'function cookie_delete_all(name,value,days)' ;
    put "{ window.parent.document.getElementById('menu').src = ""http://&_srvname:&_srvport/SASStoredProcess/do?_program=SBIP%3A%2F%2FFoundation%2F&env.%2Fbis%2Fmedmon%2Fcookie_delete_all%28StoredProcess%29"" ; }" ;

    put 'function createCookie (name,value,days) {' ;
    put '  if (days) {' ;
    put '    var date = new Date();' ;
    put '    date.setTime(date.getTime()+(days*24*60*60*1000));' ;
    put '    var expires = "; expires="+date.toGMTString(); }' ;
    put '  else { var expires = ""; }' ;
    put '  document.cookie = name+"="+value+expires+"; path=/";' ;
    put '}' ;

    put 'function readCookie (name) {  var nameEQ = name + "=";' ;
    put ' var ca = document.cookie.split('';'');' ;
    put ' for(var i=0;i < ca.length;i++) { var c = ca[i];   while (c.charAt(0)=='' '') { c = c.substring(1,c.length); }' ;
    put ' if (c.indexOf(nameEQ) === 0) { return c.substring(nameEQ.length,c.length); } } return null;}' ;

    put 'function eraseCookie (name) { createCookie(name,"",-1);}' ;

    put 'function delete_all_cookies () ' ;
    put '{ ' ;
    put '	// Get cookie string and separate into individual cookie phrases:' ;
    put '	var cookie_string = "" + document . cookie;' ;
    put '	var cookie_array = cookie_string . split ("; ");' ;
    put '	// Try to delete each cookie:' ;
    put '	for (var i = 0; i < cookie_array . length; ++ i)' ;
    put '	{' ;
    put '		var single_cookie = cookie_array [i] . split ("=");' ;
    put '		if (single_cookie . length != 2)' ;
    put '			{ continue; }' ;
    put '		var name = unescape (single_cookie [0]);' ;
    put '		if (name !="studydir" && name !="studydirs" && name !="use_new_where" &&' ;
    put '       name !="style" && name !="graphic_device") {eraseCookie (name);} ' ;
    put '	}' ;
    put '}' ;

    put 'function getOptions (name){ var x = document.getElementById(name) ; txt = " " ;' ;
    put ' for (i = 0; i < x.length; i++) {if (x.options[i].selected === true)' ;
    put ' { txt = txt + " " + x.options[i].text; } }  createCookie(name,txt,31) ;}' ;

    put '</script>' ;
  run ;
%mend write_cookie_functions ;
