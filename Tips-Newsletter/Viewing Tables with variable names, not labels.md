Daily Tip 103 25/06/2004 10:15 AM

**Viewing Tables with variable names, not labels**

Many people make use of the viewtable command in SAS, which can be used
in different ways, for example

1 -- from the command line "viewtable sashelp.class"

2 -- abbreviated from the command line "vt sashelp.class"

3 -- from the explorer window by double clicking on a dataset, or view

4 -- from the explorer window by right clicking on a dataset or view,
and then selecting open

By default when you view the table, you will see variable labels over
each column. I know that this annoys some people and they would like to
have variable names appear by default, so here is how to do it.

> 1\. click on the explorer window to activate it -- making the context
> sensitive menus appropriate for it
>
> 2\. Select tools/options/explorer
>
> 3\. double click on "table" (or "view", depending which you are
> changing)
>
> 4\. double click on "&Open"
>
> 5\. Now you can see the command that is issued when you double click
> on a table in the explorer window, it is probably "VIEWTABLE
> %8b.\'%s\'.DATA"
>
> 6\. Now add the following optional parameter to the end of this
> command ... "colheading=names". This makes the command now "VIEWTABLE
> %8b.\'%s\'.DATA colheading=names"
>
> 7\. Exit the dialog boxes via OK, and you are finished.

If you wanted to open the table in form view, rather than table view
then you could also add this ... "view=form". As far as I know these
options are not documented anywhere.

> • Colheading can be either names or labels.
>
> • View can be either form or table.

I haven't found any good documentation that I can refer you to on this
command. The following reference in SAS 9 documentation should go to doc
on viewtable, but leads to a dead end.
[http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../fsp.hlp/vtmain_1.htm#a000009106]{.underline}

*Example tested under SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
