Daily Tip 89 26/02/2004 6:19 PM

**Run SAS easily in batch on windows**

Running SAS in batch is handy, since you can have a number of programs
running in the background while you do other things on your PC. You can
also schedule SAS programs to run when you are not at your PC, making
use of the hours you are not at work for doing time consuming runs.

When running SAS under windows you will have a range of actions
associated with SAS programs in the Windows Explorer by default. These
can be selected by right clicking on a SAS program in the windows
explorer. With SAS 8.2 the actions include:

> • Open
>
> • Batch Submit
>
> • Open with SAS
>
> • Print
>
> • Print with SAS
>
> • Submit

When you select one of these a command is run passing the filename as a
parameter to that command. To see these commands from Windows Explorer
do the following:

> 1\. Select Tools from the pull down menu
>
> 2\. Select Folder options
>
> 3\. Select the File Types tab
>
> 4\. Scroll down the list to SAS
>
> 5\. Click on the advanced button -- if you don't have it, then you
> need to click on the restore button to remove your customisation
>
> 6\. Now you have a list of actions which appear when you right mouse
> click. You can choose a default action, add new actions and edit
> existing actions.
>
> 7\. Select Batch Submit, and click on Edit
>
> 8\. You can now see the command used to invoke SAS in batch in the
> field called "Application used to perform action"
>
> 9\. The part of the command that has "%1" has the filename that you
> clicked on substituted before the command is run.
>
> 10\. You can now change the command to use a customised one, if you
> wish. The command that I use uses my own configuration file so that I
> can use my own autoexec to allocate libraries I need. On my system the
> command is as follows:
>
> C:\\PROGRA\~1\\SASINS\~1\\SAS\\V8\\SAS.EXE \"%1\" -nologo -config
> h:\\mysasf\~1\\v8\\batch.CFG -noaltlog

Note: when parts of a pathname are longer than 8 characters we use the
first 6 followed by a tilde (\~) and number (1 for first occurrence, 2
for second).

Example tested under SAS 8.2, Windows XP Professional by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
