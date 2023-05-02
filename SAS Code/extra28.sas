%macro cliplog(marker1,marker2,pos=last,file=c:\test.txt) ;
 * note: split search text in half so we dont go and find it in our macro call ;
 * note: save mprint option since we want mprint turned off for the macro run, otherwise
         we get our search text written to the log and we will find it ;
  %let o=%sysfunc(getoption(mprint)) ;
  options nomprint ;
/* log;
   find '&marker1&marker2' &pos;
   rfind;
   mark;
   bottom;
   mark;
   store;
   unmark;
   notepad;
   clear;
   paste;
   file '&file';
   end
*/
  dm "log;find '&marker1&marker2' &pos;mark;bottom;mark;store;unmark;notepad;clear;paste;file '&file';end" ;
 * view the file in windows notepad ;
  x "notepad &file" ;
  options &o ;
%mend cliplog ;
Capturing part of a log
The following skeleton code shows how you might mark the start of a section you want to copy. You then run the SAS code for which you want to capture the log. Once that is done you call the macro to capture that section of the log.
***BEGIN***; /* this marks where to start the copying from the log */
/* now run all the SAS code you would like to capture */
%cliplog(***BEGIN,***) ; /* finally we call the macro which captures the log from the point we previously marked */
