proc sql ;
	select ?construct an option tag? 
	into :options separated by ' '
	from sashelp.orsales ;
quit ;
data _null_ ;
	file _webout ;
	input ;
	line=?function to handle resolving macro references?(_infile_) ;
	put line ;
	cards4 ;
<html>
<body>
<h1>Pick a report to run</h1>
<form method="?one of two?" action="?first part of SAS Stored Process call?">
<input type="?text field but we want it invisible?" name="_program" value="?path to stored process?">
<select name="?macro variable we are passing in?">
&options
</select>
<input type="?type used to execute a form?" value="?text for button?">
</form>
</body>
</html>
;;;;
run ;