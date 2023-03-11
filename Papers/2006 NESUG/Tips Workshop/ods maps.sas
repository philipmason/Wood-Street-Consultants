/* DISCOVERING ODS EVENTS, TO HELP MAKE TAGSETS */

/* EVENT_MAP */

ods markup file='c:\workshop\hw06\test.xml' tagset=event_map ;
proc print data=sashelp.class ; run ;
ods _all_ close ;
dm "wbrowse 'c:\workshop\hw06\test.xml'" ;



/* SHORT_MAP */

ods markup file='c:\workshop\hw06\test.xml' tagset=short_map ;
proc print data=sashelp.class ; run ;
ods _all_ close ;
dm "wbrowse 'c:\workshop\hw06\test.xml'" ;
