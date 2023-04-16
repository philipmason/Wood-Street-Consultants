Daily Tip 96 29/04/2004 4:49 PM

**Change Control: Promoting modules to production**

Promote macro

/\*\*\*

Program Macro Name : promote (version#002)

Date : 17feb2004

Written By : phil mason

Overview: promote a module from development to live - we dont have any
UAT at present

1 - copies module to source_live on windows network

2 - uploads module to crmprd on UNIX server

Change History : 18mar04 (pm) added explicit compile of format under
UNIX when promoting

Macros called : ci \... check in

sync \... synchronise files

Trouble Shooting Hints :

Data Input level :

Data Output level :

Data Input fields :

Data Output fields retained :

Data Output fields created :

Variable Input Fields : FILE : name of module (source code) to be
checked in

we can separate files by a colon (:) to let us use multiple file names

mt : type of the module (MAC = Program macros

USR = User macros

FMT = Formats

CAT = SAS catalogs

PROG = SAS programs

TBL = SASCBTBL files)

\*\*\*/

%macro promote(file,mt=mac) ;

%let mt=%upcase(&mt) ;

\*\*\* check in from common development to live ;

\* keep current macro variables ;

%let keep_env=&env;

%let keep_env2=&env2;

%let keep_prefix=&prefix;

%let keep_prefix2=&prefix2;

\* give them new values temporarily ;

%let env=&env2;

%let env2=source_live;

%let prefix=&prefix2;

%let prefix2=&prefix2;

%ci(&file,mt=&mt,special=promote) ;

\* upload from live to UNIX ;

%sync(&file,mt=&mt) ;

\* If we are promoting then compile format into LIBRARY (live) on
windows & then

compile format under UNIX for use there ;

%if &mt=FMT %then

%do ;

\* do on Windows ;

%let keep_fmt_lib=&fmt_lib;

%let fmt_lib=library;

filename fmt \"&prefix\\source_live\\formats\" ;

%inc fmt(&file..sas) ;

%let fmt_lib=&keep_fmt_lib;

\* do on UNIX ;

rsubmit ;

filename fmt \"&prefix/formats\" ;

%inc fmt(&file..sas) ;

endrsubmit ;

%end ;

\* restore macro variables ;

%let env=&keep_env;

%let env2=&keep_env2;

%let prefix=&keep_prefix;

%let prefix2=&keep_prefix2;

%mend promote ;

Sync macro

/\*\*\*

Program Macro Name : sync (version#001)

Date : 17feb2004

Written By : phil mason

Overview: synchronise a live module on the LAN with the UNIX server.
Currently we do a one way

sync by uploading the module to the server whenever we have done a
promote from

development to live

Change History :

Macros called :

Trouble Shooting Hints :

Data Input level :

Data Output level :

Data Input fields :

Data Output fields retained :

Data Output fields created :

Variable Input Fields : file \... file name

mt \... type of the module (MAC = Program macros

USR = User macros

FMT = Formats

CAT = SAS catalogs

PROG = SAS programs

TBL = SASCBTBL files)

\*\*\*/

%macro sync(file,mt=mac) ;

%put NOTE-USED: {};

\* Assign the correct suffix based on the member type ;

%let mt=%upcase(&mt) ;

%if &mt=MAC %then %let suffix=program_macros;

%else %if &mt=USR %then %let suffix=user_macros;

%else %if &mt=FMT %then %let suffix=formats;

%else %if &mt=CAT %then %let suffix=cat;

%else %if &mt=PROG %then %let suffix=programs;

%else %if &mt=TBL %then %let suffix=sascbtbl;

%let from_prefix=&prefix\\source_live\\&suffix;

filename in \"&from_prefix\\&file..sas\" ;

%syslput suffix=&suffix;

%syslput file=&file;

rsubmit ;

filename out \"/mg_apps/crm/crmprd/analysis/&suffix/&file..sas\" ;

proc upload infile=in outfile=out ;

run ;

\* now we need to fix privileges so others can change this module ;

x cd /mg_apps/crm/crmprd/analysis/&suffix ;

x chmod g+rwx \"&file..sas\" ;

endrsubmit ;

%mend sync ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
