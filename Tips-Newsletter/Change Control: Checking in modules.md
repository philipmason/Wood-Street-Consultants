Daily Tip 95 12/03/2004 8:12 AM

**Change Control: Checking in modules**

Overview

Checking in modules makes use of 2 macros. The CI macro checks the
module in, and calls the increment_version macro which increments the
version number as the modele is checked in. This relies on a standard
header being used, which can be defined in a template module and is then
used as a template when creating a new module.

Check In macro

/\*\*\*

Program Name : ci

Date : 19Jan2004

Written By : Phil Mason

Overview: Check in (move to common environment) a module, create a
backup

Change History :

Macros called :

Trouble Shooting Hints :

Data Input level :

Data Output level :

Data Input fields : I expect the following macro variables to exist:

\- env \... PDEV for personal development

\- env2 \... CDEV for common development

\- prefix \... path prefix required for environment we are in

\- prefix2 \... path prefix required for environment we are checking in
& out of

Data Output fields retained :

Data Output fields created :

Variable Input Fields :

IP field source_type: FILE : name of module (source code) to be checked
in

we can separate files by a colon (:) to let us use multiple file names

mt : type of the module (MAC = Program macros

USR = User macros

FMT = Formats

CAT = SAS catalogs

PROG = SAS programs

TBL = SASCBTBL files)

backups : number of backup versions that need to be maintained

debug : debug information level

special : for selecting special modes of operation, including:

\--\> promote = Promoting code from Common Dev to Live

\*\*\*/

%macro ci(FILE, mt=mac, backups=10, debug=, special=);

%let special=%upcase(&special) ;

\* If we are promoting then we dont move since that deletes the module
from common, instead we copy ;

%if %upcase(&special)=PROMOTE %then

%let cmd=COPY;

%else

%let cmd=MOVE;

\*\*\* CHECK IN A MODULE FROM CURRENT ENVIRONMENT SOURCE LIBRARY \*\*\*;

%\* If not in Personal Development then exit macro ;

%if %upcase(&special)\^=PROMOTE &

%upcase(&env2) \^= SOURCE_DEV_COM %then

%do;

%put ERROR: NOT IN PERSONAL ENVIRONMENT !!!;

%goto endmacro;

%end;

options noxwait ;

%if &debug=1 %then

%do ;

options mprint mlogic ;

%end ;

%\* Handle check in of several modules in one call (recursive call to
macro ci);

%if %index( &file, :) \> 1 %then

%do ;

%let i=1 ;

%let f = %scan( &file, &i, :) ;

%do %while( \"&f\" \> \"\" ) ;

%put NOTE: Invoking macro: CI(&f,mt=&mt,backups=&backups,debug=&debug) ;

%ci( &f, mt=&mt, backups=&backups, debug=&debug) ;

%let i = %eval( &i+1) ;

%let f = %scan( &file, &i, :) ;

%end ;

%goto endmacro ;

%end ;

%\* Detect if we are using catalog member and alter MT ;

%if %sysfunc( index(&file,.)) \> 1 %then

%let mt=cat;

%\* Check the module type, fix the directories containing the versions
in common environment;

%if %upcase( &mt) = MAC %then

%do ;

%let type = PROGRAM_MACROS ;

%LET CURRDIR = &PREFIX2\\&ENV2\\&type; \* Directory for current version
of macros;

%LET BACKDIR = &PREFIX2\\&ENV2\\&type..BAK; \* Directory for backup
versions of macros;

%end ;

%else

%if %upcase( &mt) = USR %then

%do ;

%let type = USER_MACROS ;

%LET CURRDIR = &PREFIX2\\&ENV2\\&type; \* Directory for current version
of macros;

%LET BACKDIR = &PREFIX2\\&ENV2\\&type..BAK; \* Directory for backup
versions of macros;

%end ;

%else

%if %upcase(&mt) = CAT %then

%do ;

%let type = CAT ;

%let cat = %sysfunc( scan(&file,1,.)) ;

%let entry = %sysfunc( scan(&file,2,.)) ;

%let et = %sysfunc( scan(&file,3,.)) ;

%LET CURRDIR = &PREFIX2\\&ENV2\\CATALOG; \* Directory for current
version of catalogs;

%LET BACKDIR = &CURRDIR; \* Directory for backup versions of catalogs;

%end ;

%else

%if %upcase(&mt) = PROG %then

%do ;

%let type = PROGRAMS ;

%LET CURRDIR = &PREFIX2\\&ENV2\\&type; \* Directory for current version
of PROGRAMSs;

%LET BACKDIR = &CURRDIR..bak; \* Directory for backup versions of
PROGRAMSs;

%end ;

%else

%if %upcase(&mt) = FMT %then

%do ;

%let type = FORMATS ;

%LET CURRDIR = &PREFIX2\\&ENV2\\&type; \* Directory for current version
of Formats;

%LET BACKDIR = &CURRDIR..bak; \* Directory for backup versions of
Formats;

%end ;

%else

%if %upcase(&mt) = TBL %then

%do ;

%LET type = SASCBTBL;

%LET CURRDIR = &PREFIX2\\&ENV2\\SASCBTBL; \* Directory for current
version of SASCBTBL files;

%LET BACKDIR = &CURRDIR; \* Directory for backup versions of SASCNTBL
files;

%end ;

%else

%do ;

%put Unknown Member Type - &mt ;

%put Unknown Member Type - &mt ;

%put Unknown Member Type - &mt ;

%goto endmacro ;

%end ;

%LET LOCKED=0; \* \'Module is already locked\' flag;

%LET CHECKIN=0; \* \'Module can be checked in\' flag;

\*\*\* UPDATE CONTROL DATASET \*\*\* ;

\*\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--;

%if %upcase(&special)\^=PROMOTE %then

%do ;

\* CHECK IF IT IS LOCKED BY ME, I.E. IF CHECK-IN CAN BE PERFORMED ;

DATA ref.scm (KEEP= FILE LOCKUSER LOCKDATE mt indate outdate) ;

format indate lockdate outdate datetime. ;

RETAIN FOUND 0 ;

SET ref.scm END=END ;

IF UPCASE( FILE) = UPCASE( \"&FILE\") &

UPCASE( mt) = UPCASE( \"&mt\") THEN

DO ;

FOUND = 1 ;

IF LOCKDATE \> . THEN

DO ;

CALL SYMPUT( \'LOCKED\', 1) ; /\* Position the \'locked\' flag \*/

IF UPCASE( LOCKUSER) = UPCASE( \"&USERID\") THEN

DO ;

CALL SYMPUT( \'CHECKIN\', 1) ; /\* Position the \'checkin\' flag \*/

PUT \'NOTE: ;\' ;

PUT \'NOTE: CHECKING IN: \' FILE ;

PUT \'NOTE: ;\' ;

outdate = lockdate ;

indate = datetime() ;

lockdate = . ;

END ;

ELSE

DO ;

CALL SYMPUT( \'LOCKDATE\', LOCKDATE) ;

CALL SYMPUT( \'LOCKUSER\', LOCKUSER) ;

END ;

END ;

END ;

RUN ;

%end ;

\*\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--;

\*\*\* HANDLE BACKUPS \*\*\* ;

%IF &checkin=1 or

%upcase(&special)=PROMOTE %then

%DO ;

%if %sysfunc(fileexist(\"&BACKDIR\\&FILE..B&BACKUPS\"))=1 %then

%do ;

%PUT \*\*\*\*\*\*\* DELETE LAST VERSION \*\*\*\*\*\*\* ;

%SYSEXEC ERASE \"&BACKDIR\\&FILE..B&BACKUPS\" ;

%PUT NOTE: ERASE \"&BACKDIR\\&FILE..B&BACKUPS\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%PUT \*\*\*\*\*\*\* DOING BACKUPS \*\*\*\*\*\*\* ;

%DO I = &BACKUPS %TO 1 %BY -1 ;

%IF &I \> 1 %THEN

%do ;

%if %sysfunc(fileexist(\"&BACKDIR\\&FILE..B%EVAL(&I-1)\"))=1 %then

%do ;

%SYSEXEC RENAME \"&BACKDIR\\&FILE..B%EVAL(&I-1)\" \"&FILE..B&I\" ;

%PUT NOTE: RENAME \"&BACKDIR\\&FILE..B%EVAL(&I-1)\" \"&FILE..B&I\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%end ;

%ELSE

%do ;

%if %sysfunc(fileexist(\"&BACKDIR\\&FILE..BAK\"))=1 %then

%do ;

%SYSEXEC RENAME \"&BACKDIR\\&FILE..BAK\" \"&FILE..B&I\" ;

%PUT NOTE: RENAME \"&BACKDIR\\&FILE..BAK\" \"&FILE..B&I\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%end ;

%END ;

%if %upcase(&mt) = CAT %then

%do ;

%if %sysfunc(fileexist(\"&CURRDIR\\&cat..SC2\"))=1 %then

%if &et = %then

%do ;

%\* The whole catalog is being checked in;

%SYSEXEC &cmd \"&CURRDIR\\&cat..SC2\" \"&BACKDIR\\&FILE..BAK\" ;

%PUT NOTE: &cmd \"&CURRDIR\\&cat..SC2\" \"&BACKDIR\\&FILE..BAK\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%else

%do ;

%\* Only a member of the calalog is being checked in;

%SYSEXEC COPY \"&CURRDIR\\&cat..SC2\" \"&BACKDIR\\&FILE..BAK\" ;

%\"&CURRDIR\\&cat..SC2\" \"&BACKDIR\\&FILE..BAK\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%end ;

%else

%do ;

%if %sysfunc( fileexist(\"&CURRDIR\\&FILE..SAS\")) = 1 %then

%do ;

%SYSEXEC &cmd \"&CURRDIR\\&FILE..SAS\" \"&BACKDIR\\&FILE..BAK\" ;

%PUT NOTE: &cmd \"&CURRDIR\\&FILE..SAS\" \"&BACKDIR\\&FILE..BAK\" ;

%PUT NOTE: SYSRC: &SYSRC;

%end ;

%end ;

%PUT \*\*\*\*\*\*\* FINISHED BACKUPS \*\*\*\*\*\*\* ;

%END ;

\*\*\* CHECK IN FILE \*\*\* ;

%if &checkin=1 or

%upcase(&special)=PROMOTE %then

%do;

%if %upcase( &type) = CAT %then

%do;

%if &et = %then

%do ;

%\* The whole catalog is being checked in -\> &cmd the whole catalog ;

proc catalog cat=cat_P.&cat ;

copy out=cat_C.&cat &cmd ;

run ;

quit ;

%end ;

%else

%do ;

%\* Only a member of the calalog is being checked in -\> Copy only that
catalog member ;

proc catalog cat=cat_P.&cat ;

copy out=cat_C.&cat &cmd ;

select &entry / et=&et ;

run ;

quit ;

%end ;

%end;

%else

%do;

\* increment the version number, unless we are promoting ;

%if %upcase(&special)\^=PROMOTE %then

%increment_version(&PREFIX\\&ENV\\&type\\&FILE..SAS) ;

\* &cmd other member types ;

%SYSEXEC &cmd \"&PREFIX\\&ENV\\&type\\&FILE..SAS\"

\"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\" ;

%PUT NOTE: &cmd \"&PREFIX\\&ENV\\&type\\&FILE..SAS\"

\"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\" ;

%put NOTE: sysrc=&sysrc;

\* Update the statement (if present) which writes out where this code

is being used from ;

%where_am_i(&PREFIX2\\&ENV2\\&type\\&FILE..SAS) ;

%end;

%end;

%put type=&type env2=&env2 ;

%put \"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\" ;

\* compile the formats in the new environment ;

%if %upcase( &mt) = FMT %then

%do;

%if %upcase(&env2)=SOURCE_DEV_COM %then

%let fmt_lib=fmt2;

%include \"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\" ;

run ;

\* Delete the old format module ;

proc catalog cat=fmt1.formats ;

delete &file / et=format ;

run ;

%let fmt_lib=fmt1;

%end ;

\*\*\* MESSAGES \*\*\* ;

%IF &LOCKED=1 %THEN

%DO ;

%IF &CHECKIN=1 %THEN

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: &FILE WAS CHECKED IN ;

%PUT ; %PUT ; %PUT ;

%END ;

%ELSE

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: &FILE CANT BE CHECKED IN SINCE SOMEONE ELSE HAS IT LOCKED ;

%PUT NOTE: IT IS CURRENTLY LOCKED BY %SYSFUNC(TRIM(&LOCKUSER)) AT
%SYSFUNC(PUTN(&LOCKDATE,DATE7.)) ;

%PUT ; %PUT ; %PUT ;

%END ;

%END ;

%ELSE

%if %upcase(&special)\^=PROMOTE %then

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: &FILE WAS NOT LOCKED AND SO CANNOT BE CHECKED IN ;

%PUT ; %PUT ; %PUT ;

%END ;

options xwait ;

%if &debug=1 %then

%do ;

%put \_user\_ ;

options nomlogic nomprint ;

%end ;

%endmacro:

%mend ci;

Increment version

This macro will increment a version number in code checked in using the
check in macro (CI) -- providing you are using a header containing
version numbers in the required format, as in the standard header I
proposed in a previous tip.

/\*\*\*

Program Macro Name : increment_version (version#004)

Date : 18feb2004

Written By : Phil Mason

Overview : Increment the version number in a file. Version number must
be in the following format,

but can appear anywhere in the file. Case is ignored. Zeroes indicate
position of any digits.

Change History :

Macros called :

Trouble Shooting Hints :

Data Input level :

Data Output level :

Data Input fields :

Data Output fields retained :

Data Output fields created :

Variable Input Fields :

IP field source_type :

file \... file to read in and increment version number

\*\*\*/

%macro increment_version(file) ;

data \_null\_ ;

length v \$ 3 ;

infile \"&file\" sharebuffers ;

file \"&file\" ;

input ;

i=index(upcase(\_infile\_),\'(VERSION#\') ;

if i=0 then

do ;

put ;

return ;

end ;

j=i+9 ;

v=substr(\_infile\_,j,3) ;

version=input(v,3.)+1 ;

put \@j version z3. ;

run ;

%mend increment_version ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
