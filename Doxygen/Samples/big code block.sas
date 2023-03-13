
/**
  @file 
  @brief Import CSV file (default separator: comma) into a SAS dataset. 
  @details This is a @b longer desciption. I can put bits of code in the text like this <code>&sysuserid</code>. And we can have code blocks (which are indented by 8 spaces) like this.

        option mprint;
        %global firstrow datarow guessingrows out csvfile termstr lrecl labelrow delimiter debug out_dsopts;
        %let csvfile=P:\AN_DVL_BEL-LSP_I0049\Analysis\Mapping\ADaM_Mapping_cdiscpilot01_Master_D. ADaM variables metadata.csv;
        %let termstr = CRLF;
        %let lrecl = 32767;
        %let labelrow = 3;
        %let datarow = 4;
        %let delimiter    = ',';
        %let out=cdiscpilot01_VariablesMetadata;
        %let firstrow=Name;
        %let encoding = any;
        %let guessingrows = 32767;
        %let debug=Y;
        %Read_CSV(csvfile = &csvfile, out = &out, out_dsopts=&out_dsopts, delimiter = &delimiter, firstrow = &firstrow, termstr = &termstr, lrecl = &lrecl 
                ,encoding = &encoding, labelrow = &labelrow, datarow = &datarow, guessingrows = &guessingrows);
        %Read_CSV(csvfile = &csvfile, out  = &out._nolabel, out_dsopts=&out_dsopts, delimiter = &delimiter, firstrow = &firstrow, termstr = &termstr, lrecl = &lrecl 
                ,encoding = &encoding, labelrow = , datarow = &datarow, guessingrows = &guessingrows);
        %Read_CSV(csvfile = &csvfile);
        %Read_CSV(csvfile = &csvfile, datarow=3);
        %Read_CSV(csvfile = &csvfile, datarow=4, out=&out);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, out=csv_name);  
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, out= sasuser.csv_name );
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, out=work.csv_name);  
        %Read_CSV(csvfile = &csvfile, firstrow=NAME,                        out=csv);  
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=1,            out=csv_label1);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=0,            out=csv_label0);
        %Read_CSV(csvfile = &csvfile, firstrow=NONE, labelrow=0,            out=csv_none_label0);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=1, datarow=1, out=csv_label1_data1);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=3,            out=csv_label3);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=1, datarow=4, out=csv_label1_data4);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=3, datarow=3, out=csv_label3_data3);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, labelrow=3, datarow=4, out=csv_label4_data4);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=3);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, out_dsopts=where=(D1 and D2 and D3));
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, out_dsopts=where=(D1 or D2 or D3));
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, clear_formats=);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, clear_formats=_ALL_);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, clear_formats=_NUMERIC_);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, clear_formats=D5-D10);
        %Read_CSV(csvfile = &csvfile, firstrow=NAME, datarow=4, clear_formats=D:);
        %Read_CSV(csvfile = &csvfile, firstrow=NONE);
        %Read_CSV(csvfile = &csvfile, firstrow=NONE, datarow=3);
        %Read_CSV(csvfile = &csvfile, firstrow=NONE, datarow=4);
        %Read_CSV(csvfile = &csvfile, firstrow=NONE, out_dsopts=(where=(VAR1)) );
        %let debug=Y;
        %Read_CSV(csvfile = &csvfile, firstrow=LABEL);
        %symdel debug /nowarn;
        %Read_CSV(csvfile = &csvfile, firstrow=LABEL, char2num = Y);
        %Read_CSV(csvfile = &csvfile, firstrow=LABEL, char2num = N);

  @param[in] csvfile full path and filename <b>(within </b>quotes) of CSV input file.
  @param[in] out
  @param[in] out_dsopts
  @param[in] delimiter
  @param[in] firstrow
  @param[in] termstr
  @param[in] lrecl
  @param[in] encoding
  @param[in] labelrow
  @param[in] datarow
  @param[in] guessingrows
  @param[in] clear_formats
  @param[in] char2num
  @return Dataset specified by OUT= parameter
  @version 9.4
  @author Jean-Michel Bodart
  @date 23OCT2017
  @copyright Argenx 
  @todo Need to improve the comments here
  @bug something doesn't work in here
  @warning be careful about something
  @pre Read SOP before you use this
  @dot['My little diagram']
  digraph example {
      node [shape=record, fontname=Helvetica, fontsize=10];
      b [ label="class B"];
      c [ label="class C"];
      b -> c [ arrowhead="open", style="dashed" ];
  }
  @enddot
**/

%let mcompilenote=%sysfunc(getoption(mcompilenote, keyword));
option mcompilenote=all;

%macro Read_CSV(csvfile       =              /* REQD: CSV file (with full path and extension, not quoted */
               ,out           =              /* REQD: output dataset name (without dataset options).
                                                      a libname should not be specified as it would be considered part 
                                                      of the dataset name*/
               ,out_into      =              /* OPTN: name of macro-variable to be set to the name of the output dataset */
               ,out_dsopts    =              /* OPTN: output dataset options (default: empty) */
               ,delimiter     =  ','         /* OPTN: eg: ',', '09'x and ' ' for comma (default), tab and space */
               ,firstrow      =  LABEL       /* OPTN: Values: LABEL (default) or NAME or NONE */
               ,termstr       =  CRLF        /* OPTN: Values: CRLF (windows-type newlines, for CSV files generated under Windows) 
                                                      LF (Unix-type newlines) or CR (Mac-type newlines) */
               ,lrecl         =  32767       /* OPTN: Max Record length allowed. (default: 32767 - Max: 1,073,741,823 ( 1 gigabyte)) */
               ,encoding      =  any         /* OPTN: Specify encoding if different from the current session encoding, 
                                                      e.g. "utf-8", "latin1", "wlatin1". */
               ,labelrow      =              /* OPTN: row containing labels (if any), when firstrow ^= LABEL. 
                                                      Minimum value: 1 if firstrow = NONE, 2 if firstrow = NAME. 
                                                      If labelrow is not empty, only the variables with non-missing LABEL 
                                                      (or non-missing NAME if firstrow=NAME) are kept. */ 
               ,datarow       =              /* OPTN: first row of data to consider.  Default (and minimum value): 1 if firstrow = NONE,
                                                      2 if firstrow = NAME or LABEL */
               ,guessingrows  =  32767       /* OPTN: Number of rows to examine in order to determine variables type and length (default: 32767) */
               ,clear_formats = _CHAR_       /* OPTN: Clear formats and informats on selected imported variables.  
                                                      Values: _CHAR_ (default), _NUMERIC_, _ALL_, <variable>, <var>i-<var>j, <var>: ... */
               ,char2num      = Y            /* OPTN: If Y (=default), convert imported character variables to numeric when all their values
                                                      are numeric.*/
               );

   %put %str(Not)ice:(&sysmacroname): Processing file: &csvfile..;
   %local workbookname fileext opts firstcol lastcol lastcoln rename csvlabels validn_prx lib lib_exist rc p outdsopts lib dsid nvars conv2num keep char2numrename char2numinput convert;
   %if %symexist(debug)=0 %then %local debug;
   %let opts=%sysfunc(getoption(ls, keyword)) %sysfunc(getoption(quotelenmax));
   options LS=250;
   %if not %symexist(debug) %then %local debug;
   %let workbookname=%qscan(%superq(csvfile), -1, \);
   %let fileext=%qscan(%superq(workbookname), -1, .);
   %let workbookname=%qsysfunc(cats(%qsysfunc(tranwrd(%superq(workbookname), .&fileext, %str()))));
   %*- if &out is empty, replace with workbook name -*;
   %if %length(%superq(out))=0 %then %let out=%superq(workbookname);
   %*- replace characters as needed to ensure &out is a valid SAS name -*;
   %let p=%index(%superq(out), .);
   %let lib=;
   %if &p>1 and &p < %length(%superq(out), .) %then %do;
       %let lib=%qsubstr(&out, 1, %eval(&p-1));
       %let out=%qsubstr(&out, %eval(&p+1));
   %end;
   %let validn_prx=%sysfunc(prxparse(s/^[^A-Za-z_]/_/));
   %let lib=%qsysfunc(prxchange(&validn_prx, -1, %superq(lib)));
   %let out=%qsysfunc(prxchange(&validn_prx, -1, %superq(out)));
   %syscall prxfree(validn_prx);
   %let validn_prx=%sysfunc(prxparse(s/\.[^A-Za-z_]/._/));
   %let lib=%qsysfunc(prxchange(&validn_prx, -1, %superq(lib)));
   %let out=%qsysfunc(prxchange(&validn_prx, -1, %superq(out)));
   %syscall prxfree(validn_prx);
   %let validn_prx=%sysfunc(prxparse(s/[^A-Za-z0-9_]/_/));
   %let lib=%qsysfunc(prxchange(&validn_prx, -1, %superq(lib)));
   %let out=%qsysfunc(prxchange(&validn_prx, -1, %superq(out)));
   %syscall prxfree(validn_prx);
   %if %length(&lib) = 0 %then %let lib=work;
   %let out=&lib..&out.;
   %if %length(%scan(&out, 1, .))>8  %then %let out=%substr(%scan(&out, 1, .), 1, 8).%scan(&out, 2, .);
   %if %length(%scan(&out, 2, .))>32 %then %let out=%scan(&out, 1, .).%substr(%scan(&out, 2, .), 1, 32);
   %let lib_exist=0;
   %let dsid=%sysfunc(open(sashelp.vslib(where=(upcase(libname)="%upcase(%scan(&out, 1, .))"))));
   %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(Deb)ug:(&sysmacroname): Opening sashelp.vslib(where=(upcase(libname)="%upcase(%scan(&out, 1, .))")) --> dsid=&dsid;
   %if &dsid ne 0 %then %do;
       %let lib_exist=%sysfunc(attrn(&dsid, nlobsf));
       %let rc=%sysfunc(close(&dsid));
       %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(Deb)ug:(&sysmacroname): lib_exist=&lib_exist rc=&rc;
   %end;
   %if &lib_exist=0 %then %let out=work.%sysfunc(translate(&out, _, .), $32.);
   %if %length(%superq(out_dsopts)) %then %do;
      %if %qsubstr(%superq(out_dsopts), 1, 1) ^= %qsubstr('(', 2, 1) or %qsubstr(%superq(out_dsopts), %length(%superq(out_dsopts)), 1) ^= %qsubstr(')', 2, 1) %then %do;
         %let out_dsopts=%qsubstr('(', 2, 1)%superq(out_dsopts)%qsubstr(')', 2, 1);
      %end;
   %end;

   %put %str(Not)ice: --------------------------------------------------------;
   %put %str(Not)ice: Importing file: &csvfile;
   %put %str(        )As dataset: &out %superq(out_dsopts);


   *** termstr=crlf in a FILENAME statement avoids lines being split when newline (entered as ALT+Enter in Excel) is found within a quoted string ***;
   filename _csvfile %sysfunc(quote(%superq(csvfile))) 
            termstr = %sysfunc(ifc(%length(%superq(termstr)), &termstr, CRLF))
            lrecl = %sysfunc(ifc(%length(%superq(lrecl)), &lrecl, 32767))
            ignoredoseof;

   %if %qupcase(%superq(firstrow))=LABEL %then %do;
      %let labelrow=1;
   %end;

   %if %length(%superq(labelrow)) %then %do;
      proc import datafile=_csvfile 
                  out=___Read_CSV_columns
                  dbms=dlm
                  replace;
         getnames  = no;
         guessingrows = %sysfunc(ifc(%length(%superq(guessingrows)), &guessingrows, 32767));
         delimiter = %sysfunc(ifc(%length(%superq(delimiter)), &delimiter, ','));
         datarow   = 1;
      run;

      %let nvars=0;
      %if %qupcase(%superq(char2num))=%quote(Y) %then %do;
         %let dsid=%sysfunc(open(___Read_CSV_columns, i));
         %if &dsid ne 0 %then %do;
            %let nvars = %sysfunc(attrn(&dsid, nvars));
            %let rc=%sysfunc(close(&dsid));
         %end;
      %end;
      %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname): nvars=&nvars;

      %let rc=&syserr;
      %if &rc ne 0 and &rc ne 4 %then %do;
          %put %str(ER)ROR:(&sysmacroname): Aborting due to a problem in proc import.;
          %return;
      %end;

      %let conv2num=;
      data ___Read_CSV_labels0;
         set ___Read_CSV_columns end=last;
         %if &nvars > 0 %then %do;
            array __ch $ _char_;
            array __typ (&nvars) _temporary_ (&nvars * 0);
            if _n_ >= %sysfunc(ifc( %length(%superq(datarow)), &datarow, 1+max(%sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, 1 , 0)), &labelrow ) )) then do;
               drop __i;
               do __i=1 to &nvars; 
                  if __typ(__i)=0 and prxmatch('/^-?\d*\.?\d*(E-?\d+)?$/', trimn(__ch(__i))) eq 0 then __typ(__i)=1; 
                  if last and __typ(__i)=0 then call execute('%let conv2num=&conv2num '||cats(vname(__ch(__i)))||';');
               end;
            end;
         %end;
         if _n_=&labelrow then do;
            _name_ = "LABEL";
            output;
         end;
         if _n_=%sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, 1 , 0)) then do;
            _name_ = "NAME";
            output;
         end;
      run;
      %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname):  conv2num = &conv2num;

      proc transpose data=___Read_CSV_labels0 
                     out=___Read_CSV_labels(where=(upcase(_name_) not in ("_NAME_")) %sysfunc(ifc(%qupcase(%superq(debug))=%quote(Y), genmax=10, %str( ))));
         var _all_;
      run;

      %let firstcol=;
      %let lastcol=;
      %let lastcoln=0;
      data ___Read_CSV_labels2(drop=firstcol lastcol lastcoln prx cntrlpos prx
                               index=(_idx0_=(label vnum))  
                               %sysfunc(ifc(%qupcase(%superq(debug))=%quote(Y), genmax=10, %str( ))) );
         set ___Read_CSV_labels end=last;
         length firstcol lastcol vname $40 prx $200;
         retain firstcol lastcol lastcoln;
         array _col $ %sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, name , %str( ))) label;
         vnum=_n_;
         do over _col;
            *- replace line feed and control characters with blanks -*;
            _col=cats(translate(_col, " ", byte(13), " ", byte(10)));
            *- replace embedded control characters with spaces -*;
            drop _loopcounter;
            do _loopcounter=1 to 10; 
               cntrlpos=anycntrl(_col);
               if cntrlpos>0 then substr(_col, cntrlpos, 1)=" ";
            end;
            *- replace sequences of multiple spaces by single spaces -*;
            _col=compbl(_col);
         end;
         *- create variable names -*;
         vname=upcase(compress(%sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, name, scan(label, 1, "()") )) ));
         *- replace characters as needed to ensure vname is a valid SAS name -*;
         do prx = 's/^[^A-Za-z_]/_/', 's/\.[^A-Za-z_]/._/', 's/[^A-Za-z0-9_]/_/';
            validn_prx=prxparse(prx);
            if vname ^= " " then vname=prxchange(validn_prx, -1, trim(vname));
            call prxfree(validn_prx);
         end;
         vname=put(vname, $char32.);
         if firstcol = " " and (label ^= ' ' or vname ^= ' ') then firstcol = cats(_name_);
         if (label ^= ' ' or vname ^= ' ') then do;
            lastcol=_name_;
            lastcoln=_n_;
         end;
         if last then do;
            call symput('firstcol', cats(firstcol));
            call symput('lastcol', cats(lastcol));
            call symput('lastcoln', cats(lastcoln));
         end;
      run;
      %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname): firstcol=&firstcol lastcoln=&lastcoln lastcol=&lastcol;         

      *** Rename and apply label to data imported from spreadsheet ***;
      proc sql noprint;
      *- build keep dataset option for output dataset -*;
         %let keep=;
         select cats(_name_) into :keep separated by " " from ___Read_CSV_labels2 where vname^=" ";
         %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname): (keep=&keep);
      *- build rename dataset option and input statement for converting char2num variables -*;
         %let char2numrename=;
         %let char2numinput=;
         select cats(_name_)||"="||cats(vname) 
              , cats(_name_)||"=input("||cats(vname)||', best32.);'
            into :char2numrename separated by " " 
               , :char2numinput separated by " "
            from ___Read_CSV_labels2 
               where vname^=" " and index (" &conv2num ", " "||cats(_name_)||" ");
         %if %qupcase(%superq(debug))=%quote(Y) %then %do; 
            %put %str(DEB)UG:(&sysmacroname): char2numrename=(&char2numrename);
            %put %str(DEB)UG:(&sysmacroname): char2numinput=%superq(char2numinput);
         %end;
      *- build rename statement for all variables -*;
         %let rename=;
         select cats(_name_)||"="||cats(vname) into :rename separated by " " from ___Read_CSV_labels2 where vname^=" ";
         %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname):  rename=(&rename);
      *- build label statement -*;
         %let csvlabels=;
         select cats(_name_)||"="||quote(cats(label)) into :csvlabels separated by " " from ___Read_CSV_labels2 where label^=" ";
         %if %qupcase(%superq(debug))=%quote(Y) %then %put %str(DEB)UG:(&sysmacroname): csvlabels=&csvlabels;
      quit;


      *- save imported csv dataset -*;
      data &out.(keep=&keep rename=(&rename) label=%sysfunc(quote(Imported from &csvfile)));
         %if %length(%superq(out_into))>0 %then %do;
          if _N_=1 then do;
            %if %symexist(%superq(out_into)) %then %do; 
               call symputx("&out_into", "&out.");
            %end; %else %do;
               call symputx("&out_into", "&out.", "G");
            %end;
          end;
         %end;
         set ___Read_CSV_columns(in=_b %sysfunc(ifc(%length(%superq(firstcol)) and %length(%superq(lastcol)), keep=&firstcol--&lastcol, %str( )))
                                       rename=(&char2numrename));
         if _n_ >= %sysfunc(ifc( %length(%superq(datarow)), &datarow, 1+max(%sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, 1 , 0)), &labelrow ) ));
         %if %qupcase(%superq(char2num))=%quote(Y) %then %do;
            *- convert char to num variables -*;
            &char2numinput;
         %end;
         format &clear_formats;
         informat &clear_formats;
         label &csvlabels;
      run;

      %if %length(%superq(out_dsopts)) %then %do;
         *- apply output dataset options -*;
         data &out. %unquote(&out_dsopts%str( ));
            set &out.;
         run;
      %end;

      %if %qupcase(%superq(debug))^=%quote(Y) %then %do;
         filename _csvfile;
         proc sql noprint;
            drop table ___Read_CSV_columns, ___Read_CSV_labels, ___Read_CSV_labels0, ___Read_CSV_labels2;
         quit;
      %end;

   %end; %else %do;

     %let _syslast=&syslast;
     %let syslast=;

      *- proc import always create its output in WORK -*;
      proc import datafile=_csvfile 
                  out=___Read_CSV_columns
                  dbms=dlm
                  replace;
         delimiter    = %sysfunc(ifc(%length(%superq(delimiter)), &delimiter, ','));
         guessingrows = %sysfunc(ifc(%length(%superq(guessingrows)), &guessingrows, 32767));
         getnames     = %sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, yes, no));
         datarow      = %sysfunc(max(%sysfunc(ifc(%length(%superq(datarow)), &datarow, 1)), %sysfunc(ifc(%qupcase(%superq(firstrow))=NAME, 2, 1))));
      run;

      %let rc=&syserr;
      %if &rc ne 0 and &rc ne 4 %then %do;
          %put %str(ER)ROR:(&sysmacroname): Aborting due to a problem in proc import.;
          %return;
      %end;

      *- So an extra step is needed to save the output in the specified location and apply output dataset options -*;
      %if %length(%superq(out_dsopts))=0 %then %let out_dsopts=(label=%sysfunc(quote(Imported from &csvfile)));
      data &out %unquote(&out_dsopts%str( ));
         %if %length(%superq(out_into))>0 %then %do;
          if _N_=1 then do;
            %if %symexist(%superq(out_into)) %then %do; 
               call symputx("&out_into", "&out.");
            %end; %else %do;
               call symputx("&out_into", "&out.", "G");
            %end;
          end;
         %end;
         set ___Read_CSV_columns;
         format &clear_formats;
         informat &clear_formats;
      run;

      %if %qupcase(%superq(debug))^=%quote(Y) %then %do;
         filename _csvfile;
         proc sql noprint;
            drop table ___Read_CSV_columns;
         quit;
      %end;

   %end;

   options &opts;

%mend Read_CSV;

option &mcompilenote;

