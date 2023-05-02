   filename out 'c:\out.csv' ;
   data _null_;
     file out dsd;
     set sashelp.class;
     put (_all_) (:);
   run;
   filename out ;
