%macro catscan(cat,file) ;
  proc build catalog=&cat batch ;
    print source prtfile="&file" ;
  run ;
  dm 'fslist "&file"' fslist ;
%mend catscan ;

%catscan(sashelp.webeis,webeis.txt)
