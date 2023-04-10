Daily Tip 99 14/04/2004 8:25 AM

**Generation Data Sets**

A generation data set is a historical copy of a dataset. The generation
dataset feature allows keeping multiple copies of datasets by defining a
maximum number to keep. They are supported from SAS 7.

To define the number of generations to keep you can use the *genmax=*
dataset option.

**Example SAS Program**

\* keep multiple copies of data sets ;

**data** x(genmax=**5**) ; a=**1** ; **run** ;

\* each time we create the dataset again it makes another generation ;

**data** x ; a=**2** ; **run** ;

**data** x ; a=**3** ; **run** ;

**data** x ; a=**4** ; **run** ;

\* current generation is 0, or just dont specify the one you want ;

**data** y ; set x(gennum=**0**) ; put a= ; **run** ;

\* generation 2 is the 2nd one created - actually called x#002 ;

**data** y ; set x(gennum=**2**) ; put a= ; **run** ;

\* generation -1 is the previous one created, not the current one bu the
one before ;

**data** y ; set x(gennum=-**1**) ; put a= ; **run** ;

*Example tested under SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
