/***
Program Name : Doc
Date         : 5Feb2004
Written By   : Phil Mason
Overview     : Scans a directory and looks at all SAS code,
               stripping out the comments and creating a
               MS Word file for documentation
Parms        : target ... directory where modules are
                          located that we wish to document 
***/
%macro doc(target) ;
filename dir pipe "dir ""&target""" ;
data files(keep=file line) ;
  length file line $ 200 
         next $ 8 ;
  label file='Filename'
        line='Header' ;
  if _n_=1 then
    put '*** Processing files ***' / ;
  infile dir missover ;
 * You may need to adjust this depending on the version of the operating system you are running on – for my system I am able to read the file name from a directory listing at column 37 ;
  input @37 file & ;
 * Only continue if the file is a SAS file ;
  if index(upcase(file),'.SAS')>0 ;
  put '--> ' file ;
  next='' ;
 * Point to that SAS file ;
  rc1=filename(next,"&target\"||file) ;
 * Open it up ;
  fid=fopen(next) ;
  write=0 ;
 * Read through each line of the SAS file ;
  do while(fread(fid)=0) ;
    line=' ' ;
    rc3=fget(fid,line,200) ;
     * if it is the start of a comment block then I will write line ;
	if index(line,'/*')>0 then
	  write=1 ;
	if write then
        output ;
     * if its end of comment block I will stop writing lines ;
	if index(line,'*/')>0 then
	  write=0 ;
   * we only process comment blocks that start on the first line
     - i.e. headers ;
     * only continue reading lines if I am currently in a comment block ;
	if ^write then
	  leave ;
  end ;
 * close file ;
  fid=fclose(fid) ;
  rc=filename(next) ;
run ;
* free the file ;
filename dir ;
* point to an rtf file to create ;
ods rtf file='c:\Documentation.rtf' ;
title "Documentation for &target" ;
data _null_ ;
  set files ;
    by file notsorted ;
  file print ods ;
  if first.file then
    put @1 file @ ;
  put @2 line ;
run ;
* close the rtf file ;
ods rtf close ;
%mend doc ;
Sample invocation
%doc(C:\Programs)
