*ProcessBody;

%macro x ;
	%* these defaults may be passed in, or else they default ;
	%if %symexist(dset)=0 %then %do;
		%global dset;
		%let dset=sashelp.class;
	%end;
	%if %symexist(height)=0 %then %do;
		%global height;
		%let height=280;
	%end;
	%if %symexist(pagesize)=0 %then %do;
		%global pagesize;
		%let pagesize=100;
	%end;
	%if %symexist(limit)=0 %then %do;
		%global limit;
		%let limit=100;
	%end;

  %if %lowcase(%scan(&dset,1,.))=cmis %then %do ;
    options sasautos=('/home/sasusers/masonp1/cmis/macros' sasautos) ;
    %allocate_db ;
    %var_to_macvar(cmis.where,kpi_number) ;
    %check_required ;
    %if &fail %then %do ;
      data _null_ ;
        file _webout ;
        put '<html><body><h1>Select a KPI first</h1>' ;
      run ;
      %return ;
      %end ;
    %end ;
%mend x ;
%x ;

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
  line=resolve(_infile_) ;
  put line ;
cards4 ;
    });
//    store.setDefaultSort('Age','desc');

    var grid = new Ext.grid.GridPanel({
        autoWidth: true,
        height:&height,
        store: store,
        trackMouseOver:false,
        disableSelection:true,
        stripeRows: true,
        loadMask: true,
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
/*		"width: 70," /*/
		"sortable: true" /
		"},{"
	;
	rc=fetch(dsid) ;
	do col=1 to nvars;
		vname=varname(dsid,col) ;
    if lowcase(vname) in ('_type_','_freq_') then continue ;
		vlabel=coalescec(varlabel(dsid,col),vname) ;
		put 'header: "' vlabel +(-1) '",';
		put 'dataIndex: "' vname +(-1) '",';
/*		put 'width: 100,';*/
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
/*            "  var color=(value>100)?""red"":""white"" ;" ;*/
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
  line=resolve(_infile_) ;
  put line ;
cards4 ;
       // paging bar on the bottom
       bbar: new Ext.PagingToolbar({
            pageSize: &pagesize,
            store: store,
            displayInfo: true,
            displayMsg: 'Displaying rows {0} - {1} of {2}',
            emptyMsg: "No data to display"
        })
    });

    // render it
    grid.render('row-grid');

    // trigger the data store load
    store.load({params:{start:0, limit:&limit}});
});
</script>
<div id="row-grid"></div>
</body>
</html>
;;;;
run ;

*';*";*/;run;
