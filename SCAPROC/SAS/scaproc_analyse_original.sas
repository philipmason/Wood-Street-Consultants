/******************************************************************************
* Program:         SCAPROC_ANALYSE                                            *
*                                                                             *
* Author:          Philip Mason                                               *
*                                                                             *
* Date Created:    01/08/2016                                                 *
*                                                                             *
* Description:     Analyse output from PROC SCAPROC, which has previously     *
*                  been written to a text file.                               * 
*                  After running this ...                                     *
*                  Now there are some manual steps. These could be automated, *
*                  but would need to install some software or use the Stored  *
*                  Process Web App.                                           *
*                  1 - Copy the lines from the table just created (GRAPHVIZ). *
*                      View the table in EG.                                  *
*                      Click on column, to select all values in it            *
*                      Then control-C.                                        *
*                  2 - Go to http://webgraphviz.com/ .                        *
*                  3 - Paste the lines into the Text Area.                    *
*                  4 - Press "Generate Graph!" button.                        *
*                                                                             *
* Parameters:      scaproc_dir - directory where the proc scaproc output is   *
*                  scaproc_file - file name of the proc scaproc output        *
*                                                                             *
* Data Sources:    %sysfunc(pathname(WORK))/scaproc.txt                       *
*                                                                             *
* Data Output:     WORK.GRAPHVIZ                                              *
*                                                                             *
* Auxiliary Files: n/a                                                        *
*                                                                             *
*-----------------------------------------------------------------------------*
* Modification History                                                        *
* Date        By   Details                                                    *
* 01/08/2016  PM   Original Coding                                            *
******************************************************************************/
 
 
*******************************************************************************
*** You need to have already produced a file to analyse by using the        ***
*** eanbegin and eanend macros put around the code you want to analyse.     ***
*******************************************************************************;
 
%macro scaproc_analyse_v1(scaproc_dir=%sysfunc(pathname(WORK)),scaproc_file=scaproc.txt) ;
    * list the directory to see the file created ;
    data _null_ ;
       infile "&scaproc_dir./&scaproc_file" ;
       input ;
       put _infile_ ;
    run ;
     
    * read in the info and parse into a SAS table ;
    filename scaproc "&scaproc_dir./&scaproc_file" ; 
    data scaproc ;
       length word1-word6 $ 46 ;
       retain step 1 ;
       infile scaproc ;
       input ;
       put _infile_ ;
       if _infile_=:'/* JOBSPLIT: ' ;
       word1=scan(_infile_,2,' ') ;
       word2=scan(_infile_,3,' ') ;
       word3=scan(_infile_,4,' ') ;
       word4=scan(_infile_,5,' ') ;
       word5=scan(_infile_,6,' ') ;
       word6=scan(_infile_,7,' ') ;
       if word2='DATASET' & word3='INPUT'  then in=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
       if word2='DATASET' & word3='OUTPUT' then out=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
       if word2='DATASET' & word3='UPDATE' then out=strip(word4)||'~'||scan(word5,1,'.')||'.'||scan(word5,2,'.') ;
       if word2='PROCNAME'                 then procname=word3 ;
       if word2='ELAPSED'                  then elapsed=input(word3,8.3) ;
       output ;
       if index(_infile_,'STEP SOURCE FOLLOWS') then step+1 ;
    run ;
     
    * merge the data into one record for each step ;
    proc sql noprint ;
    create table flow as
       select coalesce(a.step,b.step,c.step) as step
             ,a.procname
             ,coalesce(scan(b.in,1,'~'),scan(c.in,1,'~')) as in_access
             ,coalesce(scan(b.out,1,'~'),scan(c.out,1,'~')) as out_access
             ,coalesce(scan(b.in,2,'~'),scan(c.in,2,'~')) as in
             ,coalesce(scan(b.out,2,'~'),scan(c.out,2,'~')) as out
             ,d.elapsed
          from 
             scaproc(where=(procname>'')) as a
          full join
             scaproc(where=(in>'')) as b
             on a.step=b.step
          full join 
             scaproc(where=(out>'')) as c
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
    %percentiles(flow, elapsed)
    %put _user_ ;
     
    * Create .DOT directives to make a diagram ;
    data graphviz(keep=line) ;
       length line $ 140
             p $ 32
             color penwidth $ 12 ;
       if _n_=1 then do ;
          line="// Generated by SAS for %superq(scaproc_label)" ;
          output ;
          line="// Percentiles: 50:&pct50 60:&pct60 70:&pct70 80:&pct80 90:&pct90 95:&pct95 99:&pct99" ;
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
       if elapsed>=&pct50 then color='color=red' ;
                          else color='' ;
       if elapsed>=&pct99 then penwidth='penwidth=7' ; else
       if elapsed>=&pct95 then penwidth='penwidth=6' ; else
       if elapsed>=&pct90 then penwidth='penwidth=5' ; else
       if elapsed>=&pct80 then penwidth='penwidth=4' ; else
       if elapsed>=&pct70 then penwidth='penwidth=3' ; else
       if elapsed>=&pct60 then penwidth='penwidth=2' ;
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
    %mend scaproc_analyse_v1 ;
    