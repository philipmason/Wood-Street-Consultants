Daily Tip 116 09/12/2004 12:00:00

**Some ideas for speeding up programs**

Here are some ideas I put together recently for a client to help speed
up some SAS programs. I hope that they may also prove useful to you.
Some of these I may cover in more detail in future tips.

**Some pointers for tuning SAS jobs in general**

> • Always remember ... any tuning you do should be tested. You may
> think that making a particular change will certainly save you
> time/space but things don't always work the way you expect and should
> be measured.
>
> • Reduce disk I/O
>
> o The thing that usually slows programs down the most is I/O to the
> disk. Reducing this will generally save the most time.
>
> o Drop variables not required
>
> o Where possible use data step views to combine data step processing
> with sorts and other procedures.
>
> • Usually there is CPU capacity to spare, and so you can sometimes
> make tradeoffs by increasing CPU time to reduce I/O.
>
> o One typical application of this is to use the compress=yes option,
> which will turn on dataset compression for all files. This will
> increase CPU time overall a little, but will reduce space used and
> therefore the I/O done which will usually make programs complete
> quicker. If you run on a fast CPU, as we do, then this is usually
> worth doing.
>
> • Reduce contention
>
> o If reading from a large file/table and writing to another, then
> ideally the two files/tables should be on different disks, so that we
> reduce contention
>
> • Tune configuration file
>
> o Check memsize parameter, since the more memory we can give SAS the
> better it will perform
>
> o Check work library is on a large and fast disk
>
> • Piping output from one step to the next
>
> o Using SAS 9 MP Connect functionality we can pipe data from one step
> directly to the next. This can make very large time savings since data
> produced by one step is written to a pipe, and as it becomes available
> is read into the next step.
> [http://support.sas.com/rnd/scalability/tricks/]{.underline}
>
> • Turn data steps into views (where possible) to defer and combine
> I/O.
>
> o This is a general technique you can apply in different places and is
> best explained by an example
>
> ♣ In this example we assume our dataset is 1 gig in size. Before
> tuning, we read the data, write it, read it again and write it again
> -- doing 4 gig of I/O.

\* assuming that dataset is 1 gig in size, then this data step would
read in 1 gig and then write out 1 gig ;

Data test ;

Set something ;

X=y+1 ;

Run ;

\* this sort then reads in 1 gig and writes out 1 gig ;

Proc sort data=test out=test2 ;

By x y z ;

Run ;

\* In total we have done 4 gig of I/O, which takes some time ;

> ♣ After tuning, we define a view and then only read and write the data
> in the proc sort, saving 2 gig of I/O.

\* this data step only defines a view and does no significant I/O ;

Data test **/ view=test** ;

Set something ;

X=y+1 ;

Run ;

\* this sort then reads in 1 gig and writes out 1 gig ;

Proc sort data=test out=test2 ;

By x y z ;

Run ;

> o You can turn many data steps into views, including those have a
> fairly complex structure merging files or reading from external files
>
> o You can only create one view per data step.
>
> o You can chain together many steps, each being data step views so
> that you can combine the I/O in a single step
>
> • Sometimes you can split up data steps into two or more parts and
> process them concurrently using MP Connect, and then put the parts
> back together. This is useful where you have access to more than one
> processor concurrently.
>
> • You can check the values of SAS memory options using this code, and
> then potentially change them to tune the way that SAS uses memory

**proc** **options** group=memory ;

**run** ;

> • Tune sorts, in the following ways
>
> o Can use tagsort on very large sorts to just sort the keys and then
> assemble the sorted data. Can increase performance a lot.
>
> o Set sortsize parameter to use as much memory as possible, e.g.
> sortsize=max
>
> o If we have syncsort available, then this can be used instead of the
> SAS sort & is usually more efficient -- can set SORTPGM=BEST
>
> ♣ Use SORTANOM option to pass parms to the host sort program
>
> o Can use the SORTDEV option to put the sort work datasets onto
> another disk/directory, which may be faster or reduce contention
>
> o Use NOEQUALS options on PROC SORT, 99% of the time this is what is
> required
>
> o Reduce observations sorted with a WHERE dataset option on input
>
> o Can sometimes recode data step, summary & sort combinations as an
> SQL statement, which will carry out all the tasks in one operation --
> as well as doing self-optimisation
>
> • Use memory based libraries
>
> o There are options under windows, such as memlib/memcache for doing
> this -- but these are not yet available under UNIX
>
> • Use memory based datasets
>
> o You can use the SASFILE statement to put datasets into memory and
> use them as normal, from memory. If you have enough memory to fit the
> dataset and are doing a lot of calculations, then this can be a very
> efficient technique. e.g.

sasfile sashelp.prdsale open ;

**proc** **summary** data=sashelp.prdsale ;

class product country region ;

var actual predict ;

output out=temp sum= ;

**run** ;

sasfile sashelp.prdsale close ;

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
