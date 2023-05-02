options noxwait noxsync  ;
x '"C:\Program Files\SAS Institute\SAS\V8\spawner.exe" -comamid tcp' ;
signon jvc;
rsubmit ;
  %put REMOTE: &sysver;
endrsubmit ;
%put LOCAL: &sysver;
signoff ;
