Daily Tip 45 02/07/2003 11:43 PM

**Some ways to save space**

Here are a number of ways of saving space. This is not an exhaustive
list -- i.e. there are other ways.

> • Define an index, to avoid sorting (sorting often takes very large
> amounts of space)
>
> • Delete records not needed when they are read in
>
> • Delete temporary datasets when you are finished with them - Can use
> *proc datasets*, *proc delete* or operating system commands
>
> • Delete unused indexes
>
> • Don't use audit trails unless you need them
>
> • Only keep data in permanent libraries if it is needed later
>
> • Put data into 3rd-normal form
>
> • Put temporary datasets on RAM disk or some other form of memory
> based storage
>
> • Set length of SAS dates to 4
>
> • Sometimes use character variables to store numbers -- for instance
> if a number will only ever be 0 or 1 then that can be stored in a
> character of length 1, but a number (under windows) must be at least 3
> bytes long
>
> • Store data in required order to avoid sorting
>
> • Store large temporary files on tape, cartridge, Zip disk, CD, DVD,
> etc. -- rather than disk
>
> • Store numbers intelligently, using a length able to store the
> magnitude of the number sufficiently
>
> • Store SAS code in a central location rather than having local copies
> here, there and everywhere
>
> • Store short coded values in dataset and then decode using a format
> or indexed read of a key dataset
>
> • Use *\_null\_* dataset name when you want to run some data step code
> but don't need to create a data set
>
> • Use data step views in place of temporary datasets where possible
>
> • Use dataset compression, but beware compressing datasets with lots
> of numerics in SAS 6
>
> • Use FTP filename engine to access data on other machines, rather
> than making a local copy
>
> • Use *keep* & *drop* statements in data steps
>
> • Use *Keep=* & *Drop=* dataset options, on input and/or output
> datasets
>
> • Use length to shorten characters & numerics when possible -- can
> write a program to analyse a dataset and set lengths appropriately
> based on data values
>
> • Use on copy of data by defining libnames pointing to it on remote
> machines using Remote Library Services (requires SAS/Connect)
>
> • Use pipes to read zipped data without first unzipping it
>
> • Use SQL for *merge*, *summary*, *sort* & *print*, where you would
> otherwise need several Procs and a data step (thus reading the data
> several times)
>
> • Use SQL passthru to access data on other platforms, using that
> machines temporary work space
>
> • Use the *SASFILE* command to load datasets into memory
>
> • Use *where* statement
>
> • Use *WHERE=* dataset option to reduce data processed, on input
> and/or output datasets

by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
