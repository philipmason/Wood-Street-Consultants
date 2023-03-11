*ProcessBody;

%macro defaults ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dset)=0 %then %do;
		%global dset;
		%let dset=sashelp.class;
	%end;
%mend defaults;
%defaults

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
<html>
<head>
<title>Data Grid - Paging Example</title>
<link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css" />
<script src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
<script src="/ext-3.2.1/ext-all.js"></script>
</head>

<body>
<script type="text/javascript">
Ext.onReady(function(){

    // create the Data Store
    var store = new Ext.data.JsonStore({
        root: 'rows',
        totalProperty: 'totalCount',
        //idProperty: 'id',
        remoteSort: false,
;;;;
run;

data _null_;
	file _webout;
	dsid=open("&dset");
	nvars=attrn(dsid,'nvars');
	put 
		"fields: [" /
		"'id', " @
	;
	rc=fetch(dsid) ;
	do col=1 to nvars;
		vname=varname(dsid,col);
		put "'" vname +(-1) "'" @;
		if col ne nvars then put ', ' @;
			else put / "],";
	end;
	put '// Access data';
	put "url: 'http://&_srvname:&_srvport&_url?_program=//Foundation/cmis/DataGridProvider" '&dset=' "&dset.'";
run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
    });
//    store.setDefaultSort('Age','desc');

    var lineChart = new Ext.Window({
      title: 'CMIS',
      width: 400,
      height: 300,
      items: [
        new Ext.chart.LineChart({
          store: store,
          xField: 'date',
          yField: 'close',
;;;;
run;

data _null_;
	length type $ 1
         dslabel $ 64 ;
	file _webout;
	dsid=open("&dset");
	nvars=attrn(dsid,'nvars') ;
	dslabel=attrc(dsid,'label') ;
  if not missing(dslabel) then dslabel=strip(dslabel)||' ('||"&dset"||')' ;
  else dslabel="&dset" ;
	put 
      "title: '" dslabel +(-1) "'," /
		"// grid columns" /
		"columns:[{" /
		"id: 'id'," /
		'header: "id",' /
		"dataIndex: 'id'," /
		"sortable: true" /
		"},{"
	;
	rc=fetch(dsid) ;
	do col=1 to nvars;
		vname=varname(dsid,col) ;
		vlabel=coalescec(varlabel(dsid,col),vname) ;
		put 'header: "' vlabel +(-1) '",';
		put 'dataIndex: "' vname +(-1) '",';
		type=vartype(dsid,col);
		if type eq 'N' then do ;
      put "align: 'right', " ;
      if lowcase(vname) in ('actual','predict') then do ;
        put "renderer: function (value) {" /
            "  var color=""white"" ;" /
            "  var title="""" ;" /
            "if(value>800) color=""red"" ;" /
            "else if(value>600) color=""yellow"" ;" /
            "if(value>800) title=""title='Too High'"" ;" /
            "else if(value>600) title=""title='High'"" ;" ;
        put "  return '<p ' + title + 'style=""background-color: ' + color + " @ ;
        put "'"">' + value ;" /
            "}, ";
        end ;
      end ;
		put 'sortable: true';
		if col ne nvars then put '},{';
			else put '}],';
	end;
run;

data _null_ ;
  file _webout ;
  input ;
  put _infile_ ;
cards4 ;
    });

    // render it
    lineChart.render('row-chart');

    // trigger the data store load
    store.load() ;
});
</script>
<div id="row-chart"></div>
</body>
</html>
;;;;
run ;
%let _result=streamfragment ;
%STPBEGIN;
*';*";*/;run;
%STPEND;
