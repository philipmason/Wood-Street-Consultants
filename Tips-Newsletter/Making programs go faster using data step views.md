Daily Tip 113 25/11/2004 10:37:00

**Making programs go faster using data step views**

The following technique shows how we can use a series of data step views
to defer processing till a later point in the program. The following is
what happens

> • Example 1 -- reads data to create A, reads data to create B, merges
> A & B to create C, concatenates C with SASHELP.CLASS to create D,
> creates SAVE_HERE from D.
>
> • Example 2 -- defines views to do most of what example 1 does, i.e.
> creating A, B, C & D. Then creates SAVE_HERE from the view D, which
> resolves D by carrying out the other data step views.

The advantage of example 2 is that all the reading/writing from/to disk
(except small view definitions) is done in the final data step -- this
reduces multiple reads/writes and save time. The result here was a 62%
saving in elapsed time.

**Note:** this technique works as well under SAS 8 as SAS 9.

**Example 1: Un-tuned, took 3.28 secs**

278 %let start=%sysfunc(time()) ;

279 data a ;

280 do i=1 to 100 ;

281 do j=1 to nobs ;

282 set sashelp.prdsale point=j nobs=nobs ;

283 output ;

284 end ;

285 end ;

286 stop ;

287 run ;

NOTE: The data set WORK.A has 144000 observations and 11 variables.

NOTE: DATA statement used (Total process time):

real time 0.21 seconds

cpu time 0.18 seconds

288 data b ;

289 do i=1 to 100 ;

290 do j=1 to nobs ;

291 set sashelp.prdsale point=j nobs=nobs ;

292 calc=actual\*10 ;

293 output ;

294 end ;

295 end ;

296 stop ;

297 run ;

NOTE: The data set WORK.B has 144000 observations and 12 variables.

NOTE: DATA statement used (Total process time):

real time 1.18 seconds

cpu time 0.18 seconds

298 data c ;

299 merge a b ;

300 run ;

NOTE: There were 144000 observations read from the data set WORK.A.

NOTE: There were 144000 observations read from the data set WORK.B.

NOTE: The data set WORK.C has 144000 observations and 12 variables.

NOTE: DATA statement used (Total process time):

real time 0.21 seconds

cpu time 0.21 seconds

301 data d ;

302 set c sashelp.class ;

303 run ;

NOTE: There were 144000 observations read from the data set WORK.C.

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: The data set WORK.D has 144019 observations and 17 variables.

NOTE: DATA statement used (Total process time):

real time 1.38 seconds

cpu time 0.10 seconds

304 data save_here ;

305 set d ;

306 run ;

NOTE: There were 144019 observations read from the data set WORK.D.

NOTE: The data set WORK.SAVE_HERE has 144019 observations and 17
variables.

NOTE: DATA statement used (Total process time):

real time 0.17 seconds

cpu time 0.14 seconds

307 %put time taken: %sysevalf(%sysfunc(time())-&start) ;

time taken: 3.28199999999924

**Example 2: Tuned, took 1.25 secs**

308 %let start=%sysfunc(time()) ;

309 data a **/view=a**;

310 do i=1 to 100 ;

311 do j=1 to nobs ;

312 set sashelp.prdsale point=j nobs=nobs ;

313 output ;

314 end ;

315 end ;

316 stop ;

317 run ;

NOTE: DATA STEP view saved on file WORK.A.

NOTE: A stored DATA STEP view cannot run under a different operating
system.

NOTE: DATA statement used (Total process time):

real time 0.00 seconds

cpu time 0.00 seconds

318 data b **/view=b** ;

319 do i=1 to 100 ;

320 do j=1 to nobs ;

321 set sashelp.prdsale point=j nobs=nobs ;

322 calc=actual\*10 ;

323 output ;

324 end ;

325 end ;

326 stop ;

327 run ;

NOTE: DATA STEP view saved on file WORK.B.

NOTE: A stored DATA STEP view cannot run under a different operating
system.

NOTE: DATA statement used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

328 data c **/view=c** ;

329 merge a b ;

330 run ;

NOTE: DATA STEP view saved on file WORK.C.

NOTE: A stored DATA STEP view cannot run under a different operating
system.

NOTE: View WORK.B.VIEW used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

NOTE: View WORK.A.VIEW used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

NOTE: DATA statement used (Total process time):

real time 0.03 seconds

cpu time 0.03 seconds

331 data d **/view=d** ;

332 set c sashelp.class ;

333 run ;

NOTE: DATA STEP view saved on file WORK.D.

NOTE: A stored DATA STEP view cannot run under a different operating
system.

NOTE: View WORK.C.VIEW used (Total process time):

real time 0.01 seconds

cpu time 0.01 seconds

NOTE: DATA statement used (Total process time):

real time 0.03 seconds

cpu time 0.03 seconds

334 data save_here ;

335 set d ;

336 run ;

NOTE: There were 144000 observations read from the data set WORK.A.

NOTE: There were 144000 observations read from the data set WORK.B.

NOTE: View WORK.D.VIEW used (Total process time):

real time 0.62 seconds

cpu time 0.64 seconds

NOTE: There were 144000 observations read from the data set WORK.C.

NOTE: There were 19 observations read from the data set SASHELP.CLASS.

NOTE: There were 144019 observations read from the data set WORK.D.

NOTE: The data set WORK.SAVE_HERE has 144019 observations and 17
variables.

NOTE: DATA statement used (Total process time):

real time 1.10 seconds

cpu time 0.67 seconds

337 %put time taken: %sysevalf(%sysfunc(time())-&start) ;

time taken: 1.25

*Examples tested under SAS 9.1.2, Windows XP* by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
