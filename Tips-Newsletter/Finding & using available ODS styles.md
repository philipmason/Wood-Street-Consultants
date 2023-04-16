Daily Tip 78 22/10/2003 11:31 PM

**Finding & using available ODS styles**

Here's one for ODS beginners. To use a style in ODS you specify the
style= option on the ODS statement. So the following would produce some
HTML output which uses the default style.

ods html file='test.html' style=default ;

Proc print data=sashelp.class ; run ;

ods html close ;

There are a range of other styles available which can be used by
specifying them under STYLE=. To get a list of those available in SAS
8.2 use the following program. Try each of them out to see what they
look like.

Apart from using PROC TEMPLATE, you can see available styles by right
clicking on RESULTS in the results window, and selecting TEMPLATES. You
can then navigate to SASHELP.TMPLMST.STYLES to see what's there. Also,
if you double click on one of the styles you will see the code used for
that style.

If you want even more styles then you will find the list for SAS 9.1
below.

Still want more? Well you could buy the new CD from SAS Books By Users
which is full of professionally designed styles. See here for details
[http://support.sas.com/publishing/bbu/companion_site/58824.html]{.underline}

***SAS Program***

proc template ;

list styles ;

run ;

***Output from SAS 8.2***

Listing of: SASUSER.TEMPLAT

Path Filter is: Styles

Sort by: PATH/ASCENDING

Obs Path Type

ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

1 Styles Dir

2 Styles.Newrtf Style

Listing of: SASHELP.TMPLMST

Path Filter is: Styles

Sort by: PATH/ASCENDING

Obs Path Type

ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

1 Styles Dir

2 Styles.BarrettsBlue Style

3 Styles.Beige Style

4 Styles.Brick Style

5 Styles.Brown Style

6 Styles.D3d Style

7 Styles.Default Style

8 Styles.Minimal Style

9 Styles.NoFontDefault Style

10 Styles.Printer Style

11 Styles.Rtf Style

12 Styles.Sasweb Style

13 Styles.Statdoc Style

14 Styles.Theme Style

15 Styles.fancyPrinter Style

16 Styles.sansPrinter Style

17 Styles.sasdocPrinter Style

18 Styles.serifPrinter Style

***Output from SAS 9.1***

Listing of: SASHELP.TMPLMST

Path Filter is: Styles

Sort by: PATH/ASCENDING

Obs Path Type

ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

1 Styles Dir

2 Styles.Analysis Style

3 Styles.Astronomy Style

4 Styles.Banker Style

5 Styles.BarrettsBlue Style

6 Styles.Beige Style

7 Styles.Brick Style

8 Styles.Brown Style

9 Styles.Curve Style

10 Styles.D3d Style

11 Styles.Default Style

12 Styles.Education Style

13 Styles.Electronics Style

14 Styles.Festival Style

15 Styles.Gears Style

16 Styles.Journal Style

17 Styles.Magnify Style

18 Styles.Meadow Style

19 Styles.Minimal Style

20 Styles.Money Style

21 Styles.NoFontDefault Style

22 Styles.Normal Style

23 Styles.Printer Style

24 Styles.Rsvp Style

25 Styles.Rtf Style

26 Styles.Sasweb Style

27 Styles.Science Style

28 Styles.Seaside Style

29 Styles.Sketch Style

30 Styles.Statdoc Style

31 Styles.Statistical Style

32 Styles.Theme Style

33 Styles.Torn Style

34 Styles.Watercolor Style

35 Styles.blockPrint Style

36 Styles.fancyPrinter Style

37 Styles.sansPrinter Style

38 Styles.sasdocPrinter Style

39 Styles.serifPrinter Style

Example tested under SAS 8.2 & 9.1, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}

Instant Messengers ... ICQ:27165944, AOL:philipamason, MSN:
philipandrewmason@hotmail.com, Yahoo: philipandrewmasonb
