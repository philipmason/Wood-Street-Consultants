Daily Tip 90 12/03/2004 8:12 AM

**Make your own Change Control System**

For some years now I have been developing & using a change control
system I developed with various clients, and I thought I would share it
with you now. I will outline various parts of it over the next few
newsletters and by the end of the series you should have a system that
you can customise & use with little effort. I will also try to draw out
and emphasise some of the interesting techniques used in it. I hope it
proves useful.

***Advantages***

Why use change control? Where there are more than 1 person developing
SAS code a change control system will do the following:

> • Allows team of people to share code and develop in same areas
> without overwriting other peoples code by mistake
>
> • Automatically maintains multiple backups enabling backing out
> changes
>
> • Automatically maintains version numbers of software
>
> • Supports developing code that runs on multiple operating systems
>
> • Enables people to see who is working on what modules at any time
>
> • Facilitates best practice for software development through use of
> production/test/development environments, controlled software
> promotion, module and application level backups, etc.

***Outline***

The change control system work on modules, which can be SAS programs,
SAS macros, SAS catalog members or other file types. Locks are held in a
SAS dataset. Directories are setup in a specific way so that production
code is in one place, test in another and development in another.

The core of the change control system consists of 4 macros:

> • CO -- checks out a module, and "locks" it so no one else can change
> it
>
> • CI -- checks in a module and removes the "lock" so others can change
> it
>
> • UNLOCK -- removes a "lock"
>
> • PROMOTE -- moves a module into production

There are separate icons for starting SAS in development, test &
production. Each has a custom SAS configuration file and custom autoexec
to define macro variables and allocate librefs/filerefs needed for the
system. In development we have a personal development environment and a
shared development environment, so that code is checked out from the
shared environment, modified by a programmer in their own environment
and then checked back in.

***What will be covered***

Tip 91 -- Change Control: Setting up multiple environments

Tip 92 -- Change Control: Using configuration files

Tip 93 -- Change Control: Using autoexec files

Tip 94 -- Change Control: Checking out modules

Tip 95 -- Change Control: Checking in modules

Tip 96 -- Change Control: Promoting modules to production

Tip 97 -- Change Control: Unlock, Query, Increment & other macros

Tip 98 -- Change Control: Developing code in a client/server environment
(Windows & UNIX)

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
