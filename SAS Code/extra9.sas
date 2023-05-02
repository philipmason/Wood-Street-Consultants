*** Part 1 ***;
filename cmd pipe 'ipconfig' ;
data _null_ ;
  infile cmd dlm='.: ' ;
  input @'IP Address' n1 n2 n3 n4 3. ;
  IP_Address=compress(put(n1,3.)||'.' ||put(n2,3.)||'.'
                    ||put(n3,3.)||'.' ||put(n4,3.));
  call symput('ip',ip_address) ;
run ;
%put My IP address is &ip ;
*** Part 2 ***;
%let london=&ip;
/*%let london=homepc; * can alternatively use the PC name;*/
signon london ;
rsubmit london ;
  proc setinit ; run ;
endrsubmit ;

