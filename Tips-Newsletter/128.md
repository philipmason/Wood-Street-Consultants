Daily Tip 128 SAVEDATE 28/04/2005 14:20:00

**Create datasets which don't show up in file listings**

If you name a SAS dataset starting with "\_to" or "\_tf" then they will
not appear in the following places:

Proc Datasets

Proc contents

Libname window

SAS Explorer window

This can be a useful technique to use if you want to create a "hidden"
dataset -- but beware as using Proc Datasets on one of these files can
produce errors. Read the technical support note for more information ...
HYPERLINK \"http://support.sas.com/techsup/unotes/SN/004/004367.html\"
[http://support.sas.com/techsup/unotes/SN/004/004367.html]{.underline}

**Sample Code**

**data** \_top ;

set sashelp.class ;

**run** ;

Tested under SAS 9.1.3 & Windows XP Professional

Wood Street Consultants Ltd. HYPERLINK \"mailto:tips@woodstreet.org.uk\"
[tips@woodstreet.org.uk]{.underline}

HYPERLINK \"http://www.woodstreet.org.uk\"
[www.woodstreet.org.uk]{.underline}
