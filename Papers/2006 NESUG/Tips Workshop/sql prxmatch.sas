*** USE REGULAR EXPRESSIONS IN SQL ;
data test ;
  length period $ 7 ;
  input period ;
cards ;
2005
2005Q1
2005JAN
;;
run ;

proc sql;
  create table qtrs as 
    select *
      from test
        where prxmatch("/\d\d\d\d[qQ][1-4]/",period) ;
quit;

proc print data=qtrs ;
run ;
