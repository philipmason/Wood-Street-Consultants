/* GENERATING GRAPHS AUTOMATICALLY FOR SOME PROCEDURES */

ods listing close ;
ods html file='c:\workshop\hw06\lifetest.html' gpath='c:\workshop\hw06\' style=mystyle;
ods graphics on;

proc lifetest data=sashelp.air ;
  time air;
  survival confband=all plots=(hwb);
run;

ods graphics off;
ods html close;
