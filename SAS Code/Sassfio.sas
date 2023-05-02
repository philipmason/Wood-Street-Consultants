* Must use: SASSFIO engine & physical file name ;
libname test sassfio 'c:\sas\eis\sashelp\prdmddb.sm2' ;

proc print data=test.nway(obs=10) ;
run ;
