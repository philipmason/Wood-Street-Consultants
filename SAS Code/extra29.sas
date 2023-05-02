%macro progress(every) ;
  window progress irow=4 rows=7 columns=40 
    #1 @6 'Processing record: ' _n_ persist=yes ;
  if mod(_n_,&every)=0 then
    display progress noinput ;
%mend progress ;
How to use it
All you need to do is to add the macro call to your data step. The following data step updates the record count every 1000 records read in.
data x ;
  infile 'm:\datasets\x.txt' ;
  input name $30. phone $18. ;
  %progress(1000) ;
run ;
