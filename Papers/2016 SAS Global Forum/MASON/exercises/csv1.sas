data test ;
	length name spent $ 4 year 8 ;
	input name & spent & year ;
	cards ;
? data should be in this kind of format, 1 record per line, fields separated by 2 spaces?
Mr X  $100  2016
;;
run ;

data _null_ ;
	file ?fileref for streaming to web browser from a stored process? delimiter='?for CSV?' ;
	set test end=_end ;
	if _n_=1 then put 'Name,Spent,Year' ;
	put name spent year ;
run ;