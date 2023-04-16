Daily Tip 83 25/11/2003 12:44 PM

**Starting & minimising programs from SAS**

Sometimes you might like to start up a program from SAS, such as
Microsoft Word, since you may want to carry out some DDE with that
program (for example). Under windows you can use the start command to
run a program, and by using the /min parameter you can also minimise
that program once it begins running.

When you specify the program name to use it seems that you can't specify
the real path to the file you wish to run. Instead you need to convert
it to a DOS style path. This means that no directory name can be longer
than 8 character. This means that the 1^st^ 6 characters are used,
followed by a tilde (\~) and then a number. The number refers to whether
this directory is the 1^st^, 2^nd^, 3^rd^, etc directory of with the
same 1^st^ 6 characters. In the example below I have 3 directories which
start with "Micros", and the one I want to use is the 3^rd^ one.

*** Sample code***

\* don't wait for command to finish or synchronize with rest of SAS ;

options noxwait noxsync ;

\* start MS Word and minimize it ;

/\*x \"start /min C:\\Program Files\\Microsoft
Office\\Office10\\winword.exe\" ;\*/

x \"start /min C:\\Progra\~1\\Micros\~3\\Office10\\winword.exe\" ;

You can specify the real path to the file, provided you enclose the long
file names in double quotes, and enclose the whole thing in single
quotes. The code below works.

 

x \'\"C:\\Program Files\\Microsoft Office\\Office10\\winword.exe\"\' ;

***Start Command Syntax***

START \[\"title\"\] \[/Dpath\] \[/I\] \[/MIN\] \[/MAX\] \[/SEPARATE \|
/SHARED\]

\[/LOW \| /NORMAL \| /HIGH \| /REALTIME \| /ABOVENORMAL \|
/BELOWNORMAL\]

\[/WAIT\] \[/B\] \[command/program\]

\[parameters\]

\"title\" Title to display in window title bar.

path Starting directory

B Start application without creating a new window. The

application has \^C handling ignored. Unless the application

enables \^C processing, \^Break is the only way to interrupt

the application

I The new environment will be the original environment passed

to the cmd.exe and not the current environment.

MIN Start window minimized

MAX Start window maximized

SEPARATE Start 16-bit Windows program in separate memory space

SHARED Start 16-bit Windows program in shared memory space

LOW Start application in the IDLE priority class

NORMAL Start application in the NORMAL priority class

HIGH Start application in the HIGH priority class

REALTIME Start application in the REALTIME priority class

ABOVENORMAL Start application in the ABOVENORMAL priority class

BELOWNORMAL Start application in the BELOWNORMAL priority class

WAIT Start application and wait for it to terminate

command/program

If it is an internal cmd command or a batch file then

the command processor is run with the /K switch to cmd.exe.

This means that the window will remain after the command

has been run.

If it is not an internal cmd command or batch file then

it is a program and will run as either a windowed application

or a console application.

parameters These are the parameters passed to the command/program

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
