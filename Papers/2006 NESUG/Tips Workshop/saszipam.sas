/* USING THE ZIP ENGINE TO READ ZIP FILES
There is a currently undocumented filename engine available in SAS 9 that can be used to read from compressed ZIP files directly. You simply specify the engine "SASZIPAM" on a filename statement, and when referring to it you must specify the file within it that you wish to read. In the example below "tomcat.zip" contains a number of files. I want to read "tomat.log" and therefore specify "in(tomcat.log)", where "in" is the libref and "tomcat.log" is the file I will read from the zip file.*/

filename in saszipam 'c:\workshop\hw06\test.zip';

data _null_;
  infile in(tomcat.log);
  input ;
  put _infile_;
  if _n_>10 then
    stop ;
run;
