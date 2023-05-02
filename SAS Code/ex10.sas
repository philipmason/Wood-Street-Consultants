data people ;
  input id race ;
  label id='Id number'
        race='Race code: 1=Black, 2=White, 3=Black/White, 4=Black/White/Other' ;
cards ;
1 3
2 1
3 3
4 2
5 4
6 2
7 4
;;
run ;
proc format ;
  value race (multilabel)
    1='Black'
    2='White'
    3='Black'
    3='White'
    4='Black'
    4='White'
    4='Other' ;
run ;
proc means data=people ;
  format race race. ;
  class race / mlf ;
run ;
