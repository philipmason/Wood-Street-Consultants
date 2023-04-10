Daily Tip 122 10/03/2005 16:48:00

**SAS Performance Monitor**

Windows XP has a Performance Monitor which is useful in providing
insight into what is happening with programs running and the operating
system. SAS supports this by providing some SAS specific counters, which
enable data about some SAS processing to be viewed in real-time, or
captured to a log for analysis later.

**How to view SAS Performance data**

> 1\. Start from "Control Panel", "Administrative Tasks", "Performance"
>
> 2\. Right click on graph and select "Add Counters"
>
> 3\. Under "Performance Object", select SAS
>
> 4\. Check "All counters", or select the ones you want
>
> 5\. Check "All instances", or select the ones you want
>
> 6\. Click on Add, then click on Close
>
> 7\. Maximise the Performance window, so you can see things better.
>
> 8\. Now as you run SAS programs you will see the corresponding stats &
> graph

You can also right click on the graph and select properties, from which
you can change a range of things including:

> • How often it updates the graph (e.g. every 5 seconds)
>
> • Style of lines on graph (color, width, line type)
>
> • You can also select a saved log file to examine

**How to save performance logs**

> 1\. Go to the Performance window
>
> 2\. Under "Performance logs and alerts" select "Counter Logs"
>
> 3\. right click in a blank part of the window, select "New log
> settings"
>
> 4\. Name your log whatever you want
>
> 5\. Choose an "Interval" and "Units" to define how often you want to
> sample data.
>
> 6\. Select "Add Counters" -- select the counters you want and click on
> Add for each one. Available counters are:
>
> a\. Disk ReadFile Bytes Read Total
>
> b\. Disk ReadFile Bytes Read/Sec
>
> c\. Disk SetFilePointer/Sec
>
> d\. Disk WriteFile Bytes Written Total
>
> e\. Disk WriteFile Bytes Written/Sec
>
> f\. Memlib/Memcache Current Usage
>
> g\. Memlib/Memcache Peak Usage
>
> h\. Virtual Alloc'ed Memory
>
> 7\. Under the "Log Files" tab, you can select the "Log file type". You
> may want a comma separated file, so you can load it into EXCEL or SAS
> for further processing
>
> 8\. Under the "Schedule" tab, you can define when to record the log,
> although you can start and stop the log manually also.
>
> 9\. Click on OK and your log definition is saved.
>
> a\. You can right click on the log definition and select "Start" to
> start it running. It will create a new file each time it starts
> running
>
> b\. If it's running you can right click and select "Stop" to stop it
> running.

Tested under SAS 9.1.2 & Windows XP Professional

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
