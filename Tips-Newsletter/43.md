Daily Tip 43 30/06/2003 10:32 PM

**Reading the next value of a variable**

When reading a dataset in the data step you can use the LAG() function
to read previous values of a variable. That's handy, but what if you
would also like to look ahead and read the next value(s)? Well you can
do this by reading the same dataset again, only starting at a later
record.

For example, if you wanted to read the next value of name from a
dataset, then we would use a *SET* to read the dataset as usual, but
then we would use another *SET* to read the dataset starting at the
2^nd^ record. So as to not overwrite other variables we also just keep
the variable we are interested in, and rename it to something that makes
its meaning clear (*next_name*). The following *SAS Log* shows some code
that does this and you can see that it has worked by looking at the
values it wrote out.

Of course if you wanted to also read the next observation at the same
time, then you could just add another *SET* statement starting at record
3 and renaming the variable to something like *next_name2*.

**SAS Log**

1 data name ;

2 set sashelp.class ; \* read this record ;

3 set sashelp.class(firstobs=2

4 keep=name

5 rename=(name=next_name)) ; \* just read one variable from the next
record ;

6 put \_n\_ name= next_name= ;

7 run ;

1 Name=Alfred next_name=Alice

2 Name=Alice next_name=Barbara

3 Name=Barbara next_name=Carol

4 Name=Carol next_name=Henry

5 Name=Henry next_name=James

6 Name=James next_name=Jane

7 Name=Jane next_name=Janet

8 Name=Janet next_name=Jeffrey

9 Name=Jeffrey next_name=John

10 Name=John next_name=Joyce

11 Name=Joyce next_name=Judy

12 Name=Judy next_name=Louise

13 Name=Louise next_name=Mary

14 Name=Mary next_name=Philip

15 Name=Philip next_name=Robert

16 Name=Robert next_name=Ronald

17 Name=Ronald next_name=Thomas

18 Name=Thomas next_name=William

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: There were 18 observations read from the data set SASHELP.CLASS.

NOTE: The data set WORK.NAME has 18 observations and 6 variables.

NOTE: DATA statement used:

real time 0.35 seconds

cpu time 0.05 seconds

*Please feel free to pass this tip to your colleagues, and encourage
them to subscribe by sending an email to
[tips@woodstreet.org.uk]{.underline}*

*Example tested under SAS 8., Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
