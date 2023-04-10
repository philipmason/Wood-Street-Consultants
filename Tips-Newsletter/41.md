Daily Tip 41 25/06/2003 5:11 PM

**Interesting options on the FILE statement**

The FILE statement has a multitude of options available. Here are some
of the more interesting ones that you may find useful.

*Statement*

*Explanation*

Column=var

sets var to current column number

Delimiter=','\|var

sets delimiter to a character (e.g. comma) or variable value

Dropover

drop data too long for line

Dsd

write data items with delimiters

Filename=var

var is set to physical file name in use

Filevar=var

var determines the physical file to be written to

Flowover

anything that doesn't fit on this line is written to the next

\[no\]footnotes

prints footnotes

Header=label

run statements at label for each new page

Line=var

contains current logical line number

Linesize=

columns per line

Linesleft=var

contains lines left on page

Mod

write after whatever is in file

Ods=

Defines ODS sub-options (see later)

Old

wipes file before writing

Pagesize=

lines per page

Stopover

stops data step if trying to write beyond end of line

\[no\]titles

prints titles

\_file\_=var

contains current output buffer and is Read/Write

For more information on FILE see
[http://v8doc.sas.com/sashtml/lgref/z0171874.htm]{.underline}

> **Note 1:** There was an error in SASTip40. As the SAS documentation
> says "In the PUT statement, trailing @ and double trailing @@ produce
> the same effect." -- sorry for the error.
>
> **Note 2:** There is a fantastic new web site from Lex Jansen which
> indexes the SUGI proceedings in a most useful way. Take a look and
> learn from the massive archive of SAS knowledge.
> [http://www.lex-jansen.demon.nl/sugi/]{.underline}

This tip is based on SAS 8.2 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
