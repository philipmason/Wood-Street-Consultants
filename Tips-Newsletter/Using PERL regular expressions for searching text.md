Daily Tip 16 15/05/2003 10:00 AM

**Using PERL regular expressions for searching text**

In SAS 9 there are new functions available for using PERL regular
expressions to search text for sub-strings. There are two parts to using
these, which I demonstrate in the code below.

> 1\. Parse your PERL regular expression using the PRXPARSE function
> (see
> [http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a002295977.htm]{.underline}).
> This returns a pattern-id which can be used in other PERL functions.
>
> 2\. Search using the parsed expression by using the PRXSUBSTR function
> (see
> [http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../lrdict.hlp/a002295971.htm]{.underline}).
> This returns the position & length of the text found, or 0 if none was
> found.

Note: For a useful quick reference on PERL regular expressions see
[http://www.erudil.com/preqr.pdf]{.underline}

***SAS Program***

**data** \_null\_;

if \_N\_=**1** then

do;

retain patternID;

pattern = \"/ave\|avenue\|dr\|drive\|rd\|road/i\";

patternID = prxparse(pattern);

end;

input street \$80.;

call prxsubstr(patternID, street, position, length);

if position \^= **0** then

do;

match = substr(street, position, length);

put match : \$QUOTE. \"found in \" street : \$QUOTE.;

end;

datalines;

153 First Street

6789 64th Ave

4 Moritz Road

7493 Wilkes Place

;

**run** ;

***Lines written to Log***

\"Ave\" found in \"6789 64th Ave\"

\"Road\" found in \"4 Moritz Road\"

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
