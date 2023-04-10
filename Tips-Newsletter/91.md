Daily Tip 91 14/04/2004 8:48 AM

**Change Control: Setting up multiple environments**

The change control system works by moving code between different
environments in a controlled way. In development a programmer checks out
a module to work on it, and when it is complete the module is checked
back in. There are no fixed rules as to which environments you have,
though you should really have at least a personal development and one
other environment.

***Suggested environments***

The system works best when there are a range of higher level
environments which split sets of code into production/test/development.
You don't need all of these though you do need at least two, for
instance you could just have production & development. I suggest the
following:

> • Production
>
> • Test
>
> • Common Development
>
> • Personal Development
>
> o One for each user
>
> o This is where a user does their own development

You then need directories to split the code into various types. You can
have whichever ones you want, though I suggest that the following are
typically of use.

> • macros
>
> • programs
>
> • formats

***Example***

u:\\mis\\prod\\macros

u:\\mis\\prod\\programs

u:\\mis\\prod\\formats

u:\\mis\\test\\macros

u:\\mis\\test\\programs

u:\\mis\\test\\formats

u:\\mis\\dev\\phil\\macros

u:\\mis\\ dev\\phil\\programs

u:\\mis\\ dev\\phil\\formats

u:\\mis\\dev\\mark\\macros

u:\\mis\\ dev\\mark\\programs

u:\\mis\\ dev\\mark\\formats

u:\\mis\\dev\\hamish\\macros

u:\\mis\\ dev\\hamish\\programs

u:\\mis\\ dev\\hamish\\formats

Control file

The system hinges on use of a control file which is a central location
to keep information about who is using what modules and their status.
When a user tries to check out a module, for example, this file will be
checked to see if that module is locked and if so then user wont be able
to check it out. The user will be able to see who has the module locked
and when it was locked too. The following macro creates this initial
file.

***Makescm macro***

/\*\*\*

Program Name : makescm

Date : jan2004

Written By : Phil Mason

Overview: Makes a Source Control Module (SCM) which is used to store who
has what locked for change control purposes.

Future enhancements: We should check whether the SCM file already exists
before wiping it with a new one.

\*\*\*/

%macro makescm ;

\* CREATE CONTROL DATASET ;

DATA ref.SCM ;

LENGTH FILE \$ 200

LOCKUSER \$ 20

LOCKDATE 8

mt \$ 4 ;

FORMAT LOCKDATE DATEtime. ;

Label FILE=\"File name\"

LOCKUSER=\"Userid who holds the lock\"

LOCKDATE=\"Date/time locked\"

mt=\"Member Type\" ;

delete ;

RUN ;

%mend makescm ;

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
