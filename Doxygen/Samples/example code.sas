/**
@file
@brief this is a brief description.
@cond
*/
%macro nobs(dsid) ; %sysfunc(attrn(&dsid,nobs)) %mend nobs ;
/**
@endcond
@file
#### Examples ####
@code
    %put This dataset has %nobs(1) observations ;
@endcode
*/