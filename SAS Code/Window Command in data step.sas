data paths;
 * Define window with two entry fields, name & phone ;
  window my_win
         rows=25
         columns=100
         color=blue
    #5 'Please enter your name:'
        color=yellow @40 name $30. attr=rev_video
   #10 'Please enter your phone number: '
        color=yellow @40 phone $30. attr=rev_video
   #18 'Press  ENTER to confirm your choices' color=yellow attr=rev_video ;

 * Display window to allow user to input data ;
  display my_win ;

 * If user enters no data then stop data step ;
  if name=' ' & phone=' ' then
    stop ;
run;
