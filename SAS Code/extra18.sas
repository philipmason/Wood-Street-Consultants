ods listing close ;
ods html file='lifetest.html' style=mystyle;
ods graphics on;
proc lifetest data=sasuser.fitness;
  time age;
  survival confband=all plots=(hwb);
run;
ods graphics off;
ods html close;
