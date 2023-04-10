Daily Tip 104 28/06/2004 6:57 AM

**Finding help from SAS help files (Viewtable)**

Since I was unable to find documentation on Viewtable (covered in tip
103), I was helped by Dante diTommaso & Randy Herbison who pointed out
that there was documentation available. It is not in the SAS OnlineDoc,
but rather is in the help files installed with SAS, which end with .CHM
(compiled HTML help). The CHM files are typically located in C:\\Program
Files\\SAS Institute\\SAS\\V8\\core\\help or C:\\Program Files\\SAS\\SAS
9.1\\core\\help, depending on where you have installed SAS and the
version.

Viewtable syntax, including the invocation arguments are covered here:

ms-its:C:\\Program%20Files\\SAS%20Institute\\SAS\\V8\\core\\help\\fsp.chm::/fsp.hlp/a000007097.htm

If you are unsure how to use that reference, you can just paste it into
the address area of the Windows Explorer (doesn't seem to work if you do
the same in the Internet Explorer). You can see the reference includes
the path I installed SAS to, which was on my C drive in the default
location, so you will need to adjust if you installed somewhere else.

If you want to do this all from SAS, then you can use the following
program...

%let systemroot=%sysget(systemroot) ;

%let sasroot=%sysget(sasroot) ;

x \"&SystemRoot\\explorer.exe
ms-its:&sasroot\\core\\help\\fsp.chm::/fsp.hlp/a000007097.htm\" ;

*Example tested under SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
