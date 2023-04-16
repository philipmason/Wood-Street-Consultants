Daily Tip 59 07/08/2003 7:03 AM

**Autosaving your SAS code**

You can set SAS to automatically save your code regularly, which means
if your system, or SAS, crashes then you can retrieve the last saved
version of your code. Autosave is set using
Tools-Options-Preferences-Edit_tab. Set it to autosave every x minutes.

Autosaved code is saved to the users TEMP directory (see the TEMP
environment variable). e.g. C:\\Documents and Settings\\masonp\\Local
Settings\\Temp

If a SAS program is loaded in, autosave does not save over it. I loaded
a SAS program called \"gdevice2.sas\" into the editor. It was autosaved
into my temp directory as \"Autosave of Gdevice2.\$AS\".

If you exit the SAS session and say you don\'t want to save the modified
code, then the autosave is discarded. If SAS stops before you can do so,
then the autosaved file is kept. It is not automatically loaded back
into SAS when SAS is restarted though. We could probably write a macro
to do this if we wanted to.

*Example tested under SAS 8.2, Windows 2000* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmason
