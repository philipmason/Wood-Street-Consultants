%let a=/;  * comments active ;
%let b=*;  * comments active ;
*** to deactivate set A & B to blanks ***;
&a&b
proc print data=x ;
run ;
*/;
data _null_ ;
run ;
