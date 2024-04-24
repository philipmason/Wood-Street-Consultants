filename temp ?libname engine for making a temporary file? ;
proc ?proc for making JSON? out=temp ?optional parameters? ;
	export sashelp.orsales ;
run ;
data _null_ ;
	infile temp ;
	input ;
	put _infile_ ;
run ;