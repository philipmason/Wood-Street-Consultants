filename temp ?libname engine for making a temporary file? ;
proc ?procedure for making JSON output? out=temp ;
	?statement to send data out in JSON format? sashelp.orsales ;
run ;
data _null_ ;
	infile temp ;
	input ;
	put _infile_ ;
run ;