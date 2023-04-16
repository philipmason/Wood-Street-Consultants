Daily Tip 94 20/04/2004 5:15 PM

**Change Control: Checking out modules**

Modules are checked out to be changed and then either checked back in or
unlocked so that changes are lost. The macro to do this follows.

/\*\*\*

Program Name : CO

Date : 2004

Written By : Philip Mason

Overview: CHECK OUT A MODULE, CREATE A BACKUP

\- can separate multiple files by colons

IP field source_type: mt : type of the module (MAC = Program macros

\*\*\* USR = User macros

\*\*\* FMT = Formats

\*\*\* CAT = SAS catalogs

\*\*\* PROG = SAS programs

\*\*\* TBL = SASCBTBL files)

\*\*\*/

%MACRO CO(FILE,mt=mac,debug=) ;

\*\*\* CHECK OUT A MODULE FROM CURRENT ENVIRONMENT SOURCE LIBRARY
\*\*\*;

\*\*\* MAKE USE OF PRE-DEFINED MACRO VARIABLES: ENV, PREFIX ;

\* If not in Personal Development then exit macro ;

%if %upcase(&env2)\^=SOURCE_DEV_COM %then

%goto endmacro ;

options noxwait ;

%if &debug=1 %then

%do ;

options mlogic mprint ;

%end ;

%IF &ENV= OR &PREFIX= %THEN

%PUT NOTE: MISSING MACRO VARIABLE DEFINITIONS ;

%if \"&file\"=\"\*\" or \"&file\"=\"\" %then

%do ;

proc sort data=ref.scm out=ref_scm ;

by mt lockuser file ;

run ;

proc print data=ref_scm label noobs ;

where lockdate\^=. ;

by mt ;

id mt lockuser ;

var file lockdate ;

run ;

dm \'output\' output ;

%goto endmacro ;

%end ;

%else

%if %index(&file,:)\>1 %then

%do ;

%let i=1 ;

%let f=%scan(&file,&i,:) ;

%do %while(\"&f\"\>\"\") ;

%co(&f,mt=&mt) ;

%let i=%eval(&i+1) ;

%let f=%scan(&file,&i,:) ;

%end ;

%goto endmacro ;

%end ;

\* Detect if we are using catalog member and alter MT ;

%if %sysfunc(index(&file,.))\>1 %then

%let mt=cat;

%if %upcase(&mt)=MAC %then

%LET type=PROGRAM_MACROS;

%else

%if %upcase(&mt)=USR %then

%LET type=USER_MACROS;

%else

%if %upcase(&mt)=CAT %then

%do ;

%let cat=%sysfunc(scan(&file,1,.)) ;

%let entry=%sysfunc(scan(&file,2,.)) ;

%let et=%sysfunc(scan(&file,3,.)) ;

%LET type=CAT;

%end ;

%else

%if %upcase(&mt)=TBL %then

%LET type=SASCBTBL;

%else

%if %upcase(&mt)=PROG %then

%LET type=PROGRAMS;

%else

%if %upcase(&mt)=FMT %then

%LET type=FORMATS;

%else

%do ;

%put Unknown Member Type - &mt ;

%put Unknown Member Type - &mt ;

%put Unknown Member Type - &mt ;

%goto endmacro ;

%end ;

%IF %UPCASE(&ENV2)=SOURCE_DEV_COM %THEN

%DO ;

%LET LOCKED=0;

\*\*\* UPDATE THE CONTROL DATASET \*\*\* ;

\* CHECK IF ITS LOCKED ;

DATA ref.scm(KEEP=FILE LOCKUSER LOCKDATE mt indate outdate) ;

RETAIN FOUND 0 ;

\* Handle empty dataset condition ;

if \_n\_=1 & end then

link none ;

SET ref.scm END=END ;

\* Note: =: doesnt work here, so I must do substr ;

len1=length(file) ;

len2=length(\"&file\") ;

len=min(len1,len2) ;

\* If already processed our record then just copy the others ;

if found then

do ;

output ;

return ;

end ;

IF (upcase(mt)=\'CAT\' &

substr(UPCASE(FILE),1,len)=substr(UPCASE(\"&FILE\"),1,len) &

UPCASE(mt)=UPCASE(\"&mt\")

) or

(upcase(mt)\^=\'CAT\' &

UPCASE(FILE)=UPCASE(\"&FILE\") &

UPCASE(mt)=UPCASE(\"&mt\")

) THEN

DO ;

%if &debug\> %then put \'\*\*\* FOUND - \' mt= file= len= ;;

\* If locked by another user ;

IF LOCKDATE\>. &

UPCASE(lockuser)\^=UPCASE(\"&userid\") THEN

DO ;

FOUND=1 ;

%if &debug\> %then put \'WARNING: \*\*\* Locked by another user - \'
lockdate= lockuser= found= ;;

CALL SYMPUT(\'LOCKED\',1) ;

CALL SYMPUT(\'LOCKUSER\',LOCKUSER) ;

CALL SYMPUT(\'LOCKDATE\',LOCKDATE) ;

END ;

ELSE

IF LOCKDATE\>. then

DO ;

FOUND=1 ;

%if &debug\> %then put \'NOTE: \*\*\* Locked by you - \' lockdate=
lockuser= found= ;;

CALL SYMPUT(\'LOCKED\',1) ;

CALL SYMPUT(\'LOCKUSER\',LOCKUSER) ;

CALL SYMPUT(\'LOCKDATE\',LOCKDATE) ;

put \"NOTE:\" ;

put \"NOTE: File already locked by you!!!: \" lockuser= ;

put \"NOTE:\" ;

END ;

END ;

OUTPUT ;

none:

IF END THEN

DO ;

CALL SYMPUT(\'FOUND\',FOUND) ;

\* If observation wasnt found then we will make one ;

IF NOT FOUND THEN

DO ;

FILE=\"&FILE\" ;

mt=\"&mt\" ;

LOCKDATE=datetime() ;

LOCKUSER=\"&USERID\" ;

%if &debug\> %then put \'NOTE: \*\*\* Not found - \' lockdate= lockuser=
mt= file= ;;

put \"NOTE:\" ;

put \"NOTE: Checking out &file\" ;

put \"NOTE:\" ;

OUTPUT ;

END ;

END ;

RUN ;

\*\*\* CHECK OUT FILE \*\*\* ;

%IF &LOCKED=0 %THEN

%if %upcase(&type)=CAT %then

%do ;

%put NOTE: et=&et \-\-- cat_c.&file \-\-- cat=&cat ;

\* See if member exists ;

%if &et= &

%sysfunc(exist(cat_c.&file,catalog))=1 %then

%do ;

\* Copy a catalog member from CDEV to PDEV ;

proc catalog cat=cat_C.&cat ;

copy out=cat_P.&cat ;

run ;

quit ;

%end ;

%else

%if %sysfunc(exist(&file,\'catalog\'))=1 %then

%do ;

\* Copy a catalog member from CDEV to PDEV ;

proc catalog cat=cat_C.&cat ;

copy out=cat_P.&cat ;

select &entry / et=&et ;

run ;

quit ;

%end ;

%end ;

%else

%DO ;

\* See if file exists ;

%if %sysfunc(fileexist(&PREFIX2\\&ENV2\\&type\\&FILE..SAS))=1 %then

%do ;

%if %sysfunc(fileexist(&PREFIX\\&ENV\\&type\\&FILE..SAS))=1 %then

%do ;

%PUT ; %PUT ; %PUT ;

%put ERROR: Cannot copy over existing file, please delete it ;

%PUT ; %PUT ; %PUT ;

%end ;

%else

%do ;

%SYSEXEC COPY \"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\"

\"&PREFIX\\&ENV\\&type\" ;

%put NOTE: COPY \"&PREFIX2\\&ENV2\\&type\\&FILE..SAS\"

&PREFIX\\&ENV\\&type ;

%PUT NOTE: COPY SYSRC: &SYSRC;

%where_am_i(&PREFIX\\&ENV\\&type\\&file..sas) ;

dm \'wedit \"&PREFIX\\&ENV\\&type\\&file..SAS\"\' ;

%end ;

%end ;

%else

%do ;

%if %sysfunc(fileexist(&PREFIX\\&ENV\\&type\\&FILE..SAS))=1 %then

%do ;

%PUT ; %PUT ; %PUT ;

%put ERROR: Cannot copy over existing file, please delete it ;

%PUT ; %PUT ; %PUT ;

%end ;

%else

%do ;

\* Copy the new module template from CDEV and save under the new name in
PDEV ;

%SYSEXEC COPY \"&PREFIX2\\&ENV2\\&type\\template.SAS\"

\"&PREFIX\\&ENV\\&type\\&file..sas\" ;

%where_am_i(&PREFIX\\&ENV\\&type\\&file..sas) ;

dm \'wedit \"&PREFIX\\&ENV\\&type\\&file..SAS\"\' ;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: A new module called &FILE WAS created ;

%PUT ; %PUT ; %PUT ;

%end ;

%end ;

%END ;

\*\*\* MESSAGES \*\*\* ;

%IF &LOCKED=1 %THEN

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT WARNING: &FILE WAS ALREADY LOCKED BY %SYSFUNC(TRIM(&LOCKUSER)) ON
%SYSFUNC(PUTN(&LOCKDATE,DATETIME7.)) ;

%PUT ; %PUT ; %PUT ;

%END ;

%ELSE

%DO ;

%PUT ; %PUT ; %PUT ;

%PUT NOTE: YOU HAVE LOCKED THE FILE: &FILE ;

%PUT ; %PUT ; %PUT ;

%END ;

%END ;

%ELSE

%PUT ERROR: NOT IN PERSONAL DEVELOPMENT ;

options xwait ;

%if &debug=1 %then

%do ;

%put \_user\_ ;

options nomlogic nomprint ;

%end ;

%endmacro:

%MEND CO ;

***Sample template.sas***

If checking out a module and it does not exist, then it will use a
template as the basis for the new module. Here is a sample template that
could be used for a macro.

/\*\*\*

Macro Name : (version#000)

Date :

Written By :

Overview :

Change History :

Macros called :

Trouble Shooting :

Parameters :

\*\*\*/

%macro ;

%put NOTE-USED: {};

%mend ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
