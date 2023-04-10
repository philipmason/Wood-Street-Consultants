Daily Tip 108 27/09/2004 16:25:00

**Copy part of SAS log to a dataset, via clipboard**

This code builds on a previous tip which showed how to copy a section of
the SAS log to a text file. This method copies the required section of
the SAS log to the clipboard, as before, but then reads from the
clipboard and saves the log into a dataset. This can be very useful if
you want to capture specific parts of the log and save them away. This
is particularly useful if you want to save them away to another kind of
database, such as Oracle, since you can simply use a libname engine to
write the data from the log to the required database.

Reading and writing to the clipboard is a new feature of SAS 9.

**%macro** ClipLog2dset(marker1,marker2,pos=last,dset=log) ;

\* note: split search text in half so we dont go and find it in our
macro call ;

options nomprint noxwait xsync ;

dm \"log;find \'&marker1&marker2\' &pos;mark;bottom;mark;store;unmark\"
;

\* read from the clipboard ;

filename in CLIPBRD ;

data &dset ;

length line \$ **200** ; \* make sure its at least as long as log lines
;

infile in ;

input ;

line=\_infile\_ ; \* save lines to a variable called line ;

run ;

**%mend** ClipLog2dset ;

*Example tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
