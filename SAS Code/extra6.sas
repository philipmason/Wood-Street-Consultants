* Define your preferred settings for various resolutions ;
%let qvga=xpixels=320 ypixels=240 ;
%let vga=xpixels=640  ypixels=480 ;
%let svga=xpixels=800 ypixels=600 ;
%let xga=xpixels=1024 ypixels=768 ;
* Select the resolution you want to use ;
%let resolution=vga;
ods html file='graph.htm' gpath='c:\' ;
* Choose the ACTIVEX driver with the appropriate resolution ;
goptions device=ActiveX &&&resolution ;
proc gchart data=sashelp.class ;
  vbar3d age / subgroup=sex ;
run ;
ods html close ;