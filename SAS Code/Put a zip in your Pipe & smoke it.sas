** Define pipe to get output from PKZIP ;
filename testpipe pipe 'pkunzip.exe c:\sas\colon -c' ;

data report ;
 * Read data from pipe ;
  infile testpipe ;
  input line & $200. ;
 * Skipping PKZIP header ;
  if _n_<=9 then
    delete ;
run ;

proc print data=report ;
run ;
