* Get a SAS environment variable ;
%let sasroot=%sysget(sasroot) ;
%put sasroot=&sasroot ;

* Get an operating system environment variable ;
%let comspec=%sysget(comspec) ;
%put comspec=&comspec ;
