*** COUNTING WORDS ;

data _null_ ;
  sentence='This is ONE way of using one in One sentence' ;
  num=count(sentence,'one','i') ;
  put num= ;
run ;
