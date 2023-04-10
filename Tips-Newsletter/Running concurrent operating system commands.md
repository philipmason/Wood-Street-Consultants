Daily Tip 13 29/04/2003 12:10 PM

**Running concurrent operating system commands**

We can run more than one operating system command concurrently from SAS
using the SYSTASK statement. The code below shows how I am running two
commands in the sample SAS code. The first does a directory listing of
all files and subdirectories on my C drive, putting the listing into a
file. The second copies a file. Each one is given as task name and we
tell SAS not to wait for the command to finish running before going on.

The WAITFOR statement then tells SAS to wait until all the named tasks
have finished before going on.

For info no SYSTASK see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/hostwin.hlp/win-stmt-systask.htm&query=systask#\~1]{.underline}

For info no WAITFOR see
[http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/hostwin.hlp/win-stmt-waitfor.htm&query=systask#\~1]{.underline}

***SAS Program***

systask command \"dir c:\\ /s \>c:\\results.txt\" nowait taskname=dir ;

systask command \"copy c:\\test.txt d:\" nowait taskname=copy ;

waitfor \_all\_ dir copy ;

%put Finished! ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
