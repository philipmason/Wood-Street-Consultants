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
<input type="submit" value="Run">
</form>
<?tag for showing a web page on another web page? name="content" height="?specify in one of several ways?" width="?specify in one of several ways?">
</?tag for showing a web page on another web page?>
</body>
</html>
;;;;
run ;