Daily Tip 5 Created on 23/04/2003

**Using Integrity Constraints**

Integrity Constraints are new to version 8 of SAS. They allow you to
define rules which determine what values variables may take on a
dataset.

There are 4 types of general Integrity Constraints, which can be defined
for each variable in a dataset:

> 1\. Check - uses a where clause to check for particular values
>
> 2\. Not null -- will not allow null value
>
> 3\. Unique -- value must be unique on dataset
>
> 4\. Primary key -- must be unique & not null, only 1 of these per
> dataset

A referential Integrity Constraint connects a variable in one dataset
with a primary key in another. Actions are then defined which determine
if a value can be changed or what happens when a value is changed. There
are 3 types of referential actions that can occur:

> 1\. Restrict -- if there is a matching foreign key value then primary
> key can't be changed
>
> 2\. Set null -- if primary key is changed or deleted then foreign key
> is set to null
>
> 3\. Cascade -- if primary key is changed or deleted then foreign key
> is also changed

Note: Some procedures preserve integrity constraints and some destroy
them. A sort that creates a new data set will not preserve any integrity
constraints or indexes.

***Creating some ICs using Proc Datasets***

**data** people ;

length sex \$ **1**

name \$ **32**

serial **8** ;

delete ;

**run** ;

**data** classes ;

length serial **8**

class \$ **32** ;

delete ;

**run** ;

**proc** **datasets** ;

modify people ;

ic create null_name=not null(name) ;

ic create check_sex=check(where=(sex in (\'M\',\'F\'))) ;

ic create one_ser=unique(serial) ;

ic create prim=primary key(serial) ;

modify classes ;

ic create null_class=not null(class) ;

ic create for_key=foreign key(serial)

references people

on delete set null

on update cascade ;

**run** ; **quit** ;

***Creating some ICs using Proc SQL***

proc sql;

create table people

(

name char(14),

gender char(1),

hired num,

jobtype char(1) not null,

status char(10),

constraint prim_key primary key(name),

constraint gender check(gender in (\'male\' \'female\')),

constraint status check(status in (\'permanent\'

\'temporary\' \'terminated\'))

);

create table salary

(

name char(14),

salary num not null,

bonus num,

constraint for_key foreign key(name) references people

on delete restrict on update set null

);

quit;

See the following for more information:

> • Understanding ICs -
> [http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/lrcon.hlp/a000403555.htm&query=integrity]{.underline}
>
> • Using PROC Datasets to create integrity constraints -
> [http://v9doc.sas.com/cgi-bin/sasdoc/cgigdoc?file=../proc.hlp/a000247691.htm]{.underline}
>
> • Using SQL to create ICs -
> [http://v9doc.sas.com/cgi-bin/sasdoc/cgihilt?file=/help/proc.hlp/a002294522.htm&query=integrity#\~]{.underline}

*Example tested under SAS 9.0, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
