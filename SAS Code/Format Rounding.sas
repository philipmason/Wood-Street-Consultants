options fmtsearch=(sasuser) ;
proc format library=sasuser  ;
  picture dol (round)
  low- -1000000       = '000,000,009M'     (prefix='-$' mult=.000001)
  -1000000 <- -1000   = '009K'             (prefix='-$' mult=.001)
  -1000 <- <0         = '009'              (prefix='-$')
  0 - <1000           = '009'              (prefix='$')
  1000 -< 1000000     = '009K'             (prefix='$' mult=.001)
  1000000 - high      = '000,000,009M'     (prefix='$' mult=.000001) ;
run;

* Test format ;
data _null_ ;
  input x ;
  put _n_ x dol. -l ;
cards;
-1234567890
-1234
0
987654
999999
1339995
;
run ;
