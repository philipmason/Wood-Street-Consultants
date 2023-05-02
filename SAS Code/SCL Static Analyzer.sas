proc build batch;
    crossref project=mis.gnrl;
run;
dm 'sclprof static lib=work' sclprof ;
