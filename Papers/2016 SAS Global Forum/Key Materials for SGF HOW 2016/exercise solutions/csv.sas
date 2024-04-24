proc summary data=sashelp.orsales nway ;
	class Quarter  ;
	var Total_Retail_Price Quantity Profit ;
	output out=sum_orsales(drop=_type_ _freq_) sum= ;
run ;

* create a CSV version of the summary ;
proc export data=sum_orsales outfile=_webout dbms=csv replace ;
run ;