filename mymacros '.';
options append=sasautos=(mymacros);

%* set macro variable to turn on SCAPROC and set verbose logging ;
%let _eandebug=scaproc,verbose;
 
%* Start recording SCAPROC data ;
%eanbegin(Sample 1)
 
**************************************************************************;
*** This is the sample program we will measure and then make a flow chart ;
**************************************************************************;
data x ;
   set sashelp.class ;
run ;
 
data y ;
   set sashelp.class ;
run ;
 
proc summary data=x ;
   class sex ;
   var height ;
   output out=x2 mean= ;
run ;
 
proc summary data=y ;
   class sex ;
   var height ;
   output out=y2 mean= ;
run ;
 
proc sort data=x2 out=x3 ;
   by sex ;
run ;
 
proc sort data=y2 out=y3 ;
   by sex ;
run ;
 
data z ;
   merge x3 y3 ;
      by sex ;
run ;
 
proc print ;
run ;
 
proc sql ;
   create table sql_table as
   select *
   from x
   left join
   y
   on x.sex=y.sex ;
quit ;
 
 
*****************************;
*** finish of sample program ;
*****************************;
 
%* Finish recording SCAPROC data and write it out ;
%eanend
 
 
%* Generate the graphViz dot language to be used to make diagram ;
%scaproc_analyse
