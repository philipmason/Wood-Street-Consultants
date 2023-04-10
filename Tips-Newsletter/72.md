Daily Tip 72 08/10/2003 5:00 PM

**Getting your IP address & connecting to yourself**

Consider the case where you are developing some code at work which
connects to another machine to run remotely, using SAS/Connect. You may
want to work on this at home, but you are not able to connect to that
machine. You could start another SAS session on your home PC, and use
the same name as your remote machine at work to avoid changing your
code.

The following example demonstrates two useful techniques. Firstly a way
to automatically get the IP address of the machine you are running on.
This works for Windows 2000, and may require some changes for other
systems. Secondly a way to signon to another session on your PC using a
name of your choosing.

> 1\. I use the IPCONFIG command through a pipe so I can read its
> output, which gives me my IP address. I use @'IP Address' to position
> the input pointer at the right place to read the IP address. I define
> all the characters I want to ignore as delimiters using DLM=. I
> finally put the parts of the IP address together and write them to a
> macro variable.
>
> 2\. Now I make sure the SAS spawner program is running. This runs in
> the background and starts a new SAS session when I signon to the
> machine it is running on. As an example, the command I use to invoke
> the spawner is ...\
> **\"C:\\Program Files\\SAS Institute\\SAS\\V8\\spawner.exe\" -comamid
> tcp**\
> Now I assign either my IP address or PC name to a macro variable which
> acts as the remote session id. When I signon using the name of that
> macro variable SAS will use the IP address (or PC name) to identify
> the system to connect to. The spawner then starts another SAS session,
> and I can RSUBMIT code to it.

Starting the PC Spawner Program ...
[http://v8doc.sas.com/sashtml/comm/z0104087.htm]{.underline}

Unnamed pipe syntax ...
[http://v8doc.sas.com/bin/ixcgisol/sashtml/win/zunnamed.htm?query=%22pipe%22&base=http%3A%2F%2Fv8doc.sas.com%2Fsashtml%2Fwin%2Fzunnamed.htm#\~1]{.underline}

***SAS Program***

\*\*\* Part 1 \*\*\*;

filename cmd pipe \'ipconfig\' ;

**data** \_null\_ ;

infile cmd dlm=\'.: \' ;

input @\'IP Address\' n1 n2 n3 n4 **3.** ;

IP_Address=compress(put(n1,**3.**)\|\|\'.\' \|\|put(n2,**3.**)\|\|\'.\'

\|\|put(n3,**3.**)\|\|\'.\' \|\|put(n4,**3.**));

call symput(\'ip\',ip_address) ;

**run** ;

%put My IP address is &ip ;

\*\*\* Part 2 \*\*\*;

%let london=&ip;

/\*%let london=homepc; \* can alternatively use the PC name;\*/

signon london ;

rsubmit london ;

**proc** **setinit** ; **run** ;

endrsubmit ;

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
