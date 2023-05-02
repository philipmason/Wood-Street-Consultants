filename cmd pipe "dir c:\sas\af /s" ;

data files(keep=dir dirflag file date time) ;
  format date date9. time timeampm. ;
  length ampm $ 1
         file line dir $ 200 ;
  retain dir ;
  infile cmd missover length=ll ;
  ampm=' ' ;

*** Windows NT version ;
*  input @1  date     ?? ddmmyy8.
        @11 time     ?? time5.
        @11 timetext     $5.
        @16 ampm     $1.
        @26 dirtest  $3.
        @39 file     & $char200.
        @1  line     $varying200. ll ;

*** Windows 98/95 version ;
  input @29 date     ?? ddmmyy8.
        @39 time     ?? time5.
        @17 dirtest  $3.
        @45 file     & $char200.
        @1  line     $varying200. ll ;

  if dirtest='DIR' then
    dirflag=1 ;

  if upcase(ampm)='P' & time>0 then
    time=time+'12:00:00't ;

  pos=index(line,'Directory of') ;
  if pos>0 then
    dir=substr(line,pos+13) ;
  if date>. & file ^in ('.','..') ;
run ;

proc print ;
  by dir notsorted ;
  id dir ;
  var file dirflag date time ;
run ;
