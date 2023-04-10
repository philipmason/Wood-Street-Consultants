Daily Tip 47 03/07/2003 5:03 PM

**\_method on Proc SQL**

Using the undocumented *\_method* parameter on PROC SQL will provide a
"query plan" which describes what methods Proc SQL plans to use to
execute the query. Combining this with *options msglevel=I* is useful,
since that gives information about when indexes are used for joins or
where processing in SQL.

**SAS Log**

30 proc sql \_method ;

31 select retail.\*

32 from sashelp.retail

33 left join

34 sashelp.prdsale

35 on retail.year=prdsale.year

36 order by retail.year ;

NOTE: SQL execution methods chosen are:

sqxslct

sqxjm

sqxsort

sqxsrc( SASHELP.PRDSALE )

sqxsort

sqxsrc( SASHELP.RETAIL )

**SQL module codes used**

The following list shows some of the SQL module codes that are used in
listings produced by using *\_method*.

sqxcrta Create table as Select

sqxslct Select

sqxjsl Step Loop Join (Cartesian)

sqxjm Merge Join

sqxjndx Index Join

sqxjhsh Hash Join

sqxsort Sort

sqxsrc Source Rows from table

sqxfil Filter Rows

sqxsumg Summary Statistics (with GROUP BY)

sqxsumn Summary Statistics (not grouped)

sqxuniq Distinct rows only

For more information see the excellent reference by Paul Kent *"TS-553:
SQL Joins \-- The Long and The Short of It"* at
[http://support.sas.com/techsup/technote/ts553.txt]{.underline}

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
