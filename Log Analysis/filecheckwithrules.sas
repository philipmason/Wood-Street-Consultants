/**
@file
@brief      Check a log for specific messages
@details    Read in a set of rules for detecting various patterns of text in a text file.
            We have defined a set of rules in JSON format for finding errors, warnings and other things in a SAS log,
            although you could specify a different JSON file to look for something else.
           
@param[in]  log              location of text file (log) that will be analysed.
                             If you specify *pcsas* then it will grab the log if running on PC SAS (see examples).
@param[in]  rules            location of JSON file containing rule definitions, defined in regular expressions or starting with prefixes
@param[in]  returntypes      list of pipe separated quoted types to return, e.g. ERROR|WARN
@param[in]  print            0 = no report, 1 = produce a report

@returns    filecheckwithrules   dataset containing the results of applying the rules to the text file

Rules are defined in JSON. They can also be used in the Log Viewer web application, so there are some things that are not used
if just using from SAS directly. You can create your own rules and use them.
Each rule has the following items:

    Key           Description 
    -----------   --------------------------------
    ruleType      Either "startswith" which will check if a line starts with some text,
                  or "regex" which will apply a regular expression to the line to find any matches.
    startswith    Text used with a startswith rule.
    prefix        HTML tag that will be prepended to a line in the log viewer application. Not used if running this macro.
    suffix        HTML tag that will be appended to a line in the log viewer application. Not used if running this macro.
    anchor:       true or false, defining if a link will appear to this line in an overview. Not used if running this macro.
    linkColor     Color to apply to background in the type column of printed output, when you use print=1
    type          User defined type so that rules can be categorised and then selected using the returntypes parameter
    interesting   true or false, defines if a line is viewed as interesting or not. 
                  This can then be used with a where clause just select the interesting lines for a shorter view of output.

Here is an example of part of the JSON.
@code
     {
        "ruleType": "startswith",
        "startswith": "NOTE:",
        "prefix": "<span style='color: blue'>",
        "suffix": "</span>",
        "anchor": false,
        "linkColor": "blue",
        "type": "NOTE",
        "interesting": false
      },
      {
        "ruleType": "regex",
        "regex": "(?:^WARNING:)(?!.*MPRINT|.*MLOGIC|.*SYMBOLGEN)",
        "prefix": "<span style='color: green'>",
        "suffix": "</span>",
        "anchor": true,
        "linkColor": "green",
        "type": "WARN",
        "interesting": true
      },
@endcode

#### Update History ####

    Date         Author               Description 
    -----------  -------------------  --------------------------------
    15 Feb 2023  Phil Mason (pmason)  Original version of code created 
    16 Feb 2023  Phil Mason (pmason)  Support analyzing log in PC SAS, added interesting variable from rules.
    
@cond
*/

%macro filecheckwithrules(log,
                          rules=&_sasws_./general/biostat/tools/logviewer/rules.json,
                          returntypes=ERROR|WARN|SERIOUS,
                          outputname=filecheckwithrules,
                          print=0) ;
    %* if we want to use the log from pc sas, then specifying log=pcsas will mean we write the pc sas log
       to a temporary file and then analyse that ; 
    %if %superq(log)=pcsas %then %do ;
      dm 'log; file "___filecheckwithrulestemp.log" replace';
      %let log=___filecheckwithrulestemp.log;
      %end ; 
    libname rules json "&rules" ;
    data ___prep ;
        set rules.alldata;
        rule=int((_n_-1)/8)+1;
    run;
    proc transpose data=___prep out=___rules ;
        by rule ;
        id p1 ;
        var value;
    run ;
    %global &outputname;
   data &outputname(keep=linenumber line type linkcolor interesting
                       label="&log") ;  /* put name of log analysed into the dataset label */
      length linenumber 8 linkcolor type $ 10 line $ 200 interesting $ 1;
      infile "&log";
      input ;
      line=_infile_;
      linenumber=_n_;
      %* go through each rule and apply it to each line ;
      %let dsid=%sysfunc(open(___rules));
      %let nobs=%sysfunc(attrn(&dsid,nobs));
      %do i=1 %to &nobs ;
          %let rc=%sysfunc(fetch(&dsid));
          %let ruletype=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,ruletype))));
          %let startswith=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,startswith))));
          %let type=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,type))));
          %let regex=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,regex))));
          %let linkcolor=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,linkcolor))));
          %let interesting=%sysfunc(getvarc(&dsid,%sysfunc(varnum(&dsid,interesting))));
          %if &interesting=true %then %let interesting_value=Y;
          %else %if &interesting=false %then %let interesting_value=N;
          %else %let interesting_value=;
/*          %put &=ruletype &=startswith &=type &=regex &=linkcolor &=interesting &=interesting_value ; */
          %if &ruletype=startswith %then %do ;
            if line=:"&startswith" then type="&type";
            %end ;
          %if &ruletype=regex %then %do ;
            re=prxparse("/&regex/i");
            if prxmatch(re,line) then do ;
               type="&type";
               %if %length(-&linkcolor)=1 %then %let linkcolor=white ;
               linkcolor="&linkcolor";
               interesting="&interesting_value";
               end ;
            %end ;
      %end ;
      %let dsid=%sysfunc(close(&dsid));
     %let returnTypeList=;
      %let numberOfTypes=%sysfunc(count(&returntypes,|));
      %do _q=1 %to &numberOfTypes+1;
      %if &_q>1 %then %let returnTypeList=&returnTypeList,;
        %let returnTypeList=&returnTypeList "%scan(&returnTypes,&_q,|)";
      %end ;
      * return the selected types that were detected ;
      if type in (&returnTypeList);
   run;
   %let dsid=%sysfunc(open(&outputname));
   %let &outputname=%sysfunc(attrn(&dsid,nobs));
   %let dsid=%sysfunc(close(&dsid));
   %if &print %then %do ;
      %if &&&outputname=0 %then %do ;
         data &outputname ;
             length linenumber 8 linkcolor type $ 10 line $ 200 interesting $ 1;
             type="CLEAN";
             linenumber=0;
             linkcolor="lightgreen";
             line="No lines matched any rules" ;
             output ;
             line="Log analyzed: &log";
             output ;
             line="Rules used: &rules";
             output ;
         run ;
      %end ;
      title "&&&outputname lines found in &log";      
      ods html file="&outputname..html";
         proc report data=&outputname split='!' headline;
          column linenumber type line interesting linkcolor ;
          define linenumber  / width = 10 "Line!Number" flow style(column)=[cellwidth=0.5in];
          define type        / width = 10 "Type"        flow style(column)=[cellwidth=0.5in];
          define line        / width=100  "Line"        flow style(column)=[font_size=8pt];
          define interesting / width = 2  "Interesting" flow style(column)=[cellwidth=0.2in];
          define linkcolor   / noprint;
          compute linkcolor ;
               call define('type', "style", "STYLE={BACKGROUND="||linkcolor||"}");
          endcomp;
        run;
        title;
      ods html close ;
   %end ;
%mend filecheckwithrules ;

/**
@endcond
@file
#### Examples ####
@code
    %* default check using the standard rules for SAS logs & returning standard types ;
    %filecheckwithrules(&_sasws_./general/biostat/tools/logviewer/tests/test1.log) ;
    %put &=filecheckwithrules;
    %* just return OTHER types into a table/macrovar called other ;
    %filecheckwithrules(&_sasws_./general/biostat/tools/logviewer/tests/test2.log,returntypes=OTHER,outputname=other) ;
    %put &=other;
    %* return standard types into test3 and print report ;
    %filecheckwithrules(&_sasws_./general/biostat/tools/logviewer/tests/test3.log,outputname=test3,print=1) ;
    %put &=test3;

   %* testing on PC SAS ;
    %filecheckwithrules(C:\github\logviewer\tests\test1.log,rules=C:\github\logviewer\src\rules.json,returntypes=ERROR|WARN,outputname=test) ;
    %filecheckwithrules(C:\github\logviewer\tests\test1.log,rules=C:\github\logviewer\src\rules.json,print=1) ;
    %filecheckwithrules(C:\github\logviewer\tests\test1.log,rules=C:\github\logviewer\src\rules.json,returntypes=SERIOUS,print=1) ;
    %put &=filecheckwithrules;
    %filecheckwithrules(pcsas,rules=C:\github\logviewer\src\rules.json,print=1) ;
@endcode
*/
