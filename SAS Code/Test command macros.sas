options cmdmac ;
%macro test / cmd ;
  dir sasuser ;
  build ;
  eis ;
%mend test ;
