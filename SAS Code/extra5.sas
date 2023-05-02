ods listing close;
ods html path="c:\temp\"
         body="html\body.xls"
         contents="contents.html"
         newfile=page;
proc sort data=sashelp.prdsale ;
  by product ;
run ;
proc tabulate data=sashelp.prdsale ;
  by product ;
  class country region ;
  var actual predict ;
  table country all,
        region all,
		(actual predict)*sum ;
run ;
ods html close ;
dm "wbrowse 'c:\temp\contents.html'" wbrowse ;
