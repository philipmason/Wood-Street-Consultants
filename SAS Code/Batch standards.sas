* App:       MRMA (Test), Test.sas
* Date:      24Feb1998
* Name:      Philip Mason
* Purpose:   Demonstrates the use of coding standards.
* Parms In:  -
* Parms Out: -
* Called:    -
* Input:     sasuser.houses
* Output:    sasuser.test
* Problems:  If program abends with a return code of 1, then you may need to edit the input dataset
             and remove invalid values. ;
*;
* Changes:


* Delete the old dataset ;
proc datasets lib=sasuser
              nolist ;
  delete test
         name_is_too_long ;
run ;
quit ;


* This is needed since syserr is reset when we enter a data step ;
%let _lasterr=&syserr ;


* Check return code from procedure and stop SAS if there was an error ;
data _null_ ;
  _syserr=symget('_lasterr') ;
  if _syserr>0 then
    do ;
      _now=datetime() ;
      put 'ERROR: test.sas, ' _now datetime. ', E1, Initialisation.' ;
      put 'ERROR: We received a non-zero return code (' _syserr ') when trying to delete sasuser.test.' ;
      put 'ERROR: This is most likely because the dataset name is invalid.' ;
      put 'ERROR: SAS will now cease processing.' ;
 * Following line commented out so that this sample program will not abend ;
***   abort abend 1  ;
    end ;
run ;


* Modify the values in houses ;
data sasuser.test(drop=_:
                  label="Modified houses dataset")
     &debug ;
  attrib price label='Randomised price of a house'
               format=dollar12. ;

 * Define array holding all numeric values ;
  array nums(*) _numeric_ ;

  set sasuser.houses nobs=nobs ;

 * Check that sasuser.houses is roughly the expected size ;
  if _n_=1 then
    do ;
      put 'NOTE: sasuser.houses has ' nobs ' observations.' ;
      if nobs>50 then
        put 'WARNING: sasuser.houses has more observations than expected.' ;
      else
        if nobs<10 then
          put 'WARNING: sasuser.houses has less observations than expected.' ;
        else ;
    end ;

  link validate ;

  link calc ;

  return ;

validate:
  if sqfeet<1200 then
    do ;
      put 'WARNING: This house is far too small!' ;
      put 'WARNING: Record will not be written to the dataset.' ;
      delete ;
    end ;
  else ;
  return ;

calc:
  _feet=sqfeet+date() ;
  price=price*ranuni(1)+_feet ;

 * If its the first observation then do a random process ;
  if _n_=1 then
    do ;
      do _i=1 to 20 ;
        if _i/20<ranuni(_i) then
          put _i= 'note: Thats interesting!' ;
        else ;
      end ; * do _i=1 to 20 ;
    end ; * if _n_=1 ;

 * Modify some of the styles based on their values ;
  else
    select(style) ;
      when('RANCH')
        do ;
          put style= ;
          style='YANK' ;
        end ;
      when('CONDO')
        style='TALL' ;
      otherwise
        put style= ;
    end ; * Select ;
  return ;
run ;


* Specify sortsize parameter to help with performance ;
proc sort data=sasuser.test
          noequals
          noduplicates
          sortsize=max ;
  by style price ;
run ;

title 'Report on SASUSER.TEST' ;
Proc report data=sasuser.test
            nofs ;
run ;


proc sql ;
 * Gather performance stats for each statement ;
  reset stimer ;
  title 'Prices for small houses, under 1500 square feet' ;
  select style, price
    from sasuser.test
      where sqfeet<1500 ;
 * Add the prices up for each street ;
  create table all as
    select sum(price) as sum label='Total Price'
                             format=dollar12.,
           n(price) as count label='Number of houses',
           street
      from sasuser.test
        group by street
        order by sum desc ;
  title 'Price for buying all houses in a street' ;
  select *
    from all ;
quit ;


*** End of MRMA (Test), Test.sas ***;
*** End of MRMA (Test), Test.sas ***;
*** End of MRMA (Test), Test.sas ***;
