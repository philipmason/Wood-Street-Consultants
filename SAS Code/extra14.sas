*** need to assign this macro call to a button on toolbar
    so that pressing the button will analyse the log ;
filename cat catalog 'work.test.test.log' ;
dm 'log;file cat' ; * write log to catalog member ;
ods listing close ;
ods html file='analyse.htm' ;
data analyse ;
  length line $200 ;
  label line='Line from LOG'
        _n_='Line number' ;
  infile cat end=end truncover ;
  file print ods=(vars=(_n_ line)) ;
  input line & ;
  if substr(line,1,5)='ERROR' then
    put _ods_ ;
  else
    if substr(line,1,7)='WARNING' then
      put _ods_ ;
	else
	  n+1 ;
  if end & n=_n_ then
    do ;
	  window status rows=15 columns=40 color=gray
               #5 'No errors or warnings were found.' color=yellow
               #9 'Press enter to continue' ;
	  display status ;
	end ;
run ;
ods html close ;
filename cat ; * free catalog member ;
dm 'del work.test.test.log' results viewer ; * delete it & show HTML ;
ods listing ;
