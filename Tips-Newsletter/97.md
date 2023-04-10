Daily Tip 97 12/03/2004 8:12 AM

**Unlock, Query & other macros**

***Unlock***

Unlocks a module in the control file when it has been checked out but
the user does not want to check it back in. This then frees the module
up for use by others.

/\*\*\*

Program Name :UNLOCK

Date :2004

Written By :Philip Mason

Overview:Unlock a Module - when you checked it out and dont want to
check it back in

IP field source_type:mt : type of the module (MAC = Program macros

\*\*\* USR = User macros

\*\*\* FMT = Formats

\*\*\* CAT = SAS catalogs

\*\*\* PROG = SAS programs

\*\*\* TBL = SASCBTBL files)

\*\*\*/

%MACRO unlock(FILE,mt=mac,debug=) ;

%local exte; /\* extension of the source file \*/

\* If not in Personal Development then exit macro ;

%if %upcase(&env2)\^=SOURCE_DEV_COM %then

%goto endmacro ;

%if &debug=1 %then

%do ;

options mlogic mprint ;

%end ;

%if %index(&file,:)\>1 %then

%do ;

%let i=1 ;

%let f=%scan(&file,&i,:) ;

%do %while(\"&f\"\>\"\") ;

%unlock(&f,mt=&mt,debug=&debug) ;

%let i=%eval(&i+1) ;

%let f=%scan(&file,&i,:) ;

%end ;

%goto endmacro ;

%end ;

%IF %UPCASE(&ENV2)=SOURCE_DEV_COM %THEN

%DO ;

\* Detect if we are using catalog member and alter MT ;

%if %sysfunc(index(&file,.))\>1 %then

%let mt=cat;

\* Default extension : SAS;

%LET EXTE=SAS;

%if %upcase(&mt)=MAC %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\PROGRAM_MACROS;

%LET PREF2=&PREFIX\\&ENV\\PROGRAM_MACROS;

%end ;

%else

%if %upcase(&mt)=USR %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\USER_MACROS;

%LET PREF2=&PREFIX\\&ENV\\USER_MACROS;

%end ;

%else

%if %upcase(&mt)=CAT %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\CATALOG;

%LET PREF2=&PREFIX\\&ENV\\CATALOG;

%LET EXTE=SC2;

%end ;

%else

%if %upcase(&mt)=PROG %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\PROGRAMS;

%LET PREF2=&PREFIX\\&ENV\\PROGRAMS;

%end ;

%else

%if %upcase(&mt)=FMT %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\FORMATS;

%LET PREF2=&PREFIX\\&ENV\\FORMATS;

%end ;

%else

%if %upcase(&mt)=TBL %then

%do ;

%LET PREF=&PREFIX2\\&ENV2\\SASCBTBL;

%LET PREF2=&PREFIX\\&ENV\\SASCBTBL;

%end ;

%else

%do ;

%PUT ; %PUT ; %PUT ;

%put ERROR: - Unknown Member Type - &mt ;

%put ERROR: - Unknown Member Type - &mt ;

%put ERROR: - Unknown Member Type - &mt ;

%PUT ; %PUT ; %PUT ;

%goto endmacro ;

%end ;

%LET LOCKED=0;

%LET unlock=0;

\*\*\* UPDATE CONTROL DATASET \*\*\* ;

\* CHECK IF ITS LOCKED BY ME ;

DATA ref.SCM(KEEP=FILE LOCKUSER indate outdate LOCKDATE mt) ;

SET ref.SCM END=END ;

IF UPCASE(FILE)=UPCASE(\"&FILE\") &

UPCASE(mt)=UPCASE(\"&mt\") THEN

DO ;

IF LOCKDATE\>. THEN

DO ;

CALL SYMPUT(\'LOCKED\',1) ;

IF UPCASE(LOCKUSER)=UPCASE(\"&USERID\") THEN

DO ;

CALL SYMPUT(\'unlock\',1) ;

PUT \'NOTE: ;\' ;

PUT \'NOTE: Unlocking: \' FILE ;

PUT \'NOTE: ;\' ;

lockdate=. ;

delete ;

END ;

ELSE

DO ;

CALL SYMPUT(\'LOCKDATE\',LOCKDATE) ;

CALL SYMPUT(\'LOCKUSER\',LOCKUSER) ;

END ;

END ;

END ;

RUN ;

\*\*\* MESSAGES \*\*\* ;

%IF &LOCKED=1 %THEN

%DO ;

%IF &unlock=1 %THEN

%DO ;

\* Delete the file that was unlocked ;

%if %sysfunc(fileexist(\"&pref2\\&FILE..&EXTE\"))=1 %then

%do ;

options noxwait ;

%SYSEXEC ERASE \"&pref2\\&FILE..&EXTE\" ;

options xwait ;

%put ERASE \"&pref2\\&FILE..&EXTE\" ;

%PUT SYSRC: &SYSRC;

%end ;

%else

%put NOTE: &pref2\\&FILE..&EXTE was not found, and so cannot be erased.
;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: &FILE was unlocked ;

%PUT ; %PUT ; %PUT ;

%END ;

%ELSE

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT WARNING: &FILE cant be unlocked since someone else already has it
locked ;

%PUT WARNING: It was locked by %SYSFUNC(TRIM(&LOCKUSER)) on
%SYSFUNC(PUTN(&LOCKDATE,DATE7.)) ;

%PUT ; %PUT ; %PUT ;

%END ;

%END ;

%ELSE

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT WARNING: &FILE was NOT locked and so cannot be unlocked ;

%PUT ; %PUT ; %PUT ;

%END ;

%END ;

%ELSE

%PUT NOTE: NOT IN PERSONAL DEVELOPMENT ;

options xwait ;

%if &debug=1 %then

%do ;

%put \_user\_ ;

options nomlogic nomprint ;

%end ;

%endmacro:

%MEND unlock ;

***Query***

Reports on what modules a user currently has locked.

/\*\*\*

Program Macro Name :query (version#007)

Date :6feb2004

Written By :phil mason

Overview: query who has what locked. Specifying no parameters will show
what you have locked.

Change History : 01apr04 (kw) added upcase function to user so case
soesn\'t matter

Macros called : none

Trouble Shooting Hints :

Variable Input Fields : user \... userid of person you want to report on

\*\*\*/

%macro query(user=) ;

%put NOTE-USED:
{J:\\SASMiner\\source_dev_com\\PROGRAM_MACROS\\query.SAS} ;

user=&sysuserid ;%put &sysuserid;

data \_scm ;

set ref.scm(where=(lockdate\^=. & lockuser=%upcase(\"&user\"))) ;

run ;

dm \'vt \_scm\' ;

%mend query ;

***Where_am_i***

When this is used in conjunction with a standard header, it will modify
the code to produce a message saying where that code is coming from.
This can be very useful in debugging.

/\*\*\*

Program Macro Name : where_am_i (version#005)

Date : 30mar2004

Written By : Phil Mason

Overview : write a message to log stating where this macro is being used
from

IP field source_type : file \... file to read in and update message in

\*\*\*/

%macro where_am_i(file) ;

data \_null\_ ;

infile \"&file\" ;

file \"&file\" truncover lrecl=256 ;

input ;

i=index(upcase(\_infile\_),\'NOTE-USED: {\') ;

if i=0 then

do ;

put \_infile\_ ;

return ;

end ;

put \'%put NOTE-USED: {\' \"&file} ; \" ;

run ;

%mend where_am_i ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
