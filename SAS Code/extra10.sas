data case;
  retain Seed_1 Seed_2 Seed_3 1 ;
  do i=1 to 10;
    call ranuni(Seed_1,X1) ; * call with unchanging seed ;
    call ranuni(Seed_2,X2) ; * call with seed changing half way through ;
    X3=ranuni(Seed_3) ;      * function with seed changing half way through ;
    output;
   * change seed for last 5 rows ;
    if i=5 then
      do;
        Seed_2=2;
        Seed_3=2;
      end;
  end;
run;
proc print;
  id i;
  var Seed_1-Seed_3 X1-X3;
run;
