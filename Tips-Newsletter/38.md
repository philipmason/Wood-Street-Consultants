Daily Tip 38 20/06/2003 7:08 AM

**Reading and writing SAS datasets within a ZIP file**

Some people like to zip (compress) things to save space. Typically when
you then want to use them, you first have to unzip (decompress) them. If
you have a text file that has been zipped, then you can use pipes from
SAS to read that file without first unzipping it. However pipes
[can't]{.underline} be used to read SAS datasets from a zip file in this
way. Pipes are used with *filename* statements, and datasets must be
read using *libname* statements.

There is a way to read and write SAS datasets which are stored in a zip
file. This involves getting a product called ZIPMAGIC (for windows
platforms) which enables zip files to be treated like folders. You can
then define your zip file with a *libname* statement and read/write
datasets within it.

See [http://www.aladdinsys.com/zipmagic/]{.underline} for information
and free trial of ZIPMAGIC.

**SAS Log**

1 libname test \'C:\\Sample SAS data.zip\' ;

NOTE: Libref TEST was successfully assigned as follows:

Engine: V8

Physical Name: C:\\Sample SAS data.zip

2 proc print data=test.cars ;

3 run ;

NOTE: There were 116 observations read from the data set TEST.CARS.

NOTE: PROCEDURE PRINT used:

real time 0.26 seconds

cpu time 0.03 seconds

4 data test.new_thing ;

5 x=1 ;

6 run ;

NOTE: The data set TEST.NEW_THING has 1 observations and 1 variables.

NOTE: DATA statement used:

real time 0.14 seconds

cpu time 0.03 seconds

This tip written in response to a question from Mark Legge, EU NAB.

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
