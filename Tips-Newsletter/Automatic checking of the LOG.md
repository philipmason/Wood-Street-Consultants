Daily Tip 77 20/10/2003 11:01 PM

**Automatic checking of the LOG**

Here is a useful technique for times when you have a huge LOG and want
to check to see if it has any error or warning messages. You *could* use
DLGFIND and search for "ERROR", but that would find occurrences of the
word "ERROR" that may not be error messages (e.g. the variable
\_error\_).

This technique copies the log to a catalog member and then checks each
line from it to see if there are any error or warning messages. These
are put into a dataset and then displayed in an HTML report. If there
are no errors or warnings then a message appears to say so.

This can of course be modified to look for other messages or text.

To make this technique really useful you can define a tool on the
toolbar. The command for the tool should be something like this...

sub \'%include \"c:\\demo\\anal.sas\";\'

For more information on customizing toolbars see
v8doc.sas.com/sashtml/win/zomizing.htm#zngetool

***SAS Program***

\*\*\* need to assign this macro call to a button on toolbar

so that pressing the button will analyse the log ;

filename cat catalog \'work.test.test.log\' ;

dm \'log;file cat\' ; \* write log to catalog member ;

ods listing close ;

ods html file=\'analyse.htm\' ;

data analyse ;

length line \$200 ;

label line=\'Line from LOG\'

\_n\_=\'Line number\' ;

infile cat end=end truncover ;

file print ods=(vars=(\_n\_ line)) ;

input line & ;

if substr(line,1,5)=\'ERROR\' then

put \_ods\_ ;

else

if substr(line,1,7)=\'WARNING\' then

put \_ods\_ ;

else

n+1 ;

if end & n=\_n\_ then

do ;

window status rows=15 columns=40 color=gray

#5 \'No errors or warnings were found.\' color=yellow

#9 \'Press enter to continue\' ;

display status ;

end ;

run ;

ods html close ;

filename cat ; \* free catalog member ;

dm \'del work.test.test.log\' results viewer ; \* delete it & show HTML
;

ods listing ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
