filename temp temp ;
proc json out=temp pretty nosastags ;
	export sashelp.orsales ;
run ;
data _null_ ;
	infile temp ;
	input ;
	put _infile_ ;
run ;