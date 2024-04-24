options nomprint nosymbolgen nomlogic nomautolocdisplay;
%let _eandebug=scaproc;
%eanbegin(example2,scaproc_file=example2.txt)

data x ; set sashelp.class ; run ;
data y ; set sashelp.class ; run ;
proc summary data=x ; class sex ; var height ;
   output out=x2 sum= ; run ;
proc summary data=y ; class sex ; var weight ;
   output out=y2 sum= ; run ;
proc sort data=x2 out=x3 ; by sex ; run ;
proc sort data=y2 out=y3 ; by sex ; run ;
data z ; merge x3 y3 ; by sex ; run ;
proc print ; run ;
proc sql ; create table sql_table as select * from x left join y on x.sex=y.sex ; quit ;
%eanend;
%scaproc_analyse(scaproc_file=example2.txt)
