Daily Tip 37 19/06/2003 1:27 PM

**Tell me what I have...**

The table below demonstrates how to get SAS to tell you what you have
currently available or defined in your session. For information about
undocumented/unsupported options you can additionally use the *internal*
parameter on Proc Options.

**Information**

**Technique**

Products licensed, expiry dates, site info

Proc Setinit

Librefs defined

Libname \_all\_ list

Filerefs defined

Filename \_all\_ list

Macro variables defined

%put \_all\_ - or \_user\_, \_system\_, \_automatic\_

Options, values and meaning

Proc Options

ODS styles

Proc Template ; list styles ;

SAS/Graph devices

Proc Gdevice nofs ; list \_all\_ ;

SAS/Graph fonts

Proc Catalog cat=sashelp.fonts ; contents ;

**SAS Program**

\* what products are licensed here? What is my site number? When will
SAS expire? ;

**proc** **setinit** ;

**run** ;

\* what librefs are defined? ;

libname \_all\_ list ;

\* what filerefs are defined? ;

filename \_all\_ list ;

\* what macro variables are defined? ;

%put \_all\_ ;

\* what options are set? - including undocumented internal ones ;

**proc** **options** internal ;

**run** ;

\* what ODS styles are available? ;

**proc** **template** ;

list styles ;

**run** ;

\* what SAS/Graph devices are available? ;

**proc** **gdevice** nofs ;

list \_all\_ ;

**run** ;

\* what SAS/Graph software fonts do I have? ;

**proc** **catalog** catalog=sashelp.fonts ;

contents ;

**run** ; **quit** ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
