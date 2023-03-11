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

%let storeurl=storeUrl: %str(%')http://&_srvname:&_srvport&_url?_program=//Foundation/cmis/DataGridProvider2%nrstr(&dset=)&dset.%str(%') ;

data _null_ ;
  file _webout ;
  input ;
  line=resolve(_infile_) ;
  put line ;
cards4 ;
<html>
<head>
<title>Data Grid - Paging Example</title>
<link rel="stylesheet" type="text/css" href="/ext-3.2.1/resources/css/ext-all.css" />
<script src="/ext-3.2.1/adapter/ext/ext-base.js"></script>
<script src="/ext-3.2.1/ext-all.js"></script>
<script src="/ext-3.2.1/DynamicGridPanel.js"></script>
<script>
Ext.onReady(function(){
	new Ext.ux.DynamicGridPanel({
		id: 'simpletest2',
		&storeUrl,
		rowNumberer: true,
		renderTo: Ext.getBody(),
		checkboxSelModel: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		width: 600,
		height: 300
	});
});
</script>
</head>

<body>
</body>
</html>
;;;;
run ;

*';*";*/;run;
