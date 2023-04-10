Daily Tip 106 20/09/2004 13:52:00

**Some basics of creating XML in SAS 9**

SAS 9 handles XML extremely well via the XML libname engine. To create
an XML file I could use some code like this.

**SAS Code to create XML**

libname test xml \'c:\\test.xml\' ;

**data** test.sample ;

name=\'Phil Mason\' ;

age=**40** ;

sex=\'M\' ;

phone=\'01491 824905\' ;

country=\'England\' ;

**run** ;

libname test ;

**XML created in c:\\test.xml**

\<?xml version=\"1.0\" encoding=\"windows-1252\" ?\>

\<TABLE\>

\<SAMPLE\>

\<name\> Phil Mason \</name\>

\<age\> 40 \</age\>

\<sex\> M \</sex\>

\<phone\> 01491 824905 \</phone\>

\<country\> England \</country\>

\</SAMPLE\>

\</TABLE\>

**What happens if you write multiple datasets to an XML file?**

The following code will only write the last file (test.c) to the XML.

libname test xml \'c:\\test.xml\' ;

**data** test.a ; x=**1** ; **run** ;

**data** test.b ; x=**1** ; **run** ;

**data** test.c ; x=**1** ; **run** ;

libname test ;

This code will also only write the last file (test.c) to the XML, even
though the log seems to indicate that they have all been written.

libname test xml \'c:\\test.xml\' ;

**data** test.a test.b test.c ; x=**1** ; **run** ;

libname test ;

I could use the following code though, which *would* create an XML file
containing all three tables.

libname test xml \'c:\\test.xml\' ;

**data** a b c ; x=**1** ; **run** ;

**proc** **copy** in=work out=test ;

select a b c ;

**run** ;

libname test ;

**SAS Code to use XML**

To make use of the XML file produced above I could simply point my
libname statement at it, and then refer to the table name defined in the
XML.

libname test2 xml \'c:\\test.xml\' ;

**proc** **print** data=test2.sample ;

**run** ;

libname test2 ;

p.s. There are ways to handle more complex XML files, which I will look
at in another tip..

*Example tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
