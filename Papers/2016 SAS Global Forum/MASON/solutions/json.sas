* create a JSON version of the SAS table ;
proc json out=_webout pretty nosastags ;
write open object ;
write values "rows" ;
write open array ;
export sashelp.orsales ;
write close ;
write close ;
run ;