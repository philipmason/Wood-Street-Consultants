data a ; do x=1 to 1e5 ; z=uniform(2)*1e3; output ; end ; run ;
data b ; do y=1 to 1e5 ; zz=uniform(2)*1e3;output ; end ; run ;

proc sql noprint ;
select count(z) into :nobs from a ;
quit ;
%put SQL nobs=&nobs;

data _null_ ;
  dsid=open('a','i') ;
  nobs=attrn(dsid,'nlobs') ;
  call symput('nobs',nobs) ;
  dsid=close(dsid) ;
run ;
%put Data Step nobs=&nobs;
