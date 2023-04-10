Daily Tip 123 23/03/2005 09:51:00

**Editing with Audit Trails**

I recently had a client who made manual edits in SPSS, wrote down what
they had changed and then sent the list of changes to a database
administrator to repeat in the original database. This process is open
to manual errors. We were able to move the SPSS data into SAS via ODBC,
and handle the edits there in a much more robust way.

SAS will let you define an audit trail on any dataset, as shown in the
following code. We then use the VIEWTABLE window to allow the user to
make edits. Additionally I open VIEWTABLE in edit mode on the whole
table, showing variable labels and in form view mode (which fits as many
variables from a record on the screen as possible). You can run the
following code since it uses a standard SAS sample dataset --
sashelp.prdsale.

Once the changes are made we can look at the audit dataset, as show
below. We could even use that audit dataset to connect to another
database and automatically make changes to it -- or generate code to
make those changes.

**SAS Code**

\* make a copy of a dataset to try audit trails on ;

**data** test ;

set sashelp.prdsale ;

**run** ;

\* define an audit trail and start it recording changes ;

**proc** **datasets** lib=work ;

audit test ;

initiate ;

**run** ; **quit** ;

\* Edit the dataset, recording changes to audit dataset ;

dm \'viewtable test;formview;tableaccess;rowlabels;edit\' viewtable ;

\*\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-- Run the following after
finishing the edit, to see the changes made
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--;

**proc** **print** data=test(type=audit) ;

**run** ;

**Output showing changes recorded in audit dataset**

The SAS System 09:51 Wednesday, March 23, 2005 1

Obs ACTUAL PREDICT COUNTRY REGION DIVISION PRODTYPE PRODUCT QUARTER

1 \$220.00 \$585.00 CANADA **EAST** EDUCATION FURNITURE BED 1

2 \$220.00 \$585.00 CANADA **WEST** EDUCATION FURNITURE BED 1

3 \$329.00 \$312.00 CANADA **EAST** EDUCATION FURNITURE BED 2

4 \$329.00 \$312.00 CANADA **NORTH** EDUCATION FURNITURE BED 2

Obs YEAR MONTH \_ATDATETIME\_ \_ATOBSNO\_ \_ATRETURNCODE\_ \_ATUSERID\_
\_ATOPCODE\_ \_ATMESSAGE\_

1 1993 Jan **23MAR2005:09:53:24 1** . **Philip Mason** **DR**

2 1993 Jan **23MAR2005:09:53:24 1** . **Philip Mason** **DW**

3 1993 May **23MAR2005:09:53:30 5** . **Philip Mason** **DR**

4 1993 May **23MAR2005:09:53:30 5** . **Philip Mason** **DW**

Tested under SAS 9.1.2 & Windows XP Professional

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
