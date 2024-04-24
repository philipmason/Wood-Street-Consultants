/**
@file
@author     Philip Mason & Jean-Michel Bodart

@brief      Analyse output from PROC SCAPROC, which has previously been written to a text file.

@details    Analyse output from PROC SCAPROC, which has previously been written to a text file.
            After running this ...                                    
            Now there are some manual steps. These could be automated,
            but would need to install some software or use the Stored 
            Process Web App.                                          
            1 - Copy the lines from the table just created (GRAPHVIZ).
                View the table in EG.                                 
                Click on column, to select all values in it           
                Then control-C.                                       
            2 - Go to http://webgraphviz.com/ .                       
            3 - Paste the lines into the Text Area.                   
            4 - Press "Generate Graph!" button.                       
            @b Data @b Sources:    %sysfunc(pathname(WORK))/scaproc.txt
            @b Data @b Output:     WORK.GRAPHVIZ

@pre        You need to have already produced a file to analyse by using the 
            eanbegin and eanend macros put around the code you want to analyse.


@param[in]  scaproc_dir=%sysfunc(pathname(WORK))  - directory where the proc scaproc output is
@param[in]  scaproc_file=scaproc.txt              - file name of the proc scaproc output
@param[in]  scaproc_label=                        - (default) Analysis of PROC SCAPROC record of Program Execution
@param[in]  out_dot_file=
@param[in]  pctlpts=10                            - Examples 50, 60, 70, 80, 90, 95 or 99
@param[in]  verbose=N

**/
 
%macro scaproc_analyse(scaproc_dir=%sysfunc(pathname(WORK))
                      ,scaproc_file=scaproc.txt
                      ,scaproc_label=Analysis of PROC SCAPROC record of Program Execution
                      ,out_dot_file=
                      ,pctlpts=10 50 /*60 70 80*/ 90 /*95 99*/
                      ,verbose=N
                      );
/* *- example -*;
%let scaproc_dir=%sysfunc(pathname(WORK));
%let scaproc_file=scaprocrecord.txt;
%let scaproc_label=Analysis of PROC SCAPROC record of Program Execution;
%let pctlpts=10 50 90;
%let out_dot_file=%sysfunc(pathname(WORK))/scaprocrecord.dot;
%let verbose=N;
*/

%if %length(%superq(out_dot_file))=0 %then %let out_dot_file = &scaproc_dir/&scaproc_file..dot;

filename scapfile "&scaproc_dir./&scaproc_file";
data scaproc_lines;
   infile scapfile length=linelen truncover end=last;
   length line $1000;
   input @;
   input line $varying1000. linelen;
   linenum+1;
   if _n_=1 or index(line,'STEP SOURCE FOLLOWS') then step+1 ;
run ;

data concatmem;
   set scaproc_lines;
   where index(line, "/* JOBSPLIT: CONCATMEM ")=1;
   linenum = max(1, linenum -2);
   concatmem = put(scan(line, 4, " "), $20.);
   libname = put(scan(line, 5, " "), $20.);
run ;

data scaproc_lines2;
   merge
      scaproc_lines(in=a)
      concatmem(in=b keep=linenum concatmem libname rename=(concatmem=_concatmem libname=_libname))
      ;
   by linenum;
   if a;
   if b then do;
      concatmem=_concatmem;
      libname=_libname;
   end;
   retain concatmem libname;
   drop _concatmem _libname;
run;
 
* read in the info and parse into a SAS table ;
%local max_step;
%let max_step = -1;
data scaproc ;
   length word1-word6 $ 46 ;
   *retain step 1 ;
   set scaproc_lines2 end=last;
   %if %qsysfunc(upcase(%superq(verbose)), $1.)=Y %then %do;
   put line ;
   %end;
   if line=:'/* JOBSPLIT: ' ;
   word1=scan(line,2,' ') ;
   word2=scan(line,3,' ') ;
   word3=scan(line,4,' ') ;
   word4=scan(line,5,' ') ;
   word5=scan(line,6,' ') ;
   word6=scan(line,7,' ') ;
   if CONCATMEM ^= " " and index(line, strip(CONCATMEM)) then do;
      concatmemfl="Y";
      word5=tranwrd(word5, strip(concatmem), strip(libname));
   end;
   if word2='DATASET' & word3='INPUT'  then in=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
   if word2='DATASET' & word3='OUTPUT' then out=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
   if word2='DATASET' & word3='UPDATE' then out=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
   if word2='PROCNAME'                 then procname=word3 ;
   if word2='ELAPSED'                  then elapsed=input(word3,8.3) ;
   output ;
   *if index(line,'STEP SOURCE FOLLOWS') then step+1 ;
   if last then call symput('max_step', cats(step));
run ;
%put =&max_step;
%put Z%sysfunc(ceil(%sysfunc(log10(&max_step)))).;
 
* merge the data into one record for each step ;
proc sql noprint ;
create table dist_proc as
   select distinct step, procname
      from scaproc
      group by step
      having procname ^= ' ' or (count(procname)=0 and step ne &max_step)
      ;
create table flow as
   select distinct coalesce(a.step,b.step,c.step) as step
         ,"_"||put(coalesce(a.step,b.step,c.step), Z%sysfunc(ceil(%sysfunc(log10(&max_step)))).)||"_"||strip(a.procname) as procname
         ,coalesce(scan(b.in,1,'~'),scan(c.in,1,'~')) as in_access
         ,coalesce(scan(b.out,1,'~'),scan(c.out,1,'~')) as out_access
         ,coalesce(scan(b.in,2,'~'),scan(c.in,2,'~')) as in
         ,coalesce(scan(b.out,2,'~'),scan(c.out,2,'~')) as out
         ,d.elapsed
      from 
         scaproc(where=(procname ^= '')) as a
      full join
         scaproc(where=(in ^= '')) as b
         on a.step=b.step
      full join 
         scaproc(where=(out ^= '')) as c
         on a.step=c.step 
      left join
         scaproc(where=(elapsed>0)) as d
         on a.step=d.step 
      order by calculated step
      ;
   create table procnames as
      select distinct procname
      from flow
      where procname is not missing and (missing(in) or missing(out)) ;
quit ;
 
%* create percentiles for use in making diagram ;
%local i n_pctlpts mid_pnt pctls_desc pctl csep_pctlpts;
%let n_pctlpts = %sysfunc(countw(%superq(pctlpts)));
%let mid_pnt = %sysfunc(ceil(&n_pctlpts/2));
%let csep_pctlpts = %varlist(var=%superq(pctlpts), sep=#cs#);

%do i=1 %to &n_pctlpts;
   %let pctl = %scan(%superq(pctlpts), &i);
   %local pct&pctl;
   %let pct&pctl = .;
%end;


%percentiles(flow, elapsed, pctlpts=&pctlpts);
 
%do i=1 %to &n_pctlpts;
   %let pctl = %scan(%superq(pctlpts), &i);
   %let pctls_desc = &pctls_desc &pctl:&&pct&pctl;
%end;
%put pctls_desc=;

* Create .DOT directives to make a diagram ;
data graphviz(keep=line) ;
   length line $ 200
         p $ 32
         color $20 penwidth $ 12 ;
   if _n_=1 then do ;
      line="// Generated by SAS for %superq(scaproc_label)" ;
      output ;
      *line="// Percentiles: 50:&pct50 60:&pct60 70:&pct70 80:&pct80 90:&pct90 95:&pct95 99:&pct99" ;
      line="// Percentiles: &pctls_desc" ;
      output ;
      line='digraph test {' ;
      output ;
/*      line='rankdir=LR' ;*/
/*      output ;*/
      line="graph [label=""\n\n%superq(scaproc_label)\n%sysfunc(datetime(),datetime.)""]" ;
      output ;
      line='node [shape=box color=lightblue style=filled]' ;
      output ;
      dsid=open('procnames') ;
      do while(fetch(dsid)=0) ;
         p=getvarc(dsid,1) ;
         line=quote(strip(p))||'[shape=ellipse color=lightgreen]' ;
         output ;
      end ;
      dsid=close(dsid) ;
      end ;
   set flow end=end ;
   in=quote(strip(in)) ;
   out=quote(strip(out)) ;
   procname=quote(strip(procname)) ;
   /*
   if elapsed>=&pct50 then color='color=red' ;
                      else color='' ;
   if elapsed>=&pct99 then penwidth='penwidth=7' ; else
   if elapsed>=&pct95 then penwidth='penwidth=6' ; else
   if elapsed>=&pct90 then penwidth='penwidth=5' ; else
   if elapsed>=&pct80 then penwidth='penwidth=4' ; else
   if elapsed>=&pct70 then penwidth='penwidth=3' ; else
   if elapsed>=&pct60 then penwidth='penwidth=2' ;
   */
   if elapsed>=%unquote(%nrstr(&pct)%sysfunc(max(&csep_pctlpts))) 
      then color='color=red' ;
      else if elapsed>=%unquote(%nrstr(&pct)%scan(%superq(pctlpts), &mid_pnt)) 
         then color='color=orange' ;
      else if elapsed<%unquote(%nrstr(&pct)%sysfunc(min(&csep_pctlpts))) 
         then color='color=grey' ;
         else color='color=lightgreen' ;
   if 0 then penwidth=" ";
   %do i=&n_pctlpts %to 1 %by -1;
       else if elapsed >= %unquote(%nrstr(&pct)%scan(%superq(pctlpts), &i)) then penwidth="penwidth=&i" ;
   %end;
   else penwidth='' ;
   if in_access='MULTI' or out_access='MULTI' then style='style=dashed' ;
                                              else style='style=solid ' ;
   if compress(in,'"')>'' & compress(out,'"')>'' then
                               line=strip(in)||'->'||strip(out)||
                               ' [label=" '||lowcase(strip(dequote(procname)))||
                               ' ('||strip(put(elapsed,8.3))||
                               ')" '||strip(color)||' '||strip(penwidth)||' '||strip(style)||'];' ;
   else if compress(in,'"')>'' & compress(out,'"')='' then
                               line=strip(in)||'->'||strip(procname)||
                               ' [label="('||strip(put(elapsed,8.3))||
                               ')" '||strip(color)||' '||strip(penwidth)||' '||strip(style)||'];' ;
   else if compress(in,'"')='' & compress(out,'"')>'' then
                               line=strip(procname)||'->'||strip(out)||
                               ' [label="('||strip(put(elapsed,8.3))||
                               ')" '||strip(color)||' '||strip(penwidth)||' '||strip(style)||'];' ;
   else line='// '||strip(procname)||' ('||strip(put(elapsed,8.3))||')' ;
   output ;
   if end then do ;
      line='}' ;
      output ;
      end ;
run ;  

%if %length(%superq(out_dot_file)) %then %do;
    data _null_;
        file "&out_dot_file";
        set graphviz;
        put line;
    run ;
    %if %sysfunc(getoption(XCMD))=XCMD %then %do;
       %local dot_exe out_dot_pdf cmd;
       %if &sysscp = WIN %then %do;
          filename wh_dot pipe "where dot";
       %end; %else %if &sysscp = LIN %then %do;
          filename wh_dot pipe "which dot";
       %end;
       %if %sysfunc(fileref(wh_dot))=0 /*- Fileref is assigned to an existing file -*/ %then %do;
          data _null_;
             infile wh_dot;
             input;
             put _n_= ": " _infile_;
             if _n_=1 then call symput('dot_exe', strip(_infile_));
          run;
          filename wh_dot;
          %put &=dot_exe;
       %end;
       %if %length(%superq(dot_exe)) and %sysfunc(fileexist(%superq(dot_exe))) %then %do;
          %let out_dot_pdf = %sysfunc(prxchange(s/\.\w{1%bquote(,)6}$//, 1, %qsysfunc(trim(%superq(out_dot_file))))).pdf;
          %let cmd =  dot "&out_dot_file" -Tpdf -o "&out_dot_pdf";
          filename cmd pipe %sysfunc(quote(%superq(cmd)));
          data _null_;
             infile cmd;
             input;
             put _infile_;
          run;
          filename cmd;
          %if %sysfunc(getoption(DMS))=DMS and &sysscp = WIN and %sysfunc(fileexist(%superq(out_dot_pdf))) %then %do;
             x start "opening graphviz-generated pdf..."  "&out_dot_pdf" & exit ;
          %end;
       %end;
    %end;

%end;
%mend scaproc_analyse ;
