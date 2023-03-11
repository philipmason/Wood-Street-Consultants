*** FLEXIBLE NEW DATE FORMAT ;

   options datestyle=mdy;

   data _null_;
     date=input('01/02/03',anydtdte8.); * ambiguous date ;
     put date=date9.;
   run;

   options datestyle=ydm;

   data _null_;
     date=input('01/02/03',anydtdte8.); * ambiguous date ;
     put date=date9.;
   run;

   options datestyle=myd;

   data _null_;
     date=input('01/31/2003',anydtdte10.); * unambiguous date, so option ignored ;
     put date=date9.;
   run;

