proc format ;
  value loads
    5000-<6000 = 'Over 5,000'
    6000-<7000 = 'Over 6,000'
    7000-<8000 = 'Over 7,000'
    8000-<9000 = 'Over 8,000'
    other      = 'Mega!' ;

  value couple
    2 = 'Bingo!'
    5000-<10000 = [loads10.]
    other=[comma6.] ;
run ;

data _null_ ;
  input x ;
  put x couple. ;
  cards;
7777
1234
2
23
;
run ;
