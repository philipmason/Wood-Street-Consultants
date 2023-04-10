Daily Tip 129 SAVEDATE 09/05/2005 09:29:00

**Add news to your SAS log**

There is a SAS option that can be used to add the contents of a text
file at the start of each SAS log. This is typically used for sending
news and information to SAS users across a company. The news file can be
specified in a configuration file or on the invocation command for
starting SAS. It's a great way to communicate with all users of SAS in
an organisation.

To use it, add something like this to your sasv9.cfg file, typically
located in 'C:\\Program Files\\SAS\\SAS 9.1\\nls\\en':

-news 'c:\\news.txt'

Then you will see the contents of that file shown in your log each time
SAS starts:

NOTE: Copyright (c) 2002-2003 by SAS Institute Inc., Cary, NC, USA.

NOTE: SAS (r) 9.1 (TS1M3)

Licensed to OFFICE FOR NATIONAL STATISTICS, Site 0084110017.

NOTE: This session is executing on the XP_PRO platform.

NOTE: SAS 9.1.3 Service Pack 2

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+

\| Greetings from Wood Street Consultants. \|

\| \|

\| For SAS Help Phone: 01491-824905 \|

\| Email: help@woodstreet.org.uk \|

\| \|

\| SAS Documentation: http://v9doc.sas.com/sasdoc/ \|

\| \|

\| Upcoming Training: http://www.sas.com/offices/europe/uk/education/ \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+

\| \|

\| Tip of the week \|

\| \-\-\-\-\-\-\-\-\-\-\-\-\-\-- \|

\| Instead of using code like this \... \|

\| if x=1 then y=2 ; \|

\| else y=3 ; \|

\| You can now use code like this \... \|

\| y=ifn(x=1,2,3) ; \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+

NOTE: SAS initialization used:

real time 1.20 seconds

cpu time 0.96 seconds

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. HYPERLINK \"mailto:tips@woodstreet.org.uk\"
[tips@woodstreet.org.uk]{.underline}

HYPERLINK \"http://www.woodstreet.org.uk\"
[www.woodstreet.org.uk]{.underline}
