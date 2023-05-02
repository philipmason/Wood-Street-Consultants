TITLE h=2 'My title' m=(+0,+1) h=1 '2 ' h=2 m=(+0,-1) 'squared';
proc gplot data=sasuser.class;
  plot height*weight;
run;
quit;
