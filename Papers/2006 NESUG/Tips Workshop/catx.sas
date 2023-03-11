*** CONCATENATING STRINGS THE EASY WAY ;
data test ;
  a='  Phil         ' ;
  b='   Mason ' ;
  c=trim(left(a))!!' '!!left(b) ;
  d=catx(' ',a,b) ;
  put c= d= ;
run ;
