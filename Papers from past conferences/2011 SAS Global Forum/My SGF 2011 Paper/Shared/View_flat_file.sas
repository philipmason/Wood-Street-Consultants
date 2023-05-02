*ProcessBody;

%let _result=streamfragment ;
%macro viewFlatFile ;
 %* use flatfile passed in as parm, or else use default ;
  %if %symexist(flatfile)=0 %then %let flatfile=/home/sasusers/masonp1/logs/activity.log ;

  data _null_ ;
    file _webout ;
    if _n_=1 then do ;
      put '<html><head>' ;
      put '<style type="text/css">' ;
      put 'a:link {text-decoration: none}' ;
      put 'a:visited {text-decoration: none}' ;
      put 'a:active {text-decoration: none}' ;
      put 'a:hover {font-size:24; font-weight:bold; color: red;}' ;
      put '</style>' ;
      put '</head><body><pre>' ;
      end ;
    infile "&flatfile" ;
    input ;
    put _infile_ ;
  run ;

  data _null_ ;
    file _webout ;
    put '</pre></body></html>' ;
  run ;
%mend viewFlatFile ;
%viewFlatFile ;

*';*";*/;run;
