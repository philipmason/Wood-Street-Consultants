Daily Tip 107 27/09/2004 12:13:00

**Using SAS 8.2 from SAS 9 in an IOM architecture**

For those of you that are using SAS 9 but wish to run code in SAS 8.2,
then this may be of interest if you are also getting into the server
architecture of IOM (Integrated Object Model). If so, read on\...

To define a SAS 8.2 server follow these steps (thanks to SAS UK tech
support for the information)\...

> 1\) Copy the objectspawner directory into a new directory under Lev1
> called V8SASMain
>
> 2\) Open the objectspawner.bat file and change the spwnname to
> \"V8SASMain -- Spawner\" and change the SASServiceName to \"SAS Lev1
> V8OB\". You also need to change all the saslogfile entries to point to
> the new \"V8SASMain\\objectspawner\\logs\" directory.
>
> 3\) Copy from the SASMain directory the sas.bat, sas_internal.bat &
> sasv9.cfg files, into the V8SASMain directory
>
> 4\) Rename sasv9.cfg to sasv8.cfg and eliminate all code except the
> following lines, which can be created from existing lines or just
> added/customised

-config \"C:\\Program Files\\SAS institute\\sas\\v8\\sasv8.cfg\"

-sasinitialfolder \"c:\\SAS\\9.1\\Lev1\\SASMain\"

-set library (\"SASEnvironment/sasFormats\")

-sasautos (\"SASEnvironment/sasMacro\" SASAUTOS)

> 5\) Edit sas_internal.bat so that it points to the v8 SASROOT and the
> config file points to the one copied in step 4.
>
> 6\) Start the SMC.
>
> 7\) Go to the Server manager plugin and select new server.
>
> 8\) Choose new SAS Application Server.
>
> 9\) Call it V8SASMain.
>
> 10\) Select to create a workspace server.
>
> 11\) Select the host and port (e.g. 7591). If a workspace server has
> already been configured on the v8 machine then ensure it runs on a
> free port
>
> 12\) Go back to the Server manager and select new Server.
>
> 13\) Choose to create a new object spawner definition.
>
> 14\) Call it \"V8SASMain -- Spawner\"
>
> 15\) Again ensure that it runs on a free port (e.g. 7581) if an object
> spawner is already configured on this machine
>
> 16\) Choose to have this spawner control the V8SASMain workspace
> server.
>
> 17\) Cd to \"C:\\SAS\\9.1\\Lev1\\V8SASMain\\ObjectSpawner\" in dos.
> You may have a different directory prefix to this.
>
> 18\) Install the V8 objectspawner using this command --

\"c:\\SAS\\9.1\\Lev1\\SASMain\\ObjectSpawner\\ObjectSpawner.BAT\"
/install

> 19\) Start the v8 Objectspawner by running \"StartObjectSpawner.bat\"
>
> 20\) If it installs correctly test the connection via the SMC using an
> account with the log on as batch job right granted on the workspace
> server.

You are finished and now have a SAS 8.2 server defined in your metadata,
which can be selected from Enterprise Guide and elsewhere throughout SAS
9.

*Example tested under SAS 9.1.2 & SAS 8.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
