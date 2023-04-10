Daily Tip 21 23/05/2003 11:11 AM

**Useful symbols in ODS**

There are some useful symbols available throughout ODS, such as
Copyright & Trademark. These are easily accessed as the following code
shows. You simply code a hexadecimal value for the one you want.

Copyright

\'01\'x

RegisteredTM

\'02\'x

Trademark

\'04\'x

These are described in a great paper written by Brian Schellenberger
from SAS -

[http://support.sas.com/rnd/base/topics/odsprinter/qual.pdf]{.underline}

***SAS Program***

ods html file=\'test.html\' ;

**data** useful_symbols ;

Copyright=\'01\'x ;

RegisteredTM=\'02\'x;

Trademark=\'04\'x;

**run** ;

**proc** **print** ;

**run**;

ods html close ;

***SAS Output***

**Obs**

**Copyright**

**RegisteredTM**

**Trademark**

**1**

©

®

™

*Example tested under SAS 8.2 & 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
