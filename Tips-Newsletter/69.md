Daily Tip 69 29/09/2003 6:02 PM

**Make the right sized ActiveX for your resolution**

The program below demonstrates 2 techniques.

Firstly that we can change the size of an **ACTIVEX** control produced
from SAS/Graph & ODS by using the goptions **xpixels** & **ypixels.**

And secondly that we can conveniently store settings for different
screen sizes as macro parameters. We can then call up the desired group
of parameters by simply setting another macro variable to the required
value. In our example we define 2 parameters for each of 4 different
screen sizes, and call up the required one by just using their names.

***SAS Program***

\* Define your preferred settings for various resolutions ;

%let qvga=xpixels=320 ypixels=240 ;

%let vga=xpixels=640 ypixels=480 ;

%let svga=xpixels=800 ypixels=600 ;

%let xga=xpixels=1024 ypixels=768 ;

\* Select the resolution you want to use ;

%let resolution=vga;

ods html file=\'graph.htm\' gpath=\'c:\\\' ;

\* Choose the ACTIVEX driver with the appropriate resolution ;

goptions device=ActiveX &&&resolution ;

**proc** **gchart** data=sashelp.class ;

vbar3d age / subgroup=sex ;

**run** ;

ods html close ;

p.s. I got this information from a posting to SAS-L by my good friend
Mad Doggy -- you can see his web site which has lots of great SAS
material at [www.bassettconsulting.com]{.underline}

Example tested under SAS 8.2, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
