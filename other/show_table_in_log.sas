%macro show_table_in_log(table) ;
     %let dsid=%sysfunc(open(&table)) ;
     %let nvars=%sysfunc(attrn(&dsid,nvars)) ;
     proc sql noprint ;
           select
     %do i=1 %to &nvars ;
           %let varname=%sysfunc(varname(&dsid,&i)) ;
           %let vartype=%sysfunc(vartype(&dsid,&i)) ;
           %let varformat=%sysfunc(varformat(&dsid,&i)) ;
           %if &varformat= %then %let varformat=best32. ;
           %if &vartype=C %then max(max(length(&varname),%length(&varname)))+1 as max_&varname ;
                          %else max(max(length(strip(put(&varname,&varformat))),%length(&varname)))+1 as max_&varname ;
           %if &i<&nvars %then , ;
     %end ;
           into
     %do i=1 %to &nvars ;
           %let varname=%sysfunc(varname(&dsid,&i)) ;
           :max_&varname
           %if &i<&nvars %then , ;
     %end ;
           from &table;
     quit ;
 
     data _null_ ;
           set &table end=_end ;
           if _n_=1 then do ;
           put / %eval(18+%length(&table))*'='
                / @2 "Start of Table: &table"
                / %eval(18+%length(&table))*'=';
           put
           %let pos=1 ;
           %do i=1 %to &nvars ;
                %let varname=%sysfunc(varname(&dsid,&i)) ;
                %let max_varname=max_&varname ;
                @&pos "&varname"
                %let pos=%eval(&pos+&&&max_varname) ;
           %end ;
           ;
           put
           %let pos=1 ;
           %do i=1 %to &nvars ;
                %let varname=%sysfunc(varname(&dsid,&i)) ;
                %let max_varname=max_&varname ;
                @&pos %eval(&&&max_varname-1)*'-'
                %let pos=%eval(&pos+&&&max_varname) ;
           %end ;
           ;
           end ;
           put
           %let pos=1 ;
           %do i=1 %to &nvars ;
                %let varname=%sysfunc(varname(&dsid,&i)) ;
                %let max_varname=max_&varname ;
                @&pos &varname
                %let pos=%eval(&pos+&&&max_varname) ;
           %end ;
           ;
           if _end then put %eval(16+%length(&table))*'='
                                / @2 "End of Table: &table"
                                / %eval(16+%length(&table))*'=' ;
     run ;
     %let dsid=%sysfunc(close(&dsid)) ;
%mend show_table_in_log ;
/*%show_table_in_log(sashelp.class)*/
/*%show_table_in_log(sashelp.prdsale)*/
 
