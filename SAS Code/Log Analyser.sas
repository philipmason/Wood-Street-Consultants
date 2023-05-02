DATA SASUSER.BATCHjce(drop=line secs _:) ;
  retain _obs _vars _dset ;
  LENGTH LINE $ 200 DSET _dset PROC $ 17 ;
  format cpu time8. obs comma11. ;
  INFILE 'BATCH_jce.LOG' MISSOVER ;
  INPUT LINE & @ ;
  IF LINE=:'NOTE:' OR LINE=:'ERROR:' OR LINE=:'WARNING:' ;
  INPUT @1 @'data set' DSET
        @1 @'PROCEDURE ' PROC
        @1 @'used' cpu
        @1 @'and ' vars @ ;
  if ^index(line,'has been') then
    input @1 @'has ' obs @ ;
  if index(line,'minutes') then
    INPUT @1 @'minutes' secs ;
  else
    if index(line,'minute') then
      INPUT @1 @'minute' secs ;
  if secs>0 then
    cpu=sum(cpu*60,secs) ;
  if dset=' ' then
    dset=_dset ;
  if obs<0 then
    obs=_obs ;
  if vars<0 then
    vars=_vars ;
  if dset!!proc>' ' or
     sum(obs,cpu,vars)>0 then
    do ;
      if proc=' ' & index(line,'DATA')>0 then
        proc='DATA' ;
      output ;
      if cpu>0 then
        do ;
          obs=0 ;
          vars=0 ;
          dset='' ;
        end ;
    end ;
  else
    put line= ;
  _dset=dset ;
  _obs=obs ;
  _vars=vars ;
RUN ;
proc sort ;
  by descending cpu ;
proc print ;run;
