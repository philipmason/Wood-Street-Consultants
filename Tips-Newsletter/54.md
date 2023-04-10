Daily Tip 54 21/07/2003 8:36 PM

**Useful attributes with ODS in titles & footnotes**

You can use attributes in titles & footnotes from SAS 8 onwards. These
work a bit like those which can be specified in SAS/Graph. These are not
supported by all destinations but do work for RTF & PDF destinations --
possibly more. You can specify things like:

> • BOLD
>
> • COLOR=foreground
>
> • BCOLOR=background
>
> • FONT=font
>
> • HEIGHT=size
>
> • JUSTIFY=just
>
> • LINK=url

**Sample SAS code**

ods rtf file=\'c:\\test.rtf\' ;

Title1 justify=l bold \'Left\'

justify=c h=2 \'Centre\'

f=arial j=right \'Right\' ;

Title2 link=\'www.sas.com\' \'SAS web site\' ;

**proc** **print** data=sashelp.class ;

**run** ;

ods rtf close ;

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
