*** First example ;
filename out 'c:\sas\out.txt' ;
data _null_ ;
  infile 'c:\sas\in.txt'
         sharebuffers ;     /* Define input file which has very long records */
  input ;                   /* Read a record into the input buffer */
  file out                  /* Point to where you want to write output */
       lrecl=1024 ;         /* Default LRECL is 256, so we need to override it */
  put @33  'ABC'            /* write changes */
      @400 '12345'          /* write another change */
      @999 'Wow' ;          /* write the last change */
run ;

*** Another example ;
data _null_ ;
  infile 'c:\sas\in.txt' ;  /* Define input file */
  input ;                   /* Read a record into the input buffer */
  file out                  /* Point to where you want to write output */
       lrecl=1024 ;         /* Default LRECL is 256, so we need to override it */

 * Appends 2 fields to the end of a CSV file ;
  put _infile_ ',this,that' ;

  first='Some text' ;
  second='Phil Mason' ;
 * Puts 2 fields at the start of a CSV file ;
  put first ',' second ',' _infile_ ;
run ;
