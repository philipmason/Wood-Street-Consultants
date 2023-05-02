data x ;
  do i=0 to 2 ;
    j=round(uniform(i)*10) ;
    put _all_ ;
    output ;
  end ;
run ;

data y(index=(i)) ;
  do i=1 to 4 ;
    j=round(ranuni(i)*3) ;
    do k=1 to j ;
      put _all_ ;
      output ;
    end ;
  end ;
run ;

data z ;
  set x(in=in_x) ;
  set y(in=in_y) key=i ;
  put _iorc_= _all_ / ;
run ;
