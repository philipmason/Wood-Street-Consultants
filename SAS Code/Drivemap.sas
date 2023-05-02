filename d drivemap ;
data ;
  infile d ;
  input drive $2. ;
  put drive= ;
run ;
