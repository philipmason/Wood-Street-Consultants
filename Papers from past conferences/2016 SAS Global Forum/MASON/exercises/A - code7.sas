proc sql ;
	select distinct '<option value="'||strip(product_line)||'">'||strip(product_line)||'</option>' 
	into :options separated by ' '
	from sashelp.orsales ;
quit ;
data _null_ ;
	file _webout ;
	input ;
	line=resolve(_infile_) ;
	put line ;
	cards4 ;
<html>
<body>
<h1>Pick a report to run</h1>
<form method="get" action="http://d351tq92/SASStoredProcess/do?" target="content">
<input type="hidden" name="_program" value="/User Folders/phil/My Folder/test">
<select name="product_line">
&options
</select>
<select name="?stored process web app parameter you want to add?">
<option value="?value1?">?label for value1?</option>
<option value="?value2?">?label for value2?</option>
<option value="?value3?">?label for value3?</option>
?etc. etc.?
</select>
?you can use other tags like br, p or even table for laying things out?
<input type="submit" value="Run">
</form>
<iframe name="content" height="90%" width="100%">
</iframe>
</body>
</html>
;;;;
run ;