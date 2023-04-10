Daily Tip 10 30/04/2003 1:51 PM

**Animated GIFs**

SAS/Graph allows us to create animated GIF files. These files can
contain a number of graphs in the one file. When displayed through an
application which supports them, we can see the graphs one by one. We
can also define whether the sequence repeats and how long between each
image.

For some nice examples of animated GIFs & the code to produce them -
[http://support.sas.com/rnd/samples/graph/gifanimoverview.html]{.underline}

***SAS Program***

filename anim \'c:\\anim.gif\' ; /\* file to create \*/

goptions device=gifanim /\* animated GIF driver \*/

gsfname=anim /\* fileref to save file to \*/

delay=**100** /\* 1/100s of a second between each image \*/

gsfmode=replace /\* wipe over previous file \*/

disposal=background ; /\* when graph is erased background color returns
\*/

**proc** **gchart** data=sashelp.prdsale ;

vbar3d prodtype ;

**run** ;

goptions gsfmode=append ; /\* append the next graph to existing image
\*/

**proc** **gplot** data=sashelp.class ;

plot height\*weight ;

**run** ;

goptions gepilog=\'3b\'x; /\* write end-of-file character after next
graph \*/

**proc** **gchart** data=sashelp.prdsale ;

hbar3d country ;

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
