filename files pipe 'dir /l/b c:\*.*' ;
data figfile ;
  infile files pad lrecl=128 ;
  input fname $128. ;
run ;
proc print ;
run ;
