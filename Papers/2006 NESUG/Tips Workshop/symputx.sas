*** PUTTING NUMBERS IN MACRO VARIABLES A BETTER WAY ;
   data test ;
     my_val=12345 ;
     call symput('value0',my_val) ; * auto conversion done ;
     call symput('value1',trim(left(put(my_val,8.)))) ; * v8 ;
     call symputx('value2',my_val) ; * SAS 9 ;
   run ;

   %put =->&value0<-==->&value1<-==->&value2<-=;

