Daily Tip 117 07/02/2005 06:52:00

**SAS vs. SPSS**

I have been looking at some of the features of SAS vs. SPSS, since we
have some SPSS users who may soon be moving over to SAS. I found a book
on the SPSS web site that can be downloaded (free) about the SPSS
programming syntax. There is a chapter that compares the syntax of SPSS
& SAS, that I have put here ...

**[www.woodstreet.org.uk/files/SPSS%20for%20SAS%20Programmers.pdf]{.underline}**

Here is an example of the material contained in it, which may be useful
if you wish to make a case to SPSS users for moving to SAS

***Reading Text Data***

Both SPSS and SAS can read a wide variety of text format data files.
This example

shows how the two applications read comma separated values (CSV) files.
A CSV file

uses commas to separate data values, and encloses values that include
commas in

quotation marks. Many applications export text data in this format.

Figure 10-11

*CSV text data file*

ID,Name,Gender,Date Hired,Department

1,\"Foster, Chantal\",f,10/29/1998,1

2,\"Healy, Jonathan\",m,3/1/1992,3

3,\"Walter, Wendy\",f,1/23/1995,2

Figure 10-12

*SPSS code for reading CSV text data*

\*delimited_csv.sps.

GET DATA /TYPE = TXT

/FILE = \'C:\\examples\\data\\CSV_file.csv\'

/DELIMITERS = \",\"

/QUALIFIER = \'\"\'

/ARRANGEMENT = DELIMITED

/FIRSTCASE = 2

/VARIABLES = ID F3 Name A15 Gender A1

Date_Hired ADATE10 Department F1.

Figure 10-13

*SAS code for reading CSV text data*

data csvnew;

infile \"c:\\examples\\data\\csv_file.csv\" DLM=\',\' Firstobs=2 DSD;

informat name \$char15. gender \$1. date_hired mmddyy10.;

input id name gender date_hired department;

run;

Wood Street Consultants Ltd. [tips@woodstreet.org.uk]{.underline}

[www.woodstreet.org.uk]{.underline}
