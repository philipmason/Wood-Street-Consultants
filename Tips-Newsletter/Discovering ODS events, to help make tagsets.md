Daily Tip 114 03/12/2004 12:30:00

**Discovering ODS events, to help make tagsets**

ODS is very flexible and provides PROC TEMPLATE which can be used to
create your own custom tagsets. Then using the MARKUP destination you
can use your tagset to create the required output. This is a hugely
powerful and flexible facility, but often baffles those trying to use
it. One common question is "what events should I define in my tagset?".
Well the developer of the ODS tagset mechanism (Eric Gebhart at SAS) has
provided 2 tagsets that can be used to display the events that occur
when producing some ODS output.

**EVENT_MAP**

creates XML output that shows which events are being triggered and which
variables are used by an event to send output from a SAS process to an
output file. When you run a SAS process with EVENT_MAP, ODS writes XML
markup to an output file that shows all event names and variable names
as tags. The output helps you to create your own tagsets. e.g.

ods markup file=\'test.xml\' tagset=event_map ;

**proc** **print** data=sashelp.class ; **run** ;

ods \_all\_ close ;

dm \"wbrowse \'test.xml\'\" ;

**SHORT_MAP**

creates a subset of the XML output that is created by EVENT_MAP. e.g.

ods markup file=\'test.xml\' tagset=short_map ;

**proc** **print** data=sashelp.class ; **run** ;

ods \_all\_ close ;

dm \"wbrowse \'test.xml\'\" ;

For more information see
[http://support.sas.com/rnd/base/topics/odsmarkup/tagsets.html]{.underline}

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
