* don’t wait for command to finish or synchronize with rest of SAS ;
options noxwait noxsync ;
* start MS Word and minimize it ;
/*x "start /min C:\Program Files\Microsoft Office\Office10\winword.exe" ;*/
x "start /min C:\Progra~1\Micros~3\Office10\winword.exe" ;
You can specify the real path to the file, provided you enclose the long file names in double quotes, and enclose the whole thing in single quotes. The code below works.
 
x '"C:\Program Files\Microsoft Office\Office10\winword.exe"' ;
