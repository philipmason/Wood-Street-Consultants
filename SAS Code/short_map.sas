ods markup file='test.xml' tagset=short_map ;
proc print data=sashelp.class ; run ;
ods _all_ close ;
dm "wbrowse 'test.xml'" ;
