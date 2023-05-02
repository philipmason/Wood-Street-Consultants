* Compare 2 SAS programs - compress spaces, line numbers ;
FILENAME run PIPE 'c:\windows\command\fc.exe c:\sas\colon.sas c:\sas\colon2.sas /n /w' ;
*FILENAME run PIPE 'mem' ;
DATA _NULL_ ;
  LENGTH line $ 80 ;
  INFILE run LENGTH=ll ;
  INPUT @ ; INPUT line $varying. ll ;
  PUT line;
RUN;
