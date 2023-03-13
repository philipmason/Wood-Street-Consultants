/**
  @file
  @brief this is a SAS graph plot
@pre pre-condition
@post post-condition
@param filename
@parblock
This allows 

multiple lines for a parameter
@endparblock
**/
proc gplot data=sashelp.class;
    plot weight*height;
run;