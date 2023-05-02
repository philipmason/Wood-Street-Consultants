proc greplay igout=sasuser.test gout=sasuser.test tc=sashelp.templt template=v2 nofs ;
  treplay 1:pr_graf 2:gprint ;
run ;
quit ;
