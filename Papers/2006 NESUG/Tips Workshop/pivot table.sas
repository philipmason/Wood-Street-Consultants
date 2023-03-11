/* CREATE A PIVOT TABLE FROM SAS
A colleague and I were looking at the best way to automatically create a pivot table in EXCEL automatically from SAS. We considered solutions such as ODS with MSO XML directives, straight XML, DDE, and so on - but these were all very complex. He finally came up with the following simple method.
We use a SAS program to create a spreadsheet and then call a Visual Basic Script. The Visual Basic Script does the following:
- open the spreadsheet
- add a new sheet for pivot table
- create a pivot table using wizard
- set the fields to be used in the table
The SAS program could be extended to make a macro which creates the VBS file. This could then make it parameter driven to work for all data. */

* create EXCEL spreadsheet ;
proc export data=sashelp.class
  outfile="c:\workshop\hw06\class.xls"
  dbms=excel;
quit;

* call VB script to make the pivot table ;
data _null_;
  x 'c:\workshop\hw06\pivot.vbs';
run;
