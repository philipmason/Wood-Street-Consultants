Daily Tip 11 01/05/2003 5:53 PM

**Use wildcards in variable lists**

You can use the colon as a variable modifier (e.g. abc:), which acts as
a wildcard. So rather than entering variables abc1, abc3 & abcde you
could just specify abc:. It is great for saving typing long variable
lists & making your code more generic. However the colon must be at the
end, it can't be embedded (e.g. ab:c).

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrcon.hlp/a000695105.htm]{.underline}

***SAS Program***

**data** test ;

ab=**1** ; abc=**2** ; ab123=**3** ;

x=**1** ; y=**2** ; z=**3** ;

**run** ;

**proc** **print** data=test ;

var ab: ;

**run** ;

***Output***

The SAS System 17:56 Thursday, May 1, 2003 1

Obs ab abc ab123

1 1 2 3

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
