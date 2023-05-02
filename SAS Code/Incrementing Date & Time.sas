data _null_ ;
  format date date7.
         datetime datetime16.
         time time8. ;
  date=intnx('month','10oct97'd,0) ;
  datetime=intnx('dtday','10oct97:12:34:56'dt,0) ;
  time=intnx('hour','12:34't,0) ;
  put date= / datetime= / time= ;
run ;
