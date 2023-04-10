Daily Tip 98 14/04/2004 8:39 AM

**Change Control: Developing code in a client/server environment
(Windows & UNIX)**

There are a few things to watch out for when doing change control in a
client server environment between windows & UNIX -- which I have learnt
by doing it for a while.

General Issues

You may need to make your code portable so that it can run on windows or
UNIX. If so, you will most likely need to use macro variables to detect
the platform you are on and then macro logic to run the appropriate code
for the platform. You may also want to detect the version of SAS that
you are using, since some features you wish to use may differ between
versions.

Macro

value on windows XP

value on UNIX Solaris

&sysscp

**Win**

**SUN 4**

&sysscpl

**Win_pro**

**SunOS**

&sysver

**8.2**

**8.2**

&sysvlong

**8.02.02M0P012301**

**8.02.02M0P012301**

UNIX will also require its own autoexec and config file modifications if
you are running in client server. You will also need to modify the SAS
connect script being used to invoke SAS on UNIX with the appropriate
config/autoexec files.

Handling permissions

This depends how your UNIX system is set up, but on one that I was using
I found that when I created a file on UNIX I was the only person who had
write permission to that file -- others in my group could read it but
not write to it. The following macro issues the appropriate command to
fix permissions when I copy code up to UNIX.

***Chmod macro which handles permissions***

/\*\*\*

Program Macro Name : chmod (version#007)

Date : 19feb2004

Written By : phil mason

Overview : use chmod command to change files and authorities

Change History : 1mar04 (pm) added support for SAS views & catalogs

2mar04 (pm) added support for compressed files (Z)

2mar04 (pm) changed to do all files & directories and also go up a level
to ensure we get containing dir

Variable Input Fields : path \... libref of the path for which we want
to change permissions

local \... 1=run locally on UNIX, otherwise we run from client and
remote submit to server

\*\*\*/

%macro chmod(path=inprd,local=) ;

%put NOTE-USED: {};

%if &local= %then

%do ;

%syslput path=&path;

rsubmit ;

%end ;

\* Fix authorities so group has full access to datasets & indexes
created ;

\* use a datastep to force pathname to resolve on UNIX, rather than
windows ;

data \_null\_ ;

length path \$ 256 ;

path=pathname(\"&path\") ;

put path= ;

call system(\'cd \'\|\|trim(path)) ;

run ;

x \"chmod g=rxw \*\" ;

\* go up a level to fix the directory ;

x \"cd ..\" ;

x \"chmod g=rxw \*\" ;

%if &local= %then

endrsubmit ; ;

%mend chmod ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
