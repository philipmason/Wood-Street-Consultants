filename in saszipam 'c:\tomcat.zip';
data _null_;
  infile in(tomcat.log);
  input ;
  put _infile_;
  if _n_>10 then
    stop ;
run;
