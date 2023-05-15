/**
@file       eanbegin.sas
@brief      Start Enhanced Analysis
@details    This macro uses values from the _eandebug macro variable (if it exists). That allows you to
            switch on or off the enhanced analysis, together with some optional parameters. 
            The purpose of this macro is to start recording information about SAS code that is running.
            The information is recorded to a file, which can later be analysed to produce a diagram
            that describes the execution of the SAS code.
@author     Phil Mason
@note       Macro variable _EANDEBUG defines what kind of enhanced
            analysis is carried out according to the following values:
            - scaproc = uses Proc SCAPROC                   
            - verbose = turns on extra verbose logging      
            - on = has the effect of scaproc,verbose        
            - 1 = has the effect of scaproc,verbose values for _EANDEBUG should be comma separated  
@param[in]  use_label     specify a label to use in .DOT output that is produced (optional)
            where         specify a location for PROC SCAPROC to write its output to,
                          will default to a text file in your own work directory (optional)
            _options      specify options to use when using PROC SCAPROC (optional)
            scaproc_file  specify a filename to use for the scaproc created (optional)
@returns    dataset produced is put into location defined by the **where** parameter
            By default puts it in users Work directory
@note       This documentation uses doxygen formating, for automatic creation of documentation.
*/
%macro eanbegin(use_label,
                scaproc_file=scaproc.txt,
                where=%sysfunc(pathname(WORK)),
                _options=attr opentimes expandmacros) ;
   %* if _eandebug macro exists and is not set to 0 or off, then continue ;
   %if %symexist(_eandebug)=0 %then %return ;
   %if &_eandebug=0 or %upcase(&_eandebug)=OFF %then %return ;
   %if %superq(use_label)= %then %let use_label=Program run by &sysuserid ;

   %* process parameters ;
   %let n_parms=%eval(%sysfunc(count(%superq(_eandebug),%str(,)))+1) ;
   %do i=1 %to &n_parms ;
      %let parm=%upcase(%scan(%superq(_eandebug),&i,%str(,))) ;
      %put INFO: EANBEGIN macro invoked: &parm ;
      %if &parm=SCAPROC or &parm=ON or &parm=1 %then %do ;
         * Start recording info to a text file ;
         proc scaproc ;
            record "&where/&scaproc_file" &_options ;
         run ;
         %global scaproc_label ;
         %let scaproc_label=&use_label ;
         %end ; /* scaproc */
      %else %if &parm=VERBOSE or &parm=ON or &parm=1 %then %do ;
         * Turn on various extra logging ;
         options symbolgen
                 mlogic mlogicnest
                 mprint mprintnest
                 mautolocdisplay mautocomploc
                 msglevel=i ;
         %* look at macro variables before process ;
         %put _all_ ;
         %end ; /* verbose */
      %end ; /* do */
%mend eanbegin ;
