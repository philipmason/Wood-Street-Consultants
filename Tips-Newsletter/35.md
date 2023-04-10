Daily Tip 35 17/06/2003 9:47 PM

**Creating datasets from Proc Tabulate**

In SAS 8 we can now create a dataset using Proc Tabulate, as well as
producing a tabular report. This is done by using ***out=**dataset-name*
on the *PROC TABULATE*. This can be useful since we can often write a
complex table statement to produce just the statistics we need
summarised in the way we want. One tabulate could do what might
otherwise require several Proc Means/Summary runs. Also in SAS 8 we have
extra statistics available to Proc Tabulate such as *median*.

See this for more information -
[http://v8doc.sas.com/sashtml/proc/zatestmt.htm]{.underline}

**SAS Program**

**proc** **tabulate** data=sashelp.prdsale **out=test** ;

class country region ;

var actual predict ;

table country all,

region\*(actual\*(sum mean) predict\*(min median max)) ;

**run** ;

**proc** **print** data=test ;

**run** ;

**SAS Output**

The SAS System 21:33 Tuesday, June 17, 2003 6

„ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ†

‚ ‚ Region ‚

‚ ‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ EAST ‚

‚ ‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ Actual Sales ‚ Predicted Sales ‚

‚
‡ƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ Sum ‚ Mean ‚ Min ‚ Median ‚ Max ‚

‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚Country ‚ ‚ ‚ ‚ ‚ ‚

‚CANADA ‚ 127485.00‚ 531.19‚ 0.00‚ 508.00‚ 986.00‚

‚GERMANY ‚ 124547.00‚ 518.95‚ 4.00‚ 499.00‚ 993.00‚

‚U.S.A. ‚ 118229.00‚ 492.62‚ 1.00‚ 494.50‚ 1000.00‚

‚All ‚ 370261.00‚ 514.25‚ 0.00‚ 503.00‚ 1000.00‚

Šƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒŒ

(Continued)

„ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ†

‚ ‚ Region ‚

‚ ‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ WEST ‚

‚ ‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ Actual Sales ‚ Predicted Sales ‚

‚
‡ƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒ...ƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚ ‚ Sum ‚ Mean ‚ Min ‚ Median ‚ Max ‚

‡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒˆƒƒƒƒƒƒƒƒƒƒƒƒ‰

‚Country ‚ ‚ ‚ ‚ ‚ ‚

‚CANADA ‚ 119505.00‚ 497.94‚ 6.00‚ 447.50‚ 1000.00‚

‚GERMANY ‚ 121451.00‚ 506.05‚ 0.00‚ 448.00‚ 981.00‚

‚U.S.A. ‚ 119120.00‚ 496.33‚ 22.00‚ 490.00‚ 999.00‚

‚All ‚ 360076.00‚ 500.11‚ 0.00‚ 457.00‚ 1000.00‚

Šƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒ‹ƒƒƒƒƒƒƒƒƒƒƒƒŒ

The SAS System 21:33 Tuesday, June 17, 2003 7

ACTUAL\_ ACTUAL\_ PREDICT\_ PREDICT\_ PREDICT\_

Obs COUNTRY REGION \_TYPE\_ \_PAGE\_ \_TABLE\_ Sum Mean Min Median Max

1 CANADA EAST 11 1 1 127485 531.188 0 508.0 986

2 CANADA WEST 11 1 1 119505 497.938 6 447.5 1000

3 GERMANY EAST 11 1 1 124547 518.946 4 499.0 993

4 GERMANY WEST 11 1 1 121451 506.046 0 448.0 981

5 U.S.A. EAST 11 1 1 118229 492.621 1 494.5 1000

6 U.S.A. WEST 11 1 1 119120 496.333 22 490.0 999

7 EAST 01 1 1 370261 514.251 0 503.0 1000

8 WEST 01 1 1 360076 500.106 0 457.0 1000

Example tested under SAS 8.2, Windows 2000 by Phil Mason

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
