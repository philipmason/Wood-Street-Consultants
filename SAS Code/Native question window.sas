filename sascbtbl 'C:\sas\sascbtl.txt';
data _null_;
  length hwnd style 8
         text title $200;
  text="This is message text, which should ask a question?";
  hwnd=0;
  Title ='This is a title';
  style=32+4;
  rc=modulen('*e',"MessageBoxA",hwnd,Text,Title,Style);
  put rc=;
run ;
