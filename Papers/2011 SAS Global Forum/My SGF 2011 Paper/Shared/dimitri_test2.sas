*ProcessBody;

/* stream data to browser in JSON format */
data _null_;
   file _webout;
   set sashelp.class end=last;
   if _n_ =1 then
      put "{ success:true, rows:["; /* return data retrieved was a succes, rows is an array containing all the data */
   else
      put ","; /* seperator for each row in the data */
   put "{ name: '" name+(-1) "', sex: '" sex+(-1) "', age: '" age+(-1) "'}";
   if last then
     put "]}"; /* close array and JSON dataset */
run;
*';*";*/;run;
