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
<form method="get" action="http://&_srvname:&_srvport/&_url?" target="content">
<input type="hidden" name="_program" value="/User Folders/phil/My Folder/test">
<select name="product_line">
&options
</select>
<select name="_odsdest">
<option value="html">html</option>
<option value="pdf">pdf</option>
<option value="csv">csv</option>
<option value="rtf">rtf</option>
</select>
<select name="_odsstyle">
<option value="meadow">meadow</option>
<option value="seaside">seaside</option>
<option value="statistical">statistical</option>
</select>
<br>
<input type="checkbox" name="_debug" value="log">Show log<nbsp>
<input type="checkbox" name="_debug" value="time">Show time taken
<br>
</select>
<input type="submit" value="Run">
</form>
<iframe name="content" height="90%" width="100%">
</iframe>
</body>
</html>
;;;;
run ;