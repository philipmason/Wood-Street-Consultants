data _null_;
  file print ll=linleft line=lin page=pagno ps=50 ls=80;
  do x=1 to 100;
    put 'Page ' pagno 'line number ' lin '- There are ' linleft 'lines left on this page';
  end;
run;
