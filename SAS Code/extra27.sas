%macro getstats(dir_cmd) ;
filename cmd pipe "&dir_cmd" ;                                                                                              
data _null_ ;                                                                                                                       
  infile cmd truncover ; 
 * This works on windows XP Professional, but on other version you might need to adjust the settings to
   read the information you want from different positions ; 
  input #6  @1 date ddmmyy10.                                                                                                       
           @13 time time5.                                                                                                          
           @20 size comma17. ;     
 * Now write the data to macro variables to be used ; 
  call symput('_date',put(date,date9.)) ;                                                                                          
  call symput('_time',put(time,time5.)) ;                                                                                          
 * note we use left justification within formatted field , otherwise number is right justified within field ; 
  call symput('_size',put(size,comma9. -l)) ;
run ;                     
%global _date _time _size ; 
%mend getstats ;
%getstats(dir c:\windows\notepad.exe) ;
%put Date=&_date Time=&_time Size=&_size ; 
