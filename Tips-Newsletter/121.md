Daily Tip 121 02/03/2005 09:41:00

**Connecting to ODBC the easy way**

If you have SAS/Access for ODBC licensed, then you will be able to
connect to all kinds of supported databases through libname engines.
This lets you use those databases just as though they were SAS files.
Sometimes it can be tricky setting up the libname definition though, but
there is an easy way to do it.

***ODBC***

libname in odbc complete=\" \" ;

%put Connection String: %superq(sysdbmsg) ;

When you run this code you get the "Select Data Source" window popup
which lets you select, modify or define ODBC data sources. The libref is
then defined and you can pickup the connection string created from the
macro variable &sysdbmsg. That can then be put into the complete=
string.

**SAS Log**

11 libname in odbc complete=XXX ;

NOTE: Libref IN was successfully assigned as follows:

Engine: ODBC

Physical Name: MS Access Database

12 %put Connection String: %superq(sysdbmsg) ;

Connection String: ODBC: DSN=MS Access Database;DBQ=D:\\My
Documents\\db1.mdb;DefaultDir=D:\\My

Documents;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
