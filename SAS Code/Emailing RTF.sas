data _null_ ;
  infile 'c:\test.txt' lrecl=1000 end=end;
  input ;
  file 'userid' email ;
  put _infile_ ;
  if end then do;
  put '!EM_TO! phil@wood-st.demon.co.uk' ;
  put '!EM_SUBJECT! test of rtf mail' ;end ;
run;
