/* set the default size of memory to use for sorting            */
-sortsize 2m

/* set catalog cache                                            */
-catcache 0

/* set the default fileref for the PARMCARDS= option            */
-SET FT15F001  'FT15F001.DAT'

/* Set the type of help to use                                  */
-helpenv WIN

/* Setup the default SAS System user profile directory          */
-SASUSER !SASFOLDER\sasuser\ 

/* Setup the default SAS System user work directory             */
-WORK !SASFOLDER\SASWORK\  

/*---------------------------------------------------------------\
| SAS System FORMCHARS, used by pressing ALT then the decimal    |
| number for the Extended ASCII character.                       |
\---------------------------------------------------------------*/



/* This is the OEM character  set                               */
/* -FORMCHAR ³ÄÚÂ¿ÃÅ´ÀÁÙ+=|-/\<>*                              */

/* This is the ANSI character  set (for SAS Monospace font and ANSI Sasfont) */
-FORMCHAR ‚ƒ„…†‡ˆ‰Š‹Œ+=|-/\<>*

/* This is the ANSI character  set                              */
/* -FORMCHAR |----|+|---+=|-/\<>*                              */

-WINCHARSET ANSI


/*---------------------------------------------------------------\
| WARNING:  INSTALL Application edits below this line.  User     |
|           options should be added above this box comment.      |
|           INSTALL Application maintains and modifies the       |
|           following options; -SASAUTOS, -SASHELP, -SASMSG,     |
|           -PATH, and -MAPS.  It also maintains and modifies    |
|           the following CONFIG variables with the -SET option; |
|           INSTALL, USAGE, LIBRARY, SAMPSIO, SAMPSRC, SASCBT,   |
|           and SASEXT01-SASEXT50.  It preserves all lines above |
|           the line containing 'DO NOT EDIT BELOW THIS LINE'.   |
\---------------------------------------------------------------*/

-SET GDEVICE0 "C:\SAS\sasuser"
-SET GFONT0 "C:\SAS\sasuser"
/* DO NOT EDIT BELOW THIS LINE - INSTALL Application edits below this line */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

-SET sasext0 C:\SAS

-SET sasroot C:\SAS

-SET SASFOLDER "C:\SAS"

/* SAS/CONNECT Software script files                            */
-SASSCRIPT !sasext0\connect\saslink

/* Setup the path for the SAS system dll files */
-PATHDLL !sasroot\core\sasdll

/* location of help    in OS help format */
-HELPLOC !sasroot\core\winhelp

/* location of samples in OS help format */
-SAMPLOC !sasroot\core\sassamp

/* set the default site information file                        */
-SITEINFO !sasroot\core\sasinst\siteinfo.txt

/* SAS/EIS Software image files                                 */
-SET EISIMAGE !sasext0\eis\sasmisc

/* graph/maps */
-MAPS !sasext0\maps

/* Location of Tech Support Help */
-HELPREGISTER 'Tech Support' '!sasext0\usage\techsup\techhlp.hlp'

/* Setup the SAS System autocall library definition */
-SET SASAUTOS  (
                !sasext0\af\sasmacro
                !sasext0\assist\sasmacro
                !sasext0\base\sasmacro
                !sasext0\connect\sasmacro
                !sasroot\core\sasmacro
                !sasext0\access\sasmacro
                !sasext0\eis\sasmacro
                !sasext0\ets\sasmacro
                !sasext0\fsp\sasmacro
                !sasext0\gis\sasmacro
                !sasext0\graph\sasmacro
                !sasext0\insight\sasmacro
                !sasext0\maps\sasmacro
                !sasext0\mddbserv\sasmacro
                !sasext0\reinstal\sasmacro
                !sasext0\usage\sasmacro
                !sasext0\whouse\sasmacro
               )

/* Setup the SAS System help directory definition */
-SASHELP       (
                !SASFOLDER\SASCFG
                !sasext0\af\sashelp
                !sasext0\assist\sashelp
                !sasext0\base\sashelp
                !sasext0\connect\sashelp
                !sasroot\core\sashelp
                !sasext0\access\sashelp
                !sasext0\eis\sashelp
                !sasext0\ets\sashelp
                !sasext0\fsp\sashelp
                !sasext0\gis\sashelp
                !sasext0\graph\sashelp
                !sasext0\insight\sashelp
                !sasext0\maps\sashelp
                !sasext0\mddbserv\sashelp
                !sasext0\reinstal\sashelp
                !sasext0\usage\sashelp
                !sasext0\whouse\sashelp
               )

/* Setup the SAS System message directory definition */
-SASMSG        (
                !sasext0\af\sasmsg
                !sasext0\assist\sasmsg
                !sasext0\base\sasmsg
                !sasext0\connect\sasmsg
                !sasroot\core\sasmsg
                !sasext0\access\sasmsg
                !sasext0\eis\sasmsg
                !sasext0\ets\sasmsg
                !sasext0\fsp\sasmsg
                !sasext0\gis\sasmsg
                !sasext0\graph\sasmsg
                !sasext0\insight\sasmsg
                !sasext0\maps\sasmsg
                !sasext0\mddbserv\sasmsg
                !sasext0\reinstal\sasmsg
                !sasext0\usage\sasmsg
                !sasext0\whouse\sasmsg
               )

/* Setup the SAS System sample cat directory definition */
-SET SAMPSIO   (
                !sasext0\af\sample
                !sasext0\assist\sample
                !sasext0\base\sample
                !sasext0\connect\sample
                !sasroot\core\sample
                !sasext0\access\sample
                !sasext0\eis\sample
                !sasext0\ets\sample
                !sasext0\fsp\sample
                !sasext0\gis\sample
                !sasext0\graph\sample
                !sasext0\insight\sample
                !sasext0\maps\sample
                !sasext0\mddbserv\sample
                !sasext0\reinstal\sample
                !sasext0\usage\sample
                !sasext0\whouse\sample
               )

/* Setup the SAS System sample src directory definition */
-SET SAMPSRC   (
                !sasext0\af\sample
                !sasext0\assist\sample
                !sasext0\base\sample
                !sasext0\connect\sample
                !sasroot\core\sample
                !sasext0\access\sample
                !sasext0\eis\sample
                !sasext0\ets\sample
                !sasext0\fsp\sample
                !sasext0\gis\sample
                !sasext0\graph\sample
                !sasext0\insight\sample
                !sasext0\maps\sample
                !sasext0\mddbserv\sample
                !sasext0\reinstal\sample
                !sasext0\usage\sample
                !sasext0\whouse\sample
               )

/* Setup the SAS System teststream directory definition */
-SET INSTALL   (
                !sasext0\af\sastest
                !sasext0\assist\sastest
                !sasext0\base\sastest
                !sasext0\connect\sastest
                !sasroot\core\sastest
                !sasext0\access\sastest
                !sasext0\eis\sastest
                !sasext0\ets\sastest
                !sasext0\fsp\sastest
                !sasext0\gis\sastest
                !sasext0\graph\sastest
                !sasext0\insight\sastest
                !sasext0\maps\sastest
                !sasext0\mddbserv\sastest
                !sasext0\reinstal\sastest
                !sasext0\usage\sastest
                !sasext0\whouse\sastest
               )

/* Setup the SAS System load image search paths definition */
-PATH          (
                !sasext0\af\sasexe
                !sasext0\assist\sasexe
                !sasext0\base\sasexe
                !sasext0\connect\sasexe
                !sasroot\core\sasexe
                !sasext0\access\sasexe
                !sasext0\eis\sasexe
                !sasext0\ets\sasexe
                !sasext0\fsp\sasexe
                !sasext0\gis\sasexe
                !sasext0\graph\sasexe
                !sasext0\insight\sasexe
                !sasext0\maps\sasexe
                !sasext0\mddbserv\sasexe
                !sasext0\reinstal\sasexe
                !sasext0\usage\sasexe
                !sasext0\whouse\sasexe
               )

