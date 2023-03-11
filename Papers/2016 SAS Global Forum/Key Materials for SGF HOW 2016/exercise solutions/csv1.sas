data test ;
	length name spent $ 4 year 8 ;
	input name & spent & year ;
	cards ;
Mr A  $40  2011
Mr B  $10  2011
Mr C  $40  2011
Mr A  $70  2012
Mr B  $20  2012
Mr B  $50  2013
Mr C  $30  2013
;;
run ;

data _null_ ;
	file _webout delimiter=',' ;
	set test end=_end ;
	if _n_=1 then put 'Name,Spent,Year' ;
	put name spent year ;
run ;