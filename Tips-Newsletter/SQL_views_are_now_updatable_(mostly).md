Daily Tip 2 Created on Wednesday, 16 April 2003

**SQL views are now updatable (mostly)**

In SAS versions 8 onwards you can update a dataset referenced by an SQL
view, providing the SQL view meets some criteria such as:

> • Only 1 table is referenced
>
> • Table is not joined to another or linked via a set-operator
>
> • There are no sub-queries
>
> • There is no ORDER BY

You can update columns provided they are not derived columns.

See the following for more information -
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../proc.hlp/a000146905.htm#a000330615]{.underline}

***SAS Program***

proc sql ;

create view test as select height/weight as ratio, \* from sashelp.class
;

dm \'vt test\' vt ;

After running this code I can edit TEST using the viewtable window, and
changes are reflected in SASHELP.CLASS.

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
