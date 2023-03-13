/**
@file 

@brief Show some parameters

@details this is a demo to show how to document some parameters

@author Jean-Michel Bodart
@date 23OCT2017

@param[in] p1 parameter 1
@param[in] p2 parameter 2
@param[out] output a global parameter I use for output from the macro
@param[in,out] lasttime this parameter is used as input and output to show last time something happened

@return Some text is produced by the macro

@xrefitem special "Special" "Special List" Eat my lunch
**/

%macro a(p1,p2,out=myoutput)
  %global output ;
  %put lattime=&lasttime;
  %let lasttime=%sysfunc(time());
  some text produced by macro
%mend a;
