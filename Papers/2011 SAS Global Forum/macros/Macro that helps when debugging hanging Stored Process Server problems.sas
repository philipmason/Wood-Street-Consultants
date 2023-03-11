 * support.sas.com <http://support.sas.com> > Technical Support
</techsup/intro.html> *

	 

Technical Support 	SAS - The power to know(tm)
<http://corpprod.unx.sas.com/SASHome.html>

  TS Home </techsup/intro.html> | Intro to Services
</techsup/service_intro.html> | News and Info </techsup/news/index.html>
| Contact TS </techsup/contact/index.html> | Site Map
</techsup/sitemap.html> | FAQ </techsup/faq/> | Feedback
</techsup/feedback/feedback.html> 	</techsup/search/index.html> 	

SAS Notes 	*SN-V9-019573*
* Macro that helps when debugging "hanging" Stored Process Server problems *

------------------------------------------------------------------------


   If you have a Stored Process that occasionally "hangs" while executing
   and does not produce a SAS log, the "%stp_capture_log" macro should
   be helpful.  This macro reroutes and saves the SAS log for each request
   to a separate log file.  It also creates a "status" file (with the same
   ID number as the log file) that indicates whether or not the request ran
   successfully.
 
   This macro is useful for requests that run using the Stored Process
   Server, Workspace Server, IntrNet Application Server or SAS/CONNECT
   server.
 
   You can download the macro at:
 
     http://ftp.sas.com/techsup/download/inttech/STP_Capture_Log.zip
 
   The "Readme.txt" file contains instructions for using the macro.
 
   Example Usage
 
     %stp_capture_log(request=begin,
                      log_directory=c:\temp);
 
        /*  Beginnning of your existing code */
 
        %stpbegin;
 
          proc print data=sashelp.class;
          run;
 
        %stpend;
 
        /* End of your existing code */
 
     %stp_capture_log(request=end);

------------------------------------------------------------------------
*Product:* 	SAS Integration Technologies
*Component:* 	Stored Process Server
*Priority:* 	N/A
*Note Type:* 	Usage Issue
*Date:* 	Tue, 24 Jul 2007


      Operating System and Source Fix Information

*System* 	*Release Reported* 	*Release Fixed*
AIX/6000 	9.1.3    SP4 	 
Compaq Tru64 UNIX 	9.1.3    SP4 	 
HP-UX Operating Systems 	9.1.3    SP4 	 
HP-UX Itanium 	9.1.3    SP4 	 
Intel Itanium Processor Family(IPF) 	9.1.3    SP4 	 
Linux 	9.1.3    SP4 	 
Linux Itanium 	9.1.3    SP4 	 
Solaris 	9.1.3    SP4 	 
Solaris for x64 	9.1.3    SP4 	 
Windows 2000 Datacenter Server 	9.1.3    SP4 	 
Windows 2000 Professional 	9.1.3    SP4 	 
Windows Server 2000 family 	9.1.3    SP4 	 
Windows Server 2003 family 	9.1.3    SP4 	 
Windows XP 	9.1.3    SP4 	 
Windows XP Professional x64 	9.1.3    SP4 	 
Windows 64 bit 	9.1.3    SP4 	 

Unless otherwise stated above, no fixes are available for this issue.



------------------------------------------------------------------------
Search </search/index.html> | Contact Us </contact/intro.html> | Terms
of Use & Legal Information <http://corpprod.unx.sas.com/Copyright.html>
| Privacy Statement <http://corpprod.unx.sas.com/Privacy.html>
Copyright © 2007 SAS Institute Inc. All Rights Reserved.

