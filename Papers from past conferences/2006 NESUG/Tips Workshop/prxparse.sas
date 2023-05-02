*** USING PERL REGULAR EXPRESSIONS FOR SEARCHING TEXT ;
data _null_;
  if _N_=1 then 
    do;
      retain patternID;
      pattern = "/ave|avenue|dr|drive|rd|road/i";
      patternID = prxparse(pattern);
    end;
  input street $80.;
  call prxsubstr(patternID, street, position, length);
  if position ^= 0 then
    do;
      match = substr(street, position, length);
      put match : $QUOTE. "found in " street : $QUOTE.;
    end;
  datalines;
153 First Street
6789 64th Ave
4 Moritz Road
7493 Wilkes Place
;
run ;
