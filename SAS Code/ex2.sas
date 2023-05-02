* create EXCEL spreadsheet ;
proc export data=sashelp.class
  outfile="c:\sas\class.xls"
  dbms=excel;
quit;
* call VB script to make the pivot table ;
data _null_;
  x 'c:\sas\pivot.vbs';
run;
