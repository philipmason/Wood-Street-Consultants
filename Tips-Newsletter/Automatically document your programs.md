Daily Tip 88 SAVEDATE 16/02/2004 11:18 PM

**Automatically document your programs**

By using some simple coding standards we can use the following program
to automatically document the programs. The macro will take all the text
from the first comment block, delimited by a **/\*** and **\*/**. If you
code all your programs with an initial header in that form, as I have
done so in the macro itself, then you will be able to use this macro to
scan through a directory and automatically extract all those comments.
The macro then creates an RTF document.

***Documentation macro***

/\*\*\*

Program Name : Doc

Date : 5Feb2004

Written By : Phil Mason

Overview : Scans a directory and looks at all SAS code,

stripping out the comments and creating a

MS Word file for documentation

Parms : target \... directory where modules are

located that we wish to document

\*\*\*/

**%macro** doc(target) ;

filename dir pipe \"dir \"\"&target\"\"\" ;

data files(keep=file line) ;

length file line \$ **200**

next \$ **8** ;

label file=\'Filename\'

line=\'Header\' ;

if \_n\_=**1** then

put \'\*\*\* Processing files \*\*\*\' / ;

infile dir missover ;

\* You may need to adjust this depending on the version of the operating
system you are running on -- for my system I am able to read the file
name from a directory listing at column 37 ;

input @**37** file & ;

\* Only continue if the file is a SAS file ;

if index(upcase(file),\'.SAS\')\>**0** ;

put \'\--\> \' file ;

next=\'\' ;

\* Point to that SAS file ;

rc1=filename(next,\"&target\\\"\|\|file) ;

\* Open it up ;

fid=fopen(next) ;

write=**0** ;

\* Read through each line of the SAS file ;

do while(fread(fid)=**0**) ;

line=\' \' ;

rc3=fget(fid,line,**200**) ;

\* if it is the start of a comment block then I will write line ;

if index(line,\'/\*\')\>**0** then

write=**1** ;

if write then

output ;

\* if its end of comment block I will stop writing lines ;

if index(line,\'\*/\')\>**0** then

write=**0** ;

\* we only process comment blocks that start on the first line

\- i.e. headers ;

\* only continue reading lines if I am currently in a comment block ;

if \^write then

leave ;

end ;

\* close file ;

fid=fclose(fid) ;

rc=filename(next) ;

run ;

\* free the file ;

filename dir ;

\* point to an rtf file to create ;

ods rtf file=\'c:\\Documentation.rtf\' ;

title \"Documentation for &target\" ;

data \_null\_ ;

set files ;

by file notsorted ;

file print ods ;

if first.file then

put @**1** file @ ;

put @**2** line ;

run ;

\* close the rtf file ;

ods rtf close ;

**%mend** doc ;

***Sample invocation***

\%*doc*(C:\\Programs)

Example tested under SAS 8.2, Windows XP by Phil Mason

Wood Street Consultants Ltd. HYPERLINK \"mailto:tips@woodstreet.org.uk\"
[tips@woodstreet.org.uk]{.underline}

HYPERLINK \"http://www.woodstreet.org.uk/\"
[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
