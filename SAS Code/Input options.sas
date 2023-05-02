data clever ;
  input @1 idnum 4.
        @6 date ?? ddmmyy8. ;
  format date ddmmyy8. ;
cards ;
1234 28/06/64
5678 00/00/00
9876 99/06/64
;
run ;

proc print ;
run ;
