Daily Tip 93 20/04/2004 5:05 PM

**Change Control: Using autoexec files**

We use a custom autoexec to define several things:

> • define macro variables that describe the environment we are in and
> the one we will move modules between
>
> • definition of autocall macro library, using the sasautos option
>
> • allocation of format libraries and definition of search order using
> fmtsearch option
>
> • allocation of miscellaneous libraries
>
> • allocation of fileref pointing the program directories defined in
> the order we want to include modules in
>
> • getauto macro call, which allows use of a personal autoexec as well
> as the general group autoexec

***Sample autoexec file***

%let name=phil mason;

%let userid=%sysget(username) ;

options sasautos=(lib1 lib2 sasautos)

fmtsearch=(myfmts) ;

libname saleslib 'c:\\sales' ;

filename in 'c:\\in\\march' ;

%getauto ;

***The Getauto macro***

This is useful to allow individuals to have a custom autoxec file while
still having a central autoexec file with common tasks done.

/\*\*\*

Program Name : getauto

Date : feb2004

Written By : Phil Mason

Overview: looks to see if you have an autoexec file that exists in

your My SAS Files dierctory and if so then it runs it.

This allows users to have a custom autoexec

\*\*\*/

%macro getauto ;

%let mysasfiles=%sysget(mysasfiles) ;

%put &mysasfiles;

%if %sysfunc(fileexist(&mysasfiles.autoexec.sas)) %then

%include \"&mysasfiles\\autoexec.sas\" ;

%mend getauto ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
