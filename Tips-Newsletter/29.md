Daily Tip 29 06/06/2003 2:36 PM

**PC Performance and the SAS System**

SAS Institute have a large collection of technical support documents
available on the web. The following is taken from one such document
which discusses how to get the best performance from SAS. It also covers
how to tune hardware and software, and can be found at
[http://ftp.sas.com/techsup/download/technote/ts684/ts684.html]{.underline}

Here are some programming methods that will make your code as efficient
as possible by reducing the I/O, keeping data in memory as much as
possible and reducing unnecessary data access.

> • Create SAS datasets instead of accessing flat files - datasets are
> accessed more efficiently
>
> • Use Version 8 datasets - the Version 8 engine is faster
>
> • Eliminate unnecessary passes through the data - multiple outputs per
> input, for example
>
> • Read and write only the variables needed - use drop and keep
>
> • Subset your data using If or Where statements
>
> • Use If-Then-Else structures instead of multiple If-Then structures
>
> • When using If statements, sorting the data values from most frequent
> occurring to the least frequently occurring can reduce execution time
>
> • Use Indexes - by retrieving a subset of the data, this requires
> fewer I/O operations
>
> • Use the In operator instead of the Or operator when subsetting with
> the Where statement
>
> • Use temporary arrays, if possible - retrieval times are shorter
>
> • Use the SASFile option, if appropriate - this keeps datasets in
> memory across step boundaries. SASFile automatically sets enough
> buffers to load the entire dataset if enough memory exists - otherwise
> the default bufno value is used.
>
> • When using indexes, the IdxName and Idxwhere datastep options allow
> a precise control of which indexes are used
>
> • Avoid using the tagsort option when running Proc Sort, if at all
> possible. Proc Sort requires approximately 4 times the dataset size in
> free disk space for the sort utility files. Tagsort reduces the amount
> of free disk space required but the CPU time needed is greatly
> increased.

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
