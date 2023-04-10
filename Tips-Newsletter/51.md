Daily Tip 51 16/07/2003 10:52 PM

**Accessing the clipboard from SAS**

Here is a technique that you can use if you want to use a SAS program to
access the clipboard when running SAS under windows in display manager
mode. By using this technique you could cut or copy something from one
application and then run your program in SAS to make use of what you cut
or copied.

You can use a very similar technique to put data onto the clipboard, so
that it could then be used by another windows application.

**Getting data from clipboard**

> 1\) Use the DM command to open a SAS notepad window, clear it, paste
> the contents of the clipboard into it, and end (saving contents) ;

dm \'notepad work.temp.temp.source;clear;paste;end\';

> 2\) Read that file in

filename c catalog \'work.temp.temp.source\';

data \_null\_;

infile c;

input;

put \_infile\_;

run;

**Putting data on clipboard**

You can use a similar technique to write data to the clipboard.

filename c catalog \'work.temp.temp.source\';

data \_null\_;

file c;

put \'hello\';

run;

dm \'notepad work.temp.temp.source;curpos 1 1;mark;curpos max
max;store;end\';

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
