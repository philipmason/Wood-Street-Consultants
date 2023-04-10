Daily Tip 92 12/03/2004 8:12 AM

**Change Control: Using configuration files**

The configuration file is used when SAS starts and defines things such
as: location of work library, macro autocall libraries, sasuser library,
etc. Some options can only be set in the configuration file or on the
command line, others can be set in autoexec or from a SAS program also.

***Default config file***

It's located in the following places:

> • Windows SAS 8.2 -- usually in C:\\Program Files\\SAS
> Institute\\SAS\\V8\\Sasv8.cfg
>
> • Windows 9.1 -- usually in C:\\Program Files\\SAS\\SAS 9.1\\SASV9.CFG

You can specify your own location for it though by using the --CONFIG
parameter when invoking SAS

***Useful modifications to make***

> • Many options can be set, the documentation will tell you which ones
> work in the configuration files
>
> • You can change the location of the autoexec file by using the
> --autoexec option.
>
> • You can set environment variables using --set, which can then be
> accessed in the config file or using %sysget() from data step
>
> • Set various options to enhance performance such as SORTSIZE &
> MEMSIZE.

***Use of config file in Change Control System***

I set the following in the config file:

> • Location of autoexec file
>
> • Definition of some environment variables defining
>
> o Root directory for all source code
>
> o Path suffix for current environment & next one up

***Starting SAS to use the custom autoexec & configuration files***

SAS can be started in various ways (from windows):

> • SAS icon or shortcut
>
> • Command line using Run window
>
> • Double clicking on SAS.exe icon
>
> • Right clicking on sas.exe and selecting an option

Typical SAS command line to use a config file

> • \"C:\\Program Files\\SAS Institute\\SAS\\V8\\sas.exe\" -config
> \"d:\\MIS.cfg\"

Typical SAS command line to use a config file & autoexec

> • \"C:\\Program Files\\SAS Institute\\SAS\\V8\\sas.exe\" -config
> \"d:\\MIS.cfg\" -autoexec \"d:\\MIS.sas\"

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline} Windows Messenger -
philipandrewmason@hotmail.com
