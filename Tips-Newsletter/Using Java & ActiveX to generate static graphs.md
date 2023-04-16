Daily Tip 84 27/11/2003 11:01 PM

**Using Java & ActiveX to generate static graphs**

In SAS 9 there are 2 new graphic devices that can be used to create
graphs called *actximg* & *javaimg*. These produce very good looking
graphics but are not interactive graphics, as their siblings are
(*ActiveX* & *Java*). The files produced are actually in PNG format and
by default will be 640x480 pixels (VGA). Try them out and see how easy
it is to produce excellent looking output. The graph produced below was
only 5.6kb in size.

***Sample code***

goptions device=actximg ;

/\*goptions device=javaimg ;\*/

ods html body=\'c:\\test.html\'

gpath=\'c:\\\'

(url=none) ;

**proc** **gchart** data=sashelp.shoes ;

vbar3d product / sumvar=sales ;

**run** ;

ods html close ;

***Graph produced using ActXimg***

Example tested under SAS 9.1, Windows XP by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
