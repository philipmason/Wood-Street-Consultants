/**
@file     eanend.sas
@brief    Stop Enhanced Analysis
@details  Having started an enhanced analysis with the eanbegin.sas macro, this will stop it.
@author   Philip Mason
@note     This documentation uses doxygen formating, for automatic creation of documentation.
*/

%macro eanend ;
    %* if _eandebug macro exists and is not set to 0 or off, then continue ;
    %if %symexist(_eandebug)=0 %then %return ;
    %if &_eandebug=0 or %upcase(&_eandebug)=OFF %then %return ;
  
    %* process parameters ;
    %let n_parms=%eval(%sysfunc(count(%superq(_eandebug),%str(,)))+1) ;
    %do i=1 %to &n_parms ;
       %let parm=%upcase(%scan(%superq(_eandebug),&i,%str(,))) ;
       %put INFO: EANBEGIN macro invoked: &parm ;
       %if &parm=SCAPROC or &parm=ON or &parm=1 %then %do ;
          * write out the recorded info ;
          proc scaproc ;
             write ;
          run ;
          %end ; /* scaproc */
       %else %if &parm=VERBOSE or &parm=ON or &parm=1 %then %do ;
          %* look at macro variables after process ;
          %put _all_ ;
          %end ; /* verbose */
       %end ; /* do */
 %mend eanend ;
