* create a JSON version of the SAS table ;
proc json out='\\D351TQ92\htdocs\test\orsales.json' pretty nosastags ;
write open object ;
write values "rows" ;
write open array ;
export sashelp.orsales ;
write close ;
write close ;
run ;

/** create a CSV version of the SAS table ;*/
/*proc export data=sashelp.orsales outfile='\\D351TQ92\htdocs\test\orsales.csv' dbms=csv replace ;*/
/*run ;*/

* create a TSV version of the SAS table ;
proc export data=sashelp.orsales outfile='\\D351TQ92\htdocs\test\orsales.tsv' dbms=dlm replace ;
	delimiter='09'x ;
run ;

* summarise before making a CSV ;
proc summary data=sashelp.orsales nway ;
	class Quarter  ;
	var Total_Retail_Price Quantity Profit ;
	output out=sum_orsales(drop=_type_ _freq_) sum= ;
run ;

* create a CSV version of the summary ;
proc export data=sum_orsales outfile='\\D351TQ92\htdocs\test\sum_orsales.csv' dbms=csv replace ;
run ;
